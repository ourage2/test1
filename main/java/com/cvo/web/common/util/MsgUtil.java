package com.enpem.web.common.util;

import java.text.MessageFormat;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.enpem.web.common.biz.MsgLocator;
import com.enpem.web.common.data.Box;

@Component
public class MsgUtil {

	private static MsgLocator msgLocator;

	@Autowired(required=true)
	private MsgUtil(MsgLocator msgLocator) {
		MsgUtil.msgLocator = msgLocator;
	}

	public static Box getMsgBox(String msgId) {
		if(StringUtil.isEmpty(msgId)) {
			return null;
		}
		return msgLocator.getMsgBox(msgId);
	}

	public static String getMsgType(String msgId) {
		Box msgBox = getMsgBox(msgId);
		String msgValue = null;
		if(msgBox != null) {
			msgValue = msgBox.nvl("msgType");
		}
		return msgValue;
	}

	public static String getMsgTypeNm(String msgId) {
		Box msgBox = getMsgBox(msgId);
		String msgValue = null;
		if(msgBox != null) {
			msgValue = msgBox.nvl("msgTypeNm");
		}
		return msgValue;
	}

	public static String getMsg(String msgId) {
		Box msgBox = getMsgBox(msgId);
		String msgValue = null;
		if(msgBox != null) {
			msgValue = msgBox.nvl("msgNm");
		}
		return msgValue;
	}

	public static String getMsgEtc(String msgId) {
		Box msgBox = getMsgBox(msgId);
		String msgValue = null;
		if(msgBox != null) {
			msgValue = msgBox.nvl("msgEtc");
		}
		return msgValue;
	}

	public static String getMsg(String cd, Object[] messageParams) {
		String msg = getMsg(cd);
		if(StringUtil.isNotEmpty(msg)) {
			if(messageParams != null && messageParams.length > 0) {
				msg = MessageFormat.format(msg, messageParams);
			}
		}
		return msg;
	}
}
