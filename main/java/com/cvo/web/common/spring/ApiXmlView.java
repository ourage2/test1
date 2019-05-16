
package com.enpem.web.common.spring;

import java.io.PrintWriter;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSON;
import net.sf.json.JSONSerializer;
import net.sf.json.JsonConfig;
import net.sf.json.util.CycleDetectionStrategy;
import net.sf.json.xml.XMLSerializer;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.Assert;
import org.springframework.web.servlet.View;

import com.enpem.web.common.constants.CmnConst;
import com.enpem.web.common.data.Box;

public class ApiXmlView implements View {

	private static final Logger log = LoggerFactory.getLogger(ApiXmlView.class);

	public static final String DEFAULT_CONTENT_TYPE = "application/xml";
	public static final String XML_KEY = "_xml";
	public static final String XML_ROOT_KEY = "_xml_root";
	public static final String XML_ELEMENT_KEY = "_xml_element";


	private String contentType = DEFAULT_CONTENT_TYPE;
	private String encoding = CmnConst.DEFAULT_CHARSET;
	private XMLSerializer xmlSerializer;


	public ApiXmlView() {
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

	public void setXmlSerializer(XMLSerializer xmlSerializer) {
		this.xmlSerializer = xmlSerializer;
	}

	public void render(Map<String, ?> model, HttpServletRequest request,HttpServletResponse response) throws Exception {
		PrintWriter out = null;
		try {
			response.setContentType(getContentType());
			response.setCharacterEncoding(this.encoding);
			response.addHeader("Pragma", "no-cache");
			response.addHeader("Cache-Control", "no-cache, no-store, max-age=0");
			response.addDateHeader("Expires", 1L);

			JSON json = null;
//			if(model.containsKey(ApiConst.ERROR_CODE_KEY.getCode()) || model.containsKey(ApiConst.ERROR_MESSAGE_KEY.getCode())) {
//				Map<String, Object> errorMap = new HashMap<String, Object>();
//				errorMap.put(ApiConst.ERROR_CODE_KEY.getCode(), model.get(ApiConst.ERROR_CODE_KEY.getCode()));
//				errorMap.put(ApiConst.ERROR_MESSAGE_KEY.getCode(), model.get(ApiConst.ERROR_MESSAGE_KEY.getCode()));
//
//				json = JSONSerializer.toJSON(errorMap);
//				xmlSerializer.setRootName(ApiConst.ERROR_KEY.getCode());
//			} else {
//				String jsonStr = (String)model.get(XML_KEY);
				String rootName = "root";
				if( model.containsKey(XML_ROOT_KEY) == true){
					rootName = (String)model.get(XML_ROOT_KEY);
				}
				String elementName = "element";
				if( model.containsKey(XML_ELEMENT_KEY) == true){
					elementName = (String)model.get(XML_ELEMENT_KEY);
				}

				//순환오류 방지
				JsonConfig jsonConfig = new JsonConfig();
				jsonConfig.setCycleDetectionStrategy(CycleDetectionStrategy.LENIENT);

				Box xmlBox = new Box();
				if (null != model.get("list"))  {
					xmlBox.put("list", model.get("list"));
				} else {
					xmlBox.putAll(model);
				}
				json = JSONSerializer.toJSON(xmlBox, jsonConfig);
				xmlSerializer.setRootName(rootName);
				xmlSerializer.setElementName(elementName);
//			}

			xmlSerializer.setTypeHintsEnabled(false);
			String xml = xmlSerializer.write(json, this.encoding);

			out = response.getWriter();
			out.print(xml);
			out.flush();
		} finally {
			if(out != null) {
				out.close();
			}
		}
	}

}

/*
package com.enpem.web.common.spring;

import java.io.ByteArrayOutputStream;
import java.io.OutputStream;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.Marshaller;

import org.eclipse.persistence.jaxb.JAXBContextFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.View;

import com.enpem.web.common.constants.CmnConst;
import com.enpem.web.common.util.HttpUtil;
import com.enpem.web.common.vo.CmnResponseVO;

public class ApiXmlView implements View {

	private static final Logger log = LoggerFactory.getLogger(ApiXmlView.class);
	public static final String DEFAULT_CONTENT_TYPE = "application/xml";
	private String contentType = DEFAULT_CONTENT_TYPE;
	private Boolean prettyPrint = true;
//	private ApiLogService apiLogService;

	public ApiXmlView() {
		setContentType(DEFAULT_CONTENT_TYPE);
	}

	public void setContentType(String contentType) {
		this.contentType = contentType;
	}

	public String getContentType() {
		return this.contentType;
	}

	public void setPrettyPrint(boolean prettyPrint) {
		this.prettyPrint = prettyPrint;
	}

//	public void setApiLogService(ApiLogService apiLogService) {
//		this.apiLogService = apiLogService;
//	}

	public void render(Map<String, ?> model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		log.debug("[Response] XML");

		response.setContentType(getContentType());
		response.setCharacterEncoding(CmnConst.CHARSET);
		response.addHeader("Pragma", "no-cache");
		response.addHeader("Cache-Control", "no-cache, no-store, max-age=0");
		response.addDateHeader("Expires", 1L);
//		OmbsUtil.setHeader(modelMap, request, response);

//		if(log.isDebugEnabled()) {
//			String resHeader = HttpUtil.getHeaderToJson(response);
//			log.debug("[Response Header]\n{}", resHeader);
//		}

		Object xmlObj = model.get(CmnConst.MODELMAP_XML_RESULT);
		ByteArrayOutputStream output = new ByteArrayOutputStream();
		if(xmlObj != null) {
			JAXBContext jaxbContext = JAXBContextFactory.createContext(new Class[]{CmnResponseVO.class}, null);
			Marshaller marshaller = jaxbContext.createMarshaller();
			if(prettyPrint) {
				marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);
			}
			marshaller.marshal(xmlObj, output);
			log.debug("[Response Body]\n{}", output.toString());
			OutputStream outputStream = response.getOutputStream();
			outputStream.write(output.toByteArray());
		}
//		apiLogService.updateServerResApiLog(request, response, modelMap, output.toString());
	}

}
*/
