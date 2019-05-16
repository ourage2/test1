package com.enpem.web.common.biz;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.enpem.web.common.exception.BizException;
import com.enpem.web.common.exception.ResourceNotFoundException;
import com.enpem.web.common.util.SpringUtil;

@Controller
@RequestMapping("common")
public class ErrorController {

	protected Logger log = LoggerFactory.getLogger(this.getClass());

	@RequestMapping("error/uncaughtException.do")
	public void uncaughtException(HttpServletRequest request) throws Exception {
		Throwable throwable = (Throwable) request.getAttribute("javax.servlet.error.exception");
//		log.debug("throwable: " + throwable);
//		throw new BizException(CmnConst.RES_CODE_SERVER_ERROR);
		throw new BizException(throwable);
	}

	@RequestMapping("error/resourceNotFound.do")
	public void resourceNotFound(HttpServletRequest request) throws Exception {
		log.debug("==== [404 Not Found] Original URL : " + SpringUtil.getOriginatingRequestURL());
		throw new ResourceNotFoundException();
	}

//	@RequestMapping("error")
//	public void error(HttpServletRequest request) throws Exception {
//	}
//
//	@RequestMapping("error404")
//	public void error404(HttpServletRequest request) throws Exception {
//	}
}
