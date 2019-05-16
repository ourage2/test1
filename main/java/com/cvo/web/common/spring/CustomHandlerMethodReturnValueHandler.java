package com.enpem.web.common.spring;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.MethodParameter;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodReturnValueHandler;
import org.springframework.web.method.support.ModelAndViewContainer;
import org.springframework.web.servlet.View;

import com.enpem.web.common.util.ExcelUtil;
import com.enpem.web.common.util.HttpUtil;
import com.enpem.web.common.util.JsonUtil;
import com.enpem.web.common.util.XmlUtil;

public class CustomHandlerMethodReturnValueHandler implements HandlerMethodReturnValueHandler {

	protected Logger log = LoggerFactory.getLogger(this.getClass());

	public View jsonView;
	public View xmlView;
	public View xlsView;
	public View fileView;

	public void setJsonView(View jsonView) {
		this.jsonView = jsonView;
	}

	public void setXmlView(View xmlView) {
		this.xmlView = xmlView;
	}

	public void setExcelView(View excelView) {
		this.xlsView = excelView;
	}

	public void setFileView(View fileView) {
		this.fileView = fileView;
	}

	public boolean supportsReturnType(MethodParameter returnType) {
		Class<?> paramType = returnType.getParameterType();
		return void.class.equals(paramType);
	}

	public void handleReturnValue(Object returnValue, MethodParameter returnType, ModelAndViewContainer mavContainer, NativeWebRequest webRequest) throws Exception {
		if(returnValue == null) {
			HttpServletRequest request = webRequest.getNativeRequest(HttpServletRequest.class);
			if(HttpUtil.getRequestUri(request).startsWith("/cmn/fileDown") || HttpUtil.getRequestUri(request).startsWith("/cmn/csvDown") ) {
				mavContainer.setView(fileView);
				return;
			}
			if(JsonUtil.isJson(request)) {
				mavContainer.setView(jsonView);
				return;
			}
			if(XmlUtil.isXml(request)) {
				mavContainer.setView(xmlView);
				return;
			}
			if(ExcelUtil.isExcel(request)) {
				mavContainer.setView(xlsView);
				return;
			}

			String[] urlArry = request.getRequestURI().split("\\.");
//			log.debug("uri:" + request.getRequestURI());
//			log.debug("path:" + urlArry[0]);
//			log.debug("ext:" + urlArry[1]);
			if (urlArry.length > 1) {
				urlArry[0] = urlArry[0].replaceAll(request.getContextPath(), "");
				if ("pop".equals(urlArry[1])) {
					mavContainer.setViewName("nolayout:" + urlArry[0]);
					return;
				} else if ("ifm".equals(urlArry[1])) {
					mavContainer.setViewName("noframe:" + urlArry[0]);
					return;
				} else if ("m".equals(urlArry[1])) {
					mavContainer.setViewName("mobile:" + urlArry[0]);
					return;
				} else if ("do".equals(urlArry[1])) {
					mavContainer.setViewName(urlArry[0].substring(1, urlArry[0].length()));
					return;
				}
			}
		}
	}
//	public boolean supportsReturnType(MethodParameter returnType) {
////		Class<?> paramType = returnType.getParameterType();
////		return void.class.equals(paramType);
//		return true;
//	}
//
//	public void handleReturnValue(Object returnValue,MethodParameter returnType, ModelAndViewContainer mavContainer, NativeWebRequest webRequest) throws Exception {
//		if(returnValue == null){
//			HttpServletRequest request = webRequest.getNativeRequest(HttpServletRequest.class);
//			if(JsonUtils.isJsonAccept(request) || JsonUtils.isJsonExtension(request,jsonExtension)){
//				mavContainer.setView(jsonView);
//				return;
//			}
//		} else if(returnValue instanceof Map || returnValue instanceof List) {
//			HttpServletRequest request = webRequest.getNativeRequest(HttpServletRequest.class);
//			if(JsonUtils.isJsonAccept(request) || JsonUtils.isJsonExtension(request,jsonExtension)){
//				mavContainer.setView(jsonView);
//				return;
//			}
//		}
//	}
}