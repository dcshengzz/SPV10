
import CloverFormControls from './controls';
import CloverStore from './store';
import ReactDOMServer from 'react-dom/server';

var PrintActions = {

  print: function (model, data, hiddenControls, id) {

    var onNothing = function () {
      return;
    }

    var items = CloverFormControls.createControls(this,
      {
        swzEventOnHide: onNothing(),
        swzEventOnShow: onNothing(),
        swzPageInPage: onNothing(),

        swzEventOnColumnAddBefore: onNothing(),
        swzEventOnColumnAddAfter: onNothing(),
        swzEventOnRowAddBefore: onNothing(),
        swzEventOnRowAddAfter: onNothing(),
        swzEventOnRowDelete: onNothing(),
        swzEventOnColumnDelete: onNothing(),
        swzEventOnMerge: onNothing(),
        swzEventOnSplit: onNothing(),

        model: model,
        data: data,
        buildermode: false,
        eventOnEdit: onNothing(),
        eventOnDelete: onNothing(),
        eventOnCopy: onNothing(),
        parentItem: undefined,
        handleEvent: onNothing(),
        getFormFunc: null,
        getFormFist: null,
        getAdditionalDataForControl: null,
        disableRefs: true,
        downloadUrl: null,
        uploadUrl: null,
        controlsToReplace: [],
        needCheckReplace: true,
        hideSideMenu: true,
        hideControls: hiddenControls
      }
    );

    const htmlString = ReactDOMServer.renderToStaticMarkup(
      items
    );
    PrintActions.printDiv(htmlString, id);
  },

  printDiv: function (html, id) {
    const printContent = '<div id="print-content" class="print-content">' + html + '</div>';

    const existing = document.querySelector(".print-content");
    if (existing) existing.parentNode.removeChild(existing);

    document.getElementById(id).insertAdjacentHTML('afterend', printContent);

    $(".radiotoslider").radioslider({ orientation: 'horizontal' });

    // Delay and force reflow
    setTimeout(() => {
      document.body.offsetHeight; // Force reflow
      window.print();

      // Delay cleanup
      setTimeout(() => {
        const node = document.getElementById("print-content");
        if (node) node.parentNode.removeChild(node);
      }, 2000);
    }, 500);
  },




  printForm: function (model, data, hiddenControls, id) {
    var onNothing = function () {
      return;
    }
    // 1. If data is missing/empty, generate a comprehensive mock object
    if (!data || Object.keys(data).length === 0) {
      data = this.generateFullMockData(model);
    }

    var items = CloverFormControls.createControls(this,
      {
        swzEventOnHide: onNothing(),
        swzEventOnShow: onNothing(),
        swzPageInPage: onNothing(),

        swzEventOnColumnAddBefore: onNothing(),
        swzEventOnColumnAddAfter: onNothing(),
        swzEventOnRowAddBefore: onNothing(),
        swzEventOnRowAddAfter: onNothing(),
        swzEventOnRowDelete: onNothing(),
        swzEventOnColumnDelete: onNothing(),
        swzEventOnMerge: onNothing(),
        swzEventOnSplit: onNothing(),

        model: model,
        data: data,
        buildermode: false,
        eventOnEdit: onNothing(),
        eventOnDelete: onNothing(),
        eventOnCopy: onNothing(),
        parentItem: undefined,
        handleEvent: onNothing(),
        getFormFunc: null,
        getFormFist: null,
        getAdditionalDataForControl: null,
        disableRefs: true,
        downloadUrl: null,
        uploadUrl: null,
        controlsToReplace: [],
        needCheckReplace: true,
        hideSideMenu: true,
        hideControls: hiddenControls,
        printMode: true
      }
    );

    let htmlString = ReactDOMServer.renderToStaticMarkup(
      items
    );

    // 2. DYNAMIC HOOK INJECTION
    // We manually insert [[KEY:test11]] etc. into the attributes of the HTML string 
    // because React ignores them for checkboxes/radios.
    const addHooks = (html, items) => {
      if (!items || !Array.isArray(items)) return html;
      items.forEach(item => {
        const key = item.key || item.name;
        const type = item["data-buildertype"];

        if (key) {
          let mapping = "";
          if (item["data-elements"] && Array.isArray(item["data-elements"])) {
            const mapStr = item["data-elements"].map(el => `${el.value}:${el.text}`).join(',');
            if (mapStr) mapping = `|${mapStr}`;
          }

          if (type === "checkbox" || type === "radiogroup" || type === "radiotoslider") {
            // Find the input tag for this key and inject a merge-hook attribute
            const search = new RegExp(`name="${key}"`, 'g');
            html = html.replace(search, `name="${key}" data-placeholder="[[KEY:${key}${mapping}]]"`);
          } else if (type === "dropdown") {
            // Dropdowns don't have a simple name attribute.
            // Search for the div representing the dropdown and inject data-placeholder
            const search = new RegExp(`name="${key}"([^>]*?class=")`, 'g');
            const prefix = item.multiple ? "MULTI_KEY" : "KEY";
            html = html.replace(search, `name="${key}" data-placeholder="[[${prefix}:${key}${mapping}]]"$1`);
          } else if (type === "input" && item.type === "number") {
            const search = new RegExp(`name="${key}"`, 'g');
            html = html.replace(search, `name="${key}" data-placeholder="[[KEY:${key}${mapping}]]"`);
          }
        }

        if (item.children) html = addHooks(html, item.children);
        if (item.columns) html = addHooks(html, item.columns);
        if (item.rows) html = addHooks(html, item.rows);
      });
      return html;
    };

    htmlString = addHooks(htmlString, model);
    return new Promise((resolve, reject) => {
      PrintActions.printFormDiv(htmlString, id)
        .then(printedContent => {
          resolve(printedContent); // Resolve with the printed content
        })
        .catch(error => {
          console.error("Error printing form:", error);
          reject(error); // Reject if there's an error
        });
    });
  },

  generateFullMockData: function (model) {
    let mock = {
      RespId: "[[KEY:RespId]]",
      LastSavedPage: "[[KEY:LastSavedPage]]"
    };

    const processItems = (items) => {
      if (!items || !Array.isArray(items)) return;

      items.forEach(item => {
        const builderType = item["data-buildertype"];
        const key = item.key || item.name;

        if (key) {
          let mapping = "";
          if (item["data-elements"] && Array.isArray(item["data-elements"])) {
            const mapStr = item["data-elements"].map(el => `${el.value}:${el.text}`).join(',');
            if (mapStr) mapping = `|${mapStr}`;
          }

          switch (builderType) {
            case "dropdown":
              if (item.multiple) {
                // We provide an array with our token. 
                // This forces Semantic UI to render the <a> labels.
                mock[key] = ["[[MULTI_KEY:" + key + mapping + "]]"];
              } else {
                // For single select, we provide the token.
                mock[key] = "[[KEY:" + key + mapping + "]]";
              }
              break;

            case "checkbox":
            case "toggle":
              // Default to unchecked
              mock[key] = "";
              break;

            case "radiogroup":
            case "radiotoslider":
              // Default to unchecked
              mock[key] = "";
              break;

            case "input":
            case "textarea":
              if (item.type === "number") {
                mock[key] = "";
              } else {
                mock[key] = `[[KEY:${key}]]`;
              }
              break;

            default:
              mock[key] = `[[KEY:${key}]]`;
          }
        }
        if (item.children) processItems(item.children);
        if (item.columns) processItems(item.columns);
        if (item.rows) processItems(item.rows);
      });
    };

    processItems(model);
    return mock;
  },
  printFormDiv: function (html, id) {
    return new Promise((resolve, reject) => {
      var printContent = '<div id="pdf-print-content" class="pdf-print-content">' + html + '</div>';

      // Create a temporary div element
      var tempDiv = document.createElement('div');

      // Append printContent to the temporary div
      tempDiv.innerHTML = printContent;

      /*
      // Get all page containers within the temporary div
      var pageContainers = tempDiv.querySelectorAll('.clover-formbuilder-item-swzpagemain');

      // Loop through each page container
      pageContainers.forEach(function(container) {
          // Wait for the content to be fully rendered
          requestAnimationFrame(function() {
            // Calculate the width and height of the content within the container
            var contentWidth = container.scrollWidth;
            var contentHeight = container.scrollHeight;

            // Set the page size dynamically based on the content dimensions of this container
            var style = document.createElement('style');
            style.textContent = `
                /* Apply styles to the container itself */
      /*.clover-formbuilder-item-swzpagemain {
          width: ${contentWidth}px;
          height: ${contentHeight}px;
      } */

      /* Apply styles to @page */
      /*@page {
          size: ${contentWidth}px ${contentHeight}px !important;
      }
  `;
  container.appendChild(style);
});
});
*/
      function fetchImageAsBase64(url) {
        return fetch(url)
          .then(response => {
            if (!response.ok) {
              throw new Error('Failed to fetch image');
            }
            return response.blob();
          })
          .then(blob => {
            return new Promise(function (resolve, reject) {
              var reader = new FileReader();
              reader.readAsDataURL(blob);
              reader.onloadend = function () {
                var base64Data = reader.result.split(',')[1]; // Extracting base64 data from the result
                resolve(base64Data);
              };
              reader.onerror = reject;
            });
          });
      }

      // Find all image elements in the HTML
      var images = tempDiv.innerHTML.match(/<img[^>]+>/g);

      // Iterate over each image found
      if (images) {
        Promise.all(images.map(function (img) {
          return new Promise(function (resolve, reject) {
            var srcMatch = img.match(/src=["']([^"']+)["']/);
            if (srcMatch && srcMatch[1]) {
              var imageUrl = srcMatch[1];
              fetchImageAsBase64(imageUrl)
                .then(function (base64Image) {
                  // Replace the image URL with base64 data
                  tempDiv.innerHTML = tempDiv.innerHTML.replace(imageUrl, "data:image/jpeg;base64," + base64Image);
                  resolve();
                })
                .catch(reject);
            } else {
              resolve();
            }
          });
        }))
          .then(function () {
            var insertedContent = document.querySelector(".pdf-print-content");
            if (insertedContent)
              insertedContent.parentNode.removeChild(insertedContent);

            document.getElementById(id).insertAdjacentHTML('afterend', tempDiv.innerHTML);
            $(".radiotoslider").radioslider({
              orientation: 'horizontal'
            });

            var htmlStringPDF = tempDiv.innerHTML;
            var node = document.getElementById("pdf-print-content");
            node.parentNode.removeChild(node);
            resolve(htmlStringPDF);
          })
          .catch(function (error) {
            console.error('Error processing images:', error);
            reject(error);
          });
      }
      else {
        var insertedContent = document.querySelector(".pdf-print-content");
        if (insertedContent)
          insertedContent.parentNode.removeChild(insertedContent);

        document.getElementById(id).insertAdjacentHTML('afterend', tempDiv.innerHTML);
        $(".radiotoslider").radioslider({
          orientation: 'horizontal'
        });
        var htmlStringPDF = tempDiv.innerHTML;
        var node = document.getElementById("pdf-print-content");
        node.parentNode.removeChild(node);
        resolve(htmlStringPDF);

      }
    });

  }
};
module.exports = PrintActions;