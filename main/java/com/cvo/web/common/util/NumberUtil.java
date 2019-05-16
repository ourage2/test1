package com.enpem.web.common.util;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.ParseException;

public class NumberUtil {

	/**
	 * Instantiates a new number util.
	 */
	private NumberUtil() {
	}

	/**
	 * To int.
	 *
	 * @param value the value
	 * @return the int
	 */
	public static int toInt(Object value) {
		if (value == null) {
			return 0;
		}
		if (value instanceof Number) {
			return ((Number) value).intValue();
		} else {
			String s = value.toString();
			if (s.length() == 0) {
				return 0;
			}
			return Integer.parseInt(s);
		}
	}

	/**
	 * Nvl.
	 *
	 * @param value the value
	 * @return the number
	 */
	public static Number nvl(Number value) {
		return nvl(value, BigDecimal.ZERO);
	}

	/**
	 * Nvl.
	 *
	 * @param value the value
	 * @param defaultValue the default value
	 * @return the number
	 */
	public static Number nvl(Number value, Number defaultValue) {
		if (value == null) {
			return defaultValue;
		}
		return value;
	}

	/**
	 * To double.
	 *
	 * @param value the value
	 * @return the double
	 */
	public static double toDouble(Object value) {
		if (value == null) {
			return 0.0;
		}
		if (value instanceof Number) {
			return ((Number) value).doubleValue();
		} else {
			String s = value.toString();
			if (s.length() == 0) {
				return 0.0;
			}
			return Double.parseDouble(s);
		}
	}

	/**
	 * To long.
	 *
	 * @param value the value
	 * @return the long
	 */
	public static long toLong(Object value) {
		if (value == null) {
			return 0L;
		}
		if (value instanceof Number) {
			return ((Number) value).longValue();
		} else {
			String s = value.toString();
			if (s.length() == 0) {
				return 0L;
			}
			return Long.parseLong(s);
		}
	}

	/**
	 * To big decimal.
	 *
	 * @param value the value
	 * @return the big decimal
	 */
	public static BigDecimal toBigDecimal(Object value) {
		if (value == null) {
			return null;
		}
		if (value instanceof BigDecimal) {
			return (BigDecimal) value;
		} else {
			String s = value.toString();
			if (s.length() == 0) {
				return null;
			}
			return new BigDecimal(s);
		}
	}

	/**
	 * Parses the.
	 *
	 * @param source the source
	 * @return the number
	 */
	public static Number parse(String source) {
		if (source == null) {
			return null;
		}
		try {
			return parse(source, null);
		} catch (ParseException ee) {
			throw new NumberFormatException(source);
		}
	}

	/**
	 * Parses the.
	 *
	 * @param source the source
	 * @param pattern the pattern
	 * @return the number
	 * @throws ParseException the parse exception
	 */
	public static Number parse(String source, String pattern) throws ParseException {
		if (source == null) {
			return null;
		}
		return createDecimalFormat(pattern).parse(source);
	}

	/**
	 * Format.
	 *
	 * @param number the number
	 * @param pattern the pattern
	 * @return the string
	 */
	public static String format(Number number, String pattern) {
		if(number == null) {
			return null;
		}
		return createDecimalFormat(pattern).format(number);
	}

	/**
	 * Gets the inner number format.
	 *
	 * @param pattern the pattern
	 * @return the inner number format
	 */
	private static DecimalFormat createDecimalFormat(String pattern) {
		DecimalFormat df = new DecimalFormat();
		df.setParseBigDecimal(true);
		return df;
	}

}
