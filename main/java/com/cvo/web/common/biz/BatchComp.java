package com.enpem.web.common.biz;

import com.enpem.web.manage.service.CrateService;
import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.enpem.web.common.data.Box;
import com.enpem.web.common.util.ConfigUtil;
import com.enpem.web.common.util.DateUtil;
import com.enpem.web.common.util.HttpUtil;
import com.enpem.web.common.util.SystemUtil;
import org.springframework.ui.ModelMap;

@Component
public class BatchComp {
	protected Logger log = LoggerFactory.getLogger(this.getClass());

	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSessionTemplate dao;

	@Autowired
	private BatchService batchService;

	@Autowired
	private CrateService crateService;

	/**
	 * 스케쥴 수행여부 체크
	 *
	 * @return
	 */
	public boolean isProc() {
		//Scheduled 수행여부가 'Y'로 설정되지 않을 경우 동작하지 않음
		if (!"Y".equals(ConfigUtil.getString("scheduled.yn"))) {
			log.debug("스케쥴 수행여부가 Y로 설정되어 있지 않음");
			return false;
		}

		//Scheduled 수행서버ip와 현재 수행하는 머신의 ip가 일치하지 않을 경우 동작하지 않게함
		if ("LOCAL".equals(ConfigUtil.getString("server.mode")) || "TEST".equals(ConfigUtil.getString("server.mode"))) {
			if (!HttpUtil.getLocalIpAddr().equals(ConfigUtil.getString("scheduled.server.ip"))) {
				log.debug("스케쥴이 수행될 머신의 ip 불일치 : " + HttpUtil.getLocalIpAddr() + ", " + ConfigUtil.getString("scheduled.server.ip"));
				return false;
			}
		} else if ("REAL".equals(ConfigUtil.getString("server.mode"))) {
			String scheduledWasInstanceId = ConfigUtil.getString("scheduled.was.instanceId");
			if (scheduledWasInstanceId == null || !SystemUtil.getWasName().equals(scheduledWasInstanceId)) {
				log.debug("인스턴스명 불일치 : " + SystemUtil.getWasName() + "," + scheduledWasInstanceId);
				return false;
			}
		}

		return true;
	}


	/**
	 *  첨부파일정리 스케쥴러
	 *  ex) 공지사항, 1:1문의등의 글이 삭제되었거나 임시저장상태에서 저장된 파일들을 일괄삭제한다.(하루전 데이터)
	 *
	 * @Scheduled(fixedDelay=5000, initialDelay = 1000)
	 * 이전 호출이 완료된 시점부터 고정적으로 5초마다 수행됨.
	 * 최초 수행시 에는 1초 딜레타임이 발생함.
	 *
	 * @Scheduled(fixedRate=5000)
	 * 연속적인 시작 시각의 간격으로 계산된 5초마다 수행됨.
	 * 이전 수행의 종료를 기다리지 않고 수행됨
	 *
	 * @Scheduled(cron="5 * * * * MON-FRI")
	 * cron 표현식을 이용한 주기적 수행.
	 *
		초 0-59 , - * /
		분 0-59 , - * /
		시 0-23 , - * /
		일 1-31 , - * ? / L W
		월 1-12 or JAN-DEC , - * /
		요일 1-7 or SUN-SAT , - * ? / L #
		년(옵션) 1970-2099 , - * /
		* : 모든 값
		? : 특정 값 없음
		- : 범위 지정에 사용
		, : 여러 값 지정 구분에 사용
		/ : 초기값과 증가치 설정에 사용
		L : 지정할 수 있는 범위의 마지막 값
		W : 월~금요일 또는 가장 가까운 월/금요일
		# : 몇 번째 무슨 요일 2#1 => 첫 번째 월요일

		예제) Expression Meaning
		초 분 시 일 월 주(년)
		 "0 0 12 * * ?" : 아무 요일, 매월, 매일 12:00:00
		 "0 15 10 ? * *" : 모든 요일, 매월, 아무 날이나 10:15:00
		 "0 15 10 * * ?" : 아무 요일, 매월, 매일 10:15:00
		 "0 15 10 * * ? *" : 모든 연도, 아무 요일, 매월, 매일 10:15
		 "0 15 10 * * ? : 2005" 2005년 아무 요일이나 매월, 매일 10:15
		 "0 * 14 * * ?" : 아무 요일, 매월, 매일, 14시 매분 0초
		 "0 0/5 14 * * ?" : 아무 요일, 매월, 매일, 14시 매 5분마다 0초
		 "0 0/5 14,18 * * ?" : 아무 요일, 매월, 매일, 14시, 18시 매 5분마다 0초
		 "0 0-5 14 * * ?" : 아무 요일, 매월, 매일, 14:00 부터 매 14:05까지 매 분 0초
		 "0 10,44 14 ? 3 WED" : 3월의 매 주 수요일, 아무 날짜나 14:10:00, 14:44:00
		 "0 15 10 ? * MON-FRI" : 월~금, 매월, 아무 날이나 10:15:00
		 "0 15 10 15 * ?" : 아무 요일, 매월 15일 10:15:00
		 "0 15 10 L * ?" : 아무 요일, 매월 마지막 날 10:15:00
		 "0 15 10 ? * 6L" : 매월 마지막 금요일 아무 날이나 10:15:00
		 "0 15 10 ? * 6L 2002-2005" : 2002년부터 2005년까지 매월 마지막 금요일 아무 날이나 10:15:00
		 "0 15 10 ? * 6#3" : 매월 3번째 금요일 아무 날이나 10:15:0
	 *
	 * @throws Exception
	 */
//	@Scheduled(fixedDelayString="#{config['scheduled.file.clean.delay']}")
	@Scheduled(cron="${scheduled.file.clean.cron}")
//	@Scheduled(cron="0 30 10 * * ?") //매일 10시 30분 0초
//	@Scheduled(cron="0 * * * * ?") //매분 0초마다
	public void fileDelBatch() throws Exception {

		if (this.isProc()) { return; }
		log.debug("*첨부파일정리 스케쥴러 수행 시작 : " + DateUtil.nowYYYYMMDDHH24MIssSSSDash());
		Box box = new Box();
		Box model = new Box();
		batchService.fileDel(box, model);
	}

	/**
	 * RAW 데이터 삭제 스케쥴러
	 *
	 * @throws Exception
	 */
//	@Scheduled(cron="${scheduled.raw.delete.cron}")
//	@Scheduled(cron="0 40 0 * * ?") //매일 0시 40분 0초
//	@Scheduled(cron="0 * * * * ?") //매분 0초마다
	public void rawDelBatch() throws Exception {

		if (this.isProc()) { return; }
		log.debug("*RAW 데이터 삭제 스케쥴러 수행 시작 : " + DateUtil.nowYYYYMMDDHH24MIssSSSDash());
		Box box = new Box();
		Box model = new Box();
		batchService.rawDel(box, model);
	}

	/**
	 * 미등록 차량/대리점 데이터 삭제 스케쥴러
	 *
	 * @throws Exception
	 */
	@Scheduled(cron="${scheduled.noreg.delete.cron}")
//	@Scheduled(cron="0 40 0 * * ?") //매일 0시 50분 0초
//	@Scheduled(cron="0 * * * * ?") //매분 0초마다
	public void noregDelBatch() throws Exception {

		if (this.isProc()) { return; }
		log.debug("*미등록 차량/대리점 데이터 삭제 스케쥴러 수행 시작 : " + DateUtil.nowYYYYMMDDHH24MIssSSSDash());
		Box box = new Box();
		Box model = new Box();
		batchService.noregDel(box, model);
	}

	/**
	 * 창고통계 등록 스케쥴러
	 * @throws Exception
	 */
	@Scheduled(cron="${scheduled.cargoStat.insert.cron}")
	public void cargoStatBatch() throws Exception {

		if (this.isProc()) { return; }
		log.debug("*창고통계 등록 스케쥴러 수행 시작 : " + DateUtil.nowYYYYMMDDHH24MIssSSSDash());
		Box box = new Box();
		Box model = new Box();
		box.put("daysAgo", ConfigUtil.getInt("scheduled.cargoStat.insert.days.ago"));

		batchService.cargoStatInsert(box, model);
		log.info("cargoStatInsert complete");
	}

	/**
	 * 차량통계 등록 스케쥴러
	 * @throws Exception
	 */
	@Scheduled(cron="${scheduled.carStat.insert.cron}")
	public void carStatBatch() throws Exception {

		if (this.isProc()) { return; }
		log.debug("*차량통계 등록 스케쥴러 수행 시작 : " + DateUtil.nowYYYYMMDDHH24MIssSSSDash());
		Box box = new Box();
		Box model = new Box();
		box.put("daysAgo", ConfigUtil.getInt("scheduled.carStat.insert.days.ago"));

		batchService.carStatDel(box, model);
		log.info("carStatDel complete");

		batchService.carBaseStatInsert(box, model);
		log.info("carBaseStatInsert complete");

		batchService.carTempStatInsert(box, model);
		log.info("carTempStatInsert complete");

		batchService.carArrStatInsert(box, model);
		log.info("carArrStatInsert complete");

		batchService.carDeliStatInsert(box, model);
		log.info("carDeliStatInsert complete");

		batchService.carDrvStatInsert(box, model);
		log.info("carDrvStatInsert complete");

		batchService.carTotDrvStatInsert(box, model);
		log.info("carTotDrvStatInsert complete");

		batchService.agentCarDrvStatInsert(box, model);
		log.info("agentCarDrvStatInsert complete");
	}

	/**
	 * 포장재출고회수통계 등록
	 * @throws Exception
	 */
	@Scheduled(cron="${scheduled.pkgAnal.insert.cron}")
	public void pkgAnalBatch() throws Exception {

		if (this.isProc()) { return; }
		log.debug("*포장재출고회수통계 등록 스케쥴러 수행 시작 : " + DateUtil.nowYYYYMMDDHH24MIssSSSDash());

		Box box = new Box();
		Box model = new Box();
		batchService.pkgAnalInsert(box, model);
		log.info("pkgAnalInsert complete");
	}

	/**
	 * SAP IF 하차, 회수 수량 전송
	 * @throws Exception
	 */
	@Scheduled(cron="${scheduled.sapIfIoCnt.send.cron}")
	public void sapIfIoCntBatch() throws Exception {

		if (this.isProc()) { return; }
		log.debug("*SAP IF 하차, 회수 수량 전송 스케쥴러 수행 시작 : " + DateUtil.nowYYYYMMDDHH24MIssSSSDash());

		Box box = new Box();
		ModelMap model = new ModelMap();

		crateService.sapIfIoCntBatchSave(box, model);
		log.info("sapIfIoCntBatchSave complete");

		crateService.sapIfSend(box, model);
		log.info("sapIfSend complete");
	}


	/**
	 * 배송완료 처리
	 * @throws Exception
	 */
	@Scheduled(cron="${scheduled.deliy.update.cron}")
	public void deliyBatch() throws Exception {

		if (this.isProc()) { return; }
		log.debug("*배송완료 처리 스케쥴러 수행 시작 : " + DateUtil.nowYYYYMMDDHH24MIssSSSDash());

		Box box = new Box();
		Box model = new Box();

		batchService.deliyUpdate(box, model);
		log.info("deliyUpdate complete");
	}

	/**
	 * 차량운행 - 대용량 엑셀 파일 생성
	 *
	 * @throws Exception
	 */
	@Scheduled(cron="${scheduled.csv.make.car.cron}")
//	@Scheduled(cron="0 10 0 * * MON") //매주 월요일 0시 10분 0초
//	@Scheduled(cron="0 * * * * ?") //매분 0초마다
//	@Scheduled(fixedDelay=3000000, initialDelay = 1000)
	public void carCsvMakeBatch() throws Exception {

		if (this.isProc()) { return; }
		log.debug("*차량운행 - 대용량 엑셀 파일 생성 스케쥴러 수행 시작 : " + DateUtil.nowYYYYMMDDHH24MIssSSSDash());
		Box box = new Box();
		Box model = new Box();
		batchService.carCsvMake(box, model);
	}

	/**
	 * 창고온도 - 대용량 엑셀 파일 생성
	 *
	 * @throws Exception
	 */
	@Scheduled(cron="${scheduled.csv.make.cargo.cron}")
//	@Scheduled(cron="0 10 0 * * MON") //매주 월요일 0시 10분 0초
//	@Scheduled(cron="0 * * * * ?") //매분 0초마다
//	@Scheduled(fixedDelay=3000000, initialDelay = 1000)
	public void cargoCsvMakeBatch() throws Exception {

		if (this.isProc()) { return; }
		log.debug("*창고온도 - 대용량 엑셀 파일 생성 스케쥴러 수행 시작 : " + DateUtil.nowYYYYMMDDHH24MIssSSSDash());
		Box box = new Box();
		Box model = new Box();
		batchService.cargoCsvMake(box, model);
	}


}