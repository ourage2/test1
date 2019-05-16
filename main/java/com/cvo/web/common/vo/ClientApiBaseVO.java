package com.enpem.web.common.vo;

import com.enpem.web.common.constants.CmnConst;
import com.enpem.web.common.data.Box;

public class ClientApiBaseVO {

	private String encoding = CmnConst.CHARSET;
	private Box ifIpBasBox;
	private String scheme;
	private String host;
	private String contextPath;
	private String path;
	private String url;
	private int port = 80;
	private int timeout = 0;
	private Box rqtHeaderBox;
	private Box rqtParamBox;
	private String rqtContent;
	private String apiNm;

	/**
	 * Gets the if ip bas box.
	 *
	 * @return the if ip bas box
	 */
	public Box getIfIpBasBox() {
		return ifIpBasBox;
	}

	/**
	 * Sets the if ip bas box.
	 *
	 * @param ifIpBasBox the new if ip bas box
	 */
	public void setIfIpBasBox(Box ifIpBasBox) {
		this.ifIpBasBox = ifIpBasBox;
		if(ifIpBasBox != null) {
			this.scheme = ifIpBasBox.getString("protTypeNm");
			this.host = ifIpBasBox.getString("ipadr");
			this.contextPath = ifIpBasBox.getString("urlAdr");
			this.port = ifIpBasBox.getInt("portNo");
			this.timeout = ifIpBasBox.getInt("toutTime");
		}
	}

	/**
	 * Gets the scheme.
	 *
	 * @return the scheme
	 */
	public String getScheme() {
		return scheme;
	}

	/**
	 * Sets the scheme.
	 *
	 * @param scheme the new scheme
	 */
	public void setScheme(String scheme) {
		this.scheme = scheme;
	}

	/**
	 * Gets the host.
	 *
	 * @return the host
	 */
	public String getHost() {
		return host;
	}

	/**
	 * Sets the host.
	 *
	 * @param host the new host
	 */
	public void setHost(String host) {
		this.host = host;
	}

	/**
	 * Gets the context path.
	 *
	 * @return the context path
	 */
	public String getContextPath() {
		return contextPath;
	}

	/**
	 * Sets the context path.
	 *
	 * @param contextPath the new context path
	 */
	public void setContextPath(String contextPath) {
		this.contextPath = contextPath;
	}

	/**
	 * Gets the path.
	 *
	 * @return the path
	 */
	public String getPath() {
		return path;
	}

	/**
	 * Sets the path.
	 *
	 * @param path the new path
	 */
	public void setPath(String path) {
		this.path = path;
	}

	/**
	 * Gets the url.
	 *
	 * @return the url
	 */
	public String getUrl() {
		return url;
	}

	/**
	 * Sets the url.
	 *
	 * @param url the new url
	 */
	public void setUrl(String url) {
		this.url = url;
	}

	/**
	 * Gets the port.
	 *
	 * @return the port
	 */
	public int getPort() {
		return port;
	}

	/**
	 * Sets the port.
	 *
	 * @param port the new port
	 */
	public void setPort(int port) {
		this.port = port;
	}

	/**
	 * Gets the timeout.
	 *
	 * @return the timeout
	 */
	public int getTimeout() {
		return timeout;
	}

	/**
	 * Sets the timeout.
	 *
	 * @param timeout the new timeout
	 */
	public void setTimeout(int timeout) {
		this.timeout = timeout;
	}

	/**
	 * Gets the rqt header box.
	 *
	 * @return the rqt header box
	 */
	public Box getRqtHeaderBox() {
		return rqtHeaderBox;
	}

	/**
	 * Sets the rqt header box.
	 *
	 * @param rqtHeaderBox the new rqt header box
	 */
	public void setRqtHeaderBox(Box rqtHeaderBox) {
		this.rqtHeaderBox = rqtHeaderBox;
	}

	/**
	 * Gets the rqt param box.
	 *
	 * @return the rqt param box
	 */
	public Box getRqtParamBox() {
		return rqtParamBox;
	}

	/**
	 * Sets the rqt param box.
	 *
	 * @param rqtParamBox the new rqt param box
	 */
	public void setRqtParamBox(Box rqtParamBox) {
		this.rqtParamBox = rqtParamBox;
	}

	/**
	 * Gets the rqt content.
	 *
	 * @return the rqt content
	 */
	public String getRqtContent() {
		return rqtContent;
	}

	/**
	 * Sets the rqt content.
	 *
	 * @param rqtContent the new rqt content
	 */
	public void setRqtContent(String rqtContent) {
		this.rqtContent = rqtContent;
	}

	/**
	 * Gets the encoding.
	 *
	 * @return the encoding
	 */
	public String getEncoding() {
		return encoding;
	}

	/**
	 * Sets the encoding.
	 *
	 * @param encoding the new encoding
	 */
	public void setEncoding(String encoding) {
		this.encoding = encoding;
	}

	/**
	 * Gets the api nm.
	 *
	 * @return the api nm
	 */
	public String getApiNm() {
		return apiNm;
	}

	/**
	 * Sets the api nm.
	 *
	 * @param apiNm the new api nm
	 */
	public void setApiNm(String apiNm) {
		this.apiNm = apiNm;
	}

	@Override
	public String toString() {
		return "ClientApiBaseVO [encoding=" + encoding + ", ifIpBasBox=" + ifIpBasBox + ", scheme=" + scheme + ", host=" + host + ", contextPath="
				+ contextPath + ", path=" + path + ", url=" + url + ", port=" + port + ", timeout=" + timeout + ", rqtHeaderBox=" + rqtHeaderBox
				+ ", rqtParamBox=" + rqtParamBox + ", rqtContent=" + rqtContent + ", apiNm=" + apiNm + "]";
	}

}
