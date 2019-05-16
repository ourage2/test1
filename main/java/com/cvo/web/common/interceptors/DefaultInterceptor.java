package com.enpem.web.common.interceptors;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import org.springframework.web.util.UrlPathHelper;

import com.enpem.web.common.constants.CmnConst;
import com.enpem.web.common.data.Box;
import com.enpem.web.common.exception.BizException;
import com.enpem.web.common.util.ApiUtil;
import com.enpem.web.common.util.HttpUtil;
import com.enpem.web.common.util.SpringUtil;
import com.enpem.web.common.util.StringUtil;
import com.enpem.web.common.util.SystemUtil;


public class DefaultInterceptor extends HandlerInterceptorAdapter {

	protected Logger log = LoggerFactory.getLogger(this.getClass());

//	private View xmlView;
//	public void setXmlView(View xmlView) {
//		this.xmlView = xmlView;
//	}

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		if ("jss".equals(HttpUtil.getExt())) { return true; }
		log.debug(">>LOGIN CHECK : " + SpringUtil.getRequestUri());
//		log.debug(">>" + SystemUtil.getWasName());

		Box userBox = (Box)request.getSession().getAttribute(CmnConst.SES_USER_DATA);
		if(userBox == null) {
			String url = null;

			url = new UrlPathHelper().getRequestUri(request);

			if (url.startsWith(request.getContextPath() + "/mobile/")) {
				throw new BizException("F401");
			}

			if("GET".equals(request.getMethod())) {
				url = new UrlPathHelper().getRequestUri(request);
				String queryString = request.getQueryString();

				if(!StringUtil.isEmpty(url)) {
					if(!StringUtil.isEmpty(queryString)) {
						url += "?" + queryString;
					}
				}
			} else {
//				url = new UrlPathHelper().getRequestUri(request);
				url = request.getContextPath();
			}
			request.getSession().setAttribute("redirectUrl", url);

			if (!"json".equals(HttpUtil.getExt())) {
				response.sendRedirect(request.getContextPath());
			}
			log.debug("Redirect URL : {}", url);
//			throw new BizException("F502"); //세션이 만료되었습니다.
			return false;
		}

		//WAS LOG 기능 강화 (접근 IP, 시스템, 사번을 로그에 출력)
		Box threadBox = new Box();
		threadBox.put("clientIp", HttpUtil.getRemoteIpAddr(request));
//		threadBox.put("clientSys", clientSys);
		threadBox.put("clientCallUrl", HttpUtil.getRequestURL(request));
		threadBox.put("clientMethod", StringUtil.nvl(request.getMethod()));
		threadBox.put("clientRefererUri", HttpUtil.getRefererUri(request));

		threadBox.put("userId", userBox.nvl("userId"));
//		threadBox.put("logId", dao.selectOne("api.getLogId"));
		request.setAttribute(CmnConst.PARAM_PROP_THREAD_BOX, threadBox);
//		ApiUtil.setThreadBox(box, threadBox);
		ApiUtil.setThreadNm(threadBox);

		if (!authCheck(userBox)) {
			return false;
		}
		return true;
	}

	public boolean authCheck(Box userBox) {

		boolean isAuth = false;
		String uri = SpringUtil.getOriginatingServletPath();

		if (null == userBox) { //세션이 존재하지 않을시 예외처리
			throw new BizException("F502"); //세션이 만료 되었습니다.
		}

		String menuCd = HttpUtil.getMenuCd();
		if (HttpUtil.getExt().equals("m")) { //모바일일 경우 권한체크를 하지 않는다
			return true;
		}
		if (uri.indexOf("mobile") > -1) { //모바일일 경우 권한체크를 하지 않는다
			return true;
		}

		//dash board, 사용자정보 조회, 모바일 비밀번호 변경일 경우 권한체크를 하지 않는다
		if ("centerList".equals(menuCd) || "userView".equals(menuCd) || "pwdView".equals(menuCd)) {
			return true;
		}

		List<Box> roleList = userBox.getList("roleList");
		for (Box rowBox : roleList) {
			if (uri.endsWith(".xls")) {
				if (rowBox.nvl("menuCd").equals(menuCd) && rowBox.nvl("excelYn").equals("Y")) {
					isAuth = true;
					break;
				}
			} else {
				if (rowBox.nvl("menuCd").equals(menuCd) && rowBox.nvl("selectYn").equals("Y")) {
					isAuth = true;
					break;
				}
			}
		}

		if (!isAuth) {
			log.debug("menuCd:"+menuCd);
			for (Box rowBox : roleList) {
				if (rowBox.nvl("menuCd").equals(menuCd)) {
					log.debug("role:"+ rowBox);
				}
			}
			throw new BizException("E110"); //권한이 없습니다.
		}

		return isAuth;
	}

//	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
//		UserVO userVO = (UserVO)SessionUtil.getUser(request);
//		HttpSession session = request.getSession();
//		if(userVO == null) {
//			SessionUtil.invalidate(session);
//			throw new NoAuthException();
//		}
//        if(NumberUtil.toInt(sqlSession.selectOne("cmn.user.selectUserSession", userVO).toString()) < 1) {
//        	signService.logout();
//        	throw new NoAuthException(CmnConstants.RES_CD_SESSION_FORCE_OUT, "동시로그인으로 인하여 강제 로그아웃합니다");
//		}
//        Box authMenuBox = SessionUtil.getAuthMenuBox(session);
//        if(authMenuBox == null || authMenuBox.isEmpty()) {
//        	log.debug("접근 거부 authMenuBox : {}", authMenuBox);
//        	throw new OmbsException(CmnConstants.RES_CD_FORBIDDEN, "접근이 거부된 문서를 요청하였습니다");
//        }
//        String uri = HttpUtil.getRequestUri(request);
//        if(!authMenuBox.containsKey(uri)) {
//        	log.debug("접근 거부 uri : {}, 사용자 : {}", uri, SessionUtil.getUser(session));
//        	throw new OmbsException(CmnConstants.RES_CD_FORBIDDEN, "접근이 거부된 문서를 요청하였습니다");
//        }
//		return true;
//	}
//
//	@Override
//	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
//		HttpSession session = request.getSession();
//		Box paramBox = (Box)request.getAttribute(CmnConstants.REQUEST_PARAM);
//
//		UserVO userVO = (UserVO)SessionUtil.getUser(session);
//		Box authMenuBox = SessionUtil.getAuthMenuBox(session);
//		String uri = HttpUtil.getRequestUri(request);
//		Box menuBox = (Box)authMenuBox.get(uri);
//
//		Box useHistBox = new Box();
//		useHistBox.put("ollehId", userVO.getOllehId());
//		useHistBox.put("menuId", menuBox.getString("currMenuId"));
//		useHistBox.put("menuNm", menuBox.getString("currMenuNm"));
//		useHistBox.put("funcId", menuBox.getString("currFuncId"));
//		useHistBox.put("funcNm", menuBox.getString("currFuncNm"));
//		useHistBox.put("workTypCd", menuBox.getString("menuTypCd"));
//		useHistBox.put("workData", (paramBox == null || paramBox.isEmpty()) ? null : JsonUtil.toJson(paramBox));
//		useHistBox.put("marketId", userVO.getMarketId());
//		useHistBox.put("commYn", userVO.getCommYn());
//		useHistBox.put("sysRegId", userVO.getOllehId());
//		requestLogAsyncService.insertUseHist(useHistBox);
//		super.postHandle(request, response, handler, modelAndView);
//	}
}
