package com.enpem.web.common.spring;

import org.apache.http.client.methods.HttpEntityEnclosingRequestBase;

public class InternalEntityEclosingRequest extends HttpEntityEnclosingRequestBase {

	private String method;

	/**
	 * Instantiates a new internal entity eclosing request.
	 */
	public InternalEntityEclosingRequest() {
	}

	/**
	 * Instantiates a new internal entity eclosing request.
	 *
	 * @param uri the uri
	 */
	public InternalEntityEclosingRequest(String method) {
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
