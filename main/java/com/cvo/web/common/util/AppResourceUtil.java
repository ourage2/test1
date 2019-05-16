package com.enpem.web.common.util;

import org.springframework.core.io.Resource;

public class AppResourceUtil {

	/**
	 *
	 * @param resourceLocation the resource location
	 * @return the config resource
	 */
	public static Resource getConfigResource(String resourcePath) {
		String configPath = System.getProperty("enpem.config.path");
		StringBuffer resourceLocation = new StringBuffer();
		if(StringUtil.isEmpty(configPath)) {
			resourceLocation.append("classpath:/config");
		} else {
			resourceLocation.append(configPath);
		}
		resourceLocation.append(resourcePath);
		return ResourceUtil.getResource(resourceLocation.toString());
	}
}
