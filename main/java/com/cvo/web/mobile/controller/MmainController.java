package com.enpem.web.mobile.controller;

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
import com.enpem.web.common.util.HttpUtil;
import com.enpem.web.main.service.MainService;

@Controller
@RequestMapping("mobile/mmain")
public class MmainController {

	protected Logger log = LoggerFactory.getLogger(this.getClass());

	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSessionTemplate dao;

	@Autowired
	private MainService mainService;


	/**
	 * 모바일 login 페이지
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("mlogin")
	public void mlogin(Box box, HttpSession session, ModelMap model) throws Exception {
	}

	/**
	 * 모바일 logout 페이지
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("mlogout")
	public void mlogout(Box box, HttpSession session, ModelMap model) throws Exception {
		mainService.mlogout(box, model, session);
	}

	/**
	 * menu index 페이지
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("mindex")
	public String mindex(Box box, HttpSession session, ModelMap model) throws Exception {
		mainService.mindex(box, model, session);
		return model.get("indexUrl").toString();
	}

	/**
	 * 알림내역 카운트
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("alarmCnt")
	public void alarmCnt(Box box, HttpSession session, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			Box userBox = (Box)session.getAttribute(CmnConst.SES_USER_DATA);
			if (userBox != null) {
				model.put("alarmCnt", dao.selectOne("mset.alarmCnt", box));
			} else {
				model.put("alarmCnt", 0);
			}
		}
	}


}
