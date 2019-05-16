package com.enpem.web.mobile.service;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import com.enpem.web.common.data.Box;

@Service
public class MSetService {

	protected Logger log = LoggerFactory.getLogger(this.getClass());

	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSessionTemplate dao;


	/**
	 * 공지사항 저장
	 *
	 * @param paramMap
	 * @param modelMap
	 * @throws Exception
	 */
//	public void noticeSave(Box box, ModelMap model) throws Exception {
//
//		int result = 0;
//		if ("C".equals(box.nvl("OP_FLAG"))) {
//			result += dao.insert("mset.noticeInsert", box);
//		} else if ("U".equals(box.nvl("OP_FLAG"))) {
//			result += dao.update("mset.noticeUpdate", box);
//		} else if ("D".equals(box.nvl("OP_FLAG"))) {
//			result += dao.delete("mset.noticeDelete", box);
//		}
//		model.put("result", result);
//	}

	/**
	 * 패스워드 저장
	 *
	 * @param paramMap
	 * @param modelMap
	 * @throws Exception
	 */
	public void pwdSave(Box box, ModelMap model) throws Exception {

		int result = dao.update("mset.pwdUpdate", box);
		model.put("result", result);
	}


}
