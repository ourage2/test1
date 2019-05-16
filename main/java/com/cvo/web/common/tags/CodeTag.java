package com.enpem.web.common.tags;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.TagSupport;

import com.enpem.web.common.util.CdUtil;
import com.enpem.web.common.util.StringUtil;

public class CodeTag extends TagSupport {

	private static final long serialVersionUID = 1L;
	private String grpCd;
	private String cd;


	public String getGrpCd() {
		return grpCd;
	}


	public void setGrpCd(String grpCd) {
		this.grpCd = grpCd;
	}


	public String getCd() {
		return cd;
	}


	public void setCd(String cd) {
		this.cd = cd;
	}


	@Override
	public int doStartTag() throws JspException {
		try {
			if(StringUtil.isNotEmpty(grpCd) || StringUtil.isNotEmpty(cd)) {
				JspWriter out = pageContext.getOut();
				out.print(CdUtil.getCdNm(grpCd, cd));
			}
			return SKIP_BODY;
		} catch (Exception e) {
			throw new JspException(e.toString(), e);
		}
	}

}
