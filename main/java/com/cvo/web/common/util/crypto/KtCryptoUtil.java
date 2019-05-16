package com.enpem.web.common.util.crypto;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

public class KtCryptoUtil {

	private static byte[] blockKey = new byte[] { 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a' };

	/**
	 * Decode imsi passwd.
	 *
	 * @param ImsiNo
	 *            the imsi no
	 * @return the string
	 */
	public String DecodeImsiPasswd(String ImsiNo) {
		// [BEGIN_VIRTUAL_FUNCTION, DecodeImsiPasswd]
		int nW[] = { 6, 4, 9, 7, 2, 8, 3, 10, 5, 1 };
		int nSumL = 0;
		// int nL = 0;
		int nSumK = 0;
		// int nK = 0;
		int i;
		// char szK[] = {0,0,0,0,0,0,0,0,0,0,0};
		// char szP[] = {0,0,0,0,0,0,0,0,0,0,0};

		int szK[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
		int szP[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
		StringBuffer sbK = new StringBuffer();
		StringBuffer sbP = new StringBuffer();

		char[] szInImsiNo = ImsiNo.toCharArray();

		// System.out.println("nSumL + START");
		for (i = 0; i < 10; i++) {
			nSumL += (int) (szInImsiNo[i + 5] - '0');
			// System.out.println(nSumL);
		}

		// System.out.println("szK[i + START");
		for (i = 0; i < 10; i++) {
			szK[i] = ((nSumL + (int) (szInImsiNo[i + 5] - '0') + nW[i]) * nW[i]) % 10 + '0';
			sbK.append((char) szK[i]);
			// System.out.println( ((nSumL + (int)(szInImsiNo[i + 5] - '0') +
			// nW[i]) * nW[i]) % 10 + '0' );
		}

		// System.out.println("nSumK + + START");
		for (i = 0; i < 10; i++) {
			nSumK += (int) (szK[i] - '0');
			// System.out.println( nSumK );
		}

		// System.out.println("szP[i] + START");
		for (i = 0; i < 10; i++) {
			szP[i] = ((nSumK + (int) (szK[i] - '0') + nW[i]) * nW[i]) % 26 + 'a';
			sbP.append((char) szP[i]);
			// szP[i] = (char)(((nSumK + (int)(szK[i] - '0') + nW[i]) * nW[i]) %
			// 26 + 'a');
			// System.out.println( ((nSumK + (int)(szK[i] - '0') + nW[i]) *
			// nW[i]) % 26 + 'a' );
		}

		// System.out.println(sbK.toString()+sbP.toString());
		return sbK.toString() + sbP.toString();
		// [END_VIRTUAL_FUNCTION, DecodeImsiPasswd]
	}

	/**
	 * password, aeskey를 입력받아 AES128-CBC 방식으로 암호화한다.
	 *
	 * @param aeskey
	 *            : 암호화키
	 * @param password
	 *            : 암호화 대상칼럼
	 * @return String AES128 CBC 암호화
	 */
	public String getIdmsEncyptAESStringCBCByMD5(String aeskey, String password) {
		String encyptPassword = "";
		if (password == null || password.length() == 0) {
			return "";
		}
		try {
			password = getMd5EncodeHexString(password);

			byte[] cryptoKey = KtCryptoUtil.decodeHex(aeskey.toCharArray());

			// v2012.02 DR-2011-27069 by SSG 한글(2bytes)암호화처리를 위해 password 의
			// 바이트수/16 이 되도록 변경처리함.
			// int blen = password.length()/16;
			int blen = password.getBytes().length / 16;
			if ((password.length() % 16) > 0)
				blen = blen + 1;

			byte[] passwd = new byte[16 * blen];
			byte[] originalData = password.getBytes();
			System.arraycopy(originalData, 0, passwd, 0, originalData.length);

			encyptPassword = getEncyptAESStringBykeyCBC(cryptoKey, blockKey, passwd);

			return encyptPassword;
		} catch (Exception e) {
			return encyptPassword;
		}
	}

	/**
	 * password, aeskey를 입력받아 AES128-CBC 방식으로 암호화한다.
	 *
	 * @param aeskey
	 *            : 암호화키
	 * @param password
	 *            : 암호화 대상칼럼
	 * @return String AES128 CBC 암호화
	 */
	public String getIdmsEncyptAESStringCBC(String aeskey, String password) {
		String encyptPassword = "";
		if (password == null || password.length() == 0) {
			return "";
		}
		try {

			byte[] cryptoKey = KtCryptoUtil.decodeHex(aeskey.toCharArray());

			// v2012.02 DR-2011-27069 by SSG 한글(2bytes)암호화처리를 위해 password 의
			// 바이트수/16 이 되도록 변경처리함.
			// int blen = password.length()/16;
			int blen = password.getBytes().length / 16;
			if ((password.length() % 16) > 0)
				blen = blen + 1;

			byte[] passwd = new byte[16 * blen];
			byte[] originalData = password.getBytes();
			System.arraycopy(originalData, 0, passwd, 0, originalData.length);

			encyptPassword = getEncyptAESStringBykeyCBC(cryptoKey, blockKey, passwd);

			return encyptPassword;
		} catch (Exception e) {
			return encyptPassword;
		}
	}

	/**
	 * Gets the encypt aes string bykey cbc.
	 *
	 * @param cryptoKey
	 *            the crypto key
	 * @param blockKey
	 *            the block key
	 * @param passwd
	 *            the passwd
	 * @return the encypt aes string bykey cbc
	 */
	private static String getEncyptAESStringBykeyCBC(byte[] cryptoKey, byte[] blockKey, byte[] passwd) {
		try {
			SecretKeySpec skeySpec = new SecretKeySpec(cryptoKey, "AES");
			// Cipher cipher = Cipher.getInstance("AES/CBC/NoPadding");
			Cipher cipher = Cipher.getInstance("AES/CBC/NoPadding");
			byte[] ivSpecB = new byte[] { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };

			IvParameterSpec ivSpec = new IvParameterSpec(ivSpecB);
			cipher.init(Cipher.ENCRYPT_MODE, skeySpec, ivSpec);
			byte[] encrypted = cipher.doFinal(passwd);
			return new String(encodeHex(encrypted)).toUpperCase();
		} catch (Exception e) {
			return "";
		}
	}

	//////////////// [IMS]-END ///////////////////////////////////
	/**
	 * svc_no 를 받아 puid 형식으로 변경하여 return 한다.
	 *
	 * @param aeskey
	 *            the aeskey
	 * @param password
	 *            the password
	 * @return puid puid type으로 변경 된 번호
	 */
	public static String getEncyptAESString(String aeskey, String password) {
		String encyptPassword = "";
		if (password == null || password.length() == 0) {
			return encyptPassword;
		}
		try {
			byte[] cryptoKey = KtCryptoUtil.decodeHex(aeskey.toCharArray());
			byte[] passwd = new byte[16];
			byte[] originalData = password.getBytes();
			System.arraycopy(originalData, 0, passwd, 0, originalData.length);
			encyptPassword = getEncyptAESStringBykey(cryptoKey, blockKey, passwd);
			return encyptPassword;
		} catch (Exception e) {
			return encyptPassword;
		}
	}

	/**
	 * IMSI 를 받아 puid 형식으로 변경하여 return 한다..
	 *
	 * @param aeskey
	 *            the aeskey
	 * @param password
	 *            the password
	 * @return puid puid type으로 변경 된 번호
	 */
	public String getIdmsEncyptAESString(String aeskey, String password) {
		String encyptPassword = "";
		if (password == null || password.length() == 0) {
			return "";
		}
		try {

			byte[] cryptoKey = KtCryptoUtil.decodeHex(aeskey.toCharArray());

			// v2012.02 DR-2011-27069 by SSG 한글(2bytes)암호화처리를 위해 password 의
			// 바이트수/16 이 되도록 변경처리함.
			// int blen = password.length()/16;
			int blen = password.getBytes().length / 16;
			if ((password.length() % 16) > 0)
				blen = blen + 1;

			byte[] passwd = new byte[16 * blen];
			byte[] originalData = password.getBytes();
			System.arraycopy(originalData, 0, passwd, 0, originalData.length);

			encyptPassword = getEncyptAESStringBykey(cryptoKey, blockKey, passwd);

			return encyptPassword;
		} catch (Exception e) {
			return encyptPassword;
		}
	}

	/**
	 * Gets the decypt aes string.
	 *
	 * @param aeskey
	 *            the aeskey
	 * @param password
	 *            the password
	 * @return the decypt aes string
	 */
	public static String getDecyptAESString(String aeskey, String password) {
		String encyptPassword = "";
		if (password == null || password.length() == 0) {
			return encyptPassword;
		}
		try {
			byte[] cryptoKey = KtCryptoUtil.decodeHex(aeskey.toCharArray());
			encyptPassword = getDecyptAESString(cryptoKey, blockKey, password);
			return encyptPassword;
		} catch (Exception e) {
			return encyptPassword;
		}
	}

	/**
	 * Gets the encypt sha string.
	 *
	 * @param password
	 *            the password
	 * @return the encypt sha string
	 */
	public String getEncyptSHAString(String password) {
		String encyptPassword = "";
		if (password == null || password.length() == 0) {
			return "";
		}

		try {

			byte[] originalData = password.getBytes();

			encyptPassword = getSha1EncodeHexString(originalData);

			return encyptPassword;
		} catch (Exception e) {
			return encyptPassword;
		}
	}

	/**
	 * Gets the encypt aes string bykey.
	 *
	 * @param cryptoKey
	 *            the crypto key
	 * @param blockKey
	 *            the block key
	 * @param passwd
	 *            the passwd
	 * @return the encypt aes string bykey
	 */
	private static String getEncyptAESStringBykey(byte[] cryptoKey, byte[] blockKey, byte[] passwd) {
		try {
			SecretKeySpec skeySpec = new SecretKeySpec(cryptoKey, "AES");
			Cipher cipher = Cipher.getInstance("AES/ECB/NoPadding");
			cipher.init(Cipher.ENCRYPT_MODE, skeySpec);
			byte[] encrypted = cipher.doFinal(passwd);
			return new String(encodeHex(encrypted)).toUpperCase();
		} catch (Exception e) {
			return "";
		}
	}

	/**
	 * Gets the decypt aes string.
	 *
	 * @param cryptoKey
	 *            the crypto key
	 * @param blockKey
	 *            the block key
	 * @param cryptData
	 *            the crypt data
	 * @return the decypt aes string
	 */
	private static String getDecyptAESString(byte[] cryptoKey, byte[] blockKey, String cryptData) {
		try {
			byte[] original = new byte[] { '\0' };
			SecretKeySpec skeySpec = new SecretKeySpec(cryptoKey, "AES");
			Cipher cipher = Cipher.getInstance("AES/ECB/NoPadding");
			cipher.init(Cipher.DECRYPT_MODE, skeySpec);
			byte[] encrypted = decodeHex(cryptData.toCharArray());
			original = cipher.doFinal(encrypted);

			// 2014.02.11 add N-STEP 재배포~
			String decyptString = "";
			if (new String(original).indexOf('\0') > 0) {
				decyptString = new String(original).substring(0, new String(original).indexOf('\0'));
			} else {
				decyptString = new String(original).substring(0, new String(original).length());
			}
			return decyptString;
		} catch (Exception e) {
			return "";
		}
	}

	/**
	 * Gets the md5 string.
	 *
	 * @param passwd
	 *            the passwd
	 * @return the md5 string
	 */
	private static String getMd5String(String passwd) {
		try {
			byte[] md5Byte = md5(passwd.getBytes());
			return new String(md5Byte);

		} catch (Exception e) {
			return "";
		}
	}

	/**
	 * Gets the md5 encode hex string.
	 *
	 * @param passwd
	 *            the passwd
	 * @return the md5 encode hex string
	 */
	private static String getMd5EncodeHexString(String passwd) {
		try {
			byte[] md5Byte = md5(passwd.getBytes());
			return new String(encodeHex(md5Byte)).toUpperCase();
		} catch (Exception e) {
			return "";
		}
	}

	/**
	 * Gets the sha1 encode hex string.
	 *
	 * @param passwd
	 *            the passwd
	 * @return the sha1 encode hex string
	 */
	private static String getSha1EncodeHexString(byte[] passwd) {
		try {
			byte[] sha1Byte = sha1(passwd);
			return new String(encodeHex(sha1Byte)).toUpperCase();
		} catch (Exception e) {
			return "";
		}
	}

	/**
	 * Gets the md5 decode hex string.
	 *
	 * @param HexPasswd
	 *            the hex passwd
	 * @return the md5 decode hex string
	 */
	private static String getMd5DecodeHexString(String HexPasswd) {
		try {
			return new String(decodeHex(HexPasswd.toCharArray()));
		} catch (Exception e) {
			return "";
		}
	}

	/**
	 * Gets the md5 encode base64 string.
	 *
	 * @param passwd
	 *            the passwd
	 * @return the md5 encode base64 string
	 */
	private static String getMd5EncodeBase64String(String passwd) {
		try {
			byte[] md5Byte = md5(passwd.getBytes());
			return new String(encode(md5Byte));
		} catch (Exception e) {
			return "";
		}
	}

	/**
	 * Gets the md5 decode base64 string.
	 *
	 * @param Base64passwd
	 *            the base64passwd
	 * @return the md5 decode base64 string
	 */
	private static String getMd5DecodeBase64String(String Base64passwd) {
		try {
			return new String(decode(Base64passwd.toCharArray()));
		} catch (Exception e) {
			return "";
		}
	}

	/*********** Base 64 ************/
	// 0 - 64 의 index 값을 갖는 char[] 을 만들자.
	static char[] base64Map = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=".toCharArray();
	// Base64의 0~63(64는 '=')의 값을 매핑 시켜줄 테이블
	static private byte[] codes = new byte[256];

	static {
		for (int i = 'A'; i <= 'Z'; i++) {
			codes[i] = (byte) (i - 'A');
		}
		for (int i = 'a'; i <= 'z'; i++) {
			codes[i] = (byte) (26 + i - 'a');
		}
		for (int i = '0'; i <= '9'; i++) {
			codes[i] = (byte) (52 + i - '0');
		}
		codes['+'] = 62;
		codes['/'] = 63;
	}

	/**
	 * Encode.
	 *
	 * @param data
	 *            the data
	 * @return the char[]
	 */
	private static char[] encode(byte[] data) {
		return encode(data, 0, data.length);
	}

	/**
	 * byte[] 을 Base64 Encoding 시키는 method.
	 *
	 * @param data
	 *            Encoding 시킬 byte 배열
	 * @param offset
	 *            the offset
	 * @param len
	 *            the len
	 * @return Base64 encode 된 char[]
	 */
	private static char[] encode(byte[] data, int offset, int len) {
		// 3byte의 4개 char로의 배열 생성
		char[] encodedChars = new char[((len + 2) / 3) * 4];

		boolean threeChars = false;
		boolean fourChars = false;

		for (int i = 0, index = 0; i < len; i += 3, index += 4) {
			threeChars = false;
			fourChars = false;

			int val = (0xFF & (int) data[i]);
			val <<= 8;
			if ((i + 1) < len) {
				val |= (0xFF & (int) data[i + 1]);
				threeChars = true;
			}
			val <<= 8;
			if ((i + 2) < len) {
				val |= (0xFF & (int) data[i + 2]);
				fourChars = true;
			}
			encodedChars[index + 3] = base64Map[(fourChars ? (val & 0x3F) : 64)];
			val >>= 6;
			encodedChars[index + 2] = base64Map[(threeChars ? (val & 0x3F) : 64)];
			val >>= 6;
			encodedChars[index + 1] = base64Map[val & 0x3F];
			val >>= 6;
			encodedChars[index + 0] = base64Map[val & 0x3F];
		}
		return encodedChars;
	}

	/**
	 * Decode.
	 *
	 * @param data
	 *            the data
	 * @return the byte[]
	 */
	private static byte[] decode(char[] data) {
		return decode(data, 0, data.length);
	}

	/**
	 * char[] 을 Base64 Decoding 시키는 method.
	 *
	 * @param data
	 *            Decoding 시킬 char 배열
	 * @param offset
	 *            the offset
	 * @param len
	 *            the len
	 * @return Base64 decode 된 byte[]
	 */
	private static byte[] decode(char[] data, int offset, int len) {
		int tempLen = len;
		for (int idx = 0; idx < len; idx++) {
			// Base64 char 로서 유효하지 않는 데이터를 무시하자
			if ((data[idx] > 255) || codes[data[idx]] < 0)
				--tempLen;
		}

		int len2 = (tempLen / 4) * 3;
		if ((tempLen % 4) == 3)
			len2 += 2;
		if ((tempLen % 4) == 2)
			len2 += 1;

		byte[] out = new byte[len2];

		int shift = 0;
		int accum = 0;
		int index = 0;

		for (int ix = 0; ix < len; ix++) {
			int value = (data[ix] > 255) ? -1 : codes[data[ix]];

			if (value >= 0) { // 유효한 데이터만
				accum <<= 6; // 6비트씩 left-shift
				shift += 6;
				accum |= value;
				if (shift >= 8) {
					shift -= 8;
					out[index++] = (byte) ((accum >> shift) & 0xff);
				}
			}
		}
		return out;
	}

	/**************************************************************/
	/**
	 * Used building output as Hex
	 */
	private static final char[] DIGITS = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e',
			'f' };

	/**
	 * Decode hex.
	 *
	 * @param data
	 *            the data
	 * @return the byte[]
	 * @throws Exception
	 *             the exception
	 */
	private static byte[] decodeHex(char[] data) throws Exception {

		int len = data.length;

		if ((len & 0x01) != 0) {
			throw new Exception("Odd number of characters.");
		}

		byte[] out = new byte[len >> 1];

		// two characters form the hex value.
		for (int i = 0, j = 0; j < len; i++) {
			int f = toDigit(data[j], j) << 4;
			j++;
			f = f | toDigit(data[j], j);
			j++;
			out[i] = (byte) (f & 0xFF);
		}

		return out;
	}

	/**
	 * To digit.
	 *
	 * @param ch
	 *            the ch
	 * @param index
	 *            the index
	 * @return the int
	 * @throws Exception
	 *             the exception
	 */
	protected static int toDigit(char ch, int index) throws Exception {
		int digit = Character.digit(ch, 16);
		if (digit == -1) {
			throw new Exception("Illegal hexadecimal charcter " + ch + " at index " + index);
		}
		return digit;
	}

	/**
	 * Encode hex.
	 *
	 * @param data
	 *            the data
	 * @return the char[]
	 */
	private static char[] encodeHex(byte[] data) {

		int l = data.length;

		char[] out = new char[l << 1];

		// two characters form the hex value.
		for (int i = 0, j = 0; i < l; i++) {
			out[j++] = DIGITS[(0xF0 & data[i]) >>> 4];
			out[j++] = DIGITS[0x0F & data[i]];
		}

		return out;
	}

	/**
	 * Decode to byte.
	 *
	 * @param array
	 *            the array
	 * @return the byte[]
	 * @throws Exception
	 *             the exception
	 */
	private byte[] decodeToByte(byte[] array) throws Exception {
		return decodeHex(new String(array).toCharArray());
	}

	/**
	 * Encode to byte.
	 *
	 * @param array
	 *            the array
	 * @return the byte[]
	 */
	private byte[] encodeToByte(byte[] array) {
		return new String(encodeHex(array)).getBytes();
	}

	/**
	 * *********** MD5 ***************.
	 *
	 * @param algorithm
	 *            the algorithm
	 * @return the digest
	 */
	static MessageDigest getDigest(String algorithm) {
		try {
			return MessageDigest.getInstance(algorithm);
		} catch (NoSuchAlgorithmException e) {
			throw new RuntimeException(e.getMessage());
		}
	}

	/**
	 * Gets the md5 digest.
	 *
	 * @return the md5 digest
	 */
	private static MessageDigest getMd5Digest() {
		return getDigest("MD5");
	}

	/**
	 * Gets the SH a1 digest.
	 *
	 * @return the SH a1 digest
	 */
	private static MessageDigest getSHA1Digest() {
		return getDigest("SHA-1");
	}

	/**
	 * Md5.
	 *
	 * @param data
	 *            the data
	 * @return the byte[]
	 */
	private static byte[] md5(byte[] data) {
		return getMd5Digest().digest(data);
	}

	/**
	 * Sha1.
	 *
	 * @param data
	 *            the data
	 * @return the byte[]
	 */
	private static byte[] sha1(byte[] data) {
		MessageDigest digest = null;
		digest = getSHA1Digest();
		digest.reset();
		digest.update(data);
		return digest.digest();
	}

	/**
	 * Md5.
	 *
	 * @param data
	 *            the data
	 * @return the byte[]
	 */
	private static byte[] md5(String data) {
		return md5(data.getBytes());
	}

	/**
	 * Md5 hex.
	 *
	 * @param data
	 *            the data
	 * @return the string
	 */
	private static String md5Hex(byte[] data) {
		return new String(encodeHex(md5(data)));
	}

	/**
	 * Md5 hex.
	 *
	 * @param data
	 *            the data
	 * @return the string
	 */
	private static String md5Hex(String data) {
		return new String(encodeHex(md5(data)));
	}

}
