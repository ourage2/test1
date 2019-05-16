package com.enpem.web.common.spring;

import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.HandlerMethodReturnValueHandler;
import org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter;

public class CustomRequestMappingHandlerAdapter extends RequestMappingHandlerAdapter {

	protected Logger log = LoggerFactory.getLogger(this.getClass());

	private List<HandlerMethodArgumentResolver> preCustomArgumentResolvers;
	private List<HandlerMethodReturnValueHandler> preCustomReturnValueHandlers;

	public void setPreCustomArgumentResolvers(List<HandlerMethodArgumentResolver> argumentResolvers) {
		this.preCustomArgumentResolvers = argumentResolvers;
	}
	public List<HandlerMethodArgumentResolver> getPreCustomArgumentResolvers() {
		return this.preCustomArgumentResolvers;
	}
	public void setPreCustomReturnValueHandlers(List<HandlerMethodReturnValueHandler> returnValueHandlers) {
		this.preCustomReturnValueHandlers = returnValueHandlers;
	}
	public List<HandlerMethodReturnValueHandler> getPreCustomReturnValueHandlers() {
		return this.preCustomReturnValueHandlers;
	}

	public void afterPropertiesSet() {
		super.afterPropertiesSet();
		if(getPreCustomArgumentResolvers() != null) {
			List<HandlerMethodArgumentResolver> list = new ArrayList<HandlerMethodArgumentResolver>();
			list.addAll(getPreCustomArgumentResolvers());
			if(getArgumentResolvers() != null) {
				list.addAll(getArgumentResolvers());
			}
			setArgumentResolvers(list);
		}
		if(getPreCustomReturnValueHandlers() != null) {
			List<HandlerMethodReturnValueHandler> list = new ArrayList<HandlerMethodReturnValueHandler>();
			list.addAll(getPreCustomReturnValueHandlers());
			if(getReturnValueHandlers() != null) {
				list.addAll(getReturnValueHandlers());
			}
			setReturnValueHandlers(list);
		}
	}
//	private List<HandlerMethodArgumentResolver> preCustomArgumentResolvers;
//
//	public void setPreCustomArgumentResolvers(List<HandlerMethodArgumentResolver> argumentResolvers) {
//		this.preCustomArgumentResolvers = argumentResolvers;
//	}
//	public List<HandlerMethodArgumentResolver> getPreCustomArgumentResolvers() {
//		return this.preCustomArgumentResolvers;
//	}
//
//	public void afterPropertiesSet() {
//		super.afterPropertiesSet();
//		if(getPreCustomArgumentResolvers() != null){
//			log.debug("Settings preCustomArgumentResolvers");
//			ArrayList<HandlerMethodArgumentResolver> list = new ArrayList<HandlerMethodArgumentResolver>();
//			list.addAll(getPreCustomArgumentResolvers());
//			if(getArgumentResolvers() != null){
//				list.addAll(getArgumentResolvers().getResolvers());
//			}
//			setArgumentResolvers(list);
//		}
//	}
}

