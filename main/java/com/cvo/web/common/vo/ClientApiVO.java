package com.enpem.web.common.vo;

import java.net.URI;

import org.apache.http.StatusLine;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpUriRequest;

import com.enpem.web.common.data.Box;

public class ClientApiVO extends ClientApiBaseVO {

	/* API Log */
	private boolean apiLogFlag = true;
	private Box paramBox;  // custom required
	private Box apiLogBox;
	private Exception exception;
	private String rqtSys;
	private String rqtHost;
	private Box rqtFinalHeaderBox;
	private String rpySys;  // custom required
	private String rpyHost;
	private Box rpyHeaderBox;
	private String rpyContent;
	private String apiLogInsertYn;

	private String asyncYn;  // custom
	private String transacId;  // custom
	private String motVer;  // custom
	private String settlNo;  // custom
	private String settlId;  // custom
	private String settlIdTypeCd;  // custom
	private String loginId;  // custom
	private String loginIdTypeCd;  // custom

	/* HttpClient */
	private RequestConfig requestConfig;
	private URI uri;
	private HttpUriRequest httpRequest;
	private CloseableHttpResponse httpResponse;
	private StatusLine responseStatus;
	private String method = "POST";  // custom
	private boolean isSsl = false;  // custom

	/**
	 * Checks if is api log flag.
	 *
	 * @return true, if is api log flag
	 */
	public boolean isApiLogFlag() {
		return apiLogFlag;
	}

	/**
	 * Sets the api log flag.
	 *
	 * @param apiLogFlag the new api log flag
	 */
	public void setApiLogFlag(boolean apiLogFlag) {
		this.apiLogFlag = apiLogFlag;
	}

	/**
	 * Gets the param box.
	 *
	 * @return the param box
	 */
	public Box getParamBox() {
		return paramBox;
	}

	/**
	 * Sets the param box.
	 *
	 * @param paramBox the new param box
	 */
	public void setParamBox(Box paramBox) {
		this.paramBox = paramBox;
	}

	/**
	 * Gets the api log box.
	 *
	 * @return the api log box
	 */
	public Box getApiLogBox() {
		return apiLogBox;
	}

	/**
	 * Sets the api log box.
	 *
	 * @param apiLogBox the new api log box
	 */
	public void setApiLogBox(Box apiLogBox) {
		this.apiLogBox = apiLogBox;
	}

	/**
	 * Gets the exception.
	 *
	 * @return the exception
	 */
	public Exception getException() {
		return exception;
	}

	/**
	 * Sets the exception.
	 *
	 * @param exception the new exception
	 */
	public void setException(Exception exception) {
		this.exception = exception;
	}

	/**
	 * Gets the rqt sys.
	 *
	 * @return the rqt sys
	 */
	public String getRqtSys() {
		return rqtSys;
	}

	/**
	 * Sets the rqt sys.
	 *
	 * @param rqtSys the new rqt sys
	 */
	public void setRqtSys(String rqtSys) {
		this.rqtSys = rqtSys;
	}

	/**
	 * Gets the rqt host.
	 *
	 * @return the rqt host
	 */
	public String getRqtHost() {
		return rqtHost;
	}

	/**
	 * Sets the rqt host.
	 *
	 * @param rqtHost the new rqt host
	 */
	public void setRqtHost(String rqtHost) {
		this.rqtHost = rqtHost;
	}

	/**
	 * Gets the rqt final header box.
	 *
	 * @return the rqt final header box
	 */
	public Box getRqtFinalHeaderBox() {
		return rqtFinalHeaderBox;
	}

	/**
	 * Sets the rqt final header box.
	 *
	 * @param rqtFinalHeaderBox the new rqt final header box
	 */
	public void setRqtFinalHeaderBox(Box rqtFinalHeaderBox) {
		this.rqtFinalHeaderBox = rqtFinalHeaderBox;
	}

	/**
	 * Gets the rpy sys.
	 *
	 * @return the rpy sys
	 */
	public String getRpySys() {
		if(getIfIpBasBox() != null) {
			this.rpySys = getIfIpBasBox().getString("settlIfSysCd");
		}
		return rpySys;
	}

	/**
	 * Sets the rpy sys.
	 *
	 * @param rpySys the new rpy sys
	 */
	public void setRpySys(String rpySys) {
		this.rpySys = rpySys;
	}

	/**
	 * Gets the rpy host.
	 *
	 * @return the rpy host
	 */
	public String getRpyHost() {
		return rpyHost;
	}

	/**
	 * Sets the rpy host.
	 *
	 * @param rpyHost the new rpy host
	 */
	public void setRpyHost(String rpyHost) {
		this.rpyHost = rpyHost;
	}

	/**
	 * Gets the rpy header box.
	 *
	 * @return the rpy header box
	 */
	public Box getRpyHeaderBox() {
		return rpyHeaderBox;
	}

	/**
	 * Sets the rpy header box.
	 *
	 * @param rpyHeaderBox the new rpy header box
	 */
	public void setRpyHeaderBox(Box rpyHeaderBox) {
		this.rpyHeaderBox = rpyHeaderBox;
	}

	/**
	 * Gets the rpy content.
	 *
	 * @return the rpy content
	 */
	public String getRpyContent() {
		return rpyContent;
	}

	/**
	 * Sets the rpy content.
	 *
	 * @param rpyContent the new rpy content
	 */
	public void setRpyContent(String rpyContent) {
		this.rpyContent = rpyContent;
	}

	/**
	 * Gets the api log insert yn.
	 *
	 * @return the api log insert yn
	 */
	public String getApiLogInsertYn() {
		return apiLogInsertYn;
	}

	/**
	 * Sets the api log insert yn.
	 *
	 * @param apiLogInsertYn the new api log insert yn
	 */
	public void setApiLogInsertYn(String apiLogInsertYn) {
		this.apiLogInsertYn = apiLogInsertYn;
	}

	/**
	 * Gets the async yn.
	 *
	 * @return the async yn
	 */
	public String getAsyncYn() {
		return asyncYn;
	}

	/**
	 * Sets the async yn.
	 *
	 * @param asyncYn the new async yn
	 */
	public void setAsyncYn(String asyncYn) {
		this.asyncYn = asyncYn;
	}

	/**
	 * Gets the transac id.
	 *
	 * @return the transac id
	 */
	public String getTransacId() {
		return transacId;
	}

	/**
	 * Sets the transac id.
	 *
	 * @param transacId the new transac id
	 */
	public void setTransacId(String transacId) {
		this.transacId = transacId;
	}

	/**
	 * Gets the mot ver.
	 *
	 * @return the mot ver
	 */
	public String getMotVer() {
		return motVer;
	}

	/**
	 * Sets the mot ver.
	 *
	 * @param motVer the new mot ver
	 */
	public void setMotVer(String motVer) {
		this.motVer = motVer;
	}

	/**
	 * Gets the settl no.
	 *
	 * @return the settl no
	 */
	public String getSettlNo() {
		return settlNo;
	}

	/**
	 * Sets the settl no.
	 *
	 * @param settlNo the new settl no
	 */
	public void setSettlNo(String settlNo) {
		this.settlNo = settlNo;
	}

	/**
	 * Gets the settl id.
	 *
	 * @return the settl id
	 */
	public String getSettlId() {
		return settlId;
	}

	/**
	 * Sets the settl id.
	 *
	 * @param settlId the new settl id
	 */
	public void setSettlId(String settlId) {
		this.settlId = settlId;
	}

	/**
	 * Gets the settl id type cd.
	 *
	 * @return the settl id type cd
	 */
	public String getSettlIdTypeCd() {
		return settlIdTypeCd;
	}

	/**
	 * Sets the settl id type cd.
	 *
	 * @param settlIdTypeCd the new settl id type cd
	 */
	public void setSettlIdTypeCd(String settlIdTypeCd) {
		this.settlIdTypeCd = settlIdTypeCd;
	}

	/**
	 * Gets the login id.
	 *
	 * @return the login id
	 */
	public String getLoginId() {
		return loginId;
	}

	/**
	 * Sets the login id.
	 *
	 * @param loginId the new login id
	 */
	public void setLoginId(String loginId) {
		this.loginId = loginId;
	}

	/**
	 * Gets the login id type cd.
	 *
	 * @return the login id type cd
	 */
	public String getLoginIdTypeCd() {
		return loginIdTypeCd;
	}

	/**
	 * Sets the login id type cd.
	 *
	 * @param loginIdTypeCd the new login id type cd
	 */
	public void setLoginIdTypeCd(String loginIdTypeCd) {
		this.loginIdTypeCd = loginIdTypeCd;
	}

	/**
	 * Gets the request config.
	 *
	 * @return the request config
	 */
	public RequestConfig getRequestConfig() {
		return requestConfig;
	}

	/**
	 * Sets the request config.
	 *
	 * @param requestConfig the new request config
	 */
	public void setRequestConfig(RequestConfig requestConfig) {
		this.requestConfig = requestConfig;
	}

	/**
	 * Gets the uri.
	 *
	 * @return the uri
	 */
	public URI getUri() {
		return uri;
	}

	/**
	 * Sets the uri.
	 *
	 * @param uri the new uri
	 */
	public void setUri(URI uri) {
		this.uri = uri;
	}

	/**
	 * Gets the http request.
	 *
	 * @return the http request
	 */
	public HttpUriRequest getHttpRequest() {
		return httpRequest;
	}

	/**
	 * Sets the http request.
	 *
	 * @param httpRequest the new http request
	 */
	public void setHttpRequest(HttpUriRequest httpRequest) {
		this.httpRequest = httpRequest;
	}

	/**
	 * Gets the http response.
	 *
	 * @return the http response
	 */
	public CloseableHttpResponse getHttpResponse() {
		return httpResponse;
	}

	/**
	 * Sets the http response.
	 *
	 * @param httpResponse the new http response
	 */
	public void setHttpResponse(CloseableHttpResponse httpResponse) {
		this.httpResponse = httpResponse;
	}

	/**
	 * Gets the response status.
	 *
	 * @return the response status
	 */
	public StatusLine getResponseStatus() {
		return responseStatus;
	}

	/**
	 * Sets the response status.
	 *
	 * @param responseStatus the new response status
	 */
	public void setResponseStatus(StatusLine responseStatus) {
		this.responseStatus = responseStatus;
	}

	/**
	 * Gets the method.
	 *
	 * @return the method
	 */
	public String getMethod() {
		return method;
	}

	/**
	 * Sets the method.
	 *
	 * @param method the new method
	 */
	public void setMethod(String method) {
		this.method = method;
	}

	/**
	 * Checks if is ssl.
	 *
	 * @return true, if is ssl
	 */
	public boolean isSsl() {
		return isSsl;
	}

	/**
	 * Sets the ssl.
	 *
	 * @param isSsl the new ssl
	 */
	public void setSsl(boolean isSsl) {
		this.isSsl = isSsl;
	}

	@Override
	public String toString() {
		return "ClientApiVO [apiLogFlag=" + apiLogFlag + ", paramBox=" + paramBox + ", apiLogBox=" + apiLogBox + ", exception=" + exception
				+ ", rqtSys=" + rqtSys + ", rqtHost=" + rqtHost + ", rqtFinalHeaderBox=" + rqtFinalHeaderBox + ", rpySys=" + rpySys + ", rpyHost="
				+ rpyHost + ", rpyHeaderBox=" + rpyHeaderBox + ", rpyContent=" + rpyContent + ", apiLogInsertYn=" + apiLogInsertYn + ", asyncYn="
				+ asyncYn + ", transacId=" + transacId + ", motVer=" + motVer + ", settlNo=" + settlNo + ", settlId=" + settlId + ", settlIdTypeCd="
				+ settlIdTypeCd + ", loginId=" + loginId + ", loginIdTypeCd=" + loginIdTypeCd + ", requestConfig=" + requestConfig + ", uri=" + uri
				+ ", httpRequest=" + httpRequest + ", httpResponse=" + httpResponse + ", responseStatus=" + responseStatus + ", method=" + method
				+ ", isSsl=" + isSsl + "]";
	}


}
