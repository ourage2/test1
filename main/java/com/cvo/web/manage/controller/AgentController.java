package com.enpem.web.manage.controller;

import com.enpem.web.common.biz.BizUtil;
import com.enpem.web.common.util.HttpUtil;
import com.enpem.web.common.util.SpringUtil;
import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import com.enpem.web.common.data.Box;
import com.enpem.web.common.util.paginate.Paginate;
import com.enpem.web.manage.service.AgentService;

@Controller
@RequestMapping("manage/agent")
public class AgentController {

	protected Logger log = LoggerFactory.getLogger(this.getClass());

	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSessionTemplate dao;

	@Autowired
	private Paginate paginate;

	@Autowired
	private AgentService agentService;

	/**
	 * 대리점실시간차량 조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("agentNowCarList")
	public void agentNowCarList(Box box, ModelMap model) throws Exception {
	}

	/**
	 * 대리점창고모니터링 조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("agentNowCargoList")
	public void agentNowCargoList(Box box, ModelMap model) throws Exception {
	}

	/**
	 * 대리점차량온도현황 조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("agentCarTempList")
	public void agentCarTempList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			model.put("list", dao.selectList("agent.agentCarTempList", box));
		}
	}

	/**
	 * 대리점차량 온도현황 - 온도 준수율 상세
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("agentCarTempDtlList")
	public void agentCarTempDtlList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			model.put("list", dao.selectList("agent.agentCarTempDtlList", box));
		}
	}

	/**
	 * 대리점창고온도현황 조회
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("agentCargoTempList")
	public void agentCargoTempList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			int totCnt = dao.selectOne("agent.agentCargoTempCnt", box);
			paginate.init(box, model, totCnt);
			model.put("list", dao.selectList("agent.agentCargoTempList", box));
			BizUtil.excelDown(box, model, SpringUtil.getLookupPathForRequest());
		}
	}

	/**
	 * 대리점창고온도현황 세부내역 조회
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("agentCargoTempDtlList")
	public void agentCargoTempDtlList(Box box, ModelMap model) throws Exception {
		if (HttpUtil.isDataExtension()) {
			model.put("list", dao.selectList("agent.agentCargoTempDtlList", box));
		}
	}
}
