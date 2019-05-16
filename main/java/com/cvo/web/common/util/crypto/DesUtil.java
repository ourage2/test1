package com.enpem.web.common.util.crypto;

public class DesUtil {

	private static final String TRANSFORMATION = "DES/CBC/PKCS5Padding";
	private static final String TRANSFORMATION_TRIPLE = "DESede/ECB/PKCS5Padding";
	private static final String ALGORITHM = "DES";
	private static final String ALGORITHM_TRIPLE = "DESede";

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
	 * Encrypt triple.
	 *
	 * @param data the data
	 * @param key the key
	 * @return the byte[]
	 */
	public static byte[] encryptTriple(byte[] data, byte[] key) {
		return CipherUtil.encrypt(data, key, TRANSFORMATION_TRIPLE, ALGORITHM_TRIPLE);
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
	 * Decrypt triple.
	 *
	 * @param data the data
	 * @param key the key
	 * @return the byte[]
	 */
	public static byte[] decryptTriple(byte[] data, byte[] key) {
		return CipherUtil.decrypt(data, key, TRANSFORMATION_TRIPLE, ALGORITHM_TRIPLE);
	}

}
