package com.enpem.web.common.util.crypto;

public class AesUtil {

	private static final String TRANSFORMATION = "AES/CBC/PKCS5Padding";
	private static final String ALGORITHM = "AES";

	/**
	 * Encrypt.
	 *
	 * @param data the data
	 * @param key the key
	 * @param transformation the transformation
	 * @param algorithm the algorithm
	 * @param ivParameter the iv parameter
	 * @return the byte[]
	 */
	public static byte[] encrypt(byte[] data, byte[] key, String transformation, String algorithm, byte[] ivParameter) {
		return CipherUtil.encrypt(data, key, transformation, algorithm, ivParameter);
	}

	/**
	 * Encrypt.
	 *
	 * @param data the data
	 * @param key the key
	 * @param transformation the transformation
	 * @param algorithm the algorithm
	 * @return the byte[]
	 */
	public static byte[] encrypt(byte[] data, byte[] key, String transformation, String algorithm) {
		return CipherUtil.encrypt(data, key, transformation, algorithm);
	}

	/**
	 * Encrypt.
	 *
	 * @param data the data
	 * @param key the key
	 * @param transformation the transformation
	 * @return the byte[]
	 */
	public static byte[] encrypt(byte[] data, byte[] key, String transformation) {
		return CipherUtil.encrypt(data, key, transformation, ALGORITHM);
	}

	/**
	 * Encrypt.
	 *
	 * @param data the data
	 * @param key the key
	 * @param ivParameter the iv parameter
	 * @return the byte[]
	 */
	public static byte[] encrypt(byte[] data, byte[] key, byte[] ivParameter) {
		return CipherUtil.encrypt(data, key, TRANSFORMATION, ALGORITHM, ivParameter);
	}

	/**
	 * Encrypt.
	 *
	 * @param data the data
	 * @param key the key
	 * @return the byte[]
	 */
	public static byte[] encrypt(byte[] data, byte[] key) {
		return CipherUtil.encrypt(data, key, TRANSFORMATION, ALGORITHM);
	}

	/**
	 * Encrypt.
	 *
	 * @param data the data
	 * @param key the key
	 * @return the byte[]
	 */
	public static String encryptString(String data, String key) {
		return Base64Util.encodeString(CipherUtil.encrypt(data.getBytes(), key.getBytes(), TRANSFORMATION, ALGORITHM));
	}

	/**
	 * Decrypt.
	 *
	 * @param data the data
	 * @param key the key
	 * @param transformation the transformation
	 * @param algorithm the algorithm
	 * @param ivParameter the iv parameter
	 * @return the byte[]
	 */
	public static byte[] decrypt(byte[] data, byte[] key, String transformation, String algorithm, byte[] ivParameter) {
		return CipherUtil.decrypt(data, key, transformation, algorithm, ivParameter);
	}

	/**
	 * Decrypt.
	 *
	 * @param data the data
	 * @param key the key
	 * @param transformation the transformation
	 * @param algorithm the algorithm
	 * @return the byte[]
	 */
	public static byte[] decrypt(byte[] data, byte[] key, String transformation, String algorithm) {
		return CipherUtil.decrypt(data, key, transformation, algorithm);
	}

	/**
	 * Decrypt.
	 *
	 * @param data the data
	 * @param key the key
	 * @param transformation the transformation
	 * @return the byte[]
	 */
	public static byte[] decrypt(byte[] data, byte[] key, String transformation) {
		return CipherUtil.decrypt(data, key, transformation, ALGORITHM);
	}

	/**
	 * Decrypt.
	 *
	 * @param data the data
	 * @param key the key
	 * @param ivParameter the iv parameter
	 * @return the byte[]
	 */
	public static byte[] decrypt(byte[] data, byte[] key, byte[] ivParameter) {
		return CipherUtil.decrypt(data, key, TRANSFORMATION, ALGORITHM, ivParameter);
	}

	/**
	 * Decrypt.
	 *
	 * @param data the data
	 * @param key the key
	 * @return the byte[]
	 */
	public static byte[] decrypt(byte[] data, byte[] key) {
		return CipherUtil.decrypt(data, key, TRANSFORMATION, ALGORITHM);
	}

	/**
	 * Decrypt.
	 *
	 * @param data the data
	 * @param key the key
	 * @return the byte[]
	 */
	public static String decryptString(String data, String key) {
		return new String(CipherUtil.decrypt(Base64Util.decode(data), key.getBytes(), TRANSFORMATION, ALGORITHM));
	}

}
