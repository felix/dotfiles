// PREF: Disable Displaying Javascript in History URLs
// http://kb.mozillazine.org/Browser.urlbar.filter.javascript
user_pref("browser.urlbar.filter.javascript", true);
// PREF: Enable search suggestions in the search bar
user_pref("browser.search.suggest.enabled", true);
// PREF: When using the location bar, do suggest URLs from browsing history
user_pref("browser.urlbar.suggest.history", true);
// PREF: Enable URL bar autocomplete and history/bookmarks suggestions dropdown
user_pref("browser.urlbar.autocomplete.enabled", true);
// PREF: Clear history when Firefox closes
// https://support.mozilla.org/en-US/kb/Clear%20Recent%20History#w_how-do-i-make-firefox-clear-my-history-automatically
user_pref("privacy.sanitize.sanitizeOnShutdown", true);
user_pref("privacy.clearOnShutdown.cache", true);
user_pref("privacy.clearOnShutdown.cookies", true);
user_pref("privacy.clearOnShutdown.downloads", true);
user_pref("privacy.clearOnShutdown.formdata", true);
user_pref("privacy.clearOnShutdown.history", false);
user_pref("privacy.clearOnShutdown.offlineApps", true);
user_pref("privacy.clearOnShutdown.sessions", true);
user_pref("privacy.clearOnShutdown.openWindows", true);
// PREF: Do remember browsing history
user_pref("places.history.enabled", true);
// PREF: Enable Caching of SSL Pages
// http://kb.mozillazine.org/Browser.cache.disk_cache_ssl
user_pref("browser.cache.disk_cache_ssl", true);
// PREF: Disable password manager (use an external password manager!)
user_pref("signon.rememberSignons", false);
// PREF: Disable form autofill, don't save information entered in web page forms and the Search Bar
user_pref("browser.formfill.enable", false);
// PREF: Set Accept-Language HTTP header to en-US regardless of Firefox localization
// https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Accept-Language
user_pref("intl.accept_languages", "en-au,en,en-us");
// PREF: Do use OS values to determine locale, force using Firefox locale setting
// http://kb.mozillazine.org/Intl.locale.matchOS
user_pref("intl.locale.matchOS", true);
// PREF: Don't try to guess domain names when entering an invalid domain name in URL bar
// http://www-archive.mozilla.org/docs/end-user/domain-guessing.html
user_pref("browser.fixup.alternate.enabled", false);
// PREF: Disable asm.js
// http://asmjs.org/
// https://www.mozilla.org/en-US/security/advisories/mfsa2015-29/
// https://www.mozilla.org/en-US/security/advisories/mfsa2015-50/
// https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2015-2712
user_pref("javascript.options.asmjs", false);
// PREF: Disable Flash Player NPAPI plugin
// http://kb.mozillazine.org/Flash_plugin
user_pref("plugin.state.flash", 0);
// PREF: Disable Java NPAPI plugin
user_pref("plugin.state.java", 0);
// PREF: Disable Extension recommendations (Firefox >= 65)
// https://support.mozilla.org/en-US/kb/extension-recommendations
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr", false);
// PREF: Trusted Recursive Resolver (DNS-over-HTTPS) (disabled)
// https://wiki.mozilla.org/Trusted_Recursive_Resolver
user_pref("network.trr.mode", 0);
// PREF: Disallow Necko to do A/B testing
// https://trac.torproject.org/projects/tor/ticket/13170
user_pref("network.allow-experiments", false);
// PREF: Disable Pocket
// https://support.mozilla.org/en-US/kb/save-web-pages-later-pocket-firefox
// https://github.com/pyllyukko/user.js/issues/143
user_pref("browser.pocket.enabled", false);
user_pref("extensions.pocket.enabled", false);
// Disable captiveportal checks
user_pref("network.captive-portal-service.enabled", false);
