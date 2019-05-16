package com.enpem.web.common.spring;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRichTextString;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.CellRangeAddress;
import org.apache.poi.hssf.util.HSSFColor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.view.document.AbstractExcelView;

public class OldExcelView extends AbstractExcelView {

	protected Logger log = LoggerFactory.getLogger(this.getClass());

	public static final String JEUS_CLASS = "/jeus/server/JeusServer.class";


	/* (non-Javadoc)
	 * @see org.springframework.web.servlet.view.document.AbstractExcelView#buildExcelDocument(java.util.Map, org.apache.poi.hssf.usermodel.HSSFWorkbook, javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Override
	protected void buildExcelDocument(Map model, HSSFWorkbook wb, HttpServletRequest request, HttpServletResponse response) throws Exception {

		log.debug("====================================================================================");
		log.debug("====================================================================================");
		log.debug("==  Excel View");
//		log.debug("==  Model : " + model);
		log.debug("====================================================================================");
		log.debug("====================================================================================");



		HSSFSheet sheet = null;
		if(model.get("sheetName") == null)
			sheet = wb.createSheet();
		else
			sheet = wb.createSheet((String)model.get("sheetName"));


		HSSFRow row = null;
		HSSFCell cell = null;

		int startRow = 1;
		int headerRow = startRow + 2;
		int textRow = headerRow + 1;
		int startCol = 1;



		// Header, List Data
		Object headerObj = model.get("header");
		List<?> list = model.get("list") == null ? null : (List<?>)model.get("list");


		/* =====================================================================================
		 * Header
		 * 시작
		 * =====================================================================================*/

		// 상단 빈칸
		for(int i=0; i<startRow; i++) {
			row = sheet.createRow(i);
			row.setHeight((short)200);
		}



		// 컬럼 사이즈
		int colSize = 0;



		// Header
		if(headerObj != null) {

			HSSFCellStyle headerStyle = getHeaderStyle(wb);
			String[] header = null;

			if(headerObj instanceof List) {
				List<String[]> headerList = (List<String[]>)headerObj;

				for(int i=0, s=headerList.size(); i<s; i++) {
					header = headerList.get(i);
					colSize = header.length;

					row = sheet.createRow(headerRow);
					for(int j=0; j<colSize; j++) {
						cell = row.createCell(j + startCol);
						cell.setCellStyle(headerStyle);
						cell.setCellValue(new HSSFRichTextString(header[j]));
					}

					headerRow++;
				}
				textRow = headerRow;

			} else if(headerObj instanceof String[]) {
				header = (String[])headerObj;
				colSize = header.length;

				row = sheet.createRow(headerRow);
				for(int i=0; i<colSize; i++) {
					cell = row.createCell(i + startCol);
					cell.setCellStyle(headerStyle);
					cell.setCellValue(new HSSFRichTextString(header[i]));
				}
			}
		}





		// Title colSpan 컬럼 수 구하기
		int titleColSize = 3;

		if(colSize > 3) {
			titleColSize = colSize;
		} else if(colSize == 0 && list != null) {
			colSize = ((Map)list.get(0)).keySet().size();
		}


		// Title
		if(model.get("title") != null) {
			String title = (String)model.get("title");

			row = sheet.createRow(startRow);
			HSSFCellStyle titleStyle = getTitleStyle(wb);
			for(int i=0; i<titleColSize; i++) {
				cell = row.createCell(i + startCol);
				cell.setCellStyle(titleStyle);
			}

			cell = row.getCell(0 + startCol);
			cell.setCellValue(new HSSFRichTextString(title));
			sheet.addMergedRegion(new CellRangeAddress(startRow, startRow, startCol, titleColSize + startCol -1));
		}


		/* =====================================================================================
		 * Header
		 * 종료
		 * =====================================================================================*/








		/* =====================================================================================
		 * Contents
		 * 시작
		 * =====================================================================================*/
		if(list != null) {
			HSSFCellStyle textStyle = getTextStyle(wb);

			Map data = null;
			Iterator iter = null;
			Entry entry = null;

			for(int i=0, s=list.size(); i<s; i++) {
				data = (Map)list.get(i);
				row = sheet.createRow(i + textRow);

				iter = data.entrySet().iterator();
				for(int j=0; iter.hasNext(); j++) {
					entry = (Entry)iter.next();
					cell = row.createCell(j + startCol);
					cell.setCellStyle(textStyle);
					if(entry.getValue() instanceof String) {
						cell.setCellValue(new HSSFRichTextString((String)entry.getValue()));
					} else if(entry.getValue() instanceof BigDecimal) {
						cell.setCellValue(new HSSFRichTextString(((BigDecimal)entry.getValue()).toString()));
					} else if(entry.getValue() instanceof Date) {
						cell.setCellValue(new HSSFRichTextString(((Date)entry.getValue()).toString()));
					} else if(entry.getValue() != null) {
						log.debug("출력되지 않는 컬럼 타입입니다. [" + entry.getValue() + "]");
					}
				}
			}
		}
		/* =====================================================================================
		 * Contents
		 * 종료
		 * =====================================================================================*/





		// 컬럼 사이즈 조정
		for(int i=0; i<colSize + startCol; i++) {
			if(i<startCol) {
				sheet.setColumnWidth(i, 500);
				continue;
			}
			sheet.autoSizeColumn((short)i);
//			int width = (int)(sheet.getColumnWidth(i)*1.4);
//			if (width > 250) {
//				width = 250;
//			}
//			sheet.setColumnWidth(i,  width);
		}





		// 누계처리
		if(model.get("aggregate") != null) {

			HSSFCellStyle aggStyle = getAggStyle(wb);

			int agg = Integer.parseInt((String)model.get("aggregate"));

			int aggRow = sheet.getLastRowNum();
			row = sheet.getRow(aggRow);
			for(int i=startCol; i<colSize+startCol; i++) {
				row.getCell(i).setCellStyle(aggStyle);
			}
			sheet.addMergedRegion(new CellRangeAddress(aggRow, aggRow, startCol, startCol+agg-1));
		}





		// 컬럼 Span
		if(model.get("span") != null) {
			int[][] span = (int[][])model.get("span");
			for(int i=0, s=span.length; i<s; i++) {
				sheet.addMergedRegion(new CellRangeAddress(span[i][1]+startRow+2, span[i][3]+startRow+2, span[i][0]+startCol, span[i][2]+startCol));
			}
		}


		String fileName = createFileName((String)model.get("fileName"));
		response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
	}






	/**
	 * 파일명 생성
	 *
	 * @param fileName
	 * @return
	 * @throws Exception
	 */
	private String createFileName(String fileName) throws Exception {
		String newFileName = null;
		 SimpleDateFormat fileFormat = new SimpleDateFormat("yyyyMMdd_HHmmss");

		 boolean isJeus = false;
		 try {
			 ClassLoader cl = Thread.currentThread().getContextClassLoader();
			 if(cl == null) {
				 cl = ClassLoader.getSystemClassLoader();
			 }
			 cl.loadClass(JEUS_CLASS);
			 isJeus = true;
		 } catch (ClassNotFoundException e) {
			 if(OldExcelView.class.getResource(JEUS_CLASS) != null) {
				 isJeus = true;
			 }
		 }
		 log.debug("isJeus : " + isJeus);


		 if(fileName == null || fileName.length() < 1) {
			 newFileName = "File";
		 } else {
			 if(isJeus) {
				 newFileName = fileName;
			 } else {
//				 newFileName = new String(fileName.getBytes("UTF-8"), "8859_1");
				 newFileName = new String(fileName.getBytes("EUC-KR"), "8859_1");
			 }
		 }

	     return new StringBuilder(newFileName).append("_").append(fileFormat.format(new Date())).append(".xls").toString();
	}






	/**
	 * Title Style
	 *
	 * @param wb
	 * @return
	 */
	private HSSFCellStyle getTitleStyle(HSSFWorkbook wb) {

		HSSFCellStyle style = wb.createCellStyle();
		HSSFFont font = wb.createFont();
		font.setFontHeightInPoints((short)20);
		font.setColor(HSSFColor.WHITE.index);
		font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		style.setFont(font);
		style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		style.setFillForegroundColor(HSSFColor.ORANGE.index);
		style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		style.setBorderTop(HSSFCellStyle.BORDER_THIN);
		style.setTopBorderColor(HSSFColor.BLACK.index);
		style.setBorderRight(HSSFCellStyle.BORDER_THIN);
		style.setRightBorderColor(HSSFColor.BLACK.index);
		style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		style.setBottomBorderColor(HSSFColor.BLACK.index);
		style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		style.setLeftBorderColor(HSSFColor.BLACK.index);

		return style;
	}





	/**
	 * Header Style
	 *
	 * @param wb
	 * @return
	 */
	private HSSFCellStyle getHeaderStyle(HSSFWorkbook wb) {

		HSSFCellStyle style = wb.createCellStyle();
		HSSFFont font = wb.createFont();
		font.setFontHeightInPoints((short)12);
		font.setColor(HSSFColor.BLACK.index);
		font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		style.setFont(font);
		style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		style.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		style.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
		style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		style.setBorderTop(HSSFCellStyle.BORDER_THIN);
		style.setTopBorderColor(HSSFColor.BLACK.index);
		style.setBorderRight(HSSFCellStyle.BORDER_THIN);
		style.setRightBorderColor(HSSFColor.BLACK.index);
		style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		style.setBottomBorderColor(HSSFColor.BLACK.index);
		style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		style.setLeftBorderColor(HSSFColor.BLACK.index);

		return style;
	}




	/**
	 * 내용 Style
	 *
	 * @param wb
	 * @return
	 */
	private HSSFCellStyle getTextStyle(HSSFWorkbook wb) {

		HSSFCellStyle style = wb.createCellStyle();
		HSSFFont font = wb.createFont();
		font.setColor(HSSFColor.BLACK.index);
		style.setFont(font);
		style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		style.setBorderTop(HSSFCellStyle.BORDER_THIN);
		style.setTopBorderColor(HSSFColor.BLACK.index);
		style.setBorderRight(HSSFCellStyle.BORDER_THIN);
		style.setRightBorderColor(HSSFColor.BLACK.index);
		style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		style.setBottomBorderColor(HSSFColor.BLACK.index);
		style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		style.setLeftBorderColor(HSSFColor.BLACK.index);

		return style;
	}



	/**
	 * 누계 Style
	 *
	 * @param wb
	 * @return
	 */
	private HSSFCellStyle getAggStyle(HSSFWorkbook wb) {

		HSSFCellStyle style = wb.createCellStyle();
		HSSFFont font = wb.createFont();
		font.setFontHeightInPoints((short)12);
		font.setColor(HSSFColor.BLACK.index);
		font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		style.setFont(font);
		style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		style.setFillForegroundColor(HSSFColor.LIGHT_YELLOW.index);
		style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		style.setBorderTop(HSSFCellStyle.BORDER_THIN);
		style.setTopBorderColor(HSSFColor.BLACK.index);
		style.setBorderRight(HSSFCellStyle.BORDER_THIN);
		style.setRightBorderColor(HSSFColor.BLACK.index);
		style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		style.setBottomBorderColor(HSSFColor.BLACK.index);
		style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		style.setLeftBorderColor(HSSFColor.BLACK.index);

		return style;
	}




}
