package com.enpem.web.mobile.controller;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import com.enpem.web.common.data.Box;
import com.enpem.web.common.util.HttpUtil;
import com.enpem.web.common.util.paginate.Paginate;

@Controller
@RequestMapping("mobile/cargo")
public class CargoController {

	protected Logger log = LoggerFactory.getLogger(this.getClass());

	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSessionTemplate dao;

	@Autowired
	private Paginate paginate;


	/**
	 * 창고현재온도 조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("tempNowList")
	public void tempNowList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
//			int totCnt = dao.selectOne("cargo.tempNowCnt", box);
//			paginate.init(box, model, totCnt);
//			model.put("list", dao.selectList("cargo.tempNowList", box));
		}
	}

	/**
	 * 창고온도내역 조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("tempList")
	public void tempList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			model.put("list", dao.selectList("cargo.tempList", box));
		}
	}
}
