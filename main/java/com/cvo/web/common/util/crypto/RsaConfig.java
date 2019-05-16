package com.enpem.web.common.util.crypto;

import java.security.Key;

public class RsaConfig {

	private Key privateKey;
	private Key publicKey;
	
	public Key getPrivateKey() {
		return privateKey;
	}
	
	public void setPrivateKey(Key privateKey) {
		this.privateKey = privateKey;
	}
	
	public Key getPublicKey() {
		return publicKey;
	}
	
	public void setPublicKey(Key publicKey) {
		this.publicKey = publicKey;
	}
	
	public byte[] getPrivateKeyByte() {
		return getPrivateKey().getEncoded();
	}
	
	public byte[] getPublicKeyByte() {
		return getPublicKey().getEncoded();
	}
	
	public String getPrivateKeyString() {
		return Base64Util.encodeString(getPrivateKeyByte());
	}
	
	public String getPublicKeyString() {
		return Base64Util.encodeString(getPublicKeyByte());
	}
	
}
