package com.enpem.web.common.util;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.InetAddress;
import java.net.MalformedURLException;
import java.net.NetworkInterface;
import java.net.URI;
import java.net.URL;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.http.Header;
import org.apache.http.NameValuePair;
import org.apache.http.client.utils.URIBuilder;
import org.apache.http.message.BasicNameValuePair;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.util.UrlPathHelper;

import com.enpem.web.common.data.Box;
import com.enpem.web.common.exception.BaseException;

public class HttpUtil {

	protected static Logger log = LoggerFactory.getLogger(HttpUtil.class);

	/**
	 * Gets the context path.
	 *
	 * @param request the request
	 * @return the context path
	 */
	public static String getContextPath(HttpServletRequest request) {
		return request.getContextPath();
	}

	/**
	 * Gets the request url.
	 *
	 * @param request the request
	 * @return the request url
	 */
	public static String getRequestURL(HttpServletRequest request) {
		return request.getRequestURL().toString();
	}

	public static String getOrgRequestUri(HttpServletRequest request) throws Exception {
		return new UrlPathHelper().getOriginatingRequestUri(request);
	}

	public static String getRequestUri(HttpServletRequest request) throws Exception {
		String contextPath = request.getContextPath();
		String requestUri = getOrgRequestUri(request);
		if(StringUtil.isNotEmpty(contextPath)) {
			requestUri = requestUri.substring(contextPath.length());
		}
		return requestUri;
	}

	/**
	 * Checks if is multipart.
	 *
	 * @param request the request
	 * @return true, if is multipart
	 */
	public static final boolean isMultipart(HttpServletRequest request) {
		String contentType = request.getContentType();
		if(contentType != null && contentType.toLowerCase().startsWith("multipart/form-data")) {
			return true;
		}
		return false;
	}

	/**
	 * Gets the remote addr.
	 *
	 * @param request the request
	 * @return the remote addr
	 */
	public static String getRemoteAddr(HttpServletRequest request) {
		return request.getRemoteAddr();
	}

	/**
	 * Gets the ip addr.
	 *
	 * @param request the request
	 * @return the ip addr
	 */
	public static String getRemoteIpAddr(HttpServletRequest request) {
		String ip = request.getHeader("x-forwarded-for");
		if(StringUtil.isNotEmpty(ip) && !"unknown".equalsIgnoreCase(ip)) {
			int index = ip.indexOf(",");
			if(index != -1) {
				ip = ip.substring(0, index);
			}
			if(ip != null) {
				ip = ip.trim();
			}
			return ip;
		}
		ip = request.getHeader("http_client_ip");
		if (StringUtil.isNotEmpty(ip) && !"unknown".equalsIgnoreCase(ip)) {
			return ip;
		}
		ip = request.getHeader("http_x_forwarded");
		if (StringUtil.isNotEmpty(ip) && !"unknown".equalsIgnoreCase(ip)) {
			return ip;
		}
		ip = request.getHeader("http_x_forwarded_for");
		if (StringUtil.isNotEmpty(ip) && !"unknown".equalsIgnoreCase(ip)) {
			return ip;
		}
		ip = request.getHeader("http_x_cluster_client_ip");
		if (StringUtil.isNotEmpty(ip) && !"unknown".equalsIgnoreCase(ip)) {
			return ip;
		}
		ip = request.getHeader("http_forwarded");
		if (StringUtil.isNotEmpty(ip) && !"unknown".equalsIgnoreCase(ip)) {
			return ip;
		}
		ip = request.getHeader("remote_addr");
		if (StringUtil.isNotEmpty(ip) && !"unknown".equalsIgnoreCase(ip)) {
			return ip;
		}
		ip = request.getHeader("proxy-client-ip");  // weblogic
		if (StringUtil.isNotEmpty(ip) && !"unknown".equalsIgnoreCase(ip)) {
			return ip;
		}
		ip = request.getHeader("wl-proxy-client-ip");  // weblogic
		if (StringUtil.isNotEmpty(ip) && !"unknown".equalsIgnoreCase(ip)) {
			return ip;
		}
		return HttpUtil.getRemoteAddr(request);
	}

	/**
	 * Gets the remote port.
	 *
	 * @param request the request
	 * @return the remote port
	 */
	public static int getServerPort(HttpServletRequest request) {
		String forwardedPort = request.getHeader("x-forwarded-port");
		if(StringUtil.isNotEmpty(forwardedPort) && !"unknown".equalsIgnoreCase(forwardedPort)) {
			int index = forwardedPort.indexOf(",");
			if(index != -1) {
				forwardedPort = forwardedPort.substring(0, index);
			}
			if(forwardedPort != null) {
				forwardedPort = forwardedPort.trim();
			}
			return NumberUtil.toInt(forwardedPort);
		}
		return request.getServerPort();
	}

	/**
	 * Gets the local ip addr.
	 *
	 * @return the local ip addr
	 */
	public static String getLocalIpAddr() {
		String ip = null;
		try {
			Enumeration<NetworkInterface> en = NetworkInterface.getNetworkInterfaces();
			boolean isExit = false;
 			while(en.hasMoreElements()) {
				NetworkInterface ni = en.nextElement();
				if(ni == null || !ni.isUp() || ni.isLoopback() || ni.isVirtual()) {
					continue;
				}
				Enumeration<InetAddress> inetAddresses = ni.getInetAddresses();
				while(inetAddresses.hasMoreElements()) {
					InetAddress ia = inetAddresses.nextElement();
					if(ia.isLoopbackAddress() || ia.isLinkLocalAddress()) {
						continue;
					}
					if(ia.isSiteLocalAddress()) {
						return ia.getHostAddress();
					}
					if(ia.getHostAddress() != null && ia.getHostAddress().indexOf(".") != -1) {
						ip = ia.getHostAddress();
						isExit = true;
						break;
					}
				}
				if(isExit) {
					break;
				}
			}
		} catch (Exception e) {
			log.error("error : {}", e.getMessage());
		}
		return ip;
	}

	/**
	 * Gets the header to map.
	 *
	 * @param headers the headers
	 * @return the header to map
	 */
	public static Map<String, Object> getHeaderToMap(Header[] headers) {
		Map<String, Object> headerMap = null;
		if(headers != null) {
			headerMap = new HashMap<String, Object>();
			String key = null, value = null;
			for(Header header : headers) {
				key = header.getName();
				if(StringUtil.isNotEmpty(key)) {
					value = header.getValue();
					headerMap.put(key.toLowerCase(), value);
				}
			}
		}
		return headerMap;
	}

	/**
	 * Gets the header to box.
	 *
	 * @param headers the headers
	 * @return the header to box
	 */
	public static Box getHeaderToBox(Header[] headers) {
		Map<String, Object> headerMap = getHeaderToMap(headers);
		Box headerBox = null;
		if(headerMap != null) {
			headerBox = new Box(headerMap);
		}
		return headerBox;
	}

	/**
	 * Gets the header to map.
	 *
	 * @param request the request
	 * @return the header to map
	 */
	public static Map<String, Object> getHeaderToMap(HttpServletRequest request) {
		Map<String, Object> headerMap = null;
		if(request != null) {
			headerMap = new HashMap<String, Object>();
			Enumeration<String> headerNames = request.getHeaderNames();
			String key = null, value = null;
			while(headerNames.hasMoreElements()) {
				key = headerNames.nextElement();
				value = request.getHeader(key);
				if(StringUtil.isNotEmpty(value)) {
					headerMap.put(key.toLowerCase(), value);
				}
			}
		}
		return headerMap;
	}

	/**
	 * Gets the header to box.
	 *
	 * @param request the request
	 * @return the header to box
	 */
	public static Box getHeaderToBox(HttpServletRequest request) {
		Map<String, Object> headerMap = getHeaderToMap(request);
		Box headerBox = null;
		if(headerMap != null) {
			headerBox = new Box(headerMap);
		}
		return headerBox;
	}

	/**
	 * Gets the header to json.
	 *
	 * @param headers the headers
	 * @return the header to json
	 */
	public static String getHeaderToJson(Header[] headers) {
		String json = null;
		try {
			Map<String, Object> headerMap = getHeaderToMap(headers);
			if(headerMap == null || headerMap.isEmpty()) {
				return "";
			}
			json = JsonUtil.toFormatJson(headerMap);
		} catch (Exception e) {
			log.error("{}", e);
		}
		return json;
	}

	/**
	 * Gets the header to json.
	 *
	 * @param request the request
	 * @return the header to json
	 */
	public static String getHeaderToJson(HttpServletRequest request) {
		String json = null;
		try {
			Map<String, Object> headerMap = getHeaderToMap(request);
			if(headerMap == null || headerMap.isEmpty()) {
				return "";
			}
			json = JsonUtil.toFormatJson(headerMap);
		} catch (Exception e) {
			log.error("{}", e);
		}
		return json;
	}

	/**
	 * Gets the header to map.
	 *
	 * @param response the response
	 * @return the header to map
	 */
	public static Map<String, Object> getHeaderToMap(HttpServletResponse response) {
		Map<String, Object> headerMap = null;
		if(response != null) {
			headerMap = new HashMap<String, Object>();
			Iterator<String> iter = response.getHeaderNames().iterator();
			String key = null, value = null;
			while(iter.hasNext()) {
				key = iter.next();
				value = response.getHeader(key);
				if(StringUtil.isNotEmpty(value)) {
					headerMap.put(key.toLowerCase(), value);
				}
			}
			String contentType = response.getContentType();
			if(StringUtil.isNotEmpty(contentType)) {
				headerMap.put("content-type", contentType);
			}
		}
		return headerMap;
	}

	/**
	 * Gets the header to json.
	 *
	 * @param response the response
	 * @param isFormat the is format
	 * @return the header to json
	 */
	private static String getHeaderToJson(HttpServletResponse response, boolean isFormat) {
		String json = null;
		try {
			Map<String, Object> headerMap = getHeaderToMap(response);
			if(headerMap == null || headerMap.isEmpty()) {
				return "";
			}
			if(isFormat) {
				json = JsonUtil.toFormatJson(headerMap);
			} else {
				json = JsonUtil.toJson(headerMap);
			}
		} catch (Exception e) {
			log.error("{}", e);
		}
		return json;
	}

	/**
	 * Gets the header to json.
	 *
	 * @param response the response
	 * @return the header to json
	 */
	public static String getHeaderToJson(HttpServletResponse response) {
		return getHeaderToJson(response, false);
	}

	/**
	 * Gets the header to format json.
	 *
	 * @param response the response
	 * @return the header to format json
	 */
	public static String getHeaderToFormatJson(HttpServletResponse response) {
		return getHeaderToJson(response, true);
	}

	/**
	 * Gets the parameter to map.
	 *
	 * @param request the request
	 * @return the parameter to map
	 */
	public static Box getParameterToBox(HttpServletRequest request) {
		Box paramBox = null;
		if(request != null) {
			paramBox = new Box();
			Enumeration<String> enumeration = request.getParameterNames();
			String key = null;
			String[] values = null;
			while (enumeration.hasMoreElements()) {
				key = enumeration.nextElement();
				values = request.getParameterValues(key);
				if (values != null) {
					try {
						if(values.length > 1) {
							paramBox.put(key, values);
						} else {
							paramBox.put(key, values[0]);
						}
					} catch (Exception e) {
						throw new BaseException(e);
					}
				}
			}
		}
		return paramBox;
	}

	/**
	 * Gets the parameter to json.
	 *
	 * @param request the request
	 * @return the parameter to json
	 */
	public static String getParameterToJson(HttpServletRequest request) {
		String json = null;
		try {
			Box paramBox = getParameterToBox(request);
			if(paramBox == null || paramBox.isEmpty()) {
				return "";
			}
			json = JsonUtil.toFormatJson(paramBox);
		} catch (Exception e) {
			log.error("{}", e);
		}
		return json;
	}

	/**
	 * Gets the box to name value pair.
	 *
	 * @param rqtParamBox the box
	 * @return the box to name value pair
	 */
	public static List<NameValuePair> getBoxToNameValuePair(Box rqtParamBox) {
		if(rqtParamBox == null || rqtParamBox.isEmpty()) {
			return null;
		}
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		Iterator<String> paramIter = rqtParamBox.keySet().iterator();
		String key = null, value = null;
		while(paramIter.hasNext()) {
			key = paramIter.next();
			if(StringUtil.isNotEmpty(key)) {
				value = rqtParamBox.getParameter(key, "");
				paramList.add(new BasicNameValuePair(key, value));
			}
		}
		return paramList;
	}

	/**
	 * Rebuild uri.
	 *
	 * @param uri the uri
	 * @param rqtParamBox the rqt param box
	 * @param encoding the encoding
	 * @return the uri
	 */
	public static URI rebuildUri(URI uri, Box rqtParamBox, String encoding) {
		if(uri == null) {
			throw new BaseException("URI is null");
		}
		if(rqtParamBox == null || rqtParamBox.isEmpty()) {
			return uri;
		}
		try {
			URIBuilder uriBuilder = new URIBuilder(uri);
//			uriBuilder.setCharset(Charset.forName(encoding));
			Iterator<String> paramIter = rqtParamBox.keySet().iterator();
			String key = null, value = null;
			while(paramIter.hasNext()) {
				key = paramIter.next();
//				value = URLEncoder.encode(rqtParamBox.getParameter(key, ""), encoding);
				value = rqtParamBox.getParameter(key, "");
				uriBuilder.setParameter(key, value);
			}
			return uriBuilder.build();
		} catch (Exception e) {
			throw new BaseException(e);
		}
	}

	/**
	 * Gets the url.
	 *
	 * @param scheme the scheme
	 * @param host the host
	 * @param port the port
	 * @param path the path
	 * @param rqtParamBox the rqt param box
	 * @return the url
	 */
	public static String getUrl(String scheme, String host, int port, String path, Box rqtParamBox) {
		String url = null;
		try {
			URIBuilder uriBuilder = new URIBuilder();
			if(StringUtil.isNotEmpty(scheme)) {
				uriBuilder.setScheme(scheme);
			}
			if(StringUtil.isNotEmpty(host)) {
				uriBuilder.setHost(host);
			}
			if(port > 0) {
				uriBuilder.setPort(port);
			}
			if(StringUtil.isNotEmpty(path)) {
				uriBuilder.setPath(path);
			}
			List<NameValuePair> paramList = getBoxToNameValuePair(rqtParamBox);
			if(paramList != null) {
				uriBuilder.setParameters(paramList);
			}
			url = uriBuilder.build().toString();
		} catch (Exception e) {
			return url;
		}
		return url;
	}

	/**
	 * Gets the url.
	 *
	 * @param scheme the scheme
	 * @param host the host
	 * @param port the port
	 * @param path the path
	 * @return the url
	 */
	public static String getUrl(String scheme, String host, int port, String path) {
		return getUrl(scheme, host, port, path, null);
	}

	/**
	 * Gets the url.
	 *
	 * @param scheme the scheme
	 * @param host the host
	 * @param path the path
	 * @return the url
	 */
	public static String getUrl(String scheme, String host, String path) {
		return getUrl(scheme, host, 0, path, null);
	}

	/**
	 * Gets the referer url.
	 *
	 * @param request the request
	 * @return the referer url
	 */
	public static String getRefererURL(HttpServletRequest request) {
		return request.getHeader("referer");
	}

	/**
	 * Gets the referer uri.
	 *
	 * @param request the request
	 * @return the referer uri
	 */
	public static String getRefererUri(HttpServletRequest request) {
		String refererUrl = HttpUtil.getRefererURL(request);
		if(StringUtil.isNotEmpty(refererUrl)) {
			int idx = -1;
			String contextPath = HttpUtil.getContextPath(request);
			if(StringUtil.isNotEmpty(contextPath)) {
				idx = refererUrl.indexOf(contextPath);
			} else {
				idx = refererUrl.indexOf("/", request.getScheme().length() + 3);
			}
			if(idx > -1) {
				return refererUrl.substring(idx);
			}
		}
		return null;
	}

	/**
	 * Gets the referer path.
	 *
	 * @param request the request
	 * @return the referer path
	 */
	public static String getRefererPath(HttpServletRequest request) {
		String refererUrl = HttpUtil.getRefererURL(request);
		if(StringUtil.isNotEmpty(refererUrl)) {
			int idx = -1;
			String contextPath = HttpUtil.getContextPath(request);
			if(StringUtil.isNotEmpty(contextPath)) {
				idx = refererUrl.indexOf(contextPath);
				if(idx != -1) {
					idx += contextPath.length();
				}
			} else {
				idx = refererUrl.indexOf("/", request.getScheme().length() + 3);
			}
			if(idx > -1) {
				return refererUrl.substring(idx);
			}
		}
		return null;
	}

	public static Map<String, Object> getParameterToMap(HttpServletRequest request) {
		Map<String, Object> paramMap = null;
		if(request != null) {
			paramMap = new HashMap<String, Object>();
			Enumeration<String> enumeration = request.getParameterNames();
			String key, value;
			while (enumeration.hasMoreElements()) {
				key = enumeration.nextElement();
				value = request.getParameter(key);
				if(StringUtil.isNotEmpty(value)) {
					paramMap.put(key, value);
				}
			}
		}
		return paramMap;
	}

	/**
     * 태그제거
     */
	public static String setHtmlToText(String content, int len) throws Exception {
		String rContent = content;

		try{
			Pattern SCRIPTS = Pattern.compile("<(no)?script[^>]*>.*?</(no)?script>",Pattern.DOTALL);
			Pattern STYLE = Pattern.compile("<STYLE[^>]*>.*?</STYLE>",Pattern.DOTALL);
			Pattern TAGS = Pattern.compile("<(\"[^\"]*\"|\'[^\']*\'|[^\'\">])*>");
			//Pattern nTAGS = Pattern.compile("<\\w+\\s+[^<]*\\s*>");
			Pattern ENTITY_REFS = Pattern.compile("&[^;]+;");
			Pattern WHITESPACE = Pattern.compile("\\s\\s+");

			Matcher m;

			m = SCRIPTS.matcher(rContent);
			rContent = m.replaceAll("");
			m = STYLE.matcher(rContent);
			rContent = m.replaceAll("");
			m = TAGS.matcher(rContent);
			rContent = m.replaceAll("");
			m = ENTITY_REFS.matcher(rContent);
			rContent = m.replaceAll("");
			m = WHITESPACE.matcher(rContent);
			rContent = m.replaceAll("");
		} catch (Exception e) {
			e.printStackTrace();
			//log.debug(e.getMessage());
		}

		return (rContent.length() > len ? rContent.substring(0, len)+"..." : rContent );
	}

	public static String setHtmlToText(String content) {
		if (null == content) { return null; } //null일경우 리턴

		String target = content.replaceAll("\\<.*?\\>", "");
		target = target.replaceAll("\r\n", " ");
		target = target.replaceAll("\r", " ");

		Pattern p = Pattern.compile("&[^;]+;");
		Matcher m = p.matcher(target);

		StringBuilder sb = new StringBuilder();

		int previous = 0;

		boolean result = m.find();
		while (result) {

			//String matchStr = target.substring(m.start(), m.end());
			String replaceStr = matchMap.get(target.substring(m.start(), m.end()));
			//System.out.println(matchStr + ", " + replaceStr);

			sb.append(target.substring(previous, m.start()));
			sb.append(replaceStr == null ? " " : replaceStr);
			previous = m.end();
			result = m.find();
		}
		sb.append(target.substring(previous));

		return sb.toString();

	}

	private static Map<String, String> matchMap = new HashMap<String, String>();

	static {
		//ASCII Entities with Entity Names
		matchMap.put("&#34;", "\"");   matchMap.put("&quot;", "\"");
		matchMap.put("&#39;", "’");	   matchMap.put("&apos; (does not work in IE)", "’");
		matchMap.put("&#38;", "&");   matchMap.put("&amp;", "&");
		matchMap.put("&#60;", "<");   matchMap.put("&lt;", "<");
		matchMap.put("&#62;", ">");   matchMap.put("&gt;", ">");

		//ISO 8859-1 Symbol Entities
		matchMap.put("&#160;", " ");   matchMap.put("&nbsp;", " ");
		matchMap.put("&#161;", "¡");   matchMap.put("&iexcl;", "¡");
		matchMap.put("&#162;", "¢");   matchMap.put("&cent;", "¢");
		matchMap.put("&#163;", "£");   matchMap.put("&pound;", "£");
		matchMap.put("&#164;", "¤");   matchMap.put("&curren;", "¤");
		matchMap.put("&#165;", "¥");   matchMap.put("&yen;", "¥");
		matchMap.put("&#166;", "¦");   matchMap.put("&brvbar;", "¦");
		matchMap.put("&#167;", "§");   matchMap.put("&sect;", "§");
		matchMap.put("&#168;", "¨");   matchMap.put("&uml;", "¨");
		matchMap.put("&#169;", "©");   matchMap.put("&copy;", "©");
		matchMap.put("&#170;", "ª");   matchMap.put("&ordf;", "ª");
		matchMap.put("&#171;", "«");   matchMap.put("&laquo;", "«");
		matchMap.put("&#172;", "¬");   matchMap.put("&not;", "¬");
		matchMap.put("&#173;", "");   matchMap.put("&shy;", "");
		matchMap.put("&#174;", "®");   matchMap.put("&reg;", "®");
		matchMap.put("&#175;", "¯");   matchMap.put("&macr;", "¯");
		matchMap.put("&#176;", "°");   matchMap.put("&deg;", "°");
		matchMap.put("&#177;", "±");   matchMap.put("&plusmn;", "±");
		matchMap.put("&#178;", "²");   matchMap.put("&sup2;", "²");
		matchMap.put("&#179;", "³");   matchMap.put("&sup3;", "³");
		matchMap.put("&#180;", "´");   matchMap.put("&acute;", "´");
		matchMap.put("&#181;", "µ");   matchMap.put("&micro;", "µ");
		matchMap.put("&#182;", "¶");   matchMap.put("&para;", "¶");
		matchMap.put("&#183;", "·");   matchMap.put("&middot;", "·");
		matchMap.put("&#184;", "¸");   matchMap.put("&cedil;", "¸");
		matchMap.put("&#185;", "¹");   matchMap.put("&sup1;", "¹");
		matchMap.put("&#186;", "º");   matchMap.put("&ordm;", "º");
		matchMap.put("&#187;", "»");   matchMap.put("&raquo;", "»");
		matchMap.put("&#188;", "¼");   matchMap.put("&frac14;", "¼");
		matchMap.put("&#189;", "½");   matchMap.put("&frac12;", "½");
		matchMap.put("&#190;", "¾");   matchMap.put("&frac34;", "¾");
		matchMap.put("&#191;", "¿");   matchMap.put("&iquest;", "¿");
		matchMap.put("&#215;", "×");   matchMap.put("&times;", "×");
		matchMap.put("&#247;", "÷");   matchMap.put("&divide;", "÷");

		//ISO 8859-1 Character Entities
		matchMap.put("&#192;", "À");   matchMap.put("&Agrave;", "À");
		matchMap.put("&#193;", "Á");   matchMap.put("&Aacute;", "Á");
		matchMap.put("&#194;", "Â");   matchMap.put("&Acirc;", "Â");
		matchMap.put("&#195;", "Ã");   matchMap.put("&Atilde;", "Ã");
		matchMap.put("&#196;", "Ä");   matchMap.put("&Auml;", "Ä");
		matchMap.put("&#197;", "Å");   matchMap.put("&Aring;", "Å");
		matchMap.put("&#198;", "Æ");   matchMap.put("&AElig;", "Æ");
		matchMap.put("&#199;", "Ç");   matchMap.put("&Ccedil;", "Ç");
		matchMap.put("&#200;", "È");   matchMap.put("&Egrave;", "È");
		matchMap.put("&#201;", "É");   matchMap.put("&Eacute;", "É");
		matchMap.put("&#202;", "Ê");   matchMap.put("&Ecirc;", "Ê");
		matchMap.put("&#203;", "Ë");   matchMap.put("&Euml;", "Ë");
		matchMap.put("&#204;", "Ì");   matchMap.put("&Igrave;", "Ì");
		matchMap.put("&#205;", "Í");   matchMap.put("&Iacute;", "Í");
		matchMap.put("&#206;", "Î");   matchMap.put("&Icirc;", "Î");
		matchMap.put("&#207;", "Ï");   matchMap.put("&Iuml;", "Ï");
		matchMap.put("&#208;", "Ð");   matchMap.put("&ETH;", "Ð");
		matchMap.put("&#209;", "Ñ");   matchMap.put("&Ntilde;", "Ñ");
		matchMap.put("&#210;", "Ò");   matchMap.put("&Ograve;", "Ò");
		matchMap.put("&#211;", "Ó");   matchMap.put("&Oacute;", "Ó");
		matchMap.put("&#212;", "Ô");   matchMap.put("&Ocirc;", "Ô");
		matchMap.put("&#213;", "Õ");   matchMap.put("&Otilde;", "Õ");
		matchMap.put("&#214;", "Ö");   matchMap.put("&Ouml;", "Ö");
		matchMap.put("&#216;", "Ø");   matchMap.put("&Oslash;", "Ø");
		matchMap.put("&#217;", "Ù");   matchMap.put("&Ugrave;", "Ù");
		matchMap.put("&#218;", "Ú");   matchMap.put("&Uacute;", "Ú");
		matchMap.put("&#219;", "Û");   matchMap.put("&Ucirc;", "Û");
		matchMap.put("&#220;", "Ü");   matchMap.put("&Uuml;", "Ü");
		matchMap.put("&#221;", "Ý");   matchMap.put("&Yacute;", "Ý");
		matchMap.put("&#222;", "Þ");   matchMap.put("&THORN;", "Þ");
		matchMap.put("&#223;", "ß");   matchMap.put("&szlig;", "ß");
		matchMap.put("&#224;", "à");   matchMap.put("&agrave;", "à");
		matchMap.put("&#225;", "á");   matchMap.put("&aacute;", "á");
		matchMap.put("&#226;", "â");   matchMap.put("&acirc;", "â");
		matchMap.put("&#227;", "ã");   matchMap.put("&atilde;", "ã");
		matchMap.put("&#228;", "ä");   matchMap.put("&auml;", "ä");
		matchMap.put("&#229;", "å");   matchMap.put("&aring;", "å");
		matchMap.put("&#230;", "æ");   matchMap.put("&aelig;", "æ");
		matchMap.put("&#231;", "ç");   matchMap.put("&ccedil;", "ç");
		matchMap.put("&#232;", "è");   matchMap.put("&egrave;", "è");
		matchMap.put("&#233;", "é");   matchMap.put("&eacute;", "é");
		matchMap.put("&#234;", "ê");   matchMap.put("&ecirc;", "ê");
		matchMap.put("&#235;", "ë");   matchMap.put("&euml;", "ë");
		matchMap.put("&#236;", "ì");   matchMap.put("&igrave;", "ì");
		matchMap.put("&#237;", "í");   matchMap.put("&iacute;", "í");
		matchMap.put("&#238;", "î");   matchMap.put("&icirc;", "î");
		matchMap.put("&#239;", "ï");   matchMap.put("&iuml;", "ï");
		matchMap.put("&#240;", "ð");   matchMap.put("&eth;", "ð");
		matchMap.put("&#241;", "ñ");   matchMap.put("&ntilde;", "ñ");
		matchMap.put("&#242;", "ò");   matchMap.put("&ograve;", "ò");
		matchMap.put("&#243;", "ó");   matchMap.put("&oacute;", "ó");
		matchMap.put("&#244;", "ô");   matchMap.put("&ocirc;", "ô");
		matchMap.put("&#245;", "õ");   matchMap.put("&otilde;", "õ");
		matchMap.put("&#246;", "ö");   matchMap.put("&ouml;", "ö");
		matchMap.put("&#248;", "ø");   matchMap.put("&oslash;", "ø");
		matchMap.put("&#249;", "ù");   matchMap.put("&ugrave;", "ù");
		matchMap.put("&#250;", "ú");   matchMap.put("&uacute;", "ú");
		matchMap.put("&#251;", "û");   matchMap.put("&ucirc;", "û");
		matchMap.put("&#252;", "ü");   matchMap.put("&uuml;", "ü");
		matchMap.put("&#253;", "ý");   matchMap.put("&yacute;", "ý");
		matchMap.put("&#254;", "þ");   matchMap.put("&thorn;", "þ");
		matchMap.put("&#255;", "ÿ");   matchMap.put("&yuml;", "ÿ");

		//Math Symbols Supported by HTML
		matchMap.put("&#8704;", "∀");   matchMap.put("&forall;", "∀");
		matchMap.put("&#8706;", "∂");   matchMap.put("&part;", "∂");
		matchMap.put("&#8707;", "∃");   matchMap.put("&exists;", "∃");
		matchMap.put("&#8709;", "∅");   matchMap.put("&empty;", "∅");
		matchMap.put("&#8711;", "∇");   matchMap.put("&nabla;", "∇");
		matchMap.put("&#8712;", "∈");   matchMap.put("&isin;", "∈");
		matchMap.put("&#8713;", "∉");   matchMap.put("&notin;", "∉");
		matchMap.put("&#8715;", "∋");   matchMap.put("&ni;", "∋");
		matchMap.put("&#8719;", "∏");   matchMap.put("&prod;", "∏");
		matchMap.put("&#8721;", "∑");   matchMap.put("&sum;", "∑");
		matchMap.put("&#8722;", "−");   matchMap.put("&minus;", "−");
		matchMap.put("&#8727;", "∗");   matchMap.put("&lowast;", "∗");
		matchMap.put("&#8730;", "√");   matchMap.put("&radic;", "√");
		matchMap.put("&#8733;", "∝");   matchMap.put("&prop;", "∝");
		matchMap.put("&#8734;", "∞");   matchMap.put("&infin;", "∞");
		matchMap.put("&#8736;", "∠");   matchMap.put("&ang;", "∠");
		matchMap.put("&#8743;", "∧");   matchMap.put("&and;", "∧");
		matchMap.put("&#8744;", "∨");   matchMap.put("&or;", "∨");
		matchMap.put("&#8745;", "∩");   matchMap.put("&cap;", "∩");
		matchMap.put("&#8746;", "∪");   matchMap.put("&cup;", "∪");
		matchMap.put("&#8747;", "∫");   matchMap.put("&int;", "∫");
		matchMap.put("&#8756;", "∴");   matchMap.put("&there4;", "∴");
		matchMap.put("&#8764;", "∼");   matchMap.put("&sim;", "∼");
		matchMap.put("&#8773;", "≅");   matchMap.put("&cong;", "≅");
		matchMap.put("&#8776;", "≈");   matchMap.put("&asymp;", "≈");
		matchMap.put("&#8800;", "≠");   matchMap.put("&ne;", "≠");
		matchMap.put("&#8801;", "≡");   matchMap.put("&equiv;", "≡");
		matchMap.put("&#8804;", "≤");   matchMap.put("&le;", "≤");
		matchMap.put("&#8805;", "≥");   matchMap.put("&ge;", "≥");
		matchMap.put("&#8834;", "⊂");   matchMap.put("&sub;", "⊂");
		matchMap.put("&#8835;", "⊃");   matchMap.put("&sup;", "⊃");
		matchMap.put("&#8836;", "⊄");   matchMap.put("&nsub;", "⊄");
		matchMap.put("&#8838;", "⊆");   matchMap.put("&sube;", "⊆");
		matchMap.put("&#8839;", "⊇");   matchMap.put("&supe;", "⊇");
		matchMap.put("&#8853;", "⊕");   matchMap.put("&oplus;", "⊕");
		matchMap.put("&#8855;", "⊗");   matchMap.put("&otimes;", "⊗");
		matchMap.put("&#8869;", "⊥");   matchMap.put("&perp;", "⊥");
		matchMap.put("&#8901;", "⋅");   matchMap.put("&sdot;", "⋅");

		//Greek Letters Supported by HTML
		matchMap.put("&#913;", "Α");   matchMap.put("&Alpha;", "Α");
		matchMap.put("&#914;", "Β");   matchMap.put("&Beta;", "Β");
		matchMap.put("&#915;", "Γ");   matchMap.put("&Gamma;", "Γ");
		matchMap.put("&#916;", "Δ");   matchMap.put("&Delta;", "Δ");
		matchMap.put("&#917;", "Ε");   matchMap.put("&Epsilon;", "Ε");
		matchMap.put("&#918;", "Ζ");   matchMap.put("&Zeta;", "Ζ");
		matchMap.put("&#919;", "Η");   matchMap.put("&Eta;", "Η");
		matchMap.put("&#920;", "Θ");   matchMap.put("&Theta;", "Θ");
		matchMap.put("&#921;", "Ι");   matchMap.put("&Iota;", "Ι");
		matchMap.put("&#922;", "Κ");   matchMap.put("&Kappa;", "Κ");
		matchMap.put("&#923;", "Λ");   matchMap.put("&Lambda;", "Λ");
		matchMap.put("&#924;", "Μ");   matchMap.put("&Mu;", "Μ");
		matchMap.put("&#925;", "Ν");   matchMap.put("&Nu;", "Ν");
		matchMap.put("&#926;", "Ξ");   matchMap.put("&Xi;", "Ξ");
		matchMap.put("&#927;", "Ο");   matchMap.put("&Omicron;", "Ο");
		matchMap.put("&#928;", "Π");   matchMap.put("&Pi;", "Π");
		matchMap.put("&#929;", "Ρ");   matchMap.put("&Rho;", "Ρ");
		matchMap.put("&#931;", "Σ");   matchMap.put("&Sigma;", "Σ");
		matchMap.put("&#932;", "Τ");   matchMap.put("&Tau;", "Τ");
		matchMap.put("&#933;", "Υ");   matchMap.put("&Upsilon;", "Υ");
		matchMap.put("&#934;", "Φ");   matchMap.put("&Phi;", "Φ");
		matchMap.put("&#935;", "Χ");   matchMap.put("&Chi;", "Χ");
		matchMap.put("&#936;", "Ψ");   matchMap.put("&Psi;", "Ψ");
		matchMap.put("&#937;", "Ω");   matchMap.put("&Omega;", "Ω");
		matchMap.put("&#945;", "α");   matchMap.put("&alpha;", "α");
		matchMap.put("&#946;", "β");   matchMap.put("&beta;", "β");
		matchMap.put("&#947;", "γ");   matchMap.put("&gamma;", "γ");
		matchMap.put("&#948;", "δ");   matchMap.put("&delta;", "δ");
		matchMap.put("&#949;", "ε");   matchMap.put("&epsilon;", "ε");
		matchMap.put("&#950;", "ζ");   matchMap.put("&zeta;", "ζ");
		matchMap.put("&#951;", "η");   matchMap.put("&eta;", "η");
		matchMap.put("&#952;", "θ");   matchMap.put("&theta;", "θ");
		matchMap.put("&#953;", "ι");   matchMap.put("&iota;", "ι");
		matchMap.put("&#954;", "κ");   matchMap.put("&kappa;", "κ");
		matchMap.put("&#955;", "λ");   matchMap.put("&lambda;", "λ");
		matchMap.put("&#956;", "μ");   matchMap.put("&mu;", "μ");
		matchMap.put("&#957;", "ν");   matchMap.put("&nu;", "ν");
		matchMap.put("&#958;", "ξ");   matchMap.put("&xi;", "ξ");
		matchMap.put("&#959;", "ο");   matchMap.put("&omicron;", "ο");
		matchMap.put("&#960;", "π");   matchMap.put("&pi;", "π");
		matchMap.put("&#961;", "ρ");   matchMap.put("&rho;", "ρ");
		matchMap.put("&#962;", "ς");   matchMap.put("&sigmaf;", "ς");
		matchMap.put("&#963;", "σ");   matchMap.put("&sigma;", "σ");
		matchMap.put("&#964;", "τ");   matchMap.put("&tau;", "τ");
		matchMap.put("&#965;", "υ");   matchMap.put("&upsilon;", "υ");
		matchMap.put("&#966;", "φ");   matchMap.put("&phi;", "φ");
		matchMap.put("&#967;", "χ");   matchMap.put("&chi;", "χ");
		matchMap.put("&#968;", "ψ");   matchMap.put("&psi;", "ψ");
		matchMap.put("&#969;", "ω");   matchMap.put("&omega;", "ω");
		matchMap.put("&#977;", "ϑ");   matchMap.put("&thetasym;", "ϑ");
		matchMap.put("&#978;", "ϒ");   matchMap.put("&upsih;", "ϒ");
		matchMap.put("&#982;", "ϖ");   matchMap.put("&piv;", "ϖ");
		//Some Other Entities Supported by HTML
		matchMap.put("&#338;", "Œ");   matchMap.put("&OElig;", "Œ");
		matchMap.put("&#339;", "œ");   matchMap.put("&oelig;", "œ");
		matchMap.put("&#352;", "Š");   matchMap.put("&Scaron;", "Š");
		matchMap.put("&#353;", "š");   matchMap.put("&scaron;", "š");
		matchMap.put("&#376;", "Ÿ");   matchMap.put("&Yuml;", "Ÿ");
		matchMap.put("&#402;", "ƒ");   matchMap.put("&fnof;", "ƒ");
		matchMap.put("&#710;", "ˆ");   matchMap.put("&circ;", "ˆ");
		matchMap.put("&#732;", "˜");   matchMap.put("&tilde;", "˜");
		matchMap.put("&#8194;", " ");   matchMap.put("&ensp;", " ");
		matchMap.put("&#8195;", " ");   matchMap.put("&emsp;", " ");
		matchMap.put("&#8201;", " ");   matchMap.put("&thinsp;", " ");
		matchMap.put("&#8204;", "‌");   matchMap.put("&zwnj;", "‌");
		matchMap.put("&#8205;", "‍");   matchMap.put("&zwj;", "‍");
		matchMap.put("&#8206;", "‎");   matchMap.put("&lrm;", "‎");
		matchMap.put("&#8207;", "‏");   matchMap.put("&rlm;", "‏");
		matchMap.put("&#8211;", "–");   matchMap.put("&ndash;", "–");
		matchMap.put("&#8212;", "—");   matchMap.put("&mdash;", "—");
		matchMap.put("&#8216;", "‘");   matchMap.put("&lsquo;", "‘");
		matchMap.put("&#8217;", "’");   matchMap.put("&rsquo;", "’");
		matchMap.put("&#8218;", "‚");   matchMap.put("&sbquo;", "‚");
		matchMap.put("&#8220;", "“");   matchMap.put("&ldquo;", "“");
		matchMap.put("&#8221;", "”");   matchMap.put("&rdquo;", "”");
		matchMap.put("&#8222;", "„");   matchMap.put("&bdquo;", "„");
		matchMap.put("&#8224;", "†");   matchMap.put("&dagger;", "†");
		matchMap.put("&#8225;", "‡");   matchMap.put("&Dagger;", "‡");
		matchMap.put("&#8226;", "•");   matchMap.put("&bull;", "•");
		matchMap.put("&#8230;", "…");   matchMap.put("&hellip;", "…");
		matchMap.put("&#8240;", "‰");   matchMap.put("&permil;", "‰");
		matchMap.put("&#8242;", "′");   matchMap.put("&prime;", "′");
		matchMap.put("&#8243;", "″");   matchMap.put("&Prime;", "″");
		matchMap.put("&#8249;", "‹");   matchMap.put("&lsaquo;", "‹");
		matchMap.put("&#8250;", "›");   matchMap.put("&rsaquo;", "›");
		matchMap.put("&#8254;", "‾");   matchMap.put("&oline;", "‾");
		matchMap.put("&#8364;", "€");   matchMap.put("&euro;", "€");
		matchMap.put("&#8482;", "™");   matchMap.put("&trade;", "™");
		matchMap.put("&#8592;", "←");   matchMap.put("&larr;", "←");
		matchMap.put("&#8593;", "↑");   matchMap.put("&uarr;", "↑");
		matchMap.put("&#8594;", "→");   matchMap.put("&rarr;", "→");
		matchMap.put("&#8595;", "↓");   matchMap.put("&darr;", "↓");
		matchMap.put("&#8596;", "↔");   matchMap.put("&harr;", "↔");
		matchMap.put("&#8629;", "↵");   matchMap.put("&crarr;", "↵");
		matchMap.put("&#8968;", "⌈");   matchMap.put("&lceil;", "⌈");
		matchMap.put("&#8969;", "⌉");   matchMap.put("&rceil;", "⌉");
		matchMap.put("&#8970;", "⌊");   matchMap.put("&lfloor;", "⌊");
		matchMap.put("&#8971;", "⌋");   matchMap.put("&rfloor;", "⌋");
		matchMap.put("&#9674;", "◊");   matchMap.put("&loz;", "◊");
		matchMap.put("&#9824;", "♠");   matchMap.put("&spades;", "♠");
		matchMap.put("&#9827;", "♣");   matchMap.put("&clubs;", "♣");
		matchMap.put("&#9829;", "♥");   matchMap.put("&hearts;", "♥");
		matchMap.put("&#9830;", "♦");   matchMap.put("&diams;", "♦");

		matchMap.put("&#44;", ",");		matchMap.put("&#47;", "/");

	}

	/**
	 * URL존재여부 체크
	 *
	 * @param urlPath
	 * @return true:존재하는 URL, false:존재하지 않는 URL
	 */
	public static boolean isUrlExist(String urlPath){
		boolean isExist = false;
		URL url = null;
		HttpURLConnection conn = null;

		if( "".equals( StringUtil.nvl(urlPath) ) || "9999".equals( StringUtil.nvl(urlPath) ) ){
			isExist = false;
		} else {

			try {

				if( !urlPath.startsWith("http://") && !urlPath.startsWith("https://") ){
					urlPath = "http://" + urlPath;
				}

				if( urlPath.startsWith("https://") ){
					urlPath = urlPath.replace("https://", "http://");
				}

				url = new URL( urlPath );

				conn = (HttpURLConnection) url.openConnection();
				conn.connect();

				if( conn.getResponseCode() == 200 ){
					isExist = true;
				} else {
					isExist = false;
				}

			} catch (MalformedURLException e) {
				isExist = false;
			} catch (IOException e) {
				isExist = false;
			} finally {
				conn.disconnect();
			}
		}

		return isExist;
	}

	/**
	 * Check html extension.
	 *
	 * @param request the request
	 * @return true, if is json extension
	 */
	public static final boolean isFrmExtension() {
		String uri = SpringUtil.getOriginatingServletPath();
		if(uri.endsWith(".do") || uri.endsWith(".ifm") || uri.endsWith(".pop") || uri.endsWith(".m")) {
			return true;
		}
		return false;
	}

	/**
	 * Check json/xml/xls extension.
	 *
	 * @param request the request
	 * @return true, if is json extension
	 */
	public static final boolean isDataExtension() {
		String uri = SpringUtil.getOriginatingServletPath();
		if(uri.endsWith(".json") || uri.endsWith(".xml") || uri.endsWith(".xls")) {
//		if(uri.endsWith(".json") || uri.endsWith(".xml")) {
			return true;
		}
		return false;
	}

	/**
	 * Check json/xml/xls extension.
	 *
	 * @param request the request
	 * @return true, if is json extension
	 */
	public static final String getExt() {
		String uri = SpringUtil.getOriginatingServletPath();
		return !"".equals(uri) ? uri.substring(uri.lastIndexOf(".") + 1, uri.length()) : "";
	}

	/**
	 * Check json/xml/xls extension.
	 *
	 * @param request the request
	 * @return true, if is json extension
	 */
	public static final String getMenuCd() {
		String menuCd = StringUtil.nvl(SpringUtil.getHttpServletRequest().getHeader("menuCd"), SpringUtil.getHttpServletRequest().getParameter("menuCd"));
		String uri = "";
		if (null == menuCd || "".equals(menuCd)) {
			uri = SpringUtil.getOriginatingServletPath();
			menuCd = !"".equals(uri) ? uri.substring(uri.lastIndexOf("/") + 1, uri.lastIndexOf(".")) : "";
		}
		log.debug("menuCd: "+menuCd);
		return menuCd;
	}
}
