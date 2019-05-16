package com.enpem.web.common.util;

import javax.servlet.http.HttpServletRequest;

public class UserAgentUtil {

	private String userAgent = null;
    private String httpAccept = null;

    public static final String engineWebKit = "webkit";
    public static final String deviceAndroid = "android";
    public static final String deviceIphone = "iphone";
    public static final String deviceIpod = "ipod";
    public static final String deviceSymbian = "symbian";
    public static final String deviceS60 = "series60";
    public static final String deviceS70 = "series70";
    public static final String deviceS80 = "series80";
    public static final String deviceS90 = "series90";
    public static final String deviceWinMob = "windows ce";
    public static final String deviceWindows = "windows";
    public static final String deviceIeMob = "iemobile";
    public static final String enginePie = "wm5 pie";
    public static final String deviceBB = "blackberry";
    public static final String vndRIM = "vnd.rim";
    public static final String deviceBBStorm = "blackberry95";
    public static final String devicePalm = "palm";
    public static final String deviceWebOS = "webos";

    public static final String engineBlazer = "blazer";
    public static final String engineXiino = "xiino";

    public static final String vndwap = "vnd.wap";
    public static final String wml = "wml";

    public static final String deviceBrew = "brew";
    public static final String deviceDanger = "danger";
    public static final String deviceHiptop = "hiptop";
    public static final String devicePlaystation = "playstation";
    public static final String deviceNintendoDs = "nitro";
    public static final String deviceNintendo = "nintendo";
    public static final String deviceWii = "wii";
    public static final String deviceXbox = "xbox";
    public static final String deviceArchos = "archos";

    public static final String engineOpera = "opera";
    public static final String engineNetfront = "netfront";
    public static final String engineUpBrowser = "up.browser";
    public static final String engineOpenWeb = "openweb";
    public static final String deviceMidp = "midp";
    public static final String uplink = "up.link";

    public static final String devicePda = "pda";
    public static final String mini = "mini";
    public static final String mobile = "mobile";
    public static final String mobi = "mobi";

    public static final String maemo = "maemo";
    public static final String maemoTablet = "tablet";
    public static final String linux = "linux";
    public static final String qtembedded = "qt embedded";
    public static final String mylocom2 = "com2";

    public static final String manuSonyEricsson = "sonyericsson";
    public static final String manuericsson = "ericsson";
    public static final String manuSamsung1 = "sec-sgh";
    public static final String manuSony = "sony";

    public static final String svcDocomo = "docomo";
    public static final String svcKddi = "kddi";
    public static final String svenpemdafone = "vodafone";

    public static final String msie = "msie";
    public static final String msie60 = "msie 6.0";
    public static final String msie61 = "msie 6.1";
    public static final String msie7 = "msie 7";
    public static final String msie8 = "msie 8";
    public static final String msie9 = "msie 9";
    public static final String msie10 = "msie 10";
    public static final String msie11 = "rv:11.0";
    public static final String spartan = "edge/12.0";
    public static final String trident = "trident";
    public static final String firefox = "firefox";
    public static final String safari = "apple";
    public static final String chrome = "chrome";
    public static final String opera = "presto";

    public static final String windows = "windows";

    /**
     * Initialize the userAgent and httpAccept variables.
     *
     * @param userAgent the User-Agent header
     * @param httpAccept the Accept header
     */
    public UserAgentUtil(String userAgent, String httpAccept) {
        if (userAgent != null) {
            this.userAgent = userAgent.toLowerCase();
        }
        if (httpAccept != null) {
            this.httpAccept = httpAccept.toLowerCase();
        }
    }

    /**
     * Initialize the userAgent and httpAccept variables by getting the headers
     * from the HttpServletRequest.
     *
     * @param request the HttpServletRequest to get the header information from
     */
    public UserAgentUtil(HttpServletRequest request) {
        this(request.getHeader("User-Agent"), request.getHeader("Accept"));
    }

    /**
     * Return the lower case HTTP_USER_AGENT.
     *
     * @return the user agent
     */
    public String getUserAgent() {
        return userAgent;
    }

    /**
     * Return the lower case HTTP_ACCEPT.
     *
     * @return the http accept
     */
    public String getHttpAccept() {
        return httpAccept;
    }

    /**
     * Detects if the current device is an iPhone.
     *
     * @return true, if successful
     */
    public boolean detectIphone() {
        return userAgent.indexOf(deviceIphone) != -1 && !detectIpod();
    }

    /**
     * Detects if the current device is an iPod Touch.
     *
     * @return true, if successful
     */
    public boolean detectIpod() {
        return userAgent.indexOf(deviceIpod) != -1;
    }

    /**
     * Detects if the current device is an iPhone or iPod Touch.
     *
     * @return true, if successful
     */
    public boolean detectIphoneOrIpod() {
        return userAgent.indexOf(deviceIphone) != -1 || userAgent.indexOf(deviceIpod) != -1;
    }

    /**
     * Detects if the current device is an Android OS-based device.
     *
     * @return true, if successful
     */
    public boolean detectAndroid() {
        return userAgent.indexOf(deviceAndroid) != -1;
    }

    /**
     * Detects if the current device is an Android OS-based device and
     * the browser is based on WebKit.
     *
     * @return true, if successful
     */
    public boolean detectAndroidWebKit() {
        return detectAndroid() && detectWebkit();
    }

    /**
     * Detects if the current browser is based on WebKit.
     *
     * @return true, if successful
     */
    public boolean detectWebkit() {
        return userAgent.indexOf(engineWebKit) != -1;
    }

    /**
     * Detects if the current browser is the S60 Open Source Browser.
     *
     * @return true, if successful
     */
    public boolean detectS60OssBrowser() {
        return detectWebkit() && (userAgent.indexOf(deviceSymbian) != -1 || userAgent.indexOf(deviceS60) != -1);
    }

    /**
     * Detects if the current device is any Symbian OS-based device,
     *   including older S60, Series 70, Series 80, Series 90, and UIQ,
     *   or other browsers running on these devices.
     *
     * @return true, if successful
     */
    public boolean detectSymbianOS() {
        return userAgent.indexOf(deviceSymbian) != -1 || userAgent.indexOf(deviceS60) != -1 ||
                userAgent.indexOf(deviceS70) != -1 || userAgent.indexOf(deviceS80) != -1 ||
                userAgent.indexOf(deviceS90) != -1;
    }

    /**
     * Detects if the current browser is a Windows Mobile device.
     *
     * @return true, if successful
     */
    public boolean detectWindowsMobile() {
        return userAgent.indexOf(deviceWinMob) != -1 ||
                userAgent.indexOf(deviceIeMob) != -1 ||
                userAgent.indexOf(enginePie) != -1 ||
                (detectWapWml() && userAgent.indexOf(deviceWindows) != -1);
    }

    /**
     * Detects if the current browser is a BlackBerry of some sort.
     *
     * @return true, if successful
     */
    public boolean detectBlackBerry() {
        return userAgent.indexOf(deviceBB) != -1 || httpAccept.indexOf(vndRIM) != -1;
    }

    /**
     * Detects if the current browser is a BlackBerry Touch
     * device, such as the Storm.
     *
     * @return true, if successful
     */
    public boolean detectBlackBerryTouch() {
        return userAgent.indexOf(deviceBBStorm) != -1;
    }

    /**
     * Detects if the current browser is on a PalmOS device.
     *
     * @return true, if successful
     */
    public boolean detectPalmOS() {
        if (userAgent.indexOf(devicePalm) != -1 || userAgent.indexOf(engineBlazer) != -1 ||
                userAgent.indexOf(engineXiino) != -1 && !detectPalmWebOS()) {
            if (detectPalmWebOS()) {
            	return false;
            } else {
            	return true;
            }
        }
        return false;
    }

    /**
     * Detects if the current browser is on a Palm device
     *    running the new WebOS.
     *
     * @return true, if successful
     */
    public boolean detectPalmWebOS() {
        return userAgent.indexOf(deviceWebOS) != -1;
    }

    /**
     * Check to see whether the device is any device
     *   in the 'smartphone' category.
     *
     * @return true, if successful
     */
    public boolean detectSmartphone() {
        return (detectIphoneOrIpod() ||
                detectS60OssBrowser() ||
                detectSymbianOS() ||
                detectWindowsMobile() ||
                detectBlackBerry() ||
                detectPalmOS() ||
                detectPalmWebOS() ||
                detectAndroid());
    }

    /**
     * Detects whether the device is a Brew-powered device.
     *
     * @return true, if successful
     */
    public boolean detectBrewDevice() {
        return userAgent.indexOf(deviceBrew) != -1;
    }

    /**
     * Detects the Danger Hiptop device.
     *
     * @return true, if successful
     */
    public boolean detectDangerHiptop() {
        return userAgent.indexOf(deviceDanger) != -1 || userAgent.indexOf(deviceHiptop) != -1;
    }

    /**
     * Detects Opera Mobile or Opera Mini.
     * Added by AHand
     *
     * @return true, if successful
     */
    public boolean detectOperaMobile() {
        return userAgent.indexOf(engineOpera) != -1 && (userAgent.indexOf(mini) != -1 || userAgent.indexOf(mobi) != -1);
    }

    /**
     * Detects whether the device supports WAP or WML.
     *
     * @return true, if successful
     */
    public boolean detectWapWml() {
        return httpAccept.indexOf(vndwap) != -1 || httpAccept.indexOf(wml) != -1;
    }

    /**
     * The quick way to detect for a mobile device.
     *  Will probably detect most recent/current mid-tier Feature Phones
     *  as well as smartphone-class devices.
     *
     * @return true, if successful
     */
    public boolean detectMobileQuick() {
        if (detectWapWml()) { return true; }
        if (detectBrewDevice()) { return true; }

        if (detectOperaMobile()) { return true; }

        if (userAgent.indexOf(engineUpBrowser) != -1) { return true; }
        if (userAgent.indexOf(engineOpenWeb) != -1) { return true; }
        if (userAgent.indexOf(deviceMidp) != -1) { return true; }

        if (detectSmartphone()) { return true; }
        if (detectDangerHiptop()) { return true; }

        if (detectMidpCapable()) { return true; }

        if (userAgent.indexOf(devicePda) != -1) { return true; }
        if (userAgent.indexOf(mobile) != -1) { return true; }

        if (userAgent.indexOf(uplink) != -1) { return true; }
        if (userAgent.indexOf(manuSonyEricsson) != -1) { return true; }
        if (userAgent.indexOf(manuericsson) != -1) { return true; }
        if (userAgent.indexOf(manuSamsung1) != -1) { return true; }
        if (userAgent.indexOf(svcDocomo) != -1) { return true; }
        if (userAgent.indexOf(svcKddi) != -1) { return true; }
        if (userAgent.indexOf(svenpemdafone) != -1) { return true; }

        return false;
    }

    /**
     * Detects if the current device is a Sony Playstation.
     *
     * @return true, if successful
     */
    public boolean detectSonyPlaystation() {
        return userAgent.indexOf(devicePlaystation) != -1;
    }

    /**
     * Detects if the current device is a Nintendo game device.
     *
     * @return true, if successful
     */
    public boolean detectNintendo() {
        return userAgent.indexOf(deviceNintendo) != -1 || userAgent.indexOf(deviceWii) != -1 ||
            userAgent.indexOf(deviceNintendoDs) != -1;
    }

    /**
     * Detects if the current device is a Microsoft Xbox.
     *
     * @return true, if successful
     */
    public boolean detectXbox() {
        return userAgent.indexOf(deviceXbox) != -1;
    }

    /**
     * Detects if the current device is an Internet-capable game console.
     *
     * @return true, if successful
     */
    public boolean detectGameConsole() {
        return detectSonyPlaystation() || detectNintendo() || detectXbox();
    }

    /**
     * Detects if the current device supports MIDP, a mobile Java technology.
     *
     * @return true, if successful
     */
    public boolean detectMidpCapable() {
        return userAgent.indexOf(deviceMidp) != -1 || httpAccept.indexOf(deviceMidp) != -1;
    }

    /**
     * Detects if the current device is on one of the Maemo-based Nokia Internet Tablets.
     *
     * @return true, if successful
     */
    public boolean detectMaemoTablet() {
        return (userAgent.indexOf(maemo) != -1 || (userAgent.indexOf(maemoTablet) != -1 && userAgent.indexOf(linux) != -1));
    }

    /**
     * Detects if the current device is an Archos media player/Internet tablet.
     *
     * @return true, if successful
     */
    public boolean detectArchos() {
        return userAgent.indexOf(deviceArchos) != -1;
    }

    /**
     * Detects if the current browser is a Sony Mylo device.
     * Updated by AHand
     *
     * @return true, if successful
     */
    public boolean detectSonyMylo() {
        return userAgent.indexOf(manuSony) != -1 && (userAgent.indexOf(qtembedded) != -1 ||
            userAgent.indexOf(mylocom2) != -1);
    }

    /**
     * The longer and more thorough way to detect for a mobile device.
     *   Will probably detect most feature phones,
     *   smartphone-class devices, Internet Tablets,
     *   Internet-enabled game consoles, etc.
     *   This ought to catch a lot of the more obscure and older devices, also --
     *   but no promises on thoroughness!
     *
     * @return true, if successful
     */
    public boolean detectMobileLong() {
        return detectMobileQuick() || detectMaemoTablet() || detectGameConsole();
    }

    /**
     * Detect msie.
     *
     * @return true, if successful
     */
    public boolean detectMSIE() {
        return userAgent.indexOf(msie) != -1 || userAgent.indexOf(trident) != -1;
    }

    /**
     * Detect msi e6.
     *
     * @return true, if successful
     */
    public boolean detectMSIE6() {
        return userAgent.indexOf(msie60) != -1 && userAgent.indexOf(msie61) != -1;
    }

    /**
     * Detect msi e7.
     *
     * @return true, if successful
     */
    public boolean detectMSIE7() {
        return userAgent.indexOf(msie7) != -1;
    }

    /**
     * Detect msi e8.
     *
     * @return true, if successful
     */
    public boolean detectMSIE8() {
        return userAgent.indexOf(msie8) != -1;
    }

    /**
     * Detect msi e9.
     *
     * @return true, if successful
     */
    public boolean detectMSIE9() {
        return userAgent.indexOf(msie9) != -1;
    }

    /**
     * Detect msi e10.
     *
     * @return true, if successful
     */
    public boolean detectMSIE10() {
        return userAgent.indexOf(msie10) != -1;
    }

    /**
     * Detect msi e11.
     *
     * @return true, if successful
     */
    public boolean detectMSIE11() {
        return userAgent.indexOf(msie11) != -1;
    }

    /**
     * Detect spartan.
     *
     * @return true, if successful
     */
    public boolean detectSpartan() {
        return userAgent.indexOf(spartan) != -1;
    }

    /**
     * Detect firefox.
     *
     * @return true, if successful
     */
    public boolean detectFirefox() {
        return userAgent.indexOf(firefox) != -1;
    }

    /**
     * Detect safari.
     *
     * @return true, if successful
     */
    public boolean detectSafari() {
        return userAgent.indexOf(safari) != -1;
    }

    /**
     * Detect chrome.
     *
     * @return true, if successful
     */
    public boolean detectChrome() {
        return userAgent.indexOf(chrome) != -1;
    }

    /**
     * Detect opera.
     *
     * @return true, if successful
     */
    public boolean detectOpera() {
        return userAgent.indexOf(opera) != -1;
    }

    /**
     * Detect windows.
     *
     * @return true, if successful
     */
    public boolean detectWindows() {
        return userAgent.indexOf(windows) != -1;
    }

    /**
     * The quick way to detect for a tier of devices.
     *   This method detects for devices which can
     *   display iPhone-optimized web content.
     *   Includes iPhone, iPod Touch, Android, Palm WebOS, etc.
     *
     * @return true, if successful
     */
    public boolean detectTierIphone() {
        return detectIphoneOrIpod() || detectPalmWebOS() || detectAndroid() || detectAndroidWebKit();
    }

    /**
     * The quick way to detect for a tier of devices.
     *   This method detects for all smartphones, but
     *   excludes the iPhone Tier devices.
     *
     * @return true, if successful
     */
    public boolean detectTierSmartphones() {
        return detectSmartphone() && (!detectTierIphone());
    }

    /**
     * The quick way to detect for a tier of devices.
     *   This method detects for all other types of phones,
     *   but excludes the iPhone and Smartphone Tier devices.
     *
     * @return true, if successful
     */
    public boolean detectTierOtherPhones() {
        return detectMobileQuick() && (!detectTierIphone()) && (!detectTierSmartphones());
    }

}
