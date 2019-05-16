package com.enpem.web.common.util.crypto;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.codec.binary.BaseNCodec;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Base64Util {

	protected Logger log = LoggerFactory.getLogger(this.getClass());

	/**
	 * Encode.
	 *
	 * @param bytes the bytes
	 * @return the byte[]
	 */
	public static byte[] encode(byte[] bytes) {
		return Base64.encodeBase64(bytes);
	}

	/**
	 * Encode.
	 *
	 * @param str the str
	 * @return the byte[]
	 */
	public static byte[] encode(String str) {
		return encode(str.getBytes());
	}

	/**
	 * Encode string.
	 *
	 * @param bytes the bytes
	 * @return the string
	 */
	public static String encodeString(byte[] bytes) {
		return new String(encode(bytes));
	}

	/**
	 * Encode.
	 *
	 * @param bytes the bytes
	 * @param isChunked the is chunked
	 * @return the byte[]
	 */
	public static byte[] encode(byte[] bytes, boolean isChunked) {
		return Base64.encodeBase64(bytes, isChunked);
	}

	/**
	 * Encode string.
	 *
	 * @param bytes the bytes
	 * @param isChunked the is chunked
	 * @return the string
	 */
	public static String encodeString(byte[] bytes, boolean isChunked) {
		return new String(encode(bytes, isChunked));
	}

	/**
	 * Encode.
	 *
	 * @param bytes the bytes
	 * @param isChunked the is chunked
	 * @param urlSafe the url safe
	 * @return the byte[]
	 */
	public static byte[] encode(byte[] bytes, boolean isChunked, boolean urlSafe) {
		return Base64.encodeBase64(bytes, isChunked, urlSafe);
	}

	/**
	 * Encode string.
	 *
	 * @param bytes the bytes
	 * @param isChunked the is chunked
	 * @param urlSafe the url safe
	 * @return the string
	 */
	public static String encodeString(byte[] bytes, boolean isChunked, boolean urlSafe) {
		return new String(encode(bytes, isChunked, urlSafe));
	}

	/**
	 * Encode string.
	 *
	 * @param str the str
	 * @return the string
	 */
	public static String encodeString(String str) {
		return encodeString(str.getBytes());
	}

	/**
	 * Encode string.
	 *
	 * @param str the str
	 * @param isChunked the is chunked
	 * @return the string
	 */
	public static String encodeString(String str, boolean isChunked) {
		return encodeString(str.getBytes(), isChunked);
	}

	/**
	 * Encode string.
	 *
	 * @param str the str
	 * @param isChunked the is chunked
	 * @param urlSafe the url safe
	 * @return the string
	 */
	public static String encodeString(String str, boolean isChunked, boolean urlSafe) {
		return encodeString(str.getBytes(), isChunked, urlSafe);
	}

	/**
	 * New encode.
	 *
	 * @param bytes the bytes
	 * @param lineLength the line length
	 * @param lineSeparator the line separator
	 * @return the byte[]
	 */
	public static byte[] newEncode(byte[] bytes, int lineLength, byte[] lineSeparator) {
		Base64 base64 = new Base64(lineLength, lineSeparator);
		return base64.encode(bytes);
	}

	/**
	 * New encode.
	 *
	 * @param bytes the bytes
	 * @param lineSeparator the line separator
	 * @return the byte[]
	 */
	public static byte[] newEncode(byte[] bytes, byte[] lineSeparator) {
		return Base64Util.newEncode(bytes, BaseNCodec.MIME_CHUNK_SIZE, lineSeparator);
	}

	/**
	 * New encode string.
	 *
	 * @param bytes the bytes
	 * @param lineLength the line length
	 * @param lineSeparator the line separator
	 * @return the string
	 */
	public static String newEncodeString(byte[] bytes, int lineLength, byte[] lineSeparator) {
		return new String(Base64Util.newEncode(bytes, lineLength, lineSeparator));
	}

	/**
	 * New encode string.
	 *
	 * @param bytes the bytes
	 * @param lineSeparator the line separator
	 * @return the string
	 */
	public static String newEncodeString(byte[] bytes, byte[] lineSeparator) {
		return Base64Util.newEncodeString(bytes, BaseNCodec.MIME_CHUNK_SIZE, lineSeparator);
	}

	/*
	public static String newEncodeString(byte[] bytes) {
		String enStr = Base64Util.encodeString(bytes, true);
		if(StringUtil.isNotEmpty(enStr)) {
			enStr.replaceAll("\r", "");
		}
		return enStr;
	}
	*/

	/**
	 * Decode.
	 *
	 * @param bytes the bytes
	 * @return the byte[]
	 */
	public static byte[] decode(byte[] bytes) {
		return Base64.decodeBase64(bytes);
	}

	/**
	 * Decode.
	 *
	 * @param str the str
	 * @return the byte[]
	 */
	public static byte[] decode(String str) {
		return decode(str.getBytes());
	}

	/**
	 * Decode string.
	 *
	 * @param bytes the bytes
	 * @return the string
	 */
	public static String decodeString(byte[] bytes) {
		return new String(decode(bytes));
	}

	/**
	 * Decode string.
	 *
	 * @param str the str
	 * @return the string
	 */
	public static String decodeString(String str) {
		if (null == str || str.isEmpty()) {
			return "";
		}
		return decodeString(str.getBytes());
	}

	/**
	 * The main method.
	 *
	 * @param args the arguments
	 */
	public static void main(String[] args) {
//		String str = "viewing";
//		String enStr = Base64Util.encodeString(str);
//		System.out.println("original str : " + str);
//		System.out.println("encode str : " + enStr);
	}

}
