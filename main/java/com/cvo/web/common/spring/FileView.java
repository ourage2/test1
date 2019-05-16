package com.enpem.web.common.spring;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.servlet.View;

import com.enpem.web.common.data.Box;
import com.enpem.web.common.exception.BaseException;
import com.enpem.web.common.exception.BizException;
import com.enpem.web.common.util.ConfigUtil;
import com.enpem.web.common.util.HttpUtil;
import com.enpem.web.common.util.StringUtil;
import com.enpem.web.common.util.WebUtil;

public class FileView implements View {

	protected Logger log = LoggerFactory.getLogger(this.getClass());
	public static final String DEFAULT_CONTENT_TYPE = "application/download";
	private String contentType = DEFAULT_CONTENT_TYPE;

	/**
	 * Instantiates a new json view.
	 */
	public FileView() {
		setContentType(DEFAULT_CONTENT_TYPE);
	}

	/**
	 * Sets the content type.
	 *
	 * @param contentType the new content type
	 */
	public void setContentType(String contentType) {
		this.contentType = contentType;
	}

	/* (non-Javadoc)
	 * @see org.springframework.web.servlet.View#getContentType()
	 */
	public String getContentType() {
		return this.contentType;
	}

	/* (non-Javadoc)
	 * @see org.springframework.web.servlet.View#render(java.util.Map, javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	@SuppressWarnings("rawtypes")
	public void render(Map model, HttpServletRequest request, HttpServletResponse response) throws Exception {
//		if (((String)model.get("success")).equals("true")) {
//			throw new BizException("F500"); //시스템오류
//		}
		log.debug("[Response] DOWNLOAD");
		Box viewBox = (Box)model.get("view");

//		log.debug(" isDownloadCookie " + CookieUtil.getCookie("ajaxFileDownloading"));
//		log.debug(" isDownloadCookie " + WebUtil.isDownloadCookie(request));

//		response.setContentType(getContentType());
//		response.setContentType("application/download;charset=UTF-8");
//		response.setContentType("application/download;charset=EUC-KR");
//		response.setContentType(DEFAULT_CONTENT_TYPE);
		response.setContentType(viewBox.nvl("fileType"));

		response.addHeader("Pragma", "no-cache");
		response.addHeader("Cache-Control", "no-cache, no-store, max-age=0");
		response.addDateHeader("Expires", 1L);

		String rpyHeader = HttpUtil.getHeaderToFormatJson(response);
		log.debug("[Response Header]\n{}", rpyHeader);

		log.debug("viewBox:"+viewBox);
//		log.debug("response:"+response.getOutputStream());
		String saveFilePath = viewBox.nvl("saveFilePath");
		String fileNm = viewBox.nvl("fileNm");
		String saveFileNm = viewBox.nvl("saveFileNm");
		log.debug("orgFileNm : " + viewBox.nvl("servletPath") + saveFilePath + fileNm);
		log.debug("saveFileNm : " + viewBox.nvl("servletPath") + saveFilePath + saveFileNm);
		File orgFile = new File(viewBox.nvl("servletPath") + saveFilePath + fileNm);

		if(orgFile == null || !orgFile.isFile()) {
			throw new BizException("F404"); //NOT FOUND
		}

		if (null != orgFile && orgFile.exists()) {
			int fileLen = (int)orgFile.length();
			log.debug("File size : {}", fileLen);
			response.setContentLength(fileLen);
			WebUtil.setDisposition(saveFileNm, request, response);
			FileInputStream fis = null;
			try {
				OutputStream out = response.getOutputStream();

				fis = new FileInputStream(orgFile);
				FileCopyUtils.copy(fis, out);
				out.flush();
				out.close();
			} catch (Exception e) {
				throw new BaseException(e);
			} finally {
				if (fis != null) {
					try {
						fis.close();
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
		}

	}

//	@SuppressWarnings({ "rawtypes"})
//	protected final void renderMergedOutputModel(Map model,	HttpServletRequest request, HttpServletResponse response) throws Exception {
//
//		File file = new File("c:/bak/" + box.nvl("fileNm"));
//		String rtn = "";
//	    if (file.exists()) {
//	    	rtn = "c:/bak/" + box.nvl("fileNm");
//	    } else {
//			new File(file.getParent()).mkdirs();
//			if (file.createNewFile()) {
//				rtn = file.getAbsolutePath();
//			}
//	    }
//		FileOutputStream fos = new FileOutputStream(file);
//		fos.write((byte[])box.get("file"));
//		fos.flush();
//		fos.close();
//
//		String CONTENT_TYPE = "application/download;charset=UTF-8";
//		String CONTENT_DESCRIPTION = "JSP Generated Data";
//		response.setContentType(CONTENT_TYPE);
//		response.setHeader("Content-Description", CONTENT_DESCRIPTION);
//		WebUtil.setDisposition(box.nvl("fileNm"), request, response);
//		ServletOutputStream out = response.getOutputStream();
//		FileInputStream fis = new FileInputStream(file);
//		FileCopyUtils.copy(fis, out);
////		workbook.write(out);
//		out.flush();
//	}
}

