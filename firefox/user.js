// Firefox settings, applied at every start (linked into the profile by ./install).
// Anything changed in about:config that should survive a reinstall goes here.

// userChrome.css (hides the tab bar; Sidebery shows tabs)
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// startup: restore the previous session; home page
user_pref("browser.startup.page", 3);
user_pref("browser.startup.homepage", "https://startpage.mikolajgawrys.com");

// new tab page: no weather/sports widgets
user_pref("browser.newtabpage.activity-stream.system.showWeatherOptIn", false);
user_pref("browser.newtabpage.activity-stream.widgets.weather.enabled", false);
user_pref("browser.newtabpage.activity-stream.widgets.sportsWidget.enabled", false);
user_pref("browser.newtabpage.activity-stream.widgets.system.sportsWidget.enabled", false);

// passwords and autofill live in Bitwarden
user_pref("signon.rememberSignons", false);
user_pref("extensions.formautofill.addresses.enabled", false);
user_pref("extensions.formautofill.creditCards.enabled", false);
user_pref("privacy.clearOnShutdown_v2.formdata", true);

// no speculative connections / prefetching
user_pref("network.dns.disablePrefetch", true);
user_pref("network.prefetch-next", false);
user_pref("network.http.speculative-parallel-limit", 0);

// misc
user_pref("media.eme.enabled", true);               // DRM video (Netflix etc.)
user_pref("browser.ipProtection.enabled", true);    // Firefox's built-in VPN
user_pref("browser.aboutConfig.showWarning", false);
user_pref("extensions.recommendations.hideNotice", true);
