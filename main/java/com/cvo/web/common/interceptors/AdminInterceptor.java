package com.enpem.web.common.interceptors;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.enpem.web.common.util.HttpUtil;
import com.enpem.web.common.util.StringUtil;


public class AdminInterceptor extends HandlerInterceptorAdapter {

	protected Logger log = LoggerFactory.getLogger(this.getClass());

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		return super.preHandle(request, response, handler);
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
		log.debug(">>Admin Interceptor");
		String viewName = modelAndView.getViewName();
		if(StringUtil.isEmpty(viewName)) {
			return;
		}
		if(viewName.indexOf(":") > -1) {
			return;
		}
		String uri = HttpUtil.getRequestUri(request);
		if(StringUtil.isEmpty(uri)) {
			return;
		}
//		Box menuBox = MenuUtil.getMenuBox(uri);
//		if(menuBox == null) {
//			return;
//		}
//		request.setAttribute(CmnConstants.REQUEST_MENU_ID, menuBox.getString("menuId"));
//		request.setAttribute(CmnConstants.REQUEST_TOP_MENU_ID, menuBox.getString("upperMenuId"));

		super.postHandle(request, response, handler, modelAndView);
	}

//	@Override
//	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

		/*
		log.debug(">>>  ADMIN Interceptors");
		Box userBox = (Box)request.getSession().getAttribute(CmnConst.SES_USER_DATA);
		log.debug("userBox:"+userBox);
		if(userBox == null) {
			throw new BizException("F10001"); //로그인 세션이 존재하지 않습니다.
		}

		//WAS LOG 기능 강화 (접근 IP, 시스템, 사번을 로그에 출력)
		Box threadBox = new Box();
		threadBox.put("clientIp", HttpUtil.getRemoteIpAddr(request));
		threadBox.put("clientCallUrl", HttpUtil.getRequestURL(request));
		threadBox.put("clientMethod", StringUtil.nvl(request.getMethod()));
		threadBox.put("clientRefererUri", HttpUtil.getRefererUri(request));
		threadBox.put("adminId", null != userBox && !userBox.isEmpty() ? userBox.nvl("userId") : "");
		request.setAttribute(CmnConst.PARAM_PROP_THREAD_BOX, threadBox);
//		ApiUtil.setThreadBox(box, threadBox);
		ApiUtil.setThreadNm(threadBox);

//		if(userBox == null || (0 != userBox.getInt("USER_LVL"))) {
//			String url = null;
//			if("GET".equals(request.getMethod())) {
//				url = new UrlPathHelper().getRequestUri(request);
//				String queryString = request.getQueryString();
//
//				if(!Strings.isNullOrEmpty(url)) {
//					if(!Strings.isNullOrEmpty(queryString)) {
//						url += "?" + queryString;
//					}
//				}
//			} else {
//				url = request.getContextPath();
//			}
//			request.getSession().setAttribute("redirectUrl", url);
//			log.debug("Redirect URL : {}", url);
//
//			response.sendRedirect(request.getContextPath() + "/main/index.do");
//			return false;
//		} else if (0 == userBox.getInt("USER_LVL")) {
//			return true;
//		}
//
//		return false;
		return true;
		 */
//	}

}
