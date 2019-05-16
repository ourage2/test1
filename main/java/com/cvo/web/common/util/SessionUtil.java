package com.enpem.web.common.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.enpem.web.common.constants.CmnConst;
import com.enpem.web.common.data.Box;

public class SessionUtil {

	private SessionUtil() {
	}

	public static String getTimerApply(HttpSession session) {
		return (String)session.getAttribute(CmnConst.SESSION_TIMER_APPLY);
	}

	public static void setTimerApply(HttpSession session, String applyYn) {
		session.setAttribute(CmnConst.SESSION_TIMER_APPLY, applyYn);
	}

	public static Box getUser(HttpServletRequest request) {
		return (Box)request.getSession().getAttribute(CmnConst.SES_USER_DATA);
	}
}