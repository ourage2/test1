package com.enpem.web.common.util.crypto;

public class SeedUtil {

	public static final String TRANSFORMATION_MODE_CBC = "CBC";
	public static final String TRANSFORMATION_MODE_ECB = "ECB";
	public static final String TRANSFORMATION_MODE_CTR = "CTR";

	/**
	 * Encrypt.
	 *
	 * @param data the data
	 * @param key the key
	 * @param iv the iv
	 * @param transformationMode the transformation mode
	 * @return the byte[]
	 */
	public static byte[] encrypt(byte[] data, byte[] key, byte[] iv, String transformationMode) {
		byte[] encryptByte = null;
		if(iv == null || TRANSFORMATION_MODE_ECB.equals(transformationMode)) {
			encryptByte = KisaSeed.SEED_ECB_Encrypt(key, data, 0, data.length);
		} else if(TRANSFORMATION_MODE_CTR.equals(transformationMode)) {
			encryptByte = KisaSeed.SEED_CTR_Encrypt(key, iv, data, 0, data.length);
		} else {
			encryptByte = KisaSeed.SEED_CBC_Encrypt(key, iv, data, 0, data.length);
		}
		return encryptByte;
	}

	/**
	 * Encrypt.
	 *
	 * @param data the data
	 * @param key the key
	 * @param iv the iv
	 * @return the byte[]
	 */
	public static byte[] encrypt(byte[] data, byte[] key, byte[] iv) {
		return encrypt(data, key, iv, null);
	}

	/**
	 * Encrypt.
	 *
	 * @param data the data
	 * @param key the key
	 * @param transformationMode the transformation mode
	 * @return the byte[]
	 */
	public static byte[] encrypt(byte[] data, byte[] key, String transformationMode) {
		return encrypt(data, key, null, transformationMode);
	}

	/**
	 * Encrypt.
	 *
	 * @param data the data
	 * @param key the key
	 * @return the byte[]
	 */
	public static byte[] encrypt(byte[] data, byte[] key) {
		return encrypt(data, key, null, null);
	}

	/**
	 * Encrypt base64.
	 *
	 * @param data the data
	 * @param key the key
	 * @param iv the iv
	 * @param transformationMode the transformation mode
	 * @return the string
	 */
	public static String encryptString(byte[] data, byte[] key, byte[] iv, String transformationMode) {
		return Base64Util.encodeString(encrypt(data, key, iv, transformationMode));
	}

	/**
	 * Encrypt base64.
	 *
	 * @param data the data
	 * @param key the key
	 * @param iv the iv
	 * @return the string
	 */
	public static String encryptString(byte[] data, byte[] key, byte[] iv) {
		return encryptString(data, key, iv, null);
	}

	/**
	 * Encrypt base64.
	 *
	 * @param data the data
	 * @param key the key
	 * @param transformationMode the transformation mode
	 * @return the string
	 */
	public static String encryptString(byte[] data, byte[] key, String transformationMode) {
		return encryptString(data, key, null, transformationMode);
	}

	/**
	 * Encrypt base64.
	 *
	 * @param data the data
	 * @param key the key
	 * @return the string
	 */
	public static String encryptString(byte[] data, byte[] key) {
		return encryptString(data, key, null, null);
	}

	/**
	 * Decrypt.
	 *
	 * @param data the data
	 * @param key the key
	 * @param iv the iv
	 * @param transformationMode the transformation mode
	 * @return the byte[]
	 */
	public static byte[] decrypt(byte[] data, byte[] key, byte[] iv, String transformationMode) {
		byte[] decryptByte = null;
		if(iv == null || TRANSFORMATION_MODE_ECB.equals(transformationMode)) {
			decryptByte = KisaSeed.SEED_ECB_Decrypt(key, data, 0, data.length);
		} else if(TRANSFORMATION_MODE_CTR.equals(transformationMode)) {
			decryptByte = KisaSeed.SEED_CTR_Decrypt(key, iv, data, 0, data.length);
		} else {
			decryptByte = KisaSeed.SEED_CBC_Decrypt(key, iv, data, 0, data.length);
		}
		return decryptByte;
	}

	/**
	 * Decrypt.
	 *
	 * @param data the data
	 * @param key the key
	 * @param iv the iv
	 * @return the byte[]
	 */
	public static byte[] decrypt(byte[] data, byte[] key, byte[] iv) {
		return decrypt(data, key, iv, null);
	}

	/**
	 * Decrypt.
	 *
	 * @param data the data
	 * @param key the key
	 * @param transformationMode the transformation mode
	 * @return the byte[]
	 */
	public static byte[] decrypt(byte[] data, byte[] key, String transformationMode) {
		return decrypt(data, key, null, transformationMode);
	}

	/**
	 * Decrypt.
	 *
	 * @param data the data
	 * @param key the key
	 * @return the byte[]
	 */
	public static byte[] decrypt(byte[] data, byte[] key) {
		return decrypt(data, key, null, null);
	}

	/**
	 * Decrypt string.
	 *
	 * @param data the data
	 * @param key the key
	 * @param iv the iv
	 * @param transformationMode the transformation mode
	 * @return the string
	 */
	public static String decryptString(byte[] data, byte[] key, byte[] iv, String transformationMode) {
		return new String(decrypt(data, key, iv, transformationMode));
	}

	/**
	 * Decrypt string.
	 *
	 * @param data the data
	 * @param key the key
	 * @param iv the iv
	 * @return the string
	 */
	public static String decryptString(byte[] data, byte[] key, byte[] iv) {
		return decryptString(data, key, iv, null);
	}

	/**
	 * Decrypt string.
	 *
	 * @param data the data
	 * @param key the key
	 * @param transformationMode the transformation mode
	 * @return the string
	 */
	public static String decryptString(byte[] data, byte[] key, String transformationMode) {
		return decryptString(data, key, null, transformationMode);
	}

	/**
	 * Decrypt string.
	 *
	 * @param data the data
	 * @param key the key
	 * @return the string
	 */
	public static String decryptString(byte[] data, byte[] key) {
		return decryptString(data, key, null, null);
	}

}
