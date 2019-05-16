package com.enpem.web.common.mybatis;

import java.util.Map;

import org.apache.ibatis.reflection.MetaObject;
import org.apache.ibatis.reflection.wrapper.MapWrapper;

import com.enpem.web.common.util.StringUtil;

public class CamelKeyMapWrapper extends MapWrapper {

	/**
	 * Instantiates a new camel key map wrapper.
	 *
	 * @param metaObject the meta object
	 * @param map the map
	 */
	public CamelKeyMapWrapper(MetaObject metaObject, Map<String, Object> map) {
		super(metaObject,map);
	}

	/* (non-Javadoc)
	 * @see org.apache.ibatis.reflection.wrapper.MapWrapper#findProperty(java.lang.String, boolean)
	 */
	public String findProperty(String name, boolean useCamelCaseMapping) {
		return StringUtil.camelToLower(name);
	}

}
