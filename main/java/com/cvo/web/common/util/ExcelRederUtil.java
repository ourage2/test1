package com.enpem.web.common.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.Iterator;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/* jxl 사용 */
//import jxl.Cell;
//import jxl.Sheet;
//import jxl.Workbook;


/* excelReader */
public class ExcelRederUtil {

	protected Logger log = LoggerFactory.getLogger(this.getClass());

	public static String[][] simpleExcelReadPoi(InputStream targetFile, int sheetNo) throws Exception {
		return simpleExcelReadPoi(targetFile, sheetNo, 1, 2);
	}

	public static String[][] simpleExcelReadPoi(File targetFile, int sheetNo) throws Exception {
		InputStream file = new FileInputStream(targetFile);
		return simpleExcelReadPoi(file, sheetNo, 1, 2);
	}

	/* Poi 사용 */
	public static String[][] simpleExcelReadPoi(InputStream file, int sheetNo, int startColNo, int startRowNo) throws Exception {
		org.apache.poi.ss.usermodel.Workbook workbook = null;
		org.apache.poi.ss.usermodel.Sheet sheet = null;
		org.apache.poi.ss.usermodel.Row row = null;
		org.apache.poi.ss.usermodel.Cell cell = null;
		String[][] data = null;
//		FileInputStream file = new FileInputStream(targetFile);
		workbook = org.apache.poi.ss.usermodel.WorkbookFactory.create(file);
		file.close();

		org.apache.poi.ss.usermodel.FormulaEvaluator evaluator = workbook.getCreationHelper().createFormulaEvaluator();
		sheet = workbook.getSheetAt(sheetNo);

		int rows = sheet.getLastRowNum();
		int cells = sheet.getRow(4).getLastCellNum();
//			if(rows > 200){ rows = 200; }
		System.out.println("!!!!!!!!!rows:" + rows);
		System.out.println("!!!!!!!!!cells:" + cells);
		data = new String[rows + 1][cells];
		int idx = 0;
		for(Iterator all = sheet.iterator(); all.hasNext(); ){
			org.apache.poi.ss.usermodel.Row ds = (org.apache.poi.ss.usermodel.Row)all.next();
			if (idx > startRowNo) {
				for(int i = startColNo; i < cells; i++){
					int cellType = 9;
					cell = ds.getCell(i);
//					log.debug("!!!!!!!!!!row:" + idx + "  cell("+i+"):" + cell);
					if(null != cell) { cellType = cell.getCellType();}
					switch(cellType){
						case 0:  //Cell.CELL_TYPE_NUMERIC :
							if(org.apache.poi.ss.usermodel.DateUtil.isCellDateFormatted(cell)){
								data[idx][i] = cell.getDateCellValue().toString();
							} else{
								data[idx][i] = Integer.toString((int) cell.getNumericCellValue());
							}
							break;
						case 1: //Cell.CELL_TYPE_STRING :
							data[idx][i] = cell.getRichStringCellValue().getString();
							break;
						case org.apache.poi.ss.usermodel.Cell.CELL_TYPE_BOOLEAN :
							data[idx][i] = cell.getBooleanCellValue()+"";
							break;
						case org.apache.poi.ss.usermodel.Cell.CELL_TYPE_FORMULA :
							if(evaluator.evaluateFormulaCell(cell) == org.apache.poi.ss.usermodel.Cell.CELL_TYPE_NUMERIC){
								if(org.apache.poi.ss.usermodel.DateUtil.isCellDateFormatted(cell)){
									data[idx][i] = "";
								} else{
									Double value = new Double(cell.getNumericCellValue());
			                        if((double)value.longValue() == value.doubleValue()){
			                        	data[idx][i] = data[idx][i] = Long.toString(value.longValue());
			                        } else{
			                        	data[idx][i] = data[idx][i] = value.toString();
									}
								}
							} else if(evaluator.evaluateFormulaCell(cell) == org.apache.poi.ss.usermodel.Cell.CELL_TYPE_STRING){
								data[idx][i] = cell.getStringCellValue();
							} else if(evaluator.evaluateFormulaCell(cell) == org.apache.poi.ss.usermodel.Cell.CELL_TYPE_BOOLEAN){
								data[idx][i] = new Boolean(cell.getBooleanCellValue()).toString();
							} else {
								data[idx][i] = cell.toString();
							}
							break;
						case 9:
							data[idx][i] = "";
						default:
					}
				}
			}

			idx++;
		}
			// 데이터 검증 테스트
//			for (int r = 0; r < data.length; r++) {
//				for (int c = 0; c < data[0].length; c++) {
//					System.out.println("index : " + r + ", column Index : " + c + ", data : " + data[r][c]);
//				}
//			}
//		targetFile.deleteOnExit();
		workbook.close();


		return data;
	}
}
