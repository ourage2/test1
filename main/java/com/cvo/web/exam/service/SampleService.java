package com.enpem.web.exam.service;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import com.enpem.web.common.data.Box;
import com.enpem.web.common.util.ExcelUtil;
import com.enpem.web.common.util.JsonUtil;
import com.enpem.web.common.util.paginate.Paginate;

@Service
public class SampleService {

	protected Logger log = LoggerFactory.getLogger(this.getClass());

	@Autowired
	private Paginate paginate;

	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSession sqlSession;

	public void menuList(Box box, ModelMap model) throws Exception {
		box.put("sortColumn", "MENU_ORD");
		box.put("sortOrder", "ASC");

		int totCnt = (Integer)sqlSession.selectOne("exam.sample.menuListCnt", box);
		paginate.init(box, totCnt);
		model.addAttribute("list", sqlSession.selectList("exam.sample.menuList", box));
	}

	public void menuDetail(Box box, ModelMap model) throws Exception {
		model.addAttribute("menuDetail", sqlSession.selectOne("exam.sample.menuDetail", box));
	}

	public void authMenuList(Box box, ModelMap model) throws Exception {
		box.put("sortColumn", "MENU_ID");
		box.put("sortOrder", "ASC");

		model.addAttribute("authMenuList", JsonUtil.toJson(sqlSession.selectList("exam.sample.authMenuList", box)));
	}

	public void codeExcelDown(Box box, ModelMap model) throws Exception {
		List<?> list = sqlSession.selectList("exam.sample.codeAllList");
		List<String[]> columnList = new ArrayList<String[]>();
		columnList.add(new String[]{"grpCd", "그룹코드"});
		columnList.add(new String[]{"cd", "코드"});
		columnList.add(new String[]{"cdNm", "코드명"});
		columnList.add(new String[]{"cdDesc", "코드상세"});
		columnList.add(new String[]{"sortNo", "정렬순서"});
		columnList.add(new String[]{"useYn", "사용여부"});
		columnList.add(new String[]{"value1", "임시컬럼1"});
		columnList.add(new String[]{"value2", "임시컬럼2"});
		columnList.add(new String[]{"value3", "임시컬럼3"});
		columnList.add(new String[]{"sysRegId", "등록자ID"});
		columnList.add(new String[]{"sysRegDtm", "등록일시"});
		columnList.add(new String[]{"sysUpdId", "수정자ID"});
		columnList.add(new String[]{"sysUpdDtm", "수정일시"});
		ExcelUtil.setExcelInfo(model, "공통코드목록", columnList, list, "조회일자 : 2015.01.01 ~ 2015.03.31", "총합계 : 1000, 구매건수 200");
		// ExcelUtil.setExcelInfo(model, "공통코드목록", columnList, list);
	}

	public void apiLogExcelDown(Box box, ModelMap model) throws Exception {
		List<?> list = sqlSession.selectList("exam.sample.apiLogList");
		List<String[]> columnList = new ArrayList<String[]>();
		columnList.add(new String[]{"apiLogNo", "API로그일련번호"});
		columnList.add(new String[]{"parentApiLogNo", "상위로그일련번호"});
		columnList.add(new String[]{"marketId", "마켓ID"});
		columnList.add(new String[]{"transId", "트랜잭션ID"});
		columnList.add(new String[]{"version", "버전"});
		columnList.add(new String[]{"ioType", "IO구분"});
		columnList.add(new String[]{"callApiNm", "호출API명"});
		columnList.add(new String[]{"callUrl", "호출URL"});
		columnList.add(new String[]{"reqSystem", "요청시스템"});
		columnList.add(new String[]{"reqServer", "요청서버"});
		columnList.add(new String[]{"reqParam", "요청파라미터"});
		columnList.add(new String[]{"reqHeader", "요청헤더정보"});
		columnList.add(new String[]{"reqData", "요청본문정보"});
		columnList.add(new String[]{"reqIp", "요청IP"});
		columnList.add(new String[]{"reqDate", "요청일시"});
		columnList.add(new String[]{"resSystem", "응답시스템"});
		columnList.add(new String[]{"resServer", "응답서버"});
		columnList.add(new String[]{"resHeader", "응답헤더정보"});
		columnList.add(new String[]{"resData", "응답본문정보"});
		columnList.add(new String[]{"resCd", "응답코드"});
		columnList.add(new String[]{"resMsg", "응답메시지"});
		columnList.add(new String[]{"resDate", "응답일시"});
		columnList.add(new String[]{"elapseTime", "경과시간"});
		columnList.add(new String[]{"succYn", "성공여부"});
		columnList.add(new String[]{"errorDetail", "오류상세정보"});
		columnList.add(new String[]{"commercialYn", "상용여부"});
		columnList.add(new String[]{"asyncYn", "비동기여부"});
		ExcelUtil.setExcelInfo(model, "API로그목록", columnList, list);
	}

}
