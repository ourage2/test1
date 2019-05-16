package com.enpem.web.common.exception;

import java.text.MessageFormat;

@SuppressWarnings("serial")
public class BizException extends BaseException {

	private String messageId;
	private Object [] messageParams;

	public BizException(String messageId) {
		super("");
		this.messageId = messageId;
	}

	public BizException(String messageId, String defaultMessage) {
		super(defaultMessage);
		this.messageId = messageId;
	}

	public BizException(String messageId, String defaultMessage, Throwable cause) {
		super(defaultMessage, cause);
		this.messageId = messageId;
	}

	public BizException(String messageId, Object[] messageParams) {
		super("");
		this.messageId = messageId;
		this.messageParams = messageParams;
	}

	public BizException(String messageId, String defaultMessage, Object[] messageParams) {
		super(defaultMessage);
		this.messageId = messageId;
		this.messageParams = messageParams;
	}

	public BizException(String messageId, String defaultMessage, Object[] messageParams, Throwable cause) {
		super(defaultMessage, cause);
		this.messageId = messageId;
		this.messageParams = messageParams;
	}

	public BizException(Throwable cause) {
		super(cause);
		if (cause instanceof BizException) {
			BizException bizException = ((BizException) cause);
			this.messageId = bizException.messageId;
			this.messageParams = bizException.messageParams;
		}
	}

	public String getMessageId() {
		return messageId;
	}

	public Object [] getMessageParams() {
		return messageParams;
	}

	@Override
	public String getMessage() {
        if (messageParams == null) {
        	return super.getMessage();
        }
        return MessageFormat.format(super.getMessage(), messageParams);
    }

    public String toString() {
        String s = getClass().getName();
        String message = getLocalizedMessage();
        return (message != null) ? (s + ": [" + messageId + "] " + message) : (s + ": [" + messageId + "]");
    }

}
