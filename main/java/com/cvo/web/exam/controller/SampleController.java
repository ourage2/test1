package com.enpem.web.exam.controller;

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

import com.enpem.web.common.constants.CmnConst;
import com.enpem.web.common.data.Box;
import com.enpem.web.common.exception.BizException;
import com.enpem.web.common.util.ExcelUtil;
import com.enpem.web.common.util.crypto.DigestUtil;
import com.enpem.web.exam.service.SampleService;

@Controller
@RequestMapping("exam/sample")
public class SampleController {

	protected Logger log = LoggerFactory.getLogger(this.getClass());

	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSessionTemplate dao;

	@Autowired
	private SampleService sampleService;

	/**
	 * 샘플Index
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("index")
	public void index(Box box, ModelMap model) throws Exception {
	}

	/**
	 * 메뉴목록
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("menuList")
	public void menuList(Box box, ModelMap model) throws Exception {

		List<Box> list = new ArrayList<Box>();
		Box rowBox = new Box();
		rowBox.put("grpCd", "A001");
		rowBox.put("cd", "400");
		rowBox.put("cdNm", "찾을수 없습니다");
		rowBox.put("cdDesc", "오류코드");
		rowBox.put("sortNo", 1);
		rowBox.put("useYn", "Y");
		list.add(rowBox);
		rowBox = new Box();
		rowBox.put("grpCd", "A001");
		rowBox.put("cd", "500");
		rowBox.put("cdNm", "시스템 오류입니다");
		rowBox.put("cdDesc", "오류코드");
		rowBox.put("sortNo", 2);
		rowBox.put("useYn", "Y");
		list.add(rowBox);

		model.put("list", list);
		if (ExcelUtil.isExcel()) {
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
			ExcelUtil.setExcelInfo(model, "공통코드목록", columnList, list, "조회일자 : 2018.01.01 ~ 2018.03.31", "총합계 : 100, 목록건수 2");
		}
	}

	/**
	 * 메뉴목록Json
	 * @param box
	 * @param model
	 * @throws Exception
	 */
//	@RequestMapping("menuList.json")
//	public void menuListJson(Box box, ModelMap model) throws Exception {
//		sampleService.menuList(box, model);
//	}

	/**
	 * 메뉴상세
	 * @param box
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("menuDetail.do")
	public String menuDetail(Box box, ModelMap model) throws Exception {
		sampleService.menuDetail(box, model);
		return "nolayout:/exam/sample/menuDetail";
	}

	/**
	 * 메뉴별권한목록
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("authMenuList.do")
	public String authMenuList(Box box, ModelMap model) throws Exception {
		sampleService.authMenuList(box, model);
		return "nolayout:/exam/sample/authMenuList";
	}

	/**
	 * 공통코드/메시지 처리
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("codeMsg.do")
	public void codeMsg(Box box, ModelMap model) throws Exception {
//		log.debug("ONMMSG List : {}", CodeUtil.getCdList("ONMMSG"));
//		log.debug("ONMMSG List : {}", CodeUtil.getCdNm("ONMMSG", "8011"));
//		log.debug("ONMMSG 8000 Msg : {}", MsgUtil.getMsg("8000"));
//		log.debug("ONMMSG 8027 Msg : {}", MsgUtil.getMsg("8027", new Object[]{"이름"}));
	}

	@RequestMapping("codeMsg.json")
	public void codeMsgJson(Box box, ModelMap model) throws Exception {
//		model.put("codeNm", CodeUtil.getCd("ONMMSG", "8000"));
	}


	/**
	 * 업무 오류 처리
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("exceptionTest.do")
	public void exceptionTest(Box box, ModelMap model) throws Exception {
		log.debug("exceptionTest");
		if(true) {
			throw new BizException(CmnConst.RES_CD_BAD_REQUEST);
		}
	}

	@RequestMapping("inputValid.do")
	public void inputValid(Box box, ModelMap model) throws Exception {
	}

	@RequestMapping("popup.do")
	public void popup(Box box, ModelMap model) throws Exception {
	}

//	@RequestMapping("popup1.pop")
//	public String popup1(Box box, ModelMap model) throws Exception {
//		return "nolayout:/exam/sample/popup1";
//	}

	@RequestMapping("popup1")
	public void popup1(Box box, ModelMap model) throws Exception {
	}

//	@RequestMapping("popup2.pop")
//	public String popup2(Box box, ModelMap model) throws Exception {
//		return "nolayout:/exam/sample/popup2";
//	}
	@RequestMapping("popup2")
	public void popup2(Box box, ModelMap model) throws Exception {
	}


	@RequestMapping("headerUser.do")
	public void headerUser(Box box, ModelMap model) throws Exception {
	}

	@RequestMapping("script.do")
	public void script(Box box, ModelMap model) throws Exception {
	}

	@RequestMapping("valid.do")
	public void valid(Box box, ModelMap model) throws Exception {
	}

//	@RequestMapping("validTest1.json")
//	@ReqInfo(validForm="exam.sample.validTest1")
//	public void validTest1(Box box, ModelMap model) throws Exception {
//	}
//
//	@RequestMapping("validTest2.json")
//	@ReqInfo(validForm="exam.sample.validTest2")
//	public void validTest2(Box box, ModelMap model) throws Exception {
//	}
//
//	@RequestMapping("validTest3.json")
//	@ReqInfo(validForm="exam.sample.validTest3")
//	public void validTest3(Box box, ModelMap model) throws Exception {
//	}
//
//	@RequestMapping("validTest4.json")
//	@ReqInfo(validForm="exam.sample.validTest4")
//	public void validTest4(Box box, ModelMap model) throws Exception {
//	}
//
//	@RequestMapping("validTest5.json")
//	@ReqInfo(validForm="exam.sample.validTest5")
//	public void validTest5(Box box, ModelMap model) throws Exception {
//	}

	@RequestMapping("authChk.do")
	public void authChk(Box box, ModelMap model) throws Exception {
	}

	@RequestMapping("excelDown.do")
	public void excelDown(Box box, ModelMap model) throws Exception {
	}

	@RequestMapping("codeExcelDown.xls")
	public void codeExcelDown(Box box, ModelMap model) throws Exception {
		sampleService.codeExcelDown(box, model);
	}

	/*
	@RequestMapping("apiLogExcelDown.xls")
	public void apiLogExcelDown(Box box, ModelMap model) throws Exception {
		sampleService.apiLogExcelDown(box, model);
	}
	*/

	@RequestMapping("wait.do")
	public void wait(Box box, ModelMap model) throws Exception {
		for(int i=0; i<10000; i++) {
			log.debug("i : {}", i);
			Thread.sleep(1000);
		}
	}

	@RequestMapping("sha256")
	public void sha256(Box box, ModelMap model) throws Exception {
		model.put("pwd", box.nvl("pwd"));
		model.put("encPwd", DigestUtil.digestToStr(box.nvl("pwd"), DigestUtil.SHA256));
	}

	@RequestMapping("md5")
	public void md5(Box box, ModelMap model) throws Exception {
		model.put("pwd", box.nvl("pwd"));
		model.put("encPwd", (String)dao.selectOne("exam.sample.md5", box));
		model.put("javaEncPwd", DigestUtil.digestToStr(box.nvl("pwd"), DigestUtil.MD5));
	}


	@RequestMapping("callFn")
	public void callFn(Box box, ModelMap model) throws Exception {
		box.put("pCdNm", "관리자");
		box.put("pGrpCd", "AUTH_CD");
		List<Box> list = dao.selectList("exam.sample.callFn", box);
		log.debug("list: " + list);
	}
}
