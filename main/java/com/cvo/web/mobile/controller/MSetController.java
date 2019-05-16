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

import com.enpem.web.common.data.Box;
import com.enpem.web.common.util.HttpUtil;
import com.enpem.web.common.util.paginate.Paginate;
import com.enpem.web.main.service.MainService;
import com.enpem.web.mobile.service.MSetService;

@Controller
@RequestMapping("mobile/mset")
public class MSetController {

	protected Logger log = LoggerFactory.getLogger(this.getClass());

	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSessionTemplate dao;

	@Autowired
	private MSetService msetService;

	@Autowired
	private Paginate paginate;

	@Autowired
	private MainService mainService;

	/**
	 * 공지사항 조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("noticeList")
	public void noticeList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			int totCnt = dao.selectOne("mset.noticeCnt", box);
//			box.put("pageUnit", 1);
			paginate.init(box, model, totCnt);
			model.put("list", dao.selectList("mset.noticeList", box));
		}
	}

	/**
	 * 공지사항 PK조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("noticeView")
	public void noticeView(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			model.put("view", dao.selectOne("mset.noticeView", box));

			box.put("fileDiv", "NOTICE");
			box.put("fileKey", box.nvl("seq"));
			box.put("delYn", "N");
			box.put("tempYn", "N");
			model.put("fileList", dao.selectList("cmn.fileList", box));
		}
	}

	/**
	 * 공지사항 저장
	 *
	 * @param box the box
	 * @param model the model box
	 */
//	@RequestMapping("noticeSave")
//	public void noticeSave(Box box, ModelMap model) throws Exception {
//		msetService.noticeSave(box, model);
//	}

	/**
	 * 패스워드변경 PK조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("pwdView")
	public void pwdView(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
//			model.put("view", dao.selectOne("mset.pwdView", box));
		}
	}

	/**
	 * 패스워드변경 저장
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("pwdSave")
	public void pwdSave(Box box, ModelMap model) throws Exception {
		msetService.pwdSave(box, model);
	}

	/**
	 * 알림내역 조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("alarmList")
	public void alarmList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			int totCnt = dao.selectOne("mset.alarmCnt", box);
			paginate.init(box, model, totCnt);
			model.put("list", dao.selectList("mset.alarmList", box));
		}
	}

	/**
	 * 알림내역 PK조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
//	@RequestMapping("alarmView")
//	public void alarmView(Box box, ModelMap model) throws Exception {
//		if (HttpUtil.isDataExtension()) {
//			model.put("view", dao.selectOne("mset.alarmView", box));
//		}
//	}

	/**
	 * 현장관리자 index 페이지
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("indexManage")
	public void indexManage(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
//			model.put("view", dao.selectOne("mset.indexManageView", box));
		}
	}

	/**
	 * 배송기사 index 페이지
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("indexDeli")
	public void indexDeli(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
//			model.put("view", dao.selectOne("mset.indexDeliView", box));
		}
	}

	/**
	 * 센터담당자 index 페이지
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("indexCenter")
	public void indexCenter(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			model.put("view", dao.selectOne("mset.indexCenterView", box));
		}
	}

	/**
	 * 차량관리 팝업
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("carManage")
	public void carManage(Box box, ModelMap model) throws Exception {
	}

	/**
	 * 온도관리 팝업
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("tempManage")
	public void tempManage(Box box, ModelMap model) throws Exception {
	}

	/**
	 * 대리점관리자 index 페이지
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("indexAgent")
	public void indexAgent(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			model.put("view", dao.selectOne("mset.indexAgentView", box));
		}
	}

}
