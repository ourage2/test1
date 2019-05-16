package com.enpem.web.manage.controller;

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
@RequestMapping("manage/dash")
public class DashController {

	protected Logger log = LoggerFactory.getLogger(this.getClass());

	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSessionTemplate dao;

	@Autowired
	private Paginate paginate;

	/**
	 * 센터 조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("centerList")
	public void centerList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			model.put("centerCntRt", dao.selectOne("dash.dashCenterCntRt", box));
			
			model.put("dayCarTempList", dao.selectList("dash.dayCarTempList", box));
			model.put("dayCenterTempList", dao.selectList("dash.dayCenterTempList", box));
			
			model.put("cargoTempList", dao.selectList("dash.cargoTempList", box));
			
			model.put("centerCarTempList", dao.selectList("dash.centerCarTempList", box));
			model.put("centerCargoTempList", dao.selectList("dash.centerCargoTempList", box));
			
			model.put("deliTranList", dao.selectList("dash.deliTranList", box));
			
			model.put("arrNorRtList", dao.selectList("dash.arrNorRtList", box));
		}
	}

	/**
	 * 차트 팝업
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("chartView")
	public void chartView(Box box, ModelMap model) throws Exception {
	}
}
