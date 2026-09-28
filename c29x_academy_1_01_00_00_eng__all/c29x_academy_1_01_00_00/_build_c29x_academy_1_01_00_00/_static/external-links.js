// Make all external links open in new tab (TIREX compatible)
document.addEventListener('DOMContentLoaded', function() {
    console.log('[External Links] Script loaded');

    // Find all links with class 'external' or links starting with http/https
    var links = document.querySelectorAll('a.external, a[href^="http://"], a[href^="https://"]');
    console.log('[External Links] Found ' + links.length + ' external links');

    links.forEach(function(link) {
        // Only process truly external links (not same domain)
        var currentDomain = window.location.hostname;
        var linkHostname = link.hostname;

        if (linkHostname && linkHostname !== currentDomain && linkHostname !== '127.0.0.1' && linkHostname !== 'localhost') {
            // Set target="_blank" to open in new tab
            link.setAttribute('target', '_blank');
            link.setAttribute('rel', 'noopener noreferrer');

            // Add click handler to force window.open (prevents TIREX from blocking)
            link.addEventListener('click', function(e) {
                e.preventDefault();
                e.stopPropagation();

                var url = this.href;
                console.log('[External Links] Opening:', url);

                // Use window.open - this is the only way that works in TIREX
                window.open(url, '_blank', 'noopener,noreferrer');

                return false;
            }, true); // Use capture phase

            console.log('[External Links] Configured:', link.href);
        }
    });
});
