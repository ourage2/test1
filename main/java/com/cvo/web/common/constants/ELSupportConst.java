package com.enpem.web.common.constants;

import javax.servlet.ServletContext;

import org.springframework.beans.factory.InitializingBean;
import org.springframework.stereotype.Component;
import org.springframework.web.context.ServletContextAware;

@Component
public class ELSupportConst implements ServletContextAware, InitializingBean {

	private ServletContext servletContext;

	public void setServletContext(ServletContext servletContext) {
		this.servletContext = servletContext;
	}

	public void afterPropertiesSet() throws Exception {
		servletContext.setAttribute("cmnConst", new CommConstMap());
	}
}
