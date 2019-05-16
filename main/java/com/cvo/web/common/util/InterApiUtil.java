package com.enpem.web.common.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.enpem.web.common.constants.CmnConst;
import com.enpem.web.common.data.Box;

public class InterApiUtil {

	protected Logger log = LoggerFactory.getLogger(this.getClass());

	/**
	 * Gets the header box.
	 *
	 * @param paramBox the param box
	 * @return the header box
	 */
	public static Box getHeaderBox(Box paramBox) {
		return (Box)paramBox.get(CmnConst.PARAM_HEADER_BOX);
	}

	/**
	 * Gets the rqt data.
	 *
	 * @param <T> the generic type
	 * @param paramBox the param box
	 * @param clazz the clazz
	 * @return the rqt data
	 */
	@SuppressWarnings("unchecked")
	public static <T> T getRqtData(Box paramBox, Class<T> clazz) {
		return (T)paramBox.getProp(CmnConst.PARAM_PROP_RQT_DATA);
	}

	/**
	 * Gets the url bas box.
	 *
	 * @param paramBox the param box
	 * @return the url bas box
	 */
	public static Box getUrlBasBox(Box paramBox) {
		return ((Box)paramBox.getProp(CmnConst.PARAM_PROP_URL_BAS_BOX)).clone();
	}

	/**
	 * Gets the api log box.
	 *
	 * @param paramBox the param box
	 * @return the api log box
	 */
	public static Box getApiLogBox(Box paramBox) {
		return (Box)paramBox.getProp(CmnConst.PARAM_PROP_API_LOG_BOX);
	}

	/**
	 * Gets the api log box value.
	 *
	 * @param paramBox the param box
	 * @param key the key
	 * @return the api log box value
	 */
	public static Object getApiLogBoxValue(Box paramBox, String key) {
		Box apiLogBox = getApiLogBox(paramBox);
		Object value = null;
		if(apiLogBox != null) {
			value = apiLogBox.get(key);
		}
		return value;
	}

	/**
	 * Gets the api log box string.
	 *
	 * @param paramBox the param box
	 * @param key the key
	 * @return the api log box string
	 */
	public static String getApiLogBoxString(Box paramBox, String key) {
		Object valueObj = getApiLogBoxValue(paramBox, key);
		String value = null;
		if(valueObj != null) {
			value = StringUtil.toString(valueObj);
		}
		return value;
	}

	/**
	 * Gets the rqt header box.
	 *
	 * @param paramBox the param box
	 * @return the rqt header box
	 */
	public static Box getRqtHeaderBox(Box paramBox) {
		return ((Box)getApiLogBoxValue(paramBox, "rqtHeaderBox")).clone();
	}

	/**
	 * Gets the rqt param box.
	 *
	 * @param paramBox the param box
	 * @return the rqt param box
	 */
	public static Box getRqtParamBox(Box paramBox) {
		return ((Box)getApiLogBoxValue(paramBox, "rqtParamBox")).clone();
	}

	/**
	 * Gets the settl svc group id.
	 *
	 * @param paramBox the param box
	 * @return the settl svc group id
	 */
	public static String getSettlSvcGroupId(Box paramBox) {
		return (String)getApiLogBoxValue(paramBox, "settlSvcGroupId");
	}

	/**
	 * Gets the rqt ip.
	 *
	 * @param paramBox the param box
	 * @return the rqt ip
	 */
	public static String getRqtIp(Box paramBox) {
		return (String)getApiLogBoxValue(paramBox, "rqtIp");
	}

	/**
	 * Gets the legacy cd group id.
	 *
	 * @param paramBox the param box
	 * @return the legacy cd group id
	 */
	public static String getLegacyCdGroupId(Box paramBox) {
		return getUrlBasBox(paramBox).getString("legacyCdGroupId");
	}

	/**
	 * Gets the header value.
	 *
	 * @param paramBox the param box
	 * @param key the key
	 * @return the header value
	 */
	private static String getHeaderValue(Box paramBox, String key) {
		String value = null;
		Box headerBox = (Box)getHeaderBox(paramBox);
		if(headerBox != null) {
			value = headerBox.getString(key);
		}
		return value;
	}

	/**
	 * Copy param box.
	 *
	 * @param paramBox the param box
	 * @return the box
	 */
	public static Box copyParamBox(Box paramBox) {
		Box box = new Box();
		if(paramBox != null) {
			box.put(CmnConst.PARAM_HEADER_BOX, getHeaderBox(paramBox));
			box.putProp(CmnConst.PARAM_PROP_THREAD_BOX, getThreadBox(paramBox));
		}
		return box;
	}

	/**
	 * Gets the thread box.
	 *
	 * @param paramBox the param box
	 * @return the thread box
	 */
	public static Box getThreadBox(Box paramBox) {
		return (Box)paramBox.getProp(CmnConst.PARAM_PROP_THREAD_BOX);
	}

	/**
	 * Sets the thread name.
	 *
	 * @param paramBox the param box
	 * @param transacId the transac id
	 * @param rqtSys the rqt sys
	 * @param settlNo the settl no
	 * @param apiLogNo the api log no
	 */
	public static void setAppThreadName(Box paramBox, String transacId, String clientSys, String empNo, String logId) {
		if(paramBox == null) {
			return;
		}
		Box threadBox = ApiUtil.getThreadBox(paramBox);
		if(threadBox == null) {
			return;
		}
		if(StringUtil.isNotEmpty(logId)) {
			threadBox.put("logId", logId);
		}
		String clientIp = threadBox.nvl("clientIp");

		if(StringUtil.isNotEmpty(transacId)) {
			threadBox.put("transacId", transacId);
		}
		if(StringUtil.isNotEmpty(clientSys)) {
			threadBox.put("clientSys", clientSys);
		}
		if(StringUtil.isNotEmpty(empNo)) {
			threadBox.put("empNo", empNo);
		}
		StringBuffer sb = new StringBuffer();
		sb.append("clientIp:").append(clientIp).append("|");

		String nClientSys = threadBox.getString("clientSys");
		if(StringUtil.isNotEmpty(nClientSys)) {
			sb.append("clientSys:").append(nClientSys).append("|");
		}
		String nLogId = threadBox.getString("logId");
		if(StringUtil.isNotEmpty(nLogId)) {
			sb.append("logId:").append(nLogId).append("|");
		}
		String nTransacId = threadBox.getString("transacId");
		if(StringUtil.isNotEmpty(nTransacId)) {
			sb.append("TI:").append(nTransacId).append("|");
		}
		String nEmpNo = threadBox.getString("empNo");
		if(StringUtil.isNotEmpty(nEmpNo)) {
			sb.append("empNo:").append(nEmpNo).append("|");
		}
		String threadName = sb.toString();
		if(StringUtil.isNotEmpty(threadName)) {
			threadName = threadName.substring(0, threadName.length()-1);
			Thread thread = Thread.currentThread();
			thread.setName(threadName);
		}
	}

	/**
	 * Sets the thread name.
	 *
	 * @param paramBox the param box
	 * @param transacId the transac id
	 * @param rqtSys the rqt sys
	 * @param settlNo the settl no
	 */
	public static void setAppThreadName(Box paramBox, String transacId, String rqtSys, String settlNo) {
		InterApiUtil.setAppThreadName(paramBox, transacId, rqtSys, settlNo, null);
	}

	/**
	 * Sets the thread name.
	 *
	 * @param paramBox the param box
	 * @param transacId the transac id
	 * @param rqtSys the rqt sys
	 */
	public static void setAppThreadName(Box paramBox, String transacId, String rqtSys) {
		InterApiUtil.setAppThreadName(paramBox, transacId, rqtSys, null, null);
	}

	/**
	 * Sets the thread name.
	 *
	 * @param paramBox the param box
	 * @param transacId the transac id
	 */
	public static void setAppThreadName(Box paramBox, String transacId) {
		InterApiUtil.setAppThreadName(paramBox, transacId, null, null, null);
	}

	/**
	 * Sets the thread name.
	 *
	 * @param paramBox the new thread name
	 */
	public static void setAppThreadName(Box paramBox) {
		InterApiUtil.setAppThreadName(paramBox, null, null, null, null);
	}

}
