package com.enpem.web.common.util;

public class ServerUtil {

	/**
	 * Gets the server system name.
	 *
	 * @return the server system name
	 */
	public static String getServerSystemName() {
		String serverSystemName = System.getProperty("server.system.name");
		if(StringUtil.isEmpty(serverSystemName)) {
			serverSystemName = ConfigUtil.getString("server.system.name");
		}
		return serverSystemName;
	}

	/**
	 * Gets the server hostname.
	 *
	 * @return the server hostname
	 */
	public static String getServerHostname() {
		String serverHostname = System.getProperty("server.host.name");
		if(StringUtil.isEmpty(serverHostname)) {
			serverHostname = ConfigUtil.getString("server.host.name");
		}
		return serverHostname;
	}

}
