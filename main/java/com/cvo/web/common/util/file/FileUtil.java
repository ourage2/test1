package com.enpem.web.common.util.file;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.channels.FileChannel;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.multipart.MultipartFile;

import com.enpem.web.common.data.Box;
import com.enpem.web.common.exception.BaseException;
import com.enpem.web.common.util.DateUtil;
import com.enpem.web.common.util.StringUtil;

public class FileUtil {

	protected static Logger log = LoggerFactory.getLogger(FileUtil.class);

	public static final int BUFF_SIZE = 2048;

	/**
	 * 	 디렉토리 생성.
	 *
	 * @param dirPath the dir path
	 */
	public static void makeDirectory(final String dirPath) {
		File directory = new File(dirPath);
		if (!directory.exists() ) {
			if (!directory.mkdirs() ) {
				throw new BaseException( String.format( "요청한 디렉토리 생성 오류", directory.getAbsolutePath()));
			}
		}
	}

	/**
	 * 파일 디렉토리 이동.
	 *
	 * @param orgFile the org file
	 * @param movePath the move path
	 */
	public static void fileMove(String orgFile, String movePath) {
		makeDirectory(movePath);
		File currentFile = new File( orgFile );
		String moveFile = movePath +"/"+ currentFile.getName();
		File newFile = new File( moveFile );

		if( newFile.exists() ){
			moveFile = String.format("%s.%s", moveFile, DateUtil.now(DateUtil.DATE_TIME_PATTERN));
			File newFile_2 = new File( moveFile );
			currentFile.renameTo(newFile_2);

		}else{
			currentFile.renameTo(newFile);
		}

	}

	/**
	 * file name 변경 및 디렉토리 이동.
	 *
	 * @param orgFile the org file
	 * @param movePath the move path
	 * @param newFileNm the new file nm
	 */
	public static void fileMoveRename(String orgFile, String movePath, String newFileNm) {
		makeDirectory(movePath);
		File currentFile = new File( orgFile );
		String moveFile = movePath +"/"+ newFileNm;
		File newFile = new File( moveFile );

		if( newFile.exists() ){
			moveFile = String.format("%s.%s", moveFile, DateUtil.now(DateUtil.DATE_TIME_PATTERN));
			File newFile_2 = new File( moveFile );
			currentFile.renameTo(newFile_2);

		}else{
			currentFile.renameTo(newFile);
		}

	}

	/**
	 * file name 변경 및 디렉토리 이동.
	 *
	 * @param orgFile the org file
	 * @param newFileNm the new file nm
	 */
	public static void fileRename(String orgFile, String newFileNm) {
		File currentFile = new File( orgFile );
		File newFile = new File( newFileNm );

		if( currentFile.exists() ){
			currentFile.renameTo(newFile);
		}
	}

	/**
	 *  Check available directory.
	 *
	 * @param directory the directory
	 * @return boolean
	 */
	public static boolean isDirAvailable( File directory )
	{
		boolean result = false;
		if ( directory.exists( ) && directory.isDirectory( ) )
		{
			result = true;
		}
		return result;
	}


	/**
	 * 디렉토리 파일 리스트 검색.
	 *
	 * @param dirName - 디렉토리 명칭
	 * @return List<String> - 파일명 리스트
	 * @throws IOException - 디렉토리 검색 오류
	 */
	public static List<String> getDirFileDatList(String dirName) throws IOException {

		List<String> fileList = new ArrayList<String>();


		File requestDir = new File(dirName);

		if( !requestDir.exists() ){
			throw new IOException( "Not exist or not a directory." );
		}else{
			File []files= requestDir.listFiles();


			for (File file : files) {
				fileList.add(file.getPath());
			}
		}
		return fileList;
	}

	/**
	 * 디렉토리 파일 리스트 검색.
	 *
	 * @param dirName - 디렉토리 명칭
	 * @param listFileNm the list file nm
	 * @return List<String> - 파일명 리스트
	 * @throws IOException - 디렉토리 검색 오류
	 */
	public static List<String> getDirFileList(String dirName, String listFileNm) throws IOException {
		List<String> fileList = new ArrayList<String>();
		fileList.clear();

		File requestDir = new File(dirName);

		//Directory 에 파일이 존재하지 않으면 로그 저장
		if( !requestDir.exists() ){
			throw new IOException( "Not exist or not a directory." );
		}else{
			if ( isDirAvailable( requestDir ) ){
				//현 디렉토리에 pgp 확장자 파일 존재 여부 및 파일 리스트 가져오기
				FilenameFilterImpl filenameFilter = new FilenameFilterImpl( listFileNm );
				File[] files = requestDir.listFiles( filenameFilter );

				for (File file : files) {
					fileList.add(file.getPath());
				}
			}
		}

		return fileList;
	}

	/**
	 * File Copy.
	 *
	 * @param inFile the in file
	 * @param outFile the out file
	 * @throws IOException Signals that an I/O exception has occurred.
	 */
	public static void copyToFile(File inFile, File outFile)   throws IOException {
		FileChannel inChannel = null;
		FileChannel outChannel = null;

		try {
			makeDirectory(outFile.getParent());

			inChannel = new	FileInputStream(inFile).getChannel();
			outChannel = new FileOutputStream(outFile).getChannel();
			inChannel.transferTo(0, inChannel.size(), outChannel);
		}catch (IOException e) {
			throw new IOException(e.getMessage());
		}finally {
			if (inChannel != null) inChannel.close();
			if (outChannel != null) outChannel.close();
		}
	}

	/**
	 * 파일을 삭제한다.
	 *
	 * @param orgFullFilenm the org full filenm
	 */
	public static void fileDelete(String orgFullFilenm) {
		File fileName = new File(orgFullFilenm);

		if( fileName.exists() ){
			fileName.delete();
		}
	}

	/**
	 * fileNameCheck - FileName pattern 체크.
	 *
	 * @param fileName the file name
	 * @param paternFomat the patern fomat
	 * @return Matcher 응답 결과
	 */
	public static Matcher checkPgpFileName(final String fileName, String paternFomat){

		log.debug("** checkPgpFileName : {}",fileName  );

		final Pattern pattern = Pattern.compile(paternFomat);
		final Matcher matcher = pattern.matcher(fileName);

		return matcher;
	}

	/**
	 * fileNameCheck - FileName pattern 체크.
	 *
	 * @param fileName the file name
	 * @return Matcher 응답 결과
	 *
	 * 	public Matcher checkFileName(final String fileName){
	 * 		final Pattern pattern = Pattern.compile(BatchFormat.FILE_NAME_PATTERN.getCode());
	 * 		final Matcher matcher = pattern.matcher(fileName);
	 *
	 * 		return matcher;
	 * 	}
	 */

	/**
	 * File Name 가져오기
	 *
	 * @param fileName
	 * @return
	 */
	public static String fileGetName(String fileName) {
		File fileNm = new File(fileName);
		String fName = fileNm.getName();
		return fName;
	}


	/**
	 * 디렉토리 파일 존재 여부.
	 *
	 * @param fileName - 체크할 파일명
	 * @return boolean - 파일 존배 여부
	 */
	public static boolean isFile(String fileName) {
		boolean isFile = true;

		File createdFile = new File(fileName);
		if (!createdFile.isFile()) {
			isFile = false;
		}

		return isFile;
	}

	/**
	 * Gets the file name box.
	 *
	 * @param fileName the file name
	 * @return the file name box
	 */
	public static Box getFileNmDiv(String fileName) {
		Box fileNameBox = new Box();
		if(StringUtil.isNotEmpty(fileName)) {
			int index = fileName.lastIndexOf(".");
			if(index > -1) {
				fileNameBox.put("prefix", fileName.substring(0, index));
				String suffix = fileName.substring(index+1);
				if(StringUtil.isEmpty(suffix)) {
					fileNameBox.put("prefix", fileNameBox.getString("prefix") + ".");
					fileNameBox.put("suffix", "");
				} else {
					fileNameBox.put("suffix", suffix);
				}
			} else {
				fileNameBox.put("prefix", fileName);
				fileNameBox.put("suffix", "");
			}
		}
		return fileNameBox;
	}

	/**
	 * 파일 확장자 가져오기 .
	 *
	 * @param fileName the file name
	 * @return the extension
	 */
	public static String getExt(String fileName) {
		String extension = null;
		if(StringUtil.isNotEmpty(fileName)) {
			int index = fileName.lastIndexOf(".");
			if(index > -1) {
				extension = fileName.substring(index+1);
			}
		}
		return extension;
	}

	public static boolean fileDelete(File file) {
		boolean isDelete = false;
		if(file != null && file.exists() && file.isFile()) {
			isDelete = file.delete();
			if(isDelete) {
				log.debug("file delete successfully : {}", file);
			} else {
				log.debug("file delete failed : {}", file);
			}
			return file.delete();
		}
		return isDelete;
	}

	/**
	 * File upload.
	 *
	 * @param fromFile the from file
	 * @param toFile the to file
	 */
	public static void fileUpload(MultipartFile fromFile, File toFile) {
		try {
			if(fromFile != null && toFile != null && !toFile.isFile()) {
				fromFile.transferTo(toFile);
			}
		} catch (Exception e) {
			throw new BaseException(e);
		}
	}

	/**
	 * Move after delete file.
	 *
	 * @param source the source
	 * @param destDir the dest dir
	 * @param destFileName the dest file name
	 * @return true, if successful
	 */
	public static boolean moveAfterDelFile(String source,  String destDir, String destFileName) {

		boolean result = false;

		log.debug("### source : {}", source );
		log.debug("### destDir : {}", destDir );
		log.debug("### destFileName : {}", destFileName );

		FileInputStream inputStream = null;
		FileOutputStream outputStream = null;

		File destFolder = new File(destDir);
		if(!destFolder.exists()){
			destFolder.mkdirs();
		}

		try {
			inputStream = new FileInputStream(source);
			outputStream = new FileOutputStream(destDir + destFileName);
		} catch (FileNotFoundException e) {
			e.printStackTrace();
			result = false;
		}

		FileChannel fcin = inputStream.getChannel();
		FileChannel fcout = outputStream.getChannel();

		long size = 0;

		try {
			size = fcin.size();
			fcin.transferTo(0, size, fcout);

			fcout.close();
			fcin.close();
			outputStream.close();
			inputStream.close();

			result = true;
		} catch (IOException e) {
			e.printStackTrace();
			result = false;
		}

		File f = new File(source);

		if (f.delete()) {
			result = true;
		}

		if (result){
			log.debug("### moveAfterDeleteFile retrun : [true]");
		} else {
			log.debug("### moveAfterDeleteFile retrun : [false]");
		}

		return result;
	}

	/**
	 * 첨부파일을 서버에 저장한다.
	 *
	 * @param file
	 * @param newName
	 * @param stordFilePath
	 * @throws Exception
	 */
	public static void writeUploadFile(MultipartFile file, String newName, String stordFilePath) {

		InputStream stream = null;
		OutputStream bos = null;

		try {
			stream = file.getInputStream();
			File cFile = new File(stordFilePath);

			if (!cFile.isDirectory()) {
				boolean _flag = cFile.mkdir();
				if (!_flag) {
					throw new IOException("Directory creation Failed ");
				}
			}

			bos = new FileOutputStream(stordFilePath + File.separator + newName);
			int bytesRead = 0;
			byte[] buffer = new byte[BUFF_SIZE];
			while ((bytesRead = stream.read(buffer, 0, BUFF_SIZE)) != -1) {
				bos.write(buffer, 0, bytesRead);
			}
		} catch (FileNotFoundException fnfe) {
			fnfe.printStackTrace();
		} catch (IOException ioe) {
			ioe.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (bos != null) {
				try {
					bos.close();
				} catch (Exception ignore) {
					log.debug("IGNORED: " + ignore.getMessage());
				}
			}

			if (stream != null) {
				try {
					stream.close();
				} catch (Exception ignore) {
					log.debug("IGNORED: " + ignore.getMessage());
				}
			}
		}
	}

	public static File getFile(String path, String fileName) {
		if(!StringUtil.isEmpty(path)) {
			return null;
		}
		if(!StringUtil.isEmpty(fileName)) {
			return null;
		}
		if(!path.endsWith("/")) {
			path += "/";
		}
		return getFile(path + fileName);
	}

	public static File getFile(String source) {
		log.debug("File Path : {}", source);
		File file = new File(source);
		if(file.exists() && file.isFile()) {
			return file;
		}
		log.info("no file");
		return null;
	}

	public static void writeFile(byte[] data, File file) {
		log.debug("File Write : {}", file);
		OutputStream output = null;
		try {
			output = new FileOutputStream(file);
			output.write(data);
			output.flush();
		} catch(IOException e) {
			throw new RuntimeException(e);
		} finally {
			try {
				if (output != null) {
					output.close();
				}
			} catch(Exception e) {
			}
		}
	}

	public static void removeFile(File file) {
		log.debug("File Remove : {}", file);
		if(file != null && file.exists() && file.isFile()) {
			if(file.delete()) {
				log.debug("File Remove Complete.");
			}
		}
	}

	/**
	* If file size is more than flleSpliteSize parameter, the file will be divided to seperated files.
	* @param filename : File name with full path
	* @param fileSplitSize
	* @param deleteOrgFile : weather delete original file or not
	*/
	public static void split(String filename, long fileSplitSize, boolean deleteOrgFile) throws Exception {
		try {
			File file = new File(filename);
			String path = file.getParent();
			FileInputStream in = new FileInputStream(file);

			long originTotalFileLength = file.length();
			long jobProcess = fileSplitSize;
			long chunkCnt = (long)Math.ceil((double)originTotalFileLength / (double)fileSplitSize);

			for (int i = 1; i <= chunkCnt; i++) {
				FileOutputStream fout = new FileOutputStream(filename + "_" + i);
				int len = 0;
				byte[] buf = new byte[1024];

				while ((len = in.read(buf, 0, 1024)) != -1) {
					fout.write(buf, 0, len);
					jobProcess = jobProcess + len;

					if (fileSplitSize * (i + 1) == jobProcess) break;
				}
				fout.flush();
				fout.close();
			}
			in.close();
			if (deleteOrgFile && new File(filename).exists()) new File(path, filename).delete();

		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	/**
	* Merge Files
	* @param newFileName
	* @param filenames
	* @param removeSplittedFiles
	* @throws Exception
	*/
	public static void merge(String newFileName, String[] filenames, boolean removeSplittedFiles) throws Exception {
		FileOutputStream fout = null;
		FileInputStream in = null;
		BufferedInputStream bis = null;
		try {
			File newFile = new File(newFileName);
			fout = new FileOutputStream(newFile);

			for (String fileName : filenames) {
				File splittedFile = new File(fileName);
				in = new FileInputStream(splittedFile);
				bis = new BufferedInputStream(in);
				int len = 0;
				byte[] buf = new byte[1024];
				while ((len = bis.read(buf, 0, 1024)) != -1) {
					fout.write(buf, 0, len);
				}
				in.close();
				bis.close();
//				if(removeSplittedFiles && splittedFile.exists()) {
//					removeFile(splittedFile);
//				}
			}
		} catch (IOException e) {
			e.printStackTrace();
			throw e;
		} finally {
			try {
				fout.close();
				in.close();
				bis.close();
				for (String fileName : filenames) {
					File splittedFile = new File(fileName);
					if(removeSplittedFiles && splittedFile.exists()) {
						removeFile(splittedFile);
					}
				}
			} catch (IOException e1) {
				e1.printStackTrace();
			}
		}
	}

	/**
	* Merge Files
	* @param newFileName
	* @param filenames
	* @param removeSplittedFiles
	* @throws Exception
	*/
	public static void merge(Box box, String newFileName, List<String> filenameList, boolean removeSplittedFiles) throws Exception {
		FileOutputStream fout = null;
		FileInputStream in = null;
		BufferedInputStream bis = null;
		try {
			File newFile = new File(newFileName);
			fout = new FileOutputStream(newFile);

			for (String fileName : filenameList) {
				File splittedFile = new File(fileName);
				in = new FileInputStream(splittedFile);
				bis = new BufferedInputStream(in);
				int len = 0;
				byte[] buf = new byte[1024];
				while ((len = bis.read(buf, 0, 1024)) != -1) {
					fout.write(buf, 0, len);
				}
				in.close();
				bis.close();
//				if(removeSplittedFiles && splittedFile.exists()) {
//					removeFile(splittedFile);
//				}
			}

			box.put("fileSize", String.valueOf(newFile.length()));
		} catch (IOException e) {
			e.printStackTrace();
			throw e;
		} finally {
			try {
				fout.close();
				in.close();
				bis.close();
				for (String fileName : filenameList) {
					File splittedFile = new File(fileName);
					if(removeSplittedFiles && splittedFile.exists()) {
						removeFile(splittedFile);
					}
				}
				log.debug("파일 합치기 종료:" + newFileName);
			} catch (IOException e1) {
				e1.printStackTrace();
			}
		}
	}

}