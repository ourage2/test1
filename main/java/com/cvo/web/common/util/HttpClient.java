package com.enpem.web.common.util;

import java.io.IOException;
import java.io.InterruptedIOException;
import java.net.SocketException;
import java.net.SocketTimeoutException;
import java.net.URI;
import java.net.UnknownHostException;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.util.Iterator;
import java.util.List;

import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLException;

import org.apache.http.HttpEntity;
import org.apache.http.HttpEntityEnclosingRequest;
import org.apache.http.HttpRequest;
import org.apache.http.HttpStatus;
import org.apache.http.NameValuePair;
import org.apache.http.NoHttpResponseException;
import org.apache.http.StatusLine;
import org.apache.http.client.HttpRequestRetryHandler;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpRequestBase;
import org.apache.http.client.methods.HttpUriRequest;
import org.apache.http.client.protocol.HttpClientContext;
import org.apache.http.client.utils.URIBuilder;
import org.apache.http.conn.ConnectTimeoutException;
import org.apache.http.conn.ssl.NoopHostnameVerifier;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.protocol.HttpContext;
import org.apache.http.ssl.SSLContexts;
import org.apache.http.ssl.TrustStrategy;
import org.apache.http.util.EntityUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.enpem.web.common.data.Box;
import com.enpem.web.common.exception.BaseException;
import com.enpem.web.common.spring.InternalEntityEclosingRequest;
import com.enpem.web.common.spring.InternalRequest;
import com.enpem.web.common.vo.ClientApiVO;

public class HttpClient {

	protected static Logger log = LoggerFactory.getLogger(HttpClient.class);
	private static final String LOGGING_REQUEST_LINE = "==============================  Http Client Request  ==============================";
	private static final String LOGGING_RESPONSE_LINE = "______________________________  Http Client Response  ______________________________";

	public enum Method {
		GET("GET"),
		POST("POST"),
		PUT("PUT"),
		DELETE("DELETE"),
		HEAD("HEAD"),
		OPTIONS("OPTIONS"),
		TRACE("TRACE");
		private String name;
		Method(String _name) {
			this.name = _name;
		}
		public String getName() {
			return name;
		}
	}

	/**
	 * Send get.
	 *
	 * @param clientApiVO the client api vo
	 * @return the client api vo
	 */
	public static ClientApiVO sendGet(ClientApiVO clientApiVO) {
		clientApiVO.setMethod(Method.GET.getName());
		return HttpClient.send(clientApiVO);
	}

	/**
	 * Send post.
	 *
	 * @param clientApiVO the client api vo
	 * @return the client api vo
	 */
	public static ClientApiVO sendPost(ClientApiVO clientApiVO) {
		clientApiVO.setMethod(Method.POST.getName());
		return HttpClient.send(clientApiVO);
	}

	/**
	 * Send.
	 *
	 * @param clientApiVO the client api vo
	 * @return the client api vo
	 */
	public static ClientApiVO send(ClientApiVO clientApiVO) {
		CloseableHttpClient httpClient = null;
		CloseableHttpResponse response = null;
		try {
			HttpClient.sendBefore(clientApiVO);

			int timeout = clientApiVO.getTimeout();
			RequestConfig requestConfig = HttpClient.getDefaultRequestConfig(timeout);
//			clientApiVO.setRequestConfig(requestConfig);

			HttpClientBuilder httpClientBuilder = HttpClient.getDefaultHttpClientBuilder(requestConfig);
			/*
			HttpClientBuilder httpClientBuilder = HttpClients.custom()
					.setDefaultRequestConfig(clientApiVO.getRequestConfig())
					.setRetryHandler(getRetryHandler());
			*/

			boolean isSsl = clientApiVO.isSsl();
			/*
			if(!isSsl) {
				String scheme = null;
				URI uri = clientApiVO.getUri();
				if(uri != null) {
					String uriStr = uri.toString();
					int schemeGubunIdx = uriStr.indexOf(":");
					if(schemeGubunIdx > -1) {
						scheme = uriStr.substring(0, schemeGubunIdx);
					}
				}
				if(StringUtil.isEmpty(scheme)) {
					scheme = clientApiVO.getScheme();
				}
				if(StringUtil.isNotEmpty(scheme)) {
					isSsl = "https".equals(scheme.toLowerCase());
				}
			}
			*/

			if(isSsl) {
				SSLContext sslcontext = HttpClient.getTrustSslContext();
				httpClientBuilder.setSSLHostnameVerifier(new NoopHostnameVerifier()).setSSLContext(sslcontext);
			}
			httpClient = httpClientBuilder.build();
			response = httpClient.execute(clientApiVO.getHttpRequest());
			HttpClient.sendAfter(clientApiVO, response);
		} catch (Exception e) {
			HttpUriRequest httpRequest = clientApiVO.getHttpRequest();
			if(httpRequest != null) {
				try {
					httpRequest.abort();
				} catch (Exception e1) {
				}
			}
			clientApiVO.setException(e);
//			throw new BaseException(e);
		} finally {
			try {
				if(response != null) {
					response.close();
				}
				if(httpClient != null) {
					httpClient.close();
				}
			} catch (IOException e) {
//				throw new BaseException(e);
				log.debug("error : {}", e);
			}
//			if(clientApiVO.isApiLogFlag()) {
//				ClientApiLogUtil.insertApiLog(clientApiVO);
//			}
		}
		return clientApiVO;
	}

	/**
	 * Send before.
	 *
	 * @param clientApiVO the client api vo
	 */
	private static void sendBefore(ClientApiVO clientApiVO) {
		try {
//			if(clientApiVO.isApiLogFlag()) {
//				ClientApiLogUtil.initApiLog(clientApiVO);
//			}
			String serverSystemName = ServerUtil.getServerSystemName();
			String serverHostname = ServerUtil.getServerHostname();
			clientApiVO.setRqtSys(serverSystemName);
			clientApiVO.setRqtHost(serverHostname);

			URI uri = clientApiVO.getUri();
			URIBuilder uriBuilder = null;

			if(uri == null) {
				if(StringUtil.isNotEmpty(clientApiVO.getUrl())) {
					uriBuilder = new URIBuilder(clientApiVO.getUrl());
				} else {
					uriBuilder = new URIBuilder();
					if(StringUtil.isNotEmpty(clientApiVO.getScheme())) {
						uriBuilder.setScheme(clientApiVO.getScheme());
					}
					if(StringUtil.isNotEmpty(clientApiVO.getHost())) {
						uriBuilder.setHost(clientApiVO.getHost());
					}
					String contextPath = clientApiVO.getContextPath();
					if(contextPath == null) {
						contextPath = "";
					}
					String path = clientApiVO.getPath();
					if(path == null) {
						path = "";
					}
					path = contextPath + path;
					if(StringUtil.isNotEmpty(path)) {
						uriBuilder.setPath(path);
					}
					if(clientApiVO.getPort() > 0) {
						uriBuilder.setPort(clientApiVO.getPort());
					}
				}
				uri = uriBuilder.build();
				clientApiVO.setUri(uri);
			}

			boolean isSsl = clientApiVO.isSsl();
			String scheme = null;
			String uriStr = uri.toString();
			int schemeIdx = uriStr.indexOf(":");
			if(schemeIdx > 0) {
				scheme = uriStr.substring(0, schemeIdx);
			}
			if(StringUtil.isEmpty(scheme)) {
				scheme = clientApiVO.getScheme();
			}
			if(StringUtil.isNotEmpty(scheme)) {
				isSsl = "https".equals(scheme.toLowerCase());
				clientApiVO.setSsl(isSsl);
			}

			HttpRequestBase httpRequest = null;
			String method = clientApiVO.getMethod();

//			boolean isGet = Method.GET.getName().equalsIgnoreCase(method);
			boolean isPost = Method.POST.getName().equalsIgnoreCase(method);
			boolean isPut = Method.PUT.getName().equalsIgnoreCase(method);
//			boolean isDelete = Method.DELETE.getName().equalsIgnoreCase(method);
//			boolean isOptions = Method.OPTIONS.getName().equalsIgnoreCase(method);

			if(isPost || isPut) {
				httpRequest = new InternalEntityEclosingRequest(method);
			} else {
				httpRequest = new InternalRequest(method);
			}

			/*
			if(isGet) {
				httpRequest = new HttpGet(uri);
			} else if(isPost) {
				httpRequest = new HttpPost(uri);
			} else if(isPut) {
				httpRequest = new HttpPut(uri);
			} else if(isDelete) {
				httpRequest = new HttpDelete(uri);
			} else if(isOptions) {
				httpRequest = new HttpOptions(uri);
			}
			*/
			clientApiVO.setHttpRequest(httpRequest);

			Box rqtHeaderBox = clientApiVO.getRqtHeaderBox();
			if(rqtHeaderBox != null) {
				Iterator<String> iter = rqtHeaderBox.keySet().iterator();
				String key, value;
				while(iter.hasNext()) {
					key = iter.next();
					value = rqtHeaderBox.getString(key);
					httpRequest.setHeader(key, value);
				}
			}

			HttpEntity httpEntity = null;
			Box rqtParamBox = clientApiVO.getRqtParamBox();
			String rqtContent = clientApiVO.getRqtContent();

//			if((isPost || isPut) && StringUtil.isEmpty(rqtContent)) {
			if((isPost || isPut) && rqtContent == null) {
				List<NameValuePair> paramList = HttpUtil.getBoxToNameValuePair(rqtParamBox);
				if(paramList != null) {
					httpEntity = new UrlEncodedFormEntity(paramList, clientApiVO.getEncoding());
				}
			} else {
				if(StringUtil.isNotEmpty(rqtContent)) {
					httpEntity = new StringEntity(rqtContent, clientApiVO.getEncoding());
				}
				if(rqtParamBox != null) {
					uri = HttpUtil.rebuildUri(uri, rqtParamBox, clientApiVO.getEncoding());
				}
			}
			/*
			if(isGet || isDelete || (!isGet && !isDelete && StringUtil.isNotEmpty(rqtContent))) {
				if(!isGet) {
					httpEntity = new StringEntity(rqtContent, clientApiVO.getEncoding());
				}
				if(rqtParamBox != null) {
					uri = HttpUtil.rebuildUri(uri, rqtParamBox, clientApiVO.getEncoding());
				}
			} else {
				List<NameValuePair> paramList = HttpUtil.getBoxToNameValuePair(rqtParamBox);
				if(paramList != null) {
					httpEntity = new UrlEncodedFormEntity(paramList, clientApiVO.getEncoding());
				}
			}
			*/
			httpRequest.setURI(uri);

			Box rqtFinalHeaderBox = HttpUtil.getHeaderToBox(httpRequest.getAllHeaders());
			clientApiVO.setRqtFinalHeaderBox(rqtFinalHeaderBox);

			if(httpEntity != null) {
				if(isPost || isPut) {
					((InternalEntityEclosingRequest)httpRequest).setEntity(httpEntity);
				}
				/*
				if(isPost) {
					((HttpPost)httpRequest).setEntity(httpEntity);
				} else if(isPut) {
					((HttpPut)httpRequest).setEntity(httpEntity);
				}
				*/
			}

			if(log.isDebugEnabled()) {
				StringBuffer rqtInfoBuffer = new StringBuffer()
						.append("\n")
						.append(LOGGING_REQUEST_LINE)
						.append("\n")
						.append("[Request 정보]\n")
						.append("시스템명 : ")
						.append(serverSystemName)
						.append("\n")
						.append("서버호스트명 : ")
						.append(serverHostname)
						.append("\n")
						.append("URL : ")
						.append(uri.toString())
						.append("\n")
						.append("Method : ")
						.append(method);
				if(isSsl) {
					rqtInfoBuffer.append(" (")
						.append("SSL")
						.append(")");
				}
				rqtInfoBuffer.append("\n")
						.append("Header : ")
						.append(rqtFinalHeaderBox)
						.append("\n")
						.append("Parameter : ")
						.append(rqtParamBox)
						.append("\n")
						.append("Content : ")
						.append(rqtContent)
						.append("\n")
						.append(LOGGING_REQUEST_LINE);
				log.debug(rqtInfoBuffer.toString());
			}
		} catch (Exception e) {
			throw new BaseException(e);
		}
	}

	/**
	 * Send after.
	 *
	 * @param clientApiVO the client api vo
	 * @param response the response
	 */
	private static void sendAfter(ClientApiVO clientApiVO, CloseableHttpResponse response) {
		clientApiVO.setHttpResponse(response);
		StatusLine responseStatusLine = response.getStatusLine();
		clientApiVO.setResponseStatus(responseStatusLine);

		Box rpyHeaderBox = HttpUtil.getHeaderToBox(response.getAllHeaders());
		clientApiVO.setRpyHeaderBox(rpyHeaderBox);

		String rpyContent = null;
		HttpEntity httpEntity = null;
		try {
			httpEntity = response.getEntity();
			if(httpEntity != null) {
				rpyContent = EntityUtils.toString(httpEntity, clientApiVO.getEncoding());
				clientApiVO.setRpyContent(rpyContent);
			}
		} catch (Exception e) {
			throw new BaseException(e);
		} finally {
			EntityUtils.consumeQuietly(httpEntity);
		}

		if(log.isDebugEnabled()) {
			StringBuffer rqtInfoBuffer = new StringBuffer()
					.append("\n")
					.append(LOGGING_RESPONSE_LINE)
					.append("\n")
					.append("[Response 정보]\n")
					.append("시스템명 : ")
					.append(clientApiVO.getRpySys())
					.append("\n")
					.append("Status : ")
					.append(responseStatusLine)
					.append("\n")
					.append("Header : ")
					.append(rpyHeaderBox)
					.append("\n")
					.append("Body : ")
					.append(rpyContent)
					.append("\n")
					.append(LOGGING_RESPONSE_LINE);
			log.debug(rqtInfoBuffer.toString());
		}

		if(responseStatusLine.getStatusCode() != HttpStatus.SC_OK) {
			throw new BaseException(responseStatusLine.toString());
		}
	}

	/**
	 * Gets the default request config.
	 *
	 * @param timeout the timeout
	 * @return the default request config
	 */
	public static RequestConfig getDefaultRequestConfig(int timeout) {
		return RequestConfig.custom()
			.setSocketTimeout(timeout)
			.setConnectTimeout(timeout)
			.setConnectionRequestTimeout(timeout)
			.build();
	}

	/**
	 * Gets the default http client builder.
	 *
	 * @param requestConfig the request config
	 * @return the default http client builder
	 */
	public static HttpClientBuilder getDefaultHttpClientBuilder(RequestConfig requestConfig) {
		HttpClientBuilder httpClientBuilder = HttpClients.custom()
				.setDefaultRequestConfig(requestConfig)
				.setRetryHandler(HttpClient.getRetryHandler());
		return httpClientBuilder;
	}

	/**
	 * Gets the trust ssl context.
	 *
	 * @return the trust ssl context
	 */
	public static SSLContext getTrustSslContext() {
		SSLContext sslcontext = null;
		try {
			sslcontext = SSLContexts.custom()
					.useProtocol("SSL")
					.loadTrustMaterial(null, new TrustStrategy() {
						@Override
						public boolean isTrusted(X509Certificate[] paramArrayOfX509Certificate, String paramString) throws CertificateException {
							return true;
						}
					})
					.build();
		} catch (Exception e) {
			throw new BaseException(e);
		}
		return sslcontext;
	}

	/**
	 * Gets the retry handler.
	 *
	 * @return the retry handler
	 */
	public static HttpRequestRetryHandler getRetryHandler() {
		HttpRequestRetryHandler myRetryHandler = new HttpRequestRetryHandler() {
			public boolean retryRequest(IOException exception, int executionCount, HttpContext context) {
				log.error("HttpClient Exception (executionCount : {}) : ", executionCount, exception);
				if (executionCount >= 2) {
					return false;
				}
				if (exception instanceof NoHttpResponseException) {
					return true;
				}
				if (exception instanceof SocketException) {
					return true;
				}
				if (exception instanceof ConnectTimeoutException) {
					return false;
				}
				if (exception instanceof SocketTimeoutException) {
					return false;
				}
				if (exception instanceof InterruptedIOException) {
					return false;
				}
				if (exception instanceof UnknownHostException) {
					return false;
				}
				if (exception instanceof SSLException) {
					return false;
				}
				HttpClientContext clientContext = HttpClientContext.adapt(context);
				HttpRequest request = clientContext.getRequest();
				boolean idempotent = !(request instanceof HttpEntityEnclosingRequest);
				if(idempotent) {
					return true;
				}
				return false;
			}
		};
		return myRetryHandler;
	}

	/*
	private static class DefaultTrustManager implements javax.net.ssl.X509TrustManager {
		@Override
		public void checkClientTrusted(X509Certificate[] arg0, String arg1) throws CertificateException {
		}

		@Override
		public void checkServerTrusted(X509Certificate[] arg0, String arg1) throws CertificateException {
		}

		@Override
		public X509Certificate[] getAcceptedIssuers() {
			return null;
		}
	}
	*/

}
