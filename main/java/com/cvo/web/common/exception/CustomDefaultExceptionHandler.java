package com.enpem.web.common.exception;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.annotation.AnnotationUtils;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import com.enpem.web.common.constants.CmnConst;
import com.enpem.web.common.data.Box;
import com.enpem.web.common.util.JsonUtil;
import com.enpem.web.common.util.MsgUtil;
import com.enpem.web.common.util.SessionUtil;
import com.enpem.web.common.util.StringUtil;
import com.enpem.web.common.util.XmlUtil;
import com.enpem.web.common.vo.ResponseVO;
import com.microsoft.sqlserver.jdbc.SQLServerException;

@ControllerAdvice
public class CustomDefaultExceptionHandler {

	protected Logger log = LoggerFactory.getLogger(this.getClass());

	@Autowired
	private View jsonView;

	@Autowired
	private View xmlView;

	@ExceptionHandler(Exception.class)
	@ResponseStatus(value=HttpStatus.INTERNAL_SERVER_ERROR)
	public ModelAndView handleException(Exception e, HttpServletRequest request, HttpServletResponse response) throws Exception {
		preHandleException(e, request, response);

		String msgId = null, msg = null;
		Object[] messageParams = null;
		Throwable nested = e.getCause();
		if(e instanceof BizException) {
			BizException be = (BizException)e;
			msgId = be.getMessageId();
			messageParams = be.getMessageParams();
		}
		if (nested != null) {
			if (nested instanceof SQLException) {
				SQLException se = (SQLException) nested;
				log.debug("SQLException errorCode:" + se.getErrorCode());
				log.debug("SQLException sqlState:" + se.getSQLState());
				log.debug("SQLException message:" + se.getMessage());
				if (se.getErrorCode() == 2627) {
					msgId = CmnConst.RES_CD_DUPLICATE; //중복된 데이터가 존재합니다.
				}
			}
		}
//		} else if (e instanceof DuplicateKeyException) {
//			DuplicateKeyException de = (DuplicateKeyException) e;
//			msgId = CmnConst.RES_CD_DUPLICATE; //중복된 데이터가 존재합니다.
//		}



		if (null == msgId || msgId.isEmpty()) {
			msgId = CmnConst.RES_CD_SERVER_ERROR;
		}

		msg = MsgUtil.getMsg(msgId, messageParams);
		if(StringUtil.isEmpty(msg)) {
			msg = e.getMessage();
		}

		log.error("Exception Class : {}", e.getClass());
		log.error("Exception ID : {}", msgId);
		log.error("Exception Message : {}", msg);
		if(!(e instanceof BizException)) {
			log.error("Exception Detail : {}", e);
		}

		Box box = new Box();
		box.put(CmnConst.RES_CODE, msgId);
		box.put(CmnConst.RES_MSG, msg);

		if(JsonUtil.isJson(request)) {
			return new ModelAndView(jsonView, box);
		} else if (XmlUtil.isXml(request)) {
			ResponseVO responseVO = new ResponseVO();
			responseVO.setResponseCode(msgId);
			responseVO.setResponseMessage(msg);
			box.put(CmnConst.MODELMAP_XML_RESULT, responseVO);
			return new ModelAndView(xmlView, box);
		}

		return new ModelAndView("common/error/bizException", box);
//		return new ModelAndView("mobile:common/error/bizException", box);
	}

	@ExceptionHandler(NoAuthException.class)
	@ResponseStatus(value=HttpStatus.INTERNAL_SERVER_ERROR)
	public ModelAndView handleNoAuthException(Exception e, HttpServletRequest request, HttpServletResponse response) throws Exception {
		preHandleException(e, request, response);

		NoAuthException nae = (NoAuthException)e;
		String msgId = nae.getMessageId();
		if(StringUtil.isEmpty(msgId)) {
			msgId = CmnConst.RES_CD_SESSION_OUT;
		}
		String msg = MsgUtil.getMsg(msgId);

		log.error("Exception ID : {}", msgId);
		log.error("Exception Message : {}", msg);

		Box box = new Box();
		box.put(CmnConst.RES_CODE, msgId);
		box.put(CmnConst.RES_MSG, msg);
		if (JsonUtil.isJson(request)) {
			return new ModelAndView(jsonView, box);
		} else if (XmlUtil.isXml(request)) {
			ResponseVO responseVO = new ResponseVO();
			responseVO.setResponseCode(msgId);
			responseVO.setResponseMessage(msg);
			box.put(CmnConst.MODELMAP_XML_RESULT, responseVO);
			return new ModelAndView(xmlView, box);
		}
		request.getSession().setAttribute("msgId", msgId);
		return new ModelAndView("redirect:/main/login.do");
	}

	@ExceptionHandler(ResourceNotFoundException.class)
	@ResponseStatus(value=HttpStatus.INTERNAL_SERVER_ERROR)
	public ModelAndView handleNoResourceNotFoundException(Exception e, HttpServletRequest request, HttpServletResponse response) throws Exception {
		preHandleException(e, request, response);

		String msgId = CmnConst.RES_CD_NOT_FOUND;
		String msg = MsgUtil.getMsg(msgId);

		log.error("Exception ID : {}", msgId);
		log.error("Exception Message : {}", msg);

		Box box = new Box();
		box.put(CmnConst.RES_CODE, msgId);
		box.put(CmnConst.RES_MSG, msg);
		if(JsonUtil.isJson(request)) {
			return new ModelAndView(jsonView, box);
		} else if (XmlUtil.isXml(request)) {
			ResponseVO responseVO = new ResponseVO();
			responseVO.setResponseCode(msgId);
			responseVO.setResponseMessage(msg);
			box.put(CmnConst.MODELMAP_XML_RESULT, responseVO);
			return new ModelAndView(xmlView, box);
		}

		//세션객체 체크
//		Box userBox = SessionUtil.getUser(request);
//		if(userBox == null) {
//			return new ModelAndView("noframe:/common/error/resourceNotFound", box);
//		} else {
			return new ModelAndView("common/error/resourceNotFound", box);
//		}
	}

	private void preHandleException(Exception e, HttpServletRequest request, HttpServletResponse response) throws Exception {
		if (AnnotationUtils.findAnnotation(e.getClass(), ResponseStatus.class) != null) {
			throw e;
		}
	}

}
