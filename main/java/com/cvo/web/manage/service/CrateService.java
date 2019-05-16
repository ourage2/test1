package com.enpem.web.manage.service;

import com.enpem.web.common.data.Box;

import com.enpem.web.common.util.ConfigUtil;
import com.enpem.web.common.util.StringUtil;
import dsic.client.DsicPayloadClient;
import dsic.message.BaseMessage;
import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import dsic.message.ext.JcoJsonMessage;
import dsic.message.ext.DataSet;

@Service
public class CrateService {

	protected Logger log = LoggerFactory.getLogger(this.getClass());

	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSessionTemplate dao;

	/**
	 * 포장재 회수수량 조정 저장
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	public void inOutCntAdjSave(Box box, ModelMap model) throws Exception {
		int result = 0;

		List<Box> list = box.getList("list");

		for (Box box1 : list) {
			result += dao.update("crate.pkgAgentAdjCntUpdate", box1);
			result += dao.update("crate.pkgAdjUpdate", box1);

			// ASIS IDW_SP_ZSDS_MANAGER_SET
			box1.put("div", "ioCntAdj");
			box1.put("ifFlg", "2");

			Box seqnoParam = new Box();
			seqnoParam.put("shipNo", box1.getString("shipNo"));
			seqnoParam.put("ifFlg", "2");

			box1.put("seqno", dao.selectOne("crate.ifZsds4103Seqno", seqnoParam));
			result += dao.insert("crate.outCntIfMerge", box1);

			box1.put("seqno", dao.selectOne("crate.ifZsds4104Seqno", seqnoParam));
			result += dao.insert("crate.inCntIfMerge", box1);
		}

		model.put("result", result);
	}

	/**
	 * 전표확인 여부 저장
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	public void rcptYnSave(Box box, ModelMap model) throws Exception {
		int result = 0;

		List<Box> list = box.getList("list");

		for(Box box1 : list) {
			result += dao.update("crate.rcptYnUpdate", box1);
		}

		model.put("result", result);
	}


	/**
	 * SAP 전송여부조회 - 수동전송
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	public void sapIfManualSend(Box box, ModelMap model) throws Exception {
		int result = 0;

		// ASIS IDW_SP_ZSDS_DRIVER_SET_MANUAL
//		box.put("div", "manual");
//		box.put("ifFlg", "1");
		result += dao.insert("crate.outCntIfInsert", box);
		result += dao.insert("crate.inCntIfInsert", box);

		box.put("outCntIfStat", "R");
		box.put("inCntIfStat", "R");
		result += dao.update("crate.deliDtlIfStatUpdate", box);

		model.put("result", result);
	}

	/**
	 * 모바일 하차, 회수 수량 저장 할 때 마지막 대리점인 경우 SAP 전송 데이터 저장
	 *
	 * @see com.enpem.web.mobile.controller.DeliController#agentInOutCntSave(Box, ModelMap)
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	public int sapIfIoCntDriverSave(Box box, ModelMap model) throws Exception {

		int result = 0;

		// ASIS IDW_SP_ZSDS_DRIVER_SET
		box.put("div", "driver");
		box.put("ifFlg", "1");

		box.put("inOut", "out");
		result += dao.insert("crate.outCntIfInsert", box);

		box.put("inOut", "in");
		result += dao.insert("crate.inCntIfInsert", box);

		box.put("outCntIfStat", "R");
		result += dao.update("crate.deliDtlIfStatUpdate", box);
		box.remove("outCntIfStat");

		box.put("inCntIfStat", "R");
		result += dao.update("crate.deliDtlIfStatUpdate", box);
		box.remove("inCntIfStat");

		model.put("result", result);

		log.debug("sapIfIoCntDriverSave result = {}", result);

		return result;
	}

	/**
	 * 배치 하차, 회수 수량 SAP 전송 데이터 저장
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	public void sapIfIoCntBatchSave(Box box, ModelMap model) throws Exception {
		int result = 0;

		List<Box> outDeliDtlList = dao.selectList("crate.batchOutDeliDtlList");
		for (Box outDeliDtl : outDeliDtlList) {
			outDeliDtl.put("div", "batch");
			outDeliDtl.put("ifFlg", "1");
			result += dao.insert("crate.outCntIfInsert", outDeliDtl);

			outDeliDtl.put("outCntIfStat", "R");
			result += dao.update("crate.deliDtlIfStatUpdate", outDeliDtl);
		}

		List<Box> inDeliDtlList = dao.selectList("crate.batchInDeliDtlList");
		for (Box inDeliDtl : inDeliDtlList) {
			inDeliDtl.put("div", "batch");
			inDeliDtl.put("ifFlg", "1");
			result += dao.insert("crate.inCntIfInsert", inDeliDtl);

			inDeliDtl.put("inCntIfStat", "R");
			result += dao.update("crate.deliDtlIfStatUpdate", inDeliDtl);
		}

		model.put("result", result);
	}

	/**
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	public void sapIfSend(Box box, ModelMap model) throws Exception {

		String gwIp = ConfigUtil.getString("sap.gw.ip"); //SAP GW IP
		int gwPort = ConfigUtil.getInt("sap.gw.port");

		DsicPayloadClient sapGwClient = new DsicPayloadClient(gwIp, gwPort);	//SAP Client

		List<String> zsds4103SeqNoList = dao.selectList("crate.ifZsds4103SeqNoList", box);

		if (zsds4103SeqNoList != null && zsds4103SeqNoList.size() > 0) {
			List<Box> zsds4103List = dao.selectList("crate.ifZsds4103List", box);
			final String[] COLS = new String[]{"SEQNO", "VBELN", "WADAT", "KUNNR", "MATNR", "WERKS", "IF_FLG", "LFIMG", "LFIMG_C", "ZUSER", "SGTXT"};
			this.sapIfSendExec(sapGwClient, "ZSDS4103", COLS, zsds4103SeqNoList, zsds4103List);
		}

		List<String> zsds4104SeqNoList = dao.selectList("crate.ifZsds4104SeqNoList", box);

		if (zsds4104SeqNoList != null && zsds4104SeqNoList.size() > 0) {
			List<Box> zsds4104List = dao.selectList("crate.ifZsds4104List", box);
			final String[] COLS = new String[]{"ZVBELN", "SEQNO", "KUNNR", "WERKS", "MATNR", "IF_FLG", "WADAT", "LFIMG", "LFIMG_C", "ZUSER", "TDLNR", "SGTXT"};
			this.sapIfSendExec(sapGwClient, "ZSDS4104", COLS, zsds4104SeqNoList, zsds4104List);
		}
	}

	/**
	 * @param dateSetName
	 * @param cols
	 * @param seqNoList
	 * @param boxList
	 * @throws Exception
	 */
	private void sapIfSendExec(final DsicPayloadClient sapGwClient, final String dateSetName, final String[] cols, final List<String> seqNoList, final List<Box> boxList) throws Exception {

		DataSet dataSet = null;
		Box delParam = new Box();
		Set<String> deliNoList = null;

		int beginIdx = 0;

		for (String seqno : seqNoList) {

			for (int i = beginIdx; i < boxList.size(); i++) {

				Box box = boxList.get(i);

				if (seqno.equals(box.getString("seqno"))) {
					if (dataSet == null) {
						dataSet = new DataSet(dateSetName, cols);
						deliNoList = new HashSet<String>();

						delParam.put("seqno", box.getString("seqno"));
						delParam.put("shipno", box.getString("shipno"));
//						delParam.put("vbeln", box.getString("vbeln"));
					}
					deliNoList.add(box.getString("vbeln"));

					List<String> valList = new ArrayList<String>();
					for (String col : cols) {
						valList.add(box.getString(StringUtil.toCamel(col)));
					}

					dataSet.addRow(valList);

				} else {
					beginIdx = i;
					break;
				}
			}

			//데이타셋을 전송한다.
			//JSON 메시지 준비
			JcoJsonMessage reqMsg = new JcoJsonMessage();

			//SAP RFC FunctionName 지정
			reqMsg.setServiceName("Zenpem_SMT_CRATE_QTY");

			//데이타셋 추가
			reqMsg.addDataSet(dataSet);
			dataSet = null;

			log.info("reqMsg = {}", reqMsg.toString());

			//SAP GW로 전송
			try {
				BaseMessage resMsg = sapGwClient.sendReceive(reqMsg);


				Box ifStatBox = new Box();
				ifStatBox.put("shipNo", delParam.getString("shipno"));
				ifStatBox.put("deliNoList", deliNoList);

				Box sapIfHist = new Box();
				sapIfHist.put("ifSeq", seqno);
				sapIfHist.put("sendDiv", "U");
				sapIfHist.put("shipNo", delParam.getString("shipno"));
				sapIfHist.put("deliNoList", deliNoList);


				if ("ZSDS4103".equals(dateSetName)) {
					String sendResult  = StringUtil.nvl(resMsg.getParam("EV_RETURN_DELI"), "N"); //리턴코드
					String sendResultMsg = StringUtil.nvl(resMsg.getParam("EV_RETURN_MSG_DELI"), ""); //리턴메시지

					ifStatBox.put("outCntIfStat", sendResult);
					dao.update("crate.deliDtlIfStatUpdate", ifStatBox);

					sapIfHist.put("succYn", sendResult);
					sapIfHist.put("errMsg", sendResultMsg);
					sapIfHist.put("ifDivCd", "23");
					dao.insert("crate.sapIfHistInsert", sapIfHist);

					dao.delete("crate.ifZsds4103Delete", delParam);
				} else if("ZSDS4104".equals(dateSetName)) {
					String sendResult  = StringUtil.nvl(resMsg.getParam("EV_RETURN_COL"), "N"); //리턴코드
					String sendResultMsg = StringUtil.nvl(resMsg.getParam("EV_RETURN_MSG_COL"), ""); //리턴메시지

					ifStatBox.put("inCntIfStat", sendResult);
					dao.update("crate.deliDtlIfStatUpdate", ifStatBox);

					sapIfHist.put("succYn", sendResult);
					sapIfHist.put("errMsg", sendResultMsg);
					sapIfHist.put("ifDivCd", "24");
					dao.insert("crate.sapIfHistInsert", sapIfHist);

					dao.delete("crate.ifZsds4104Delete", delParam);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}

		} // END for each seqNoList
	}
}
