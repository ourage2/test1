package com.enpem.web.common.util;

import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.concurrent.ConcurrentHashMap;

import org.joda.time.DateTime;
import org.joda.time.DateTimeUtils;
import org.joda.time.DateTimeZone;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

public class DateUtil {

	private static ConcurrentHashMap<String, SimpleDateFormat> cache = new ConcurrentHashMap<String, SimpleDateFormat>();

	public static final String YEAR_PATTERN = "yyyy";
	public static final String MONTH_PATTERN = "MM";
	public static final String YEARMONTH_PATTERN = "yyyyMM";
	public static final String YEARMONTH_DASH_PATTERN = "yyyy-MM";
	public static final String DAY_PATTERN = "dd";
	public static final String DATE_PATTERN = "yyyyMMdd";
	public static final String DATE_DASH_PATTERN = "yyyy-MM-dd";
	public static final String TIME_HM_COLONE_PATTERN = "HH:mm";
	public static final String TIME_PATTERN = "HHmmss";
	public static final String TIME_HMS_COLONE_PATTERN = "HH:mm:ss";
	public static final String DATE_TIME_PATTERN = "yyyyMMddHHmmss";
	public static final String DATE_TIME_DC_PATTERN = "yyyy-MM-dd HH:mm:ss";
	public static final String TIMESTAMP_PATTERN = "yyyyMMddHHmmssSSS";
	public static final String TIMESTAMP_DC_PATTERN = "yyyy-MM-dd HH:mm:ss.SSS";

	private static final String DEFAULT_FULL_PARSE_PATTERN = "yyyyMMddHHmmssSSS";
	private static final int DEFAULT_FULL_PARSE_MAXLENGTH = DEFAULT_FULL_PARSE_PATTERN.length();
	private static final String[] DEFAULT_PARSE_PATTERN = new String[DEFAULT_FULL_PARSE_MAXLENGTH + 1];
	static {
		DEFAULT_PARSE_PATTERN[DEFAULT_FULL_PARSE_MAXLENGTH] = DEFAULT_FULL_PARSE_PATTERN;
		DEFAULT_PARSE_PATTERN[14] = DEFAULT_FULL_PARSE_PATTERN.substring(0, 14);
		DEFAULT_PARSE_PATTERN[12] = DEFAULT_FULL_PARSE_PATTERN.substring(0, 12);
		DEFAULT_PARSE_PATTERN[10] = DEFAULT_FULL_PARSE_PATTERN.substring(0, 10);
		DEFAULT_PARSE_PATTERN[8] = DEFAULT_FULL_PARSE_PATTERN.substring(0, 8);
		DEFAULT_PARSE_PATTERN[6] = DEFAULT_FULL_PARSE_PATTERN.substring(0, 6);
		DEFAULT_PARSE_PATTERN[4] = DEFAULT_FULL_PARSE_PATTERN.substring(0, 4);
		DEFAULT_PARSE_PATTERN[0] = "";
	}
	private static final String DEFAULT_FORMAT_PATTERN = DEFAULT_PARSE_PATTERN[8];

	/**
	 * Instantiates a new date util.
	 */
	private DateUtil() {
	}

	public static Date parse(String source) throws ParseException {
		if(source == null) {
			return null;
		}
		int len = source.length();
		int rlen = len;
		if (len > DEFAULT_FULL_PARSE_MAXLENGTH) {
			rlen = DEFAULT_FULL_PARSE_MAXLENGTH;
		}
		while (DEFAULT_PARSE_PATTERN[rlen] == null) {
			rlen--;
		}
		return getDateFormat(DEFAULT_PARSE_PATTERN[rlen]).parse(source);
	}

	private static SimpleDateFormat getDateFormat(String pattern) {
		SimpleDateFormat sdf = cache.get(pattern);
		if (sdf == null) {
			sdf = new SimpleDateFormat(pattern);
			cache.putIfAbsent(pattern, sdf);
		}
		return sdf;
	}

	/**
	 * Parses the to date time.
	 *
	 * @param source the source
	 * @param pattern the pattern
	 * @return the date time
	 */
	public static DateTime parseToDateTime(String source, String pattern) {
		if (source == null) {
			return null;
		}
		DateTimeFormatter fmt = DateTimeFormat.forPattern(pattern);
		DateTime utcDt = fmt.withZone(DateTimeZone.UTC).parseDateTime(source);
		return new DateTime(DateTimeZone.getDefault().convertLocalToUTC(utcDt.getMillis(), false));
	}

	/**
	 * Parses the.
	 *
	 * @param source the source
	 * @param pattern the pattern
	 * @return the date
	 */
	public static Date parse(String source, String pattern) {
		DateTime dt = DateUtil.parseToDateTime(source, pattern);
		return dt.toDate();
	}

	/**
	 * Parses the to timestamp.
	 *
	 * @param source the source
	 * @param pattern the pattern
	 * @return the timestamp
	 */
	public static Timestamp parseToTimestamp(String source, String pattern) {
		DateTime dt = DateUtil.parseToDateTime(source, pattern);
		Timestamp timeStamp = new Timestamp(dt.getMillis());
		return timeStamp;
	}

	public static String format(Date date) {
		if (date == null) {
			return null;
		}
		return getDateFormat(DEFAULT_FORMAT_PATTERN).format(date);
	}

	/**
	 * Checks if is valid.
	 *
	 * @param source the source
	 * @param pattern the pattern
	 * @return true, if is valid
	 */
	public static boolean isValid(String source, String pattern) {
		try {
			DateUtil.parse(source, pattern);
			return true;
		} catch (Exception e) {
			return false;
		}
	}

	/**
	 * Format.
	 *
	 * @param dt the dt
	 * @param pattern the pattern
	 * @return the string
	 */
	public static String format(DateTime dt, String pattern) {
		return dt.toString(pattern);
	}

	/**
	 * Format.
	 *
	 * @param date the date
	 * @param pattern the pattern
	 * @return the string
	 */
	public static String format(Date date, String pattern) {
		if (date == null) {
			return null;
		}
		DateTime dt = new DateTime(date);
		return format(dt, pattern);
	}

	/**
	 * Format.
	 *
	 * @param timestamp the timestamp
	 * @param pattern the pattern
	 * @return the string
	 */
	public static String format(long timestamp, String pattern) {
		return format(new DateTime(timestamp), pattern);
	}

	/**
	 * Format timestamp.
	 *
	 * @param timestamp the timestamp
	 * @return the string
	 */
	public static String format(long timestamp) {
		return DateUtil.format(timestamp, TIMESTAMP_PATTERN);
	}

	/**
	 * Adds the date date time.
	 *
	 * @param dt the dt
	 * @param amount the amount
	 * @return the date time
	 */
	public static DateTime addDateDateTime(DateTime dt, int amount) {
		return dt.plusDays(amount);
	}

	/**
	 * Adds the date date time.
	 *
	 * @param amount the amount
	 * @return the date time
	 */
	public static DateTime addDateDateTime(int amount) {
		DateTime dt = new DateTime();
		return DateUtil.addDateDateTime(dt, amount);
	}

	/**
	 * Adds the date.
	 *
	 * @param dt the dt
	 * @param amount the amount
	 * @return the date
	 */
	public static Date addDate(DateTime dt, int amount) {
		return DateUtil.addDateDateTime(dt, amount).toDate();
	}

	/**
	 * Adds the date.
	 *
	 * @param date the date
	 * @param amount the amount
	 * @return the date
	 */
	public static Date addDate(Date date, int amount) {
		DateTime dt = new DateTime(date);
		return DateUtil.addDate(dt, amount);
	}

	/**
	 * Adds the date.
	 *
	 * @param amount the amount
	 * @return the date
	 */
	public static Date addDate(int amount) {
		DateTime dt = new DateTime();
		return DateUtil.addDate(dt, amount);
	}

	/**
	 * Adds the month date time.
	 *
	 * @param dt the dt
	 * @param amount the amount
	 * @return the date time
	 */
	public static DateTime addMonthDateTime(DateTime dt, int amount) {
		return dt.plusMonths(amount);
	}

	/**
	 * Adds the month date time.
	 *
	 * @param amount the amount
	 * @return the date time
	 */
	public static DateTime addMonthDateTime(int amount) {
		DateTime dt = new DateTime();
		return DateUtil.addMonthDateTime(dt, amount);
	}

	/**
	 * Adds the month.
	 *
	 * @param dt the dt
	 * @param amount the amount
	 * @return the date
	 */
	public static Date addMonth(DateTime dt, int amount) {
		return DateUtil.addMonthDateTime(dt, amount).toDate();
	}

	/**
	 * Adds the month.
	 *
	 * @param date the date
	 * @param amount the amount
	 * @return the date
	 */
	public static Date addMonth(Date date, int amount) {
		DateTime dt = new DateTime(date);
		return DateUtil.addMonth(dt, amount);
	}

	/**
	 * Adds the month.
	 *
	 * @param amount the amount
	 * @return the date
	 */
	public static Date addMonth(int amount) {
		DateTime dt = new DateTime();
		return DateUtil.addMonth(dt, amount);
	}

	/**
	 * Adds the year date time.
	 *
	 * @param dt the dt
	 * @param amount the amount
	 * @return the date time
	 */
	public static DateTime addYearDateTime(DateTime dt, int amount) {
		return dt.plusYears(amount);
	}

	/**
	 * Adds the year date time.
	 *
	 * @param amount the amount
	 * @return the date time
	 */
	public static DateTime addYearDateTime(int amount) {
		DateTime dt = new DateTime();
		return DateUtil.addYearDateTime(dt, amount);
	}

	/**
	 * Adds the year.
	 *
	 * @param dt the dt
	 * @param amount the amount
	 * @return the date
	 */
	public static Date addYear(DateTime dt, int amount) {
		return DateUtil.addYearDateTime(dt, amount).toDate();
	}

	/**
	 * Adds the year.
	 *
	 * @param date the date
	 * @param amount the amount
	 * @return the date
	 */
	public static Date addYear(Date date, int amount) {
		DateTime dt = new DateTime(date);
		return DateUtil.addYear(dt, amount);
	}

	/**
	 * Adds the year.
	 *
	 * @param amount the amount
	 * @return the date
	 */
	public static Date addYear(int amount) {
		DateTime dt = new DateTime();
		return DateUtil.addYear(dt, amount);
	}

	/**
	 * Adds the hour date time.
	 *
	 * @param dt the dt
	 * @param amount the amount
	 * @return the date time
	 */
	public static DateTime addHourDateTime(DateTime dt, int amount) {
		return dt.plusHours(amount);
	}

	/**
	 * Adds the hour date time.
	 *
	 * @param amount the amount
	 * @return the date time
	 */
	public static DateTime addHourDateTime(int amount) {
		DateTime dt = new DateTime();
		return DateUtil.addHourDateTime(dt, amount);
	}

	/**
	 * Adds the hour.
	 *
	 * @param dt the dt
	 * @param amount the amount
	 * @return the date
	 */
	public static Date addHour(DateTime dt, int amount) {
		return DateUtil.addHourDateTime(dt, amount).toDate();
	}

	/**
	 * Adds the hour.
	 *
	 * @param date the date
	 * @param amount the amount
	 * @return the date
	 */
	public static Date addHour(Date date, int amount) {
		DateTime dt = new DateTime(date);
		return DateUtil.addHour(dt, amount);
	}

	/**
	 * Adds the hour.
	 *
	 * @param amount the amount
	 * @return the date
	 */
	public static Date addHour(int amount) {
		DateTime dt = new DateTime();
		return DateUtil.addHour(dt, amount);
	}

	/**
	 * Adds the minute date time.
	 *
	 * @param dt the dt
	 * @param amount the amount
	 * @return the date time
	 */
	public static DateTime addMinuteDateTime(DateTime dt, int amount) {
		return dt.plusMinutes(amount);
	}

	/**
	 * Adds the minute date time.
	 *
	 * @param amount the amount
	 * @return the date time
	 */
	public static DateTime addMinuteDateTime(int amount) {
		DateTime dt = new DateTime();
		return DateUtil.addMinuteDateTime(dt, amount);
	}

	/**
	 * Adds the minute.
	 *
	 * @param dt the dt
	 * @param amount the amount
	 * @return the date
	 */
	public static Date addMinute(DateTime dt, int amount) {
		return DateUtil.addMinuteDateTime(dt, amount).toDate();
	}

	/**
	 * Adds the minute.
	 *
	 * @param date the date
	 * @param amount the amount
	 * @return the date
	 */
	public static Date addMinute(Date date, int amount) {
		DateTime dt = new DateTime(date);
		return DateUtil.addMinute(dt, amount);
	}

	/**
	 * Adds the minute.
	 *
	 * @param amount the amount
	 * @return the date
	 */
	public static Date addMinute(int amount) {
		DateTime dt = new DateTime();
		return DateUtil.addMinute(dt, amount);
	}

	/**
	 * Adds the second date time.
	 *
	 * @param dt the dt
	 * @param amount the amount
	 * @return the date time
	 */
	public static DateTime addSecondDateTime(DateTime dt, int amount) {
		return dt.plusSeconds(amount);
	}

	/**
	 * Adds the second date time.
	 *
	 * @param amount the amount
	 * @return the date time
	 */
	public static DateTime addSecondDateTime(int amount) {
		DateTime dt = new DateTime();
		return DateUtil.addSecondDateTime(dt, amount);
	}

	/**
	 * Adds the second.
	 *
	 * @param dt the dt
	 * @param amount the amount
	 * @return the date
	 */
	public static Date addSecond(DateTime dt, int amount) {
		return DateUtil.addSecondDateTime(dt, amount).toDate();
	}

	/**
	 * Adds the second.
	 *
	 * @param date the date
	 * @param amount the amount
	 * @return the date
	 */
	public static Date addSecond(Date date, int amount) {
		DateTime dt = new DateTime(date);
		return DateUtil.addSecond(dt, amount);
	}

	/**
	 * Adds the second.
	 *
	 * @param amount the amount
	 * @return the date
	 */
	public static Date addSecond(int amount) {
		DateTime dt = new DateTime();
		return DateUtil.addSecond(dt, amount);
	}

	/**
	 * 시스템의 밀리초 구하기.(국제표준시각(UTC, GMT) 1970/1/1/0/0/0 으로부터 경과한 시각)
	 *
	 * @return the current millis
	 */
	public static long getCurrentMillis() {
		return DateTimeUtils.currentTimeMillis();
	}

	/**
	 * Gets the date time.
	 *
	 * @return the date time
	 */
	public static DateTime getDateTime() {
		return DateTime.now();
	}

	/**
	 * 현재 시각을 가져오기.
	 *
	 * @return the current date
	 */
	public static Date getCurrentDate() {
		return DateUtil.getDateTime().toDate();
	}

	/**
	 * Compare to.
	 *
	 * @param date1 the date1
	 * @param date2 the date2
	 * @param pattern the pattern
	 * @return the int
	 */
	public static int compareTo(String date1, String date2, String pattern) {
		Date d1 = DateUtil.parse(date1, pattern);
		Date d2 = DateUtil.parse(date2, pattern);
		return d1.compareTo(d2);
	}

	/**
	 * Now.
	 *
	 * @param pattern the pattern
	 * @return the string
	 */
	public static String now(String pattern) {
		return DateUtil.format(new DateTime(), pattern);
	}

	/**
	 * Now yyyymmdd.
	 *
	 * @return the string
	 */
	public static String nowYYYYMM() {
		return now(YEARMONTH_PATTERN);
	}

	/**
	 * Now yyyymmdd dash.
	 *
	 * @return the string
	 */
	public static String nowYYYYMMDash() {
		return now(YEARMONTH_DASH_PATTERN);
	}

	/**
	 * Now yyyymmdd.
	 *
	 * @return the string
	 */
	public static String nowYYYYMMDD() {
		return now(DATE_PATTERN);
	}

	/**
	 * Now yyyymmdd dash.
	 *
	 * @return the string
	 */
	public static String nowYYYYMMDDDash() {
		return now(DATE_DASH_PATTERN);
	}

	/**
	 * Now yyyymmddh h24 miss.
	 *
	 * @return the string
	 */
	public static String nowYYYYMMDDHH24MISS() {
		return now(DATE_TIME_PATTERN);
	}

	/**
	 * Now yyyymmddh h24 m iss sss.
	 *
	 * @return the string
	 */
	public static String nowYYYYMMDDHH24MIssSSS() {
		return now(TIMESTAMP_PATTERN);
	}

	public static String nowYYYYMMDDHH24MIssSSSDash() {
		return now(TIMESTAMP_DC_PATTERN);
	}

	/**
	 * Format date.
	 *
	 * @param source the source
	 * @param parsePattern the parse pattern
	 * @param formatPattern the format pattern
	 * @return the string
	 */
	public static String formatDate(String source, String parsePattern, String formatPattern) {
		return DateUtil.format(DateUtil.parse(source, parsePattern), formatPattern);
	}

	/**
	 * Format date.
	 *
	 * @param source the source
	 * @param pattern the pattern
	 * @return the string
	 */
	public static String formatDate(String source, String pattern) {
		return DateUtil.formatDate(source, pattern, pattern);
	}

	/**
	 * Adds the date.
	 *
	 * @param amount the amount
	 * @param pattern the pattern
	 * @return the string
	 */
	public static String formatAddMonth(int amount, String pattern) {
		return DateUtil.addMonthDateTime(amount).toString(pattern);
	}

	/**
	 * Format timestamp.
	 *
	 * @param timestamp the timestamp
	 * @return the string
	 */
	public static String formatTimestamp(String timestamp) {
		if (StringUtil.isEmpty(timestamp)) {
			return timestamp;
		}
		return DateUtil.format(NumberUtil.toLong(timestamp));
	}

	/**
	 * Format timestamp.
	 *
	 * @param source the source
	 * @param pattern the pattern
	 * @return the string
	 */
	public static String formatTimestamp(String source, String pattern) {
		DateTime dt = DateUtil.parseToDateTime(source, pattern);
		return Long.toString(dt.getMillis());
	}

	/**
	 * Gets the last day of month value.
	 *
	 * @param dt the dt
	 * @return the last day of month value
	 */
	public static int getLastDayOfMonthValue(DateTime dt) {
		return dt.dayOfMonth().getMaximumValue();
	}

	/**
	 * Gets the last day of month value.
	 *
	 * @return the last day of month value
	 */
	public static int getLastDayOfMonthValue() {
		return DateUtil.getLastDayOfMonthValue(new DateTime());
	}

	/**
	 * Gets the last day of month value.
	 *
	 * @param date the date
	 * @return the last day of month value
	 */
	public static int getLastDayOfMonthValue(Date date) {
		return DateUtil.getLastDayOfMonthValue(new DateTime(date));
	}

	/**
	 * Gets the last day of month date time.
	 *
	 * @param dt the dt
	 * @return the last day of month date time
	 */
	public static DateTime getLastDayOfMonthDateTime(DateTime dt) {
		return dt.dayOfMonth().withMaximumValue();
	}

	/**
	 * Gets the last day of month date time.
	 *
	 * @return the last day of month date time
	 */
	public static DateTime getLastDayOfMonthDateTime() {
		return DateUtil.getLastDayOfMonthDateTime(new DateTime());
	}

	/**
	 * Gets the last day of month date time.
	 *
	 * @param date the date
	 * @return the last day of month date time
	 */
	public static DateTime getLastDayOfMonthDateTime(Date date) {
		return DateUtil.getLastDayOfMonthDateTime(new DateTime(date));
	}

	/**
	 * Gets the last day of month.
	 *
	 * @param dt the dt
	 * @return the last day of month
	 */
	public static Date getLastDayOfMonth(DateTime dt) {
		return DateUtil.getLastDayOfMonthDateTime(dt).toDate();
	}

	/**
	 * Gets the last day of month.
	 *
	 * @return the last day of month
	 */
	public static Date getLastDayOfMonth() {
		return DateUtil.getLastDayOfMonth(new DateTime());
	}

	/**
	 * Gets the last day of month.
	 *
	 * @param date the date
	 * @return the last day of month
	 */
	public static Date getLastDayOfMonth(Date date) {
		return DateUtil.getLastDayOfMonth(new DateTime(date));
	}

	/**
	 * Format last day of month.
	 *
	 * @param dt the dt
	 * @param pattern the pattern
	 * @return the string
	 */
	public static String formatLastDayOfMonth(DateTime dt, String pattern) {
		return DateUtil.getLastDayOfMonthDateTime(dt).toString(pattern);
	}

	/**
	 * Format last day of month.
	 *
	 * @param pattern the pattern
	 * @return the string
	 */
	public static String formatLastDayOfMonth(String pattern) {
		return DateUtil.formatLastDayOfMonth(new DateTime(), pattern);
	}

	/**
	 * Format last day of month.
	 *
	 * @param date the date
	 * @param pattern the pattern
	 * @return the string
	 */
	public static String formatLastDayOfMonth(Date date, String pattern) {
		return DateUtil.formatLastDayOfMonth(new DateTime(date), pattern);
	}

}
