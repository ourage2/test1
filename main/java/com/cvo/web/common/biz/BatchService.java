package com.enpem.web.common.biz;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.util.ArrayList;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.enpem.web.common.constants.CmnConst;
import com.enpem.web.common.data.Box;
import com.enpem.web.common.util.CenterUtil;
import com.enpem.web.common.util.ConfigUtil;
import com.enpem.web.common.util.DateUtil;
import com.enpem.web.common.util.StringUtil;
import com.enpem.web.common.util.file.FileUtil;

@Service
public class BatchService {
	protected Logger log = LoggerFactory.getLogger(this.getClass());

	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSessionTemplate dao;

	@Autowired
	private CmnService cmnService;

	public void fileDel(Box box, Box model) throws Exception {
		List<Box> list = dao.selectList("batch.fileDelTargetList", box);
		if (null == list || list.size() == 0) {
			log.debug("파일삭제 대상이 존재하지 않습니다");
			return;
		}

		for (Box rowBox : list) {
			cmnService.fileRealDelete(rowBox);
		}

		//첨부파일정리 대상 db에서도 삭제
		int result = dao.delete("batch.fileDelDelete", box);
		log.debug("삭제된 수 : " + result);
		model.put("result", result);
	}

	/**
	 * raw 데이터 삭제
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	public void rawDel(Box box, Box model) throws Exception {
		box.put("delDay", ConfigUtil.getInt("scheduled.raw.delete.term.day"));
		int resultCar = dao.delete("batch.carRawDelete", box);
		int resultCargo = dao.delete("batch.cargoRawDelete", box);
		log.debug("삭제된 차량 RAW 데이터수 : " + resultCar + ", 삭제된 창고 RAW 데이터수 : " + resultCargo);
		model.put("resultCar", resultCar);
		model.put("resultCargo", resultCargo);
	}

	/**
	 * 미등록 차량/대리점 데이터 삭제
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	public void noregDel(Box box, Box model) throws Exception {
		box.put("delDay", ConfigUtil.getInt("scheduled.raw.delete.term.day"));
		int resultCar = dao.delete("batch.noregCarDelete", box);
		int resultAgent = dao.delete("batch.noregAgentDelete", box);
		log.debug("삭제된 미등록 차량 데이터수 : " + resultCar + ", 삭제된 미등록 대리점 데이터수 : " + resultAgent);
		model.put("resultCar", resultCar);
		model.put("resultAgent", resultAgent);
	}



	/**
	 * 창고통계 등록
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	public void cargoStatInsert(Box box, Box model) throws Exception {

		int delCnt = dao.delete("batch.cargoStatDelete", box);

		box.put("div", "C"); //센터
		dao.insert("batch.cargoStatInsert", box);

		box.put("div", "A"); //대리점
		dao.insert("batch.cargoStatInsert", box);

		model.put("delCnt", delCnt);
	}

	/**
	 * 차량통계 삭제
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	public void carStatDel(Box box, Box model) throws Exception {
		int delCnt = dao.delete("batch.carStatDelete", box);
		model.put("delCnt", delCnt);
	}

	public void carBaseStatInsert(Box box, Box model) throws Exception {
		dao.insert("batch.carBaseStatInsert", box);
	}

	/**
	 * 차량온도통계 등록
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	public void carTempStatInsert(Box box, Box model) throws Exception {
		dao.insert("batch.carTempStatInsert", box);
	}

	/**
	 * 차량도착통계 등록
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	public void carArrStatInsert(Box box, Box model) throws Exception {
		dao.insert("batch.carArrStatInsert", box);
	}

	/**
	 * 차량납품실적통계 등록
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	public void carDeliStatInsert(Box box, Box model) throws Exception {
		dao.insert("batch.carDeliStatInsert", box);
	}

	/**
	 * 차량주행통계 등록
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	public void carDrvStatInsert(Box box, Box model) throws Exception {
		dao.insert("batch.carDrvStatInsert", box);
	}

	/**
	 * 차량운행통계 등록
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	public void carTotDrvStatInsert(Box box, Box model) throws Exception {
		dao.insert("batch.carTotDrvStatInsert", box);
	}

	/**
	 * 대리점차량주행통계 등록
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	public void agentCarDrvStatInsert(Box box, Box model) throws Exception {
		dao.insert("batch.agentCarDrvStatInsert", box);
	}

	/**
	 * 포장재출고회수통계 등록
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	public void pkgAnalInsert(Box box, Box model) throws Exception {
		int delCnt = dao.delete("batch.pkgAnalDelete", box);
		dao.insert("batch.pkgAnalInsert");

		model.put("delCnt", delCnt);
	}

	/**
	 * 배송완료 처리
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	public void deliyUpdate(Box box, Box model) throws Exception {
		dao.update("batch.deliyUpdate", box);
	}

	/**
	 * 차량운행 - 대용량 엑셀 파일 생성
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	public void carCsvMake(Box box, Box model) throws Exception {
		int weekCnt = Integer.parseInt(DateUtil.now("e")) == 0 ? -13 : (Integer.parseInt(DateUtil.now("e")) * -1) - 6;
		box.put("strDate", DateUtil.format(DateUtil.addDate(weekCnt), "yyyyMMdd"));
		box.put("endDate", DateUtil.format(DateUtil.addDate(weekCnt + 6), "yyyyMMdd"));
		log.debug(box.nvl("strDate"));
		log.debug(box.nvl("endDate"));

		String[] centerCds = new String[]{"1200", "1300", "1400", "1500", "2100", "2300", "2700", "3600", "9999"};
		int filePerCnt = 100000;
		int totPage = 0;
		String outFilePath = ConfigUtil.getString("excel.path") + DateUtil.now("yyyy/"); //파일을 생성할 디렉토리
		box.put("div", "CAR");
		dao.delete("batch.csvFileDelete", box);

		for (String centerCd: centerCds) {

			String fileNmFmt = "[차량운행현황_" + CenterUtil.getNm(centerCd) + "]" + box.nvl("strDate") + "_" + box.nvl("endDate");
			List<String> fileList = new ArrayList<String>();
			box.put("centerCd", centerCd);
			int cnt = dao.selectOne("batch.carDrvRawCnt", box);
			box.put("cnt", cnt);
			totPage = (cnt - 1) / filePerCnt + 1;
			log.debug("totPage:"+totPage);

			for (int nowPage = 1; nowPage <= totPage; nowPage++) {

				box.put("strNum", (nowPage - 1) * filePerCnt + 1);
				box.put("endNum", nowPage * filePerCnt);
				log.debug("strNum:"+box.nvl("strNum"));
				log.debug("endNum:"+box.nvl("endNum"));
				List<Box> carList = dao.selectList("batch.carDrvRawList", box);
				if (null == carList || carList.size() == 0) {
					log.debug(centerCd + "의 차량별 운행 현황이 존재하지 않습니다");
				} else {
					String[] colNameArry = new String[]{
							"rnum", "seq", "centerNm", "carNo", "carId", "drvNm", "devDate", "devTm", "jibunAddr", "spd", "dayTotDis"
							, "ch1", "ch2", "shipNo", "deliNo", "agentCd", "agentNm", "delayTxt", "arrVioNm", "vioTxt", "vioLongTxt", "tempVioNm", "event"};

					String outFileNm = fileNmFmt + "_" + String.valueOf(nowPage) + ".csv"; //생성할 파일명
					String fileFullPath = outFilePath + outFileNm; //생성할 파일명을 전체경로에 결합
					FileUtil.makeDirectory(outFilePath);
					File file = new File(fileFullPath);
					Writer outFile = null;
					log.debug("쿼리 완료:" + carList.size() + "건");

					//파일 생성
					try {
						file.createNewFile();
						outFile = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(fileFullPath), CmnConst.EUCKR));
						StringBuffer csvSb = new StringBuffer();
						for (Box rowBox : carList) {
							for (int idx = 0; idx < colNameArry.length; idx++) {
								csvSb.append("\"" + StringUtil.replaceAll(rowBox.nvl(colNameArry[idx]), "\"", "\"\"") + "\"");
									if ((idx + 1) == colNameArry.length) {
									csvSb.append("\n");
								} else {
									csvSb.append(",");
								}
							}
						}
						outFile.write(csvSb.toString());
						outFile.flush();
						outFile.close();
					} catch (IOException e) {
						e.printStackTrace();
					} finally {
						log.debug("파일생성 종료:" + outFileNm);
						if (null != file) { file = null; }
						if (null != outFile) { outFile = null; }
						fileList.add(outFilePath + outFileNm);
					}
				}
			}

			if (fileList.size() != 0) {
				String fileNm = fileNmFmt + ".csv";
				box.put("fileNm", fileNm);
				box.put("saveFileNm", fileNm);
				box.put("saveFilePath", outFilePath);
				FileUtil.merge(box, outFilePath + fileNm, fileList, true);
				dao.insert("batch.csvFileInsert", box);
			}
		}
	}


	/**
	 * 창고온도 - 대용량 엑셀 파일 생성
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	public void cargoCsvMake(Box box, Box model) throws Exception {
		String strDate = DateUtil.format(DateUtil.addMonth(-1), "yyyyMM") + "01";
		String endDate = DateUtil.format(DateUtil.getLastDayOfMonth(DateUtil.parse(strDate, "yyyyMMdd")), "yyyyMMdd");
		box.put("strDate", strDate);
		box.put("endDate", endDate);
		log.debug(box.nvl("strDate"));
		log.debug(box.nvl("endDate"));

		int filePerCnt = 100000;
		int totPage = 0;
		String outFilePath = ConfigUtil.getString("excel.path") + DateUtil.now("yyyy/"); //파일을 생성할 디렉토리
		box.put("div", "CARGO");
		dao.delete("batch.csvFileDelete", box);

		String fileNmFmt = "[창고온도현황]" + box.nvl("strDate") + "_" + box.nvl("endDate");
		List<String> fileList = new ArrayList<String>();
		int cnt = dao.selectOne("batch.cargoRawCnt", box);
		box.put("cnt", cnt);
		totPage = (cnt - 1) / filePerCnt + 1;
		log.debug("totPage:"+totPage);

		for (int nowPage = 1; nowPage <= totPage; nowPage++) {

			box.put("strNum", (nowPage - 1) * filePerCnt + 1);
			box.put("endNum", nowPage * filePerCnt);
			log.debug("strNum:"+box.nvl("strNum"));
			log.debug("endNum:"+box.nvl("endNum"));
			List<Box> cargoList = dao.selectList("batch.cargoRawList", box);
			if (null == cargoList || cargoList.size() == 0) {
				log.debug("창고 온도 현황이 존재하지 않습니다");
			} else {
				String[] colNameArry = new String[]{"rnum", "seq", "centerNm", "devNm", "devDate", "devTm", "ch1", "ch2", "ch3", "tempStat", "tempVioNm"};
				String outFileNm = fileNmFmt + "_" + String.valueOf(nowPage) + ".csv"; //생성할 파일명
				String fileFullPath = outFilePath + outFileNm; //생성할 파일명을 전체경로에 결합
				FileUtil.makeDirectory(outFilePath);
				File file = new File(fileFullPath);
				Writer outFile = null;
				log.debug("쿼리 완료:" + cargoList.size() + "건");

				//파일 생성
				try {
					file.createNewFile();
					outFile = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(fileFullPath), CmnConst.EUCKR));
					StringBuffer csvSb = new StringBuffer();
					for (Box rowBox : cargoList) {
						for (int idx = 0; idx < colNameArry.length; idx++) {
							csvSb.append("\"" + StringUtil.replaceAll(rowBox.nvl(colNameArry[idx]), "\"", "\"\"") + "\"");
								if ((idx + 1) == colNameArry.length) {
								csvSb.append("\n");
							} else {
								csvSb.append(",");
							}
						}
					}
					outFile.write(csvSb.toString());
					outFile.flush();
					outFile.close();
				} catch (IOException e) {
					e.printStackTrace();
				} finally {
					log.debug("파일생성 종료:" + outFileNm);
					if (null != file) { file = null; }
					if (null != outFile) { outFile = null; }
					fileList.add(outFilePath + outFileNm);
				}
			}
		}

		if (fileList.size() != 0) {
			String fileNm = fileNmFmt + ".csv";
			box.put("fileNm", fileNm);
			box.put("saveFileNm", fileNm);
			box.put("saveFilePath", outFilePath);
			FileUtil.merge(box, outFilePath + fileNm, fileList, true);
			dao.insert("batch.csvFileInsert", box);
		}
	}
}
