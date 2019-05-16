package com.enpem.web.common.exception;

@SuppressWarnings("serial")
public class BaseException extends RuntimeException {

	/**
	 * Instantiates a new base exception.
	 */
	public BaseException() {
		super();
	}

	/**
	 * Instantiates a new base exception.
	 *
	 * @param message the message
	 */
	public BaseException(String message) {
        super(message);
    }

	/**
	 * Instantiates a new base exception.
	 *
	 * @param message the message
	 * @param cause the cause
	 */
	public BaseException(String message, Throwable cause) {
        super(message, cause);
    }

	/**
	 * Instantiates a new base exception.
	 *
	 * @param cause the cause
	 */
	public BaseException(Throwable cause) {
        super(cause);
    }

}
