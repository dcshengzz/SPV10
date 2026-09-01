using System.Threading.Tasks;
using System.IO;
using System.Collections.Generic;
using System.Collections.Concurrent;
using PdfSharp.Pdf.IO;
using HtmlAgilityPack;
using swz.SurveyPlus.Application;
using System;
using Winnovative;
using swz.Clover.Core;
using Newtonsoft.Json;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using swz.Clover.Core.Metadata.DbObjects;

namespace swz.SurveyPlus.IntranetApplication
{

    public class SurveyPrinting
    {
        private const RegexOptions StandardOptions = RegexOptions.Singleline;

        private static string _cachedCssContent;
        private static readonly object _cssLock = new object();

        private static readonly ConcurrentDictionary<string, (string html, DateTime expiry)> _templateCache
            = new ConcurrentDictionary<string, (string, DateTime)>();
        private static readonly TimeSpan TemplateCacheTtl = TimeSpan.FromMinutes(10);

        private static string GetCssContent()
        {
            if (_cachedCssContent != null) return _cachedCssContent;

            lock (_cssLock)
            {
                if (_cachedCssContent != null) return _cachedCssContent;

                string cssFilePath = "wwwroot\\css\\swz-pdfexport.css";
                if (!File.Exists(cssFilePath))
                {
                    throw new FileNotFoundException("PDF export CSS file not found.", cssFilePath);
                }
                _cachedCssContent = File.ReadAllText(cssFilePath);
                return _cachedCssContent;
            }
        }

        private static async Task<string> GetTemplateAsync(string formName)
        {
            string cacheKey = formName;
            if (_templateCache.TryGetValue(cacheKey, out var cached) && DateTime.UtcNow < cached.expiry)
            {
                return cached.html;
            }

            Filter filter = Filter.And.Equal(formName + "-pdftemplate.html", Constants.FieldName.Filename).Equal("metadata/forms", "Folder");
            List<Metadata> metadataItems = await swz.Clover.Core.Metadata.DbObjects.Metadata.SelectAsync(filter);
            Metadata item = System.Linq.Enumerable.FirstOrDefault(metadataItems);
            if (item == null)
            {
                throw new NotFoundException($"PDF template not found for form '{formName}'.");
            }

            _templateCache[cacheKey] = (item.Data, DateTime.UtcNow.Add(TemplateCacheTtl));
            return item.Data;
        }

        public static async Task<Stream> WinnovativeGeneratePdf(string formName, string responseData)
        {
            if (string.IsNullOrWhiteSpace(formName))
            {
                throw new ArgumentException("Form name cannot be null or empty.", nameof(formName));
            }

            string cssContent = GetCssContent();
            string htmlContentFromForm = await GetTemplateAsync(formName);

            if (!string.IsNullOrEmpty(responseData))
            {
                Dictionary<string, object> dataDict = JsonConvert.DeserializeObject<Dictionary<string, object>>(responseData);
                htmlContentFromForm = MergeDataToHtml(htmlContentFromForm, dataDict);
            }

            htmlContentFromForm = FlattenRadioSlidersForPdf(htmlContentFromForm);

            List<string> pagesHtml = ExtractHtmlPages(htmlContentFromForm);

            string htmlPrefix = $@"<!DOCTYPE html>
<html>
<head><style>{cssContent}</style></head>
<body>";

            MemoryStream[] pdfResults = new MemoryStream[pagesHtml.Count];

            try
            {
                Parallel.For(0, pagesHtml.Count, new ParallelOptions
                {
                    MaxDegreeOfParallelism = Math.Min(4, Environment.ProcessorCount)
                }, i =>
                {
                    string htmlWithCss = htmlPrefix + pagesHtml[i] + "</body></html>";

                    PdfConverter converter = HtmlToPdfStream.NewConverterInstance();
                    converter.PdfDocumentOptions.FitHeight = false;
                    converter.PdfDocumentOptions.FitWidth = false;
                    converter.PdfDocumentOptions.AutoSizePdfPage = true;
                    converter.PdfDocumentOptions.AvoidImageBreak = true;
                    converter.PdfDocumentOptions.AvoidTextBreak = true;
                    converter.PdfDocumentOptions.SinglePage = true;

                    MemoryStream pdfStream = new MemoryStream();
                    converter.SavePdfFromHtmlStringToStream(htmlWithCss, pdfStream);
                    pdfStream.Seek(0, SeekOrigin.Begin);
                    pdfResults[i] = pdfStream;
                });

                Stream combinePDFStream = CombinePdfsAndReturnStream(pdfResults);
                combinePDFStream.Position = 0;
                return combinePDFStream;
            }
            finally
            {
                foreach (MemoryStream s in pdfResults)
                {
                    s?.Dispose();
                }
            }
        }

        public static string MergeDataToHtml(string html, Dictionary<string, object> data)
        {
            if (string.IsNullOrEmpty(html) || data == null) return html;

            Dictionary<string, string> lookup = new Dictionary<string, string>(data.Count, StringComparer.Ordinal);
            foreach (KeyValuePair<string, object> entry in data)
            {
                if (entry.Key == "prePopulatedFields" || entry.Key == "validation") continue;
                lookup[entry.Key] = entry.Value?.ToString() ?? "";
            }

            // Single pass: replace all [[KEY:xxx]] and [[MULTI_KEY:xxx|mapping]] placeholders
            html = Regex.Replace(html, @"\[\[(?:KEY|MULTI_KEY):([^\|\]]+)(?:\|([^\]]+))?\]\]", m =>
            {
                string key = m.Groups[1].Value;
                if (!lookup.TryGetValue(key, out string rawValue)) return m.Value;
                string mappingStr = m.Groups[2].Value;
                if (string.IsNullOrEmpty(mappingStr)) return HttpUtility.HtmlEncode(rawValue);
                Dictionary<string, string> mapping = ParseMappingString(mappingStr);
                string[] ids = ParseJsonLikeArray(rawValue);
                return HttpUtility.HtmlEncode(string.Join(", ", ids.Select(id => mapping.ContainsKey(id) ? mapping[id] : id)));
            }, StandardOptions);

            // Single pass: update all <input> tag values and checked states by name
            html = Regex.Replace(html, @"<input\b[^>]*?>", m =>
            {
                string tag = m.Value;
                Match nameMatch = Regex.Match(tag, @"name=""([^""]+)""");
                if (!nameMatch.Success) return tag;
                string name = nameMatch.Groups[1].Value;
                if (!lookup.TryGetValue(name, out string rawValue)) return tag;

                if (tag.Contains(@"type=""radio"""))
                {
                    Match valMatch = Regex.Match(tag, @"value=""([^""]*)""");
                    bool matchesValue = valMatch.Success && valMatch.Groups[1].Value == rawValue;
                    return matchesValue ? InjectAttribute(tag, "checked", "") : StripAttribute(tag, "checked");
                }

                if (tag.Contains(@"type=""hidden""")) return tag;

                if (tag.Contains(@"class=""hidden"""))
                {
                    bool isChecked = rawValue == "1" || rawValue.Equals("true", StringComparison.OrdinalIgnoreCase);
                    return isChecked ? InjectAttribute(tag, "checked", "") : StripAttribute(tag, "checked");
                }

                string encodedVal = HttpUtility.HtmlEncode(rawValue);
                return Regex.Replace(tag, @"value=""[^""]*""", $@"value=""{encodedVal}""");
            }, StandardOptions);

            // Single pass: update checkbox container CSS classes
            html = Regex.Replace(html,
                @"class=""ui\s+(checked\s+)?(toggle\s+)?checkbox""><input\s+class=""hidden""\s+name=""([^""]+)""",
                m =>
                {
                    string name = m.Groups[3].Value;
                    if (!lookup.TryGetValue(name, out string rawValue)) return m.Value;
                    bool isChecked = rawValue == "1" || rawValue.Equals("true", StringComparison.OrdinalIgnoreCase);
                    string toggle = m.Groups[2].Success ? "toggle " : "";
                    string checkedStr = isChecked ? "checked " : "";
                    return $@"class=""ui {checkedStr}{toggle}checkbox""><input class=""hidden"" name=""{name}""";
                }, StandardOptions);

            if (html.Contains("dropdown"))
            {
                html = ProcessAllDropdowns(html, lookup);
            }

            return html;
        }

        private static string ProcessAllDropdowns(string html, Dictionary<string, string> lookup)
        {
            // Multi-select: name before class
            html = Regex.Replace(html,
                @"<div[^>]*?name=""([^""]+)""[^>]*?class=""[^""]*multiple[^""]*dropdown""[^>]*?>(?<inner>.*?)<i[^>]*?class=""dropdown icon""",
                m =>
                {
                    if (!lookup.TryGetValue(m.Groups[1].Value, out string rawValue)) return m.Value;
                    return ReplaceMultiSelect(m, rawValue);
                }, StandardOptions);

            // Multi-select: class before name
            html = Regex.Replace(html,
                @"<div[^>]*?class=""[^""]*multiple[^""]*dropdown""[^>]*?name=""([^""]+)""[^>]*?>(?<inner>.*?)<i[^>]*?class=""dropdown icon""",
                m =>
                {
                    if (!lookup.TryGetValue(m.Groups[1].Value, out string rawValue)) return m.Value;
                    return ReplaceMultiSelect(m, rawValue);
                }, StandardOptions);

            // Single-select: name before class
            html = Regex.Replace(html,
                @"<div[^>]*?name=""([^""]+)""[^>]*?class=""(?![^""]*multiple)[^""]*selection[^""]*dropdown""[^>]*?>(?<inner>.*?)<i[^>]*?class=""dropdown icon""",
                m =>
                {
                    if (!lookup.TryGetValue(m.Groups[1].Value, out string rawValue)) return m.Value;
                    return ReplaceSingleSelect(m, rawValue);
                }, StandardOptions);

            // Single-select: class before name
            html = Regex.Replace(html,
                @"<div[^>]*?class=""(?![^""]*multiple)[^""]*selection[^""]*dropdown""[^>]*?name=""([^""]+)""[^>]*?>(?<inner>.*?)<i[^>]*?class=""dropdown icon""",
                m =>
                {
                    if (!lookup.TryGetValue(m.Groups[1].Value, out string rawValue)) return m.Value;
                    return ReplaceSingleSelect(m, rawValue);
                }, StandardOptions);

            return html;
        }

        private static string ReplaceMultiSelect(Match m, string value)
        {
            Dictionary<string, string> mapping = ParseMappingFromTag(m.Value);
            string[] ids = ParseJsonLikeArray(value);
            StringBuilder labelsHtml = new StringBuilder();

            foreach (string id in ids)
            {
                string displayLabel = mapping.ContainsKey(id) ? mapping[id] : LookupLabelInHtml(m.Value, id);
                labelsHtml.Append($@"<a class=""ui label"" style=""font-weight:normal"" value=""{HttpUtility.HtmlAttributeEncode(id)}"">{HttpUtility.HtmlEncode(displayLabel)}<span aria-hidden=""true"" style=""font-size:0.9em;margin-left:4px;cursor:pointer;opacity:0.7"">&#x2715;</span></a>");
            }

            string fullMatch = m.Value;
            int tagEnd = fullMatch.IndexOf(">") + 1;
            int iconStart = fullMatch.LastIndexOf("<i");
            return fullMatch.Substring(0, tagEnd) + labelsHtml.ToString() + fullMatch.Substring(iconStart);
        }

        private static string ReplaceSingleSelect(Match m, string value)
        {
            string openingTag = m.Value.Substring(0, m.Value.IndexOf(">") + 1);
            string inner = m.Groups["inner"].Value;

            Dictionary<string, string> mapping = ParseMappingFromTag(openingTag);
            string displayLabel = mapping.ContainsKey(value) ? mapping[value] : value;
            string encodedLabel = HttpUtility.HtmlEncode(displayLabel);

            inner = Regex.Replace(inner, @"<div[^>]*?class=""[^""]*text[^""]*""[^>]*?>.*?</div>", "", StandardOptions);
            if (inner.Contains("class=\"search\""))
            {
                inner = Regex.Replace(inner, @"(value="")([^""]*)("")", $"$1{encodedLabel}$3");
            }

            return $@"{openingTag}<div class=""text"">{encodedLabel}</div>{inner}<i aria-hidden=""true"" class=""dropdown icon""";
        }

        private static string FlattenRadioSlidersForPdf(string html)
        {
            HtmlDocument doc = new HtmlDocument();
            doc.OptionOutputOriginalCase = true;
            doc.LoadHtml(html);

            HtmlNodeCollection sliders = doc.DocumentNode.SelectNodes("//div[contains(@class, 'radiotoslider')]");
            if (sliders == null) return html;

            foreach (HtmlNode slider in sliders.ToList())
            {
                HtmlNodeCollection itemNodes = slider.SelectNodes(".//div[contains(@class, 'radioslider__item')]");
                if (itemNodes == null || itemNodes.Count == 0) continue;

                List<(string text, bool isChecked)> items = new List<(string text, bool isChecked)>();
                foreach (var itemNode in itemNodes)
                {
                    HtmlNode input = itemNode.SelectSingleNode(".//input[contains(@class, 'radioslider__input')]");
                    HtmlNode textSpan = itemNode.SelectSingleNode(".//span[contains(@class, 'radioslider__text')]");
                    items.Add((textSpan?.InnerText?.Trim() ?? "", input?.Attributes["checked"] != null));
                }

                HtmlNode tableNode = HtmlNode.CreateNode(BuildSliderTable(items));
                slider.ParentNode.ReplaceChild(tableNode, slider);
            }

            return doc.DocumentNode.OuterHtml;
        }

        private static string BuildSliderTable(List<(string text, bool isChecked)> items)
        {
            int count = items.Count;
            int selectedIndex = items.FindIndex(i => i.isChecked);

            StringBuilder sb = new StringBuilder();
            sb.Append(@"<table cellpadding=""0"" cellspacing=""0"" style=""width:100%;border-collapse:separate;border-spacing:0;margin:0.5em 0;"">");

            sb.Append("<tr>");
            for (int i = 0; i < count; i++)
            {
                bool isFilled = selectedIndex >= 0 && i <= selectedIndex;
                string bgColor = isFilled ? "#3377ff" : "#d9d9d9";

                string borderRadius = "";
                if (i == 0) borderRadius += "border-top-left-radius:99em;border-bottom-left-radius:99em;";
                if (i == count - 1) borderRadius += "border-top-right-radius:99em;border-bottom-right-radius:99em;";

                string dotStyle = i == selectedIndex
                    ? "display:inline-block;width:2em;height:2em;background-color:white;border-radius:50%;border:3px solid #3377ff;vertical-align:middle;"
                    : "display:inline-block;width:1.5em;height:1.5em;background-color:white;border-radius:50%;vertical-align:middle;";

                sb.Append($@"<td style=""background-color:{bgColor};height:2em;{borderRadius}text-align:center;vertical-align:middle;padding:0.25em 0;"">");
                sb.Append($@"<span style=""{dotStyle}""></span>");
                sb.Append("</td>");
            }
            sb.Append("</tr>");

            sb.Append("<tr>");
            for (int i = 0; i < count; i++)
            {
                string fontWeight = i == selectedIndex ? "font-weight:bold;" : "";
                sb.Append($@"<td style=""text-align:center;padding-top:4px;font-size:0.9em;{fontWeight}"">{HttpUtility.HtmlEncode(items[i].text)}</td>");
            }
            sb.Append("</tr>");

            sb.Append("</table>");
            return sb.ToString();
        }

        // --- Helpers ---

        private static Dictionary<string, string> ParseMappingFromTag(string tag)
        {
            Match match = Regex.Match(tag, @"data-placeholder=""\[\[(?:KEY|MULTI_KEY):[^\|]+\|([^\]]+)\]\]""");
            return match.Success ? ParseMappingString(match.Groups[1].Value) : new Dictionary<string, string>();
        }

        private static Dictionary<string, string> ParseMappingString(string mapStr)
        {
            Dictionary<string, string> result = new Dictionary<string, string>();
            string[] pairs = mapStr.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            foreach (string pair in pairs)
            {
                int colonIndex = pair.IndexOf(':');
                if (colonIndex <= 0) continue;
                string id = pair.Substring(0, colonIndex).Trim();
                string label = pair.Substring(colonIndex + 1).Trim();
                if (!string.IsNullOrEmpty(id))
                {
                    result[id] = label;
                }
            }
            return result;
        }

        private static string[] ParseJsonLikeArray(string val)
        {
            return val.Split(new[] { '[', ']', '"', ',', ' ', '\r', '\n' }, StringSplitOptions.RemoveEmptyEntries)
                      .Select(s => s.Trim())
                      .Where(s => !string.IsNullOrEmpty(s))
                      .ToArray();
        }

        private static string LookupLabelInHtml(string containerHtml, string id)
        {
            string lookupPattern = $@"data-value=""{Regex.Escape(id)}""[^>]*?><span[^>]*?class=""text""[^>]*?>(?<t>.*?)<\/span>";
            Match match = Regex.Match(containerHtml, lookupPattern, StandardOptions);
            return match.Success ? match.Groups["t"].Value : id;
        }

        private static string InjectAttribute(string tag, string attr, string value)
        {
            if (tag.Contains(attr)) return tag;
            return tag.TrimEnd('>').TrimEnd('/') + $" {attr}=\"{value}\">";
        }

        private static string StripAttribute(string tag, string attr)
        {
            return Regex.Replace(tag, $@"\s{attr}(=[""']?.*?[""']?)?", "");
        }


        public static Stream CombinePdfsAndReturnStream(IEnumerable<Stream> pdfStreams)
        {
            using (PdfSharp.Pdf.PdfDocument outputDocument = new PdfSharp.Pdf.PdfDocument())
            {
                foreach (Stream pdfStream in pdfStreams)
                {
                    using (PdfSharp.Pdf.PdfDocument inputDocument = PdfSharp.Pdf.IO.PdfReader.Open(pdfStream, PdfDocumentOpenMode.Import))
                    {
                        for (int i = 0; i < inputDocument.PageCount; i++)
                        {
                            PdfSharp.Pdf.PdfPage page = inputDocument.Pages[i];
                            outputDocument.AddPage(page);
                        }
                    }
                }

                MemoryStream memoryStream = new MemoryStream();
                outputDocument.Save(memoryStream, false);

                memoryStream.Position = 0;

                return memoryStream;
            }
        }

        public class PageDimension
        {
            public string Id { get; set; }
            public double Width { get; set; }
            public double Height { get; set; }
        }

        public static List<string> ExtractHtmlPages(string htmlContent)
        {
            List<string> pagesHtml = new List<string>();

            try
            {
                HtmlDocument doc = new HtmlDocument();
                doc.LoadHtml(htmlContent);
                HtmlNodeCollection nodes = doc.DocumentNode.SelectNodes("//div[@class='clover-formbuilder-item-swzpagemain']");

                if (nodes != null)
                {
                    foreach (HtmlNode node in nodes)
                    {
                        string pageHtml = node.OuterHtml;
                        HtmlNode nextNode = node.NextSibling;

                        while (nextNode != null && nextNode.Name != "div")
                        {
                            pageHtml += nextNode.OuterHtml;
                            nextNode = nextNode.NextSibling;
                        }

                        pagesHtml.Add(pageHtml);
                    }
                }

            }
            catch (Exception extractHTMLPages)
            {
                throw new InternalException($"Error occurred while extracting and splitting HTML content.", extractHTMLPages);
            }

            return pagesHtml;
        }
    }
}