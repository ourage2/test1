package com.enpem.web.common.tags;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.TagSupport;

import com.enpem.web.common.util.MsgUtil;
import com.enpem.web.common.util.StringUtil;

public class MsgTag extends TagSupport {

	/**
	 *
	 */
	private static final long serialVersionUID = 1L;
	private String cd;
	private String param;
	private Object[] params;


	public String getCd() {
		return cd;
	}


	public void setCd(String cd) {
		this.cd = cd;
	}


	public String getParam() {
		return param;
	}


	public void setParam(String param) {
		this.param = param;
	}


	public Object[] getParams() {
		return params;
	}


	public void setParams(Object[] params) {
		this.params = params;
	}


	@Override
	public int doStartTag() throws JspException {
		try {
			if(StringUtil.isNotEmpty(cd)) {
				JspWriter out = pageContext.getOut();
				if(StringUtil.isNotEmpty(param)) {
					out.print(MsgUtil.getMsg(cd, new Object[]{param}));
				} else if(params != null) {
					out.print(MsgUtil.getMsg(cd, params));
				} else {
					out.print(MsgUtil.getMsg(cd));
				}
			}
			return SKIP_BODY;
		} catch (Exception e) {
			throw new JspException(e.toString(), e);
		}
	}

}
