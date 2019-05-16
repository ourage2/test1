package com.enpem.web.common.util;

import javax.servlet.http.HttpServletRequest;

public class ViewUtil {

	/**
	 * Checks if is html.
	 *
	 * @param request the request
	 * @return true, if is html
	 */
	public static final boolean isHtml(HttpServletRequest request) {
		if(isHtmlExtension(request) || isHtmlAccept(request) || isHtmlBody(request)) {
			return true;
		}
		return false;
	}

	/**
	 * Checks if is html extension.
	 *
	 * @param request the request
	 * @return true, if is html extension
	 */
	public static final boolean isHtmlExtension(HttpServletRequest request) {
		String uri = SpringUtil.getServletPath(request);
		if(uri.endsWith(".do")) {
			return true;
		}
		return false;
	}

	/**
	 * Checks if is html accept.
	 *
	 * @param request the request
	 * @return true, if is html accept
	 */
	public static final boolean isHtmlAccept(HttpServletRequest request) {
		String accept = request.getHeader("Accept");
		if(accept != null && accept.toLowerCase().startsWith("text/html")) {
			return true;
		}
		return false;
	}

	/**
	 * Checks if is json body.
	 *
	 * @param request the request
	 * @return true, if is json body
	 */
	public static final boolean isHtmlBody(HttpServletRequest request) {
		String contentType = request.getContentType();
		if(contentType != null && contentType.toLowerCase().startsWith("text/html") ){
			return true;
		}
		return false;
	}

}
