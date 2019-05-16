package com.enpem.web.common.tags;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.BodyTagSupport;

import com.enpem.web.common.data.Box;
import com.enpem.web.common.util.StringUtil;

public class AuthFuncTag extends BodyTagSupport {

	private static final long serialVersionUID = 1L;
	private String funcId;


	public String getFuncId() {
		return funcId;
	}


	public void setFuncId(String funcId) {
		this.funcId = funcId;
	}


	@Override
	public int doStartTag() throws JspException {
		try {
			if(StringUtil.isEmpty(funcId)) {
				return SKIP_BODY;
			}
			HttpServletRequest request = (HttpServletRequest)pageContext.getRequest();
//			Box funcMenuBox = SessionUtil.getFuncMenuBox(request.getSession()); //session에서 menu가져오기
//			if(funcMenuBox == null) {
//				return SKIP_BODY;
//			}
//			if(!funcMenuBox.containsKey(funcId)) {
//				return SKIP_BODY;
//			}
			return EVAL_BODY_INCLUDE;
		} catch (Exception e) {
			throw new JspException(e.toString(), e);
		}
	}

}
