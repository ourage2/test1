package com.enpem.web.common.util.crypto;

import java.security.MessageDigest;

import com.enpem.web.common.exception.BaseException;

public class DigestUtil {

	public static final String MD5 = "MD5";
	public static final String SHA1 = "SHA-1";
	public static final String SHA256 = "SHA-256";
	public static final String SHA512 = "SHA-512";


	/**
	 * Digest.
	 *
	 * @param data the data
	 * @param algorithm the algorithm
	 * @return the byte[]
	 */
	public static byte[] digest(byte[] data, String algorithm) {
		try {
			MessageDigest md = MessageDigest.getInstance(algorithm);
			md.update(data);
			return md.digest();
		} catch (Exception e) {
			throw new BaseException(e);
		}
	}

	/**
	 * Digest.
	 *
	 * @param data the data
	 * @param algorithm the algorithm
	 * @return the byte[]
	 */
	public static byte[] digest(String data, String algorithm) {
		return digest(data.getBytes(), algorithm);
	}

	/**
	 * Digest to str.
	 *
	 * @param data the data
	 * @param algorithm the algorithm
	 * @return the string
	 */
	public static String digestToStr(byte[] data, String algorithm) {
		try {
			byte dataByte[] = digest(data, algorithm);
			StringBuffer hexSb = new StringBuffer();
			for(int i=0, s=dataByte.length; i<s; i++) {
				hexSb.append(Integer.toString((dataByte[i]&0xff) + 0x100, 16).substring(1));
			}
			return hexSb.toString();
		} catch (Exception e) {
			throw new BaseException(e);
		}
	}

	/**
	 * Digest.
	 *
	 * @param data the data
	 * @param algorithm the algorithm
	 * @return the string
	 */
	public static String digestToStr(String data, String algorithm) {
		return digestToStr(data.getBytes(), algorithm);
	}

	/**
	 * Md5.
	 *
	 * @param data the data
	 * @return the string
	 */
	public static String md5(byte[] data) {
		return digestToStr(data, MD5);
	}

	/**
	 * Md5.
	 *
	 * @param data the data
	 * @return the string
	 */
	public static String md5(String data) {
		return md5(data.getBytes());
	}

	/**
	 * Sha1.
	 *
	 * @param data the data
	 * @return the string
	 */
	public static String sha1(byte[] data) {
		return digestToStr(data, SHA1);
	}

	/**
	 * Sha1.
	 *
	 * @param data the data
	 * @return the string
	 */
	public static String sha1(String data) {
		return sha1(data.getBytes());
	}

	/**
	 * Sha256.
	 *
	 * @param data the data
	 * @return the byte[]
	 */
	public static byte[] sha256(byte[] data) {
		return digest(data, SHA256);
	}

	/**
	 * Sha256.
	 *
	 * @param data the data
	 * @return the string
	 */
	public static String sha256ToStr(byte[] data) {
		return digestToStr(data, SHA256);
	}

	/**
	 * Sha256.
	 *
	 * @param data the data
	 * @return the string
	 */
	public static String sha256ToStr(String data) {
		return sha256ToStr(data.getBytes());
	}

	/**
	 * Sha256 salt.
	 *
	 * @param data the data
	 * @param salt the salt
	 * @return the string
	 */
	public static String sha256Salt(String data, String salt) {
		String sha = "";
		try {
			MessageDigest sh = MessageDigest.getInstance(SHA256);
			sh.reset();
			sh.update(salt.getBytes());
			byte byteData[] = sh.digest(data.getBytes());

			sh.reset();
			byteData = sh.digest(byteData);

			StringBuffer sb = new StringBuffer();
			for (int i = 0; i < byteData.length; i++) {
				sb.append(Integer.toString((byteData[i] & 0xff) + 0x100, 16).substring(1));
			}
			sha = Base64Util.encodeString(sb.toString());
		} catch (Exception e) {
			throw new BaseException(e);
		}
		return sha;
	}

	/**
	 * Sha512.
	 *
	 * @param data the data
	 * @return the byte[]
	 */
	public static byte[] sha512(byte[] data) {
		return digest(data, SHA512);
	}

	/**
	 * Sha512.
	 *
	 * @param data the data
	 * @return the string
	 */
	public static String sha512ToStr(byte[] data) {
		return digestToStr(data, SHA512);
	}

	/**
	 * Sha512.
	 *
	 * @param data the data
	 * @return the string
	 */
	public static String sha512ToStr(String data) {
		return sha512ToStr(data.getBytes());
	}

}
