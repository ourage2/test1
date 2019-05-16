package com.enpem.web.manage.service;

import java.util.ArrayList;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import com.enpem.web.common.biz.CmnService;
import com.enpem.web.common.data.Box;
import com.enpem.web.common.exception.BizException;

@Service
public class SetService {

	protected Logger log = LoggerFactory.getLogger(this.getClass());

	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSessionTemplate dao;

	@Autowired
	@Qualifier("sqlBatchSessionTemplate")
	private SqlSessionTemplate batchDao;

	@Autowired
	private CmnService cmnService;

	/**
	 * 그룹코드 저장
	 *
	 * @param paramMap
	 * @param modelMap
	 * @throws Exception
	 */
	public void grpCdSave(Box box, ModelMap model) throws Exception {

		int result = 0;
		if ("C".equals(box.nvl("OP_FLAG"))) {
			result += dao.insert("set.grpCdInsert", box);
		} else if ("U".equals(box.nvl("OP_FLAG"))) {
			result += dao.update("set.grpCdUpdate", box);
		} else if ("D".equals(box.nvl("OP_FLAG"))) {
			if ((Integer)dao.selectOne("set.cdCnt", box) == 0) {
				result += dao.delete("set.grpCdDelete", box);
			} else {
				throw new BizException("E106"); //해당 그룹코드에 상세코드가 존재합니다.
			}

		}
		model.put("result", result);
	}

	/**
	 * 코드 저장
	 *
	 * @param paramMap
	 * @param modelMap
	 * @throws Exception
	 */
	public void cdSave(Box box, ModelMap model) throws Exception {

		int result = 0;
//		List<Box> list = box.getList("list");
//		if (null == list || list.size() == 0) { //단건일 경우 list가 넘어오지 않으므로 기존 box를 list에 세팅하여 코드룰 재활용 한다.
//			list = new ArrayList<Box>();
//			list.add(box);
//		}
//		log.debug("list:" + list);
//
//		if ( 1 == 1) return;
//		for (Box rowBox : list) {
//			if ("C".equals(rowBox.nvl("OP_FLAG"))) {
//				rowBox.put("dupleChk", "Y");
//				if ((Integer)dao.selectOne("set.grpCdCnt", rowBox) >= 1) {
//					result += dao.insert("set.cdInsert", rowBox);
//				} else {
//					throw new BizException("E107", new String[]{"그룹코드가"}); //그룹코드가 존재하지 않습니다
//				}
//			} else if ("U".equals(rowBox.nvl("OP_FLAG"))) {
//				result += dao.update("set.cdUpdate", rowBox);
//			} else if ("D".equals(rowBox.nvl("OP_FLAG"))) {
//				result += dao.delete("set.cdDelete", rowBox);
//			}
//		}

		if ("C".equals(box.nvl("OP_FLAG"))) {
			box.put("dupleChk", "Y");
			if ((Integer)dao.selectOne("set.grpCdCnt", box) >= 1) {
				result += dao.insert("set.cdInsert", box);
			} else {
				throw new BizException("E107", new String[]{"그룹코드가"}); //그룹코드가 존재하지 않습니다
			}
		} else if ("U".equals(box.nvl("OP_FLAG"))) {
			result += dao.update("set.cdUpdate", box);
		} else if ("D".equals(box.nvl("OP_FLAG"))) {
//			box.put("cdArry", box.getArry("cdArry"));
			result += dao.delete("set.cdDelete", box);
		}

		model.put("result", result);
	}

	/**
	 * 메시지 저장
	 *
	 * @param paramMap
	 * @param modelMap
	 * @throws Exception
	 */
	public void msgSave(Box box, ModelMap model) throws Exception {

		//싱글 쿼테이션 문자를 치환한다.(web로딩시 parsing 오류 문제)
		if (box.nvl("msgNm").indexOf("'") > -1) {
			box.put("msgNm", box.nvl("msgNm").replaceAll("'", "`"));
		}
		if (box.nvl("msgDesc").indexOf("'") > -1) {
			box.put("msgDesc", box.nvl("msgDesc").replaceAll("'", "`"));
		}

		int result = 0;
		if ("C".equals(box.nvl("OP_FLAG"))) {
			result += dao.insert("set.msgInsert", box);
		} else if ("U".equals(box.nvl("OP_FLAG"))) {
			result += dao.update("set.msgUpdate", box);
		} else if ("D".equals(box.nvl("OP_FLAG"))) {
			result += dao.delete("set.msgDelete", box);
		}
		model.put("result", result);
	}

	/**
	 * 공지사항 저장
	 *
	 * @param paramMap
	 * @param modelMap
	 * @throws Exception
	 */
	public void noticeSave(Box box, ModelMap model) throws Exception {
		//첨부파일처리
		box.put("fileDiv", "NOTICE");
		box.put("fileKey", box.nvl("seq"));
		cmnService.fileProc(box, model); //파일을 처리한다.
		cmnService.thumb(box, model); //썸네일을 생성한다.

		int result = 0;
		if ("C".equals(box.nvl("OP_FLAG"))) {
			result += dao.insert("set.noticeInsert", box);
		} else if ("U".equals(box.nvl("OP_FLAG"))) {
			result += dao.update("set.noticeUpdate", box);
		} else if ("D".equals(box.nvl("OP_FLAG"))) {
			result += dao.delete("set.noticeDelete", box);
		}
		model.put("result", result);
	}


	/**
	 * 1대1문의질문 저장
	 *
	 * @param paramMap
	 * @param modelMap
	 * @throws Exception
	 */
	public void qnaSave(Box box, ModelMap model) throws Exception {
		//첨부파일처리
		box.put("fileDiv", "QNA");
		box.put("fileKey", box.nvl("seq"));
		cmnService.fileProc(box, model); //파일을 처리한다.
		cmnService.thumb(box, model); //썸네일을 생성한다.

		int result = 0;
		if ("C".equals(box.nvl("OP_FLAG"))) {
			result += dao.insert("set.qnaInsert", box);
		} else if ("U".equals(box.nvl("OP_FLAG"))) {
			result += dao.update("set.qnaUpdate", box);
		} else if ("D".equals(box.nvl("OP_FLAG"))) {
			result += dao.delete("set.qnaDelete", box);
		}
		model.put("result", result);
	}

	/**
	 * 1대1문의답변 저장
	 *
	 * @param paramMap
	 * @param modelMap
	 * @throws Exception
	 */
	public void qnaAnsSave(Box box, ModelMap model) throws Exception {
		//첨부파일처리
		box.put("fileDiv", "QNA");
		box.put("fileKey", box.nvl("seq"));
//		cmnService.fileProc(box, model); //파일을 처리한다.
		cmnService.thumb(box, model); //썸네일을 생성한다.

		int result = 0;
		if ("C".equals(box.nvl("OP_FLAG"))) {
			result += dao.update("set.qnaAnsUpdate", box);
		} else if ("U".equals(box.nvl("OP_FLAG"))) {
			result += dao.update("set.qnaAnsUpdate", box);
		} else if ("D".equals(box.nvl("OP_FLAG"))) {
			result += dao.update("set.qnaAnsDelete", box);
		}
		model.put("result", result);
	}

	/**
	 * 알림발송
	 *
	 * @param paramMap
	 * @param modelMap
	 * @throws Exception
	 */
	public void alarmSend(Box box, ModelMap model) throws Exception {

		int result = 0;
		box.put("sendNo", dao.selectOne("set.sendNoView", box));
		for (String recvId : box.nvl("pushIds").split(",")) {
			box.put("recvId", recvId);
			batchDao.insert("set.alarmInsert", box); //row 단위로 데이터 update
			result++;
		}
		model.put("result", result);
	}

}
