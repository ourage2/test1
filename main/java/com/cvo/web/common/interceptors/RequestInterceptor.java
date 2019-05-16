package com.enpem.web.common.interceptors;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;


public class RequestInterceptor extends HandlerInterceptorAdapter {

	protected Logger log = LoggerFactory.getLogger(this.getClass());

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		log.debug(">>Request Interceptor");
		return true;
	}

//	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
//		Box paramBox = new Box();
//		Enumeration<String> enumeration = request.getParameterNames();
//		while (enumeration.hasMoreElements()) {
//			String key = enumeration.nextElement();
//			String[] values = request.getParameterValues(key);
//			if (values != null) {
//				if(values.length > 1) {
//					paramBox.put(key, values);
//				} else {
//					/*
//					String value = URLDecoder.decode(values[0], CmnConstants.CHARSET);
//					Matcher matcher = SQL_INJECTION_PATTERN.matcher(value);
//					if(matcher.find()) {
//						throw new OmbsException(CmnConstants.RES_CD_VALIDATION_ERROR);
//					}
//					*/
//					paramBox.put(key, values[0]);
//				}
//			}
//		}
//		request.setAttribute(CmnConstants.REQUEST_PARAM, paramBox);
//		Box newParamBox = new Box(paramBox);
//		request.setAttribute(CmnConstants.REQUEST_PARAM_ORG, newParamBox);
//		paramBox.setSession(request.getSession());
//
//		HandlerMethod handlerMethod = (HandlerMethod)handler;
//		ReqInfo reqInfo = handlerMethod.getMethodAnnotation(ReqInfo.class);
//		if(reqInfo != null) {
//			String validForm = reqInfo.validForm();
//			if(StringUtil.isNotEmpty(validForm)) {
//				log.debug("Validation Form Name : {}", validForm);
//				BindingResult errors = new MapBindingResult(paramBox, validForm);
//				configBeanValidator.setFormName(validForm);
//				try {
//					configBeanValidator.validate(paramBox, errors);
//				} catch (Exception e) {
//					throw new OmbsException(CmnConstants.RES_CD_VALIDATION_ERROR);
//				}
//				if(errors.hasErrors()) {
//					log.info("Validation Error : {}", errors);
//					FieldError fieldError = errors.getFieldError();
//					String errorCode = fieldError.getCode();
//					throw new OmbsException(errorCode, fieldError.getArguments());
//				}
//			}
//		}
//		return true;
//	}
}
