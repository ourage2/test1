package com.enpem.web.common.util;

import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.enpem.web.common.constants.CmnConst;
import com.enpem.web.common.data.Box;
import com.enpem.web.common.exception.BaseException;

public class ParamUtil {

	private static final String PARAM_PATTEN_REGEX = "^(.*)=(.*)$";
	private static final Pattern PARAM_PATTEN = Pattern.compile(PARAM_PATTEN_REGEX, Pattern.MULTILINE);

	/**
	 * Gets the param.
	 *
	 * @param params the params
	 * @param isUrlEncoding the is url encoding
	 * @param charset the charset
	 * @return the param
	 */
	public static String getParam(Map<?, ?> params, boolean isUrlEncoding, String charset) {
		return getParam("&", params, isUrlEncoding, charset);
	}

	/**
	 * Gets the param.
	 *
	 * @param params the params
	 * @param isUrlEncoding the is url encoding
	 * @return the param
	 */
	public static String getParam(Map<?, ?> params, boolean isUrlEncoding) {
		return getParam("&", params, isUrlEncoding, CmnConst.CHARSET);
	}

	/**
	 * Gets the param.
	 *
	 * @param params the params
	 * @return the param
	 */
	public static String getParam(Map<?, ?> params) {
		return getParam("&", params, false, CmnConst.CHARSET);
	}

	/**
	 * Gets the param html.
	 *
	 * @param params the params
	 * @param isUrlEncoding the is url encoding
	 * @param charset the charset
	 * @return the param html
	 */
	public static String getParamHtml(Map<?, ?> params, boolean isUrlEncoding, String charset) {
		return getParam("&amp;", params, isUrlEncoding, charset);
	}

	/**
	 * Gets the param html.
	 *
	 * @param params the params
	 * @param isUrlEncoding the is url encoding
	 * @return the param html
	 */
	public static String getParamHtml(Map<?, ?> params, boolean isUrlEncoding) {
		return getParam("&amp;", params, isUrlEncoding, CmnConst.CHARSET);
	}

	/**
	 * Gets the param html.
	 *
	 * @param params the params
	 * @return the param html
	 */
	public static String getParamHtml(Map<?, ?> params) {
		return getParam("&amp;", params, false, CmnConst.CHARSET);
	}

	/**
	 * Gets the param.
	 *
	 * @param seperator the seperator
	 * @param params the params
	 * @param isUrlEncoding the is url encoding
	 * @param charset the charset
	 * @return the param
	 */
	private static String getParam(String seperator, Map<?, ?> params, boolean isUrlEncoding, String charset) {
		if(params == null) {
			return "";
		}
		StringBuffer sb = new StringBuffer();
		try {
			Iterator<?> iter = params.keySet().iterator();
			String key = null;
			String value = null;
			while (iter.hasNext()) {
				key = String.valueOf(iter.next());
				value = String.valueOf(params.get(key));
				if (StringUtil.isNotEmpty(value)) {
					sb.append(key)
					  .append("=");
					if(isUrlEncoding) {
						sb.append(URLEncoder.encode(value, charset));
					} else {
						sb.append(value);
					}
					sb.append(seperator);
				}
			}
		} catch (Exception e) {
			throw new BaseException(e);
		}
		return sb.toString().replaceAll(seperator+"$", "");
	}

	/**
	 * Gets the param map.
	 *
	 * @param params the params
	 * @param update the update
	 * @return the param map
	 */
	public static Map<String, Object> getParamMap(Map<String, Object> params, String update) {
		if(params == null) {
			return params;
		}
		if(StringUtil.isNotEmpty(update)) {
			String newParam = update.replaceAll("^\\?", "");
			String newParamToken[] = newParam.split("&");
			int newParamTokenCnt = newParamToken.length;
			Matcher newParamMatcher = null;
			String newParamName = null;
			String newParamValue = null;
			for(int i=0; i<newParamTokenCnt; i++) {
				newParamMatcher = PARAM_PATTEN.matcher(newParamToken[i]);
				newParamName = newParamMatcher.replaceAll("$1");
				if(StringUtil.isNotEmpty(newParamName)) {
					newParamValue = newParamMatcher.replaceAll("$2");
					if(StringUtil.isEmpty(newParamValue)) {
						params.remove(newParamName);
					} else {
						params.put(newParamName, newParamValue);
					}
				}
			}
		}
		return params;
	}

	/**
	 * Gets the param.
	 *
	 * @param params the params
	 * @param update the update
	 * @return the param
	 */
	public static String getParam(Map<String, Object> params, String update) {
		if(params == null) {
			return "";
		}
		params = getParamMap(params, update);
		return getParam(params);
	}

	/**
	 * Gets the param html.
	 *
	 * @param params the params
	 * @param update the update
	 * @return the param html
	 */
	public static String getParamHtml(Map<String, Object> params, String update) {
		if(params == null) {
			return "";
		}
		params = getParamMap(params, update);
		return getParamHtml(params);
	}

	/**
	 * Select param map.
	 *
	 * @param params the params
	 * @param keys the keys
	 * @return the map
	 */
	public static Map<String, Object> selectParamMap(Map<String, Object> params, String...keys) {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		if(keys != null) {
			Object value = null;
			for(String key : keys) {
				value = params.get(key);
				if(value != null) {
					if(value instanceof String) {
						paramMap.put(key, value);
					}
				}
			}
		}
		return paramMap;
	}

	/**
	 * Select param.
	 *
	 * @param params the params
	 * @param keys the keys
	 * @return the string
	 */
	public static String selectParam(Map<String, Object> params, String...keys) {
		Map<String, Object> paramMap = selectParamMap(params, keys);
		return getParam(paramMap);
	}

	/**
	 * Parses the param map.
	 *
	 * @param param the param
	 * @param params the params
	 * @return the map
	 */
	public static Map<String, Object> parseParamMap(String param, Map<String, Object> params) {
		if(params == null) {
			params = new HashMap<String, Object>();
		}
		if(StringUtil.isNotEmpty(param)) {
			String newParam = param.replaceAll("^\\?", "");
			String newParamToken[] = newParam.split("&");
			int newParamTokenCnt = newParamToken.length;
			Matcher newParamMatcher = null;
			String newParamName = null;
			String newParamValue = null;
			for(int i=0; i<newParamTokenCnt; i++) {
				newParamMatcher = PARAM_PATTEN.matcher(newParamToken[i]);
				newParamName = newParamMatcher.replaceAll("$1");
				if(StringUtil.isNotEmpty(newParamName)) {
					newParamValue = newParamMatcher.replaceAll("$2");
					if(StringUtil.isEmpty(newParamValue)) {
						params.remove(newParamName);
					} else {
						params.put(newParamName, newParamValue);
					}
				}
			}
		}
		return params;
	}

	/**
	 * Parses the param box.
	 *
	 * @param param the param
	 * @return the box
	 */
	public static Box parseParamBox(String param) {
		Box params = new Box();
		parseParamMap(param, params);
		return params;
	}

}
