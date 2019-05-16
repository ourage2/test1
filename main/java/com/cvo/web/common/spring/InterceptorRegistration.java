package com.enpem.web.common.spring;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.springframework.util.Assert;
import org.springframework.util.CollectionUtils;
import org.springframework.util.PathMatcher;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.handler.MappedInterceptor;

public class InterceptorRegistration {

	private final HandlerInterceptor interceptor;

	private final List<String> includePatterns = new ArrayList<String>();

	private final List<String> excludePatterns = new ArrayList<String>();

	private PathMatcher pathMatcher;


	/**
	 * Instantiates a new interceptor registration.
	 *
	 * @param interceptor the interceptor
	 */
	public InterceptorRegistration(HandlerInterceptor interceptor) {
		Assert.notNull(interceptor, "Interceptor is required");
		this.interceptor = interceptor;
	}

	/**
	 * Adds the path patterns.
	 *
	 * @param patterns the patterns
	 * @return the interceptor registration
	 */
	public InterceptorRegistration addPathPatterns(String... patterns) {
		this.includePatterns.addAll(Arrays.asList(patterns));
		return this;
	}

	/**
	 * Exclude path patterns.
	 *
	 * @param patterns the patterns
	 * @return the interceptor registration
	 */
	public InterceptorRegistration excludePathPatterns(String... patterns) {
		this.excludePatterns.addAll(Arrays.asList(patterns));
		return this;
	}

	/**
	 * Path matcher.
	 *
	 * @param pathMatcher the path matcher
	 * @return the interceptor registration
	 */
	public InterceptorRegistration pathMatcher(PathMatcher pathMatcher) {
		this.pathMatcher = pathMatcher;
		return this;
	}

	/**
	 * Gets the interceptor.
	 *
	 * @return the interceptor
	 */
	public Object getInterceptor() {
		if (this.includePatterns.isEmpty() && this.excludePatterns.isEmpty()) {
			return this.interceptor;
		}

		String[] include = toArray(this.includePatterns);
		String[] exclude = toArray(this.excludePatterns);
		MappedInterceptor mappedInterceptor = new MappedInterceptor(include, exclude, this.interceptor);

		if (this.pathMatcher != null) {
//			mappedInterceptor.setPathMatcher(this.pathMatcher);
		}

		return mappedInterceptor;
	}

	/**
	 * To array.
	 *
	 * @param list the list
	 * @return the string[]
	 */
	private static String[] toArray(List<String> list) {
		return (CollectionUtils.isEmpty(list) ? null : list.toArray(new String[list.size()]));
	}

}
