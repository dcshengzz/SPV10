using Microsoft.AspNetCore.Http;

namespace swz.AspNetCore.Identity.Anonymous
{
    public class AnonymousIdCookieOptions : CookieOptions
    {
        public string Name { get; set; }
        public bool SlidingExpiration { get; set; } = false;
        public int Timeout { get; set; }
    }
}