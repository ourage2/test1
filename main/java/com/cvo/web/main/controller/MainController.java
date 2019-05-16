package com.enpem.web.main.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import com.enpem.web.common.constants.CmnConst;
import com.enpem.web.common.data.Box;
import com.enpem.web.common.exception.BizException;
import com.enpem.web.common.util.HttpUtil;
import com.enpem.web.common.util.SpringUtil;
import com.enpem.web.common.util.UserAgentUtil;
import com.enpem.web.common.util.crypto.Base64Util;
import com.enpem.web.main.service.MainService;

@Controller
@RequestMapping("main")
public class MainController {

	protected Logger log = LoggerFactory.getLogger(this.getClass());

	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSessionTemplate dao;

	@Autowired
	private MainService mainService;

//	@Autowired
//	private MailUtil mailUtil;


	/**
	 *
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("index")
	public void index(Box box, HttpSession session, ModelMap model) throws Exception {
	}


	/**
	 *
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("mindex")
	public void mindex(Box box, HttpSession session, ModelMap model) throws Exception {
		mainService.mindex(box, model, session);
	}

	/**
	 * 로그인 처리
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("login")
	public void login(Box box, HttpSession session, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			mainService.login(box, model, session);
		}
	}

	/**
	 * 로그인 처리(모바일)
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("mlogin")
	public void mlogin(Box box, HttpServletRequest request, HttpSession session, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
//			UserAgentUtil userAgentUtil = new UserAgentUtil(request);
//			log.debug(">>" + userAgentUtil.detectAndroid());
//			log.debug(">>" + userAgentUtil.detectChrome());
			if (box.nvl("app").equals("1")) { //app이 1로 올경우 안드로이드 app으로 접속했다고 가정함(모바일웹)
				mainService.login(box, model, session);
			} else if (box.nvl("app").equals("2")) { //app이 2로 올경우 safari 브라우져로 접속했다고 가정함(모바일웹)
				//safari 체크로직 필요 - safari로 로그인 하지 않을 경우 튕겨낸다. --> 로직상 체크할 필요 없음
				mainService.login(box, model, session);
			} else {
				throw new BizException("E109"); //유효하지 않은 접근입니다.
			}
		}
	}

	/**
	 * 로그아웃 처리
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("logout")
	public void logout(Box box, HttpSession session, ModelMap model) throws Exception {
		mainService.logout(box, model, session);
	}

	/**
	 * 로그아웃 처리(모바일)
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("mlogout")
	public void mlogout(Box box, HttpSession session, ModelMap model) throws Exception {
		mainService.mlogout(box, model, session);
	}

	/**
	 * 세션미존재
	 *
	 * @param box the box
	 * @param model the model box
	 */
//	@RequestMapping("noSession.json")
//	public void noSession(Box box, ModelMap model) throws Exception {
//	}


	/**
	 * 세션체크
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("sessionInfo.json")
	public void sessionInfo(Box box, HttpSession session, ModelMap model) throws Exception {
		Box userBox = (Box)session.getAttribute(CmnConst.SES_USER_DATA);
//		log.debug("userBox:" + userBox);
		if(userBox == null) {
			log.debug("로그인 세션이 존재하지 않습니다");
			throw new BizException("E101"); //로그인 세션이 존재하지 않습니다
//			throw new BizException("F401"); // UNAUTHORIZED
		}
		model.putAll(userBox);
	}

}
