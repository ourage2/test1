package com.enpem.web.common.util;

import java.net.URLEncoder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.BooleanUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.enpem.web.common.constants.CmnConst;
import com.enpem.web.common.exception.BaseException;

public class WebUtil {

	protected Logger log = LoggerFactory.getLogger(this.getClass());

	/**
	 * Sets the disposition.
	 *
	 * @param filename the filename
	 * @param request the request
	 * @param response the response
	 */
	public static void setDisposition(String filename, HttpServletRequest request, HttpServletResponse response) {
		String dispositionPrefix = "attachment; filename=";
		String encodedFilename = null;
		try {
			UserAgentUtil userAgentUtil = new UserAgentUtil(request);
			if (userAgentUtil.detectMSIE()) {
				encodedFilename = URLEncoder.encode(filename, CmnConst.CHARSET).replaceAll("\\+", "%20");
			} else if (userAgentUtil.detectFirefox()) {
				encodedFilename = "\"" + new String(filename.getBytes(CmnConst.CHARSET), "8859_1") + "\"";
			} else if (userAgentUtil.detectOpera()) {
				encodedFilename = "\"" + new String(filename.getBytes(CmnConst.CHARSET), "8859_1") + "\"";
			} else if (userAgentUtil.detectChrome() || userAgentUtil.detectSafari()) {
				StringBuffer sb = new StringBuffer();
				for (int i = 0; i < filename.length(); i++) {
					char c = filename.charAt(i);
					if (c > '~') {
						sb.append(URLEncoder.encode("" + c, CmnConst.CHARSET));
					} else {
						sb.append(c);
					}
				}
				encodedFilename = sb.toString();
			} else {
				throw new BaseException("Not supported browser");
			}
			response.setHeader("Content-Disposition", dispositionPrefix + encodedFilename);
			response.setHeader("Content-Transfer-Encoding", "binary");
			if (userAgentUtil.detectOpera()) {
				response.setContentType("application/octet-stream;charset=" + CmnConst.CHARSET);
			}
		} catch (Exception e) {
			throw new BaseException(e);
		}
		if(StringUtil.isNotEmpty(CookieUtil.getCookie("ajaxFileDownloading"))) {
			CookieUtil.setCookie("ajaxFileDownload", "true");
		}
	}

	/**
	 * Download clear header.
	 *
	 * @param request the request
	 * @param response the response
	 */
	public static final void downloadClearHeader(HttpServletRequest request, HttpServletResponse response) {
		if(WebUtil.isDownloadAccept(request)) {
			response.setHeader("Content-Disposition", null);
			response.setHeader("Content-Description", null);
		}
		// CookieUtil.setCookie("fileDownload", null, "/");
	}

	/**
	 * Checks if is download.
	 *
	 * @param request the request
	 * @return true, if is download
	 */
	public static final boolean isDownloadAccept(HttpServletRequest request) {
		String xAccept = request.getHeader("X-Accept");
		if(xAccept != null && xAccept.toLowerCase().startsWith("application/download")) {
			return true;
		}
		return false;
	}

	public static final boolean isDownloadCookie(HttpServletRequest request) {
		return BooleanUtils.toBoolean(CookieUtil.getCookie("ajaxFileDownloading"));
	}

	/**
	 * Checks if is download extension.
	 *
	 * @param request the request
	 * @return true, if is download extension
	 */
	public static final boolean isDownloadExtension(HttpServletRequest request) {
		String uri = SpringUtil.getOriginatingServletPath(request);
		if(uri.endsWith(".file")) {
			return true;
		}
		return false;
	}

	/**
	 * Checks if is do extension.
	 *
	 * @param request the request
	 * @return true, if is do extension
	 */
	public static final boolean isDoExtension(HttpServletRequest request) {
		String uri = SpringUtil.getOriginatingServletPath(request);
		if(uri.endsWith(".do")) {
			return true;
		}
		return false;
	}

}
