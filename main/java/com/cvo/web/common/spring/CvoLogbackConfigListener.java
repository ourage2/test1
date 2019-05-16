package com.enpem.web.common.spring;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;

import ch.qos.logback.ext.spring.web.LogbackConfigListener;
import ch.qos.logback.ext.spring.web.WebLogbackConfigurer;

import com.enpem.web.common.util.StringUtil;

/**
 * The listener interface for receiving etsLogbackConfig events.
 * The class that is interested in processing a etsLogbackConfig
 * event implements this interface, and the object created
 * with that class is registered with a component using the
 * component's <code>addEtsLogbackConfigListener<code> method. When
 * the etsLogbackConfig event occurs, that object's appropriate
 * method is invoked.
 *
 * @see EtsLogbackConfigEvent
 */
public class enpemLogbackConfigListener extends LogbackConfigListener {

	/* (비Javadoc)
	 * @see ch.qos.logback.ext.spring.web.LogbackConfigListener#contextInitialized(javax.servlet.ServletContextEvent)
	 */
	/* (non-Javadoc)
	 * @see ch.qos.logback.ext.spring.web.LogbackConfigListener#contextInitialized(javax.servlet.ServletContextEvent)
	 */
	public void contextInitialized(ServletContextEvent paramServletContextEvent) {
		ServletContext paramServletContext = paramServletContextEvent.getServletContext();
		/*
		RuntimeMXBean bean = ManagementFactory.getRuntimeMXBean();
		List<String> argList = bean.getInputArguments();
		String logbackFile = null;
		for(int i=0, s=argList.size(); i<s; i++) {
			if(argList.get(i).startsWith("-Dlogback.file=")) {
				logbackFile = argList.get(i);
			}
		}
		*/
//		GenericXmlApplicationContext springContext = new GenericXmlApplicationContext();
//		System.out.println(">>>>>>>>:" + springContext.getEnvironment().getDefaultProfiles().length);
//		System.out.println(">>>>>>>>:" + springContext.getEnvironment().getDefaultProfiles()[0]);
//		System.out.println(">>>>>>>>:" + springContext.getEnvironment().getActiveProfiles().length);
//		System.out.println(">>>>>>>>:" + springContext.getEnvironment().getActiveProfiles()[0]);
//		System.out.println(">>>>>>>>:" + springContext.getEnvironment().getProperty("spring.profiles.active"));
//		System.out.println(">>>>>>>>:" + System.getProperty("spring.profiles.active"));

		String configPath = System.getProperty("admin.config.path");
		String logbackFile = null;
		if(StringUtil.isEmpty(configPath)) {
			logbackFile = "classpath:log/logback.xml";
		} else {
			logbackFile = configPath + "/log/logback.xml";
		}
		if(!logbackFile.startsWith("classpath:")) {
			logbackFile = new StringBuffer("file:").append(logbackFile).toString();
		}
		paramServletContext.setInitParameter("logbackConfigLocation", logbackFile);
		WebLogbackConfigurer.initLogging(paramServletContext);
	}

}
