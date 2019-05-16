package com.enpem.web.manage.controller;

import java.util.ArrayList;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.enpem.web.common.biz.BizUtil;
import com.enpem.web.common.data.Box;
import com.enpem.web.common.util.HttpUtil;
import com.enpem.web.common.util.SpringUtil;
import com.enpem.web.common.util.paginate.Paginate;
import com.enpem.web.manage.service.BasisService;

@Controller
@RequestMapping("manage/basis")
public class BasisController {

	protected Logger log = LoggerFactory.getLogger(this.getClass());

	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSessionTemplate dao;

	@Autowired
	private Paginate paginate;

	@Autowired
	private BasisService basisService;

	/**
	 * 센터차량 조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("carList")
	public void carList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			box.put("srchCenterCdList", box.strToList("srchCenterCd"));
			int totCnt = dao.selectOne("basis.carCnt", box);
			paginate.init(box, model, totCnt);
			model.put("list", dao.selectList("basis.carList", box));
			BizUtil.excelDown(box, model, SpringUtil.getLookupPathForRequest());
		}
	}

	/**
	 * 센터차량 저장
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("carSave")
	public void carSave(Box box, ModelMap model) throws Exception {
		basisService.carSave(box, model);
	}

	/**
	 * 센터창고단말 조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("cargoDevList")
	public void cargoDevList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			box.put("srchCenterCdList", box.strToList("srchCenterCd"));
			model.put("list", dao.selectList("basis.cargoDevList", box));
			BizUtil.excelDown(box, model, SpringUtil.getLookupPathForRequest());
		}
	}

	/**
	 * 센터창고단말 저장
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("cargoDevSave")
	public void cargoDevSave(Box box, ModelMap model) throws Exception {
		basisService.cargoDevSave(box, model);
	}

	/**
	 * 대리점차량 조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("agentCarList")
	public void agentCarList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			box.put("srchCenterCdList", box.strToList("srchCenterCd"));
			box.put("agentYn", "Y");
			int totCnt = dao.selectOne("basis.carCnt", box);
			paginate.init(box, model, totCnt);
			model.put("list", dao.selectList("basis.carList", box));
			BizUtil.excelDown(box, model, SpringUtil.getLookupPathForRequest());
		}
	}

	/**
	 * 대리점차량 저장
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("agentCarSave")
	public void agentCarSave(Box box, ModelMap model) throws Exception {
		basisService.agentCarSave(box, model);
	}

	/**
	 * 대리점창고단말 조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("agentCargoList")
	public void agentCargoList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			box.put("srchCenterCdList", box.strToList("srchCenterCd"));
			box.put("agentYn", "Y");
			int totCnt = dao.selectOne("basis.cargoDevCnt", box);
			paginate.init(box, model, totCnt);
			model.put("list", dao.selectList("basis.cargoDevList", box));
			BizUtil.excelDown(box, model, SpringUtil.getLookupPathForRequest());
		}
	}

	/**
	 * 대리점창고단말 저장
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("agentCargoSave")
	public void agentCargoSave(Box box, ModelMap model) throws Exception {
		basisService.agentCargoSave(box, model);
	}

	/**
	 * 대리점 조회(대리점찾기 팝업)
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping({"agentList", "agentFindList"})
	public void agentList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			box.put("srchCenterCdList", box.strToList("srchCenterCd"));
			int totCnt = dao.selectOne("basis.agentCnt", box);
			paginate.init(box, model, totCnt);
			model.put("list", dao.selectList("basis.agentList", box));
			BizUtil.excelDown(box, model, SpringUtil.getLookupPathForRequest());
		}
	}

	/**
	 * 대리점 조회(대리점출도착)
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("agentIoList")
	public void agentIoList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			box.put("srchCenterCdList", box.strToList("srchCenterCd"));
//			box.put("srchCenterCdList", box.strToList("srchCenterCd", null, box.path("sBox/centerCd")));
			int totCnt = dao.selectOne("basis.agentCnt", box);
			paginate.init(box, model, totCnt);
			model.put("list", dao.selectList("basis.agentList", box));
			BizUtil.excelDown(box, model, SpringUtil.getLookupPathForRequest());
		}
	}

	/**
	 * 대리점출도착 일괄설정 팝업
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("agentIoBatch")
	public void agentIoBatch(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
		}
	}

	/**
	 * 대리점 위치조회 팝업
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("agentLoc")
	public void agentLoc(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			box.put("srchCenterCdList", box.strToList("srchCenterCd"));
			model.put("list", dao.selectList("basis.agentList", box));
		}
	}

	/**
	 * 대리점 좌표지정 팝업
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("agentMap")
	public void agentMap(Box box, ModelMap model) throws Exception {

//		if (!box.nvl("data").equals("")) {
//			box.put("resData", JsonUtil.toObject(box.nvl("data"), Box.class));
//		}
		if (HttpUtil.isDataExtension()) {
		}
	}

	/**
	 * 대리점찾기 팝업
	 *
	 * @param box the box
	 * @param model the model box
	 */
//	@RequestMapping("agentFindList")
//	public void agentFindList(Box box, ModelMap model) throws Exception {
//		if (HttpUtil.isDataExtension()) {
//		}
//	}

	/**
	 * 대리점출도착 일괄저장
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("agentIoSave")
	public void agentIoSave(Box box, MultipartHttpServletRequest mReq, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			basisService.agentIoSave(box, mReq, model);
		}
	}

	/**
	 * 대리점출도착 최종업데이트 조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("agentLastUpdateView")
	public void agentLastUpdateView(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			model.put("view", dao.selectOne("basis.agentLastUpdateView", box));
		}
	}



	/**
	 * 대리점 저장
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("agentSave")
	public void agentSave(Box box, ModelMap model) throws Exception {
		basisService.agentSave(box, model);
	}

	/**
	 * 사용자 조회 (사용자찾기 팝업)
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping({"userList", "userFindList"})
	public void userList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			box.put("srchCenterCdList", box.strToList("srchCenterCd"));
			box.put("pushIdArry", box.getArry("pushIds", ","));
			int totCnt = dao.selectOne("basis.userCnt", box);
			paginate.init(box, model, totCnt);
			model.put("list", dao.selectList("basis.userList", box));
			BizUtil.excelDown(box, model, SpringUtil.getLookupPathForRequest());
		} else {
			box.put("srchUseYn", "Y");
		}

	}

	/**
	 * 사용자 PK조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("userView")
	public void userView(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			model.put("view", dao.selectOne("basis.userView", box));
		}
	}

	/**
	 * 사용자 저장
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("userSave")
	public void userSave(Box box, ModelMap model) throws Exception {
		basisService.userSave(box, model);
	}

	/**
	 * 사용자 패스워드 초기화
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("userPwdResetUpdate")
	public void userPwdResetUpdate(Box box, ModelMap model) throws Exception {
		basisService.userPwdResetUpdate(box, model);
	}

	/**
	 * 사용자 패스워드 변경
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("userPwdUpdate")
	public void userPwdUpdate(Box box, ModelMap model) throws Exception {
		basisService.userPwdUpdate(box, model);
	}

	/**
	 * 권한 조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("authList")
	public void authList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			model.put("list", dao.selectList("basis.authList", box));
		}
	}

	/**
	 * 권한별 유저 조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("authUserList")
	public void authUserList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			model.put("list", dao.selectList("basis.authUserList", box));
		}
	}

	/**
	 * 메뉴별권한 조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("menuAuthList")
	public void menuAuthList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			model.put("list", dao.selectList("basis.menuAuthList", box));
		}
	}

	/**
	 * 권한 저장
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("authSave")
	public void authSave(Box box, ModelMap model) throws Exception {
		basisService.authSave(box, model);
	}

	/**
	 * 메뉴별권한 일괄저장
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("menuAuthSave")
	public void menuAuthSave(Box box, ModelMap model) throws Exception {
		basisService.menuAuthSave(box, model);
	}

	/**
	 * 차량휴무 조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("restList")
	public void restList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			box.put("srchCenterCdList", box.strToList("srchCenterCd"));
			model.put("list", dao.selectList("basis.restList", box));
			BizUtil.excelDown(box, model, SpringUtil.getLookupPathForRequest());
		}
	}

	/**
	 * 차량휴무 조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("restBatchList")
	public void restBatchList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			box.put("srchCenterCdList", box.strToList("srchCenterCd", null, box.path("sBox/centerCd")));
			model.put("list", dao.selectList("basis.restList", box));
			BizUtil.excelDown(box, model, SpringUtil.getLookupPathForRequest());
		}
	}

	/**
	 * 차량휴무 일괄설정 팝업
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("restBatch")
	public void restBatch(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
		}
	}

	/**
	 * 차량휴무 최종업데이트 조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("restLastUpdateView")
	public void restLastUpdateView(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			model.put("view", dao.selectOne("basis.restLastUpdateView", box));
		}
	}

	/**
	 * 차량휴무 일괄저장
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("restSave")
	public void restSave(Box box, MultipartHttpServletRequest mReq, ModelMap model) throws Exception {
		basisService.restSave(box, mReq, model);
	}
}
