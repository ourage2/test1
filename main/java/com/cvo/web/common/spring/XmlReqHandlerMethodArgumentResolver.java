package com.enpem.web.common.spring;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.MethodParameter;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;

import com.enpem.web.common.util.ApiUtil;

public class XmlReqHandlerMethodArgumentResolver implements HandlerMethodArgumentResolver {

	protected Logger log = LoggerFactory.getLogger(this.getClass());

    /* (non-Javadoc)
     * @see org.springframework.web.method.support.HandlerMethodArgumentResolver#supportsParameter(org.springframework.core.MethodParameter)
     */
    public boolean supportsParameter(MethodParameter mthodParameter) {
    	MethodInfo methodInfo = mthodParameter.getMethodAnnotation(MethodInfo.class);
    	if(methodInfo == null) {
    		return false;
    	}
		return (mthodParameter.getParameterType().getSimpleName().equals(methodInfo.inXml().getSimpleName()));
    }

    /* (non-Javadoc)
     * @see org.springframework.web.method.support.HandlerMethodArgumentResolver#resolveArgument(org.springframework.core.MethodParameter, org.springframework.web.method.support.ModelAndViewContainer, org.springframework.web.context.request.NativeWebRequest, org.springframework.web.bind.support.WebDataBinderFactory)
     */
    public Object resolveArgument(MethodParameter methodParameter, ModelAndViewContainer modelAndViewContainer, NativeWebRequest webRequest, WebDataBinderFactory webDataBinderFactory) {
//		HttpServletRequest request = webRequest.getNativeRequest(HttpServletRequest.class);
		return ApiUtil.getApiLogBox();
    }
}
