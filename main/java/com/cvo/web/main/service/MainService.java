package com.enpem.web.main.service;

import javax.servlet.http.HttpSession;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import com.enpem.web.common.constants.CmnConst;
import com.enpem.web.common.data.Box;
import com.enpem.web.common.exception.BizException;
import com.enpem.web.common.util.CdUtil;
import com.enpem.web.common.util.HttpUtil;
import com.enpem.web.common.util.SpringUtil;
import com.enpem.web.common.util.crypto.Base64Util;

@Service
public class MainService {

	protected Logger log = LoggerFactory.getLogger(this.getClass());

	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSessionTemplate dao;

	@Value("#{config['session.timeout']}")
	private int sessionTimeout;

	@Value("#{config['session.timeout.manual']}")
	private String sessionTimeoutManual;


	/**
	 * 로그인 처리
	 *
	 * @param paramMap
	 * @param modelMap
	 * @throws Exception
	 */
	public void login(Box box, ModelMap model, HttpSession session) throws Exception {

		Box userBox = dao.selectOne("main.userView", box);
		//사용자 조회 실패시
		if (null == userBox || userBox.isEmpty()) {
			throw new BizException("E100"); //사용자 정보가 존재하지 않습니다.
		}

		box.put("ipAddr", HttpUtil.getRemoteIpAddr(SpringUtil.getHttpServletRequest()));
		box.put("loginGb", "1"); //1: 로그인, 2: 로그아웃
		box.put("webMobGb", box.decode("app", "1", "M", "2", "M", "W")); //M: 모바일, W: 웹

		dao.insert("main.userHistInsert", box); //로그인 로그를 쌓는다.
		dao.update("main.lastConUpdate", box); //최종접속일시 update

		//login한 사용자의권한을 가져온다
		userBox.put("roleList", dao.selectList("main.authList" , userBox));

		userBox.put("mAuthCd", userBox.nvl("authCd").substring(0, 1));
		userBox.put("s1Url", CdUtil.getCdEtc1("CONFIG", "S1"));
		userBox.put("s1Id", CdUtil.getCdEtc2("CONFIG", "S1"));
		userBox.put("s1Pwd", CdUtil.getCdEtc3("CONFIG", "S1"));
		userBox.put("redirectUrl", box.nvl("app").equals("1") || box.nvl("app").equals("2") ? CmnConst.M_REDIRECT_URL : CmnConst.REDIRECT_URL);

		//배송기사로 로그인시 배송기사의 차량이 존재하지 않거나 차량을 사용하지 않을 경우 로그인이 되지 않게 오류처리
		if (userBox.nvl("mAuthCd").equals("3")) {
			if (!userBox.nvl("isCar").equals("Y")) {
				throw new BizException("E107", new String[]{"차량정보가"}); //{0} 존재하지 않습니다.
			}
		}
		session.setAttribute(CmnConst.SES_USER_ID, userBox.nvl("userId"));
		session.setAttribute(CmnConst.SES_USER_DATA, userBox);
		session.setMaxInactiveInterval(sessionTimeout * 60);

		model.putAll(userBox);
		model.put("resCd", "S200");
		model.put("resMsg", "성공");
		model.put("safariYn", box.nvl("app").equals("2") ? "Y" : "");
		model.put("token", Base64Util.encodeString(box.nvl("userId")));
	}

	/**
	 * 세션 처리(모바일)
	 *
	 * @param paramMap
	 * @param modelMap
	 * @throws Exception
	 */
	public void mindex(Box box, ModelMap model, HttpSession session) throws Exception {


		Box userBox = (Box)session.getAttribute(CmnConst.SES_USER_DATA);

		if ((userBox != null && !userBox.isEmpty())) {
			log.debug(box.nvl("userId"));
			log.debug(Base64Util.encodeString(userBox.nvl("userId")));
			if (!Base64Util.encodeString(userBox.nvl("userId")).equals(box.nvl("userId"))) {
				userBox = null;
			}
		}
//		log.debug("userBox:" + userBox);

		if ((userBox == null || userBox.isEmpty())) {
	//		log.debug(">>>>" + Base64Util.decodeString(box.nvl("userId")));
			box.put("userId", Base64Util.decodeString(box.nvl("userId")));
			box.put("userPwdBypass", "Y");
			userBox = dao.selectOne("main.userView", box);
			//사용자 조회 실패시
			if (null == userBox || userBox.isEmpty()) {
				throw new BizException("E100"); //사용자 정보가 존재하지 않습니다.
			}
			box.put("ipAddr", HttpUtil.getRemoteIpAddr(SpringUtil.getHttpServletRequest()));
			box.put("webMobGb", "M"); //M: 모바일, W: 웹

			//login한 사용자의권한을 가져온다
			userBox.put("roleList", dao.selectList("main.authList" , userBox));

			userBox.put("mAuthCd", userBox.nvl("authCd").substring(0, 1));
			userBox.put("redirectUrl", CmnConst.M_REDIRECT_URL);
			userBox.put("safariYn", box.nvl("safariYn"));

			session.setAttribute(CmnConst.SES_USER_ID, userBox.nvl("userId"));
			session.setAttribute(CmnConst.SES_USER_DATA, userBox);
			session.setMaxInactiveInterval(sessionTimeout * 60);
		}

		//권한에 따른 index 페이지 분기처리
		if (userBox.nvl("mAuthCd").equals("1")) { //최고관리자
			model.put("indexUrl", "mobile:/mobile/mset/indexCenter");
		} else if (userBox.nvl("mAuthCd").equals("2")) { //웹관리자
			model.put("indexUrl", "mobile:/mobile/mset/indexCenter");
		} else if (userBox.nvl("mAuthCd").equals("3")) { //배송기사
			model.put("indexUrl", "mobile:/mobile/mset/indexDeli");
		} else if (userBox.nvl("mAuthCd").equals("5")) { //현장관리자
			model.put("indexUrl", "mobile:/mobile/mset/indexManage");
		} else if (userBox.nvl("mAuthCd").equals("6")) { //대리점담당자
			model.put("indexUrl", "mobile:/mobile/mset/indexAgent");
		}

	}

	/**
	 * 로그아웃 처리
	 *
	 * @param paramMap
	 * @param modelMap
	 * @throws Exception
	 */
	public void logout(Box box, ModelMap model, HttpSession session) throws Exception {

//		box.put("userId", session.getAttribute(CmnConst.SES_USER_ID));
		box.put("ipAddr", HttpUtil.getRemoteIpAddr(SpringUtil.getHttpServletRequest()));
		box.put("userId", box.path("sBox/userId"));
		box.put("ipAddr", HttpUtil.getLocalIpAddr());
		box.put("loginGb", "2"); //1: 로그인, 2: 로그아웃
		box.put("webMobGb", "W"); //M: 모바일, W: 웹

		if (!"".equals(box.nvl("userId"))) { //userId가 세션에 존재할때만 로그를 쌓는다
			dao.insert("main.userHistInsert", box); //로그아웃 로그를 쌓는다.
//				dao.update("main.lastConUpdate", box); //최종접속일시 update
		}
		session.invalidate();
	}

	/**
	 * 로그아웃 처리(모바일)
	 *
	 * @param paramMap
	 * @param modelMap
	 * @throws Exception
	 */
	public void mlogout(Box box, ModelMap model, HttpSession session) throws Exception {

//		box.put("userId", session.getAttribute(CmnConst.SES_USER_ID));
		box.put("ipAddr", HttpUtil.getRemoteIpAddr(SpringUtil.getHttpServletRequest()));
		box.put("userId", box.path("sBox/userId"));
		box.put("ipAddr", HttpUtil.getLocalIpAddr());
		box.put("loginGb", "2"); //1: 로그인, 2: 로그아웃
		box.put("webMobGb", "M"); //M: 모바일, W: 웹

		if (!"".equals(box.nvl("userId"))) { //userId가 세션에 존재할때만 로그를 쌓는다
			dao.insert("main.userHistInsert", box); //로그아웃 로그를 쌓는다.
		}
		session.invalidate();

		model.put("resCd", "S200");
		model.put("resMsg", "성공");
	}
}
