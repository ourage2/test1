package com.enpem.web.common.constants;


public class CmnConst {

	public static final String DEFAULT_CHARSET = "UTF-8";

	public static final String PARAM_BOX = "paramBox";
	public static final String PARAM_BOX_ORG = "paramBoxOrg";

	public static final String PAGINATE = "PAGINATE";
//	@Value("#{config['paginate.pageUnit']}")
//	private int paginatePageUnit;

	public static final String SES_USER_ID = "SES_USER_ID";
	public static final String SES_USER_DATA = "SES_USER_DATA";
	public static final String REQUEST_DATA = "REQUEST_DATA";
	public static final String REQUEST_DATA_EXCEPTION = "REQUEST_DATA_EXCEPTION";

	/* Encode type */
	public static final String UTF8 = "UTF-8";
	public static final String EUCKR = "EUC-KR";
	public static final String MS949 = "MS949";
	public static final String CHARSET = UTF8;
	public static final String REDIRECT_URL = "/main/index.do";
	public static final String M_REDIRECT_URL = "/mobile/mmain/mindex.m";
	public static final String M_LOGIN_URL = "/mobile/mmain/mlogin.m";


	/* Request box key */
//	public static final String REQUEST_THREAD_NAME = "REQUEST_THREAD_NAME";

	/* Response Key */
	public static final String RES_CODE = "resCd";
	public static final String RES_MSG = "resMsg";

	/* Session Key */
	public static final String SESSION_USER = "SES_USER_DATA";
	public static final String SESSION_USER_ID = "SES_USER_ID";
	public static final String SESSION_HOME_URL = "SES_HOME_URL";
	public static final String SESSION_AUTH_MENU_BOX = "SES_AUTH_MENU_BOX";
	public static final String SESSION_FUNC_MENU_BOX = "SES_FUNC_MENU_BOX";
	public static final String SESSION_TOP_MENU_LIST = "SES_TOP_MENU_LIST";
	public static final String SESSION_SUB_MENU_BOX = "SES_SUB_MENU_BOX";
	public static final String SESSION_TIMER_APPLY = "SES_TIMER_APPLY";
	public static final String SESSION_CUSTOMER_INFO = "SES_CUSTOMER_INFO";

	/* Request Key */
	public static final String REQUEST_MENU = "REQUEST_MENU";
	public static final String REQUEST_MENU_ID = "REQUEST_MENU_ID";
	public static final String REQUEST_TOP_MENU_ID = "REQUEST_TOP_MENU_ID";

	/* paramBox property key */
	public static final String REQUEST_PARAM_BOX = "paramBox";
	public static final String REQUEST_MODEL_BOX = "modelBox";
	public static final String PARAM_PROP_API_LOG_BOX = "PARAM_PROP_API_LOG_BOX";
	public static final String PARAM_PROP_CLIENT_API_LOG_LIST = "PARAM_PROP_CLIENT_API_LOG_LIST";
	public static final String PARAM_PROP_THREAD_BOX = "PARAM_PROP_THREAD_BOX";
	public static final String PARAM_PROP_FILE_BOX = "PARAM_PROP_FILE_BOX";
	public static final String PARAM_HEADER_BOX = "headerBox";
	public static final String PARAM_PROP_MODEL_BOX = "PARAM_PROP_MODEL_BOX";
	public static final String PARAM_PROP_RQT_PARAM_BOX = "PARAM_PROP_RQT_PARAM_BOX";
	public static final String PARAM_PROP_RQT_DATA = "PARAM_PROP_RQT_DATA";  //request body (object)
	public static final String PARAM_PROP_SESSION = "PARAM_PROP_SESSION";
	public static final String PARAM_PROP_URL_BAS_BOX = "PARAM_PROP_URL_BAS_BOX";
	public static final String PARAM_PROP_RES_BOX = "PARAM_PROP_RES_BOX";  // itgResCd, resCd
	public static final String PARAM_PROP_XML_RQT_VO = "PARAM_PROP_XML_RQT_VO";  // xml vo
	public static final String PARAM_PROP_XML_RPY_DATA = "PARAM_PROP_XML_RPY_DATA";  // response data
	public static final String PARAM_PROP_XML_RPY_CLASS = "PARAM_PROP_XML_RPY_CLASS";  // response vo class
	public static final String PARAM_PROP_JSON_FORMAT = "PARAM_PROP_JSON_FORMAT";  // response json format
	public static final String PARAM_PROP_XML_FORMAT = "PARAM_PROP_XML_FORMAT";  // response xml format
	public static final String PARAM_PROP_VIEW = "PARAM_PROP_VIEW";
//	public static final String PARAM_PROP_VIEW_NAME = "PARAM_PROP_VIEW_NAME";
	public static final String PARAM_PROP_CHARSET = "PARAM_PROP_CHARSET";  // charset
	public static final String PARAM_PROP_STATUS_BOX = "PARAM_PROP_STATUS_BOX";  // status
	public static final String PARAM_PROP_SIMPLE_HTML_DATA_KEY = "PARAM_PROP_SIMPLE_HTML_DATA_KEY";

	/* paramBox key */
	public static final String PARAM_PAGINATE = "paginate";
	public static final String PARAM_PAGINATE_PAGE = "pg";
	public static final String PARAM_PAGINATE_SUFFIX = "PARAM_PAGINATE_SUFFIX";
	public static final String PARAM_PAGINATE_RECORD_SIZE = "PARAM_PAGINATE_RECORD_SIZE";
	public static final String PARAM_PAGINATE_PAGE_SIZE = "PARAM_PAGINATE_PAGE_SIZE";
//	public static final String PARAM_PAGINATE = "paginate";
//	public static final String PARAM_PAGINATE_PAGE = "page";
//	public static final String PARAM_PAGINATE_RECORD_SIZE = "records";
//	public static final String PARAM_PAGINATE_TOTAL_RECORDS = "total";
	public static final String PARAM_PAGINATE_TOTAL_PAGE = "totalPage";

	/* ModelBox key */
	public static final String MODEL_DOWNLOAD_FILE_NAME = "MODEL_DOWNLOAD_FILE_NAME";
	public static final String MODEL_DOWNLOAD_FILE = "MODEL_DOWNLOAD_FILE";

	public static final String MODELMAP_XML_RESULT = "MODELMAP_XML_RESULT";

	/* System */
	public static final String SYSTEM_SVC_NAME = "enpem";

	/* Response code */
	public static final String RES_CD_SUCCESS = "S200";  // 성공
	public static final String RES_CD_UNAUTHORIZED = "F401";  // UNAUTHORIZED
	public static final String RES_CD_FORBIDDEN = "F403";  // FORBIDDEN
	public static final String RES_CD_NOT_FOUND = "F404";  // NOT FOUND
	public static final String RES_CD_ERROR = "F500";  // 오류입니다.
	public static final String RES_CD_SERVER_ERROR = "F501";  // 시스템 점검중 입니다.
	public static final String RES_CD_SESSION_OUT = "F502";  // 세션이 만료 되었습니다.
	public static final String RES_CD_DUPLICATE = "F503";  //중복된 데이터가 존재합니다.
	public static final String RES_CD_IF_ERROR = "F600";  //연동 오류입니다.

	public static final String RES_CD_BAD_REQUEST = "E801";  // 클라이언트의 잘못된 요청으로 처리할 수 없음
	public static final String RES_CD_METHOD_NOT_ALLOWED = "E804";  // 리소스를 찾을 수 없음
	public static final String RES_CD_NOT_ACCEPTABLE = "E805";  // 허용할 수 없음
	public static final String RES_CD_BAD_GATEWAY = "E808";  // 서버의 과부하 상태
	public static final String RES_CD_SERVICE_UNAVAILABLE = "E809";  // 외부서비스가 죽었거나 현재 멈춤상태
	public static final String RES_CD_HTTP_VERSION_NOT_SUPPORTED = "E810";  // HTTP 버전이 지원되지 않음
	public static final String RES_CD_UNKNOWN_ERROR = "E815";  // 알수 없는 에러입니다
	public static final String RES_CD_SESSION_FORCE_OUT = "E817";  // 동시로그인으로 인하여 강제 로그아웃합니다
	public static final String RES_CD_USER_DENY = "E818";  // 관리자의 승인이 필요한 ID 입니다.
	public static final String RES_CD_USER_NOT_GROUP = "E819";  // 그룹에 속하지 않은 ID 입니다. 관리자에게 문의하세요.
	public static final String RES_CD_MARKET_ACCESS_DENY = "E820";  // 해당 마켓에 로그인 권한이 없습니다.
	public static final String RES_CD_DB_CONNECTION_ERROR = "E831";  // 데이터베이스 접속 오류
	public static final String RES_CD_DB_QUERY_ERROR = "E832";  // DB 질의문 처리시 오류가 발생하였습니다
	public static final String RES_CD_VALIDATION_ERROR = "E900";  // 유효성 검증 오류가 발생하였습니다

	/* HTTP Header Key */
	public static final String HTTP_HEADER_ACCEPT = "Accept";
	public static final String HTTP_HEADER_ACCEPT_CHARSET = "Accept-Charset";
	public static final String HTTP_HEADER_ACCEPT_ENCODING = "Accept-Encoding";
	public static final String HTTP_HEADER_AUTHORIZATION = "Authorization";
	public static final String HTTP_HEADER_WWW_AUTHENTICATE = "WWW-Authenticate";

	/* Excel */
	public static final String EXCEL_NAME = "EXCEL_NAME";
	public static final String EXCEL_COLUMN = "EXCEL_COLUMN";
	public static final String EXCEL_LIST = "EXCEL_LIST";
	public static final String EXCEL_SEARCH = "EXCEL_SEARCH";
	public static final String EXCEL_ETC = "EXCEL_ETC";
}
