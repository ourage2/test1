package com.enpem.web.common.spring;

import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.Assert;
import org.springframework.web.servlet.View;

import com.enpem.web.common.constants.ApiConst;
import com.enpem.web.common.constants.CmnConst;

public class ApiCsvView implements View {

	protected Logger log = LoggerFactory.getLogger(this.getClass());

	public static final String DEFAULT_CONTENT_TYPE = "text/plain";
	public static final String CSV_KEY = "_csv";


	private String contentType = DEFAULT_CONTENT_TYPE;
	private String encoding = CmnConst.DEFAULT_CHARSET;


	public ApiCsvView() {
		setContentType(DEFAULT_CONTENT_TYPE);
	}

	public void setContentType(String contentType) {
		this.contentType = contentType;
	}

	public String getContentType() {
		return this.contentType;
	}

	public void setEncoding(String encoding) {
		Assert.notNull(encoding, "'encoding' must not be null");
		this.encoding = encoding;
	}


	public void render(Map<String, ?> model, HttpServletRequest request,HttpServletResponse response) throws Exception {
		PrintWriter out = null;
		try {
			response.setContentType(getContentType());
			response.setCharacterEncoding(this.encoding);
			response.addHeader("Pragma", "no-cache");
			response.addHeader("Cache-Control", "no-cache, no-store, max-age=0");
			response.addDateHeader("Expires", 1L);

			String output = null;
			if(model.containsKey(ApiConst.ERROR_CODE_KEY.getCode()) || model.containsKey(ApiConst.ERROR_MESSAGE_KEY.getCode())) {
				Map<String, Object> errorMap = new HashMap<String, Object>();
				errorMap.put(ApiConst.ERROR_CODE_KEY.getCode(), model.get(ApiConst.ERROR_CODE_KEY.getCode()));
				errorMap.put(ApiConst.ERROR_MESSAGE_KEY.getCode(), model.get(ApiConst.ERROR_MESSAGE_KEY.getCode()));

				output = new StringBuffer()
				.append(ApiConst.ERROR_CODE_KEY.getCode()).append(",")
				.append(model.get(ApiConst.ERROR_CODE_KEY.getCode())).append(",")
				.append(ApiConst.ERROR_MESSAGE_KEY.getCode()).append(",")
				.append(model.get(ApiConst.ERROR_MESSAGE_KEY.getCode())).toString();
			} else {
				output = (String)model.get(CSV_KEY);
			}
			out = response.getWriter();
			out.print(output);

			out.flush();
		} finally {
			if(out != null) {
				out.close();
			}
		}
	}

}
