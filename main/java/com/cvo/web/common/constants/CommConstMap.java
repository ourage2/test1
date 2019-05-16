package com.enpem.web.common.constants;

import java.lang.reflect.Field;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.enpem.web.common.data.Box;
import com.enpem.web.common.util.StringUtil;

@SuppressWarnings("serial")
public class CommConstMap extends Box {

	private static final Logger log = LoggerFactory.getLogger(CommConstMap.class);
	private static Map<String, Object> reflectedConstants;
	public static final CommConstMap commConstants = new CommConstMap();

	static {
		reflectedConstants = new Box();
		Field[] fields = CmnConst.class.getFields();
		int i=0, s=fields.length;
		try {
			for(; i<s; i++) {
				reflectedConstants.put(StringUtil.camelToLower(fields[i].getName()), fields[i].get(null));
			}
		} catch (IllegalAccessException ex) {
			log.error("Exception accessing field : " + fields[i].getName());
		}
	}

	public Object get(Object key) {
		Object value = reflectedConstants.get(key);
		if (value == null) {
			throw new IllegalArgumentException("[" + key + "] " + "No such constant defined in class Constants");
		}
		return value;
	}
}
