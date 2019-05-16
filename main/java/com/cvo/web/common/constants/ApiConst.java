package com.enpem.web.common.constants;

public enum ApiConst {

	ERROR_KEY("error"),						// 오류 Key
	ERROR_CODE_KEY("errorCode"),			// 오류 코드 Key
	ERROR_MESSAGE_KEY("errorMessage"),		// 오류 메시지 Key
	SUCCESS("200"),  						// 성공 - Sucessful !
	ERROR_SYSTEM("500"),  					// 시스템 에러 - System Error !
	ERROR_NOT_ARROW_ACCESS("1000"),			// 허용되지 않는 접근 - Access denied !
	ERROR_REQUEST_COUNT("1001"),  			// 요청 횟수 초과
	ERROR_PARAMETER("1002"),  				// 잘못된 요청변수(필수, 길이, 형식 오류) - Wrong Parameter !
	ERROR_ENCRYPT_KEY("1003"),  			// 암복호화 실패(암복호화 키 오류, 암복호화 값 오류) - Encrypt/Decrypt Error !
	ERROR_NOAUTH_USER("1004"),  			// 권한이 없는 사용자(등록되지 않은 사용자) - You are not authorised to access Rotem PLM System !
	NO_RETURN("1005");  					// 검색된 내용이 없음(리턴된 내용이 없음) - Drawing is not Released !

	private String code;

	private ApiConst(String code) {
		this.code = code;
	}

	public String getCode() {
		return code;
	}

}