package com.enpem.web.common.util;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.enpem.web.common.biz.CenterLocator;
import com.enpem.web.common.data.Box;

@Component
public class CenterUtil {

	private static CenterLocator centerLocator;

	@Autowired(required=true)
	private CenterUtil(CenterLocator centerLocator) {
		CenterUtil.centerLocator = centerLocator;
	}

	public static Box getBox(String cd) {
		if(StringUtil.isEmpty(cd)) {
			return null;
		}
		return centerLocator.getBox(cd);
	}

	public static String getNm(String cd) {
		Box rowBox = getBox(cd);
		String nm = null;
		if(rowBox != null) {
			nm = rowBox.nvl("nm");
		}
		return nm;
	}

}
