package com.enpem.web.common.spring;

import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.web.servlet.view.AbstractView;

public abstract class AbstractExcelView extends AbstractView {
	private static final String CONTENT_TYPE = "application/vnd.ms-excel";
	private static final String EXTENSION = ".xlsx";
	
	public AbstractExcelView() {
		setContentType(CONTENT_TYPE);
	}
	
	@Override
	protected void renderMergedOutputModel(Map<String, Object> modelMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		XSSFWorkbook workbook = new XSSFWorkbook();
		buildExcelDocument(modelMap, workbook, request, response);
		response.setContentType(getContentType());
		ServletOutputStream out = response.getOutputStream();
		workbook.write(out);
		out.flush();
	}
	
	public static String getExtension() {
		return EXTENSION;
	}

	protected abstract void buildExcelDocument(Map<String, Object> paramMap,
			XSSFWorkbook workbook,
			HttpServletRequest request,
			HttpServletResponse response) throws Exception;

}
