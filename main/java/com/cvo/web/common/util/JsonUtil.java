package com.enpem.web.common.util;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.enpem.web.common.exception.BaseException;

@Service
public class JsonUtil {

	private static ObjectMapper objectMapper;
	private static ObjectMapper objectMapperFormat;

	/**
	 * Sets the object mapper.
	 *
	 * @param objectMapper the new object mapper
	 */
	@Autowired
	@Qualifier(value="objectMapper")
	private void setObjectMapper(ObjectMapper objectMapper) {
		JsonUtil.objectMapper = objectMapper;
	}

	/**
	 * Sets the object mapper format.
	 *
	 * @param objectMapperFormat the new object mapper format
	 */
	@Autowired
	@Qualifier(value="objectMapperFormat")
	private void setObjectMapperFormat(ObjectMapper objectMapperFormat) {
		JsonUtil.objectMapperFormat = objectMapperFormat;
	}

	/**
	 * Checks if is json accept.
	 *
	 * @param request the request
	 * @return true, if is json accept
	 */
	public static final boolean isJsonAccept(HttpServletRequest request) {
		String accept = request.getHeader("Accept");

		if(accept != null && accept.toLowerCase().startsWith("application/json")) {
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
	public static final boolean isJsonBody(HttpServletRequest request) {
		String contentType = request.getContentType();
		if(contentType != null && contentType.toLowerCase().startsWith("application/json") ){
			return true;
		}
		return false;
	}

	/**
	 * Checks if is json extension.
	 *
	 * @param request the request
	 * @return true, if is json extension
	 */
	public static final boolean isJsonExtension(HttpServletRequest request) {
		String uri = SpringUtil.getOriginatingServletPath(request);
		if(uri.endsWith(".json")) {
			return true;
		}
		return false;
	}

	/**
	 * Checks if is json error accept.
	 *
	 * @param request the request
	 * @return true, if is json error accept
	 */
	public static final boolean isJsonErrorAccept(HttpServletRequest request) {
		if("application/json".equals(request.getHeader("X-Error-Accept"))) {
			return true;
		}
		return false;
	}

	/**
	 * Checks if is json.
	 *
	 * @param request the request
	 * @return true, if is json
	 */
	public static final boolean isJson(HttpServletRequest request) {
//		if(isJsonExtension(request) || isJsonAccept(request) || isJsonBody(request) || isJsonErrorAccept(request)) {
		if(isJsonExtension(request) || isJsonAccept(request) || isJsonBody(request)) {
			return true;
		}
		return false;
	}

	/**
	 * To json.
	 *
	 * @param obj the obj
	 * @return the string
	 */
	public static final String toJson(Object obj) {
		try {
			return objectMapper.writeValueAsString(obj);
		} catch (JsonProcessingException e) {
			throw new BaseException(e);
		}
	}

	/**
	 * To format json.
	 *
	 * @param obj the obj
	 * @return the string
	 */
	public static final String toFormatJson(Object obj) {
		try {
			return objectMapperFormat.writeValueAsString(obj);
		} catch (JsonProcessingException e) {
			throw new BaseException(e);
		}
	}

	/**
	 * To object.
	 *
	 * @param <T> the generic type
	 * @param json the json
	 * @param clazz the clazz
	 * @return the t
	 */
	public static final <T> T toObject(String json, Class<T> clazz) {
		try {
			return objectMapper.readValue(json, clazz);
		} catch (Exception e) {
			throw new BaseException(e);
		}
	}

	/**
	 * Convert value.
	 *
	 * @param <T> the generic type
	 * @param fromValue the from value
	 * @param toValueType the to value type
	 * @return the t
	 */
	public static final <T> T convertValue(Object fromValue, Class<T> toValueType) {
		return objectMapper.convertValue(fromValue, toValueType);
	}

}
