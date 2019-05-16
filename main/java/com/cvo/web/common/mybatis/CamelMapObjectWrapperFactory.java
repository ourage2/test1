package com.enpem.web.common.mybatis;

import java.util.Map;

import org.apache.ibatis.reflection.MetaObject;
import org.apache.ibatis.reflection.wrapper.ObjectWrapper;
import org.apache.ibatis.reflection.wrapper.ObjectWrapperFactory;

import com.enpem.web.common.data.Box;


public class CamelMapObjectWrapperFactory implements ObjectWrapperFactory {

	/* (non-Javadoc)
	 * @see org.apache.ibatis.reflection.wrapper.ObjectWrapperFactory#hasWrapperFor(java.lang.Object)
	 */
	public boolean hasWrapperFor(Object object) {
		if(object instanceof Box) {
			return true;
		}
		return false;
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	public ObjectWrapper getWrapperFor(MetaObject metaObject, Object object) {
		return new CamelKeyMapWrapper(metaObject,(Map)object);
	}
}
