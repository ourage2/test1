package com.enpem.web.common.util;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipOutputStream;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ZipUtil {

	private static final Logger LOG = LoggerFactory.getLogger(ZipUtil.class);

	/**
	 * 디렉토리 및 파일을 압축한다.
	 * @param orgFilePath 압축할 디렉토리 및 파일
	 * @param targetPath 압축파일을 생성할 경로
	 * @param zipFileNm 압축파일의 이름
	 */
	public static void createZipFile(String orgFilePath, String targetPath, String zipFileNm) {

		File dir = new File(orgFilePath);
		String[] list = dir.list();
		String _path;

		if (!dir.canRead() || !dir.canWrite()) {
			return;
		}
		int len = list.length;

		if (orgFilePath.charAt(orgFilePath.length() - 1) != '/') {
			_path = orgFilePath + "/";
		} else {
			_path = orgFilePath;
		}

		ZipOutputStream zipOut = null;
		try {
			zipOut = new ZipOutputStream(new BufferedOutputStream(new FileOutputStream(targetPath + "/" + zipFileNm), 2048));

			for (int i = 0; i < len; i++) {
				zipFolder("", new File(_path + list[i]), zipOut);
			}
			zipOut.close();

		} catch (FileNotFoundException e) {
			LOG.error("File not found", e.getMessage());

		} catch (IOException e) {
			LOG.error("IOException", e.getMessage());
		} finally {
			if (null != zipOut) { zipOut = null; }
		}
	}

	/**
	 * 디렉토리 및 파일을 압축한다.
	 * @param orgFilesPath 압축할 디렉토리 및 파일들
	 * @param targetPath 압축파일을 생성할 경로
	 * @param zipFileNm 압축파일의 이름
	 */
	public static void createZipFile(String[] orgFilesPath, String targetPath, String zipFileNm) {

		ZipOutputStream zipOut = null;
		try {
			zipOut = new ZipOutputStream(new BufferedOutputStream(new FileOutputStream(targetPath + "/" + zipFileNm), 2048));
			for (int idx = 0; idx < orgFilesPath.length; idx++) {
				zipFolder("", new File(orgFilesPath[idx]), zipOut);
			}
			zipOut.close();

		} catch (FileNotFoundException e) {
			LOG.error("File not found", e.getMessage());

		} catch (IOException e) {
			LOG.error("IOException", e.getMessage());
		} finally {
			if (null != zipOut) { zipOut = null; }
		}
	}

	/**
	 * ZipOutputStream를 넘겨 받아서 하나의 압축파일로 만든다.
	 * @param parent 상위폴더명
	 * @param file 압축할 파일
	 * @param zipOut 압축전체스트림
	 * @throws IOException
	 */
	private static void zipFolder(String parent, File file, ZipOutputStream zipOut) throws IOException {
		byte[] data = new byte[2048];
		int read;

		if (file.isFile()) {
			ZipEntry entry = new ZipEntry(parent + file.getName());
			zipOut.putNextEntry(entry);
			BufferedInputStream instream = new BufferedInputStream(new FileInputStream(file));

			while ((read = instream.read(data, 0, 2048)) != -1) {
				zipOut.write(data, 0, read);
			}
			zipOut.flush();
			zipOut.closeEntry();
			instream.close();

		} else if (file.isDirectory()) {

//			String parentString = file.getPath().replace(ConfigUtil.getString(""), "");
			String parentString = file.getPath();
			parentString = parentString.substring(0,parentString.length() - file.getName().length());
			ZipEntry entry = new ZipEntry(parentString+file.getName() + "/");
			zipOut.putNextEntry(entry);

			String[] list = file.list();
			if (list != null) {
				int len = list.length;
				for (int i = 0; i < len; i++) {
					zipFolder(entry.getName(),new File(file.getPath() + "/" + list[i]), zipOut);
				}
			}
		}
	}

	/**
	 * 압축을 해제 한다
	 *
	 * @param zipFile
	 * @param directory
	 */
	public static boolean extractZipFile(String zipFile, String targetPath) {
		boolean result = false;

		byte[] data = new byte[2048];
		ZipEntry entry = null;
		ZipInputStream zipstream = null;
		FileOutputStream out = null;

		if (!(targetPath.charAt(targetPath.length() - 1) == '/'))
			targetPath += "/";

		File destDir = new File(targetPath);
		boolean isDirExists = destDir.exists();
		boolean isDirMake = destDir.mkdirs();

		try {
			zipstream = new ZipInputStream(new FileInputStream(zipFile));

			while ((entry = zipstream.getNextEntry()) != null) {

				int read = 0;
				File entryFile;

				//디렉토리의 경우 폴더를 생성한다.
				if (entry.isDirectory()) {
					File folder = new File(targetPath+entry.getName());
					if(!folder.exists()){
						folder.mkdirs();
					}
					continue;
				}else {
					entryFile = new File(targetPath + entry.getName());
				}

				if (!entryFile.exists()) {
					boolean isFileMake = entryFile.createNewFile();
				}

				out = new FileOutputStream(entryFile);
				while ((read = zipstream.read(data, 0, 2048)) != -1)
					out.write(data, 0, read);

				zipstream.closeEntry();

			}

			result = true;
		} catch (FileNotFoundException e) {
			e.printStackTrace();
			result = false;
		} catch (IOException e) {
			e.printStackTrace();
			result = false;
		} finally {
			if (out != null) {
				try {
					out.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}

			if (zipstream != null) {
				try {
					zipstream.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}

		return result;
	}

}