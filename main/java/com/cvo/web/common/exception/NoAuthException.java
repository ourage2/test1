package com.enpem.web.common.exception;


@SuppressWarnings("serial")
public class NoAuthException extends BaseException {

	private String messageId;

	/**
	 * Instantiates a new no auth exception.
	 */
	public NoAuthException() {
		super();
	}

	/**
	 * Instantiates a new no auth exception.
	 *
	 * @param messageId the message id
	 */
	public NoAuthException(String messageId) {
		super();
		this.messageId = messageId;
	}

	/**
	 * Instantiates a new no auth exception.
	 *
	 * @param messageId the message id
	 * @param defaultMessage the default message
	 */
	public NoAuthException(String messageId, String defaultMessage) {
		super(defaultMessage);
		this.messageId = messageId;
	}

	/**
	 * Instantiates a new no auth exception.
	 *
	 * @param messageId the message id
	 * @param cause the cause
	 */
	public NoAuthException(String messageId, Throwable cause) {
		super(null, cause);
		this.messageId = messageId;
	}

	/**
	 * Instantiates a new no auth exception.
	 *
	 * @param cause the cause
	 */
	public NoAuthException(Throwable cause) {
		super(cause);
	}

	/**
	 * Gets the message id.
	 *
	 * @return the message id
	 */
	public String getMessageId() {
		return messageId;
	}

}
