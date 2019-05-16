package com.enpem.web.common.util;

import java.awt.Color;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.ui.ModelMap;

import com.enpem.web.common.constants.CmnConst;

public class ExcelUtil {

	/**
	 * Checks if is json extension.
	 *
	 * @param request the request
	 * @return true, if is json extension
	 */
	public static final boolean isExcelExtension(HttpServletRequest request) {
		String uri = SpringUtil.getServletPath(request);
		if(uri.endsWith(".xls") || uri.endsWith(".xlsx")) {
			return true;
		}
		return false;
	}

	public static final boolean isExcel(HttpServletRequest request) throws Exception {
		return isExcelExtension(request);
	}

	public static final boolean isExcel() throws Exception {
		String uri = SpringUtil.getHttpServletRequest().getRequestURI();
		return isExcelExtension(uri);
	}

	public static final boolean isExcelExtension(String uri) {
		if(uri.endsWith(".xls") || uri.endsWith(".xlsx")) {
			return true;
		}
		return false;
	}



	public static final void setExcelInfo(ModelMap modelMap, String excelName, List<String[]> columnList, List<?> excelList, String excelSearch, String excelEtc) {
		modelMap.put(CmnConst.EXCEL_NAME, excelName);
		modelMap.put(CmnConst.EXCEL_COLUMN, columnList);
		modelMap.put(CmnConst.EXCEL_LIST, excelList);
		modelMap.put(CmnConst.EXCEL_SEARCH, excelSearch);
		modelMap.put(CmnConst.EXCEL_ETC, excelEtc);
	}

	public static final void setExcelInfo(ModelMap modelMap, String excelName, List<String[]> columnList, List<?> excelList, String excelSearch) {
		setExcelInfo(modelMap, excelName, columnList, excelList, excelSearch, null);
	}

	public static final void setExcelInfo(ModelMap modelMap, String excelName, List<String[]> columnList, List<?> excelList) {
		setExcelInfo(modelMap, excelName, columnList, excelList, null, null);
	}

	public static final String createFileName(String fileName, HttpServletRequest request) throws Exception {
		return new StringBuffer(fileName).append("_").append(DateUtil.nowYYYYMMDDHH24MISS()).append(".xlsx").toString();
	}

	public static final CellStyle getTitleStyle(XSSFWorkbook wb) {
		CellStyle style = wb.createCellStyle();
		style.setAlignment(CellStyle.ALIGN_CENTER);
		style.setBorderTop(CellStyle.BORDER_MEDIUM);
		style.setTopBorderColor(IndexedColors.BLACK.getIndex());
		style.setBorderRight(CellStyle.BORDER_MEDIUM);
		style.setRightBorderColor(IndexedColors.BLACK.getIndex());
		style.setBorderBottom(CellStyle.BORDER_MEDIUM);
		style.setBottomBorderColor(IndexedColors.BLACK.getIndex());
		style.setBorderLeft(CellStyle.BORDER_MEDIUM);
		style.setLeftBorderColor(IndexedColors.BLACK.getIndex());
		XSSFFont font = wb.createFont();
		font.setFontHeightInPoints((short)16);
		font.setBoldweight(Font.BOLDWEIGHT_BOLD);
		style.setFont(font);
		return style;
	}

	public static final CellStyle getInfoTitleStyle(XSSFWorkbook wb) {
		XSSFCellStyle style = wb.createCellStyle();
		style.setAlignment(CellStyle.ALIGN_CENTER);
		style.setBorderTop(CellStyle.BORDER_THIN);
		style.setTopBorderColor(IndexedColors.BLACK.getIndex());
		style.setBorderRight(CellStyle.BORDER_THIN);
		style.setRightBorderColor(IndexedColors.BLACK.getIndex());
		style.setBorderBottom(CellStyle.BORDER_THIN);
		style.setBottomBorderColor(IndexedColors.BLACK.getIndex());
		style.setBorderLeft(CellStyle.BORDER_THIN);
		style.setLeftBorderColor(IndexedColors.BLACK.getIndex());
		style.setFillPattern(CellStyle.SOLID_FOREGROUND);
		style.setFillForegroundColor(new XSSFColor(new Color(215, 215, 215)));
		return style;
	}

	public static final CellStyle getInfoDataStyle(XSSFWorkbook wb) {
		CellStyle style = wb.createCellStyle();
		style.setAlignment(CellStyle.ALIGN_LEFT);
		style.setBorderTop(CellStyle.BORDER_THIN);
		style.setTopBorderColor(IndexedColors.BLACK.getIndex());
		style.setBorderRight(CellStyle.BORDER_THIN);
		style.setRightBorderColor(IndexedColors.BLACK.getIndex());
		style.setBorderBottom(CellStyle.BORDER_THIN);
		style.setBottomBorderColor(IndexedColors.BLACK.getIndex());
		style.setBorderLeft(CellStyle.BORDER_THIN);
		style.setLeftBorderColor(IndexedColors.BLACK.getIndex());
		return style;
	}

	public static final CellStyle getHeaderStyle(XSSFWorkbook wb) {
		CellStyle style = wb.createCellStyle();
		style.setAlignment(CellStyle.ALIGN_CENTER);
		style.setBorderTop(CellStyle.BORDER_THIN);
		style.setTopBorderColor(IndexedColors.BLACK.getIndex());
		style.setBorderRight(CellStyle.BORDER_THIN);
		style.setRightBorderColor(IndexedColors.BLACK.getIndex());
		style.setBorderBottom(CellStyle.BORDER_THIN);
		style.setBottomBorderColor(IndexedColors.BLACK.getIndex());
		style.setBorderLeft(CellStyle.BORDER_THIN);
		style.setLeftBorderColor(IndexedColors.BLACK.getIndex());
		style.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
		style.setFillPattern(CellStyle.SOLID_FOREGROUND);
		return style;
	}


}
