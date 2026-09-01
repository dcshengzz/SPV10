using System;
using Microsoft.AspNetCore.Http;

namespace swz.AspNetCore.Identity.Anonymous
{
    public class AnonymousIdCookieOptionsBuilder
    {
        private const string DefaultCookieName = ".ASPXANONYMOUS";
        private const string DefaultCookiePath = "/";
        private const int DefaultCookieTimeout = 100000;
        private const int MinimumCookieTimeout = 1;
        private const int MaximumCookieTimeout = 60 * 60 * 24 * 365 * 2;
        private const bool DefaultCookieRequireSsl = false;
        private const bool DefaultCookieHttpOnly = true;
        private const bool DefaultSlidingExpiration = false;
        private const SameSiteMode DefaultCookieSameSite = SameSiteMode.Strict;

        private string _cookieName;
        private string _cookiePath;
        private int? _cookieTimeout;
        private string _cookieDomain;
        private bool? _cookieRequireSsl;
        private bool? _cookieHttpOnly;
        private bool? _cookieSlidingExpiration;

        private SameSiteMode? _cookieSameSite;

        public AnonymousIdCookieOptionsBuilder SetCustomCookieName(string cookieName)
        {
            _cookieName = cookieName;
            return this;
        }

        public AnonymousIdCookieOptionsBuilder SetCustomCookiePath(string cookiePath)
        {
            _cookiePath = cookiePath;
            return this;
        }

        public AnonymousIdCookieOptionsBuilder SetCustomCookieTimeout(int cookieTimeout)
        {
            _cookieTimeout = Math.Min(Math.Max(MinimumCookieTimeout, cookieTimeout), MaximumCookieTimeout);
            return this;
        }

        public AnonymousIdCookieOptionsBuilder SetCustomCookieDomain(string cookieDomain)
        {
            _cookieDomain = cookieDomain;
            return this;
        }

        public AnonymousIdCookieOptionsBuilder SetCustomCookieRequireSsl(bool cookieRequireSsl)
        {
            _cookieRequireSsl = cookieRequireSsl;
            return this;
        }

        public AnonymousIdCookieOptionsBuilder SetCustomCookieHttpOnly(bool cookieHttpOnly)
        {
            _cookieHttpOnly = cookieHttpOnly;
            return this;
        }

        public AnonymousIdCookieOptionsBuilder SetCustomCookieSlidingExpiration(bool slidingExpiration)
        {
            _cookieSlidingExpiration = slidingExpiration;
            return this;
        }


        public AnonymousIdCookieOptionsBuilder SetCustomCookieSameSite(SameSiteMode? cookieSameSite)
        {
            _cookieSameSite = cookieSameSite;
            return this;
        }

        public AnonymousIdCookieOptions Build()
        {
            AnonymousIdCookieOptions options = new AnonymousIdCookieOptions
            {
                Name = _cookieName ?? DefaultCookieName,
                Path = _cookiePath ?? DefaultCookiePath,
                Timeout = _cookieTimeout ?? DefaultCookieTimeout,
                Secure = _cookieRequireSsl ?? DefaultCookieRequireSsl,
                HttpOnly = _cookieHttpOnly ?? DefaultCookieHttpOnly,
                SameSite = _cookieSameSite ?? DefaultCookieSameSite,
                SlidingExpiration = _cookieSlidingExpiration ?? DefaultSlidingExpiration
            };

            if (!string.IsNullOrWhiteSpace(_cookieDomain))
            {
                options.Domain = _cookieDomain;
            }

            return options;
        }
    }
}