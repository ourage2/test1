package com.enpem.web.common.spring;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.enpem.web.common.constants.CmnConst;
import com.enpem.web.common.data.Box;
import com.enpem.web.common.util.ConfigUtil;
import com.enpem.web.common.util.ExcelUtil;
import com.enpem.web.common.util.NumberUtil;
import com.enpem.web.common.util.StringUtil;
import com.enpem.web.common.util.WebUtil;

public class ExcelView extends AbstractExcelView {

	protected Logger log = LoggerFactory.getLogger(this.getClass());
	private static final String LIST_COUNT_NAME = "총건수";
	private static final String SEARCH_TITLE_NAME = "검색조건";

	@SuppressWarnings("unchecked")
	@Override
	protected void buildExcelDocument(Map<String, Object> modelMap, XSSFWorkbook workbook, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String excelName = (String)modelMap.get(CmnConst.EXCEL_NAME);
		if(StringUtil.isEmpty(excelName)) {
			excelName = "excel";
		}
		List<String[]> columnList = (List<String[]>)modelMap.get(CmnConst.EXCEL_COLUMN);
		int columnSize = -1;
		if(columnList == null || (columnSize = columnList.size()) < 1) {
			throw new Exception("Excel Column 정의가 되지 않았습니다.");
		}
		List<Box> excelList = (List<Box>)modelMap.get(CmnConst.EXCEL_LIST);
//		if(excelList == null) {
//			throw new Exception("Excel List 정의가 되지 않았습니다.");
//		}

		int excelSize = 0;
		if(excelList != null) {
			excelSize = excelList.size();
			if(excelSize > ConfigUtil.getInt("excel.max.row")) {
				throw new Exception("Excel Export 허용건수가 초과하였습니다.");
			}
		}

		int rowIdx = 0;
		int cellIdx = 1;
		int revColumnSize = cellIdx+columnSize;
		Sheet sheet = workbook.createSheet(excelName);
		Row row = null;
		Cell cell = null;

		row = sheet.createRow(rowIdx++);
		row.setHeightInPoints(8);
		sheet.setColumnWidth(0, 300);

		row = sheet.createRow(rowIdx++);
		CellStyle titleStyle = ExcelUtil.getTitleStyle(workbook);
		for (int i = 0; i < columnSize; i++) {
			cell = row.createCell(cellIdx+i);
			cell.setCellStyle(titleStyle);
		}
		sheet.addMergedRegion(new CellRangeAddress((rowIdx-1), (rowIdx-1), cellIdx, revColumnSize-1));
		row.getCell(cellIdx).setCellValue(excelName);

		row = sheet.createRow(rowIdx++);
		row.setHeightInPoints(8);

		CellStyle infoTitleStyle = ExcelUtil.getInfoTitleStyle(workbook);
		CellStyle infoDataStyle = ExcelUtil.getInfoDataStyle(workbook);

		row = sheet.createRow(rowIdx++);
		cell = row.createCell(cellIdx);
		cell.setCellValue(LIST_COUNT_NAME);
		cell.setCellStyle(infoTitleStyle);
		for (int i = 1; i < columnSize; i++) {
			cell = row.createCell(cellIdx+i);
			cell.setCellStyle(infoDataStyle);
		}
		sheet.addMergedRegion(new CellRangeAddress((rowIdx-1), (rowIdx-1), cellIdx+1, revColumnSize-1));
		row.getCell(cellIdx+1).setCellValue(excelSize);

		String excelSearch = (String)modelMap.get(CmnConst.EXCEL_SEARCH);
		if(StringUtil.isNotEmpty(excelSearch)) {
			row = sheet.createRow(rowIdx++);
			cell = row.createCell(cellIdx);
			cell.setCellValue(SEARCH_TITLE_NAME);
			cell.setCellStyle(infoTitleStyle);
			for (int i = 1; i < columnSize; i++) {
				cell = row.createCell(cellIdx+i);
				cell.setCellStyle(infoDataStyle);
			}
			sheet.addMergedRegion(new CellRangeAddress((rowIdx-1), (rowIdx-1), cellIdx+1, revColumnSize-1));
			row.getCell(cellIdx+1).setCellValue(excelSearch);
		}

		String excelEtc = (String)modelMap.get(CmnConst.EXCEL_ETC);
		if(StringUtil.isNotEmpty(excelEtc)) {
			row = sheet.createRow(rowIdx++);
			cell = row.createCell(cellIdx);
			cell.setCellValue(excelEtc);
		}

		row = sheet.createRow(rowIdx++);
		row.setHeightInPoints(8);

		CellStyle headerStyle = ExcelUtil.getHeaderStyle(workbook);
		row = sheet.createRow(rowIdx++);
		for (int i = 0; i < columnSize; i++) {
			cell = row.createCell(cellIdx+i);
			cell.setCellValue(columnList.get(i)[1]);
			cell.setCellStyle(headerStyle);
		}

		Box data = null;
		Object colValObj = null;
		for (int i = 0; i < excelSize; i++) {
			data = (Box)excelList.get(i);
			row = sheet.createRow(rowIdx++);
			for (int j = 0; j < columnSize; j++) {
				cell = row.createCell(cellIdx + j);
				colValObj = data.get(columnList.get(j)[0]);
				if (colValObj instanceof BigDecimal) {
					cell.setCellValue(NumberUtil.toBigDecimal(colValObj).doubleValue());
				} else {
					if (colValObj != null) {
						cell.setCellValue(String.valueOf(colValObj));
					}
				}
			}
		}

		for (int i = 0; i < columnSize; i++) {
			sheet.autoSizeColumn(cellIdx + i);
			sheet.setColumnWidth(cellIdx + i, (sheet.getColumnWidth(cellIdx + i)) + 1024); //여백을 추가로 조정한다
		}

		String fileName = ExcelUtil.createFileName(excelName, request);
		WebUtil.setDisposition(fileName, request, response);
	}

}
