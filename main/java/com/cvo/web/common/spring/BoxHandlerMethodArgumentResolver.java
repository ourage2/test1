package com.enpem.web.common.spring;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.MethodParameter;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;

import com.enpem.web.common.constants.CmnConst;
import com.enpem.web.common.data.Box;
import com.enpem.web.common.util.JsonUtil;
import com.enpem.web.common.util.StringUtil;

public class BoxHandlerMethodArgumentResolver implements HandlerMethodArgumentResolver {

	protected Logger log = LoggerFactory.getLogger(this.getClass());

	/* (non-Javadoc)
	 * @see org.springframework.web.method.support.HandlerMethodArgumentResolver#supportsParameter(org.springframework.core.MethodParameter)
	 */
	public boolean supportsParameter(MethodParameter mthodParameter) {
		Class<?> paramType = mthodParameter.getParameterType();
		return (Box.class.isAssignableFrom(paramType));
	}

	/* (non-Javadoc)
	 * @see org.springframework.web.method.support.HandlerMethodArgumentResolver#resolveArgument(org.springframework.core.MethodParameter, org.springframework.web.method.support.ModelAndViewContainer, org.springframework.web.context.request.NativeWebRequest, org.springframework.web.bind.support.WebDataBinderFactory)
	 */
	public Object resolveArgument(MethodParameter methodParameter, ModelAndViewContainer modelAndViewContainer, NativeWebRequest webRequest, WebDataBinderFactory webDataBinderFactory) {
		HttpServletRequest request = webRequest.getNativeRequest(HttpServletRequest.class);
		if (StringUtil.nvl(request.getContentType()).startsWith("application/json")) {
			String body = null;
			StringBuilder stringBuilder = new StringBuilder();
			BufferedReader bufferedReader = null;
			try {
				InputStream inputStream = request.getInputStream();
				if (inputStream != null) {
					bufferedReader = new BufferedReader(new InputStreamReader(inputStream, "utf-8"));
					char[] charBuffer = new char[128];
					int bytesRead = -1;
					while ((bytesRead = bufferedReader.read(charBuffer)) > 0) {
						stringBuilder.append(charBuffer, 0, bytesRead);
					}
				} else {
					stringBuilder.append("");
				}
			} catch (IOException ex) {
				log.debug("error: " + ex);
			} finally {
				if (bufferedReader != null) {
					try {
						bufferedReader.close();
					} catch (IOException ex) {
						log.debug("error: " + ex);
					}
				}
			}
			body = stringBuilder.toString();

			Box box = JsonUtil.toObject(body, Box.class);
			Box rtnBox = box.getBox("payload");
			
			Object sesUserData = request.getSession().getAttribute(CmnConst.SES_USER_DATA);
			
			Iterator iterator = rtnBox.keySet().iterator();
			Object key, val;
			while (iterator.hasNext()) {
				key = iterator.next();
				val = rtnBox.get(key);
				if (val instanceof Box) {
					((Box) val).put("sBox", sesUserData);
				} else if (val instanceof List) {
					List<Box> list = rtnBox.getList(key.toString());
					for (Box bx1 : list) {
						bx1.put("sBox", sesUserData);
					}
				}
			}
			
			rtnBox.put("sBox", (Box)request.getSession().getAttribute(CmnConst.SES_USER_DATA));
//			log.debug("rtnBox" + rtnBox);
			return rtnBox;
		} else {
			Box box = new Box(request);
			Box newParamBox = new Box(box);
			request.setAttribute(CmnConst.PARAM_BOX_ORG, newParamBox);
			request.setAttribute(CmnConst.PARAM_BOX, box);
			box.put("sBox", (Box)request.getSession().getAttribute(CmnConst.SES_USER_DATA));
			return box;
		}


	}

}

//public class BoxHandlerMethodArgumentResolver implements WebArgumentResolver {
//
//	private static final Logger log = LoggerFactory.getLogger(BoxHandlerMethodArgumentResolver.class);
//
//	/**
//	 * Controller의 메소드 argument에 paramMap이라는 Map 객체가 있다면 HTTP request 객체에 있는
//	 * 파라미터이름과 값을 paramBox에 담아 returng한다. 배열인 파라미터 값은 배열로 Map에 저장한다.
//	 */
//	public Object resolveArgument(MethodParameter methodParameter, NativeWebRequest webRequest) {
//		Class<?> clazz = methodParameter.getParameterType();
//		String paramName = methodParameter.getParameterName();
//		log.debug("111111111111:"+clazz);
//		log.debug("111111111111:"+paramName);
//
//		if (clazz.equals(Map.class)) {
//
//			Map<String, Object> paramMap = new HashMap<String, Object>();
//			HttpServletRequest request = (HttpServletRequest) webRequest.getNativeRequest();
//			Enumeration<?> enumeration = request.getParameterNames();
//
//			while (enumeration.hasMoreElements()) {
//				String key = (String) enumeration.nextElement();
//				String[] values = request.getParameterValues(key);
//				if (values != null) {
//					paramMap.put(key, (values.length > 1) ? values : values[0]);
//				}
//			}
//			paramMap.put("jsonData", request.getAttribute("jsonData"));
//			return paramMap;
//		} else if (clazz.equals(Box.class)) {
//
//			HttpServletRequest request = (HttpServletRequest) webRequest.getNativeRequest();
//
//			Box box = new Box(request);
//			box.put("jsonData", request.getAttribute("jsonData"));
//			return box;
//		}
//
//		return UNRESOLVED;
//	}
//}
