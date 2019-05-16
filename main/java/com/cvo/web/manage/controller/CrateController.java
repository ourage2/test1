package com.enpem.web.manage.controller;

import com.enpem.web.common.biz.BizUtil;
import com.enpem.web.common.data.Box;
import com.enpem.web.common.util.HttpUtil;
import com.enpem.web.common.util.SpringUtil;
import com.enpem.web.common.util.paginate.Paginate;
import com.enpem.web.manage.service.CrateService;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("manage/crate")
public class CrateController {

	protected Logger log = LoggerFactory.getLogger(this.getClass());

	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSessionTemplate dao;

	@Autowired
	private Paginate paginate;

	@Autowired
	private CrateService crateService;


	/**
	 * SAP인터페이스 현황
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("sapIfList")
	public void sapIfList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			box.put("srchCenterCdList", box.strToList("srchCenterCd"));
			int totCnt = dao.selectOne("crate.sapIfCnt", box);
			paginate.init(box, model, totCnt);
			model.put("list", dao.selectList("crate.sapIfList", box));
			BizUtil.excelDown(box, model, SpringUtil.getLookupPathForRequest());
		}
	}

	/**
	 * 포장재 회수현황
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("inOutList")
	public void inOutList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			box.put("srchCenterCdList", box.strToList("srchCenterCd"));
//			int totCnt = dao.selectOne("crate.inOutCnt", box);

			paginate.init(box, model);
			List<Box> list = dao.selectList("crate.inOutList", box);

			model.put("list", list);

			int totCnt = 0;
			if (list != null && list.size() > 0) {
				totCnt = list.get(0).getInt("totCnt");
			}
			paginate.init(box, model, totCnt);

			BizUtil.excelDown(box, model, SpringUtil.getLookupPathForRequest());
		}
	}

	/**
	 * 포장재 회수수량 조정 조회
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("inOutCntAdjList")
	public void inOutCntAdjList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			// int totCnt = dao.selectOne("crate.inOutCntAdjCnt", box);
			// paginate.init(box, model, totCnt);
			model.put("list", dao.selectList("crate.inOutCntAdjList", box));
		}
	}

	/**
	 * 포장재 회수수량 조정 저장
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("inOutCntAdjSave")
	public void inOutCntAdjSave(Box box, ModelMap model) throws Exception {
		box.put("div", "ioCntAdj");
		box.put("ifFlg", "2");
		crateService.inOutCntAdjSave(box, model);
		crateService.sapIfSend(box, model);
	}

	/**
	 * 전표확인 여부 저장
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("rcptYnSave")
	public void rcptYnSave(Box box, ModelMap model) throws Exception {
		crateService.rcptYnSave(box, model);
	}

	/**
	 * 관리자수정 이력조회
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("inOutAdjResultList")
	public void inOutAdjResultList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			box.put("srchCenterCdList", box.strToList("srchCenterCd"));
			int totCnt = dao.selectOne("crate.inOutAdjResultCnt", box);
			paginate.init(box, model, totCnt);
			model.put("list", dao.selectList("crate.inOutAdjResultList", box));
			BizUtil.excelDown(box, model, SpringUtil.getLookupPathForRequest());
		}
	}

	/**
	 * 포장재 회수현황 통계관리
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("inOutAnalList")
	public void inOutAnalList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			box.put("srchCenterCdList", box.strToList("srchCenterCd"));
			int totCnt = dao.selectOne("crate.inOutAnalCnt", box);
			paginate.init(box, model, totCnt);
			model.put("list", dao.selectList("crate.inOutAnalList", box));
			BizUtil.excelDown(box, model, SpringUtil.getLookupPathForRequest());
		}
	}


	/**
	 * SAP 전송여부조회
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("sapIfResultList")
	public void sapIfResultList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			box.put("srchCenterCdList", box.strToList("srchCenterCd"));
			int totCnt = dao.selectOne("crate.sapIfResultCnt", box);
			paginate.init(box, model, totCnt);
			model.put("list", dao.selectList("crate.sapIfResultList", box));
			BizUtil.excelDown(box, model, SpringUtil.getLookupPathForRequest());
		}
	}

	/**
	 * SAP 전송여부조회 - 수동전송
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("sapIfManualSend")
	public void sapIfManualSend(Box box, ModelMap model) throws Exception {

		if ("json".equalsIgnoreCase(HttpUtil.getExt())) {
			box.put("div", "manual");
			box.put("ifFlg", "1");
			crateService.sapIfManualSend(box, model);
			crateService.sapIfSend(box, model);
		}

	}

//	/**
//	 * SAP 전송 테스트
//	 * @param box
//	 * @param model
//	 * @throws Exception
//	 */
//	@RequestMapping("sapIfSend")
//	public void sapIfSend(Box box, ModelMap model) throws Exception {
//		if ("json".equalsIgnoreCase(HttpUtil.getExt())) {
//			crateService.sapIfIoCntBatchSave(box, model);
//			crateService.sapIfSend(box, model);
//		}
//	}
}
