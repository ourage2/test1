package com.enpem.web.common.spring;

import java.util.ArrayList;
import java.util.List;

import org.springframework.web.context.request.WebRequestInterceptor;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.handler.WebRequestHandlerInterceptorAdapter;

public class InterceptorRegistry {

	private final List<InterceptorRegistration> registrations = new ArrayList<InterceptorRegistration>();

	/**
	 * Adds the interceptor.
	 *
	 * @param interceptor the interceptor
	 * @return the interceptor registration
	 */
	public InterceptorRegistration addInterceptor(HandlerInterceptor interceptor) {
		InterceptorRegistration registration = new InterceptorRegistration(interceptor);
		registrations.add(registration);
		return registration;
	}

	/**
	 * Adds the web request interceptor.
	 *
	 * @param interceptor the interceptor
	 * @return the interceptor registration
	 */
	public InterceptorRegistration addWebRequestInterceptor(WebRequestInterceptor interceptor) {
		WebRequestHandlerInterceptorAdapter adapted = new WebRequestHandlerInterceptorAdapter(interceptor);
		InterceptorRegistration registration = new InterceptorRegistration(adapted);
		registrations.add(registration);
		return registration;
	}

	/**
	 * Gets the interceptors.
	 *
	 * @return the interceptors
	 */
	public List<Object> getInterceptors() {
		List<Object> interceptors = new ArrayList<Object>();
		for (InterceptorRegistration registration : registrations) {
			interceptors.add(registration.getInterceptor());
		}
		return interceptors;
	}

}
