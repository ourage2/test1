package com.enpem.web.manage.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import com.enpem.web.common.biz.BizUtil;
import com.enpem.web.common.data.Box;
import com.enpem.web.common.util.ExcelUtil;
import com.enpem.web.common.util.HttpUtil;
import com.enpem.web.common.util.SpringUtil;
import com.enpem.web.common.util.paginate.Paginate;
import com.enpem.web.manage.service.SetService;

@Controller
@RequestMapping("manage/set")
public class SetController {

	protected Logger log = LoggerFactory.getLogger(this.getClass());

	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSessionTemplate dao;

	@Autowired
	private SetService setService;

	@Autowired
	private Paginate paginate;

	/**
	 * 그룹코드 조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("grpCdList")
	public void grpCdList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			model.put("list", dao.selectList("set.grpCdList", box));
		}
	}

	/**
	 * 그룹코드 저장
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("grpCdSave")
	public void grpCdSave(Box box, ModelMap model) throws Exception {
		setService.grpCdSave(box, model);
	}

	/**
	 * 코드 조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("cdList")
	public void cdList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			model.put("list", dao.selectList("set.cdList", box));
		}
	}

	/**
	 * 코드 저장
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("cdSave")
	public void cdSave(Box box, ModelMap model) throws Exception {
		setService.cdSave(box, model);
	}

	/**
	 * 메시지 조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("msgList")
	public void msgList(Box box, ModelMap model) throws Exception {

		if (HttpUtil.isDataExtension()) {
			int totCnt = dao.selectOne("set.msgCnt", box);
			paginate.init(box, model, totCnt);
			model.put("list", dao.selectList("set.msgList", box));
			BizUtil.excelDown(box, model, SpringUtil.getLookupPathForRequest());
		}

	}

	/**
	 * 메시지 PK조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("msgView")
	public void msgView(Box box, ModelMap model) throws Exception {
		model.put("view", dao.selectOne("set.msgView", box));
	}

	/**
	 * 메시지 저장
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("msgSave")
	public void msgSave(Box box, ModelMap model) throws Exception {
		setService.msgSave(box, model);
	}

	/**
	 * 사용자접속로그 조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("userHistList")
	public void userHistList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			int totCnt = dao.selectOne("set.userHistCnt", box);
			paginate.init(box, model, totCnt);
			model.put("list", dao.selectList("set.userHistList", box));
			BizUtil.excelDown(box, model, SpringUtil.getLookupPathForRequest());
		}

	}

	/**
	 * 공지사항 조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("noticeList")
	public void noticeList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			int totCnt = dao.selectOne("set.noticeCnt", box);
			paginate.init(box, model, totCnt);
			model.put("list", dao.selectList("set.noticeList", box));
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
			model.put("view", dao.selectOne("set.noticeView", box));

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
	@RequestMapping("noticeSave")
	public void noticeSave(Box box, ModelMap model) throws Exception {
		setService.noticeSave(box, model);
	}

	/**
	 * 1대1문의 조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("qnaList")
	public void qnaList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			int totCnt = dao.selectOne("set.qnaCnt", box);
			paginate.init(box, model, totCnt);
			model.put("list", dao.selectList("set.qnaList", box));
		}
	}

	/**
	 * 1대1문의 PK조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("qnaView")
	public void qnaView(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			model.put("view", dao.selectOne("set.qnaView", box));

			box.put("fileDiv", "QNA");
			box.put("fileKey", box.nvl("seq"));
			box.put("delYn", "N");
			box.put("tempYn", "N");
			model.put("fileList", dao.selectList("cmn.fileList", box));
		}
	}

	/**
	 * 1대1문의질문 저장
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("qnaSave")
	public void qnaSave(Box box, ModelMap model) throws Exception {
		setService.qnaSave(box, model);
	}

	/**
	 * 1대1문의답변 저장
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("qnaAnsSave")
	public void qnaAnsSave(Box box, ModelMap model) throws Exception {
		setService.qnaAnsSave(box, model);
	}

	/**
	 * 미등록단말기내역 조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("noregDevList")
	public void noregDevList(Box box, ModelMap model) throws Exception {

		if (HttpUtil.isDataExtension()) {
			int totCnt = dao.selectOne("set.noregDevCnt", box);
			paginate.init(box, model, totCnt);
			model.put("list", dao.selectList("set.noregDevList", box));
			BizUtil.excelDown(box, model, SpringUtil.getLookupPathForRequest());
		}
	}

	/**
	 * 미등록단말기차량목록 조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("noregCarList")
	public void noregCarList(Box box, ModelMap model) throws Exception {

		if (HttpUtil.isDataExtension()) {
			model.put("list", dao.selectList("set.noregCarList", box));
		}
	}

	/**
	 * 미등록대리점 조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("noregAgentList")
	public void noregAgentList(Box box, ModelMap model) throws Exception {

		if (HttpUtil.isDataExtension()) {
			int totCnt = dao.selectOne("set.noregAgentCnt", box);
			paginate.init(box, model, totCnt);
			model.put("list", dao.selectList("set.noregAgentList", box));
			BizUtil.excelDown(box, model, SpringUtil.getLookupPathForRequest());
		}
	}

	/**
	 * 알림발송이력 조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("alarmHistList")
	public void alarmHistList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			int totCnt = dao.selectOne("set.alarmHistCnt", box);
			paginate.init(box, model, totCnt);
			model.put("list", dao.selectList("set.alarmHistList", box));
			BizUtil.excelDown(box, model, SpringUtil.getLookupPathForRequest());
		}
	}

	/**
	 * 알림발송
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("alarmSend")
	public void alarmSend(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			setService.alarmSend(box, model);
		}
	}

	/**
	 * 대용량엑셀 다운로드 조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("csvList")
	public void csvList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			box.put("srchCenterCdList", box.strToList("srchCenterCd"));
			int totCnt = dao.selectOne("set.csvCnt", box);
			paginate.init(box, model, totCnt);
			model.put("list", dao.selectList("set.csvList", box));
		}
	}
}
