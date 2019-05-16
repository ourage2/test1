package com.enpem.web.common.biz;

import java.util.ArrayList;
import java.util.List;

import com.enpem.web.common.util.StringUtil;
import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;
import org.springframework.ui.ModelMap;

import com.enpem.web.common.data.Box;
import com.enpem.web.common.util.ExcelUtil;

@Component
public class BizUtil {
	protected Logger log = LoggerFactory.getLogger(this.getClass());

	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSessionTemplate dao;

	/**
	 * 엑셀다운로드
	 *
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public static void excelDown(Box box, ModelMap model, String methodNm) throws Exception {
		List<String[]> columnList = new ArrayList<String[]>();
		String title = "";
		List<Box> list =  (ArrayList<Box>)model.get(box.nvl("listKeyNm", "list"));
		if (methodNm.startsWith("/manage/set/msgList")) { //메시지
			title = "메시지";
			columnList.add(new String[]{"msgId", "메시지ID"});
			columnList.add(new String[]{"msgTypeNm", "메시지유형"});
			columnList.add(new String[]{"msgNm", "메시지내용"});
			columnList.add(new String[]{"msgEtc", "메시지상세"});

		} else if (methodNm.startsWith("/manage/set/userHistList")) { //사용자접속로그
			title = "사용자접속로그";
			columnList.add(new String[]{"userId", "사용자ID"});
			columnList.add(new String[]{"userNm", "성명"});
			columnList.add(new String[]{"ipAddr", "접속IP"});
			columnList.add(new String[]{"insertDt", "접속일시"});
			columnList.add(new String[]{"loginGbNm", "구분"});

		} else if (methodNm.startsWith("/manage/set/noregDevList")) { //미등록단말기 내역
			title = "미등록단말기내역";
			columnList.add(new String[]{"insertDt", "서버수신시간"});
			columnList.add(new String[]{"devDt", "단말기수신시간"});
			columnList.add(new String[]{"carTid", "단말기ID"});
			columnList.add(new String[]{"carNo", "차량번호"});
			columnList.add(new String[]{"turnYn", "시동ON/OFF"});
			columnList.add(new String[]{"xpos", "위도"});
			columnList.add(new String[]{"ypos", "경도"});
			columnList.add(new String[]{"dayTotDis", "운행거리"});
			columnList.add(new String[]{"spd", "속도"});
			columnList.add(new String[]{"ch1", "CH1"});
			columnList.add(new String[]{"ch2", "CH2"});
			columnList.add(new String[]{"ch3", "CH3"});
			columnList.add(new String[]{"ch4", "CH4"});
			columnList.add(new String[]{"tempYn", "온도기록계ON/OFF"});

		} else if (methodNm.startsWith("/manage/set/noregAgentList")) { //미등록대리점이력
			title = "미등록대리점이력";
			columnList.add(new String[]{"insertDt", "서버수신시간"});
			columnList.add(new String[]{"deliDt", "납품예정일"});
			columnList.add(new String[]{"centerCd", "센터코드"});
			columnList.add(new String[]{"agentCd", "대리점코드"});
			columnList.add(new String[]{"deliNo", "납품번호"});
			columnList.add(new String[]{"tid1", "연동TID_1"});
			columnList.add(new String[]{"tid2", "연동TID_2"});

		} else if (methodNm.startsWith("/manage/set/alarmHistList")) { //알림발송이력
			title = "알림발송이력";
			columnList.add(new String[]{"seq", "알림발송일련번호"});
			columnList.add(new String[]{"sendNo", "발송번호"});
			columnList.add(new String[]{"sendDt", "발송일시"});
			columnList.add(new String[]{"pushType", "알림종류"});
//			columnList.add(new String[]{"sendId", "발송자ID"});
			columnList.add(new String[]{"sendNm", "발송자명"});
//			columnList.add(new String[]{"recvId", "수신자ID"});
			columnList.add(new String[]{"recvNm", "수신자명"});
			columnList.add(new String[]{"sendFlag", "발송결과"});
			columnList.add(new String[]{"recvFlag", "수신결과"});
			columnList.add(new String[]{"recvTxt", "수신결과내용"});
//			columnList.add(new String[]{"msgIdx", "메세지번호"});
			columnList.add(new String[]{"sendTitle", "발송제목"});
			columnList.add(new String[]{"sendTxt", "발송내용"});

		} else if (methodNm.startsWith("/manage/basis/carList")) { //센터차량
			title = "센터차량";
			columnList.add(new String[]{"carId", "차량ID"});
			columnList.add(new String[]{"carNo", "차량번호"});
			columnList.add(new String[]{"carTid", "차량TID"});
			columnList.add(new String[]{"useYn", "사용여부"});
			columnList.add(new String[]{"dtgYn", "DTG연동여부"});
			columnList.add(new String[]{"rentYn", "용차여부"});
			columnList.add(new String[]{"rentIfStat", "용차인터페이스상태"});
			columnList.add(new String[]{"centerCd", "센터코드"});
			columnList.add(new String[]{"agentCd", "대리점코드"});
			columnList.add(new String[]{"companyCd", "운송회사코드"});
			columnList.add(new String[]{"wetCd", "차종(톤)코드"});
			columnList.add(new String[]{"chCnt", "채널설정갯수"});
			columnList.add(new String[]{"ch1Min", "채널1MIN"});
			columnList.add(new String[]{"ch1Max", "채널1MAX"});
			columnList.add(new String[]{"ch2Min", "채널2MIN"});
			columnList.add(new String[]{"ch2Max", "채널2MAX"});
			columnList.add(new String[]{"ch3Min", "채널3MIN"});
			columnList.add(new String[]{"ch3Max", "채널3MAX"});
			columnList.add(new String[]{"ch4Min", "채널4MIN"});
			columnList.add(new String[]{"ch4Max", "채널4MAX"});
			columnList.add(new String[]{"drvNm", "운전자명"});
			columnList.add(new String[]{"drvTelNo", "전화번호"});
			columnList.add(new String[]{"drvHpNo", "휴대폰번호"});
			columnList.add(new String[]{"drvZipNo", "우편번호"});
			columnList.add(new String[]{"drvAddr1", "지번주소"});
			columnList.add(new String[]{"drvAddr2", "상세주소"});
			columnList.add(new String[]{"lastPosDt", "최종위치연동일시"});
			columnList.add(new String[]{"lastTempDt", "최종온도연동일시"});
			columnList.add(new String[]{"pushYn", "알림여부"});
//			columnList.add(new String[]{"pushIds", "알림ID"});
//			columnList.add(new String[]{"pushNms", "알림자성명"});

		} else if (methodNm.startsWith("/manage/basis/agentCarList")) { //대리점차량
			title = "대리점차량";
			columnList.add(new String[]{"carId", "차량ID"});
			columnList.add(new String[]{"carNo", "차량번호"});
			columnList.add(new String[]{"carTid", "차량TID"});
			columnList.add(new String[]{"useYn", "사용여부"});
			columnList.add(new String[]{"dtgYn", "DTG연동여부"});
			columnList.add(new String[]{"rentYn", "용차여부"});
			columnList.add(new String[]{"rentIfStat", "용차인터페이스상태"});
			columnList.add(new String[]{"centerCd", "센터코드"});
			columnList.add(new String[]{"agentCd", "대리점코드"});
			columnList.add(new String[]{"companyCd", "운송회사코드"});
			columnList.add(new String[]{"wetCd", "차종(톤)코드"});
			columnList.add(new String[]{"chCnt", "채널설정갯수"});
			columnList.add(new String[]{"ch1Min", "채널1MIN"});
			columnList.add(new String[]{"ch1Max", "채널1MAX"});
			columnList.add(new String[]{"ch2Min", "채널2MIN"});
			columnList.add(new String[]{"ch2Max", "채널2MAX"});
			columnList.add(new String[]{"ch3Min", "채널3MIN"});
			columnList.add(new String[]{"ch3Max", "채널3MAX"});
			columnList.add(new String[]{"ch4Min", "채널4MIN"});
			columnList.add(new String[]{"ch4Max", "채널4MAX"});
			columnList.add(new String[]{"drvNm", "운전자명"});
			columnList.add(new String[]{"drvTelNo", "전화번호"});
			columnList.add(new String[]{"drvHpNo", "휴대폰번호"});
			columnList.add(new String[]{"drvZipNo", "우편번호"});
			columnList.add(new String[]{"drvAddr1", "지번주소"});
			columnList.add(new String[]{"drvAddr2", "상세주소"});
			columnList.add(new String[]{"lastPosDt", "최종위치연동일시"});
			columnList.add(new String[]{"lastTempDt", "최종온도연동일시"});
			columnList.add(new String[]{"pushYn", "알림여부"});
//			columnList.add(new String[]{"pushIds", "알림ID"});
//			columnList.add(new String[]{"pushNms", "알림자성명"});

		} else if (methodNm.startsWith("/manage/basis/cargoDevList")) { //센터창고단말
			title = "센터창고단말";
			columnList.add(new String[]{"devId", "단말ID"});
			columnList.add(new String[]{"cargoNm", "창고명"});
			columnList.add(new String[]{"useYn", "사용여부"});
			columnList.add(new String[]{"devNm", "단말명"});
			columnList.add(new String[]{"chargeId", "담당자ID"});
			columnList.add(new String[]{"chargeNm", "담당자명"});
			columnList.add(new String[]{"chargeTel", "연락처"});
			columnList.add(new String[]{"chargeHp", "핸드폰"});
			columnList.add(new String[]{"centerCd", "센터코드"});
			columnList.add(new String[]{"agentCd", "대리점코드"});
			columnList.add(new String[]{"chCnt", "채널설정갯수"});
			columnList.add(new String[]{"ch1Nm", "채널1명칭"});
			columnList.add(new String[]{"ch1Min", "채널1MIN"});
			columnList.add(new String[]{"ch1Max", "채널1MAX"});
			columnList.add(new String[]{"ch2Nm", "채널2명칭"});
			columnList.add(new String[]{"ch2Min", "채널2MIN"});
			columnList.add(new String[]{"ch2Max", "채널2MAX"});
			columnList.add(new String[]{"ch3Nm", "채널3명칭"});
			columnList.add(new String[]{"ch3Min", "채널3MIN"});
			columnList.add(new String[]{"ch3Max", "채널3MAX"});
			columnList.add(new String[]{"ch4Nm", "채널4명칭"});
			columnList.add(new String[]{"ch4Min", "채널4MIN"});
			columnList.add(new String[]{"ch4Max", "채널4MAX"});
			columnList.add(new String[]{"ch5Nm", "채널5명칭"});
			columnList.add(new String[]{"ch5Min", "채널5MIN"});
			columnList.add(new String[]{"ch5Max", "채널5MAX"});
			columnList.add(new String[]{"ch6Nm", "채널6명칭"});
			columnList.add(new String[]{"ch6Min", "채널6MIN"});
			columnList.add(new String[]{"ch6Max", "채널6MAX"});
			columnList.add(new String[]{"lastDevDt", "최종단말연동일시"});
			columnList.add(new String[]{"lastSvrDt", "최종서버연동일시"});
			columnList.add(new String[]{"chargeId", "담당자ID"});
			columnList.add(new String[]{"pushYn", "알림여부"});
//			columnList.add(new String[]{"pushIds", "알림ID"});
//			columnList.add(new String[]{"pushNms", "알림자성명"});

		} else if (methodNm.startsWith("/manage/basis/agentCargoList")) { //대리점창고단말
			title = "대리점창고단말";
			columnList.add(new String[]{"devId", "단말ID"});
			columnList.add(new String[]{"cargoNm", "창고명"});
			columnList.add(new String[]{"useYn", "사용여부"});
			columnList.add(new String[]{"devNm", "단말명"});
			columnList.add(new String[]{"agentCd", "대리점코드"});
			columnList.add(new String[]{"agentNm", "대리점명"});
			columnList.add(new String[]{"chargeId", "담당자ID"});
			columnList.add(new String[]{"chargeNm", "담당자명"});
			columnList.add(new String[]{"chargeTel", "연락처"});
			columnList.add(new String[]{"chargeHp", "핸드폰"});
			columnList.add(new String[]{"centerCd", "센터코드"});
			columnList.add(new String[]{"agentCd", "대리점코드"});
			columnList.add(new String[]{"chCnt", "채널설정갯수"});
			columnList.add(new String[]{"ch1Nm", "채널1명칭"});
			columnList.add(new String[]{"ch1Min", "채널1MIN"});
			columnList.add(new String[]{"ch1Max", "채널1MAX"});
			columnList.add(new String[]{"ch2Nm", "채널2명칭"});
			columnList.add(new String[]{"ch2Min", "채널2MIN"});
			columnList.add(new String[]{"ch2Max", "채널2MAX"});
			columnList.add(new String[]{"ch3Nm", "채널3명칭"});
			columnList.add(new String[]{"ch3Min", "채널3MIN"});
			columnList.add(new String[]{"ch3Max", "채널3MAX"});
			columnList.add(new String[]{"ch4Nm", "채널4명칭"});
			columnList.add(new String[]{"ch4Min", "채널4MIN"});
			columnList.add(new String[]{"ch4Max", "채널4MAX"});
			columnList.add(new String[]{"ch5Nm", "채널5명칭"});
			columnList.add(new String[]{"ch5Min", "채널5MIN"});
			columnList.add(new String[]{"ch5Max", "채널5MAX"});
			columnList.add(new String[]{"ch6Nm", "채널6명칭"});
			columnList.add(new String[]{"ch6Min", "채널6MIN"});
			columnList.add(new String[]{"ch6Max", "채널6MAX"});
			columnList.add(new String[]{"lastDevDt", "최종단말연동일시"});
			columnList.add(new String[]{"lastSvrDt", "최종서버연동일시"});
			columnList.add(new String[]{"chargeId", "담당자ID"});
			columnList.add(new String[]{"pushYn", "알림여부"});
//			columnList.add(new String[]{"pushIds", "알림ID"});
//			columnList.add(new String[]{"pushNms", "알림자성명"});

		} else if (methodNm.startsWith("/manage/basis/userList")) { //사용자
			title = "사용자";
			columnList.add(new String[]{"userId", "사용자ID"});
			columnList.add(new String[]{"useYn", "사용여부"});
			columnList.add(new String[]{"userNm", "성명"});
//			columnList.add(new String[]{"userPwd", "패스워드"});
//			columnList.add(new String[]{"authCd", "권한코드"});
			columnList.add(new String[]{"acDivNm", "구분"});
			columnList.add(new String[]{"acNm", "소속(센터/대리점)"});
//			columnList.add(new String[]{"authCenterCd", "권한센터"});
//			columnList.add(new String[]{"authCenterNm", "권한센터명"});
			columnList.add(new String[]{"telNo", "전화번호"});
			columnList.add(new String[]{"hpNo", "휴대폰번호"});
//			columnList.add(new String[]{"faxNo", "팩스번호"});
			columnList.add(new String[]{"email", "이메일"});
			columnList.add(new String[]{"lastConDt", "최종접속일시"});

		} else if (methodNm.startsWith("/manage/basis/agentList")) { //대리점
			title = "대리점";
			columnList.add(new String[]{"agentCd", "대리점코드"});
			columnList.add(new String[]{"agentNm", "대리점명"});
			columnList.add(new String[]{"useYn", "사용여부"});
			columnList.add(new String[]{"centerCd", "센터코드"});
			columnList.add(new String[]{"empNo", "담당사원사번"});
			columnList.add(new String[]{"si", "시"});
			columnList.add(new String[]{"gu", "구"});
			columnList.add(new String[]{"dong", "동"});
			columnList.add(new String[]{"ri", "리"});
			columnList.add(new String[]{"sBunji", "시작번지"});
			columnList.add(new String[]{"eBunji", "종료번지"});
			columnList.add(new String[]{"staffNm", "대리점장명"});
			columnList.add(new String[]{"staffHpNo", "대리점장휴대폰"});
			columnList.add(new String[]{"staffTelNo", "대리점장전화번호"});
			columnList.add(new String[]{"sapUpdateDt", "SAP수정일시"});
			columnList.add(new String[]{"enpemZip", "enpem우편번호"});
			columnList.add(new String[]{"enpemSi", "enpem시도"});
			columnList.add(new String[]{"enpemAddr", "enpem주소"});
			columnList.add(new String[]{"xpos", "위도"});
			columnList.add(new String[]{"ypos", "경도"});
			columnList.add(new String[]{"enpemHpNo", "enpem휴대폰"});
			columnList.add(new String[]{"enpemTelNo", "enpem전화번호"});
			columnList.add(new String[]{"soCd", "사업장코드"});
			columnList.add(new String[]{"chCd", "영업그룹코드"});
			columnList.add(new String[]{"normalFrom", "평일출발시각"});
			columnList.add(new String[]{"normalTo", "평일도착시각"});
			columnList.add(new String[]{"weekendFrom", "주말출발시각"});
			columnList.add(new String[]{"weekendTo", "주말도착시각"});

		} else if (methodNm.startsWith("/manage/basis/agentIoList")) { //대리점출도착
			title = "대리점출도착";
			columnList.add(new String[]{"agentCd", "대리점코드"});
			columnList.add(new String[]{"agentNm", "대리점명"});
			columnList.add(new String[]{"centerCd", "센터코드"});
			columnList.add(new String[]{"centerNm", "센터명"});
			columnList.add(new String[]{"normalFrom", "평일출발시각"});
			columnList.add(new String[]{"normalTo", "평일도착시각"});
			columnList.add(new String[]{"weekendFrom", "주말출발시각"});
			columnList.add(new String[]{"weekendTo", "주말도착시각"});

		} else if (methodNm.startsWith("/manage/basis/restList") || methodNm.startsWith("/manage/basis/restBatchList")) { //차량휴무
			title = box.nvl("title", "차량휴무");

			columnList.add(new String[]{"carId", "차량ID"});
			columnList.add(new String[]{"centerNm", "센터명"});
			columnList.add(new String[]{"carNo", "차량번호"});
			columnList.add(new String[]{"drvNm", "운전자"});
			columnList.add(new String[]{"stdYm", "기준년월"});
			columnList.add(new String[]{"day1", "1일"});
			columnList.add(new String[]{"day2", "2일"});
			columnList.add(new String[]{"day3", "3일"});
			columnList.add(new String[]{"day4", "4일"});
			columnList.add(new String[]{"day5", "5일"});
			columnList.add(new String[]{"day6", "6일"});
			columnList.add(new String[]{"day7", "7일"});
			columnList.add(new String[]{"day8", "8일"});
			columnList.add(new String[]{"day9", "9일"});
			columnList.add(new String[]{"day10", "10일"});
			columnList.add(new String[]{"day11", "11일"});
			columnList.add(new String[]{"day12", "12일"});
			columnList.add(new String[]{"day13", "13일"});
			columnList.add(new String[]{"day14", "14일"});
			columnList.add(new String[]{"day15", "15일"});
			columnList.add(new String[]{"day16", "16일"});
			columnList.add(new String[]{"day17", "17일"});
			columnList.add(new String[]{"day18", "18일"});
			columnList.add(new String[]{"day19", "19일"});
			columnList.add(new String[]{"day20", "20일"});
			columnList.add(new String[]{"day21", "21일"});
			columnList.add(new String[]{"day22", "22일"});
			columnList.add(new String[]{"day23", "23일"});
			columnList.add(new String[]{"day24", "24일"});
			columnList.add(new String[]{"day25", "25일"});
			columnList.add(new String[]{"day26", "26일"});
			columnList.add(new String[]{"day27", "27일"});
			columnList.add(new String[]{"day28", "28일"});
			columnList.add(new String[]{"day29", "29일"});
			columnList.add(new String[]{"day30", "30일"});
			columnList.add(new String[]{"day31", "31일"});

		} else if (methodNm.startsWith("/manage/crate/sapIfList")) {
			title = "SAP인터페이스 현황";

			columnList.add(new String[]{"centerName", "센터"});
			columnList.add(new String[]{"ifSeq", "고유번호"});
			columnList.add(new String[]{"shipNo", "선적번호"});
			columnList.add(new String[]{"deliNo", "납품번호"});
			columnList.add(new String[]{"sendDiv", "업/다운 구분"});
			columnList.add(new String[]{"ifDivNm", "인터페이스 구분"});
			columnList.add(new String[]{"succYn", "전송결과"});
			columnList.add(new String[]{"errMsg", "전송메시지"});
			columnList.add(new String[]{"ifDt", "인터페이스 일자"});

		} else if (methodNm.startsWith("/manage/crate/inOutList")) {
			title = "포장재 회수현황";

			columnList.add(new String[]{"shipReqDate", "납품요청일"});
			columnList.add(new String[]{"shipNo", "선적번호"});
			columnList.add(new String[]{"carId", "차량번호"});
			columnList.add(new String[]{"pkgNm", "포장재항목"});
			columnList.add(new String[]{"outCnt", "현재출고수량"});
			if("show".equals(box.getString("srchIdVisible")))
				columnList.add(new String[]{"outId", "입력자"});
			columnList.add(new String[]{"sapOutCnt", "전산출고수량"});
			columnList.add(new String[]{"agentOutCnt", "하차수량"});
			columnList.add(new String[]{"agentInCnt", "회수수량"});
			columnList.add(new String[]{"inCnt", "검수수량"});
			if("show".equals(box.getString("srchIdVisible")))
				columnList.add(new String[]{"inId", "입력자"});
			columnList.add(new String[]{"inoutDifYn", "차이유무"});
			columnList.add(new String[]{"updateYn", "수정여부"});
		} else if (methodNm.startsWith("/manage/crate/inOutAdjResultList")) {
			title = "관리자수정 이력조회";

			columnList.add(new String[]{"shipReqDate", "납품요청일"});
			columnList.add(new String[]{"shipNo", "선적번호"});
			columnList.add(new String[]{"carId", "차량번호"});
			columnList.add(new String[]{"deliNo", "납품번호"});
			columnList.add(new String[]{"agentCd", "대리점코드"});
			columnList.add(new String[]{"agentNm", "대리점명"});
			columnList.add(new String[]{"pkgNm", "포장재항목"});
			columnList.add(new String[]{"outCnt", "현재출고수량"});
			columnList.add(new String[]{"sapOutCnt", "전산출고수량"});
			columnList.add(new String[]{"agentOutCnt", "하차수량"});
			columnList.add(new String[]{"agentOutAdjCnt", "하차조정수량"});
			columnList.add(new String[]{"agentInCnt", "회수수량"});
			columnList.add(new String[]{"agentInAdjCnt", "회수조정수량"});
		} else if (methodNm.startsWith("/manage/crate/inOutAnalList")) {
			title = "포장재 회수현황 통계관리";

			columnList.add(new String[]{"carId", "차량번호"});
			columnList.add(new String[]{"agentCd", "대리점코드"});
			columnList.add(new String[]{"agentNm", "대리점명"});
			columnList.add(new String[]{"pkgNm", "포장재항목"});
			columnList.add(new String[]{"sapOutCnt", "출고수량"});
			columnList.add(new String[]{"inCnt", "회수수량"});
			columnList.add(new String[]{"inAdjCnt", "회수조정수량"});
			columnList.add(new String[]{"inRt", "회수율"});
		} else if (methodNm.startsWith("/manage/crate/sapIfResultList")) {
			title = "SAP전송여부조회";

			columnList.add(new String[]{"centerNm", "센터명"});
			columnList.add(new String[]{"shipReqDate", "납품예정일"});
			columnList.add(new String[]{"shipNo", "선적번호"});
			columnList.add(new String[]{"deliNo", "납품번호"});
			columnList.add(new String[]{"outCntIfStat", "출고수량전송여부"});
			columnList.add(new String[]{"inCntIfStat", "회수수량전송여부"});
			columnList.add(new String[]{"deliYn", "업무완료여부"});
		} else if (methodNm.endsWith("/manage/center/dayCarDrvAnal.xls")) {
			title = "일자별 차량 운행 내역";

			columnList.add(new String[]{"rnum", "순번"});
			columnList.add(new String[]{"centerNm", "센터명"});
			columnList.add(new String[]{"stdDate", "조회일"});
			columnList.add(new String[]{"companyNm", "소속운송사"});
			columnList.add(new String[]{"carNo", "차량번호"});
			columnList.add(new String[]{"drvNm", "운전자"});
			columnList.add(new String[]{"totDis", "운행거리"});
			columnList.add(new String[]{"totTm", "운행시간"});
			columnList.add(new String[]{"lastAgentStrTm", "최종 대리점 출발 시간"});
			columnList.add(new String[]{"drvDis", "업무거리"});
			columnList.add(new String[]{"drvTm", "업무시간"});
			columnList.add(new String[]{"shipCnt", "선적건수"});
			columnList.add(new String[]{"deliCompCnt", "납품건수"});
			columnList.add(new String[]{"arrNorVioCnt", "SAP기준 정시/위반 납품"});
			columnList.add(new String[]{"arrAgentNorVioCnt", "구간기준 정시/위반 납품"});
			columnList.add(new String[]{"inputArrVioCnt", "사유건수"});
			columnList.add(new String[]{"tempTotCnt", "온도수집건"});
			columnList.add(new String[]{"tempVioLongCnt", "기준온도 위반건"});
			columnList.add(new String[]{"tempHaccpVioLongCnt", "HACCP 온도 위반건"});
			columnList.add(new String[]{"inputTempVioCnt", "사유건수"});
			columnList.add(new String[]{"restNm", "상태정보"});
		} else if (methodNm.endsWith("/manage/center/dayCarDrvAnalDtl.xls")) {
			title = "일자별 차량 운행 세부 내역";

			columnList.add(new String[]{"rnum", "순번"});
			columnList.add(new String[]{"devTm", "보고시간"});
			columnList.add(new String[]{"jibunAddr", "주소"});
			columnList.add(new String[]{"spd", "속도"});
			columnList.add(new String[]{"dayTotDis", "누적운행거리"});
			columnList.add(new String[]{"ch1", "CH1"});
			columnList.add(new String[]{"ch2", "CH2"});
			columnList.add(new String[]{"shipNo", "선적번호"});
			columnList.add(new String[]{"deliNo", "납품번호"});
			columnList.add(new String[]{"agentCd", "대리점코드"});
			columnList.add(new String[]{"agentNm", "대리점명"});
			columnList.add(new String[]{"delayTxt", "도착 위반여부"});
			columnList.add(new String[]{"arrVioNm", "위반사유"});
			columnList.add(new String[]{"vioTxt", "온도상태"});
			columnList.add(new String[]{"vioLongTxt", "온도위반여부"});
			columnList.add(new String[]{"tempVioNm", "온도위반사유"});
			columnList.add(new String[]{"event", "배송이벤트"});

		} else if (methodNm.endsWith("/manage/center/dayCargoTempAnal.xls")) {
			title = "일자별 창고 온도 내역";

			columnList.add(new String[]{"rnum", "순번"});
			columnList.add(new String[]{"stdDate", "날짜"});
			columnList.add(new String[]{"centerNm", "센터명"});
			columnList.add(new String[]{"cargoNm", "창고명"});
			columnList.add(new String[]{"devId", "창고ID"});
			columnList.add(new String[]{"totCnt", "수집횟수"});
			columnList.add(new String[]{"vioCnt", "이상온도횟수"});
			columnList.add(new String[]{"vioLongCnt", "위반횟수"});
			columnList.add(new String[]{"norRt", "온도준수율"});

		} else if (methodNm.endsWith("/manage/center/dayCargoTempAnalDtl.xls")) {

			title = "창고 온도 세부 내역";

			columnList.add(new String[]{"rnum", "순번"});
			columnList.add(new String[]{"devDt", "시간"});
			columnList.add(new String[]{"ch1", "CH1"});
			columnList.add(new String[]{"ch2", "CH2"});
			columnList.add(new String[]{"ch3", "CH3"});
			columnList.add(new String[]{"ch4", "CH4"});
			columnList.add(new String[]{"ch5", "CH5"});
			columnList.add(new String[]{"ch6", "CH6"});
			columnList.add(new String[]{"tempStat", "온도상태"});
			columnList.add(new String[]{"tempVioNm", "위반상태"});

		} else if (methodNm.startsWith("/manage/center/dayAnal")) {
			title = "일자별 누적 내역 현황";

			String xlsColLbs = box.getString("xlsColLbs");
			String xlsColNms = box.getString("xlsColNms");

			if (StringUtil.isNotEmpty(xlsColLbs)) {
				String[] nms = xlsColNms.split(",");
				String[] lbs = xlsColLbs.split(",");
				for (int i = 0; i < nms.length; i++) {
					columnList.add(new String[]{nms[i], lbs[i]});
				}
			}
		} else if (methodNm.endsWith("/manage/center/dayTempAnal.xls")) {

			title = "센터별 차량 온도 준수율";

			columnList.add(new String[]{"rnum", "순번"});
			columnList.add(new String[]{"centerNm", "센터"});
			columnList.add(new String[]{"restCnt", "휴차"});
			columnList.add(new String[]{"devBknCnt", "단말기고장"});
			columnList.add(new String[]{"fixCnt", "차량수리"});
			columnList.add(new String[]{"etcCnt", "기타"});
			columnList.add(new String[]{"norCnt", "정상운행"});
			columnList.add(new String[]{"tempTotCnt2", "전체온도건수"});
			columnList.add(new String[]{"tempVioLongCnt", "온도위반건수"});
			columnList.add(new String[]{"tempNorRt", "온도준수율"});
			columnList.add(new String[]{"tempTotCnt1", "전체온도건수"});
			columnList.add(new String[]{"tempHaccpVioLongCnt", "온도위반건수"});
			columnList.add(new String[]{"tempHaccpNorRt", "온도준수율"});
			columnList.add(new String[]{"difRt", "차이"});

		} else if (methodNm.endsWith("/manage/center/dayTempAnalDtl.xls")) {

			title = "차량별 온도 준수율";

			columnList.add(new String[]{"rnum", "순번"});
			columnList.add(new String[]{"centerNm", "센터"});
			columnList.add(new String[]{"companyNm", "차량소속"});
			columnList.add(new String[]{"carNo", "차량번호"});
			columnList.add(new String[]{"drvNm", "운전자"});
			columnList.add(new String[]{"restNm", "차량구분"});
			columnList.add(new String[]{"tempTotCnt2", "전체온도건수"});
			columnList.add(new String[]{"tempVioCnt", "온도위반건수"});
			columnList.add(new String[]{"tempNorRt", "온도준수율"});
			columnList.add(new String[]{"tempTotCnt1", "전체온도건수"});
			columnList.add(new String[]{"tempHaccpVioCnt", "온도위반건수"});
			columnList.add(new String[]{"tempHaccpNorRt", "온도준수율"});

		} else if (methodNm.startsWith("/manage/center/carAnal")) {
			title = "차량 운행 현황";

			columnList.add(new String[]{"rnum", "순번"});
			columnList.add(new String[]{"centerNm", "소속센터"});
			columnList.add(new String[]{"companyNm", "운송사"});
			columnList.add(new String[]{"agentNm", "대리점"});
			columnList.add(new String[]{"stdDate", "운행날짜"});
			columnList.add(new String[]{"carId", "차량코드"});
			columnList.add(new String[]{"carNo", "차량번호"});
			columnList.add(new String[]{"drvNm", "운전자명"});
			columnList.add(new String[]{"drvHpNo", "핸드폰"});
			columnList.add(new String[]{"drvTm", "운행시간"});
			columnList.add(new String[]{"drvDis", "운행거리"});
			columnList.add(new String[]{"drvCnt", "운행횟수"});
			columnList.add(new String[]{"idleCnt", "공회전횟수"});
			columnList.add(new String[]{"overSpdCnt", "과속횟수"});
			columnList.add(new String[]{"burstSpdCnt", "급가속횟수"});
			columnList.add(new String[]{"dropSpdCnt", "급감속횟수"});

		} else if (methodNm.endsWith("manage/agent/agentCargoTempList.xls")) {
			title = "대리점 창고 온도 내역";

			columnList.add(new String[]{"rnum", "순번"});
			columnList.add(new String[]{"stdDate", "날짜"});
			columnList.add(new String[]{"agentNm", "대리점명"});
			columnList.add(new String[]{"cargoNm", "창고명"});
			columnList.add(new String[]{"devId", "창고ID"});
			columnList.add(new String[]{"totCnt", "수집횟수"});
			columnList.add(new String[]{"vioCnt", "이상온도횟수"});
			columnList.add(new String[]{"vioLongCnt", "위반횟수"});
			columnList.add(new String[]{"norRt", "온도준수율"});

		} else if (methodNm.endsWith("manage/center/dayCarNow.xls")) {
			title = "일자별차량 운행현황 선적정보";
			columnList.add(new String[]{"rnum", "순번"});
			columnList.add(new String[]{"strBizCd", "수배송"});
			columnList.add(new String[]{"centerNm", "소속센터"});
			columnList.add(new String[]{"carNo", "차량번호"});
			columnList.add(new String[]{"shipNo", "선적번호"});
			columnList.add(new String[]{"shipReqDate", "납품요청일"});

		} else if (methodNm.endsWith("manage/center/dayCarNowHistList.xls")) {
			title = "일자별차량 운행현황";

			columnList.add(new String[]{"rnum", "순번"});
			columnList.add(new String[]{"devDt", "시간"});
			columnList.add(new String[]{"jibunAddr", "주소"});
			columnList.add(new String[]{"spd", "속도"});
			columnList.add(new String[]{"dayDis", "운행거리"});
			columnList.add(new String[]{"ch1", "CH1"});
			columnList.add(new String[]{"ch2", "CH2"});
			columnList.add(new String[]{"ch3", "CH3"});
			columnList.add(new String[]{"ch4", "CH4"});
			columnList.add(new String[]{"bigo", "비고"});

		} else if (methodNm.endsWith("manage/center/dayAgentArrAnal.xls")) {

			title = "대리점 정시 도착률";

			columnList.add(new String[]{"rnum", "순번"});
			columnList.add(new String[]{"centerNm", "센터"});
			columnList.add(new String[]{"deliPlanCnt", "전체건수"});
			columnList.add(new String[]{"arrTotCnt", "도착건수"});
			columnList.add(new String[]{"inCompCnt", "미도착건수"});
			columnList.add(new String[]{"arrAgentNorCnt", "정시"});
			columnList.add(new String[]{"arrAgentVioCnt", "위반"});
			columnList.add(new String[]{"arrAgentNorRt", "정시도착율(%)"});
			columnList.add(new String[]{"arrNorCnt", "정시"});
			columnList.add(new String[]{"arrVioCnt", "위반"});
			columnList.add(new String[]{"arrNorRt", "정시도착율(%)"});
			columnList.add(new String[]{"difRt", "차이(%)"});

		} else if (methodNm.endsWith("manage/center/dayAgentArrAnalDtlList.xls")) {

			title = "차량별 대리점 도착률";

			columnList.add(new String[]{"rnum", "순번"});
			columnList.add(new String[]{"centerNm", "센터"});
			columnList.add(new String[]{"companyNm", "차량소속"});
			columnList.add(new String[]{"carNo", "차량번호"});
			columnList.add(new String[]{"drvNm", "운전자"});
			columnList.add(new String[]{"restNm", "차량구분"});
			columnList.add(new String[]{"arrTotCnt", "납품완료건"});
			columnList.add(new String[]{"arrAgentNorCnt", "정시"});
			columnList.add(new String[]{"arrAgentVioCnt", "위반"});
			columnList.add(new String[]{"arrAgentNorRt", "정시도착률"});
			columnList.add(new String[]{"arrNorCnt", "정시"});
			columnList.add(new String[]{"arrVioCnt", "위반"});
			columnList.add(new String[]{"arrNorRt", "정시도착률"});
			columnList.add(new String[]{"difRt", "차이"});

		} else if (methodNm.endsWith("manage/center/carDayAnal.xls")) {
			title = "차량별 누적 현황 - " + box.getString("xlsTitle");

			String xlsColLbs = box.getString("xlsColLbs");
			String xlsColNms = box.getString("xlsColNms");

			if (StringUtil.isNotEmpty(xlsColLbs)) {
				String[] nms = xlsColNms.split(",");
				String[] lbs = xlsColLbs.split(",");
				for (int i = 0; i < nms.length; i++) {
					columnList.add(new String[]{nms[i], lbs[i]});
				}
			}
		} else if (methodNm.endsWith("manage/center/carDayAnalDtl.xls")) {
			title = "차량별 누적 현황 - " + box.getString("xlsTitle");

			String xlsColLbs = box.getString("xlsColLbs");
			String xlsColNms = box.getString("xlsColNms");

			if (StringUtil.isNotEmpty(xlsColLbs)) {
				String[] nms = xlsColNms.split(",");
				String[] lbs = xlsColLbs.split(",");
				for (int i = 0; i < nms.length; i++) {
					columnList.add(new String[]{nms[i], lbs[i]});
				}
			}
		} else if (methodNm.endsWith("manage/center/dayCarTempAnalHist.xls")) {
			title = "온도 준수율 세부 현황";

			columnList.add(new String[]{"rnum", "순번"});
			columnList.add(new String[]{"devTm", "보고시간"});
			columnList.add(new String[]{"jibunAddr", "주소"});
			columnList.add(new String[]{"spd", "속도"});
			columnList.add(new String[]{"ch1", "CH1"});
			columnList.add(new String[]{"ch2", "CH2"});
			columnList.add(new String[]{"maeilTempStat1", "온도상태"});
			columnList.add(new String[]{"maeilTempStat2", "온도위반(기준)"});
			columnList.add(new String[]{"haccpTempStat1", "온도상태"});
			columnList.add(new String[]{"haccpTempStat2", "온도위반(HACCP)"});
			columnList.add(new String[]{"event", "Event내역"});
		}

		if (list != null && !list.isEmpty()) {
			StringBuffer sb = new StringBuffer();
			for (String key : box.keySet()) {
				if (key.startsWith("srch") && !box.nvl(key).equals("")) {
					sb.append(key + ": " + box.nvl(key) + "   ");
				}
			}
			ExcelUtil.setExcelInfo(model, title, columnList, list, sb.toString(), "총합계 : " + list.size());
		} else {
			ExcelUtil.setExcelInfo(model, title, columnList, null, null, "총합계 : 0");
		}

	}


}