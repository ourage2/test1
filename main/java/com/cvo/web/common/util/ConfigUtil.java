package com.enpem.web.common.util;

import java.util.Properties;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service
public class ConfigUtil {

	protected Logger log = LoggerFactory.getLogger(this.getClass());
	private static Properties config;

	/**
	 * Sets the config.
	 *
	 * @param config the new config
	 */
	@Resource(name="config")
	private void setConfig(Properties config) {
		ConfigUtil.config = config;
	}

	/**
	 * Gets the string.
	 *
	 * @param key the key
	 * @return the string
	 */
	public static String getString(String key) {
		return config.getProperty(key);
	}

	/**
	 * Gets the int.
	 *
	 * @param key the key
	 * @return the int
	 */
	public static int getInt(String key) {
		if(StringUtil.isEmpty(config.getProperty(key))) {
			return 0;
		}
		return Integer.parseInt(config.getProperty(key));
	}

//	public static void setString(String key, String value) throws Exception {
//		ClassLoader cl;
//		cl = Thread.currentThread().getContextClassLoader();
//		if (cl == null) {
//			cl = ClassLoader.getSystemClassLoader();
//		}
//		URL url = cl.getResource("config/properties/config.xml");
//		log.debug("url:"+url.getPath());
//
//		config.loadFromXML(new FileInputStream(url.getPath()));
//       	config.setProperty(key, value);
//		config.storeToXML(new FileOutputStream(url.getPath()), null);
//	}

}
