package com.enpem.web.common.util.crypto;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.enpem.web.common.exception.BaseException;

public class GnuPgpUtil {

	protected Logger log = LoggerFactory.getLogger(this.getClass());

	private StringBuffer newFile = new StringBuffer();
	private StringBuffer orgFile = new StringBuffer();

	enum GpgCmd{
	   	RUN_CMD     ("gpg", 			"gpg 명령어"),
	   	ARMOR		("--armor", 		"create ascii armored output"),
	   	CMD_R       ("-r",				"encrypt for NAME"),
	   	CMD_U		("-u", 				"use this user-id to sign or decrypt"),
	   	CMD_O       ("-o",				"use as output file"),
	   	CMD_PASSS   ("--passphrase-fd", ""),
	   	CMD_Z		("-z", 				"set compress level N (0 disables)"),
	   	CMD_Z_LEVEL("0", 				"set compress level N (0 disables)"),
	   	CMD_NOTTY   ("--no-tty",		""),
	   	CMD_ENCRTPT ("--encrypt", 		"encrypt data"),
	   	CMD_SIGN    ("--sign",			"make a signature"),
	   	CMD_DECRYPT ("--decrypt",		"decrypt data (default)"),
	   	;

		private final String code;
		private final String msg;

		/**
		 * Instantiates a new gpg cmd.
		 *
		 * @param code the code
		 * @param msg the msg
		 */
		private GpgCmd(String code, String msg) {
			this.code = code;
			this.msg = msg;
		}

		/**
		 * Gets the code.
		 *
		 * @return the code
		 */
		public String getCode() {
		    return code;
		}

		/**
		 * Gets the msg.
		 *
		 * @return the msg
		 */
		public String getMsg(){
			return msg;
		}
    }



	public synchronized boolean encryptFile(String publicCode, String orgFile, String newFile, String runShell) throws IOException {

		boolean success = false;
 		Process proc;

 		try {
 			// UNIX 명령어 저장할 String 배열 선언
 			String[] cmd = new String[5];

 			// Runtime 객체 생성
 		    cmd[0] = "sh";
 			cmd[1] = runShell; 		//"pgpEncryptFile.sh";// Shell 파일명
 			cmd[2] = publicCode;	//  Public Code
 			cmd[3] = orgFile;		//	Org File Path
 			cmd[4] = newFile;		//	New File Path

 			if(isFile(orgFile)) {

 				log.info(String.format("### runGnuPg  run exec shell cmd [%s %s %s %s %s]:",cmd[0], cmd[1], cmd[2], cmd[3], cmd[4]));

 				proc = Runtime.getRuntime().exec(cmd);

 				BufferedInputStream in = new BufferedInputStream(proc.getInputStream());
 				byte[] bytes = new byte[4096];
 				while (in.read(bytes) != -1) {}

 				proc.waitFor();
 				success = true;

 			} else {
 				throw new Exception( String.format("암복화할 파일명 %s 이 없읍니다. %n", orgFile ));
 			}
 		} catch (Exception e) {
 			throw new BaseException(String.format("외부 명령(gnupg) 실행에 IpgException : %s %n", e.getMessage()));
 		}

 		return success;
     }

	/**
	 * File Encrypt.
	 *
	 * @param googleKeyID - google Key에 대한 ID(email)
	 * @param ktKeyID - kt keyID(email)
	 * @param pgpPassphrase - 비밀키에 대한 비밀번호
	 * @param encryFilePath - 암호화 된 파일 저장 경로
	 * @param encryFile - 암호화 파일 명
	 * @param origFilePath - 원본 파일 경로
	 * @param origFileName - 원본 파일 명
	 * @return true, if successful
	 * @throws IOException Signals that an I/O exception has occurred.
	 */
	public boolean encryptFile(String googleKeyID, String ktKeyID, String pgpPassphrase, String encryFilePath, String encryFile, String origFilePath, String origFileName) throws IOException {
		clearStrBuff();

		//암호화 파일
		newFile.append(encryFilePath)
		       .append("/")
		       .append(encryFile);
		//원본 파일
		orgFile.append(origFilePath)
	       	   .append("/")
	       	   .append(origFileName);

		return runGnuPg(pgpPassphrase,
				newFile.toString(),
				encryFilePath,
				orgFile.toString(),
				getPgpCmd(pgpPassphrase, googleKeyID, ktKeyID, newFile.toString(), orgFile.toString(), GpgCmd.CMD_ENCRTPT.getCode()));
	}

	/**
	 * File Encrypt.
	 *
	 * @param googleKeyID - google Key에 대한 ID(email)
	 * @param ktKeyID - kt keyID(email)
	 * @param pgpPassphrase - 비밀키에 대한 비밀번호
	 * @param encryFilePath - 암호화 된 파일 저장 경로
	 * @param encryFile - 암호화 파일 명
	 * @param origFilePath - 원본 파일 경로
	 * @param origFileName - 원본 파일 명
	 * @param runShell the run shell
	 * @return true, if successful
	 * @throws IOException Signals that an I/O exception has occurred.
	 */
	public boolean encryptFile(String googleKeyID, String ktKeyID, String pgpPassphrase, String encryFilePath, String encryFile, String origFilePath, String origFileName, String runShell) throws IOException {
		clearStrBuff();

		//암호화 파일
		newFile.append(encryFilePath)
		       .append("/")
		       .append(encryFile);
		//원본 파일
		orgFile.append(origFilePath)
	       	   .append("/")
	       	   .append(origFileName);

		return runEncryptFile(googleKeyID, ktKeyID, pgpPassphrase, newFile.toString(), orgFile.toString(), runShell);
	}


	/**
	 * File Decrypt.
	 *
	 * @param pgpPassphrase - 비밀키에 대한 비밀번호
	 * @param decyFilePath the decy file path
	 * @param decryFile the decry file
	 * @param origFilePath - 원본 파일 경로
	 * @param origFileName - 원본 파일 명
	 * @return true, if successful
	 * @throws IOException Signals that an I/O exception has occurred.
	 */
	public boolean decryptFile(String pgpPassphrase, String decyFilePath, String decryFile, String origFilePath, String origFileName) throws IOException {
		clearStrBuff();

		//복호화 파일
		newFile.append(decyFilePath)
		       .append("/")
		       .append(decryFile);
		//원본 파일
		orgFile.append(origFilePath)
	       	   .append("/")
	       	   .append(origFileName);

		return runGnuPg(pgpPassphrase,
				newFile.toString(),
				decyFilePath,
				orgFile.toString(),
				getPgpCmd(pgpPassphrase, null, null, newFile.toString(), orgFile.toString(), GpgCmd.CMD_DECRYPT.getCode()));



	}

	/**
	 * File Decrypt.
	 *
	 * @param pgpPassphrase - 비밀키에 대한 비밀번호
	 * @param decyFilePath the decy file path
	 * @param decryFile the decry file
	 * @param origFilePath - 원본 파일 경로
	 * @param origFileName - 원본 파일 명
	 * @param runShell the run shell
	 * @return true, if successful
	 * @throws IOException Signals that an I/O exception has occurred.
	 */
	public boolean decryptFile(String pgpPassphrase, String decyFilePath, String decryFile, String origFilePath, String origFileName, String runShell) throws IOException {
		clearStrBuff();

		//복호화 파일
		newFile.append(decyFilePath)
		       .append("/")
		       .append(decryFile);
		//원본 파일
		orgFile.append(origFilePath)
	       	   .append("/")
	       	   .append(origFileName);

		return runDecryptFile(pgpPassphrase, newFile.toString(), orgFile.toString(), runShell);
	}


	/**
	 * Clear str buff.
	 */
	public void clearStrBuff(){
		newFile.setLength(0);
		orgFile.setLength(0);
	}


	/**
	 * pgp run command.
	 *
	 * @param pgpPassphrase the pgp passphrase
	 * @param googleKeyID the google key id
	 * @param ktKeyID the kt key id
	 * @param newFile - 암호화 파일 명
	 * @param orgFile - 원본 파일 명
	 * @param cmd_type the cmd_type
	 * @return the pgp cmd
	 */
	private String[] getPgpCmd(String pgpPassphrase, String googleKeyID, String ktKeyID, String newFile, String orgFile, String cmd_type) {
		String[] pgpCmd = null;

		if(cmd_type.equals(GpgCmd.CMD_ENCRTPT.getCode()) ){
			//encrytion file command
			pgpCmd = new String[]{
									GpgCmd.RUN_CMD.getCode(),
									GpgCmd.ARMOR.getCode(),
									GpgCmd.CMD_O.getCode(),
									newFile.toString(),
									GpgCmd.CMD_R.getCode(),
									googleKeyID,
									GpgCmd.CMD_U.getCode(),
									ktKeyID,
									GpgCmd.CMD_PASSS.getCode(),
									GpgCmd.CMD_NOTTY.getCode(),
									GpgCmd.CMD_SIGN.getCode(),
									GpgCmd.CMD_ENCRTPT.getCode(),
									GpgCmd.CMD_Z.getCode(),
									GpgCmd.CMD_Z_LEVEL.getCode(),
									orgFile};
		}

		if( cmd_type.equals(GpgCmd.CMD_DECRYPT.getCode()) ){
			//decrytion file command
			pgpCmd = new String[]{
									GpgCmd.RUN_CMD.getCode(),
									GpgCmd.CMD_DECRYPT.getCode(),
									GpgCmd.CMD_O.getCode(), newFile,
									GpgCmd.CMD_PASSS.getCode(),
									GpgCmd.CMD_Z_LEVEL.getCode(),
									GpgCmd.CMD_NOTTY.getCode(),
									orgFile};
		}

		//test
		StringBuffer pgpCmdMsg = new StringBuffer();
		for (int i = 0; i < pgpCmd.length; i++) {
			pgpCmdMsg.append(pgpCmd[i] );
			pgpCmdMsg.append(" ");
		}

		log.debug( "getPgpCmd : {}",  pgpCmdMsg.toString());

		return pgpCmd;

	}


    /**
     * Run decrypt file.
     *
     * @param pgpPassphrase the pgp passphrase
     * @param newFile the new file
     * @param orgFile the org file
     * @param runShell the run shell
     * @return true, if successful
     * @throws IOException Signals that an I/O exception has occurred.
     */
    public synchronized boolean runDecryptFile(String pgpPassphrase, String newFile, String orgFile, String runShell) throws IOException {
		boolean success = false;
		Process proc;

		try {
			// UNIX 명령어 저장할 String 배열 선언
			String[] cmd = new String[5];

			// Runtime 객체 생성
		    cmd[0] = "sh";
			cmd[1] = runShell; 		//"pgpDecryptFile.sh"
			cmd[2] = pgpPassphrase;	//google Key
			cmd[3] = newFile ;		//복호화 파일
			cmd[4] = orgFile;		//암호화 원본 파일

			if( isFile(orgFile)){

				log.info(String.format("### runGnuPg  run exec shell cmd [%s %s %s %s %s]:",cmd[0], cmd[1], cmd[2], cmd[3], cmd[4] ) );

				proc = Runtime.getRuntime().exec(cmd);

				BufferedInputStream in = new BufferedInputStream(proc.getInputStream());
 				byte[] bytes = new byte[4096];
 				while (in.read(bytes) != -1) {}

				proc.waitFor();
				success = true;

			}else{
				throw new Exception( String.format("복호화 파일명 %s 이 없읍니다. %n", orgFile ));
			}
		} catch (Exception e) {
			throw new BaseException(String.format("외부 명령(gnupg) 실행에 IpgException : %s %n", e.getMessage()));
		}

		return success;
    }



    /**
     * Run encrypt file.
     *
     * @param googleKeyID the google key id
     * @param ktKeyID the kt key id
     * @param pgpPassphrase the pgp passphrase
     * @param newFile the new file
     * @param orgFile the org file
     * @param runShell the run shell
     * @return true, if successful
     * @throws IOException Signals that an I/O exception has occurred.
     */
    public synchronized boolean runEncryptFile(String googleKeyID, String ktKeyID, String pgpPassphrase, String newFile, String orgFile, String runShell) throws IOException {
 		boolean success = false;
 		Process proc;

 		try {
 			// UNIX 명령어 저장할 String 배열 선언
 			String[] cmd = new String[7];

 			// Runtime 객체 생성
 		    cmd[0] = "sh";
 			cmd[1] = runShell; 		//"pgpEncryptFile.sh";// Shell 파일명
 			cmd[2] = pgpPassphrase;	//google Key
 			cmd[3] = googleKeyID;	//google Key
 			cmd[4] = ktKeyID;		//kt Key
 			cmd[5] = newFile ;		//암호화 파일
 			cmd[6] = orgFile;		//원본 파일

 			if( isFile(orgFile)){

 				log.info(String.format("### runGnuPg  run exec shell cmd [%s %s %s %s %s]:",cmd[0], cmd[1], cmd[2], cmd[3], cmd[4], cmd[5], cmd[6] ) );

 				proc = Runtime.getRuntime().exec(cmd);

 				BufferedInputStream in = new BufferedInputStream(proc.getInputStream());
 				byte[] bytes = new byte[4096];
 				while (in.read(bytes) != -1) {}

 				proc.waitFor();
 				success = true;
 			}else{
 				throw new Exception( String.format("암복화할 파일명 %s 이 없읍니다. %n", orgFile ));
 			}
 		} catch (Exception e) {
 			throw new BaseException(String.format("외부 명령(gnupg) 실행에 IpgException : %s %n", e.getMessage()));
 		}

 		return success;
     }


	/**
	 * PGP CMD 실행 메소드.
	 *
	 * @param passphrase the passphrase
	 * @param file - 요청 파일명
	 * @param filePath the file path
	 * @param orgFile the org file
	 * @param command the command
	 * @return boolean
	 * @throws IOException Signals that an I/O exception has occurred.
	 */
	private boolean runGnuPg(String passphrase, String file, String filePath, String orgFile, String... command) throws IOException {
		boolean success = false;
		Process process = null;
		BufferedWriter outWriter = null;

		if( command == null || command.length == 0){
			return success;
		}

		try {

			if( isFile(orgFile)){

				log.info( String.format("runGnuPg  run : orgFile=%s,  filePath=%s, file=%s", orgFile, filePath, file) );

				// 새로운  파일 생성 디렉토리
				newFileDirectory(filePath);

				// ProcessBuilder
				process = new ProcessBuilder(command).start();

				outWriter = new BufferedWriter(new OutputStreamWriter(process.getOutputStream()));
				outWriter.write(passphrase);
				outWriter.close();

				//암호화 또는 복호화 파일 생성 존재 여부
				success = isFile(file);

				log.debug("runGnuPg  run status : {}", success);

				chkProcess(process);

			}else{
				throw new Exception( String.format("암복화할 파일명 %s 이 없읍니다. %n", orgFile ));
			}

		} catch (IOException e) {
			throw new IOException(String.format("외부 명령(gnupg) 실행에 IOException  : %s %n", e.getMessage()));
		}catch (Exception e) {
			throw new BaseException(String.format("외부 명령(gnupg) 실행에 Exception  : %s %n", e.getMessage()));
		}finally {
			if(null != process) {
				process.destroy();
			}
		}

		return success;
	}

	/**
	 * 유지보수 때 필요.
	 *
	 * @param process - 실행 프로세스
	 * @throws IOException Signals that an I/O exception has occurred.
	 */
	private void chkProcess(Process process ) throws IOException {
		BufferedReader inReader = null;
		BufferedReader erReader = null;
		String inLine = "";
		String erLine = "";

		try{
			// ProcessBuilder-inputStream
			inReader = new BufferedReader(new InputStreamReader(process.getInputStream()));
			while ((inLine = inReader.readLine()) != null) {
				log.info("chkProcess input : {}", inLine);
			}

			// ProcessBuilder-errorStream
			erReader = new BufferedReader(new InputStreamReader(process.getErrorStream()));
			while ((erLine = erReader.readLine()) != null) {
				log.info("chkProcess error : {}", erLine);
			}

		} catch (IOException e) {
			throw new IOException(String.format("GPG 암호화 chkProcess  : %s%n ", e.getMessage()));
		}finally{
			if( inReader != null ) {
				inReader.close();
			}

			if( erReader != null ) {
				erReader.close();
			}
		}

	}


	/**
	 * 암복화 파일 존재 여부 체크.
	 *
	 * @param fileName - 체크할 파일명
	 * @return boolean - 파일 존배 여부
	 */
	private boolean isFile(String fileName) {
		boolean isFile = true;

		File createdFile = new File(fileName);
		if (!createdFile.isFile()) {
			isFile = false;
		}

		return isFile;
	}


	/**
	 * 디렉토리 존재여부 확인.
	 *
	 * @param filePath the file path
	 */
    public void newFileDirectory(String filePath) {
    	File directory = new File( "/" + filePath);
        if (!directory.exists() ) {
            if (!directory.mkdirs() ) {
                throw new BaseException( String.format("%s 디렉토리 생성 시 오류 발생 %n", filePath)  );
            }
        }
    }


	/**
	 * ********************************
	 *  Test Main.
	 *
	 * @param args the arguments
	 */
    public static void main(String[] args) {

		GnuPgpUtil gnupg = new GnuPgpUtil();

		boolean enSuccess = false;
		//String pgpKeyID = "KT DCB3 Development";    // pgp Key에 대한 ID
		String pgpPassphrase = "ktkr-dcb";  		// 비밀 Key에 대한 Key 비밀번호
		String googleKeyId ="GoogleTest1@google.com";
		String ktKeyId ="kt-dcb3-dev@kt.com";

		String encryFilePath = "/home/gaia01/ipgbatch/gpgTest/src";
		String origFilePath = "/home/gaia01/ipgbatch/gpgTest/src";
//		String encryFile = "gnupg-test-02.csv.pgp";
//		String origFileName = "gnupg-test-02.csv";

		if( args[0].equals("en")){
			try {
				String origFileName = args[1];
				String encryFile = origFileName+".pgp";

//				enSuccess = gnupg.encryptFile(pgpKeyID, pgpPassphrase, encryFilePath, encryFile, origFilePath , origFileName);
				enSuccess = gnupg.encryptFile(googleKeyId, ktKeyId, pgpPassphrase, encryFilePath, encryFile, origFilePath , origFileName);

			} catch (Exception e) {
//				log.error(String.format("error=%s %n", e.getMessage()));
			}

			if (enSuccess) {
//				log.debug(String.format("file en success"));
			} else {
//				log.debug(String.format("file en fail"));
			}

			gnupg.clearStrBuff();

		}else{
			String decyfilePath = "/home/gaia01/ipgbatch/gpgTest/src";
			String encryFile = args[1];
			String[] decryFile = encryFile.split(".pgp");

			boolean deSuccess = false;
			try {
				deSuccess = gnupg.decryptFile(pgpPassphrase, decyfilePath, decryFile[0], encryFilePath, encryFile);
			} catch (Exception e) {
//				log.debug(String.format("error=%s %n", e.getMessage()));
			}

			if (deSuccess) {
//				log.debug("file en/de success");
			} else {
//				log.debug("file en/de success");
			}
		}
	}
}