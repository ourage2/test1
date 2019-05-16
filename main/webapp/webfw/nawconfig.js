naw.config = {
	/**** site name에 따른 naw widget 특성화 구현 처리 ****/
	//site name define
	siteName : "cvo",

	/**** 웹 어플리케이션 context path ****/
	context		: _contextPath_,

	/**** 운영 환경 URL 및 IP 등록 ****/
	//smit.co.kr
	prodUrl			: ["127.0.0.1", "www.maeil.com"],
	testUrl			: [],
	devUrl			: ["127.0.0.1", "dev.maeil.com"],
	localUrl		: ["127.0.0.1", "local.maeil.com"],

	/**** 시스템 URL 및 IP 등록 ****/
	systemGbUrl : {
		"cvo" 	: ["www.maeil.com", "local.maeil.com", "dev.maeil.com"]
	},

	/**** 한글 자단위 기본 바이트(byte) 길이 설정 ****/
	// 서버 데이터 인코딩이 "euc-kr" 인 경우 2 , "utf-8" 이면 3
	// 반드시 숫자로 지정
	baseHanLen	: 3,

	/**** 응답 데이터셋의 읽기 전용 모드 설정 ****/
	// 기본값은 false
//	datasetReadonlyMode : true,

	/**** 중복바인딩 알림 설정 ****/
	// 요청 필드에 대한 중복 바인딩 알림 여부를 지정. 기본값은 false
	// 요청시 중복 바인딩 알림을 활성화 하려면 true, 알림을 비활성화려면 false를 지정
	//duplicationBinding : true,

	/**** 중복 디비전(division) 로딩 설정 ****/
	// 동일 영역에 동일 디비전(division) 로딩 여부를 지정. 기본값은 true
	duplicationDivisionLoading : true,

	/**** 페이지 보안 설정 ****/
	// 개발자도구 및 소스보기 방지 (ie, chrome, safari)
	// 로컬 접속(localhost, 127.0.0.1)시에는 적용되지 않음
	pageSecurity : false,

	/**** crossDomain 환경(타 시스템 임베디드 환경)에서 domain 일치 처리 ****/
	// crossDomain type 정보를 가지고 domain 일치 처리를 한다.
	crossDomain : {
		apply		: false,
		type		: "sub", // ex)portal.ncrm.co.kr ==> ncrm.co.kr
		blank		: "/index.do"
	},

	/**** 날짜필드 공휴일 색상 표시 설정 ****/
	// 공휴일 색상 표시를 사용하지 않으려면 false를 지정. 기본값은 true
	//useHolidayColor : false,

	/**** 비활성 Element 유효설 체크 설정 ****/
	// readonly or disabled 상태인 element의 타입별 유효성 체크 여부를 지정
	// 비활성 element의 유효성 체크를 하지 않으려면 false 로 설정
	// validationCheck 설정을 생략하거나 true로 지정하면 활성/비활성 여부에 관련없이 유효성 체크를 함
	validationCheck : true,

	/**** 입력필드 포커스시 selection 여부 설정 ****/
	inputSelectionOnFocus : true,

	/**** readonly 입력필드 포커스시 selection 여부 설정 ****/
	readonlyInputSelectionOnFocus : true,

	/**** 유효성 체크 실패시 데이터 삭제 여부 설정 ****/
	// 입력필드에 데이터 입력 후 blur시 타입별 유효성 체크에 실패시 입력필드의 데이터 삭제 여부를 지정
	// 유효성 실패시 데이터를 삭제 하려면 true를 지정
	invalidDataClear : true,

	/**** 슬라이드 메시지 종류 변경 ***/
	// 기본은 상단 슬라이드이며 브라우저 alert 메시지창으로 변경하려면 타입을 "alert" 으로 지정
	//slideMessageType : "alert",

	/**** Number 유틸 toInt(), toFloat() API 리턴값이 NaN인 경우에 대한 예외 처리  ***/
	// 리턴값을 NaN이 아닌 특정 숫자값으로 리턴하려면 지정
	// 반드시 숫자타입으로 지정해야 함
	defaultNumber: 0,

	/**** Encryption Configuration	****/
	// 서드파티 암호화 솔루션 구현 JS 파일명 지정
	/*
	encryptJS:{
		// 서드파티 암호화 솔루션 JS파일 디렉토리
		path		: "/script/demo",
		// 서드파티 암호화 솔루션 JS파일명
		jsName	: "/interface-xecure.js",
		// 서드파티 암호화 솔루션 JS 파일의 로딩 여부
		loadable	: false
	},
	*/

	/**** maxlength 단위 설정 ****/
	// maxlength를 DB의 길이와 동일하게 지정하는 경우 true 또는 아래의 설정을 주석 처리
	// maxlength를 자단위로 지정하려면 false
	// isByteUnitMaxlength: true이고 maxlength가 5인 경우 한글은 1글자 입력, 단, euc-kr 환경인 경우 2글자 입력
	// isByteUnitMaxlength: false이고 maxlength가 5인 경우 한글은 5글자 입력
	isByteUnitMaxlength : true,

	/**** Shortcut icon Configuration ****/
	// 브라우저 Shortcut 아이콘 지정
//	shortcut_icon	: "/webfw/favicon.ico",

	/**** Journal 로깅 설정(Support only IE) ****/
	journal : false,

	/**** 보안 마스킹 자릿수 설정 ****/
	secureMasking: true,

	// 지정 가능한 타입은 email, mobile, tel, ssn, foreign, card, dln, pn, ssnAll, sbnAll
	secureMaskDigit: {
//		an			: {s:7},			// 계좌번호
		card		: {s:4, e:4},			// 신용카드번호
//		cln			: {e:4},			// 차량번호
//		cvt			: "*",			// 신용카드 유효기간
//		dln			: {s:2},			// 운전면허증번호(지역명 제외)
//		dlnA		: {				// 운전면허증번호(지역명 포함)
//			visibleBase: false,
//			s:2,
//			e:8
//		},
//		email		: {s:3},			// 이메일
//		emailid	: {s:3},			// 이메일 ID
//		emailAll	: {s:3},			// 이메일, 이메일ID
//		foreign	: {s:7},			// 외국인등록번호
//		mobile	: {s:3,e:4},		// 휴대폰번호
//		nm			: {s:1,e:1},		// 이름
//		phone		: {				// 전화번호(지역번호 제외)
//			visibleBase: false,
//			e:3
//		},
//		pln			: {s:1},			// 전화번호 마지막 번호 4자리 (개별번호)
//		pn			: "*",			// 여권번호
		sbnAll		: {s:7},			// sbnAll
		ssn		: {s:7},			// 주민등록번호
		ssnAll		: {s:7},			// ssnAll
//		tel			: {				// 일반전화
//			visibleBase: false,
//			e:3
//		},
//		telAll		: {s:3,e:4},		// 모든 전화번호 (mobile, tel, phone, pln)
	},

	/**** 운전면허번호(dln) 타입 지역명 ****/
	// 운전면허 발급 지역명을 정의
	dlnArea: ["서울","부산","경기","강원","충북","충남","전북","전남","경북","경남","제주","대구","인천","광주","대전","울산"],

	/**** 페이지 기본 확장자 ****/
	// 화면 오픈시 확장자를 지정하지 않은 경우 기본 적용할 페이지 확장자를 지정
	// defaultPageExt 값이 "do" 로 지정하면 naw.openWindow("ncr0001m"); ==> ncr0001m.do 페이지를 요청
	// defaultPageExt 값을 지정하지 않으면 기본 확장자로 "html"이 적용
	defaultPageExt : "do",

	/**** Button Auth(버튼 권한) Configuration ****/
	auth : {
		loadable : true,

		// 지정 가능한 값 "hidden" or "disable"
		type : "disable",

		// 체크할 권한값을 가져올 속성(attribute)명 지정. 지정하지 않으면 "id" 속성이 적용
		//attrName: "auth",

		defaultCheck : true,

		// reverse 속성이 false이면 화면 로딩시 모든 권한 체크 대상 버튼을 비활성화 시킨 후 권한이 있는 버튼을 활성화 함.
		// reverse 속성이 true이면 화면 로딩시 모든 버튼은 활성화 상태이며 권한이 없는 버튼을 비활성화 함.
		reverse : true,

		// 버튼 ID 네이밍룰 정규식
		rule : /^btn(\w{1})[0-9]?/,		// btnS1

		// 버튼 selector query
//		sysButtonSelector : ":button"
		sysButtonSelector : "button[id^=btn]"
	},

	/**** Excel import시 허용 가능한 Excel 파일 최대 용량(단위 kb) ****/
	maxExcelSize: 200,

	/**** 파일 업로드시 허용 가능한 최대 파일 용량(단위 kb) ****/
	maxUploadSize: 1024*2,

	/**** fileupload 허용 확장자 설정 ****/
	// 아래의 설정을 주석처리하거나 "*" 로 지정시 확장자와 상관없이 모든 파일 업로드 가능
//	uploadFileExt : ["doc", "docx", "pdf", "xls", "xlsx", "ppt", "pptx", "txt", "wav", "wma", "csv", "png", "jpg", "gif", "jpeg", "tif"],

	/**** 화면에서 contextmenu 사용 여부를 지정 ****/
	// contextmenu를 사용하려면 true, 그렇지 않으면 false
	contextmenu: true,

	/**** Widget or Plugin Dependency Table Configuration ****/
	dependencyTable:{
		treegrid		: ["widget.grid"],
		minicalendar	: ["widget.calendar"],
		scheduler       : ["widget.calendar"],
		sortable		: ["widget.draggable"],
		droppable		: ["widget.draggable"],
		resizable		: ["widget.draggable"],
		dialog			: ["widget.draggable", "widget.resizable"]
	},

	/**** Holiday Configuration ****/
	holiday: {
  		"0101" : "신정",
  		"0301" : "삼일절",
  		"0505" : "어린이날",
  		"0606" : "현충일",
  		"0815" : "광복절",
  		"1003" : "개천절",
  		"1009" : "한글날",
  		"1225" : "성탄절"
	},

	/**** Global key registration Configuration ****/
	//  GlobalKey가 ID의 Prefix로 사용하는 경우 정규식 => /^(custNm|custRrn|contNo|custId|lnNo|fncafPlanId)/
	//  GlobalKey가 ID의 suffix로 사용하는 경우 정규식 => /(custNm|custRrn|contNo|custId|lnNo|fncafPlanId)$/
	//  GlobalKey가 ID의 어느곳이든 존재만 하면 되는 경우에 사용하는 정규식 => /custNm|custRrn|contNo|custId|lnNo|fncafPlanId/
	globalKey: /custNm|custRrn|contNo|custId|lnNo|fncafPlanId/,

	searchRule: {
		base : "cvo",
		file : /(\w{5})/,///(\w{2})(\w{1})/g,
		directory : {
			demo : {
				/* sample */
				nc : "html/sample/nc",	//ncrm sample
				/* test */
				te : "html/sample/te" //ncrm test
			},
			krma : {
				/* 공통 */
				cmcod : "html/cm/cod",	//코드
				cmmat : "html/cm/mat",	//메뉴권한
				cmdev : "html/cm/dev",	//개발원
				cmsta : "html/cm/sta",	//통계
				cmpop : "html/cm/pop",	//팝업
				cmetc : "html/cm/etc",	//기타
				cmvoc : "html/cm/voc",	//민원관리

				/* sample */
				nc : "html/sample/nc",	//ncrm sample
				/* test */
				te : "html/sample/te" //ncrm test
			}
		}
	},

	/**** Theme Configuration ****/
	theme:{
		// 기본 테마명
//		baseName 	: "default",

		// CSS 최상위 경로 패스
		basePath 	: "/css",

		// 기본 테마 적용을 제외할 위젯명 정의(widget 자체 CSS 적용)
		//excludeWidget : ["range"]	,

		// CSS를 사용하지 않는 WIDGET을 지정
		except 		: ["sortable","draggable","resizable","iscroll","marquee","filedownload", "simplefileupload", "gauge", "layout", "menu", "megamenu", "htmleditor"]
	},

	/**** 사이트 전체 공통 JS의 경로 및 파일명을 정의 ****/
	// 주의!! 업무별 파트 JS는 여기에 지정하시면 안됩니다.
	commonJS:{
		// 공통 JS파일 디렉토리
		path		: "/script",
		// 공통 JS파일명
		jsNames	: ["onsite.js"],
		// 공통 JS 파일의 로딩 여부
		loadable	: true
	},

	/**** 사이트 선택적 공통 JS의 경로 및 파일명을 정의 ****/
	// 주의!! 업무별 파트 JS는 여기에 지정하시면 안됩니다.
	thirdpartyJS:{
//		chart : "/chart/FusionCharts.js"
	},

	extendedModules:{
		"ext.extbehavior":function(){ },
		"ext.extinterface":function(){ },
	},

	/**** 업무 파트명 정의 ****/
	// naw.setPartObj()에서 참조
	//partNames: /sf|te|ki/,

	/**** 사이트 servletURI의 경로 정의 ****/
	// context + servletURI 조합으로 사용
	servletURI:{
		upload 			: "/online/upload",
//		imageDecoder 	: "/online/imageDecoder",
		excel 			: "/online/excel",
		profile 		: "/online/profile",
//		nlog	 		: "/online/Nlog"
	},


	/**** 사이트 drm 적용시 사용 하는 옵션 ****/
	drmOptions :{
		upload : false,
		download : false,
		excel : false
	},

	/**** Submit시 기본으로 사용하는 옵션 ****/
	ajaxOptions : {
	  /* 서비스 CONTEXT를 재정의 하는 경우 지정.(필수 아님) */
	  //context		: "/svc",

	  /* CTL(controller)의 키값을 변경하고자 하는 경우 지정. 기본값은 "name" */
	  //controllerKey : "ctl",

	  /* CTL(controller)명을 패키지를 포함하여 지정 */
//	  controller		: "ncrm.sample.JSAdaptor",	//"com.ngs.framework.broker.NCRMAdapter", "ncrm.sample.JSAdaptor", "ncrm.sample.ActionCTL"

	  /* HTTP 요청 Method("GET" or "POST") */
	  type			: "POST",

	  /* 요청 데이터 타입 지정 ("json" or "form"). 기본값은 ncrm */
	  sendType	: "json",

	  /* 응답 데이터 타입 지정 */
	  dataType		: "json",

	  /* 공통헤더 전송 여부 지정. 기본값은 true */
	  sendHeader	: true,

	  url : _contextPath_,
	  /*
	   * 세션(로그인) 헤더 정보 전송 여부 지정. 기본값은 true
	   * sendHeader 옵션이 true인 경우에만 유효함.
	   */
	  sendSessionHeader : true,

	  /*
	   * 업무 거래 송수신시 공통헤더 필드명을 변경하려는 경우에 지정. 기본값은 header
	   */
	  //headerName: "HEADER",

	  /*
	   * 업무 거래 송수신시 사용자 필드명을 변경하려는 경우에 지정. 기본값은 user
	   * 단, 업무화면의 submit 코드의 paramName을 선언한 경우 아래의 속성을 무시됩니다.
	   */
	  paramName: "payload",

	  /* 응답 대기 타임아웃(ms) */
	  timeout		: 1000000
	},

	tooltip:{
		//messageClass: 'tooltip',		// error message element's class name
		offset		: [-12, 0],
		position	: 'top left',
		delay		: 1500,
		speed		: 100				// message's fade-in speed
	},

	/**** 캘린더 아이콘 비활성 설정 ****/
	// date타입의 입력필드를 비활성화시 캘린더 아이콘도 같이 비활성화 하려면 true를 지정한다.
	// calendarDisable 항목을 삭제시 기본값은 false
	calendarDisable : true,

	dialog:{
		information : {
			modal : true,
			icon : "information"
		},
		alert : {
			modal : true,
			icon : "alert"
		},
		titlebarHeight:35
//		bottomHeight:35
	},

	/**** dialogpopup widget Configuration ****/
	dialogpopup : {
		resizeAuto : true,
		//useTitleTranId : true,
		//useTitleMenuId : true,
		returnClose : true,
		titleIconItems : [			//title icon
			{id	: "print",		use : false,		title : ""},
			{id	: "grade",		use : false,	title : ""},
			{id	: "close",		use : true,		title : ""}
		],
		htmlConf		: {
			transform : {
				resource	: "lowsercase",	//screenID uppercase : 대문자 처리, lowercase : 소문자 처리, default : 치환 없음
				title		: "lowsercase"	//screenID uppercase : 대문자 처리, lowercase : 소문자 처리, default : 치환 없음
			}
		},
		draggable : {
			useContainment : false
		},
		useNotErrorPopup : true,			//에러 발생시 자동으로 nawresmessage 오픈처리
		useNotResizable : true,				//팝업 resizable false 처리
		//useIBeforeDeActive : true,				//팝업 resizable false 처리
		//useIBeforeActivate : true,				//팝업 resizable false 처리
		urlErrorPopup : "nawresmessage"		//에러 메세지창 url
	},

	/**** Accordion option Configuration ****/
	accordion : {
		// 접기,펼치기 속도
		duration : 0

	},

	/**** mobile option Configuration ****/
	mobile : {
		// 접기,펼치기 속도
		isSwap : false
	},

	/**** Grid Configuration ****/
	grid:{
		tdStyle : {
			height 			: "25px",
//			padding 		: "0px 3px 1px 1px",
//			"line-height" 	: "1.2em",
//			"border-bottom" : "0px dotted #DDDDDD"
		}
//		,nextButtonInitEnable : true
//		,totalCntStringPosition:"left"
//		,ideColumnRequiredCheck:false
//		,oneClickEditMode:true
//		,dblClickEditMode:true
		,hideColumnResize:false
//		,columnWidthCheck:false
//		,rowDragChangeFlag:true
//		,titleClickSortType:"desc"
//		,titleClickSort:true
//		,emptyDataViewText:"데이터가 없습니다."
//		,pasteBodyChangeFire:true
//
//		// bodyWidth 가 screenWidth 보다 작을 경우 colFix 적용 X (BW -> bodyWidth, SW -> screenWidth)
//		,BWIsLessThanSWApplyColFix:false
//
//		// 모바일에서 default 로 autoFit 버튼을 보여줄 것인가
//		,mobileAutoFitBtnShow:false
//
//		// 방향키로 Cell 이동가능 여부
//		,directionKeyToCellMove:true
//
//		// autoSkip 발생 시 editableCell 대상에만
//		,autoSkipInEditableCell : true
//
//		// 마우스 hover 시 효과
//		,hoverEffect : false
//
//		// row 홀짝 구분 표현
//		,oddEvenRowDisplay : false

		// next button text | image

//		nextButtonType : "text"
//		,nextButtonText : "다 음"
		// 휠 시 몇개의 Row 를 움직일 것인가
		,wheelMoveRowCnt : 1

		// 붙여넣기 시 bodyChange 이벤트 fire 할 지 여부
		//,pasteBodyChangeFire:true

		// exportExcel 시 font 설정
		//,excelFontName : "arial"
	},

	/**** combobox Configuration ****/
	combobox:{
		inputEditable : false,	//combobox input readonly 설정
		mobileInputEditable : false,
		listWidth	: "input"
	},

	/**** Listcombobox Configuration ****/
	listcombobox:{
		inputClickListOpen : true // input 클릭 시 항목 펼치기
		,buttonClickListOpen : false	// button 클릭시 filter 해제기능을 사용하지 않고 List 를 펼친다
	},

	/**** calendar Configuration ****/
	calendar:{
		inputEditable : true,								//calendar input readonly 설정
		iconDisplay : true,									//calendar icon 사용 여부, icon 미사용시 input click 하면 달력이 보여진다.
		yearRange : [-100, 100],							//calendar year 기간 설정
		resetBtnDisplay : false,							//지우기 버튼 설정 여부
		headerTitle : ["일","월","화","수","목","금","토"]	//달력 테이블 TH TEXT 설정
	}
};