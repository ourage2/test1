package com.enpem.web.common.util;

import java.io.ByteArrayOutputStream;
import java.io.StringReader;
import java.io.StringWriter;

import javax.servlet.http.HttpServletRequest;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.Marshaller;
import javax.xml.bind.Unmarshaller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.enpem.web.common.constants.CmnConst;
import com.enpem.web.common.exception.BaseException;

import nu.xom.Builder;
import nu.xom.Serializer;


public class XmlUtil {

	protected Logger log = LoggerFactory.getLogger(this.getClass());

	/**
	 * Checks if is xml accept.
	 *
	 * @param request the request
	 * @return true, if is xml accept
	 */
	public static final boolean isXmlAccept(HttpServletRequest request) {
		String accept = request.getHeader("Accept");
		if(accept != null) {
			accept = accept.toLowerCase();
			if(accept.startsWith("text/xml") || accept.startsWith("application/xml")) {
				return true;
			}
		}
		return false;
	}

	/**
	 * Checks if is xml body.
	 *
	 * @param request the request
	 * @return true, if is xml body
	 */
	public static final boolean isXmlBody(HttpServletRequest request) {
		String contentType = request.getContentType();
		if(contentType != null) {
			contentType = contentType.toLowerCase();
			if(contentType.startsWith("text/xml") || contentType.startsWith("application/xml")) {
				return true;
			}
		}
		return false;
	}

	/**
	 * Checks if is xml.
	 *
	 * @param request the request
	 * @return true, if is xml
	 */
	public static final boolean isXml(HttpServletRequest request) {
		if(isXmlExtension(request) || isXmlAccept(request) || isXmlBody(request)) {
			return true;
		}
		return false;
	}

	/**
	 * Checks if is xml extension.
	 *
	 * @param request the request
	 * @return true, if is xml extension
	 */
	public static final boolean isXmlExtension(HttpServletRequest request) {
		String uri = SpringUtil.getOriginatingServletPath(request);
		if(uri.endsWith(".xml")) {
			return true;
		}
		return false;
	}

	/**
	 * Marshall.
	 *
	 * @param target the target
	 * @param clazz the clazz
	 * @param isFormat the is format
	 * @return the string
	 */
	public static final String marshall(Object target, Class<?> clazz, boolean isFormat) {
		try {
			JAXBContext jaxbContext = JAXBContext.newInstance(clazz);
			Marshaller marshaller = jaxbContext.createMarshaller();
			// ByteArrayOutputStream output = new ByteArrayOutputStream();
			StringWriter writer = new StringWriter();
			marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, isFormat);
			marshaller.marshal(target, writer);
			return writer.toString();
		} catch (Exception e) {
			throw new BaseException(e);
		}
	}

	/**
	 * Marshall.
	 *
	 * @param target the target
	 * @param clazz the clazz
	 * @return the string
	 */
	public static final String marshall(Object target, Class<?> clazz) {
		return marshall(target, clazz, true);
	}

	/**
	 * Unmarshall.
	 *
	 * @param <T> the generic type
	 * @param xml the xml
	 * @param clazz the clazz
	 * @return the t
	 */
	@SuppressWarnings("unchecked")
	public static final <T> T unmarshall(String xml, Class<T> clazz) {
		T obj = null;
		if(StringUtil.isNotEmpty(xml)) {
			try {
				JAXBContext jaxbContext = JAXBContext.newInstance(clazz);
				Unmarshaller umarshaller = jaxbContext.createUnmarshaller();
				obj = (T)umarshaller.unmarshal(new StringReader(xml));
			} catch (Exception e) {
				throw new BaseException(e);
			}
		}
		return obj;
	}

	/**
	 * Format.
	 *
	 * @param xml the xml
	 * @return the string
	 */
	public String prettyPrint(String xml) {
		String format = null;
		try {
			ByteArrayOutputStream out = new ByteArrayOutputStream();
		    Serializer serializer = new Serializer(out);
		    serializer.setIndent(4);
		    serializer.write(new Builder().build(xml, ""));
		    format = out.toString(CmnConst.CHARSET);
		} catch (Exception e) {
			log.error("format error : ", e);
		}
	    return format;
	}

}
