package com.enpem.web.manage.service;


import com.enpem.web.common.data.Box;
import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

@Service
public class CenterService {
	
	protected Logger log = LoggerFactory.getLogger(this.getClass());

	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSessionTemplate dao;

	/**
	 * 차량 대리점 도착 위반 / 온도 이상 사유 저장
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	public void carVioInput(Box box, ModelMap model) throws Exception {
		int result = 0;
		result += dao.update("center.carVioInputUpdate", box);
		model.put("result", result);
	}

	/**
	 * 창고 온도 이상 사유 저장
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	public void cargoVioInput(Box box, ModelMap model) throws Exception {
		int result = 0;
		result += dao.update("center.cargoVioInputUpdate", box);
		model.put("result", result);
	}
}
