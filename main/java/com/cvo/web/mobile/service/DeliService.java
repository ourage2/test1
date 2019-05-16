package com.enpem.web.mobile.service;

import com.enpem.web.common.data.Box;

import com.enpem.web.common.util.StringUtil;
import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import java.util.List;

@Service
public class DeliService {

	protected Logger log = LoggerFactory.getLogger(this.getClass());

	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSessionTemplate dao;

	/**
	 * 현장출고 임시저장, 저장
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	public void pkgOutCntSave(Box box, ModelMap model) throws Exception {

		int result = 0;

		List<Box> list = box.getList("list");
		String shipNo = null;

		for (Box bx1 : list) {
			result += dao.update("deli.pkgOutCntUpdate", bx1);
			shipNo = bx1.getString("shipNo");
		}

		if ("N".equals(box.getString("tempYn"))) {
			Box box1 = new Box();
			box1.put("shipNo", shipNo);
			box1.put("releaseYn", "Y");
			box1.put("sBox", box.get("sBox"));
			result += dao.update("deli.releaseYnUpdate", box1);
		}

		model.put("result", result);
	}

	/**
	 * 하차검수 임시저장, 저장
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	public void pkgInCntSave(Box box, ModelMap model) throws Exception {

		int result = 0;

		List<Box> list = box.getList("list");
		String shipNo = null;

		for (Box bx1 : list) {
			result += dao.update("deli.pkgInCntUpdate", bx1);
			result += dao.update("deli.inoutDifYnUpdate", bx1);
			shipNo = bx1.getString("shipNo");
		}

		if ("N".equals(box.getString("tempYn"))) {
			Box box1 = new Box();
			box1.put("shipNo", shipNo);
			box1.put("unloadChkYn", "Y");
			box1.put("sBox", box.get("sBox"));
			result += dao.update("deli.unloadChkYnUpdate", box1);
		}

		model.put("result", result);
	}

	/**
	 * 공장출발대기
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	public void centerRdyDtSave(Box box, ModelMap model) throws Exception {
		int result = 0;
		
		Box infoOne = dao.selectOne("deli.infoOne", box);
		
		boolean update = true;
		String resMsg = null;
		
		String rdyYn = box.getString("rdyYn");
		String centerRdyYn = infoOne.getString("centerRdyYn");
		
		String linkShipYn = box.getString("linkShipYn");	//연계배송여부
		
		if ("Y".equals(rdyYn)) {
			
			if ("Y".equals(linkShipYn)) {
				String expectLinkShipNo = infoOne.getString("expectLinkShipNo");
				if (update && StringUtil.isEmpty(expectLinkShipNo)) {
					resMsg = "연계배송 상태가 변경되어 연계배송을 적용할 수 없습니다.";
					update = false;
				}

				if (update && infoOne.getString("refShipNoYn").equals("Y")) {
					resMsg = "현재 선적번호가 이미 연계배송 중 입니다.";
					update = false;
				}

				if (update && StringUtil.isNotEmpty(infoOne.getString("linkShipNo"))) {
					resMsg = "이미 연계배송 처리되었습니다.";
					update = false;
				}

				if (update) {
					Box param = new Box();
					param.put("shipNo", infoOne.getString("shipNo"));
					param.put("linkShipNo", infoOne.getString("expectLinkShipNo"));
					result += dao.update("deli.linkShipNoUpdate", param);
				}
			}
			
//			if (update && infoOne.getInt("arrCnt") > 0) {
//				resMsg = "대리점에 도착하여 공장 출발 대기가 불가합니다.";
//				update = false;
//			}
			
			if (update &&"Y".equals(centerRdyYn)) {
				resMsg = "이미 공장 출발 대기 처리되었습니다.";
				update = false;
			}
			
		} else if("N".equals(rdyYn)) {

			if (update && infoOne.getString("refShipNoYn").equals("Y")) {
				resMsg = "현재 선적번호가 연계배송중으로 공장 출발 대기 취소가 불가합니다.";
				update = false;
			}
				
			if (update && infoOne.getInt("arrCnt") > 0) {
				resMsg = "대리점에 도착하여 공장 출발 대기 취소가 불가합니다.";
				update = false;
			}

			if (update && "N".equals(centerRdyYn)) {
				resMsg = "이미 공장 출발 대기 취소 처리되었습니다.";
				update = false;
			}

			if (update && StringUtil.isNotEmpty(infoOne.getString("linkShipNo"))) {
				Box param = new Box();
				param.put("shipNo", infoOne.getString("shipNo"));
				result += dao.update("deli.linkShipNoUpdate", param);
			}
		}

		if (update) {
			result += dao.update("deli.centerRdyDtUpdate", box);
		}
		
		model.put("result", result);
		model.put("resMsg", resMsg);
	}

	/**
	 * 납품완료, 납품완료취소
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	public void deliYnSave(Box box, ModelMap model) throws Exception {
		int result = 0;
		
		Box infoOne = dao.selectOne("deli.infoOne", box);
		
		boolean update = true;
		String resMsg = null;
		
		String deliYnNew = box.getString("deliYn");
		String deliYn = infoOne.getString("deliYn");
		
		if ("Y".equals(deliYnNew)) {
			if ("Y".equals(deliYn)) {
				resMsg = "이미 납품 완료 처리 되었습니다.";
				update = false;
			}
			
		} else if("N".equals(deliYnNew)) {

			if (update && "Y".equals(infoOne.getString("centerRtnYn"))) {
				resMsg = "차량이 센터로 회송되어 납품 완료 취소가 불가합니다.";
				update = false;
			}

			if (update && "N".equals(deliYn)) {
				resMsg = "이미 납품 완료 취소 되었습니다.";
				update = false;
			}
		}

		if (update) {
			result += dao.update("deli.deliYnUpdate", box);
		}
		
		model.put("result", result);
		model.put("resMsg", resMsg);
	}

	/**
	 * 도착, 도착취소
	 * 출고회수수량저장준비여부 변경
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	public void ioSaveRdyYnSave(Box box, ModelMap model) throws Exception {
		int result = 0;
		
		Box infoAgentOne = dao.selectOne("deli.infoAgentOne", box);
		
		String ioSaveRdyYnNew = box.getString("ioSaveRdyYn");
		String ioSaveRdyYn = infoAgentOne.getString("ioSaveRdyYn");
		
		boolean update = false;
		String resMsg = null;
		
		if ("Y".equals(ioSaveRdyYnNew)) {
			if ("Y".equals(ioSaveRdyYn)) {
				resMsg = "이미 도착 처리되었습니다.";
			} else {
				update = true;
			}
		} else if("N".equals(ioSaveRdyYnNew)) {
			if ("N".equals(ioSaveRdyYn)) {
				resMsg = "이미 도착 취소 처리되었습니다.";
			} else {
				update = true;
			}
		}

		if (update) {
			result += dao.update("deli.ioSaveRdyYnUpdate", box);
		}

		model.put("result", result);
		model.put("resMsg", resMsg);
	}

	/**
	 * 하차, 회수 수량 저장
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	public void agentInOutCntSave(Box box, ModelMap model) throws Exception {
		int result = 0;

		List<Box> list = box.getList("list");

		String shipNo = null;
		String agentCd = null;
		String deliNo = null;
		for (Box bx1 : list) {
			result += dao.update("deli.agentInOutCntUpdate", bx1);

			shipNo = bx1.getString("shipNo");
			agentCd = bx1.getString("agentCd");
			deliNo = bx1.getString("deliNo");
		}

		if (result > 0) {
			Box box1 = new Box();
			box1.put("shipNo", shipNo);
			box1.put("agentCd", agentCd);
			box1.put("deliNo", deliNo);
			box1.put("sBox", box.get("sBox"));
			result += dao.update("deli.ioSaveYnUpdate", box1);
		}

		model.put("result", result);
	}

}
