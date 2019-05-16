package com.enpem.web.common.spring;

import org.apache.http.client.methods.HttpRequestBase;

public class InternalRequest extends HttpRequestBase {

	private String method;

	/**
	 * Instantiates a new internal request.
	 */
	public InternalRequest() {
	}

	/**
	 * Instantiates a new internal request.
	 *
	 * @param uri the uri
	 */
	public InternalRequest(String method) {
		this.method = method;
	}

	/* (non-Javadoc)
	 * @see org.apache.http.client.methods.HttpRequestBase#getMethod()
	 */
	@Override
	public String getMethod() {
		return this.method;
	}

}
