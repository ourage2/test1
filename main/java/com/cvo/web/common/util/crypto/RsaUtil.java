package com.enpem.web.common.util.crypto;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.security.Key;
import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.spec.KeySpec;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;

import javax.crypto.Cipher;

import com.enpem.web.common.exception.BaseException;

public class RsaUtil {

	public static final String TRANSFORMATION = "RSA/ECB/PKCS1Padding";
	private static final String ALGORITHM = "RSA";
	private static final int KEY_SIZE = 2048;

	/**
	 * Generator key.
	 *
	 * @param keySize the key size
	 * @return the string[]
	 */
	public static RsaConfig generatorKey(int keySize) {
		try {
			KeyPairGenerator keyPairGenerator = KeyPairGenerator.getInstance(ALGORITHM);
			keyPairGenerator.initialize(keySize);
			KeyPair keyPair = keyPairGenerator.genKeyPair();

			Key privateKey = keyPair.getPrivate();
			Key publicKey = keyPair.getPublic();

			RsaConfig rsaConfig = new RsaConfig();
			rsaConfig.setPrivateKey(privateKey);
			rsaConfig.setPublicKey(publicKey);

			return rsaConfig;
		} catch (Exception e) {
			throw new BaseException(e);
		}
	}

	/**
	 * Generator key.
	 *
	 * @return the string[]
	 */
	public static RsaConfig generatorKey() {
		return generatorKey(KEY_SIZE);
	}

	/**
	 * Encrypt.
	 *
	 * @param data the data
	 * @param pubKey the pub key
	 * @param keySize the key size
	 * @param transformation the transformation
	 * @param isReverse the is reverse
	 * @return the byte[]
	 */
	public static byte[] encrypt(byte[] data, byte[] pubKey, int keySize, String transformation, boolean isReverse) {
		ByteArrayOutputStream baos = null;
		try {
			KeySpec keySpec = null;
			if(isReverse) {
				keySpec = new PKCS8EncodedKeySpec(pubKey);
			} else {
				keySpec = new X509EncodedKeySpec(pubKey);
			}
			KeyFactory kf = KeyFactory.getInstance(ALGORITHM);

			Key publicKey = null;
			if(isReverse) {
				publicKey = kf.generatePrivate(keySpec);
			} else {
				publicKey = kf.generatePublic(keySpec);
			}

			Cipher cipher = Cipher.getInstance(transformation);
			cipher.init(Cipher.ENCRYPT_MODE, publicKey);

			baos = new ByteArrayOutputStream();
			byte[] tmp = null;
			int curIndex = 0;
			int dataLength = data.length;
			int blockSize = keySize / 8 - 11;
			while (true) {
				tmp = null;
				if (dataLength == 0) {
					break;
				}
				if (dataLength <= blockSize) {
					tmp = new byte[dataLength];
					System.arraycopy(data, curIndex, tmp, 0, dataLength);
					baos.write(cipher.doFinal(tmp));
					break;
				}
				tmp = new byte[blockSize];
				System.arraycopy(data, curIndex, tmp, 0, blockSize);
				baos.write(cipher.doFinal(tmp));

				dataLength -= blockSize;
				curIndex += blockSize;
			}
			return baos.toByteArray();
		} catch (Exception e) {
			throw new BaseException(e);
		} finally {
			if(baos != null) {
				try {
					baos.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}

	/**
	 * Encrypt.
	 *
	 * @param data the data
	 * @param pubKey the pub key
	 * @param keySize the key size
	 * @param transformation the transformation
	 * @return the byte[]
	 */
	public static byte[] encrypt(byte[] data, byte[] pubKey, int keySize, String transformation) {
		return encrypt(data, pubKey, keySize, transformation, false);
	}

	/**
	 * Encrypt.
	 *
	 * @param data the data
	 * @param pubKey the pub key
	 * @param keySize the key size
	 * @return the byte[]
	 */
	public static byte[] encrypt(byte[] data, byte[] pubKey, int keySize) {
		return encrypt(data, pubKey, keySize, TRANSFORMATION, false);
	}

	/**
	 * Encrypt.
	 *
	 * @param data the data
	 * @param pubKey the pub key
	 * @return the byte[]
	 */
	public static byte[] encrypt(byte[] data, byte[] pubKey) {
		return encrypt(data, pubKey, KEY_SIZE, TRANSFORMATION, false);
	}

	/**
	 * Encrypt.
	 *
	 * @param data the data
	 * @param pubKey the pub key
	 * @return the byte[]
	 */
	public static byte[] encrypt(String data, byte[] pubKey) {
		return encrypt(data.getBytes(), pubKey);
	}

	/**
	 * Encrypt.
	 *
	 * @param data the data
	 * @param pubKey the pub key
	 * @return the byte[]
	 */
	public static byte[] encrypt(byte[] data, String pubKey) {
		return encrypt(data, Base64Util.decode(pubKey));
	}

	/**
	 * Encrypt.
	 *
	 * @param data the data
	 * @param pubKey the pub key
	 * @return the byte[]
	 */
	public static byte[] encrypt(String data, String pubKey) {
		return encrypt(data.getBytes(), pubKey);
	}

	/**
	 * Encrypt string.
	 *
	 * @param data the data
	 * @param pubKey the pub key
	 * @param keySize the key size
	 * @param transformation the transformation
	 * @param isReverse the is reverse
	 * @return the string
	 */
	public static String encryptString(byte[] data, byte[] pubKey, int keySize, String transformation, boolean isReverse) {
		return Base64Util.encodeString(encrypt(data, pubKey, keySize, transformation, isReverse));
	}

	/**
	 * Encrypt string.
	 *
	 * @param data the data
	 * @param pubKey the pub key
	 * @param keySize the key size
	 * @param transformation the transformation
	 * @return the string
	 */
	public static String encryptString(byte[] data, byte[] pubKey, int keySize, String transformation) {
		return encryptString(data, pubKey, keySize, transformation, false);
	}

	/**
	 * Encrypt string.
	 *
	 * @param data the data
	 * @param pubKey the pub key
	 * @param keySize the key size
	 * @return the string
	 */
	public static String encryptString(byte[] data, byte[] pubKey, int keySize) {
		return encryptString(data, pubKey, keySize, TRANSFORMATION, false);
	}

	/**
	 * Encrypt string.
	 *
	 * @param data the data
	 * @param pubKey the pub key
	 * @return the string
	 */
	public static String encryptString(byte[] data, byte[] pubKey) {
		return encryptString(data, pubKey, KEY_SIZE, TRANSFORMATION, false);
	}

	/**
	 * Encrypt string.
	 *
	 * @param data the data
	 * @param pubKey the pub key
	 * @return the string
	 */
	public static String encryptString(String data, byte[] pubKey) {
		return encryptString(data.getBytes(), pubKey);
	}

	/**
	 * Encrypt string.
	 *
	 * @param data the data
	 * @param pubKey the pub key
	 * @return the string
	 */
	public static String encryptString(byte[] data, String pubKey) {
		return encryptString(data, Base64Util.decode(pubKey));
	}

	/**
	 * Encrypt string.
	 *
	 * @param data the data
	 * @param pubKey the pub key
	 * @return the string
	 */
	public static String encryptString(String data, String pubKey) {
		return encryptString(data.getBytes(), pubKey);
	}

	/**
	 * Decrypt.
	 *
	 * @param data the data
	 * @param priKey the pri key
	 * @param keySize the key size
	 * @param transformation the transformation
	 * @param isReverse the is reverse
	 * @return the byte[]
	 */
	public static byte[] decrypt(byte[] data, byte[] priKey, int keySize, String transformation, boolean isReverse) {
		ByteArrayOutputStream baos = null;
		try {
			KeySpec keySpec = null;
			if(isReverse) {
				keySpec = new X509EncodedKeySpec(priKey);
			} else {
				keySpec = new PKCS8EncodedKeySpec(priKey);
			}

			KeyFactory kf = KeyFactory.getInstance(ALGORITHM);

			Key privateKey = null;
			if(isReverse) {
				privateKey = kf.generatePublic(keySpec);
			} else {
				privateKey = kf.generatePrivate(keySpec);
			}

			Cipher cipher = Cipher.getInstance(transformation);
			cipher.init(Cipher.DECRYPT_MODE, privateKey);

			baos = new ByteArrayOutputStream();
			byte[] tmp = null;
			int curIndex = 0;
			int dataLength = data.length;
			int blockSize = keySize / 8;

			while (true) {
				tmp = null;
				if (dataLength == 0) {
					break;
				}
				if (dataLength <= blockSize) {
					tmp = new byte[dataLength];
					System.arraycopy(data, curIndex, tmp, 0, dataLength);
					baos.write(cipher.doFinal(tmp));
					break;
				}
				tmp = new byte[blockSize];
				System.arraycopy(data, curIndex, tmp, 0, blockSize);
				baos.write(cipher.doFinal(tmp));

				dataLength -= blockSize;
				curIndex += blockSize;
			}
			return baos.toByteArray();
		} catch (Exception e) {
			throw new BaseException(e);
		} finally {
			if(baos != null) {
				try {
					baos.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}

	/**
	 * Decrypt.
	 *
	 * @param data the data
	 * @param priKey the pri key
	 * @param keySize the key size
	 * @param transformation the transformation
	 * @return the byte[]
	 */
	public static byte[] decrypt(byte[] data, byte[] priKey, int keySize, String transformation) {
		return decrypt(data, priKey, keySize, transformation, false);
	}

	/**
	 * Decrypt.
	 *
	 * @param data the data
	 * @param priKey the pri key
	 * @param keySize the key size
	 * @return the byte[]
	 */
	public static byte[] decrypt(byte[] data, byte[] priKey, int keySize) {
		return decrypt(data, priKey, keySize, TRANSFORMATION, false);
	}

	/**
	 * Decrypt.
	 *
	 * @param data the data
	 * @param priKey the pri key
	 * @return the byte[]
	 */
	public static byte[] decrypt(byte[] data, byte[] priKey) {
		return decrypt(data, priKey, KEY_SIZE, TRANSFORMATION, false);
	}

	/**
	 * Decrypt.
	 *
	 * @param data the data
	 * @param priKey the pri key
	 * @return the byte[]
	 */
	public static byte[] decrypt(String data, byte[] priKey) {
		return decrypt(data.getBytes(), priKey);
	}

	/**
	 * Decrypt.
	 *
	 * @param data the data
	 * @param priKey the pri key
	 * @return the byte[]
	 */
	public static byte[] decrypt(byte[] data, String priKey) {
		return decrypt(data, Base64Util.decode(priKey));
	}

	/**
	 * Decrypt.
	 *
	 * @param data the data
	 * @param priKey the pri key
	 * @return the byte[]
	 */
	public static byte[] decrypt(String data, String priKey) {
		return decrypt(data.getBytes(), priKey);
	}



	/**
	 * Decrypt string.
	 *
	 * @param data the data
	 * @param priKey the pri key
	 * @param keySize the key size
	 * @param transformation the transformation
	 * @param isReverse the is reverse
	 * @return the string
	 */
	public static String decryptString(byte[] data, byte[] priKey, int keySize, String transformation, boolean isReverse) {
		return new String(decrypt(data, priKey, keySize, transformation, isReverse));
	}

	/**
	 * Decrypt string.
	 *
	 * @param data the data
	 * @param priKey the pri key
	 * @param keySize the key size
	 * @param transformation the transformation
	 * @return the string
	 */
	public static String decryptString(byte[] data, byte[] priKey, int keySize, String transformation) {
		return decryptString(data, priKey, keySize, transformation, false);
	}

	/**
	 * Decrypt string.
	 *
	 * @param data the data
	 * @param priKey the pri key
	 * @param keySize the key size
	 * @return the string
	 */
	public static String decryptString(byte[] data, byte[] priKey, int keySize) {
		return decryptString(data, priKey, keySize, TRANSFORMATION, false);
	}

	/**
	 * Decrypt string.
	 *
	 * @param data the data
	 * @param priKey the pri key
	 * @return the string
	 */
	public static String decryptString(byte[] data, byte[] priKey) {
		return decryptString(data, priKey, KEY_SIZE, TRANSFORMATION, false);
	}

	/**
	 * Decrypt string.
	 *
	 * @param data the data
	 * @param priKey the pri key
	 * @return the string
	 */
	public static String decryptString(String data, byte[] priKey) {
		return decryptString(data.getBytes(), priKey);
	}

	/**
	 * Decrypt string.
	 *
	 * @param data the data
	 * @param priKey the pri key
	 * @return the string
	 */
	public static String decryptString(byte[] data, String priKey) {
		return decryptString(data, Base64Util.decode(priKey));
	}

	/**
	 * Decrypt string.
	 *
	 * @param data the data
	 * @param priKey the pri key
	 * @return the string
	 */
	public static String decryptString(String data, String priKey) {
		return decryptString(data.getBytes(), priKey);
	}

}
