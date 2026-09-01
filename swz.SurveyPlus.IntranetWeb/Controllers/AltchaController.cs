using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Configuration;
using System.Text;
using System.Security.Cryptography;
using Ixnas.AltchaNet;
using System.Linq;
namespace swz.SurveyPlus.IntranetWeb.Controllers
{
    public class AltchaController : Controller
    {
        private readonly IConfiguration _configuration;
        private readonly ILogger<AltchaController> _logger;

        public AltchaController(IConfiguration configuration, ILogger<AltchaController> logger)
        {
            _configuration = configuration;
            _logger = logger;
        }

        [HttpGet("/api/altcha/challenge")]
        public IActionResult GetAltchaChallenge()
        {
            const int maxNumber = 100000; 
            string hmacKey = "lXSp5P0GvfUtg6OfXSimEVkcPQkzMhIuWSYau77iY/P7HgUn0MtGS7ou5EqxcZR7";
            string salt = GenerateSalt(16); 

            int secretNumber = RandomNumber(maxNumber);

            string challengeInput = salt + secretNumber.ToString();

            string challengeHash = ComputeSha256Hex(challengeInput);

            string signature = ComputeHmacSha256Hex(challengeHash, hmacKey);

            // Return Altcha challenge response
            return Ok(new
            {
                algorithm = "SHA-256",
                challenge = challengeHash,
                maxnumber = maxNumber,
                salt = salt,
                signature = signature
            });
        }



        [HttpPost("/api/verify-captcha")]
        public IActionResult VerifyCaptcha([FromBody] AltchaVerificationRequest request)
        {
            if (string.IsNullOrEmpty(request?.Response))
                return BadRequest(new { valid = false, error = "Missing response" });

            try
            {
                byte[] data = Convert.FromBase64String(request.Response);
                string jsonString = Encoding.UTF8.GetString(data);

                var options = new System.Text.Json.JsonSerializerOptions
                {
                    PropertyNameCaseInsensitive = true
                };

                var response = System.Text.Json.JsonSerializer.Deserialize<AltchaResponsePayload>(jsonString, options);

                if (response == null)
                    return BadRequest(new { valid = false, error = "Invalid response payload" });

                if (string.IsNullOrEmpty(response.Salt) ||
                    string.IsNullOrEmpty(response.Challenge) ||
                    string.IsNullOrEmpty(response.Signature) ||
                    response.Number < 0)
                {
                    return BadRequest(new { valid = false, error = "Invalid response fields" });
                }

                if (!response.Algorithm.Equals("SHA-256", StringComparison.OrdinalIgnoreCase))
                {
                    return BadRequest(new { valid = false, error = "Unsupported algorithm" });
                }

                string hmacKey = "lXSp5P0GvfUtg6OfXSimEVkcPQkzMhIuWSYau77iY/P7HgUn0MtGS7ou5EqxcZR7";

                string challengeInput = response.Salt + response.Number.ToString();
                string computedChallenge = ComputeSha256Hex(challengeInput);

                if (!computedChallenge.Equals(response.Challenge, StringComparison.OrdinalIgnoreCase))
                {
                    return BadRequest(new { valid = false, error = "Challenge mismatch" });
                }

                string computedSignature = ComputeHmacSha256Hex(computedChallenge, hmacKey);

                if (!computedSignature.Equals(response.Signature, StringComparison.OrdinalIgnoreCase))
                {
                    return BadRequest(new { valid = false, error = "Signature mismatch" });
                }
                return Ok(new { valid = true });
            }
            catch (FormatException)
            {
                return BadRequest(new { valid = false, error = "Invalid base64 format" });
            }
            catch (Exception ex)
            {
                return BadRequest(new { valid = false, error = $"Exception: {ex.Message}" });
            }
        }

        private static string GenerateSalt(int length)
        {
            const string chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            var random = new Random();
            return new string(Enumerable.Repeat(chars, length)
              .Select(s => s[random.Next(s.Length)]).ToArray());
        }

        private static int RandomNumber(int maxNumber)
        {
            var rng = new Random();
            return rng.Next(0, maxNumber + 1);
        }

        private static string ComputeSha256Hex(string input)
        {
            using var sha256 = SHA256.Create();
            byte[] bytes = Encoding.UTF8.GetBytes(input);
            byte[] hashBytes = sha256.ComputeHash(bytes);
            return BitConverter.ToString(hashBytes).Replace("-", "").ToLowerInvariant();
        }
        private static string ComputeHmacSha256Hex(string input, string hmacKey)
        {
            byte[] keyBytes = Encoding.UTF8.GetBytes(hmacKey);
            byte[] messageBytes = Encoding.UTF8.GetBytes(input);

            using var hmac = new HMACSHA256(keyBytes);
            byte[] hmacBytes = hmac.ComputeHash(messageBytes);
            return BitConverter.ToString(hmacBytes).Replace("-", "").ToLowerInvariant();
        }
    }
    }
    public class AltchaVerificationRequest
    {
        public string Response { get; set; } = string.Empty;
    }

public class AltchaResponsePayload
{
    public string Algorithm { get; set; } = string.Empty;
    public string Challenge { get; set; } = string.Empty;
    public int Number { get; set; }
    public string Salt { get; set; } = string.Empty;
    public string Signature { get; set; } = string.Empty;
    public int Took { get; set; }
}