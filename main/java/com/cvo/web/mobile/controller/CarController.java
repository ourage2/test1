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
@RequestMapping("mobile/car")
public class CarController {

	protected Logger log = LoggerFactory.getLogger(this.getClass());

	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSessionTemplate dao;

	@Autowired
	private Paginate paginate;

	/**
	 * 차량현위치 조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("nowList")
	public void nowList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
//			int totCnt = dao.selectOne("car.nowCnt", box);
//			paginate.init(box, model, totCnt);
//			model.put("list", dao.selectList("car.nowList", box));
		}
	}

	/**
	 * 차량현위치 PK조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("nowView")
	public void nowView(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			model.put("view", dao.selectOne("car.nowView", box));
		}
	}

	/**
	 * 차량위치경로 조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("pathList")
	public void pathList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
//			int totCnt = dao.selectOne("car.pathCnt", box);
//			paginate.init(box, model, totCnt);
//			model.put("list", dao.selectList("car.pathList", box));
		}
	}

	/**
	 * 차량위치경로 PK조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("pathView")
	public void pathView(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			model.put("view", dao.selectOne("car.pathView", box));
		}
	}

	/**
	 * 실시간차량온도 조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("tempNowList")
	public void tempNowList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
//			int totCnt = dao.selectOne("car.tempNowCnt", box);
//			paginate.init(box, model, totCnt);
			model.put("list", dao.selectList("car.tempNowList", box));
		}
	}

	/**
	 * 차량현재온도 PK조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("tempNowView")
	public void tempNowView(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			model.put("view", dao.selectOne("car.tempNowView", box));
		}
	}

	/**
	 * 온도내역 조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("tempList")
	public void tempList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			model.put("list", dao.selectList("car.tempList", box));
		}
	}

	/**
	 * 대리점 - 차량온도
	 * @param box   
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("agentTempList")
	public void agentTempList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			model.put("list", dao.selectList("car.tempList", box));
		}
	}

	/**
	 * 차량현재온도 조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("deliList")
	public void deliList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
//			int totCnt = dao.selectOne("car.deliCnt", box);
//			paginate.init(box, model, totCnt);
//			model.put("list", dao.selectList("car.deliList", box));
		}
	}

	/**
	 * 차량현재온도 PK조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("deliView")
	public void deliView(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			model.put("view", dao.selectOne("car.deliView", box));
		}
	}
}
