package com.enpem.web.manage.controller;

import com.enpem.web.common.biz.BatchService;
import com.enpem.web.common.biz.BizUtil;
import com.enpem.web.common.data.Box;
import com.enpem.web.common.util.DateUtil;
import com.enpem.web.common.util.HttpUtil;
import com.enpem.web.common.util.SpringUtil;
import com.enpem.web.common.util.paginate.Paginate;
import com.enpem.web.manage.service.CenterService;

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
@RequestMapping("manage/center")
public class CenterController {

	protected Logger log = LoggerFactory.getLogger(this.getClass());

	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSessionTemplate dao;

	@Autowired
	private Paginate paginate;

	@Autowired
	private BatchService batchService;

	@Autowired
	private CenterService centerService;

	/**
	 * 대리점배송 모니터링 조회
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("agentDeliList")
	public void agentDeliList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			box.put("srchCenterCdList", box.strToList("srchCenterCd"));
			model.put("list", dao.selectList("center.agentDeliList", box));
			model.put("dtlList", dao.selectList("center.agentDeliDtlList", box));
		}
	}

	/**
	 * 실시간온도 모니터링 - 차량운행정보 대수
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("tempNowOnOffCnt")
	public void tempNowOnOffCnt(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			box.put("authCenterCd", box.path("sBox/authCenterCd"));
			box.put("sessCenterCdList", box.strToList("authCenterCd"));
			box.remove("authCenterCd");
			model.put("list", dao.selectList("center.tempNowOnOffCnt", box));
		}
	}

	/**
	 * 실시간온도 모니터링 조회
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("tempNowList")
	public void tempNowList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			box.put("srchCenterCd", box.get("srchCenterCd"));
			box.put("authCenterCd", box.path("sBox/authCenterCd"));
			box.put("sessCenterCdList", box.strToList("authCenterCd"));
			box.remove("authCenterCd");
			model.put("list", dao.selectList("center.tempNowList", box));
		}
	}

	@RequestMapping("dayCarNowCenter")
	public void dayCarNowCenter(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			model.put("list", dao.selectList("center.dayCarNowCenter", box));
		}
	}

	/**
	 * 실시간온도 모니터링 조회 - 상세
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("tempNowDtl")
	public void tempNowDtl(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			box.put("carId", box.get("carId"));
			box.put("authCenterCd", box.path("sBox/authCenterCd"));
			box.put("sessCenterCdList", box.strToList("authCenterCd"));
			box.remove("authCenterCd");
			model.put("list", dao.selectList("center.tempNowDtlList", box));
			model.put("deliDtlList", dao.selectList("center.dayCarDeliDtlList", box));
		}
	}

	/**
	 * 실시간온도 모니터링 조회 - 로드뷰
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping(value = "roadViewPop")
	public void roadViewPop(Box box, ModelMap model) throws Exception {
		model.addAttribute("xpos", box.get("xpos"));
		model.addAttribute("ypos", box.get("ypos"));
	}

	/**
	 * 실시간온도 모니터링 조회 - 창고
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("tempNowCargoList")
	public void tempNowCargoList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			box.put("srchCenterCd", box.get("srchCenterCd"));
			box.put("authCenterCd", box.path("sBox/authCenterCd"));
			box.put("sessCenterCdList", box.strToList("authCenterCd"));
			box.remove("authCenterCd");
			model.put("list", dao.selectList("center.tempNowCargoList", box));
		}
	}


	/**
	 * 일자별차량 운행현황 조회
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("dayCarNow")
	public void dayCarNow(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			box.put("authCenterCd", box.path("sBox/authCenterCd"));
			box.put("sessCenterCdList", box.strToList("authCenterCd"));
			box.remove("authCenterCd");

			if (Integer.parseInt(box.get("srchShipReqDate").toString()) < Integer.parseInt(DateUtil.nowYYYYMMDD())) {
				box.put("srchDateFlag", "P");
			} else {
				box.put("srchDateFlag", "N");
			}

			model.put("list", dao.selectList("center.dayCarNowList", box));

			BizUtil.excelDown(box, model, SpringUtil.getLookupPathForRequest());
		}
	}

	/**
	 * 일자별차량 운행현황 조회 - 납품정보
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("dayCarNowDtlList")
	public void dayCarNowDtlList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			box.put("authCenterCd", box.path("sBox/authCenterCd"));
			box.put("sessCenterCdList", box.strToList("authCenterCd"));
			box.remove("authCenterCd");
			model.put("list", dao.selectList("center.dayCarNowDtlList", box));
		}
	}

	/**
	 * 일자별차량 운행현황 조회 - 운행정보
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("dayCarNowHistList")
	public void dayCarNowHistList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			model.put("list", dao.selectList("center.dayCarNowHistList", box));
			BizUtil.excelDown(box, model, SpringUtil.getLookupPathForRequest());
		}
	}

	/**
	 * 일자별차량 운행현황 조회 - 전체 운행정보
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("dayCarAllHistList")
	public void dayCarAllHistList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			model.put("list", dao.selectList("center.dayCarAllHistList", box));
		}
	}



	/**
	 * 일자별차량 운행내역
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("dayCarDrvAnal")
	public void dayCarDrvAnal(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			box.put("srchCenterCdList", box.strToList("srchCenterCd"));
			int totCnt = dao.selectOne("center.dayCarDrvAnalCnt", box);
			paginate.init(box, model, totCnt);
			model.put("list", dao.selectList("center.dayCarDrvAnalList", box));
			BizUtil.excelDown(box, model, SpringUtil.getLookupPathForRequest());
		}
	}

	/**
	 * 일자별 차량 운행 세부 내역
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("dayCarDrvAnalDtl")
	public void dayCarDrvAnalDtl(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			model.put("list", dao.selectList("center.dayCarDrvAnalDtlList", box));
			BizUtil.excelDown(box, model, SpringUtil.getLookupPathForRequest());
		}
	}

	/**
	 * 차량 대리점 도착 위반 / 온도 이상 사유 팝업
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("carVioInputView")
	public void carVioInputView(Box box, ModelMap model) throws Exception {
	}

	/**
	 * 차량 대리점 도착 위반 / 온도 이상 사유 저장
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("carVioInputSave")
	public void carVioInputSave(Box box, ModelMap model) throws Exception {
		if ("json".equalsIgnoreCase(HttpUtil.getExt())) {
			centerService.carVioInput(box, model);
		}
	}

	/**
	 * 일자별창고온도 내역
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("dayCargoTempAnal")
	public void dayCargoTempAnal(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			box.put("srchCenterCdList", box.strToList("srchCenterCd"));
			model.put("list", dao.selectList("center.dayCargoTempAnalList", box));
			BizUtil.excelDown(box, model, SpringUtil.getLookupPathForRequest());
		}
	}

	/**
	 * 일자별창고온도 세부내역
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("dayCargoTempAnalDtl")
	public void dayCargoTempAnalDtl(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			model.put("list", dao.selectList("center.dayCargoTempAnalDtlList", box));
			BizUtil.excelDown(box, model, SpringUtil.getLookupPathForRequest());
		}
	}

	/**
	 * 창고 온도 이상 사유 팝업
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("cargoVioInputView")
	public void cargoVioInputView(Box box, ModelMap model) throws Exception {
	}

	/**
	 * 창고 온도 이상 사유 저장
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("cargoVioInputSave")
	public void cargoVioInputSave(Box box, ModelMap model) throws Exception {
		if ("json".equalsIgnoreCase(HttpUtil.getExt())) {
			centerService.cargoVioInput(box, model);
		}
	}

	/**
	 * 일자별 창고 온도 내역 차트 팝업
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("dayCargoTempAnalChartView")
	public void dayCargoTempAnalChartView(Box box, ModelMap model) throws Exception {
	}


	/**
	 * 일자별 누적 현황
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("dayAnal")
	public void dayAnal(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			box.put("srchCenterCdList", box.strToList("srchCenterCd"));
			List<Box> list = dao.selectList("center.dayAnalList", box);
			model.put("list", list);
			Box dayAnalSum = dao.selectOne("center.dayAnalSum", box);

			if ("xls".equalsIgnoreCase(HttpUtil.getExt())) {
				list.add(dayAnalSum);
			} else {
				model.put("userData", dayAnalSum);
			}

			BizUtil.excelDown(box, model, SpringUtil.getLookupPathForRequest());
		}
	}

	/**
	 * 일자별채널별 정시도착률
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("dayChArrAnal")
	public void dayChArrAnal(Box box, ModelMap model) throws Exception {

		if (HttpUtil.isDataExtension()) {
			box.put("srchCenterCdList", box.strToList("srchCenterCd"));
			box.put("agentChList", dao.selectList("center.agentChList", box));
			model.put("list", dao.selectList("center.dayChArrAnalList", box));
		}
	}

	/**
	 * 일자별채널별 세부 정시도착률
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("dayChArrAnalDtl")
	public void dayChArrAnalDtl(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			model.put("list", dao.selectList("center.dayChArrAnalDtlList", box));
		}
	}

	/**
	 * 일자별 온도준수율
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("dayTempAnal")
	public void dayTempAnal(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			box.put("srchCenterCdList", box.strToList("srchCenterCd"));
			model.put("list", dao.selectList("center.dayTempAnalList", box));
			BizUtil.excelDown(box, model, SpringUtil.getLookupPathForRequest());
		}
	}

	/**
	 * 일자별 온도 세부(차량) 준수율
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("dayTempAnalDtl")
	public void dayTempAnalDtl(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			model.put("list", dao.selectList("center.dayTempAnalDtlList", box));
			BizUtil.excelDown(box, model, SpringUtil.getLookupPathForRequest());
		}
	}

	/**
	 * 온도 준수율 상세정보(차량)
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("dayCarTempAnalHist")
	public void dayCarTempAnalHist(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			model.put("list", dao.selectList("center.dayCarTempAnalHistList", box));
			BizUtil.excelDown(box, model, SpringUtil.getLookupPathForRequest());
		}
	}

	/**
	 * 일자별대리점 정시도착률
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("dayAgentArrAnal")
	public void dayAgentArrAnal(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			box.put("srchCenterCdList", box.strToList("srchCenterCd"));
			model.put("list", dao.selectList("center.dayAgentArrAnalList", box));
			BizUtil.excelDown(box, model, SpringUtil.getLookupPathForRequest());
		}
	}

	/**
	 * 차량별 대리점 도착률
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("dayAgentArrAnalDtlList")
	public void dayAgentArrAnalDtlList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			model.put("list", dao.selectList("center.dayAgentArrAnalDtlList", box));
			BizUtil.excelDown(box, model, SpringUtil.getLookupPathForRequest());
		}
	}

	/**
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("dayAgentArrAnalHist")
	public void dayAgentArrAnalHist(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			model.put("list", dao.selectList("center.dayAgentArrAnalHistList", box));
		}
	}

	/**
	 * 차량별 누적 현황
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("carDayAnal")
	public void carDayAnal(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			box.put("srchCenterCdList", box.strToList("srchCenterCd"));
			List<Box> list = dao.selectList("center.carDayAnalList", box);
			Box carDayAnalSum = dao.selectOne("center.carDayAnalSum", box);
			model.put("list", list);

			if ("xls".equalsIgnoreCase(HttpUtil.getExt())) {
				list.add(carDayAnalSum);
			} else {
				model.put("userData", carDayAnalSum);
			}

			BizUtil.excelDown(box, model, SpringUtil.getLookupPathForRequest());
		}
	}

	@RequestMapping("carDayAnalDtl")
	public void carDayAnalDtl(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			box.put("srchCenterCdList", box.strToList("srchCenterCd"));

			switch (box.getString("srchAnalDiv")) {
				case "ARR":
					model.put("list", dao.selectList("center.carArrDtlAnalList", box));
					break;
				case "TEMP":
					model.put("list", dao.selectList("center.carTempDtlAnalList", box));
					break;
				case "DELI":
					model.put("list", dao.selectList("center.carDeliDtlAnalList", box));
					break;
			}

			BizUtil.excelDown(box, model, SpringUtil.getLookupPathForRequest());
		}
	}

	/**
	 * 차량 운행현황
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("carAnal")
	public void carAnal(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			box.put("srchCenterCdList", box.strToList("srchCenterCd"));
			model.put("list", dao.selectList("center.carAnalList", box));
			BizUtil.excelDown(box, model, SpringUtil.getLookupPathForRequest());
		}
	}

////	 배치 테스트
//	 @RequestMapping("cargoStatBatch")
//	 public void cargoStatBatch(Box box, ModelMap model) throws Exception {
//	 	if (HttpUtil.isDataExtension()) {
//	 		box.put("daysAgo", com.enpem.web.common.util.ConfigUtil.getInt("scheduled.cargoStat.insert.days.ago"));
//	 		Box model1 = new Box();
//	 		batchService.cargoStatInsert(box, model1);
//	 	}
//	 }
//
////	 배치 테스트
//	 @RequestMapping("carStatBatch")
//	 public void carStatBatch(Box box, ModelMap model) throws Exception {
//	 	if (HttpUtil.isDataExtension()) {
//	 		box.put("daysAgo", com.enpem.web.common.util.ConfigUtil.getInt("scheduled.carStat.insert.days.ago"));
//	 		Box model1 = new Box();
//	 		batchService.carStatDel(box, model1);
//	 		batchService.carBaseStatInsert(box, model1);
//	 		batchService.carTempStatInsert(box, model1);
//	 		batchService.carArrStatInsert(box, model1);
//	 		batchService.carDeliStatInsert(box, model1);
//	 		batchService.carDrvStatInsert(box, model1);
//	 		batchService.carTotDrvStatInsert(box, model1);
//
////	 		batchService.agentCarDrvStatInsert(box, model1);
//	 	}
//	 }
}
