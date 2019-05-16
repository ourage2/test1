package com.enpem.web.common.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class SystemUtil {

	protected Logger log = LoggerFactory.getLogger(this.getClass());

	private static final String OS_NAME = System.getProperty("os.name").toLowerCase();
	private static final String USER_NAME = System.getProperty("user.name").toLowerCase();
	private static final String USER_HOME = System.getProperty("user.home").toLowerCase();
	private static final String WAS_NAME = System.getProperty("was.name");

	/**
	 * Checks if is windows.
	 *
	 * @return true, if is windows
	 */
	public static boolean isWindows() {
		return (OS_NAME.indexOf("windows") >= 0);
	}

	/**
	 * Gets the user name.
	 *
	 * @return the user name
	 */
	public static String getUserName() {
		return USER_NAME;
	}

	/**
	 * Gets the user home.
	 *
	 * @return the user home
	 */
	public static String getUserHome() {
		return USER_HOME;
	}

	/**
	 * Gets the WAS name.
	 *
	 * @return the WAS name
	 */
	public static String getWasName() {
		return (WAS_NAME == null ? "" : WAS_NAME);
	}
}
