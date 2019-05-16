package com.enpem.web.common.util;

import java.io.File;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.enpem.web.common.constants.CmnConst;
import com.enpem.web.common.data.Box;
import com.enpem.web.common.data.ModelBox;
import com.enpem.web.common.exception.BizException;

public class ApiUtil {

	protected Logger log = LoggerFactory.getLogger(this.getClass());

	/**
	 * Sets the session.
	 *
	 * @param paramBox the param box
	 * @param session the session
	 */
	public static void setSession(Box paramBox, HttpSession session) {
		paramBox.putProp(CmnConst.PARAM_PROP_SESSION, session);
	}

	/**
	 * Gets the session.
	 *
	 * @param paramBox the param box
	 * @return the session
	 */
	public static HttpSession getSession(Box paramBox) {
		return (HttpSession)paramBox.getProp(CmnConst.PARAM_PROP_SESSION);
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
	 * Gets the api log box.
	 *
	 * @return the api log box
	 */
	public static Box getApiLogBox() {
		return getApiLogBox(ApiUtil.getParamBox());
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
	 * Gets the log id.
	 *
	 * @param paramBox the param box
	 */
	public static String getLogId(Box paramBox) {
		return ApiUtil.getApiLogBoxString(paramBox, "logId");
	}

	/**
	 * Gets the log id.
	 *
	 * @param paramBox the param box
	 */
	public static String setLogId(Box paramBox) {
		return ApiUtil.getApiLogBoxString(paramBox, "logId");
	}

	/**
	 * Gets the log id.
	 *
	 */
	public static String getLogId() {
		return ApiUtil.getLogId(ApiUtil.getParamBox());
	}

	/**
	 * Sets the req data.
	 *
	 * @param reqData the new req data
	 */
	public static void setRqtData(Object reqData) {
		ApiUtil.getParamBox().putProp(CmnConst.PARAM_PROP_RQT_DATA, reqData);
	}

	/**
	 * Gets the req data.
	 *
	 * @param <T> the generic type
	 * @param paramBox the param box
	 * @param clazz the clazz
	 * @return the req data
	 */
	@SuppressWarnings("unchecked")
	public static <T> T getRqtData(Box paramBox, Class<T> clazz) {
		return (T)paramBox.getProp(CmnConst.PARAM_PROP_RQT_DATA);
	}

	/**
	 * Gets the req data.
	 *
	 * @param <T> the generic type
	 * @param clazz the clazz
	 * @return the req data
	 */
	public static <T> T getRqtData(Class<T> clazz) {
		return getRqtData(ApiUtil.getParamBox(), clazz);
	}

	/**
	 * Sets the model box.
	 *
	 * @param request the request
	 * @param modelBox the model box
	 */
	public static void setModelBox(HttpServletRequest request, ModelBox modelBox) {
		getParamBox(request).putProp(CmnConst.PARAM_PROP_MODEL_BOX, modelBox);
	}

	/**
	 * Sets the model box.
	 *
	 * @param modelBox the model box
	 */
	public static void setModelBox(ModelBox modelBox) {
		ApiUtil.getParamBox().putProp(CmnConst.PARAM_PROP_MODEL_BOX, modelBox);
	}

	/**
	 * Gets the model box.
	 *
	 * @param request the request
	 * @param paramBox the param box
	 * @return the model box
	 */
	public static ModelBox getModelBox(HttpServletRequest request, Box paramBox) {
		ModelBox modelBox = (ModelBox)paramBox.getProp(CmnConst.PARAM_PROP_MODEL_BOX);
		if(modelBox == null) {
			modelBox = new ModelBox();
			setModelBox(request, modelBox);
		}
		return modelBox;
	}

	/**
	 * Gets the model box.
	 *
	 * @param paramBox the param box
	 * @return the model box
	 */
	public static ModelBox getModelBox(Box paramBox) {
		return ApiUtil.getModelBox(SpringUtil.getHttpServletRequest(), paramBox);
	}

	/**
	 * Gets the model box.
	 *
	 * @return the model box
	 */
	public static ModelBox getModelBox() {
		return ApiUtil.getModelBox(ApiUtil.getParamBox());
	}

	/**
	 * Gets the param box.
	 *
	 * @return the param box
	 */
	public static Box getParamBox() {
		return getParamBox(SpringUtil.getHttpServletRequest());
	}

	/**
	 * Sets the header box.
	 *
	 * @param paramBox the param box
	 * @param headerBox the header box
	 */
	public static void setHeaderBox(Box paramBox, Box headerBox) {
		paramBox.put(CmnConst.PARAM_HEADER_BOX, headerBox);
	}

	/**
	 * Sets the header vo.
	 *
	 * @param headerBox the header box
	 */
	public static void setHeaderBox(Box headerBox) {
		setHeaderBox(ApiUtil.getParamBox(), headerBox);
	}

	/**
	 * Gets the header vo.
	 *
	 * @param paramBox the param box
	 * @return the header vo
	 */
	public static Box getHeaderBox(Box paramBox) {
		return (Box)paramBox.get(CmnConst.PARAM_HEADER_BOX);
	}

	/**
	 * Gets the header box.
	 *
	 * @return the header box
	 */
	public static Box getHeaderBox() {
		return getHeaderBox(ApiUtil.getParamBox());
	}

	/**
	 * Inits the param box.
	 *
	 * @param request the request
	 * @return the box
	 */
	public static Box initParamBox(HttpServletRequest request) {
		Box paramBox = new Box();
		request.setAttribute(CmnConst.REQUEST_PARAM_BOX, paramBox);
		return paramBox;
	}

	/**
	 * Gets the param box.
	 *
	 * @param request the request
	 * @return the param box
	 */
	public static Box getParamBox(HttpServletRequest request) {
		Box paramBox = null;
		if(request != null) {
			paramBox = (Box)request.getAttribute(CmnConst.REQUEST_PARAM_BOX);
		}
		if(paramBox == null) {
		}
		paramBox = initParamBox(request);
		return paramBox;
	}

	/**
	 * Sets the thread box.
	 *
	 * @param paramBox the param box
	 * @param threadBox the thread box
	 */
	public static void setThreadBox(Box paramBox, Box threadBox) {
		if (null == paramBox.getProp(CmnConst.PARAM_PROP_THREAD_BOX)) {
			paramBox.putProp(CmnConst.PARAM_PROP_THREAD_BOX, threadBox);
		}
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
	 * Inits the thread name.
	 *
	 * @param paramBox the param box
	 * @return the box
	 */
	public static Box initThreadBox(Box paramBox) {
		Box threadBox = ApiUtil.getThreadBox(paramBox);
		if(threadBox == null) {
			threadBox = new Box();
			ApiUtil.setThreadBox(paramBox, threadBox);
		}
		String threadName = Thread.currentThread().getName();
		threadBox.put("orgThreadName", threadName);
		return threadBox;
	}

	/**
	 * Sets the thread name.
	 *
	 * @param paramBox the param box
	 */
	public static void clearThreadName(Box paramBox) {
		Box threadBox = ApiUtil.getThreadBox(paramBox);
		if(threadBox != null) {
			String orgThreadName = threadBox.getString("orgThreadName");
			if(StringUtil.isNotEmpty(orgThreadName)) {
				Thread thread = Thread.currentThread();
				thread.setName(orgThreadName);
			}
		}
	}

	/**
	 * Sets the thread name.
	 *
	 * @param paramBox the param box
	 * @param transacId the transac id
	 * @param clientSys the client sys
	 * @param apiLogId the api log id
	 */
	public static void setThreadName(Box paramBox, String transacId, String clientSys, String empNo, String logId) {
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
		sb.append("cIp:").append(clientIp).append("|");

		String nClientSys = threadBox.getString("clientSys");
		if(StringUtil.isNotEmpty(nClientSys)) {
			sb.append("cSys:").append(nClientSys).append("|");
		}
		String nEmpNo = threadBox.getString("empNo");
		if(StringUtil.isNotEmpty(nEmpNo)) {
			sb.append("empNo:").append(nEmpNo).append("|");
		}
		String nLogId = threadBox.getString("logId");
		if(StringUtil.isNotEmpty(nLogId)) {
			sb.append("logId:").append(nLogId).append("|");
		}
		String nTransacId = threadBox.getString("transacId");
		if(StringUtil.isNotEmpty(nTransacId)) {
			sb.append("TI:").append(nTransacId).append("|");
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
	public static void setThreadName(Box paramBox, String transacId, String clientSys, String empNo) {
		ApiUtil.setThreadName(paramBox, transacId, clientSys, empNo, null);
	}

	/**
	 * Sets the thread name.
	 *
	 * @param paramBox the param box
	 * @param transacId the transac id
	 * @param rqtSys the rqt sys
	 */
	public static void setThreadName(Box paramBox, String transacId, String clientSys) {
		ApiUtil.setThreadName(paramBox, transacId, clientSys, null, null);
	}

	/**
	 * Sets the thread name.
	 *
	 * @param paramBox the param box
	 * @param transacId the transac id
	 */
	public static void setThreadName(Box paramBox, String transacId) {
		ApiUtil.setThreadName(paramBox, transacId, null, null, null);
	}

	/**
	 * Sets the thread name.
	 *
	 * @param paramBox the new thread name
	 */
	public static void setThreadName(Box paramBox) {
		ApiUtil.setThreadName(paramBox, null, null, null, null);
	}

	/**
	 * Sets the thread name.
	 *
	 * @param paramBox the param box
	 */
	public static void setThreadNm(Box threadBox) {
		if(threadBox == null) {
			return;
		}
		StringBuffer sb = new StringBuffer();
		String nClientIp = threadBox.getString("clientIp");
		if(StringUtil.isNotEmpty(nClientIp)) {
			sb.append("cIp:").append(nClientIp).append("|");
		}
		String nClientSys = threadBox.getString("clientSys");
		if(StringUtil.isNotEmpty(nClientSys)) {
			sb.append("cSys:").append(nClientSys).append("|");
		}
		String nEmpNo = threadBox.getString("empNo");
		if(StringUtil.isNotEmpty(nEmpNo)) {
			sb.append("empNo:").append(nEmpNo).append("|");
		}
		String nLogId = threadBox.getString("logId");
		if(StringUtil.isNotEmpty(nLogId)) {
			sb.append("logId:").append(nLogId).append("|");
		}
		String nAdminId = threadBox.getString("adminId");
		if(StringUtil.isNotEmpty(nAdminId)) {
			sb.append("adminId:").append(nAdminId).append("|");
		}
		String threadName = sb.toString();
//		log.debug("threadName:"+threadName);
		if(StringUtil.isNotEmpty(threadName)) {
			threadName = threadName.substring(0, threadName.length()-1);
			Thread thread = Thread.currentThread();
			thread.setName(threadName);
		}
	}

	/**
	 * Gets the thread box.
	 *
	 * @param paramBox the param box
	 * @return the thread box
	 */
	public static Box getThreadBox(Box paramBox, HttpServletRequest request) {
		return (Box)request.getAttribute(CmnConst.PARAM_PROP_THREAD_BOX);
	}

	/**
	 * Sets the download.
	 *
	 * @param fileName the file name
	 * @param file the file
	 */
	public static void setDownload(String fileName, File file) {
		if(file == null || !file.isFile()) {
			throw new BizException("404");
		}
		ModelBox modelBox = ApiUtil.getModelBox();
		modelBox.put(CmnConst.MODEL_DOWNLOAD_FILE_NAME, fileName);
		modelBox.put(CmnConst.MODEL_DOWNLOAD_FILE, file);
	}

	/**
	 * Sets the download.
	 *
	 * @param file the new download
	 */
	public static void setDownload(File file) {
		if(file == null || !file.isFile()) {
			throw new BizException("404");
		}
		setDownload(file.getName(), file);
	}
}
