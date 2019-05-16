package com.enpem.web.common.util;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.Assert;

public class CookieUtil {

	protected static final Logger log = LoggerFactory.getLogger(CookieUtil.class);
	private static final int DEFAULT_EXPIRY = -1;

	/**
	 * Sets the cookie.
	 *
	 * @param key the key
	 * @param value the value
	 * @param path the path
	 * @param expiry the expiry
	 * @param domain the domain
	 */
	public static final void setCookie(String key, String value, String path, int expiry, String domain) {
		try {
			Assert.hasLength(key);
			Cookie cookie = new Cookie(key, value);
			if(StringUtil.isEmpty(path)) {
				path = "/";
			}
			cookie.setPath(path);
			if(expiry != DEFAULT_EXPIRY) {
				cookie.setMaxAge(expiry);
			}
			if(domain != null) {
				cookie.setDomain(domain);
			}
//			HttpServletResponse response = SpringUtil.getHttpServletResponse();
//			response.addCookie(cookie);
		} catch (Exception e) {
			log.error("cookie setter error : {} - {}", key, value);
			log.error("error : {}", e);
		}
	}

	/**
	 * Sets the cookie.
	 *
	 * @param key the key
	 * @param value the value
	 * @param path the path
	 */
	public static final void setCookie(String key, String value, String path) {
		setCookie(key, value, path, DEFAULT_EXPIRY, null);
	}

	/**
	 * Sets the cookie.
	 *
	 * @param key the key
	 * @param value the value
	 */
	public static final void setCookie(String key, String value) {
		setCookie(key, value, null, DEFAULT_EXPIRY, null);
	}

	/**
	 * Sets the cookie.
	 *
	 * @param key the key
	 * @param value the value
	 * @param path the path
	 * @param expiry the expiry
	 */
	public static final void setCookie(String key, String value, String path, int expiry) {
		setCookie(key, value, path, expiry, null);
	}

	/**
	 * Sets the cookie.
	 *
	 * @param key the key
	 * @param value the value
	 * @param expiry the expiry
	 */
	public static final void setCookie(String key, String value, int expiry) {
		setCookie(key, value, null, expiry, null);
	}

	/**
	 * Gets the cookie.
	 *
	 * @param key the key
	 * @return the cookie
	 */
	public static final String getCookie(String key) {
		String value = null;
		try {
			Assert.hasLength(key);
		    HttpServletRequest request = SpringUtil.getHttpServletRequest();
			Cookie[] cookies = request.getCookies();
			if(cookies != null) {
				for(Cookie cookie : cookies) {
					if(key.equals(cookie.getName())) {
						return cookie.getValue();
					}
				}
			}
		} catch (Exception e) {
			log.error("cookie getter error : {} - {}", key);
			log.error("error : {}", e);
		}
		return value;
	}

	/**
	 * Removes the cookie.
	 *
	 * @param key the key
	 * @param path the path
	 */
	public static final void removeCookie(String key, String path) {
		try {
			Assert.hasLength(key);
		    HttpServletRequest request = SpringUtil.getHttpServletRequest();
			Cookie[] cookies = request.getCookies();
			for(Cookie cookie : cookies) {
				if(key.equals(cookie.getName())) {
					CookieUtil.setCookie(key, null, path, 0, null);
				}
			}
		} catch (Exception e) {
			log.error("cookie remove error : {} - {}", key);
			log.error("error : {}", e);
		}
	}

	/**
	 * Removes the cookie.
	 *
	 * @param key the key
	 */
	public static final void removeCookie(String key) {
		CookieUtil.removeCookie(key, null);
	}

	/**
	 * Prints the cookies.
	 */
	public static final void printCookies() {
		try {
		    HttpServletRequest request = SpringUtil.getHttpServletRequest();
			Cookie[] cookies = request.getCookies();
			int cookieLen = cookies == null ? 0 : cookies.length;
			log.debug("Cookie Length : {}", cookieLen);
			Cookie cookie = null;
			for(int i=0; i<cookieLen; i++) {
				cookie = cookies[i];
				log.debug("Key : {}, Value : {}", cookie.getName(), cookie.getValue());
			}
		} catch (Exception e) {
			log.error("error : {}", e);
		}
	}

}
