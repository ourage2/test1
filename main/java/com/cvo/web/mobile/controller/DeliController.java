package com.enpem.web.mobile.controller;

import com.enpem.web.manage.service.CrateService;
import com.enpem.web.mobile.service.DeliService;

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

import java.util.List;

@Controller
@RequestMapping("mobile/deli")
public class DeliController {

	protected Logger log = LoggerFactory.getLogger(this.getClass());

	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSessionTemplate dao;

	@Autowired
	private Paginate paginate;

	@Autowired
	private DeliService deliService;
	
	@Autowired
	private CrateService crateService;
	 

	/**
	 * 현장출고 조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("inoutList")
	public void inoutList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			int totCnt = dao.selectOne("deli.inoutCnt", box);
			paginate.init(box, model, totCnt);
			model.put("list", dao.selectList("deli.inoutList", box));
		}
	}

	/**
	 * 현장출고 PK조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("inoutView")
	public void inoutView(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			model.put("view", dao.selectOne("deli.inoutView", box));
			model.put("list", dao.selectList("deli.inoutDtlList", box));
		}
	}

	/**
	 * 현장출고 임시저장, 저장
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("pkgOutCntSave")
	public void pkgOutCntSave(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			deliService.pkgOutCntSave(box, model);
		}
	}


	/**
	 * 하차검수 조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("chkList")
	public void chkList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			int totCnt = dao.selectOne("deli.chkCnt", box);
			paginate.init(box, model, totCnt);
			model.put("list", dao.selectList("deli.chkList", box));
		}
	}

	/**
	 * 하차검수 PK조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("chkView")
	public void chkView(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			model.put("view", dao.selectOne("deli.inoutView", box));
			model.put("list", dao.selectList("deli.chkDtlList", box));
		}
	}

	/**
	 * 하차검수 임시저장, 저장
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("pkgInCntSave")
	public void pkgInCntSave(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			deliService.pkgInCntSave(box, model);
		}
	}

	/**
	 * 납품정보수신 조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("infoList")
	public void infoList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			int totCnt = dao.selectOne("deli.infoCnt", box);
			paginate.init(box, model, totCnt);
			model.put("list", dao.selectList("deli.infoList", box));
		}
	}

	/**
	 * 납품정보수신 대리점 조회
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping(value = {"infoAgentList", "infoAgentList2"})
	public void infoAgentList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			model.put("view", dao.selectOne("deli.infoOne", box));
			model.put("list", dao.selectList("deli.infoAgentList", box));
		}
	}
	
	/**
	 * 공장출발대기, 공장출발대기취소
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("centerRdySave")
	public void centerRdyDtSave(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			deliService.centerRdyDtSave(box, model);
		}
	}

	/**
	 * 납품완료, 납품완료취소
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("deliSave")
	public void deliSave(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			deliService.deliYnSave(box, model);
		}
	}

	/**
	 * 도착, 도착취소
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("ioSaveRdySave")
	public void ioSaveRdySave(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			deliService.ioSaveRdyYnSave(box, model);
		}
	}
	
	/**
	 * 납품정보수신 PK조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("infoView")
	public void infoView(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			model.put("view", dao.selectOne("deli.infoView", box));
			model.put("list", dao.selectList("deli.infoDtlList", box));
		}
	}


	/**
	 * 하차, 회수 수량 저장
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("agentInOutCntSave")
	public void agentInOutCntSave(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			
			deliService.agentInOutCntSave(box, model);

			Box paramBox1 = new Box();
			paramBox1.put("shipNo", box.getString("shipNo"));
			paramBox1.put("sBox", box.get("sBox"));
			paramBox1.put("div", "driver");
			Box box2 = dao.selectOne("deli.ioSaveCntOne", paramBox1);
			int deliCnt = box2.getInt("deliCnt");
			int ioSaveCnt = box2.getInt("ioSaveCnt");
			if (deliCnt > 0 && deliCnt == ioSaveCnt) {
				int resultCnt = crateService.sapIfIoCntDriverSave(paramBox1, model);
				if (resultCnt > 0) {
					crateService.sapIfSend(paramBox1, model);
					model.put("sapIfYn", "Y");
				}
			}
		}
	}

	/**
	 * 납품내역 조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("deliList")
	public void deliList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			int totCnt = dao.selectOne("deli.deliCnt", box);
			paginate.init(box, model, totCnt);
			model.put("list", dao.selectList("deli.deliList", box));
		}
	}

	/**
	 * 납품내역 대리점 조회
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("deliAgentList")
	public void deliAgentList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			model.put("view", dao.selectOne("deli.infoAgentView", box));
			model.put("list", dao.selectList("deli.infoAgentList", box));
		}
	}

	/**
	 * 납품내역 PK조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("deliView")
	public void deliView(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			model.put("view", dao.selectOne("deli.infoView", box));
			model.put("list", dao.selectList("deli.infoDtlList", box));
		}
	}

}
