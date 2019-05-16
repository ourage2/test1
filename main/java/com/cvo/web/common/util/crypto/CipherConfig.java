package com.enpem.web.common.util.crypto;

public class CipherConfig {

	private byte[] key = null;
	private String transformation = "AES/CBC/PKCS5Padding";
	private String algorithm = "AES";
	private byte[] ivParameter = null;

	/**
	 * Instantiates a new AES config.
	 */
	public CipherConfig() {
	}

	/**
	 * Instantiates a new cipher config.
	 *
	 * @param key the key
	 * @param transformation the transformation
	 * @param algorithm the algorithm
	 * @param ivParameter the iv parameter
	 */
	public CipherConfig(byte[] key, String transformation, String algorithm, byte[] ivParameter) {
		this.key = key;
		this.transformation = transformation;
		this.algorithm = algorithm;
		this.ivParameter = ivParameter;
	}

	/**
	 * Instantiates a new AES config.
	 *
	 * @param key the key
	 * @param transformation the transformation
	 * @param algorithm the algorithm
	 */
	public CipherConfig(byte[] key, String transformation, String algorithm) {
		this.key = key;
		this.transformation = transformation;
		this.algorithm = algorithm;
	}

	/**
	 * Instantiates a new cipher config.
	 *
	 * @param key the key
	 * @param transformation the transformation
	 */
	public CipherConfig(byte[] key, String transformation) {
		this.key = key;
		this.transformation = transformation;
	}

	/**
	 * Gets the key.
	 *
	 * @return the key
	 */
	public byte[] getKey() {
		return key;
	}

	/**
	 * Sets the key.
	 *
	 * @param key the new key
	 */
	public void setKey(byte[] key) {
		this.key = key;
	}

	/**
	 * Gets the transformation.
	 *
	 * @return the transformation
	 */
	public String getTransformation() {
		return transformation;
	}

	/**
	 * Sets the transformation.
	 *
	 * @param transformation the new transformation
	 */
	public void setTransformation(String transformation) {
		this.transformation = transformation;
	}

	/**
	 * Gets the algorithm.
	 *
	 * @return the algorithm
	 */
	public String getAlgorithm() {
		return algorithm;
	}

	/**
	 * Sets the algorithm.
	 *
	 * @param algorithm the new algorithm
	 */
	public void setAlgorithm(String algorithm) {
		this.algorithm = algorithm;
	}

	/**
	 * Gets the iv parameter.
	 *
	 * @return the iv parameter
	 */
	public byte[] getIvParameter() {
		return ivParameter;
	}

	/**
	 * Sets the iv parameter.
	 *
	 * @param ivParameter the new iv parameter
	 */
	public void setIvParameter(byte[] ivParameter) {
		this.ivParameter = ivParameter;
	}

}
