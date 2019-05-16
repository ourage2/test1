/**
 * custom log4jdbc by lsj
 */
package net.sf.log4jdbc;

import java.util.List;



import org.slf4j.Logger;

import com.enpem.web.common.util.ConfigUtil;

public class ResultSetCollectorPrinter {

	private Logger log;

	public ResultSetCollectorPrinter(Logger log) {
		this.log = log;
	}

	public void printResultSet(ResultSetCollector resultSetCollector) {

		int columnCount = resultSetCollector.getColumnCount();
		int maxLength[] = new int[columnCount];

		for (int column = 1; column <= columnCount; column++) {
			maxLength[column - 1] = resultSetCollector.getColumnName(column)
					.length();
		}
		if (resultSetCollector.getRows() != null) {
			for (List<Object> printRow : resultSetCollector.getRows()) {
				int colIndex = 0;
				for (Object v : printRow) {
					if (v != null) {
						int length = v.toString().length();
						if (length > maxLength[colIndex]) {
							maxLength[colIndex] = length;
						}
					}
					colIndex++;
				}
			}
		}
		for (int column = 1; column <= columnCount; column++) {
			maxLength[column - 1] = maxLength[column - 1] + 1;
		}

		print("|");
		for (int column = 1; column <= columnCount; column++) {
			print(padRight("-", maxLength[column - 1]).replaceAll(" ", "-")
					+ "|");
		}
		println();
		print("|");
		for (int column = 1; column <= columnCount; column++) {
			print(padRight(resultSetCollector.getColumnName(column),
					maxLength[column - 1])
					+ "|");
		}
		println();
		print("|");
		for (int column = 1; column <= columnCount; column++) {
			print(padRight("-", maxLength[column - 1]).replaceAll(" ", "-")
					+ "|");
		}
		println();
		if (resultSetCollector.getRows() != null) {
			int idx = 0;
			for (List<Object> printRow : resultSetCollector.getRows()) {
				int colIndex = 0;
				print("|");
				for (Object v : printRow) {
					print(padRight(v == null ? "null" : v.toString(),
							maxLength[colIndex])
							+ "|");
					colIndex++;
				}
				println();

				if ((idx + 1) >= ConfigUtil.getInt("log.max.cnt")) { break;}
				idx++;
			}
		}
		print("|");
		for (int column = 1; column <= columnCount; column++) {
			print(padRight("-", maxLength[column - 1]).replaceAll(" ", "-")
					+ "|");
		}
		println();
		int rowCnt = null != resultSetCollector.getRows() ? resultSetCollector.getRows().size() : 0;
		if (rowCnt > ConfigUtil.getInt("log.max.cnt")) {
			log.info("결과출력을 제한합니다. [rowCnt : " + rowCnt + ", maxRowCnt : " + ConfigUtil.getInt("log.max.cnt") + "]");
		}

		resultSetCollector.reset();
	}

	public static String padRight(String s, int n) {
		return String.format("%1$-" + n + "s", s);
	}

	public static String padLeft(String s, int n) {
		return String.format("%1$#" + n + "s", s);
	}

	void println() {
		log.info(sb.toString());
		sb.setLength(0);
	}

	private StringBuffer sb = new StringBuffer();

	void print(String s) {
		sb.append(s);
	}

}