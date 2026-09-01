import React, { useEffect } from 'react';

const BrowserCompatibilityCheck = () => {
  useEffect(() => {
    const userAgent = navigator.userAgent;
    const isOutdatedBrowser = checkBrowserCompatibility(userAgent);

    if (isOutdatedBrowser) {

      alert('Your browser is outdated. Please update your browser to prevent any potential issues.');
    }
  }, []);

  const checkBrowserCompatibility = (userAgent) => {

    const match = userAgent.match(/(Edg|Chrome|Firefox|Safari)\/(\d+)/);
    if (match && match.length === 3) {
      const browserName = match[1];
      const browserVersion = parseInt(match[2]);

      if (window.browserConfig[browserName] && browserVersion < window.browserConfig[browserName]) {
        return true; // Browser is outdated
      }
    }
    return false; 
  };

  return null; 
};

export default BrowserCompatibilityCheck;
