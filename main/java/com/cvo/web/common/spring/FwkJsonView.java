package com.enpem.web.common.spring;

import java.io.IOException;
import java.io.OutputStream;
import java.util.LinkedHashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.Assert;
import org.springframework.web.servlet.View;

import com.fasterxml.jackson.core.JsonEncoding;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;

public class FwkJsonView implements View {

	protected Logger log = LoggerFactory.getLogger(this.getClass());
	public static final String JSON_STATUS_KEY  = "responseCode";
	public static final String JSON_MESSAGE_KEY = "responseMessage";

	public static final String DEFAULT_CONTENT_TYPE = "application/json";
	private String contentType = DEFAULT_CONTENT_TYPE;
	private ObjectMapper objectMapper = new ObjectMapper();
	private JsonEncoding encoding = JsonEncoding.UTF8;
	private boolean prefixJson = false;
	private Boolean prettyPrint;

	public FwkJsonView() {
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

		LinkedHashMap<String, Object> outValue = new LinkedHashMap<String,Object>();
		LinkedHashMap<String, Object> modelMap = new LinkedHashMap<String,Object>();
		modelMap.putAll(model);
		if( modelMap.containsKey(JSON_STATUS_KEY) == false || modelMap.containsKey(JSON_MESSAGE_KEY) == false ){
			LinkedHashMap<String,Object> headValue = new LinkedHashMap<String,Object>();
			modelMap.put(JSON_STATUS_KEY, "S00001");
			modelMap.put(JSON_MESSAGE_KEY, "정상");
			headValue.put(JSON_STATUS_KEY, "S00001");
			headValue.put(JSON_MESSAGE_KEY, "정상");
			headValue.put("requestId","");
			headValue.put("clientId","");
			headValue.put("screenId","");
			headValue.put("serviceId","");
			headValue.put("userId","");
			headValue.put("requestDate","");
			headValue.put("requestTime","");
			headValue.put("additionalMessage","");
			outValue.put("header", headValue);
		} else {
			LinkedHashMap<String,Object> headValue = new LinkedHashMap<String,Object>();
			headValue.put(JSON_STATUS_KEY, modelMap.get(JSON_STATUS_KEY));
			headValue.put(JSON_MESSAGE_KEY, modelMap.get(JSON_MESSAGE_KEY));
			headValue.put("requestId","");
			headValue.put("clientId","");
			headValue.put("screenId","");
			headValue.put("serviceId","");
			headValue.put("userId","");
			headValue.put("requestDate","");
			headValue.put("requestTime","");
			headValue.put("additionalMessage","");
			outValue.put("header", headValue);
		}
		outValue.put("payload", modelMap);

		writeContent(response.getOutputStream(), outValue, this.prefixJson);
	}

	protected void writeContent(OutputStream stream, Object value, boolean prefixJson) throws IOException {
		JsonGenerator generator = this.objectMapper.getFactory().createGenerator(stream, this.encoding);

		this.objectMapper.configure(SerializationFeature.WRITE_NULL_MAP_VALUES, false);
		this.objectMapper.enable(SerializationFeature.WRITE_NULL_MAP_VALUES); //null도 함께 보낸다
//		this.objectMapper.disable(SerializationFeature.WRITE_NULL_MAP_VALUES); //null은 제외하여 보낸다

		if (this.objectMapper.isEnabled(SerializationFeature.INDENT_OUTPUT)) {
			generator.useDefaultPrettyPrinter();
		}

		if (prefixJson) {
			generator.writeRaw("{} && ");
		}
		this.objectMapper.writeValue(generator, value);
	}


}
