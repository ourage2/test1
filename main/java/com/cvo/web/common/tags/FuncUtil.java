package com.enpem.web.common.tags;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import com.enpem.web.common.constants.CmnConst;
import com.enpem.web.common.util.CdUtil;
import com.enpem.web.common.util.HttpUtil;
import com.enpem.web.common.util.JsonUtil;
import com.enpem.web.common.util.SpringUtil;
import com.enpem.web.common.util.StringUtil;
import com.google.common.base.Objects;
import com.google.common.base.Strings;

public class FuncUtil {

//	private static final Logger log = LoggerFactory.getLogger(FuncUtil.class);

	/**
	 * URL Encoding
	 *
	 * @param input
	 * @return
	 * @throws Exception
	 */
	public static String encode(String input) throws Exception {
		return URLEncoder.encode(input, CmnConst.DEFAULT_CHARSET);
	}


	/**
	 * URL Encoding
	 *
	 * @param input
	 * @param charset
	 * @return
	 * @throws Exception
	 */
	public static String encode(String input, String charset) throws Exception {
		return URLEncoder.encode(input, charset);
	}


	/**
	 * URL Decoding
	 *
	 * @param input
	 * @return
	 * @throws Exception
	 */
	public static String decode(String input) throws Exception {
		return URLDecoder.decode(input, CmnConst.DEFAULT_CHARSET);
	}


	/**
	 * URL Decoding
	 *
	 * @param input
	 * @param charset
	 * @return
	 * @throws Exception
	 */
	public static String decode(String input, String charset) throws Exception {
		return URLDecoder.decode(input, charset);
	}


	/**
	 * 바이트로 문자열 자르기
	 *
	 * @param szText
	 * @param nLength
	 * @return
	 * @throws Exception
	 */
	public static String subByte(String szText, int nLength) throws Exception {
		String r_val = szText;
		int oF = 0, oL = 0, rF = 0, rL = 0;
		int nLengthPrev = 0;
		byte[] bytes = r_val.getBytes(CmnConst.DEFAULT_CHARSET);

		int byteLen = bytes.length;
		int j = 0;
		if (nLengthPrev > 0) {
			while (j < byteLen) {
				if ((bytes[j] & 0x80) != 0) {
					oF += 2;
					rF += 3;
					if (oF + 2 > nLengthPrev) {
						break;
					}
					j += 3;
				} else {
					if (oF + 1 > nLengthPrev) {
						break;
					}
					++oF;
					++rF;
					++j;
				}
			}
			j = rF;
		}

		while (j < byteLen) {
			if ((bytes[j] & 0x80) != 0) {
				if (oL + 2 > nLength) {
					break;
				}
				oL += 2;
				rL += 3;
				j += 3;
			} else {
				if (oL + 1 > nLength) {
					break;
				}
				++oL;
				++rL;
				++j;
			}
		}

		r_val = new String(bytes, rF, rL, CmnConst.DEFAULT_CHARSET);

		return r_val;
	}


	/**
	 * 바이트로 문자열 자르기(말줄임 변수 추가)
	 *
	 * @param szText
	 * @param nLength
	 * @return
	 * @throws Exception
	 */
	public static String subByteTail(String szText, int nLength, String tail) throws Exception {
		String r_val = szText;
		int oF = 0, oL = 0, rF = 0, rL = 0;
		int nLengthPrev = 0;
		byte[] bytes = r_val.getBytes(CmnConst.DEFAULT_CHARSET);

		int byteLen = bytes.length;
		int j = 0;
		if (nLengthPrev > 0) {
			while (j < byteLen) {
				if ((bytes[j] & 0x80) != 0) {
					oF += 2;
					rF += 3;
					if (oF + 2 > nLengthPrev) {
						break;
					}
					j += 3;
				} else {
					if (oF + 1 > nLengthPrev) {
						break;
					}
					++oF;
					++rF;
					++j;
				}
			}
			j = rF;
		}

		while (j < byteLen) {
			if ((bytes[j] & 0x80) != 0) {
				if (oL + 2 > nLength) {
					break;
				}
				oL += 2;
				rL += 3;
				j += 3;
			} else {
				if (oL + 1 > nLength) {
					break;
				}
				++oL;
				++rL;
				++j;
			}
		}

		r_val = new String(bytes, rF, rL, CmnConst.DEFAULT_CHARSET);

		//System.out.println("cnt: !!!!!!!!!    oL:  " + oL + "     nLength:  "+ nLength);

		if(nLength <= oL ) {
			r_val = r_val + tail;
		}

		return r_val;
	}


	/**
	 * String to Integer
	 *
	 * @param str
	 * @return
	 * @throws Exception
	 */
	public static int parseInt(String str) throws Exception {
		return Integer.parseInt(str);
	}


	/**
	 * String to Float
	 *
	 * @param str
	 * @return
	 * @throws Exception
	 */
	public static float parseFloat(String str) throws Exception {
		return Float.parseFloat(str);
	}


	/**
	 * split
	 *
	 * @param str, before, after
	 * @return
	 * @throws Exception
	 */
	public static String split(String str, String gubun, int idx) throws Exception {
		if(Strings.isNullOrEmpty(str)) {
			return "";
		}
		String[] strArray = str.split(gubun);
		return strArray[idx];
	}


	/**
	 * 확장자 구하기
	 *
	 * @param str, gubun
	 * @return
	 * @throws Exception
	 */
	public static String getExt(String str) throws Exception {
		if(Strings.isNullOrEmpty(str)) {
			return "";
		}
		return str.substring(str.lastIndexOf(".") + 1, str.length());
	}

	/**
	 * url 확장자 구하기
	 *
	 * @param str, gubun
	 * @return
	 * @throws Exception
	 */
	public static String getUrlExt() throws Exception {
		return HttpUtil.getExt();
	}

	/**
	 * menuCd 구하기
	 *
	 * @param str, gubun
	 * @return
	 * @throws Exception
	 */
	public static String getMenuCd() throws Exception {
		return HttpUtil.getMenuCd().equals("index") ? "enpem" : HttpUtil.getMenuCd();
	}

	/**
	 * URI Starts Match
	 *
	 * @param request
	 * @param path
	 * @return
	 * @throws Exception
	 */
	public static boolean uriStartsMatch(HttpServletRequest request, String paths) throws Exception {
		if (null == paths || paths.isEmpty()) { return false; }
		String url = (String)request.getAttribute("javax.servlet.forward.request_uri");
		String contextPath = request.getContextPath();
		if(Strings.isNullOrEmpty(url) || Objects.equal(url, contextPath + "/")) {
			url = request.getRequestURI();
		}

		boolean isRtn = false;
		if(!Strings.isNullOrEmpty(url)) {
			String[] path = paths.split(",");
			for (int idx = 0; idx < path.length; idx++) {
				System.out.println(url);
				System.out.println(path[idx]);
				if(url.startsWith(contextPath + path[idx])) {
					isRtn = true;
				}
			}
		}
		return isRtn;
	}


	/**
	 * \n 문자를 <br/> 태그로 교체
	 *
	 * @param input
	 * @return
	 * @throws Exception
	 */
	public static String nl2br(String input) throws Exception {
		if(input == null || input.length() < 1) {
			return input;
		}
		return input.replaceAll("(\r)?\n", "<br />");
	}


	/**
	 * YYYYMMDD > YYYY.MM.DD (문자열 formatter)
	 *
	 * @param input
	 * @return
	 * @throws Exception
	 */
	public static String toYmd(String input, String gubun) throws Exception {
		if(input == null || input.length() < 1 || input.length() != 8) {
			return input;
		}
		if(gubun == null || gubun.length() < 1) {
			return input;
		}
		return input.substring(0, 4) + gubun + input.substring(4, 6) + gubun + input.substring(6, 8);
	}

	/**
	 * replace
	 *
	 * @param str, before, after
	 * @return
	 * @throws Exception
	 */
	public static String replace(String str, String before, String after) throws Exception {

		String rtnStr = "";

		//컨텍스트 패스로 변환 요청한 경우
		if(after.equals("contextPath")) {
			after = SpringUtil.getContextPath();
			rtnStr = str.replaceAll("\\$\\{pageContext.request.contextPath\\}", after);
		} else {
			rtnStr = str.replaceAll(before, after);
		}
		return rtnStr;
	}

	/**
	 * url 패턴 비교 - 종료url
	 *
	 * @param request, url
	 * @return
	 * @throws Exception
	 */
	public static boolean uriEndsMatch(HttpServletRequest request, String url) throws Exception {
//		System.out.println(request.getRequestURI());
		if(request.getRequestURI().endsWith(url + ".jsp")) {
			return true;
		}
		return false;
	}


	/**
	 * url 변환
	 *
	 *
	 *
	 */
	 public static String httpConvert(String str) throws Exception {
		 return HttpUtil.setHtmlToText(str);
	 }

	public static String urlEncode(String str) {
		if(StringUtil.isEmpty(str)) {
			return str;
		}
		try {
			return URLEncoder.encode(str, CmnConst.CHARSET);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return str;
	}

	public static boolean startsWith(String str, String prefix) {
		return str.startsWith(prefix);
	}

	public static List<?> cdList(String grpCd) {
		return CdUtil.getCdList(grpCd);
	}

	public static String toJson(Object obj) throws Exception {
		return JsonUtil.toJson(obj);
	}

}
