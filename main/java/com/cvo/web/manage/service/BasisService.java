package com.enpem.web.manage.service;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.enpem.web.common.biz.CdLocator;
import com.enpem.web.common.biz.CmnService;
import com.enpem.web.common.data.Box;
import com.enpem.web.common.exception.BizException;
import com.enpem.web.common.util.CdUtil;
import com.enpem.web.common.util.DateUtil;
import com.enpem.web.common.util.ExcelRederUtil;
import com.enpem.web.common.util.JsonUtil;

@Service
public class BasisService {

	protected Logger log = LoggerFactory.getLogger(this.getClass());

	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSessionTemplate dao;

	@Autowired
	@Qualifier("sqlBatchSessionTemplate")
	private SqlSessionTemplate batchDao;

	@Autowired
	private CdLocator cdLocator;

	@Autowired
	private CmnService cmnService;

	/**
	 * 센터차량 저장
	 *
	 * @param paramMap
	 * @param modelMap
	 * @throws Exception
	 */
	public void carSave(Box box, ModelMap model) throws Exception {

		int result = 0;
		if ("C".equals(box.nvl("OP_FLAG"))) {
//			result += dao.insert("basis.carInsert", box);
		} else if ("U".equals(box.nvl("OP_FLAG"))) {
			result += dao.update("basis.carUpdate", box);
		} else if ("D".equals(box.nvl("OP_FLAG"))) {
//			result += dao.delete("basis.carDelete", box);
		}
		model.put("result", result);
	}

	/**
	 * 센터창고단말 저장
	 *
	 * @param paramMap
	 * @param modelMap
	 * @throws Exception
	 */
	public void cargoDevSave(Box box, ModelMap model) throws Exception {

		int result = 0;
		if ("C".equals(box.nvl("OP_FLAG"))) {
//			result += dao.insert("basis.cargoDevInsert", box);
		} else if ("U".equals(box.nvl("OP_FLAG"))) {
			result += dao.update("basis.cargoDevUpdate", box);
		} else if ("D".equals(box.nvl("OP_FLAG"))) {
//			result += dao.delete("basis.cargoDevDelete", box);
		}

		model.put("result", result);
	}

	/**
	 * 대리점차량 저장
	 *
	 * @param paramMap
	 * @param modelMap
	 * @throws Exception
	 */
	public void agentCarSave(Box box, ModelMap model) throws Exception {

		int result = 0;
		if ("C".equals(box.nvl("OP_FLAG"))) {
			if ((Integer)dao.selectOne("basis.carNoCnt", box) == 0) {
				result += dao.insert("basis.agentCarInsert", box);
			} else {
				throw new BizException("E112", new String[]{"차량번호가"}); //{0} 이미 존재합니다.
			}


		} else if ("U".equals(box.nvl("OP_FLAG"))) {
			result += dao.update("basis.agentCarUpdate", box);
		} else if ("D".equals(box.nvl("OP_FLAG"))) {
			result += dao.delete("basis.agentCarDelete", box);
		}
		model.put("result", result);
	}

	/**
	 * 대리점창고단말 저장
	 *
	 * @param paramMap
	 * @param modelMap
	 * @throws Exception
	 */
	public void agentCargoSave(Box box, ModelMap model) throws Exception {

		int result = 0;
		if ("C".equals(box.nvl("OP_FLAG"))) {
//			result += dao.insert("basis.agentCargoInsert", box);
		} else if ("U".equals(box.nvl("OP_FLAG"))) {
			result += dao.update("basis.cargoDevUpdate", box);
		} else if ("D".equals(box.nvl("OP_FLAG"))) {
//			result += dao.delete("basis.agentCargoDelete", box);
		}

		model.put("result", result);
	}

	/**
	 * 대리점 저장
	 *
	 * @param paramMap
	 * @param modelMap
	 * @throws Exception
	 */
	public void agentSave(Box box, ModelMap model) throws Exception {

		int result = 0;
		if ("C".equals(box.nvl("OP_FLAG"))) {
			result += dao.insert("basis.agentInsert", box);
		} else if ("U".equals(box.nvl("OP_FLAG"))) {
			result += dao.update("basis.agentUpdate", box);
			if (box.nvl("useChangeYn").equals("Y")) { //사용여부 변경시 사용자 사용여부 수정
				dao.update("basis.userUseYnUpdate", box);
			}
		} else if ("D".equals(box.nvl("OP_FLAG"))) {
			result += dao.delete("basis.agentDelete", box);
		}
		model.put("result", result);
	}

	/**
	 * 대리점출도착 일괄저장
	 *
	 * @param paramMap
	 * @param modelMap
	 * @throws Exception
	 */
	public void agentIoSave(Box box, MultipartHttpServletRequest mReq, ModelMap model) throws Exception {

		String fileKeyNm = box.nvl("fileKeyNm", "file");
		box.put("excelFile", mReq.getFile(fileKeyNm));
		this.agentExcelProc(box, model); //차량휴무 엑셀 처리
	}

	/**
	 * 대리점출도착 엑셀 처리
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	public void agentExcelProc(Box box, ModelMap model) throws Exception {
		MultipartFile mFile = (MultipartFile) box.get("excelFile");
		String[][] data = null;
		int result = 0;

		if (!mFile.isEmpty()) {
			InputStream is = (InputStream) mFile.getInputStream();
			data = ExcelRederUtil.simpleExcelReadPoi(is, 0, 0, -1);

			//valid 체크후 row를 insert한다
			for (int idx=0; idx < data.length; idx++) {
				String agentCd = "";
				String normalFrom = "";
				String normalTo = "";
				String weekendFrom = "";
				String weekendTo = "";
				Box rowBox = new Box();
				if (idx >= 8) {
					agentCd = data[idx][1];
					normalFrom = data[idx][5];
					normalTo = data[idx][6];
					weekendFrom = data[idx][7];
					weekendTo = data[idx][8];
//					log.debug(agentCd);
					if (null == agentCd || agentCd.isEmpty() || !(agentCd.length() == 5 || agentCd.length() == 10)) {
						throw new BizException("E111", new String[]{"[" + (idx + 1) + "행 - 잘못된 대리점코드입니다.]"}); //잘못된 엑셀 파일입니다. {0}
					}
					if (null == normalFrom || normalFrom.isEmpty() || normalFrom.length() != 4 || !DateUtil.isValid(normalFrom, "HHmm")) {
						throw new BizException("E111", new String[]{"[" + (idx + 1) + "행 - 잘못된 평일출발시각입니다.]"}); //잘못된 엑셀 파일입니다. {0}
					}
					if (null == normalTo || normalTo.isEmpty() || normalTo.length() != 4 || !DateUtil.isValid(normalTo, "HHmm")) {
						throw new BizException("E111", new String[]{"[" + (idx + 1) + "행 - 잘못된 평일도착시각입니다.]"}); //잘못된 엑셀 파일입니다. {0}
					}
					if (null == weekendFrom || weekendFrom.isEmpty() || weekendFrom.length() != 4 || !DateUtil.isValid(weekendFrom, "HHmm")) {
						throw new BizException("E111", new String[]{"[" + (idx + 1) + "행 - 잘못된 주말출발시각입니다.]"}); //잘못된 엑셀 파일입니다. {0}
					}
					if (null == weekendTo || weekendTo.isEmpty() || weekendTo.length() != 4 || !DateUtil.isValid(weekendTo, "HHmm")) {
						throw new BizException("E111", new String[]{"[" + (idx + 1) + "행 - 잘못된 주말도착시각입니다.]"}); //잘못된 엑셀 파일입니다. {0}
					}
					if (Integer.parseInt(normalFrom) > Integer.parseInt(normalTo)) {
						throw new BizException("E111", new String[]{"[" + (idx + 1) + "행 - 평일도착시각이 평일출발시각을 앞설수 없습니다.]"}); //잘못된 엑셀 파일입니다. {0}
					}
					if (Integer.parseInt(weekendFrom) > Integer.parseInt(weekendTo)) {
						throw new BizException("E111", new String[]{"[" + (idx + 1) + "행 - 주말도착시각이 주말출발시각을 앞설수 없습니다.]"}); //잘못된 엑셀 파일입니다. {0}
					}

					rowBox = new Box();
					rowBox.put("userId", box.getPath("sBox/userId"));
					rowBox.put("agentCd", agentCd);
					rowBox.put("normalFrom", normalFrom);
					rowBox.put("normalTo", normalTo);
					rowBox.put("weekendFrom", weekendFrom);
					rowBox.put("weekendTo", weekendTo);
					batchDao.update("basis.agentIoUpdate", rowBox); //row 단위로 데이터 update
					result++;
				}
			}
		}

//		box.put("restList", restList);
//		result = batchDao.insert("basis.restBatchInsert", box); //일괄 insert
		if (result > 0) {
			batchDao.insert("basis.agentLogInsert", box); //log 추가
		}
		model.put("result", result);
	}

	/**
	 * 사용자 저장
	 *
	 * @param paramMap
	 * @param modelMap
	 * @throws Exception
	 */
	public void userSave(Box box, ModelMap model) throws Exception {

		int result = 0;
		if ("C".equals(box.nvl("OP_FLAG"))) {
			result += dao.insert("basis.userInsert", box);
		} else if ("U".equals(box.nvl("OP_FLAG"))) {
			result += dao.update("basis.userUpdate", box);
		} else if ("D".equals(box.nvl("OP_FLAG"))) {
			result += dao.delete("basis.userDelete", box);
		}
		model.put("result", result);
	}

	/**
	 * 사용자 패스워드 초기화
	 *
	 * @param paramMap
	 * @param modelMap
	 * @throws Exception
	 */
	public void userPwdResetUpdate(Box box, ModelMap model) throws Exception {

		int result = dao.update("basis.userPwdResetUpdate", box);
		model.put("result", result);
	}

	/**
	 * 사용자 패스워드 변경
	 *
	 * @param paramMap
	 * @param modelMap
	 * @throws Exception
	 */
	public void userPwdUpdate(Box box, ModelMap model) throws Exception {

		int result = dao.update("basis.userPwdUpdate", box);
		model.put("result", result);
	}

	/**
	 * 권한 저장
	 *
	 * @param paramMap
	 * @param modelMap
	 * @throws Exception
	 */
	public void authSave(Box box, ModelMap model) throws Exception {

		int result = 0;
		if ("C".equals(box.nvl("OP_FLAG"))) {
			result += dao.insert("basis.authInsert", box);
		} else if ("U".equals(box.nvl("OP_FLAG"))) {
			result += dao.update("basis.authUpdate", box);
		} else if ("D".equals(box.nvl("OP_FLAG"))) {
			result += dao.delete("basis.authDelete", box);
		}
		cdLocator.initialize();

		model.put("result", result);

	}

	/**
	 * 메뉴별권한 일괄저장
	 *
	 * @param paramMap
	 * @param modelMap
	 * @throws Exception
	 */
	public void menuAuthSave(Box box, ModelMap model) throws Exception {

		int result = 0;
//		box.put("gridList", JsonUtil.toObject(box.nvl("gridData").substring(1, box.nvl("gridData").length() - 1), Box.class));
//		List<Map>  = JsonUtil.toObject(box.nvl("gridData"), ArrayList.class);
//		log.debug(">>" + bodyList.size());
//		for (Map rowBox : bodyList) {
//			log.debug(">>>" + rowBox.get("selectYn"));
//		}

		box.put("gridList", JsonUtil.toObject(box.nvl("gridData"), ArrayList.class));
		dao.delete("basis.menuAuthDelete", box); //기존 데이터 삭제
		result += dao.insert("basis.menuAuthInsert", box);
		model.put("result", result);
	}

	/**
	 * 차량휴무 일괄저장
	 *
	 * @param paramMap
	 * @param modelMap
	 * @throws Exception
	 */
	public void restSave(Box box, MultipartHttpServletRequest mReq, ModelMap model) throws Exception {

		String fileKeyNm = box.nvl("fileKeyNm", "file");
		box.put("excelFile", mReq.getFile(fileKeyNm));
		this.restExcelProc(box, model); //차량휴무 엑셀 처리
	}

	/**
	 * 차량휴무 엑셀 처리
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	public void restExcelProc(Box box, ModelMap model) throws Exception {
//		log.debug(">>>" + dao.getExecutorType());
//		log.debug(">>>" + batchDao.getExecutorType());

		MultipartFile mFile = (MultipartFile) box.get("excelFile");
		String[][] data = null;
		int result = 0;
		List<Box> restCdlist = CdUtil.getCdList("REST_CD");
		List<Box> restBeforeList = new ArrayList<Box>();
//		List<Box> restList = new ArrayList<Box>();
		String restCdStr = "";
		for (Box rowBox : restCdlist) {
			restCdStr += rowBox.nvl("cd") + ",";
		}
		restCdStr = restCdStr.substring(0, restCdStr.length() - 1);
		if (!mFile.isEmpty()) {
			InputStream is = (InputStream) mFile.getInputStream();
			data = ExcelRederUtil.simpleExcelReadPoi(is, 0, 0, -1);
			if (null == data[8][5] || data[8][5].isEmpty() || data[8][5].length() != 6) {
				throw new BizException("E111", new String[]{"[기준년월 오류]"}); //잘못된 엑셀 파일입니다. {0}
			}
			box.put("stdYm", data[8][5]);
			box.put("srchStdYm", data[8][5]);
			String todayYm = DateUtil.nowYYYYMM();

//			log.debug(">>" + box.getInt("stdYm"));
//			log.debug(">>" + Integer.parseInt(todayYm));
//			log.debug(">>" + (box.getInt("stdYm") < Integer.parseInt(todayYm)));
			if (box.getInt("stdYm") < Integer.parseInt(todayYm)) {
				throw new BizException("E111", new String[]{"[이전월 변경불가 : " + box.getInt("stdYm") + "]"}); //잘못된 엑셀 파일입니다. {0}
			}
			int checkDay = 0;
			//엑셀 데이터가 당월일 경우 : 당월 3일 이전은 당월 1일로 고정하기 위한 변수, 기존 데이터를 변경할 수 없는 날짜경계
			if (box.getInt("stdYm") == Integer.parseInt(todayYm)) {
				checkDay = Integer.parseInt(DateUtil.now("dd")) <= 3 ? 1 : Integer.parseInt(DateUtil.format(DateUtil.addDate(-3), "dd"));
				restBeforeList = batchDao.selectList("basis.restList", box); //기존 데이터 적재
			}
//			log.debug(">>" + checkDay);
			batchDao.delete("basis.restDelete", box); //기존 데이터 삭제

			//valid 체크후 row를 insert한다
			for (int idx=0; idx < data.length; idx++) {
				String carId = "";
				Box rowBox = new Box();
				if (idx >= 8) {
					carId = data[idx][1];
//					log.debug(carId);
					if (null == carId || carId.isEmpty() || carId.length() > 5) {
						throw new BizException("E111", new String[]{"[" + (idx + 1) + "행 - 잘못된 차량ID입니다.]"}); //잘못된 엑셀 파일입니다. {0}
					}
					if (!box.nvl("stdYm").equals(data[idx][5])) {
						throw new BizException("E111", new String[]{"[" + (idx + 1) + "행 - 잘못된 기준월입니다.]"}); //잘못된 엑셀 파일입니다. {0}
					}

					rowBox = new Box();
					rowBox.put("userId", box.getPath("sBox/userId"));
					rowBox.put("carId", carId);
					rowBox.put("stdYm", box.nvl("stdYm"));
					int restCnt = 0;
					for (int jdx = 1; jdx <= 31; jdx++) {
						if (restCdStr.indexOf(data[idx][jdx + 5]) <= -1) {
							throw new BizException("E111", new String[]{"[" + (idx + 1) + "행, DAY" + jdx + " - 잘못된 휴무코드입니다.]"}); //잘못된 엑셀 파일입니다. {0}
						}

						//checkDay 값이 없거나(다른달) jdx가 checkDay보다 크거나 같을 경우 엑셀 내용대로 처리, jdx가 checkDay보다 작을 경우 기존 데이터로 세팅
						if (checkDay == 0 || jdx >= checkDay) {
							rowBox.put("day" + jdx, data[idx][jdx + 5]);
						} else {
							for (Box iBox : restBeforeList) {
								if (iBox.nvl("carId").equals(carId)) {
									rowBox.put("day" + jdx, iBox.nvl("day" + jdx));
									break;
								}
							}
						}
						if (!rowBox.nvl("day" + jdx).equals("N") && !rowBox.nvl("day" + jdx).equals("n")) { //정상운행이 아닌경우 휴무 카운트
							restCnt++;
						}
					}

					rowBox.put("restCnt", restCnt);
//					restList.add(rowBox);
					batchDao.insert("basis.restInsert", rowBox); //row 단위로 데이터 insert
					result++;
				}
			}
		}

//		box.put("restList", restList);
//		result = batchDao.insert("basis.restBatchInsert", box); //일괄 insert
		if (result > 0) {
			batchDao.insert("basis.restLogInsert", box); //log 추가
		}
		model.put("stdYm", box.nvl("stdYm"));
		model.put("result", result);
	}
}
