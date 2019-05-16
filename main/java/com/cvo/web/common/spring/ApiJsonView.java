package com.enpem.web.common.spring;

import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.Assert;
import org.springframework.validation.BindingResult;
import org.springframework.web.servlet.View;

import com.enpem.web.common.util.ConfigUtil;
import com.enpem.web.common.util.HttpUtil;
import com.fasterxml.jackson.core.JsonEncoding;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;

public class ApiJsonView implements View {

	protected Logger log = LoggerFactory.getLogger(this.getClass());

	public static final String DEFAULT_CONTENT_TYPE = "application/json";
	private String contentType = DEFAULT_CONTENT_TYPE;
	private ObjectMapper objectMapper = new ObjectMapper();
	private JsonEncoding encoding = JsonEncoding.UTF8;
	private boolean prefixJson = false;
	private Boolean prettyPrint;

	public ApiJsonView() {
		setContentType(DEFAULT_CONTENT_TYPE);
	}

	public void setContentType(String contentType) {
		this.contentType = contentType;
	}

	public String getContentType() {
		return this.contentType;
	}

	public void setObjectMapper(ObjectMapper objectMapper) {
		Assert.notNull(objectMapper, "'objectMapper' must not be null");
		this.objectMapper = objectMapper;
		configurePrettyPrint();
	}

	public void setEncoding(JsonEncoding encoding) {
		Assert.notNull(encoding, "'encoding' must not be null");
		this.encoding = encoding;
	}

	public void setPrefixJson(boolean prefixJson) {
		this.prefixJson = prefixJson;
	}

	public void setPrettyPrint(boolean prettyPrint) {
		this.prettyPrint = prettyPrint;
		configurePrettyPrint();
	}

	private void configurePrettyPrint() {
		if (this.prettyPrint != null) {
			this.objectMapper.configure(SerializationFeature.INDENT_OUTPUT, this.prettyPrint);
		}
	}

	public void render(Map<String, ?> model, HttpServletRequest request,HttpServletResponse response) throws Exception {
		response.setContentType(getContentType());
		response.setCharacterEncoding(this.encoding.getJavaName());
		response.addHeader("Pragma", "no-cache");
		response.addHeader("Cache-Control", "no-cache, no-store, max-age=0");
		response.addDateHeader("Expires", 1L);

//		LinkedHashMap<String,Object> outValue = new LinkedHashMap<String,Object>();
//		if(model.containsKey(ApiConst.ERROR_CODE_KEY.getCode()) || model.containsKey(ApiConst.ERROR_MESSAGE_KEY.getCode())) {
//			Map<String, Object> errorMap = new HashMap<String, Object>();
//			errorMap.put(ApiConst.ERROR_CODE_KEY.getCode(), model.get(ApiConst.ERROR_CODE_KEY.getCode()));
//			errorMap.put(ApiConst.ERROR_MESSAGE_KEY.getCode(), model.get(ApiConst.ERROR_MESSAGE_KEY.getCode()));
//			outValue.put(ApiConst.ERROR_KEY.getCode(), errorMap);
//			writeContent(response.getOutputStream(), outValue, this.prefixJson);
//			return;
//		}
//		outValue.putAll(model);
//		writeContent(response.getOutputStream(), outValue, this.prefixJson);

		Iterator<String> keys = model.keySet().iterator();
		String key = null;
		while(keys.hasNext()) {
			key = keys.next();
			if(key.startsWith(BindingResult.MODEL_KEY_PREFIX)) {
				model.remove(key);
			}
		}
		if (ConfigUtil.getString("log.except.url").indexOf(HttpUtil.getRequestUri(request)) <= -1) {
			String[] listNm = ConfigUtil.getString("log.list.nm").split("\\,");
			boolean isLog = true;
			for (String nm : listNm) {
				if (model.containsKey(nm)) {
					if (model.get(nm) instanceof List<?>) {
						List<?> list = (ArrayList)model.get(nm);
						if (list.size() > ConfigUtil.getInt("log.max.cnt")) {
							isLog = false;
						}
					}
				}
			}
			if (isLog) {
				log.debug("Result JSON : {}", model);
			}
		}
		writeContent(response.getOutputStream(), model, this.prefixJson);

	}

	protected void writeContent(OutputStream stream, Object value, boolean prefixJson) throws IOException {
		JsonGenerator generator = this.objectMapper.getFactory().createGenerator(stream, this.encoding);

		if (this.objectMapper.isEnabled(SerializationFeature.INDENT_OUTPUT)) {
			generator.useDefaultPrettyPrinter();
		}

		if (prefixJson) {
			generator.writeRaw("{} && ");
		}
		this.objectMapper.writeValue(generator, value);
	}



}
