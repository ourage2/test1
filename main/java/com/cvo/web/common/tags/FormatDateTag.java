package com.enpem.web.common.tags;

import java.util.Date;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.TagSupport;

import com.enpem.web.common.util.FormatUtil;
import com.enpem.web.common.util.StringUtil;

public class FormatDateTag extends TagSupport {

	private static final long serialVersionUID = 1L;
	private Object value = null;
	private String pattern = null;
	private String parsePattern = null;


	public Object getValue() {
		return value;
	}


	public void setValue(Object value) {
		this.value = value;
	}


	public String getPattern() {
		return pattern;
	}


	public void setPattern(String pattern) {
		this.pattern = pattern;
	}


	public String getParsePattern() {
		return parsePattern;
	}


	public void setParsePattern(String parsePattern) {
		this.parsePattern = parsePattern;
	}


	@Override
	public int doStartTag() throws JspException {
		try {
			if (value != null) {
				Date date = null;
				if (value instanceof Date) {
					date = (Date)value;
				} else {
					String dateStr = StringUtil.trim(value.toString());
					if (StringUtil.isNotEmpty(dateStr)) {
						if(StringUtil.isEmpty(parsePattern)) {
							if (dateStr.indexOf(FormatUtil.DEFAULT_EXPRESSION_DATE_PATTERN_DELIM_CHAR) > -1) {
								date = FormatUtil.parseDate(dateStr, FormatUtil.DEFAULT_EXPRESSION_DATE_PATTERN);
							} else {
								date = FormatUtil.parseDate(dateStr);
							}
						} else {
							date = FormatUtil.parseDate(dateStr, parsePattern);
						}
					}
				}
				if (date != null) {
					JspWriter out = pageContext.getOut();
					if (StringUtil.isEmpty(pattern)) {
						out.print(FormatUtil.formatDate(date, FormatUtil.DEFAULT_EXPRESSION_DATE_PATTERN));
					} else {
						out.print(FormatUtil.formatDate(date, pattern));
					}
				}
			}
			return SKIP_BODY;
		} catch (Exception e) {
			throw new JspException(e.toString(), e);
		}
	}

}
