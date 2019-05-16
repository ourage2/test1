package com.enpem.web.common.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.context.ContextLoaderListener;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.util.UrlPathHelper;

import com.enpem.web.common.exception.BaseException;

public class SpringUtil {

	/**
	 * Gets the http servlet request.
	 *
	 * @return the http servlet request
	 */
	public static final HttpServletRequest getHttpServletRequest() {
		HttpServletRequest request = null;
		try {
			ServletRequestAttributes servletRequestAttributes = (ServletRequestAttributes)RequestContextHolder.getRequestAttributes();
			if(servletRequestAttributes != null) {
				request = servletRequestAttributes.getRequest();
			}
		} catch (Exception e) {
			throw new BaseException(e);
		}
		return request;
	}

	/**
	 * Gets the http servlet response.
	 *
	 * @return the http servlet response
	 */
//	public static final HttpServletResponse getHttpServletResponse() {
//		HttpServletResponse response = null;
//		try {
//			ServletRequestAttributes servletRequestAttributes = (ServletRequestAttributes)RequestContextHolder.getRequestAttributes();
//			if(servletRequestAttributes != null) {
//				response = servletRequestAttributes.getRequest().getResponse();
//			}
//		} catch (Exception e) {
//			throw new BaseException(e);
//		}
//		return response;
//	}

	/**
	 * Gets the web application context.
	 *
	 * @return the web application context
	 */
	public static final WebApplicationContext getWebApplicationContext() {
		return ContextLoaderListener.getCurrentWebApplicationContext();
	}

	/**
	 * Gets the bean.
	 *
	 * @param beanName the bean name
	 * @return the bean
	 */
	public static final Object getBean(String beanName) {
		Object bean = null;
		WebApplicationContext webApplicationContext = SpringUtil.getWebApplicationContext();
		if(webApplicationContext != null) {
			bean = webApplicationContext.getBean(beanName);
		}
		return bean;
	}

	/**
	 * Gets the bean.
	 *
	 * @param <T> the generic type
	 * @param clazz the clazz
	 * @return the bean
	 */
	public static final <T> T getBean(Class<T> clazz) {
		T bean = null;
		WebApplicationContext webApplicationContext = SpringUtil.getWebApplicationContext();
		if(webApplicationContext != null) {
			bean = webApplicationContext.getBean(clazz);
		}
		return bean;
	}

	/**
	 * Gets the context path.
	 *
	 * @param request the request
	 * @return the context path
	 */
	public static String getContextPath(HttpServletRequest request) {
		return new UrlPathHelper().getContextPath(request);
	}

	/**
	 * Gets the context path.
	 *
	 * @return the context path
	 */
	public static String getContextPath() {
		HttpServletRequest request = SpringUtil.getHttpServletRequest();
		return new UrlPathHelper().getContextPath(request);
	}

	public static int getServerPort() {
		HttpServletRequest request = SpringUtil.getHttpServletRequest();
		return request.getServerPort();
	}

	/**
	 * Gets the servlet path.
	 *
	 * @param request the request
	 * @return the servlet path
	 */
	public static String getServletPath(HttpServletRequest request) {
		return new UrlPathHelper().getServletPath(request);
	}

	/**
	 * Gets the servlet path.
	 *
	 * @return the servlet path
	 */
	public static String getServletPath() {
		HttpServletRequest request = SpringUtil.getHttpServletRequest();
		return SpringUtil.getServletPath(request);
	}

	/**
	 * Gets the originating servlet path.
	 *
	 * @param request the request
	 * @return the originating servlet path
	 */
	public static String getOriginatingServletPath(HttpServletRequest request) {
		return new UrlPathHelper().getOriginatingServletPath(request);
	}

	/**
	 * Gets the originating servlet path.
	 *
	 * @return the originating servlet path
	 */
	public static String getOriginatingServletPath() {
		HttpServletRequest request = SpringUtil.getHttpServletRequest();
		return new UrlPathHelper().getOriginatingServletPath(request);
	}

	/**
	 * Gets the request uri.
	 *
	 * @param request the request
	 * @return the request uri
	 */
	public static String getRequestUri(HttpServletRequest request) {
		return new UrlPathHelper().getRequestUri(request);
	}

	/**
	 * Gets the request uri.
	 *
	 * @return the request uri
	 */
	public static String getRequestUri() {
		HttpServletRequest request = SpringUtil.getHttpServletRequest();
		return new UrlPathHelper().getRequestUri(request);
	}

	/**
	 * Gets the org request uri.
	 *
	 * @param request the request
	 * @return the org request uri
	 */
	public static String getOriginatingRequestUri(HttpServletRequest request) {
		return new UrlPathHelper().getOriginatingRequestUri(request);
	}

	/**
	 * Gets the originating request uri.
	 *
	 * @return the originating request uri
	 */
	public static String getOriginatingRequestUri() {
		HttpServletRequest request = SpringUtil.getHttpServletRequest();
		return new UrlPathHelper().getOriginatingRequestUri(request);
	}

	/**
	 * Gets the org query string.
	 *
	 * @param request the request
	 * @return the org query string
	 */
	public static String getOriginatingQueryString(HttpServletRequest request) {
		return new UrlPathHelper().getOriginatingQueryString(request);
	}

	/**
	 * Gets the originating query string.
	 *
	 * @return the originating query string
	 */
	public static String getOriginatingQueryString() {
		HttpServletRequest request = SpringUtil.getHttpServletRequest();
		return new UrlPathHelper().getOriginatingQueryString(request);
	}

	/**
	 * Gets the request url.
	 *
	 * @param request the request
	 * @return the request url
	 */
	public static String getRequestURL(HttpServletRequest request) {
		StringBuffer url = new StringBuffer();
		String reqUrl = HttpUtil.getRequestURL(request);
		int pathIdx = reqUrl.indexOf("/", request.getScheme().length() + 3);
		if(pathIdx > -1) {
			url.append(reqUrl.substring(0, pathIdx));
		} else {
			url.append(reqUrl);
		}
		String uri = SpringUtil.getRequestUri(request);
		if(StringUtil.isNotEmpty(uri)) {
			url.append(uri);
		}
		return url.toString();
	}

	/**
	 * Gets the request url.
	 *
	 * @return the request url
	 */
	public static String getRequestURL() {
		HttpServletRequest request = SpringUtil.getHttpServletRequest();
		return SpringUtil.getRequestURL(request);
	}

	/**
	 * Gets the org request url.
	 *
	 * @param request the request
	 * @return the org request url
	 */
	public static String getOriginatingRequestURL(HttpServletRequest request) {
		StringBuffer url = new StringBuffer();
		String reqUrl = HttpUtil.getRequestURL(request);
		int pathIdx = reqUrl.indexOf("/", request.getScheme().length() + 3);
		if(pathIdx > -1) {
			url.append(reqUrl.substring(0, pathIdx));
		} else {
			url.append(reqUrl);
		}
		String uri = SpringUtil.getOriginatingRequestUri(request);
		if(StringUtil.isNotEmpty(uri)) {
			url.append(uri);
		}
		return url.toString();
	}

	/**
	 * Gets the org request url.
	 *
	 * @return the org request url
	 */
	public static String getOriginatingRequestURL() {
		HttpServletRequest request = SpringUtil.getHttpServletRequest();
		return SpringUtil.getOriginatingRequestURL(request);
	}

	/**
	 * Gets the lookup path for request.
	 *
	 * @param request the request
	 * @return the lookup path for request
	 */
	public static String getLookupPathForRequest(HttpServletRequest request) {
		return new UrlPathHelper().getLookupPathForRequest(request);
	}

	/**
	 * Gets the lookup path for request.
	 *
	 * @return the lookup path for request
	 */
	public static String getLookupPathForRequest() {
		HttpServletRequest request = SpringUtil.getHttpServletRequest();
		return SpringUtil.getLookupPathForRequest(request);
	}

}
