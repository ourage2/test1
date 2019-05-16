package com.enpem.web.common.util;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.enpem.web.common.biz.CdLocator;
import com.enpem.web.common.data.Box;

@Component
public class CdUtil {

	private static CdLocator cdLocator;

	@Autowired(required=true)
	private CdUtil(CdLocator cdLocator) {
		CdUtil.cdLocator = cdLocator;
	}

	public static List<Box> getCdList(String grpCd) {
		if(StringUtil.isEmpty(grpCd)) {
			return null;
		}
		return cdLocator.getCdList(grpCd);
	}

	public static Box getCd(String grpCd, String cd) {
		if(StringUtil.isEmpty(grpCd)) {
			return null;
		}
		if(StringUtil.isEmpty(cd)) {
			return null;
		}
		return cdLocator.getCdBox(grpCd, cd);
	}

//	public static Box getCdBox(String grpCd, String cd) {
//		return (Box)MapUtil.toBox(getCd(grpCd, cd));
//		return JsonUtil.convertValue(getCd(grpCd, cd), Box.class);
//	}

	public static String getGrpNm(String grpCd) {
		List<Box> cdList = getCdList(grpCd);
		String cdValue = null;
		if(cdList != null) {
			cdValue = cdList.get(0).nvl("grpNm");
		}
		return cdValue;
	}

	public static String getCdNm(String grpCd, String cd) {
		Box cdBox = getCd(grpCd, cd);
		String cdValue = null;
		if(cdBox != null) {
			cdValue = cdBox.nvl("cdNm");
		}
		return cdValue;
	}

	public static String getCdEtc1(String grpCd, String cd) {
		Box cdBox = getCd(grpCd, cd);
		String cdValue = null;
		if(cdBox != null) {
			cdValue = cdBox.nvl("etc1");
		}
		return cdValue;
	}

	public static String getCdEtc2(String grpCd, String cd) {
		Box cdBox = getCd(grpCd, cd);
		String cdValue = null;
		if(cdBox != null) {
			cdValue = cdBox.nvl("etc3");
		}
		return cdValue;
	}

	public static String getCdEtc3(String grpCd, String cd) {
		Box cdBox = getCd(grpCd, cd);
		String cdValue = null;
		if(cdBox != null) {
			cdValue = cdBox.nvl("etc3");
		}
		return cdValue;
	}
	public static String[] getCdEtcAry(String grpCd, String cd) {
		Box cdBox = getCd(grpCd, cd);
		String[] cdValue = new String[3];
		if(cdBox != null) {
			cdValue[0] = cdBox.nvl("etc1");
			cdValue[1] = cdBox.nvl("etc2");
			cdValue[2] = cdBox.nvl("etc3");
		}
		return cdValue;
	}
}
