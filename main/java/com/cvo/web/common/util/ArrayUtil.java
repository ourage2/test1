package com.enpem.web.common.util;

import java.io.ByteArrayOutputStream;
import java.io.UnsupportedEncodingException;

import org.apache.commons.lang.ArrayUtils;

import com.enpem.web.common.constants.CmnConst;
import com.enpem.web.common.exception.BaseException;

public class ArrayUtil {

	/**
	 * Subbyte.
	 *
	 * @param array the array
	 * @param start the start
	 * @param end the end
	 * @return the byte[]
	 */
	public static byte[] subbyte(byte[] array, int start, int end) {
		if(array == null) {
			return null;
		}
		return ArrayUtils.subarray(array, start, end);
	}

	/**
	 * Subbyte.
	 *
	 * @param arrayStr the array str
	 * @param start the start
	 * @param end the end
	 * @param charset the charset
	 * @return the byte[]
	 */
	public static byte[] subbyte(String arrayStr, int start, int end, String charset) {
		byte[] subarray = null;
		if(arrayStr == null) {
			return subarray;
		}
		try {
			subarray = ArrayUtil.subbyte(arrayStr.getBytes(charset), start, end);
		} catch (UnsupportedEncodingException e) {
			throw new BaseException(e);
		}
		return subarray;
	}

	/**
	 * Subbyte.
	 *
	 * @param arrayStr the array str
	 * @param start the start
	 * @param end the end
	 * @return the byte[]
	 */
	public static byte[] subbyte(String arrayStr, int start, int end) {
		return ArrayUtil.subbyte(arrayStr, start, end, CmnConst.CHARSET);
	}

	/**
	 * Adds the.
	 *
	 * @param array1 the array1
	 * @param array2 the array2
	 * @return the byte[]
	 */
	public static byte[] add(byte[] array1, byte[] array2) {
		return ArrayUtils.addAll(array1, array2);
	}

	/**
	 * Adds the.
	 *
	 * @param arrays the arrays
	 * @return the byte[]
	 */
	public static byte[] add(byte[]... arrays) {
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		if(arrays != null) {
			for(byte[] array : arrays) {
				if(array != null) {
					baos.write(array, 0, array.length);
				}
			}
		}
		return baos.toByteArray();
	}

	/**
	 * Adds the.
	 *
	 * @param element1 the element1
	 * @param element2 the element2
	 * @return the byte[]
	 */
	public static byte[] add(byte element1, byte element2) {
		byte[] arrays = new byte[2];
		arrays[0] = element1;
		arrays[1] = element2;
		return arrays;
	}

	/**
	 * Adds the.
	 *
	 * @param arrays the arrays
	 * @return the byte[]
	 */
	public static byte[] add(byte... arrays) {
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		if(arrays != null) {
			for(byte array : arrays) {
				baos.write(array);
			}
		}
		return baos.toByteArray();
	}

	/**
	 * Adds the.
	 *
	 * @param array the array
	 * @param element the element
	 * @return the byte[]
	 */
	public static byte[] add(byte[] array, byte element) {
		return ArrayUtils.add(array, element);
	}

	/**
	 * Adds the.
	 *
	 * @param element the element
	 * @param array the array
	 * @return the byte[]
	 */
	public static byte[] add(byte element, byte[] array) {
		if(array == null) {
			return new byte[]{element};
		}
		byte[] newArray = new byte[1 + array.length];
		newArray[0] = element;
		System.arraycopy(array, 0, newArray, 1, array.length);
		return newArray;
	}

}
