package com.enpem.web.common.biz;

import static org.imgscalr.Scalr.OP_ANTIALIAS;
import static org.imgscalr.Scalr.OP_BRIGHTER;
import static org.imgscalr.Scalr.pad;
import static org.imgscalr.Scalr.resize;

import java.awt.image.BufferedImage;
import java.io.File;
import java.net.InetAddress;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;
import javax.servlet.ServletContext;

import org.imgscalr.Scalr.Method;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.select.Elements;
import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.enpem.web.common.data.Box;
import com.enpem.web.common.exception.BizException;
import com.enpem.web.common.util.ConfigUtil;
import com.enpem.web.common.util.SpringUtil;
import com.enpem.web.common.util.file.FileUtil;

@Service
public class CmnService {
	protected Logger log = LoggerFactory.getLogger(this.getClass());

	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSessionTemplate dao;

	@Autowired
	private ServletContext servletContext;


	/**
	 * 첨부파일 업로드
	 *
	 * @param box
	 * @param mReq
	 * @param model
	 * @throws Exception
	 */
	public void fileUpload(Box box, MultipartHttpServletRequest mReq, ModelMap model) throws Exception {
		String fileKeyNm = box.nvl("fileKeyNm", "file");
		List<MultipartFile> mFileList = mReq.getFiles(fileKeyNm);
		List<Box> fileList = new ArrayList<Box>();

		int imgSize = 0;
		int fileSize = 0;
		for (MultipartFile mFile : mFileList) {
			if (mFile.getContentType().startsWith("image")) {
				imgSize++;
			} else {
				fileSize++;
			}
		}
		if (ConfigUtil.getInt("img.max.cnt") < imgSize) {
			throw new BizException("E103", new String[]{ConfigUtil.getString("img.max.cnt")}); //첨부가능 파일수({0})를 초과했습니다.
		}
		if (ConfigUtil.getInt("file.max.cnt") < fileSize) {
			throw new BizException("E103", new String[]{ConfigUtil.getString("file.max.cnt")}); //첨부가능 파일수({0})를 초과했습니다.
		}

		String fileSeq = "";
		for (MultipartFile mFile : mFileList) {
			if (!mFile.isEmpty()) {

				String fileKey = box.nvl("fileKey", "temp");
				String fileKind = "F";
				String fileExt = mFile.getOriginalFilename().substring(mFile.getOriginalFilename().lastIndexOf(".") + 1, mFile.getOriginalFilename().length());
				if (mFile.getContentType().startsWith("image")) {
					fileKind = "I";
				}
				if (fileExt.equals("csv")) {
					fileKind = "R";
				}
				String saveFilePath = (fileKind.equals("I") ? ConfigUtil.getString("img.path") : ConfigUtil.getString("file.path")) + box.nvl("fileDiv") + "/" + fileKey+ "/";
				String allowExt = fileKind.equals("I") ? ConfigUtil.getString("img.ext") : ConfigUtil.getString("file.ext");
				if (allowExt.indexOf(fileExt) <= -1) {
					throw new BizException("E104", new String[]{allowExt, fileExt}); //허용({0})되지 않은 첨부파일({1}) 형식입니다.
				}
				int fileMaxSize = fileKind.equals("I") ? ConfigUtil.getInt("img.max.size") : ConfigUtil.getInt("file.max.size");
				if (fileMaxSize < mFile.getSize()) {
					throw new BizException("E105", new String[]{(fileMaxSize / 1000 / 1000) + "M"}); //첨부가능 용량({0})을 초과했습니다.
				}

				box.put("fileNm", mFile.getOriginalFilename());
				box.put("fileExt", fileExt);
				box.put("fileType", mFile.getContentType());
				box.put("fileSize", mFile.getSize());
				box.put("fileKind", fileKind);
//				box.put("fileDiv", box.nvl("fileDiv"));
				box.put("fileKey", fileKey);
				box.put("saveFileNm", mFile.getOriginalFilename());
				box.put("saveFilePath", saveFilePath);

				int result = dao.insert("cmn.fileInsert", box);
				if (result <= 0) {
					throw new BizException("E102"); //첨부파일 등록이 실패하였습니다.
				}
				fileSeq += box.nvl("fileSeq") + ",";
				if (!fileKind.equals("I")) {
					dao.update("cmn.fileNmUpdate", box);
				}
			}
		}

		int idx = 0;
		for (MultipartFile mFile : mFileList) {
			if (!mFile.isEmpty()) {
				Box rowBox = new Box();
				String realRoot = servletContext.getRealPath("/");
				String saveFilePath = (mFile.getContentType().startsWith("image") ? ConfigUtil.getString("img.path") : ConfigUtil.getString("file.path"))
						+ box.nvl("fileDiv") + "/" + box.nvl("fileKey", "temp") + "/" + (mFile.getContentType().startsWith("image") ? mFile.getOriginalFilename() : fileSeq.split(",")[idx]);
				String fullPath = realRoot + saveFilePath;
				FileUtil.makeDirectory(fullPath);
				FileUtil.fileUpload(mFile, new File(fullPath));

//				String localIp = InetAddress.getLocalHost().getHostAddress();
				String hostIp = ConfigUtil.getString("server.host.ip");
//				String url = "http://" + localIp + ":" + mReq.getServerPort() + mReq.getContextPath() + saveFilePath;
				String url = "http://" + hostIp + ":" + mReq.getServerPort() +  mReq.getContextPath() + saveFilePath;
				String fileExt = mFile.getOriginalFilename().substring(mFile.getOriginalFilename().lastIndexOf(".") + 1, mFile.getOriginalFilename().length());
				rowBox.put("url", url);
				rowBox.put("fileExt", fileExt);
				rowBox.put("fileSize", mFile.getSize());
				rowBox.put("saveFileNm", mFile.getOriginalFilename());
				rowBox.put("fileNm", fileSeq.split(",")[idx]);
				rowBox.put("fileSeq", fileSeq.split(",")[idx]);
				fileList.add(rowBox);

				idx++;
				log.debug("upload file path : " + url);
			}
		}

		model.put("fileList", fileList);
	}

	/**
	 * 첨부파일 다운로드
	 *
	 * @param box
	 * @param mReq
	 * @param model
	 * @throws Exception
	 */
	public void fileDown(Box box, ModelMap model) throws Exception {
		box.put("tempYn", "N");
		box.put("delYn", "N");
		Box viewBox = dao.selectOne("cmn.fileView", box);
//		String localIp = InetAddress.getLocalHost().getHostAddress();
		String hostIp = ConfigUtil.getString("server.host.ip");
		String saveFilePath = viewBox.nvl("saveFilePath") + URLEncoder.encode(viewBox.nvl("saveFileNm"), "UTF-8");
//		viewBox.put("url", "http://" + localIp + ":" + SpringUtil.getServerPort() + SpringUtil.getContextPath() + saveFilePath);
		viewBox.put("url", "http://" + hostIp  + ":" + SpringUtil.getServerPort() + SpringUtil.getContextPath() + saveFilePath);
		viewBox.put("servletPath", servletContext.getRealPath("/").substring(0, servletContext.getRealPath("/").length() - 1));
		model.put("view", viewBox);
	}

	/**
	 * 대용량엑셀파일 다운로드
	 *
	 * @param box
	 * @param mReq
	 * @param model
	 * @throws Exception
	 */
	public void csvDown(Box box, ModelMap model) throws Exception {
		Box viewBox = dao.selectOne("cmn.csvView", box);
		viewBox.put("fileType", "application/download");
		String saveFilePath = viewBox.nvl("saveFilePath") + URLEncoder.encode(viewBox.nvl("saveFileNm"), "UTF-8");
		viewBox.put("url", saveFilePath);
//		viewBox.put("servletPath", "C:");
		model.put("view", viewBox);
	}

	/**
	 * 첨부파일처리
	 *
	 * @param box
	 * @param mReq
	 * @param model
	 * @throws Exception
	 */
	public void fileProc(Box box, ModelMap model) throws Exception {

		if (null != box.getArry("fileList")) {
			for (String row : box.getArry("fileList")) {
				box.put("fileSeq", row.split(",")[1]);
				if (row.split(",")[0].equals("new")) {
					dao.insert("cmn.fileStatUpdate", box); //첨부파일 정상상태로 변경
				} else if (row.split(",")[0].equals("del")) {
					if (box.ne("OP_FLAG", "D")) {
						Box delBox = dao.selectOne("cmn.fileView", box); //첨부파일 PK조회
						this.fileRealDelete(delBox);
						dao.delete("cmn.fileDelete", box); //첨부파일 삭제
					}
				}
			}
		}

		//실제파일 삭제처리 : 삭제일경우 임시상태 여부와 무관하게 일괄삭제 / 등록,수정일 경우 임시상태인 파일삭제
		box.put("delYn", "N");
		box.put("tempYn", box.decode("OP_FLAG", "D", "", "Y"));
		List<Box> delList = dao.selectList("cmn.fileList", box); //(삭제대상) 첨부파일 목록
		for (Box rowBox : delList) {
			this.fileRealDelete(rowBox);
		}
		dao.delete("cmn.fileStatDelete", box); //첨부파일 상태별 삭제
	}

	/**
	 * 실제 경로의 파일삭제
	 *
	 * @param rowBox
	 */
	public void fileRealDelete(Box rowBox) {
		String realRoot = servletContext.getRealPath("/").substring(0, servletContext.getRealPath("/").length() - 1);
		log.debug("삭제파일 : " + realRoot + rowBox.nvl("saveFilePath") + rowBox.nvl("fileNm"));
		File fileName = new File(realRoot + rowBox.nvl("saveFilePath") + rowBox.nvl("fileNm"));
		if(fileName.exists()){
			fileName.delete();
		}
	}

	/**
	 * 시퀀스 증가후 조회
	 *
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	public void seqView(Box box, ModelMap model) throws Exception {
		int result = dao.update("cmn.seqUpdate", box);
		model.put("view", result > 0 ? dao.selectOne("cmn.seqView", box) : null);
	}

	/**
	 * 썸네일 생성 작업
	 *
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	public void thumb(Box box, ModelMap model) throws Exception {
		if (ConfigUtil.getString("thumb.yn").equals("Y")) {
			if (box.eq("OP_FLAG", "C", "U")) {
				String source = box.nvl(box.nvl("editNm"));
				Document doc = Jsoup.parse(source);
				Elements elements = doc.select("img");
				String[] urls = checkElements(elements);
//				String localIp = InetAddress.getLocalHost().getHostAddress();
				String hostIp = ConfigUtil.getString("server.host.ip");

				log.debug("썸네일 생성 작업 처리 시작.. ");
				if (urls != null) {
					for (int idx = 0; idx < urls.length; idx++) {
						log.debug(urls[idx]);
						if (urls[idx].startsWith(hostIp)) {
							String realRoot = servletContext.getRealPath("/").substring(0, servletContext.getRealPath("/").length() - 1);
							urls[idx] = urls[idx].substring(urls[idx].lastIndexOf("/") + 1);
							String ext = urls[idx].substring(urls[idx].lastIndexOf(".") + 1);

							File file = new File(realRoot + ConfigUtil.getString("img.path") + box.nvl("fileDiv") + "/" + box.nvl("seq") + "/" + urls[idx]);
							log.debug(realRoot + ConfigUtil.getString("img.path") + box.nvl("fileDiv") + "/" + box.nvl("seq") + "/" + urls[idx]);
							BufferedImage img = ImageIO.read(file);
							BufferedImage thumbnail = createThumbnail(img);

							String thubmPath = realRoot + ConfigUtil.getString("thumb.path") + box.nvl("fileDiv") + "/" + box.nvl("seq") + "/";
							FileUtil.makeDirectory(thubmPath);
							File thumbnailoutput = new File(thubmPath + urls[idx]);
							ImageIO.write(thumbnail, ext, thumbnailoutput);
						}
					}
				}
			}
		}
	}

	/**
	 * 썸네일용 엘리먼트 체크
	 *
	 * @param elements
	 * @return
	 */
	public String[] checkElements(Elements elements) {
		String[] urls = new String[elements.size()];
		for (int idx = 0; idx < elements.size(); idx++) {
			Elements elem = elements.get(idx).getElementsByAttribute("src");
			String url = elem.toString();
			int pos = url.indexOf("src=\"") + 5;
			url = url.substring(pos, url.indexOf("\"", pos));
			log.debug("img url :{}",url);
			log.debug(url.startsWith("http")+":"+url);
			urls[idx] = url;
		}
		return urls;
	}

	/**
	 * 이미지 썸네일 실제 수행
	 *
	 * @param img
	 * @return
	 */
	public static BufferedImage createThumbnail(BufferedImage img) {
		img = resize(img, Method.SPEED, 150, OP_ANTIALIAS, OP_BRIGHTER);
		return pad(img, 4);
	}

	/**
	 * 필수 체크
	 *
	 * @param box
	 * @param reqNms
	 * @return
	 * @throws Exception
	 */
	public Boolean required(Box box, String... reqNms) throws Exception {
		for (String reqNm : reqNms) {
			if ("".equals(box.nvl(reqNm))) {
				box.put("errorDuplMsg", " (" + reqNm + "은 필수입력입니다.)");
				return false;
			}
		}
		return true;
	}

	/**
	 * 예외처리 상세 정보
	 *
	 * @param e
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public Map errorInfo(Exception e) throws Exception {
		Map errorMap = new HashMap();
		Throwable nested = e.getCause();
		if (nested != null) {
			if (nested instanceof SQLException) {
				SQLException se = (SQLException) nested;
				errorMap.put("errorCode", se.getErrorCode());
				errorMap.put("message", se.getMessage());
				errorMap.put("sqlState", se.getSQLState());
			}
		}

		return errorMap;
	}

}
