/*
 * @sample
 *
 * [함수 정의]
 *
 * naw.defineTxnFunction("comm", {
 *		login : {
 *			before: function(header, user){
 *				// 로직 구현
 *			},
 *			callback: function(header, user){
 *				// 로직구현
 *			}
 *		},
 *		logout : {
 *			before: function(header, user){
 *				// 로직 구현
 *			},
 *			callback: function(header, user){
 *				// 로직구현
 *			}
 *		}
 * });
 *
 * [화면에서 호출]
 *
 * comm.login({
 *		header:{
 *			RRAPPLID:"MAIN",
 *			RRRECORD:"RDABSG44"
 *		},
 *		user:{
 *			arg1:"abcdef",
 *			arg2:"1234"
 *		}
 *});
 *
 * comm.logout({
 *		header:{
 *			RRAPPLID:"MAIN",
 *			RRRECORD:"RDABSG43"
 *		},
 *		user:{
 *			arg1:"abcdef",
 *			arg2:"1234"
 *		}
 *});
 *
 */

//참조 방식 처리
//1. MAIN, POPUP, Framework, Opener
if(!window["g_windowOpen"]){
	window["g_windowOpen"] = {};
}
if(!window["globalObj"]){
	window["globalObj"] = {};
}

if(!window["gdsMenu"]){
	window["gdsMenu"] = {};
}
if(!window["siteMapMenu"]){
	window["siteMapMenu"] = {};
}

//이전 거래 메시지 유지.
window["beforeMsgShow"] = false;

//getBizOrgan
if(!window["bizOrgan"]){
	window["bizOrgan"] = {};
}

//참조 방식 처리
//1. MAIN, POPUP, Framework, opener
var isMain = false;
var targetWindow = window;
if(naw.isPopup){
	if(parent.naw.isFwkMode){//2.1. MDI 메인내 팝업 화면
		targetWindow = parent.naw.framework;
	}else{//2.2. 단독 오픈 메인화면 내 팝업 화면
		targetWindow = parent;
	}
}else if(naw.isFwkMode){
	targetWindow = naw.framework;
}else{
	isMain = true;
}
if(naw.isNCRMOpener){
	naw.NCRMOpener = opener;
}else{
	naw.NCRMOpener = null;
}
//1.targetWindow.opener.targetWindow == undefined 일때는 기간계 https 에서 콜센터 https를 오픈 했을 때 예 외 처리 추가
if(targetWindow.naw.isNCRMOpener){
	naw.NCRMTopOpener = (targetWindow.opener.targetWindow && targetWindow.opener.targetWindow.naw.isNCRMOpener)? targetWindow.opener.targetWindow.naw.NCRMTopOpener : targetWindow.opener.targetWindow;
}else{
	naw.NCRMTopOpener = null;
}

//cipher load Start //
var target = null;
if(naw.isFwkMode){//1.1. MDI 메인화면
	target = naw.framework;
}else if(naw.isPopup){//2. 팝업 화면
	if(parent.naw.isFwkMode){//2.1. MDI 메인내 팝업 화면
		target = parent.naw.framework;
	}else{//2.2. 단독 오픈 메인화면 내 팝업 화면
		target = parent;
	}
}else{//1.2. 단독 오픈 메인화면
	target = window;
}
//cipher load End //
//2. system 구분 값 전역 변수 처리
var g_systemGb = naw.systemGb;

if(!naw.isNCRMOpener && isMain){
	//로그인 정보 전역 변수 처리
	/*
	var storageObjHeader = naw.storage.get("header");
	if(naw.isNull(storageObjHeader)){
		for(var key in objHeader){
			window[key] = objHeader[key];
		}
		//공통 헤더 정보 셋팅
		//naw.storage.set("header", objHeader);
	}else{
		//공통 헤더 정보 셋팅
		var decryptHeader = naw.decrypt(storageObjHeader);
		var convObjHeader = naw.convertObject(decryptHeader);
		for(var key in convObjHeader){
			window[key] = convObjHeader[key];
		}
	}
	*/

	/* 임시 data 처리 */
	//개발툴에서는 호출 되지 않게 처리
	if(!naw.__designMode__){

		//공통코드 적용.
		var strMenuUrl = "/main/cdList.js";
		naw.loadScriptSync(naw._getFixedUri(strMenuUrl), function(){
			var tmpCdList = [];
			var k = 0;
			for(var i=0; i<cdList.rows.length; i++){
				tmpCdList[i] = {};
				k = 0;
				for(var j=0; j<cdList.columns.length; j++){
					tmpCdList[i][cdList.columns[j].name] = cdList.rows[i][k++];
				}
			}
			cdList = tmpCdList;
		});

		//메시지
		var strMsgCdFileUrl = "/main/msgList.js";
		naw.loadScriptSync(naw._getFixedUri(strMsgCdFileUrl), function(){
			var tmpMsgList = [];
			var k = 0;
			for(var i=0; i<msgList.rows.length; i++){
				tmpMsgList[i] = {};
				k = 0;
				for(var j=0; j<msgList.columns.length; j++){
					tmpMsgList[i][msgList.columns[j].name] = msgList.rows[i][k++];
				}
			}
			msgList = tmpMsgList;
		});

		//기본메뉴
		var strMenuUrl = "/script/"+g_systemGb+"/comMnList.js";
		naw.loadScriptSync(naw._getFixedUri(strMenuUrl), function(){
			var tmpGdsMenu = [];
			var k = 0;
			for(var i=0; i<gdsMenu.rows.length; i++){
				tmpGdsMenu[i] = {};
				k = 0;
				for(var j=0; j<gdsMenu.columns.length; j++){
					tmpGdsMenu[i][gdsMenu.columns[j].name] = gdsMenu.rows[i][k++];
				}
			}
			gdsMenu = tmpGdsMenu;
		});

	}
}else{
	var targetWin = (naw.NCRMTopOpener)? naw.NCRMTopOpener : targetWindow;

	gdsMenu = targetWin.gdsMenu;
	cdList = targetWin.cdList;
	msgList = targetWin.msgList;
	siteMapMenu = targetWin.siteMapMenu;
	bizOrgan = targetWin.bizOrgan;
}

naw.defineTxnFunction("comm", {
	//삭제 대상 : 사용 하지 않음
	login: {
		before: function(header, user){
			// arguments variable check
			if(naw.isNull(user.userId)||naw.isNull(user.userPswd)){
				alert('로그인-매개변수 오류!\n\n사용자 정보 매개변수 오류');
				return false;
			}

			// login data vailidate
			if(naw.isEmpty(user.userId)||naw.isEmpty(user.userPswd)){
				alert('로그인-사용자 입력 오류!\n\n사용자 정보(아이디/패스워드)를 정확히 입력하십시오.');
				return false;
			}

			// login request header set
			header.RRRECORD = 'RLOGIN';

			return true;
		},
		callback: function(header, user){
			// login response header insert to session storage
			var tmpHeader = naw.storage.get("header");
			var objHeader = user;

			//공통 헤더 정보 셋팅
			naw.storage.setHeader(naw.merge( tmpHeader, objHeader ));

			//로그인 날짜 셋팅 - naw.getToday() return 하여 사용 가능
			//var loinDtm = (objHeader.loinDtm)? objHeader.loinDtm : "";
			var loinDtm = (objHeader.respDtm)? objHeader.respDtm : "";
			if(loinDtm != ""){
				naw.storage.set("loginDay",	 loinDtm.substr(0, 6));
			}

			//system 정보 setting
			var tmpSystem = naw.storage.get("system");
			var conctScCd = naw.getHeader("conctScCd");
			var objSystem = {
					"Env" : (conctScCd.substr(0, 1) != "")? conctScCd.substr(0, 1) : "L", // D:개발, S:검증, P:운영, L:로컬
					"Sys" : (conctScCd.substr(1, 1) != "")? conctScCd.substr(1, 1) : "P", // P: policy, S: sfa, H: hospital, B: banca
					"Con" : (conctScCd.substr(2, 1) != "")? conctScCd.substr(2, 1) : "I" // I: internal, E: external
			};

			naw.storage.set("system", naw.merge( tmpSystem, objSystem ));
			return true;
		},
		ajaxOptions: {//xdata 조회 처리
			context : naw.config.context,
			uri : naw.config.ajaxOptions.context
		},
		error: function(header, user) {
			// AP 서비스 오류 발생 시
			if(header){
				var errCode = header.svrTrtRsltList[0].svrTrtRsltCd;
				var errMgs = header.svrTrtRsltList[0].svrTrtRsltCntnt;
				alert("["+errCode+"] "+ errMgs);
			}
			return false;
		}
	},

	getBizAuth : {
		before: function(header, user){
			return true;
		},
		callback: function(header, user){
			/*
			// strAuth : 1. return false 이면 화면 오픈 X, 1. return "" or string 이면 화면 오픈 O
			var strAuth = false;
			strAuth = user.AuthRolCd;
			if(onsite.getSystemObj("Env") == "S" || onsite.getSystemObj("Env") == "P"){
				if(user.pgmAprcAuthYn == "N"){
					onsite.messageBox("해당 페이지에 접근할 수 없습니다. 권한담당자에게 문의하세요.","","ALERT");
					strAuth = false;
				}
			}else if(onsite.getSystemObj("Env") == "D"){
				if(user.pgmAprcAuthYn == "N"){
					onsite.messageBox("해당 페이지에 접근할 수 없습니다. 권한담당자에게 문의하세요.\n(개발계 임시 접근 허용)","","ALERT");
					strAuth = "SIUDPKATXE";
					//strAuth = false;
				}
			}else{
				if(user.pgmAprcAuthYn == "N"){
					onsite.messageBox("해당 페이지에 접근할 수 없습니다. 권한담당자에게 문의하세요.\n(개발계 임시 접근 허용)","","ALERT");
					strAuth = "SIUDPKATXE";
					//strAuth = false;
				}
			}
			return strAuth;
			*/
		},
		ajaxOptions: {//xdata 조회 처리
			context : naw.config.context,
			uri : naw.config.ajaxOptions.context
		},
		error: function(header, user) {
			// AP 서비스 오류 발생 시
			return "SIUDPKATXE";
			//return false;
		}
	},

	getBizMenu : {
		before: function(header, user){
			return true;
		},
		callback: function(header, user){
			return user.list;
		},
		error: function(header, user) {
			return false;
		}
	},

	getBizOrgan : {
		before: function(header, user){
			return true;
		},
		callback: function(header, user){
			return user.list;
		},
		error: function(header, user) {
			return false;
		}
	},

	sessionInfo : {
		before : function(header, user){
			return true
		},
		callback : function(header, user){
//			console.log(user);
			return user;
//			naw.storage.setHeader(user.userInfo);
		}
	}
});

/**
 * onsite Class
 * @name onsite
 * @class
 */
naw.defineBizFunction("onsite", {
	/**
	 * @lends onsite
	 */

	/* ========================================== grid onsite 함수  시작 ========================================== */
	/**
	 * 그리드 마우스 오버시 그리드의 height를 조정할때 사용한다.
	 * @param {Object} objOpt 옵션지정
	 * @example
	 * var objOpt = {
     *     	"grid" : widgetGrid1,
     *     	"maxHeight" : 700,
     *     	"tab" : widgetTab100, // 그리드 탭 안에 있을 경우
     *  };
     *
     * onsite.dynamicHeight(objOpt);
	 */
	dynamicHeight : function(objOpt){
		var gridObj = objOpt.grid;
		var gridID = gridObj.getId();

		if(objOpt.tab){
			var tabObj = objOpt.tab;
			var tabID = tabObj.id;
			var tabHeight = naw.toInt(naw("#"+tabID+" .tab-body").css("height"));
		}

		var $elStr = jQuery("#"+gridID);
		var bodyHeight = naw.toInt(naw("#"+gridID+"-outerbody").css("height"));
		var gridHeight = $elStr.css("height");

		$elStr.wrap('<div id="'+gridID+'_absolutWrap" class="grid-absolute-wrap-pnl"></div>');
		var $orgEleWrap = jQuery("#"+gridID+"_absolutWrap");				//실제 그리드 wapper

		var firstChild = $elStr.parent().parent().children().children().first().hasClass("grid-pnl");

        naw("#"+gridID+"_absolutWrap").mouseenter(function(e){	// grid에 mouseEnter시 grid를 main(height) 만큼 키운다.
        	if(naw("#vir_"+gridID+"_absolutWrap").length == 0){
        		$orgEleWrap.after('<div id="vir_'+gridID+'_absolutWrap" class="grid-pnl"></div>');
        	}

        	naw("#vir_"+gridID+'_absolutWrap').css({// 가상 그리드 wapper
        		"height" : gridHeight,
        	});

        	naw("#"+gridID+'_absolutWrap').css({	// 실제 그리드 wrapper
        		"margin-top" : firstChild ? 0 : "-5px",
        		"position" : "absolute",
				"z-index" : 1
        	});
        	gridObj.setBodyHeight(objOpt.maxHeight);
        	naw("#"+tabID+" .tab-body").css({"height":tabHeight+objOpt.maxHeight,});

        });

        naw("#"+gridID+"_absolutWrap").mouseleave(function(obj, e){// grid에 mouseLeave시 grid를 minHeight 만큼 줄인다.
        	naw("#vir_"+gridID+'_absolutWrap').remove();
        	jQuery("#"+gridID+'_absolutWrap').removeAttr("style");

        	gridObj.setBodyHeight(bodyHeight);
        	naw("#"+tabID+" .tab-body").css({"height":tabHeight,});
        });
        naw.publish("window.resize", null);
    },

	/**
	* 그리드 reDraw시 header영역의 width를 자동으로 지정한다. dynamicGrid가 아니며, width는 %로 지정되어 return 된다.
	* @param {Object} gridHeader 그리드 hedaer의 정보 보낸다(width의 크기에 따라 넓이가 지정된다).
	* @returns {Object} 변경된 그리드 hedaer정보
	* @example
	* &lt;script type="text/javascript">
	* onsite.getGridHeaderWidth(gridHeader)
	* &lt;/script>
	*/
	getGridHeaderWidth : function(gridHeader) {
		var gridHeaderLength  = gridHeader.length;

		var headerRowLen = 1;
		if(gridHeader[gridHeaderLength-1].rowIndex)
			headerRowLen = parseInt(gridHeader[gridHeaderLength-1].rowIndex);

		var oneRowColLen = gridHeaderLength / headerRowLen;

		var colArrSum = 0;

		for(var i = 0; i < oneRowColLen; i++)
		{
			colArrSum += parseFloat(gridHeader[i].width);
		}

		for(var i = 0; i < oneRowColLen; i++)
		{
			gridHeader[i].width = (parseFloat(gridHeader[i].width) / colArrSum) * 100;
			gridHeader[i].width = naw.dismiss(gridHeader[i].width, 3) + "%";
		}

		return gridHeader;
	},


	/**
	* 마스킹 처리된 그리드의 컬럼을 마스킹을 해제합니다. 단, 그리드의 값을 추가하기 전에 함수를 호출하여야만 적용이 됩니다!
	* @param {Object} obj 그리드객체.
	* @param {String} cellName 마스킹을 해제할 cell.
	* @example
	* &lt;script type="text/javascript">
	* onsite.deSecureMaskGrid(widgetGrid1, "cell1")
	* &lt;/script>
	*/

	deSecureMaskGrid : function(obj, colName, bool){
		if(!bool){
			bool = false;
		}
		obj.setTplCellSecureMask(colName,bool);
	},

	/**
	* 그리드의 header, body, bottom의 각 area의 column 정보를 return 받는다.
	* @param {Object} gridObj 정보를 추출할 그리드 객체
	* @param {String} area header, body, bottom영역 지정. 전체를 가져올 경우 all
	* @param {Object} options area가 header일경우 title만 가져올 경우 작성, {title, hide, parent, customHide}.
	* @returns {Object}
	* @example
	* &lt;script type="text/javascript">
	* onsite.getGridColumnInfo(widgetGrid100, "header", {title:true});
	* &lt;/script>
	*/
	getGridColumnInfo : function(gridObj, area, options){
		if(options == undefined){ //아무것도 오지 않았을 경우 기본값으로 세팅
			options = {
				title:false,
				parent:false,
				hide:false,
				customHide:false
			}
		}
		else{
			if(naw.isEmpty(options.title)){
				options.title = false
			}
			if(naw.isEmpty(options.parent)){
				options.parent = false;
			}
			if(naw.isEmpty(options.hide)){
				options.hide = false;
			}
			if(naw.isEmpty(options.customHide)){
				options.customHide = false;
			}
		}

		var tmpArea = (area) ? area : "all";
		var titleBool = options.title;
		var tmpGridTemplate = gridObj.getTemplate();

		var dataReturnFuntion  = function(tmpAreaStr){
			var bodyObj = {};
			var templateObj =  (tmpAreaStr == "header") ? tmpGridTemplate.gridHeader : (tmpAreaStr == "body") ? tmpGridTemplate.gridBody : tmpGridTemplate.gridBottom;
			var mergeTempateObj = [];

			naw.foreach(templateObj, function(idx, obj){
				bodyObj = {};
				if(obj.dataNX){
					for(var key in obj.dataNX){
						bodyObj["dataNX-"+key] = obj.dataNX[key];
					}

					//dataNX 삭제 처리.
					delete obj.dataNX;
				}

				//column hide이며, 엑셀로 뽑을때 width지정.
				if(options.hide){
					if(obj.width == "0.0001%"){
						obj.width = "10%";
					}
				}

				mergeTempateObj[idx] = naw.merge(obj, bodyObj);
			});

			return mergeTempateObj;
		};

		if(tmpArea == "header" && titleBool){
			var titleArr = gridObj.getTitle();

			return titleArr;
		}
		else if(tmpArea == "all"){
			var allData = {};
			var areaArr = [];
			if(tmpGridTemplate.gridHeader){
				areaArr.push("header");
			}
			if(tmpGridTemplate.gridBody){
				areaArr.push("body");
			}
			if(tmpGridTemplate.gridBottom){
				areaArr.push("bottom");
			}

			for(var key in areaArr){
				if(areaArr[key] == "header"){
					allData["gridHeader"] = dataReturnFuntion(areaArr[key]);
				}
				else if(areaArr[key] == "body"){
					allData["gridBody"] = dataReturnFuntion(areaArr[key]);
				}
				else{
					allData["gridBottom"] = dataReturnFuntion(areaArr[key]);
				}
			}

			var parentBool = options.parent;
			var gridObjTemp = jQuery('#'+gridObj.getId());
			if(!parentBool){
				gridObjTemp = naw.parentWindow().jQuery('#'+gridObj.getId());
			}

			var title = gridObjTemp.parent().find('div').eq(0).children().find('.x-label').text();

			if(title) {
				allData["title"] = title;
			}

			var gridColNm;
			if (options.customHide) {
				var titleArry = [];
				for(var key in gridObj.getTemplate().gridBody){
					if(gridObj.getTemplate().gridBody[key].hide != "undefined" && gridObj.getTemplate().gridBody[key].hide != true) {
						titleArry.push(gridObj.getTemplate().gridHeader[key].name)
					}
				}
				gridColNm = titleArry.join(',');
			} else {
				gridColNm = gridObj.getTitle().join(",");
			}
			allData["gridColNm"] = gridColNm;


			//header hideCol width적용;
			if(options.hide){
				onsite.getGridHeaderWidth(allData.gridHeader);
			}

			return allData;
		}
		else {
			return dataReturnFuntion(tmpArea);
		}
	},

	/**
	* 그리드의 combobox인 경우 그리드의 combobox의 value로 text를 가져온다.
	* @param {Object} gridObj 대상이 되는 grid
	* @param {Integer} rowIdx 해당되는 row
	* @param {String} colNm 해당되는 column
	* @param {String} value text를 가져올 value
	* @returns {String}
	* @example
	* &lt;script type="text/javascript">
	* onsite.getSelectOptionGridLabel(widgetGrid100, 1, "column", "01");
	* &lt;/script>
	*/

	getSelectOptionGridLabel : function(gridObj, rowIdx, colNm, value){
		var cnt = gridObj.getSelectOptionCnt(rowIdx, colNm);
		var text = "";

		for(var i=0; i<cnt; i++){
			if(gridObj.getSelectOptionValue(rowIdx, colNm, i) == value){
				text = gridObj.getSelectOptionLabel(rowIdx, colNm, i);
				break;
			}
		}

		return text;
	},

	/**
	* 그리드의 combobox인 경우 그리드의 combobox가 현재 선택된 index를 가져온다.
	* @param {Object} gridObj 대상이 되는 grid
	* @param {Integer} rowIdx 해당되는 row
	* @param {String} colNm 해당되는 column
	* @returns {Integer}
	* @example
	* &lt;script type="text/javascript">
	* onsite.getSelectOptionGridIndex(widgetGrid100, 1, "column");
	* &lt;/script>
	*/
	getSelectOptionGridIndex : function(gridObj, rowIdx, colNm){
		var gridOptions = gridObj.getCellOptions(rowIdx, colNm);
		var rowCnt = gridOptions.length;
		var idx = 0;

		for(var i=0; i<rowCnt; i++){
			if(gridOptions[i].selected){
				idx = i;
				break;
			}
		}

		return idx;

	},
	/* ========================================== grid onsite 함수  끝 ========================================== */

	/* ========================================== combobox onsite 함수  시작 ========================================== */
	/**
	 * 화면의 전체 combobox에 change 이벤트를 발생 시킨다.
	 * @param {function} functionName user.chcombEvt
	 * @param {String} area 특정영역만 한 경우 영역 지정.
	 * @example
	 * onsite.comboboxChange(user.chcombEvt);
	 *
	 *
	 * user영역.
	 * chcombEvt : function(id, obj){
	 * 		console.log(id);
	 * 		console.log(obj);
	 * }
	 */
	comboboxChange : function(functionName, area){
		var thisId;
		var allObj = (area) ? naw("#"+area+" .combobox-pnl", true) : naw(".combobox-pnl", true);

		allObj.foreach(function(){
			naw("#"+this.id).change(function(){
				thisId = this.renderTo;
				nawThis = naw("#"+thisId);

				if(typeof(functionName) == "function"){
					functionName(thisId, this);
				}
				else{
					eval(functionName)(thisId, this);
				}
			});
		});
	},

	/**
	 * combobox의 모든 데이터를 Remove합니다.
	 * @param {String} area combobox를 Remove처리할 영역, 없을경우 화면의 모든 combobox Remove;
	 * @example
	 * onsite.comboboxRemove("dsView1");
	 * onsite.comboboxRemove();
	 */
	comboboxRemove : function(area){
		if(area == undefined){
			naw("#wrap .combobox-pnl", true).foreach(function(){
				if(naw(this).name == "combobox"){
					naw("#"+this.id).removeAll();
				}
			});
		}
		else{
			naw("#"+area+" .combobox-pnl", true).foreach(function(){
				if(naw(this).name == "combobox"){
					naw("#"+this.id).removeAll();
				}
			});
		}
	},

	/**
	 * combobox의 list의 값으로 특정 row를 삭제합니다.
	 * @param {Object} combobox 대상이 되는 combobox
	 * @param {String} value combobox의 값으로 해당 row를 삭제합니다.
	 * @example
	 * onsite.comboboxRemoveIndex(widgetCombobox100,"01");
	 * onsite.comboboxRemoveIndex(widgetCombobox100,["01","02"]);
	 */
	comboboxRemoveIndex : function(combobox,value){
		var valueLen = value.length;
		if(value == undefined){
			return;
		}
		else{
			var count = combobox.count();
			var selectedIdx = 0;
			for(j=0 ; j<valueLen;j++){
				for(var i=0; i<count; i++){
					if(combobox.getItemValue(i) == value[j]){
						selectedIdx = i;
						break;
					}
				}
				combobox.removeIndex(selectedIdx);
			}

		}

	},
	/**
	 * 공통코드가 아닌 combobox에 값을 넣는 함수.
	 * @param {widget} widget 그리드의 combobox또는 일반 combobox
	 * @param {object} comboData combobox에 값을 넣기 위한 object
	 * @param {object} options 옵션 지정, combobox인 경우 {lable:"aa", value:"bb", selectedValue:"02"|selectedIndex:1}, grid인 경우 {lable:"aa", value:"bb", colNum:0, rowNum:"2"|["0", "1"], selectedValue:"02", editable:true}
	 * @example
	 * onsite.setComboData(combobox, comboData, {lable:"aa", value:"bb", selectedValue:"02"|selectedIndex:1})
	 * onsite.setComboData(grid, comboData, {lable:"aa", value:"bb", colNum:0, rowNum:"2"|["0", "1"], selectedValue:"02", editable:true})
	 */
	setComboData : function(widget, comboData, options){
		if(widget.name == "combobox"){
			var arrComboData = [];
			for(var key in comboData){
				arrComboData[key] = [comboData[key][options.value], comboData[key][options.label]]
			}

			if(options.textCol){
				if(!options.valueCol || options.valueCol == ""){
					options.valueCol = "";
				}
				if(widget.count() == 0){
					widget.addItem(options.valueCol, options.textCol);
				}
				else{
					widget.insertItem(0, options.valueCol, options.textCol);
				}
			}
			if(arrComboData.length!= 0)
				widget.addItem(arrComboData);

			if(options.selectedValue){
				widget.val(options.selectedValue);
			}
			else if(options.selectedIndex){
				widget.selectedIndex(options.selectedIndex);
			}
			else{
				widget.selectedIndex(0);
			}
		}
		else if(widget.name == "grid"){
			var arrComboData = onsite.___getGridComboData(comboData, options);//combodata return;
			onsite.___setGridComboData(widget, arrComboData, options);
		}
		else{
			return onsite.messageBox("객체를 잘못 지정하였습니다.");
		}
	},

	/* ========================================== combobox onsite 함수  끝 ========================================== */

	/* ========================================== 기타 onsite 함수  시작 ========================================== */
	getSystem : function() {
		/* 접속된 System 정보 : policy/channel */
		return naw.getSystemGb();
	},
	getSystemObj : function(a_type) {
		/* 접속된 System 정보
		a_type : {
			Env : "L",	// D:개발, S:검증, P:운영, L:로컬
			Sys : "P",	// P: policy, S: sfa, H: hospital, B: banca
			Con : "I"	// I: internal, E: external
		}
		*/
		var tmpSystemObj = naw.storage.get("system");
		if(a_type){
			return (tmpSystemObj[a_type])? tmpSystemObj[a_type] : "";
		}else{
			return tmpSystemObj;
		}
	},

	/**
	* 화면의 alert나 confirm창을 호출할때 사용한다.
	* @param {String} a_sMsg 표현할 메시지
	* @param {String} a_sMsgCd 메시지코드(사용하지 않음);
	* @param {String} a_sMsgType ALERT또는 CONFIRM, default는 ALERT;
	* @example
	* &lt;script type="text/javascript">
	* onsite.messageBox("alert창입니다", "", "ALERT");
	* &lt;/script>
	*/
	messageBox : function(a_sMsg, a_sMsgCd, a_sMsgType) {

		//우측화면에서 alert나 confirm인 경우 return(tskim);
		if(onsite.eastPnlShowMode("mode")){
			if(!onsite.eastPnlShowMode("show")) return;
		}

		//=====================================================================
		// Default Message Type ==> "ALERT"
		//=====================================================================
		a_sMsgType = (!a_sMsgType)? "ALERT" : a_sMsgType;

		switch(a_sMsgType) {
		case "ALERT":
			if(a_sMsgCd=="GIRD_ERROR_SELECTEDINDEX") {
				alert("항목이 선택되지 않았습니다.\n\n하나 이상의 항목을 선택하십시오.");
			}
			else
				alert(a_sMsg);
			break;

		case "CONFIRM":
			var sMatch = "IUSPDR";
			var sConfirmMsg = "";

			if(sMatch.indexOf(a_sMsgCd.substr(0,1))>-1 && a_sMsgCd !="") {
				var sAlias = a_sMsgCd.substr(0,1).toUpperCase();
				sConfirmMsg = "을(를) 하시겠습니까?";
				switch(sAlias) {
				case "I": sConfirmMsg="등록"+sConfirmMsg;break;
				case "U": sConfirmMsg="수정"+sConfirmMsg;break;
				case "S": sConfirmMsg="조회"+sConfirmMsg;break;
				case "P": sConfirmMsg="저장"+sConfirmMsg;break;
				case "D": sConfirmMsg="삭제"+sConfirmMsg;break;
				case "R": sConfirmMsg="초기화"+sConfirmMsg;break;
				}
			}
			else {
				sConfirmMsg = a_sMsg;
			}
			return confirm(sConfirmMsg);

		case "STATUSBAR":
			if(a_sMsgCd)
				naw.setMsg(a_sMsg, a_sMsgCd);
			else
				naw.setMsg(a_sMsg);
		}
	},

	isCollapse : function (a_strId, a_idxAcdn) {
		if(typeof(a_strId) == "undefined" || a_strId == "") return false;

		var captionEle = naw("#"+a_strId);

		if(captionEle.length == 0 || captionEle.tagName() != "DIV" || !captionEle.hasClass("caption-pnl")) return false;
		var captionEleH2 = naw("#"+a_strId +" h2");

		if(captionEleH2.hasClass("state-collapse")) return true;
		else return false;

		/* container / accordion-pnl 접힌 상태 여부
		 [argument]
		 a_strId : container or accordion ID
		 a_idxAcdn : accordion index
		 [return]
		 - true : 접힌 상태
		 - false : 펼쳐진 상태
		 */
//		var isColl = false;
//		if(naw("#"+a_strId).hasClass("container")) {
//			return naw("#"+a_strId).find("h2").hasClass("state-collapse");
//		}
//		else if(naw("#"+a_strId).hasClass("accordion-pnl")) {
//			if(a_idxAcdn)
//				return naw("#"+a_strId).find("h3").nth(a_idxAcdn).hasClass("x-corner-all");
//		}
//		return isColl;
	},

	delServerFile : function(a_node, oDeleteFileArray){
		var uploadURI = naw._getFixedUri(naw.config.servletURI.upload);
		naw.post({
			type : "post",
			url : uploadURI+"?upload_id="+a_node,
			data : {"funCd":"delete","delFList":oDeleteFileArray.join("")},
			async : false,
			cache : false,
			success : function(result){
				if(result!="FAIL")
				{
					try
					{
						var oArrReponseMsg = result.split("|");
						var sReturnCd = oArrReponseMsg[0];		// "0000":Success, 그 외:Failed
						var sReturnMsg = oArrReponseMsg[1];		// 정상/에러 메시지
						//var oDeleteFailInfo = (sReturnCd!="0000")? eval(oArrReponseMsg[2].substr(0,oArrReponseMsg[2].length-1)) : null;

						if(sReturnMsg == "DELETE OK!!!") sReturnMsg = "정상적으로 삭제처리 되었습니다."; //메세지 변경요청 2010.1.12 jsh
						//onsite.messageBox(sReturnMsg,"","ALERT");				// 메시지출력
						//return(oDeleteFailInfo);			// 삭제완료된 파일정보를 리턴한다
					}
					catch(e){alert(e.description);return(null)}
				}
				else
				{
					alert("파일 삭제 시 오류가 발생하였습니다. 확인 후 재전송 하십시오.");
				}
			},
			error : function(){}
		});
	},

	getServerImgUrl : function(sFile, sOfile, sPath, sGubun)
	{
		//사용하지 않음.
		return false;
		var uploadURI = (sGubun && sGubun == "rd")? naw.config.servletURI.upload : naw._getFixedUri(naw.config.servletURI.upload);
		var sImgUrl = uploadURI + "?upload_id=fileattach&funCd=down";
		sImgUrl += "&subFPath=" + ((typeof(sPath)=="undefined")? "" : sPath);
		sImgUrl += "&saveFName=" + ((typeof(sFile)=="undefined")? "" : sFile);
		sImgUrl += "&orgFName=" + ((typeof(sOfile)=="undefined")? "" : sOfile);
		//attachment 파라미터 값을 false 로 지정하면 Content-Type 이 파일 확장자에 맞는 MINE 타입으로 다운로드
		sImgUrl += "&attachment=false";

		return(sImgUrl);
	},

	/*	로컬PC의 파일을 실행한다.(Only IE)
	 *	1. 신뢰할 수 있는 사이트 등록
	 *	2. 도구->인터넷 옵션->보안탭->신뢰할 수 있는 사이트 선택->사용자 지정 수준버튼 클릭->스크립팅하기 안전하지 않는 것으로 표시된 ActiveX 컨트롤 초기화 및 스크립팅 : 사용
	 a_strOperation	: (String) file Operation("open")
	 a_strFileName : (String) 경로와 확장자를 포함한 파일명
	 a_strParameters : (String) 실행될 파일에 전달할 argument
	 */
	shellExecute :	function(a_strOperation, a_strFileName, a_strParameters) {
		try{
			var objShell = new ActiveXObject("shell.application");
			objShell.ShellExecute(a_strFileName, a_strParameters, "", a_strOperation, 1);
		}catch(e){
			if(naw.agent.browser == "msie"){
				onsite.messageBox(e.description +"\n1.shellExecute 기능은 신뢰할 수 있는 사이트에 등록되있어야 합니다.\n2.인터넷옵션->보안탭->신뢰할수있는 사이트 선택->\n사용자지정수준 버튼클릭->스크립팅하기 안전하지 않은것으로 표시된 ActiveX 컨트롤 초기화및 스크립팅을 사용으로 바꿔주세요.","","ALERT");
			}
			else{
				onsite.messageBox("shellExecute 기능은 IE Browser에서만 사용가능 합니다.","","ALERT");
			}
		}
	},
	/*	부서 관련 header 정보 변경 함수 - 일반 화면 사용 금지
	 a_objHeader	: (object) 부서 관련 header
	*/
	setHeader : function(a_objHeader){
		//ncrmheader 화면 이외에는 사용 하지 못하도록 설정
		if(naw.screenID != "ncrmheader")
			return;

		var tmpHeader = naw.merge( naw.storage.getHeader(), a_objHeader );
		if(!confirm("모든 화면을 종료 합니다.\r\n적용 하시겠습니까?"))	return false;

		//공통 헤더 정보 셋팅
		naw.storage.setHeader(tmpHeader);
//		naw.framework.closeAllWindowOther(document.id);

		top.location.reload(true);
	},
	/*	업무화면 캡쳐 수행 후 출력 함수 -
	제약사항 : 화면 내 외부솔루션이 연동된 영역은 정상적으로 보이지 않을 가능성이 높아 일반업무 화면에서만 사용을 권장
	*/
	/*
	 * 업무화면 프린터 출력 함수.
	 *
	 * @example ex)
	 * // 화면출력
	 * naw("#logPrint").click(function(e){
	 *	onsite.viewPrint();
	 * });
	 * @requires <br>
	 * - 업무화면 내 외부 솔루션이 연동된 영역은 정상적으로 보이지 않을 가능성이 높아 일반 업무 화면에서만 사용을 권장합니다. <br>
	 * - 프린트 출력 설정 화면은 브라우저 마다 다를 수 있으니 유의하시기 바랍니다.
	 * - ie브라우저인 경우는 메뉴 - 파일 - 페이지설정 - 배경색 및 이미지 인쇄 체크 설정을 해야 ie에서 정상적인 화면이 인쇄됩니다.
	 * - chrome인 경우 설정보더기 - 배경그래픽 체크 설정.
	 */
	viewPrint : function(){
		if(naw.agent.browser == "msie"){//ie경우 미리보기 인쇄 변경.
			try {
				var printPreview = '<OBJECT ID="iePrintPreview" WIDTH="0" HEIGHT="0" CLASSID="CLSID:8856F961-340A-11D0-A96B-00C04FD705A2"></OBJECT>';
				document.body.insertAdjacentHTML("beforeEnd", printPreview);
				iePrintPreview.ExecWB(7, 1);
			} catch (e) {
				return onsite.messageBox("신뢰할 수 있는 사이트를 등록해주시기 바랍니다.\n등록하지 않으실 경우 print 기능을 사용하실 수 없습니다.");
			}
		}
		else{
			window.print();
		}
	},

	//사용자 정보 수정.
	/**
	* 최상위 전역변수 set
	* @param {String} flag set할 전역변수 flag
	* @param {object} objData 세팅할 오브젝트.
	* @example
	* &lt;script type="text/javascript">
	* onsite.setGlobalObj("cust",{name:"아무개", age:"50"});
	* &lt;/script>
	*/
	setGlobalObj : function(flag, objData){
		var targetWin = (naw.NCRMTopOpener)? naw.NCRMTopOpener : targetWindow;
		var globalFlagObj = targetWin.globalObj[flag];
		if(globalFlagObj){
			var mergeObjKey = targetWin.naw.merge(globalFlagObj, objData);
		}else{
			var mergeObjKey = targetWin.naw.merge({}, objData);
		}
		targetWin.globalObj[flag] = mergeObjKey;
	},

	/**
	* 최상위 전역변수 get.
	* @param {String} flag get할 전역변수 flag
	* @param {String} objKey get하는 오브젝트의 key값.
	* @example
	* &lt;script type="text/javascript">
	* onsite.getGlobalObj("cust","name");
	* onsite.getGlobalObj("cust");
	* &lt;/script>
	*/
	getGlobalObj : function(flag, objKey){
		var returnVal = "";
		var targetWin = (naw.NCRMTopOpener)? naw.NCRMTopOpener : targetWindow;
		if(!targetWin.globalObj){
			targetWin.globalObj = {};
		}

		var globalFlagObj = targetWin.globalObj[flag];
		if(globalFlagObj){
			if(!objKey){
				returnVal = globalFlagObj;
			}else{
				returnVal = globalFlagObj[objKey];
			}
		}
		return returnVal;
	},

	/**
	* 최상위 전역변수를 Clear, 아무것도 보내지 않으면 모든 전역변수 클리어.
	* @param {String} flag get할 전역변수 flag
	* @param {String} objKey get하는 오브젝트의 key값(선택적).
	* @example
	* &lt;script type="text/javascript">
	* onsite.clearGlobalObj("cust","name");
	* onsite.clearGlobalObj("cust");
	* &lt;/script>
	*/
	clearGlobalObj : function(flag, objKey){
		var targetWin = (naw.NCRMTopOpener)? naw.NCRMTopOpener : targetWindow;

		if(flag == undefined && objKey == undefined){
			if(targetWin.globalObj){
				targetWin.globalObj = targetWin.naw.merge({},{});
			}
		}
		else if(flag != undefined && objKey == undefined){
			if(targetWin.globalObj && targetWin.globalObj[flag]){
				targetWin.globalObj[flag] = targetWin.naw.merge({},{});
			}
		}
		else{
			if(targetWin.globalObj && targetWin.globalObj[flag]){
				var globalFlagObj = targetWin.globalObj[flag];
				globalFlagObj[objKey] = targetWin.naw.merge({},{});
			}
		}
	},

	/**
	* 새로운 화면을 오픈하는데 사용 합니다.
	* @param {String}	url 	오픈할 화면의 절대 또는 상대 주소. 단, 업무 검색 규칙이 적용된 경우에는 화면명만 지정 가능.
	* @param {Object} obj 추후 확장성을 고려 선택적 옵션
	* @param {Object} [options]
	* @param {Any} [options.data] 새로운 화면을 오픈하면서 전달할 데이터. 데이터 타입에 제한은 없음.
	* @param {Boolean} [options.popup] 팝업으로 화면을 오픈하는 경우에는 true, 동일창에 오픈하는 경우에는 false. 기본값은 false
	* @param {String} [options.modalinfo] 모달리스 팝업으로 오픈하는 경우에는 "modaless", 기본값은 "modal". 단, popup : true 일 때만 적용
	* @param {Boolean} [options.external] 새창으로 오픈 할 때 true, MDI에 오픈하는 경우에는 false. 기본값은 false
	* @example
	* onsite.openWindow("LTRA010");
	* onsite.openWindow("LTRA010", {tran : "TCAT001", data: {sabun:"10020"});
	* onsite.openWindow("LTRA010", {tran : "TCAT001", data: {sabun:"10020"}, popup : true});
	*/
	openWindow : function(url, options){
		if(naw.isEmpty(url)){	//url이 없을 경우 return 처리.
			return url;
		}

		/*
		var ssoData = naw.storage.get("ssoData");

		if(ssoData.isMobile == "true"){
			var m_message = {};

			if(options && options.data){
				m_message.data = options.data;
				m_messageName = "message-" + url;

				m_message = JSON.parse(JSON.stringify(m_message));
				naw.storage.set(m_messageName, m_message);
			}

			var m_fileUrl = naw.behavior.IGetRulePath("get", url);

			if(options){
				if(options.popup){
					naw.openWindow(url, options);
				}
				else{
					top.user.openScreen("../../"+m_fileUrl+"/"+url+".html");
				}
			}
			else{
				top.user.openScreen("../../"+m_fileUrl+"/"+url+".html");
			}
		}
		else{//일반 브라우저. */
			//브라우저 X버튼 클릭 후 계속 있기 선택시 다시 화면 open하는 경 예외 처리 20161116kts
			if(!targetWindow.g_windowOpen){
				targetWindow.g_windowOpen = {};
			}

			var accessDeny = jQuery(".openWindow-access-deny");

			if(accessDeny.length == 0){
				accessDeny = jQuery("<div/>").addClass("openWindow-access-deny").appendTo(document.body);
			}

			setTimeout(function(){
				accessDeny.remove();
			},500);
			//1. opener 조건
			//1.1. MDI Framework 오픈
			// - [opener] nawmain
			// - [제약조건] 새창에서 MDI Framework 오픈 제공 하지 않음 -> 새창 열기로 대체
			//1.2. 업무화면 새창 열기
			// - [opener] 메뉴 클릭시 : nawmain, 화면 이동 버튼 클릭시 : 업무화면
			// - [제약조건] 새창에서 MDI Framework 오픈 제공 하지 않음 -> 새창 열기로 대체

			var objFeatures = {
//				top:0,
//				left:0,
					//height:300,
					//width:500,
					menubar:"no",
//				toolbar:"no",
//				directories:"no",
//				location:"no",
//				titlebar:"yes",
//				status:"yes",
//				scrollbars:"yes",
//				fullscreen:"yes",
					resizable:"yes"
			};

			if(options && options.features){
				objFeatures = naw.merge(objFeatures, options.features);
			}
			var features = "";
			for(var key in objFeatures){
				if(features != ""){
					features += ",";
				}
				features +=	key +"=" + objFeatures[key];
			}

			//url = url.toLowerCase();

			var fileName = url,
			message = null,
			messageName = "message-" + fileName;
			if(naw.isNull(message)){
				message = {};
			}
			message.source = naw.getFileName(window.location.pathname);

			var isExternal = false;
			var openType = "";
			var useDuplication = false;
			if(naw.isNull(options)){

			}else if(options && options.openflag){
				/* openflag
				'sf'  : Sub Framework -> MDI 기능만 제공, 중복화면 오픈 허용 X
	            'sfd' : Sub Framework Duplication -> MDI 기능만 제공, 중복화면 오픈 허용 O

	            //화면 단독 오픈은 nawsdi 연동 필요 - 로그인, rulePath
	            's'   : Single -> 새창 열기, 동일한 화면 중복 오픈 허용 X(새로고침)
	            'sd'  : Single Duplication -> 새창 열기, 동일한 화면 중복 오픈 허용 O
				 */
				if(options.openflag.indexOf("s") != -1){
					isExternal = true;

					if(options.openflag.indexOf("f") != -1){
						openType = "MDI";
					}
					if(options.openflag.indexOf("d") != -1){
						useDuplication = true;
					}
				}

				//데이터를 전달하지 않아도 opener에 데이터 전달.
				var urlOpenerObj =  {};
				urlOpenerObj[url+"-openerID"] = naw.screenID;
				onsite.setGlobalObj("ncrmSystem", urlOpenerObj);
			}

			if(isExternal){
				if(openType == "MDI"){
					//1. sf에서 sf 실행시 같은 창에 뜨도록.
					if(targetWindow.naw.isMDIMode){
						if(options && options.data){
							message.data = options.data;
							messageName = "message-" + fileName;
						}
						targetWindow.onsite.__activateMessage(messageName, (options && options.data)? message : null, url);
						return;
					}
					//2. s or sd 에서 sf 실행시 sf 창에서 뜨도록.
					else{
						if(targetWindow.isMain && ! targetWindow.isFwkMode){
							if(naw.NCRMTopOpener){
								naw.NCRMTopOpener.onsite.openWindow(url, options);
							}
							return;
						}
					}
					//1. MDI Framework 오픈 opener는 nawmain이 된다.
					/*
				var targetWindow = window;
				var isMain = false;
				if(naw.isPopup){
					targetWindow = parent;
				}else if(naw.isFwkMode){
					targetWindow = naw.framework;
				}else{
					isMain = true;
				}
					 */

					var targetMDIWindowUrl = targetWindow.document.location.href;
					var targetMDIWindowName = targetMDIWindowUrl.substr(targetMDIWindowUrl.lastIndexOf("/")+1, targetMDIWindowUrl.length);
					targetMDIWindowName += (useDuplication)? "_dup" : "_sing";
					var isOpen = (targetWindow.g_windowOpen[targetMDIWindowName])? true : false;
					var targetMDIWindow = (isOpen)? targetWindow.g_windowOpen[targetMDIWindowName] : targetWindow;
					try{
						isOpen = isOpen && targetMDIWindow.naw && targetMDIWindow.window;
						if(isOpen && naw.agent.browser == "chrome"){
							isOpen = (targetMDIWindow.sessionStorage)? true : false;
						}
					}catch(e){
						isOpen = false;
						targetWindow.g_windowOpen[targetMDIWindowName] = null;
					}
					message.source = targetWindow.naw.getFileName(targetWindow.window.location.pathname);
					messageName = "message-" + message.source;
					if(isOpen){
						//기간계 브라우져 활성화 처리
						targetMDIWindow.focus();

						if(options && options.data){
							message.data = options.data;
							messageName = "message-" + fileName;
						}

						targetMDIWindow.onsite.__activateMessage(messageName, (options && options.data)? message : null, url);
					}else{
						message.data = {
								url : url,
								useMdiDuplication : (useDuplication)? true : false,
										sysGb : naw.getSystemGb()
						};
						if(options && options.data){
							message.data.data = options.data;
						}
						targetWindow.naw.storage.set(messageName, message);

						//open후 url변경 2017.04.24 kts.
						targetWindow.g_windowOpen[targetMDIWindowName] = targetWindow.open("", "", features);
						targetWindow.g_windowOpen[targetMDIWindowName].document.location.href  = targetWindow.document.location.href;
					}
				}else{
					if(url.indexOf("/") != -1){
						url = url.substring(url.lastIndexOf("/")+1, url.lastIndexOf("."));
					}
					var fullUrl = url;
					var _rulePath = naw.behavior.IGetRulePath("get", fullUrl);

					if(naw.config.auth.loadable){
						var strAuth = naw.behavior.IServiceApplyAuth(fullUrl);
						//권한 조회 서비스 호출
						if(strAuth || strAuth == ""){
							naw.behavior.ISetAuth(strAuth, fullUrl);
						}
						else{
							onsite.messageBox("요청하신 화면에 대해 열기(Open) 권한이 없거나,\r\n권한 정보가 등록되지 않은 화면입니다.","","ALERT");
							return false;
						}
					}

					fullUrl = (_rulePath? _rulePath : "") + "/" + fullUrl;
					if(fullUrl.indexOf(".") == -1){
						fullUrl += ".html";
					}
					fullUrl = naw._getFixedUri(fullUrl);
					if(options && options.data){
						message.data = options.data;
					}
					if(useDuplication){
						if(options && options.data){
							naw.storage.set(messageName, message);
						}

						//open후 url변경 2017.04.24 kts.
						var targetTitle = Math.random();
						g_windowOpen[url+"_"+targetTitle] = window.open("", "", features);
						g_windowOpen[url+"_"+targetTitle].document.location.href = fullUrl;

					}else{
						//open url 이 나 자신 일때 reload 처리
						if(naw.screenID == url && isMain){
							if(options && options.data){
								naw.storage.set(messageName, message);
							}
							document.location.reload(true);
						}else{
							var isOpen = false;
							try{
								isOpen = g_windowOpen[url] && g_windowOpen[url].naw && g_windowOpen[url].window;

								if(isOpen && naw.agent.browser == "chrome"){
									isOpen = (g_windowOpen[url].sessionStorage)? true : false;
								}
							}catch(e){
								isOpen = false;
								g_windowOpen[url] = null;
							}

							if(isOpen){
								//브라우져 활성화 처리
								g_windowOpen[url].focus();

								if(options && options.data){
									if(typeof(options.reload) != "undefined" && !options.reload){
										g_windowOpen[url].onsite.__activateMessage("", message);
										return;
									}else{
										g_windowOpen[url].onsite.__activateMessage(messageName, message);
									}
								}
							}else{
								if(options && options.data){
									naw.storage.set(messageName, message);
								}
							}

							//ie9에서 열리지 않는 현상 수정, object의 키 값에 . 이 들어가는 현상 제거.
							if(url.indexOf(".") != -1){
								url = url.substring(0, url.indexOf("."));
							}

							//open후 url변경 2017.04.24 kts.
							g_windowOpen[url] = window.open("", url, features);
							g_windowOpen[url].document.location.href = fullUrl;
						}
					}
				}
			}else{
				//options -> mergeOptions로 변경 2017/05/18
				var mergeOptions = {};
				if(options){//popup창일 경우는 objFeatures는 merge하지 않는다.
					mergeOptions = 	options.popup ? options : naw.merge(options, objFeatures);
				}
				else{
					mergeOptions = objFeatures;
				}

				//sso에 인증 권한 체크.
				naw.behavior.IServiceApplyAuth(url);
				naw.openWindow(url, mergeOptions);
			}
		//}
	},

	__activateMessage : function(messageName, tmpMessage, a_url){
		var message = JSON.parse(JSON.stringify(tmpMessage));
		//1. naw.adapter.outbound.message 호출 처리
		if(messageName == ""){
			naw.adapter.outbound.message(message);
		}else{
			//2. naw.storage.set 처리
			var objMsg = naw.merge({}, message);
			naw.storage.set(messageName, objMsg);
			//3. createWindow 처리
			if(a_url){
				createWindow(a_url, message);
			}
		}
	},

	/**
	* 새창으로 연계데이터 전달후 연계데이터를 opener에서 return 시킬 경우 사용.
	* @param {object} options opener에 전달할 데이터
	* @example
	* onsite.openerSendMessage({data:{a:"aa"}});
	*/
	openerSendMessage : function(options){
		var url = window.openerID;

		var fileName = url,
		message = null,
		messageName = "message-" + fileName.toLowerCase();
		if(naw.isNull(message)){
			message = {};
		}
		message.source = naw.getFileName(window.location.pathname);
		if(options && options.data){
			message.data = options.data;
		}

		if(url != "" && targetWindow.naw.isNCRMOpener){
			if(targetWindow.naw.NCRMOpener.naw.screenID == "nawmain"){
				if(url != "nawmain"){//opener가 nawmain일 경우 화면 open 하지 않음
					targetWindow.naw.NCRMOpener.onsite.__activateMessage(messageName, message, url);
				}else{
					if(message.data){
						targetWindow.naw.NCRMOpener.onsite.__activateMessage("", message);
					}
				}
			}
			else{
				if(message.data){
					if(targetWindow.naw.NCRMOpener.targetWindow.naw.screenID == "nawmain"){
						targetWindow.naw.NCRMOpener.targetWindow.onsite.__activateMessage(messageName, message, url);
					}else{
						targetWindow.naw.NCRMOpener.onsite.__activateMessage("", message);
					}
				}
			}
		}
		else{//그외
			return onsite.messageBox("opener가 존재 하지 않습니다.", "", "ALERT");
		}
	},

	/**
	 * 로케일에 따라 메세지를 보여준다.
	 * @param {String} strMsgId 화면에 보여줄 메세지 코드
	 * @returns {String} 요청한 msgid의 메세지 내용
	 * @example
	 * onsite.getMsg("W90001");
	 */
	getMsg:function(msgId) {
		var filterData = msgList.filter(function(menuData){return menuData["msgId"] == msgId})[0];
		return filterData.msgNm;
	},

	/**
	 * 모든 객체를 enable / disable 시키는 함수
	 * @param {Object} obj Input, Button, Grid, Combobox
	 * @param {Boolean} isEnable enable 여부
	 * @example
	 * onsite.changeCompEnable(obj, true);
	 */
	changeCompEnable:function(obj, isEnable){
		var obj = naw(obj, true);
		// 그리드, 콤보, 탭
		// 라디오, 체크박스 , input, 버튼
		naw("input, button", obj.jq).foreach(function(index){
			var $this = naw(this, true),
			componentThis = naw(this);

			if($this.tagName() == "BUTTON"){
				if($this.hasClass("dosearch")) return true;
				$this.disabled(!isEnable);
			}
			else if($this.tagName() == "INPUT"){
				$this.disabled(!isEnable);
			}
		});
		naw(".grid-pnl, .combobox-pnl, .tab-pnl", obj.jq).foreach(function(index){
			var $this = naw(this, true),
			componentThis = naw(this);

			if($this.hasClass("grid-pnl")){
				componentThis.setReadOnly(!isEnable);
			}
			else if($this.hasClass("combobox-pnl")){
				componentThis.disable(!isEnable);
			}
//			else if($this.hasClass("tab-pnl")){
//				componentThis.setProp("enable", isEnable);
//			}
		});

	},

	/**
	 * 해당 영역을 disabled또는 abled 시킨다.
	 * @param {String} area disabled 시킬 영역.
	 * @param {Boolean} disable disable 여부
	 * @example
	 * onsite.areaDisabled(area, true);
	 */
	areaDisabled : function(area, disable){
		var thisObj;

		if(naw("#"+area).length > 0){	//id지정시.
			thisObj = naw("#"+area);
			area = "#"+area
		}
		else{	//일반 객체시.
			thisObj = naw(area);
		}

		thisObj.disabled(disable)

		if(disable){
			thisObj.addClass("state-control");
		}
		else{
			thisObj.removeClass("state-control");
		}

	},

	/**
	 * 파일을 다운로드한다.
	 * @param {String} argFilePathNm 파일경로명
	 * @param {String} argAtchOrgcpFileNm 첨부원본파일명
	 * @param {String} argAtchSavFileNm 첨부저장파일명
	 * @param {Function} argCallback download완료 후 수행할 함수 지정(ie9는 사용 불가), 없을 경우 null or undefined or "".
	 * @param {String} argUploadId default "fileattach"
	 * @example
	 * onsite.attachFileDownload(argFilePathNm, argAtchOrgcpFileNm, argAtchSavFileNm)
	 */
	attachFileDownload:function(argFilePathNm, argAtchOrgcpFileNm, argAtchSavFileNm, argCallback,argUploadId) {
		var uploadId = (argUploadId) ? argUploadId : "fileattach";

		// download widget load - start
		if(naw("#common_myFiledownload").length == 0){
			naw.loadWidget({
				filedownload:function(){}
			});

			naw("#wrap").jq.append("<div class='extra-dimensions'><div class='filedownload-pnl' id='common_myFiledownload'></div></div>");
			naw("#common_myFiledownload").filedownload({template:{nodeId:uploadId}});
		}
		var widgetDownload = naw("#common_myFiledownload");

		//nodeId변경시.
		if(uploadId != "fileattach"){
			widgetDownload.changeNodeId(uploadId);
		}

		//callback 함수 추가시.
		if(!naw.isEmpty(argCallback)){
			widgetDownload.changeCallFunc(argCallback);
		}

		if(naw.isEmpty(argFilePathNm) || naw.trim(argFilePathNm) == "") {
			return onsite.messageBox("파일 경로명이 존재하지 않습니다.", "", "ALERT");
		}

		if(naw.isEmpty(argAtchOrgcpFileNm) || naw.trim(argAtchOrgcpFileNm) == "") {
			return onsite.messageBox("첨부원본파일명이 존재하지 않습니다.", "", "ALERT");
		}

		if(naw.isEmpty(argAtchSavFileNm) || naw.trim(argAtchSavFileNm) == "") {
			return onsite.messageBox("첨부저장파일명이 존재하지 않습니다.", "", "ALERT");
		}

		//download widget 파일다운로드 수행
		widgetDownload.filedownSubmit(argAtchSavFileNm, argAtchOrgcpFileNm, argFilePathNm);
	},

	/**
	 * fileKey 정보를 가지고 파일을 다운로드 받습니다.
	 * @param {String} fileKey 파일key
	 * @param {Object} fileParam 파일 param정보
	 * @example
	 * onsite.fileKeyDownload("1829671", {savefilenm : "contract.jpg"});
	 */

	fileKeyDownload : function(fileKey, fileParam){
		var ourl = "";
		if(fileParam){
			ourl = naw.config.context+"/file/downloadkey/"+fileKey+"?"+jQuery.param(fileParam);
		}
		else{
			ourl = naw.config.context+"/file/downloadkey/"+fileKey;
		}
		jQuery("main").append('<a id="__fileKeyDowload__" class="state-hide"></a>');

		var fileKeyDowloadObj = jQuery("#__fileKeyDowload__");

		fileKeyDowloadObj.prop("href", ourl);
		fileKeyDowloadObj[0].click();
	},

	excuteCallback : function(a_callbackFn, a_return){
		if(typeof(a_callbackFn) == "function"){
			a_callbackFn.call(window, a_return);
		}
	},

	/**
	 * 디버깅 로그를 남길 수 있는 함수
	 * @param {String} a_str 디버깅 내용
	 * @example
	 * onsite.log("오류");
	 */
	log : function(a_str){
		naw.logger.log(a_str);
	},

	/**
	 * footer 상단에 위치하는 가이드 메세지 영역을 보여주는 기능
	 * @param {object} guideMsg 가이드메세지 영역에 보여질 메세지, title : 제목, content : 내용
	 * @param {number} [delayTime] 가이드메세지 영역이 보여지는 시간(단위 : ms). 기본 설정 시간 : 5초
	 * @example
	 * onsite.guideMessage("업무<em>가이드메세지</em>가 보여집니다.");
	 */
	guideMessage : function(/*String*/guideMsg, /*String*/delayTime){
		var elMain = jQuery("main").get(0);

		if(!elMain){
			return false;
		}

		delayTime = (naw.isNull(delayTime))? 5000: delayTime;
		var self = jQuery('<div class="guidemessageArea"><div class="guidemessage-titlebar"><span class="guidemessage-fix"><input type="checkbox" id="fixGuidemessageArea"> <label for="fixGuidemessageArea">고정</label></span><span class="guidemessage-icon-close"></span></div><div id="guidemessage"><em>' + guideMsg.title + '</em></div><div id="guidemessage-content">'+guideMsg.content+'</div></div>');

		// 보험료 영역 여부에 따라 처리
		if(naw("#wrap-south").length == 0){
			var gmBottom = parseInt(jQuery("footer").css("bottom")) + jQuery("footer").outerHeight(true);
			if(jQuery(".messagearea").length == 1){
				gmBottom = gmBottom + parseInt(jQuery(".messagearea").css("height"));	//새창일 경우 message영역까지 처리.
			}
			self.css({"position":"fixed","bottom":gmBottom});
		}
		if(jQuery("footer").length == 0){
			if(elMain.scrollHeight > elMain.offsetHeight){
				self.css({"position":"fixed","bottom":0, "right":"26px", "overflow":"auto", "overflow-x":"hidden"});
			}else{
				self.css({"position":"fixed","bottom":0, "right":"0px", "overflow":"auto", "overflow-x":"hidden"});
			}
			jQuery("main").after(self);
		}else{
			jQuery("footer").before(self);
		}

		// 닫기
		jQuery(".guidemessage-icon-close").click(function(){
			self.slideUp("slow", function(){
//					naw.publish("window.resize", null);
				naw("#fixGuidemessageArea").checked(false);
			});	// hide
		});

		if(self.is(":visible")) {
			self.slideUp("slow", function(){
//				naw.publish("window.resize", null);
				naw("#fixGuidemessageArea").checked(false);
			});	// hide
		}
		else{
			// show
			self.slideDown("slow", function(){
//				naw.publish("window.resize", null);
				setTimeout(function(){
					// 고정
					if(!naw("#fixGuidemessageArea").checked()){
						self.slideUp("slow", function(){
//							naw.publish("window.resize", null);
						});	// hide
					}
				}, delayTime);
			});
		}
	},

	/**
	 * Nwagon차트를 생성한다. 옵션은 sample 화면 또는 Nwagon chart 가이드를 참고한다. target 객체의 id는 "Nwagon"으로 지정하지 않습니다.
	 * @param {Object} chartInfo chart를 생성하기 위한 options(chart마다 options값은 변경됨.)
	 * @example
	 * var options = {
	 *			'legend':{
	 *				names: ['Perceivable', 'Information', 'Understandable', 'Enough', 'Epilepsy', 'Operable', 'Navigation','Error'],
	 *				hrefs: []
	 *					},
	 *			'dataset': {
	 *				title: 'Web accessibility status',
	 *				values: [['n/a',53,67,23,78, 55, 45, 89]],
	 *				bgColor: '#f9f9f9',
	 *				fgColor: '#cc79a7'
	 *			},
	 *			'chartDiv': 'chart12',
	 *			'chartType': 'radar',
	 *			'chartSize': {width:600, height:300}
	 *		};
	 * onsite.createNwagonChart(options);
	 */
	createNwagonChart : function(chartInfo){
		if(typeof Nwagon == "undefined"){//동적으로 차트 화면만 import받도록
			naw.loadScriptSync(naw._getFixedUri("/thirdparty/Nwagon/Nwagon.js"));
		}
		Nwagon.chart(chartInfo);
	},

	/**
	 * 이미지 시스템 연동(미개발)
	 *
	 */
	imageSystemLink : function() {
		alert("이미지 시스템 연동 개발 중..");
		return;

	},

	/**
	 * HTML tag 를 문자열로 변환
	 * @param {String} as_Val HTML tag 가 있는 문자열
	 * @returns {String} 변환된 문자열
	 * @example
	 * 	onsite.getHTMLEncoding("가&lt;br&gt;나");	-> "가\n나"
	 */
	getHTMLEncoding : function(as_Val) {
		var s_Ret = as_Val;
		s_Ret = s_Ret.replace(/<BR>/g, "\n");
		s_Ret = s_Ret.replace(/<br>/g, "\n");
		s_Ret = s_Ret.replace(/<\/Q>/g, "'");
	    s_Ret = s_Ret.replace(/&QUOT;/g, "\"");

		return s_Ret;
	},

	/**
	 * 문자열을 HTML tag 로 변환
	 * @param {String} as_Val 변환할 문자열
	 * @returns {String} html tag 로 변환된 문자열
	 * @example
	 * 	onsite.getHTMLDecoding("가\n나");	-> "가&lt;br&gt;나"
	 */
	getHTMLDecoding : function(as_Val) {
		var s_Ret = as_Val;
		s_Ret = s_Ret.replace(/\n/g, "<br>");
		s_Ret = s_Ret.replace(/'/g, "</Q>");

		return s_Ret;
	},

	/**
	 * 우측 화면인지 mdi화면인지 구분 처리 및 우측화면이 show인지 hide확인 하는 함수.
	 * @param {String} type show-> 우측화면이 현재 self(우측화면)가 show인지 hide인지 확인, mode->우측화면인지 mdi화면인지 확인
	 * @returns {boolean} bool true/false 해당되지 않을 경우 undefined
	 * @example
	 * 	onsite.eastPnlShowMode(show);	-> false
	 */
	eastPnlShowMode : function(type){
		var topElement = frameElement ? (frameElement.parentNode.className.indexOf("east-contents") != -1) : false  ? true : false;
		if(type == "mode"){
			return topElement;
		}
		else{
			if(topElement){
				var checkMode = frameElement.parentNode.className.indexOf("state-hide") != -1;
				if(checkMode) return false;
				else return true;
			}
		}
	},

	/**
	* 마스킹 처리된 객체의 마스킹을 해제합니다.
	* @param {object} obj 마스킹을 해제할 객체.
	* @example
	* &lt;script type="text/javascript">
	* onsite.deSecureMask(naw("#ssn"))
	* &lt;/script>
	*/
	deSecureMask : function(obj, bool){
		if(!bool){
			bool = false;
		}
		obj.__secureMasking__(bool);
	},

	/**
	 * type에 따라서 formatting해준다.
	 * @param {String} type formatting type(date, time, ssn, tel, post, dateTime, num, brn, float1, float2, float3, card)
	 * @param {String} value formatting 할 데이터
	 * @returns {String} 변환된 문자열
	 */
	makeTypeFormat : function(type, value)
	{
		var rtnValue = "";
		switch(type) {
			case "float1":
				rtnValue = naw.round(value, 1);
				break;
			case "float2":
				rtnValue = naw.round(value, 2);
				break;
			case "float3":
				rtnValue = naw.round(value, 3);
				break;
			case "float4":
				rtnValue = naw.round(value, 4);
				break;
			default:
				rtnValue = naw.valMask(value, type);
				break;
		}

		return rtnValue;
	},
	/**
	 * type에 따라 해당하는 domain을 반환한다.
	 * @param {String} domainName report, image
	 * @returns {String} 요청된 문자열
	 * @example
	 * var do = onsite.getDomain("report");
	 */
	getDomain : function(domainName){
		//추후 커스터마이징
		var returnDomain = null;
		switch (domainName) {
			case "report":
				if(naw.isLocal){
					returnDomain = "https://rpt-dev.krma.or.kr:8402";
				}
				else if(naw.isDev){
					returnDomain = "https://rpt-dev.krma.or.kr:8402";
				}
				else if(naw.isTest){
					returnDomain = "https://rpt-test.krma.or.kr:8402";
				}
				else if(naw.isProd){
					returnDomain = "https://rpt.krma.or.kr:8402";
				}
				else {}
				break;
			case "image" :
				if(naw.isLocal){
					returnDomain = "https://img-dev.krma.or.kr:8411";
				}
				else if(naw.isDev){
					returnDomain = "https://img-dev.krma.or.kr:8411";
				}
				else if(naw.isTest){
					returnDomain = "https://img-dev.krma.or.kr:8411";
				}
				else if(naw.isProd){
					returnDomain = "prod";
				}
				else {}
				break;
			default:
				break;
		}
		return returnDomain;
	},
	/**
	 * caption을 접거나 펼치는 기능을 제공하는 함수
	 * @param {String} a_strId section ID
	 * @param {Boolean} a_state section 을 접을지에 대한 여부(작성하지 않으면 현재 상태에 따라 접히거나 펼쳐진다 - toggle)
	 * @example
	 * onsite.doCollapse("cont1")
	 */
	doCollapse : function (a_strId, a_state) {
		if(typeof(a_strId) == "undefined" || a_strId == "") return false;

		var captionEle = naw("#"+a_strId);

		if(captionEle.length == 0 || captionEle.tagName() != "DIV" || !captionEle.hasClass("caption-pnl")) return false;
		var captionEleH2 = naw("#"+a_strId +" h2");

		if(!naw.isNull(a_state))
		{
			if(a_state)
				captionEleH2.removeClass("state-collapse");
			else
				captionEleH2.addClass("state-collapse");

		}

		captionEleH2.click();

	},

	/**
	 * 초기화 진행(input, textarea, combobox의 disable, readonly 해제)을 위한 wrapper로 감싼 객체의 class명을 지정해야 한다.
	 * @param {String} className 객체 클래스 name
	 * @example
	 * onsite.init("dsView1")
	 */
	init : function(clsName){
		naw("."+clsName+" input, textarea").readonly(false); //tag readonly 해제
		naw("."+clsName+" input, textarea").disabled(false); //tag disabled 해제

		var comboboxObj = naw("."+clsName+" .combobox-pnl");
		for(var key in comboboxObj){
			comboboxObj[key].disable(false);
			comboboxObj[key].editable(true);
		}
	},

	___setGridComboData : function(widget, arrComboData, options){
		var colName = options.colNum;
		if(colName == undefined) return onsite.messageBox("colName 또는 index가 지정되지 않았습니다. 다시 확인하여 주세요.");
		var editable = options.editable ? options.editable : false;

		if(options.rowNum == undefined){
			var gridRowNum = widget.getRowNum();
			widget.setTplCellFormat(options.colNum, 'select');
			widget.setTplSelectOptions(options.colNum, arrComboData);
			if(!(gridRowNum == 0)){
				for(var i=0; i<gridRowNum; i++){
					widget.setCellAttr(i, options.colNum, {type:'select', editable:editable, options:arrComboData});
				}
			}
		}
		else{
			var optionRowNum = options.rowNum;
			if(naw.isArray(optionRowNum)){
				for(var i=0; i<optionRowNum.length; i++){
					widget.setCellAttr(optionRowNum[i], options.colNum, {type:'select', editable:editable, options:arrComboData});
				}
			}
			else{
				widget.setCellAttr(options.rowNum, options.colNum, {type:'select', editable:editable, options:arrComboData});
			}
		}
	},

	___getGridComboData : function(comboData, options){
		var arrComboData = [];
		var idx = 0;
		var valIdx = 0;
		var comboDataLength = comboData.length;
		if(options.textCol){
			idx  = 1;
			valIdx = 1;
			comboDataLength = (comboData.length)+1;
			if(options.valueCol == undefined){
				options.valueCol = "";
			}

			if((options.selectedIndex == 0) || (options.selectedValue == options.valueCol)){
				arrComboData.push({label:options.textCol, value:options.valueCol, selected:true});
			}
			else{
				arrComboData.push({label:options.textCol, value:options.valueCol});
			}

		}

		for(var key=idx; key<comboDataLength; key++){
			if(options.selectedValue == comboData[key-valIdx][options.value]){
				arrComboData[key] = {label:comboData[key-valIdx][options.label], value:comboData[key-valIdx][options.value], selected:true};
			}
			else if(key == options.selectedIndex){
				arrComboData[key] = {label:comboData[key-valIdx][options.label], value:comboData[key-valIdx][options.value], selected:true};
			}
			else{
				arrComboData[key] = {label:comboData[key-valIdx][options.label], value:comboData[key-valIdx][options.value]};
			}
		}

		return arrComboData;
	},

	/**
	 *  checkbox의 name을 기준으로 check된 값들만 return 받는다.
	 * @param {String} chkName checkbox name
	 * @returns {Object} check된 객체의 정보
	 * @example
	 * onsite.getCheckedBox("checkboxName")
	 */
	getCheckedBox : function(chkName){
		var checkedObj = naw("[name="+chkName+"]:checked");
		var returnObj = [];
		var checked;

		for(var i=0; i<checkedObj.length; i++){
			checked = checkedObj.nth(i);
			returnObj[i] = {value:checked.val(), text:naw("[for="+checked.id()+"]").text(), id:checked.id()}
		}
		return returnObj;
	},

	/**
	 * radio Button의 name을 기준으로 check되었는지 확인한다.
	 * @param {String} radName radio Button Name
	 * @returns {boolean} bool true/false
	 * @example
	 * onsite.getRadioButton("radNm")
	 */
	getRadioButton : function(radName){

		var radioObj = naw("[name="+radName+"]:checked");

		if(radioObj.length == 0){
			return false;
		}
		else{
			return true;
		}
	},

	/**
	 * 문자열중 특정 문자를 치환하여 문자열을 return 합니다.
	 * @param {String} text 변경 대상 문자열.
	 * @param {String || Array} value 변경할 문자열.
	 * @returns {String} 변환된 문자열
	 * @example
	 * onsite.getMessage("{0}과(와) {1}는(은) 필수 입력입니다.", ["이름", "날짜"]);
	 */
	getMessage : function(text, value){
		var tmpText =  text;
		var tmpValue = value;
		if (tmpValue == null) return tmpText;

		if(naw.isArray(tmpValue)){
			for(var i=0; i<tmpValue.length; i++) {
				tmpText = tmpText.replace("{" + (i) + "}", tmpValue[i]);
			}
		}
		else{
			tmpText = tmpText.replace("{0}", tmpValue);
		}
		return tmpText;
	},

	/**
	 * 입력받은 데이터로 check를 생성한다.
	 * @param {Object} target check박스를 생성할 target id
	 * @param {Array} chkArr check박스 정보. 단순 array로만 생성할 경우 check박스 value는 index지정.
	 * @param {String} type radio인자 checkbox인지에 대한 값, default는 checkbox
	 * @example
	 * onsite.setCheckbox("checkArea", [{dtlCdNm:"예", dtlCd:"1"}, {dtlCdNm:"아니오", dtlCd:"2", checked:true}]);
	 * onsite.setCheckbox("checkArea", ["예", "아니오"]);
	 */
	setCheckbox : function(target, chkArr, type){

		type = (type) ? type : "checkbox";

		if(naw.isArray(chkArr)){
			var textChk = "<span class='selection-grp'>";
			if(!chkArr[0].dtlCdNm){
				naw.foreach(chkArr, function(idx, obj){
					textChk += '<input type="'+type+'" id="'+target+'_'+idx+'" name="'+target+'_chkName" value="'+idx+'"><label for="'+target+'_'+idx+'">'+obj+'</label>';
				});
			}
			else{
				naw.foreach(chkArr, function(idx, obj){
					var value = obj.dtlCd;
					var text = obj.dtlCdNm;
					if(obj.checked){
						textChk += '<input type="'+type+'" id="'+target+'_'+value+'" checked name="'+target+'_chkName" value="'+value+'"><label for="'+target+'_'+value+'">'+text+'</label>';
					}
					else{
						textChk += '<input type="'+type+'" id="'+target+'_'+value+'" name="'+target+'_chkName" value="'+value+'"><label for="'+target+'_'+value+'">'+text+'</label>';
					}
				});
			}

			textChk += "</span>";
			naw("#"+target).append(textChk);
		}
	},

	/**
	 * 입력받은 두개의 json데이터를 merge한다.
	 * @param {Object} target check박스를 생성할 target id
	 * @param {Array} chkArr check박스 정보. 단순 array로만 생성할 경우 check박스 value는 index지정.
	 * @param {Object} options list일 경우는 {list:true}, 있는 값을 덮어쓰지 않을 경우 {overwrite:false}
	 * @example
	 * onsite.mergeData({a:"aa", b:"bb"}, {a:"11", c:"cc"}, false);
	 * -> {a:"11", b:"bb", c:"cc"};
	 * onsite.mergeData([{a:"aa", b:"bb"}, {a:"aa1", b:"bb1"}], [{a:"11", c:"cc"},{a:"a11", c:"acc"}]);
	 *  -> [{a:"11", b:"bb", c:"cc"}, {a:"a11", b:"bb1", c:"acc"}];
	 * onsite.mergeData([1,2],[3,4], false);
	 *  -> [1,2,3,4];
	 * @returns {Object}
	 */
	mergeData : function(obj1, obj2, options){
		if(options == undefined){ //아무것도 오지 않았을 경우 기본값으로 세팅
			options = {
				list : true,
				overwrite : true
			}
		}
		else{
			if(naw.isEmpty(options.list)){
				options.list = true
			}
			if(naw.isEmpty(options.overwrite)){
				options.overwrite = true;
			}
		}

		if(options.list){
			if(options.overwrite){
				var mergeArr = [];
				naw.foreach(obj1, function(idx, obj){
					mergeArr.push(naw.merge(obj, obj2[idx]));
				});

				return mergeArr;
			}
			else{
				var mergeArr = obj1;

				naw.foreach(obj1, function(idx, obj){
					for(var key2 in obj2[idx]){
						if(!mergeArr[idx][key2]){
							mergeArr[idx][key2] =  obj2[idx][key2];
						}
					}
				});

				return mergeArr;
			}
		}
		else{
			if(options.overwrite){
				return naw.merge(obj1, obj2);
			}
			else{
				if(!naw.isArray(obj1) && !naw.isArray(obj2)){
					var mergeObj = obj1;
					for(var key1 in obj1){
						for(var key2 in obj2){
							if(!mergeObj[key2]){
								mergeObj[key2] = obj2[key2];
							}
						}
					}
					return mergeObj;
				}
				else {
					return naw.merge(obj1, obj2);
				}
			}
		}
	},

	/**
	* 주민번호로 출생년도를 return 한다.
	* @param {String} ssnBirth 주민번호 7자리 또는 13자리.
	* @retunrs {String}
	* @example
	* onsite.getBornDay("8601012");
	*/
	getBornDay : function(ssnBirth) {
		//1900 ->  1 : 남자, 2 : 여자
		//2000 -> 3 : 남자, 4 : 여자
		//1800 -> 9 : 남자, 0 : 여자
		//외국인 1900 -> 5:남자, 6: 여자
		//외국인 2000 -> 7: 남자, 8:여자

		if(typeof(ssnBirth) != "string"){
			ssnBirth = naw.toStr(ssnBirth);
		}

		if(ssnBirth.indexOf("-")){
			ssnBirth = naw.replace(ssnBirth, "-", "");
		}

		var checkYy = ssnBirth.substr(6, 1);
		var bornYy = ssnBirth.substr(0, 6);

		var rtn = "";

		switch (checkYy) {

			case "9" :
			case "0" :
				rtn = "18" + bornYy;
				break;

			case "1" :
			case "2" :
			case "5" :
			case "6" :
				rtn = "19" + bornYy;
				break;

			case "3" :
			case "4" :
			case "7" :
			case "8" :
				rtn = "20" + bornYy;
				break;
			default :
				break;
		}

		return rtn;
	},

	/**
	* upload후 callback영역에서 이 함수를 호출하면, 업로드 된 파일 정보를 return한다.
	* @param {Object} arg upload완료후 fileupload에서 주는 모든 arguments를 넘긴다.
	* @retunrs {Object}
	* @example
	* onsite.uploadCallback(arg);
	*/
	uploadCallback : function(arg){
		var argObj = arg;
		var tempArr = [];
        if(argObj[0] == "0000")//success
        {
            for(var i=0;i<argObj[1].length;i++)
            {
                tempArr.push({
                    "fname":argObj[1][i],//원본파일명
                    "fsavename":argObj[2][i],//저장파일명
                    "fext":argObj[3][i],//확장자
                    "fsize":argObj[4][i]+"byte",//파일 사이즈
                    "fpath":argObj[5][i],//sub경로
                });
            }
            return tempArr;
        }
        else{
        	return onsite.messageBox("upload에 실패하였습니다.");
        }
	},

	/**
	* upload한 img파일의 경로를 return한다.
	* @param {String} orgName 원본 파일명(확장자 포함).
	* @param {String} saveName 저장된 파일명.
	* @param {String} subPath sub경로.
	* @param {String} uploadId uploadId가 fileattach가 아닐경우 필요. default는 fileattach로 지정.
	* @returns {String}
	* @example
	* onsite.imageShow("aa.jpg", "20170901102717167001", "temp/aa");
	*/
	imageShowSrc : function(orgName, saveName, subPath, uploadId){
		uploadId = (uploadId) ? uploadId : "fileattach";

		var uploadURI = naw._getServletUri("upload");
		var sImgUrl = uploadURI + "?upload_id=" + uploadId + "&funCd=down";
		sImgUrl += "&subFPath=" + ((typeof(subPath)=="undefined")? "" : subPath);
		sImgUrl += "&saveFName=" + ((typeof(saveName)=="undefined")? "" : saveName);
		sImgUrl += "&orgFName=" + ((typeof(orgName)=="undefined")? "" : orgName);

		return(sImgUrl);
	},

	/**
	* 공통으로 지정된 excel, rd path를 return 받는다.
	* @param {String} url excel, rd
	* @returns {String}
	* @example
	* onsite.getSitePath("rd");
	*/
	getSitePath : function(url){
		if(url == "excel"){
			/**	사이트 엑셀 대용량 다운로드 경로지정.	**/
			return "excel";
		}
		else if(url == "rd"){
			/**	사이트 레포트디자인(rd) 파일 다운로드 경로지정.	**/
			return "files/rd";
		}
		else if(url == "doc"){
			/**양식지 파일 다운로드 경로지정.	**/
			return "files/doc";
		}
		else {
			return "excel";
		}
	},

	/**
	* 년월일시분초 단위로 두 기간을 비교해서 분 단위로 return 받는다
	* @param {String} yyyy-MM-dd hh:mm:ss
	* @returns {Integer}
	* @example
	* onsite.getDiffTime("2017-01-01 12:00:00","2017-10-10 12:00:00");
	* onsite.getDiffTime("2017-01-01 12:00:00",naw.getServerDay("yyyy-MM-dd hh:mm:ss"));
	* onsite.getDiffTime("2017-01-01 12:00",naw.getServerDay("yyyy-MM-dd hh:mm"));
	* onsite.getDiffTime("2017-01-01",naw.getServerDay("yyyy-MM-dd"));
	*/
	getDiffTime: function(startTime,endTime){

		var st = new Date(startTime);
		var et = new Date(endTime);
		var diff = et-st;
		var minDiff = naw.toInt(diff/1000/60);

		return minDiff;
	},

	/**
	* 전화번호 형식으로 return
	* @param {String}
	* @returns {String}
	* @example
	* onsite.phoneFormat("16881234");
	* onsite.phoneFormat("01012341234");
	* onsite.phoneFormat("0101231234");
	* onsite.phoneFormat("0212341234");
	* onsite.phoneFormat("0311231234");
	*/
	phoneFormat : function(num){
		var phone = naw.valMask(num, "telAll");

		return phone;
	},

	/* ========================================== 기타 onsite 함수  끝 ========================================== */

	/* ========================================== dataset onsite 함수  시작 ========================================== */
	/**
	 * subDataSet 또는 listDataSet에  json형태의 데이터를 set 합니다.
	 * @param {String} name return 받을 이름.
	 * @param {dataset} dataset set할 subDataSet 또는 listDataSet
	 * @param {Object} objData object형태의 data
	 * @param {String} type list(다건Object)형태 인지 sub(단건Object)형태 인지 지정. default list
	 * @example
	 * onsite.subListSetJson(name, dataset, objData,"list");
	 */
	subListSetJson : function(name, dataset, objData, type){
		if(type == undefined){
			type = "list";
		}

		if(type == "list"){
			//참조 관계를 끊기 위해  str변환 후 다시 obj로 변환.
			var convertStr;
			var convertObj;
			var listDataSet = dataset.getListDataSet(name);
			for(var i=0; i<objData.length; i++){
				convertStr = JSON.stringify(objData[i]);
				convertObj = naw.convertObject(convertStr);

				listDataSet.set(convertObj, i);
			}
		}
		else{
			var listDataSet = dataset.getSubDataSet(name);
			listDataSet.set(objData);
		}
	},

	/**
	 * subDataSet 또는 listDataSet을 json형태로 get 합니다.
	 * @param {String} name return 받을 이름.
	 * @param {dataset} dataset subDataSet, listDataSet을 json형태로 return한다.
	 * @param {String} type list(다건Object)형태 인지 sub(단건Object)형태 인지 지정. default list
	 * @returns {Object} json형태의 데이터
	 * @example
	 * onsite.subListGetJson(name, dataset, "list");
	 */
	subListGetJson : function(name, dataset, type){
		var returnObj;
		if(type == undefined){
			type = "list";
		}

		if(type == "list"){
			returnObj = new Array();
			var convertStr;
			var convertObj;

			var listDataSet = dataset.getListDataSet(name);
			for(var i=0; i<listDataSet.getCount(); i++){
				convertStr =  JSON.stringify(listDataSet.getRow(i));
				convertObj = naw.convertObject(convertStr);
				returnObj[i] = convertObj;
			}
		}
		else{
			returnObj = dataset.getJson()[name];
		}
		return returnObj;
	},

	/**
	 * 단건 필드를 객체에 세팅할 경우 사용한다. 지정된 area의 아래 객체들을 setting한다. 단, dataset field명과 동일해야 한다.
	 * @param {String} area set할 영역의 id
	 * @param {object} data set할 object data
	 * @example
	 * onsite.getObjData(area, data)
	 */
	getObjData : function(area, data){
		var areaData = naw("#"+area+" *");
		if(arguments[2]){
			areaData = naw.parentWindow().naw("#"+area+" *");
		}

		areaData.foreach(function() {
			if(this.id){
				if(data[this.id] != undefined && data[this.id] != null){
					naw(this).val(data[this.id]);
				}
			}
			else if(this.name){
				if(data[this.name] != undefined && data[this.name] != null){
					naw(this).val(data[this.name]);
				}
			}
			else {
			}
		});
	},

	/**
	 * 단건 필드를 dataset에 세팅할 경우 사용한다. 지정된 area의 아래 객체들을 setting한다. 단, dataset field명과 동일해야 한다.
	 * @param {String} area set할 영역의 id
	 * @param {dataset} data set할 dataset
	 * @example
	 * onsite.setObjData(area, data)
	 */
	setObjData : function(area, data){
		var parentBool = arguments[2] ? arguments[2] : false;
		var areaData = jQuery("#"+area+" *");
		if(parentBool){
			areaData = naw.parentWindow().jQuery("#"+area+" *");
		}

		var nawThis;
		areaData.each(function() {
			nawThis = naw(this);

			if(parentBool){
				nawThis = naw.parentWindow().naw(this);
			}

			if(nawThis.name == "combobox"){	//combobox인 경우
				data.set(nawThis.renderTo, nawThis.val());
				if (this.id.indexOf('_') > -1) {
					var name = this.id.substring(this.id.indexOf('_') + 1, this.id.length);
					data.set(name, nawThis.val());
				}
			}
			else if(nawThis.name == "accordion"){}	//accordion 예외
			else if(nawThis.name == "tab"){}		//tab 예외
			else if(nawThis.name == "listcombobox"){}//listcombobox 예외
			else if(nawThis.name == "grid"){}		//grid 예외
			else if(nawThis.name == "fileupload"){}
			else if(nawThis.name == "filedownload"){}
			else{							//일반 태그.
				if(nawThis.tagName() == "TEXTAREA"){
					if(this.id){
						data.set(this.id, nawThis.val());
					}
					else if(this.name){
						data.set(this.name, nawThis.val());
					}
				}
				else{
					var thisType = this.type;
					if(thisType == "text" || thisType == "hidden" || thisType == "password"){		//일반 input박스.
						if(this.id){
							data.set(this.id, nawThis.val());
						}
						else if(this.name){
							data.set(this.name, nawThis.val());
						}
					}
					else if(thisType == "radio"){		//radio Button
						//radio는 하나만 체크.
						if(this.name){
							if(nawThis.checked()){
								data.set(this.name, nawThis.val());
							}
						}
					}
					else if(thisType == "checkbox"){	//checkbox
						if(this.id){
							data.set(this.id, nawThis.val());
						}
					}
					else{}
				}
			}
		});
	},

	/**
	 * listDataSet의 해당하는 컬럼의 값이 일치하는 rowIndex를 return 한다.
	 * @param {dataset} dataset dataset
	 * @param {String} datasetName dataset의 list 이름.
	 * @param {String} colId 찾을 colId
	 * @param {String} serachData 찾을 value
	 * @returns {Number} 선택된 idx
	 * @example
	 * onsite.getListDataSetIdx(dataset, listDataSetId, colId, searchVal);
	 */
	getListDataSetIdx : function(dataset, listDataSetId, colId, searchVal) {
		var dsTmpList = dataset.getListDataSet(listDataSetId);
		if(dsTmpList.getCount){
			var rtnIdx;
			for(var i = 0; i < dsTmpList.getCount(); i++) {
				if(dsTmpList.get(colId, i) == searchVal) {
					rtnIdx = i;
				}
			}
			return rtnIdx;
		}
	},

	/**
	 * dataset을 grid의 template정보를 가지고 엑셀을 내려 받는다. 단, grid가 merge인 경우는 안된다.
	 * @param {dataset} dataset 엑셀로 뽑을 dataset
	 * @param {String} dsList 엑셀로 뽑을 dataset의 list명.
	 * @param {Object} gridObj template를 가져올 그리드 obj
	 * @param {String} excelName 엑셀 파일명 지정.
	 * @param {Boolean} hideBool 숨겨진 column들도 가져올 경우 true, default false;
	 * @example
	 * onsite.datasetExportExcel(dataset,"dsList" gridObj, "엑셀테스트");
	 */
	datasetExportExcel : function(dataset, dsList, gridObj, excelName, hideBool){
		if((dataset == undefined) || (dsList == undefined) || (gridObj == undefined))
			return onsite.messageBox("보내는 인자가 잘못 되었습니다. 다시 확인하여 주세요.");

		if(dataset.getListDataSet(dsList).getCount() == 0){
			return onsite.messageBox("조회된 건이 존재하지 않습니다. 다시 확인하여 주세요.");
		}


		excelName = excelName == undefined ? naw.screenID : excelName;
		hideBool = hideBool == undefined ? false : hideBool;

		var grdTemplate = gridObj.getTemplate();
		var grdBodyTemplate = grdTemplate.gridBody;
		var grdHeaderTemplate = grdTemplate.gridHeader;
		var grdBodyTitle = [];
		var grdHeaderTitle = [];
		var options = {};


		//numbering이 있을경우
		if(grdTemplate.numbering){

			if(!grdTemplate.numberingWidth){
				grdTemplate.numberingWidth = "40";
			}

			if(!grdTemplate.numberingTitleText){
				grdTemplate.numberingTitleText = " ";
			}

			grdHeaderTitle.push(grdTemplate.numberingTitleText);
			grdBodyTitle.push("numbering");

			var listDataSetObj = dataset.getListDataSet(dsList);
			var listDataSetObjCount = listDataSetObj.getCount();
			for(var j=1; j<=listDataSetObjCount; j++){
				listDataSetObj.set({"numbering":j}, j-1);
			}
		}

		if(hideBool){
			for(var key in grdBodyTemplate){
				if(!grdBodyTemplate[key].hide){
					grdHeaderTitle.push(grdHeaderTemplate[key].name);
					grdBodyTitle.push(grdBodyTemplate[key].colName);
				}
			}
		}
		else{
			for(var key in grdBodyTemplate){
				grdHeaderTitle.push(grdHeaderTemplate[key].name);
				grdBodyTitle.push(grdBodyTemplate[key].colName);
			}
		}

		options = {
			name : excelName+".xlsx",
			header : grdHeaderTitle.join("^"),
			columns : grdBodyTitle.join("^")
		}

		//팝업창일 경우 dataset을 부모창에 다시 저장
		if(naw.isPopup && naw.parentWindow()){
			var nawParent = naw.parentWindow();
			nawParent.__parentDataset__ = new nawParent.naw.dataSet(dataset.getName());
			nawParent.__parnetJsonStr__ = nawParent.naw.convertString(dataset.getJson());
			nawParent.__parnetJsonData__ = nawParent.naw.convertObject(nawParent.__parnetJsonStr__);

			nawParent.__ObjKey__ = nawParent.Object.keys(nawParent.__parnetJsonData__);
			nawParent.__ObjKey__Length = nawParent.__ObjKey__.length;
			for(nawParent.__i__=0; nawParent.__i__<nawParent.__ObjKey__Length; nawParent.__i__++){
				nawParent.__parentDataset__.set(nawParent.__parnetJsonData__);
			}
			nawParent.__parentDataset__.exportExcel(dsList, options);
		}
		else{
			dataset.exportExcel(dsList, options);
		}

	},

	/* ========================================== dataset onsite 함수  끝 ========================================== */

	/* ========================================== 공통코드 onsite 함수  시작 ========================================== */

	/**
	 * 공통코드를 list로 가져온다(사용여부의 Y).
	 * @param {String} grpCd 그룹코드
	 * @param {String} typeCd 상세코드
	 * @returns {Object}
	 * @example
	 * onsite.getCdList("A0001", {ect2:"N"});
	 * onsite.getCdList("A0001", "06", {ect2:"N"});
	 */
	getCdList : function(grpCd, typeCd, ectCd){
		var filterYnData = onsite.___filterData(cdList, {text:"useYn", value:"Y"})[0];
		var filterGrpCd;
		var filterTypeCd;


		if(grpCd && !typeCd && !ectCd){		//그룹코드
			filterGrpCd = onsite.___filterData(filterYnData, {text : "grpCd", value : grpCd})[0];
			return filterGrpCd;
		}
		else if(grpCd && typeCd && !ectCd){	//그룹코드, 상세코드
			filterGrpCd = onsite.___filterData(filterYnData, {text : "grpCd", value : grpCd})[0];

			if(typeof(typeCd) == "object"){
				var filterEtcCd;
				for(var key in typeCd){
					filterEtcCd = onsite.___filterData(filterGrpCd, {text : key, value : typeCd[key]})[0];
				}
				return filterEtcCd;
			}
			else{
				filterTypeCd = onsite.___filterData(filterGrpCd, {text : "typeCd", value : typeCd})[0];
				return filterTypeCd;
			}
		}
		else if(grpCd && typeCd && ectCd){	//그룹코드, 상세코드
			filterGrpCd = onsite.___filterData(filterYnData, {text : "grpCd", value : grpCd})[0];
			filterTypeCd = onsite.___filterData(filterGrpCd, {text : "typeCd", value : typeCd})[0];

			for(var key in ectCd){
				filterEtcCd = onsite.___filterData(filterTypeCd, {text : key, value : ectCd[key]})[0];
			}
			return filterEtcCd;
		}
		else {
			return onsite.messageBox("보내는 인자가 잘못 되었습니다. 확인바랍니다.","","ALERT");
		}
	},

	/**
	 * 공통코드를 가져온다(사용여부의 Y).
	 * @param {String} grpCd 그룹코드
	 * @param {String} typeCd 유형코드
	 * @param {String} dtlCd 상세코드
	 * @returns {Object}
	 * @example
	 * onsite.getCd("A0001", "06", {ect2:"N"});
	 * onsite.getCd("A0001", "06", "1", {ect2:"N"});
	 */
	getCd : function(grpCd, typeCd, dtlCd, etcCd){
		var filterYnData = onsite.___filterData(cdList, {text:"useYn", value:"Y"})[0];
		var filterGrpCd;
		var filterTypeCd;
		var filterDtlCd;

		if(dtlCd == null){//dtlCd가 null일 경우 빈값 return;
			var objKeys = Object.keys(cdList[0]);
			var nullObj = new Object();

			for(var key in objKeys){
				nullObj[objKeys[key]] = "";
			}

			return nullObj;
		}

		if(grpCd && !typeCd && !dtlCd && !etcCd){		//그룹코드
			filterGrpCd = onsite.___filterData(filterYnData, {text : "grpCd", value : grpCd})[0];
			return filterGrpCd[0];
		}
		else if(grpCd && typeCd && !dtlCd && !etcCd){	//그룹코드, 상세코드
			filterGrpCd = onsite.___filterData(filterYnData, {text : "grpCd", value : grpCd})[0];
			if(typeof(typeCd) == "object"){
				var filterEtcCd;
				for(var key in typeCd){
					filterEtcCd = onsite.___filterData(filterGrpCd, {text : key, value : typeCd[key]})[0];
				}
				return filterEtcCd[0];
			}
			else{
				filterTypeCd = onsite.___filterData(filterGrpCd, {text : "typeCd", value : typeCd})[0];
				return filterTypeCd[0];
			}
		}
		else if(grpCd && typeCd && dtlCd && !etcCd){	//그룹코드, 상세코드
			filterGrpCd = onsite.___filterData(filterYnData, {text : "grpCd", value : grpCd})[0];
			filterTypeCd = onsite.___filterData(filterGrpCd, {text : "typeCd", value : typeCd})[0];
			if(typeof(dtlCd) == "object"){
				var filterEtcCd;
				for(var key in dtlCd){
					filterEtcCd = onsite.___filterData(filterTypeCd, {text : key, value : dtlCd[key]})[0];
				}
				return filterEtcCd[0];
			}
			else{
				filterDtlCd = onsite.___filterData(filterTypeCd, {text : "dtlCd", value : dtlCd})[0];
				return filterDtlCd[0];
			}

		}
		else if(grpCd && typeCd && dtlCd && etcCd){	//그룹코드, 상세코드
			filterGrpCd = onsite.___filterData(filterYnData, {text : "grpCd", value : grpCd})[0];
			filterTypeCd = onsite.___filterData(filterGrpCd, {text : "typeCd", value : typeCd})[0];
			filterDtlCd = onsite.___filterData(filterTypeCd, {text : "dtlCd", value : dtlCd})[0];

			var filterEtcCd;
			for(var key in etcCd){
				filterEtcCd = onsite.___filterData(filterDtlCd, {text : key, value : etcCd[key]})[0];
			}
			return filterEtcCd[0];
		}
		else {
			return onsite.messageBox("보내는 인자가 잘못 되었습니다. 확인바랍니다.","","ALERT");
		}
	},

	/**
	 * 모든 공통코드를 가져온다(사용여부의 관계 없이 모두).
	 * @param {String} grpCd 그룹코드
	 * @param {String} typeCd 유형코드
	 * @param {Array} etcCd 기타코드
	 * @returns {Object}
	 * @example
	 * onsite.getCdAllList("A0001", {"ect1" : "N"});
	 * onsite.getCdAllList("A0001");
	 * onsite.getCdAllList("A0001", "06");
	 * onsite.getCdAllList("A0001", "06", {"ect1" : "N"});
	 */
	getCdAllList : function(grpCd, typeCd, etcCd){
		var filterGrpCd;
		var filterTypeCd;

		if(grpCd && !typeCd && !etcCd){		//그룹코드
			filterGrpCd = onsite.___filterData(cdList, {text : "grpCd", value : grpCd})[0];
			return filterGrpCd;
		}
		else if(grpCd && typeCd && !etcCd){
			filterGrpCd = onsite.___filterData(cdList, {text : "grpCd", value : grpCd})[0];
			if(typeof(typeCd) == "object"){
				var filterEtcCd;
				for(var key in typeCd){
					filterEtcCd = onsite.___filterData(filterGrpCd, {text : key, value : typeCd[key]})[0];
				}
				return filterEtcCd;
			}
			else{
				filterTypeCd = onsite.___filterData(filterGrpCd, {text : "typeCd", value : typeCd})[0];
				return filterTypeCd;
			}
		}

		else if(grpCd && typeCd && etcCd){	//그룹코드, 상세코드
			filterGrpCd = onsite.___filterData(cdList, {text : "grpCd", value : grpCd})[0];
			filterTypeCd = onsite.___filterData(filterGrpCd, {text : "typeCd", value : typeCd})[0];

			var filterEtcCd;
			for(var key in etcCd){
				filterEtcCd = onsite.___filterData(filterTypeCd, {text : key, value : etcCd[key]})[0];
			}
			return filterEtcCd;
		}
		else {
			return onsite.messageBox("보내는 인자가 잘못 되었습니다. 확인바랍니다.","","ALERT");
		}
	},

	/**
	 * 공통코드를 가져와 해당 컴포넌트를 세팅한다.radio, checkbox인 경우는 append할 target을 지정한다.
	 * @param {Object} objComp naw객체(combobox, grid, radio, checkbox)
	 * @param {String} grpCd 그룹코드
	 * @param {String} typeCd 유형코드
	 * @param {Object} default {textCol:"선택", valueCol:"01", selectedIndex:"0" || selectedValue :"01"}
	 * @example
	 * onsite.getCdComp(naw("#combobox1"), "A0001", {textCol:"선택", valueCol:"01"});				//combobox
	 * onsite.getCdComp(naw("#widgetGRid100"), "A0001", "06", {textCol:"선택", valueCol:"01", ect:{etc2:"N"}});		//grid
	 * onsite.getCdComp({name:"radio", target:"tdAppend1", etc:{etc2:"N"}, defaultValue:"01"}, "A0008");		//radio
	 * onsite.getCdComp({name:"checkbox", target:"tdAppend2", defaultValue:["01", "02"]}, "A0009");//checkbox
	 */

	getCdComp : function(objComp, grpCd, typeCd){
		var argLength = arguments.length;
		var lastArg = {};
		var ectCd;
		//combobox인 경우
		if(objComp.name == "combobox"){
			if(typeof(arguments[argLength-1]) == "object"){	//마지막객체가 object인경우
				lastArg = arguments[argLength-1]
				ectCd = lastArg.etc;
				if(lastArg.textCol == "" || lastArg.valueCol == ""){
					if(naw.isEmpty(lastArg.valueCol)){
						lastArg.valueCol = "";
					}

					if(naw.isEmpty(lastArg.textCol)){
						lastArg.textCol = "";
					}

					if(objComp.count() == 0){
						objComp.addItem(lastArg.valueCol, lastArg.textCol);
					}
					else{
						objComp.insertItem(0,  lastArg.valueCol, lastArg.textCol);
					}
				}
			}

			if(typeof(typeCd) == "string"){				//상세코드의 여부
				var typeCdData = this.getCdList(grpCd, typeCd, ectCd);

				var typeCdArr = [];
				for(var i=0; i<typeCdData.length; i++){
					typeCdArr[i] = [typeCdData[i].dtlCd, typeCdData[i].dtlCdNm];
				}
				objComp.addItem(typeCdArr);

				if(lastArg.selectedIndex != undefined){
					objComp.selectedIndex(lastArg.selectedIndex);
				}
				else if(lastArg.selectedValue != undefined){
					objComp.val(lastArg.selectedValue);
				}
				else{
					objComp.selectedIndex(lastArg.selectedIndex);
				}
			}
			else{
				var grpCdData = this.getCdList(grpCd, ectCd);// combobox셋팅
				var grpCdArr = [];
				for(var i=0; i<grpCdData.length; i++){
					grpCdArr[i] = [grpCdData[i].dtlCd, grpCdData[i].dtlCdNm];
				}
				objComp.addItem(grpCdArr);

				if(lastArg.selectedIndex != undefined){
					objComp.selectedIndex(lastArg.selectedIndex);
				}
				else if(lastArg.selectedValue != undefined){
					objComp.val(lastArg.selectedValue);
				}
				else{
					objComp.selectedIndex(lastArg.selectedIndex);
				}
			}
		}
		else if(objComp.name == "grid"){
			var colName = "colName 또는 index가 지정되지 않았습니다. 다시 확인하여 주세요.";
			if(typeof(arguments[argLength-1]) == "object"){	//마지막객체가 object인경우
				lastArg = arguments[argLength-1];
				ectCd = lastArg.etc;

				if(naw.isEmpty(lastArg.colNum)){
					return onsite.messageBox(colName);
				}
				else{
					colName = lastArg.colNum;
				}

				if(lastArg.textCol){
					if(!lastArg.valueCol || lastArg.valueCol == ""){
						lastArg.valueCol = "";
					}
				}
			}

			var editable = lastArg.editable ? lastArg.editable : false;

			if(typeof(typeCd) == "string"){						//상세코드의 여부
				var typeCdData = this.getCdList(grpCd, typeCd, ectCd);	// grid셋팅

				var mergeOptions = naw.merge(lastArg, {label:"dtlCdNm", value:"dtlCd"});
				var typeCdArr = onsite.___getGridComboData(typeCdData, mergeOptions);//combodata return;
				onsite.___setGridComboData(objComp, typeCdArr, mergeOptions);
			}
			else{
				var grpCdData = this.getCdList(grpCd, ectCd);

				var mergeOptions = naw.merge(lastArg, {label:"dtlCdNm", value:"dtlCd"});
				var grdCdArr = onsite.___getGridComboData(grpCdData, mergeOptions);//combodata return;
				onsite.___setGridComboData(objComp, grdCdArr, mergeOptions);
			}
		}
		//radio버튼인 경우
		else if(objComp.name == "radio"){
			var etcCd = objComp.etc;
			var radioData = this.getCdList(grpCd, typeCd, etcCd);// radio셋팅

			var radioDataLength = radioData.length;
			var thisRadioID = "";
			var thisRadioName = "";
			var radioText = "";

			var radioText = '<span class="selection-grp">';
			for(var i=0; i<radioDataLength; i++){
				thisRadioID = radioData[i]["grpCd"]+"_"+radioData[i]["typeCd"]+"_"+radioData[i]["dtlCd"];
				thisRadioName = radioData[i]["grpCd"]+"_radio";
				radioText += '<input name="'+objComp.target+"_"+thisRadioName+'" type="radio" id="'+objComp.target+"_"+thisRadioID+'_rdo" value="'+radioData[i]["dtlCd"]+'"><label for="'+objComp.target+"_"+thisRadioID+'_rdo">'+radioData[i]["dtlCdNm"]+'</label>';
			}
			radioText += '</span>';

			naw("#"+objComp.target).append(radioText);

			if(!naw.isEmpty(objComp.defaultValue)){
				naw("[name="+objComp.target+"_"+thisRadioName+"]").val(objComp.defaultValue);
			}

		}
		//checkbox버튼인 경우
		else if(objComp.name == "checkbox"){
			var etcCd = objComp.etc;
			var checkboxData = this.getCdList(grpCd, typeCd, etcCd);// checkbox셋팅

			var checkboxDataLength = checkboxData.length;
			var thisCheckboxID;
			var thisCheckboxName;

			var checkvalue = "true";
			var unCheckvalue = "false";

			if(objComp.check && objComp.unCheck){
				checkvalue = objComp.check;
				unCheckvalue = objComp.unCheck;
			}

			var radioText = '<span class="selection-grp">';
			for(var i=0; i<checkboxDataLength; i++){
				thisCheckboxID = checkboxData[i]["grpCd"]+"_"+checkboxData[i]["typeCd"]+"_"+checkboxData[i]["dtlCd"];
				thisCheckboxName = checkboxData[i]["grpCd"]+"_checkbox";
				radioText += '<input name="'+objComp.target+"_"+thisCheckboxName+'" type="checkbox" id="'+objComp.target+"_"+thisCheckboxID+'_chk" value="'+checkboxData[i]["dtlCd"]+'"><label for="'+objComp.target+"_"+thisCheckboxID+'_chk">'+checkboxData[i]["dtlCdNm"]+'</label>';
			}
			radioText += '</span>';

			naw("#"+objComp.target).append(radioText);

			if(!naw.isEmpty(objComp.defaultValue)){
				var checkBoxObj = naw("[name="+objComp.target+"_"+thisCheckboxName+"]");
				if(naw.isArray(objComp.defaultValue)){
					for(var i=0; i<checkBoxObj.length; i++){
						for(var j=0; j<objComp.defaultValue.length; j++){
							if(checkBoxObj.nth(i).attr("value") == objComp.defaultValue[j]){
								checkBoxObj.nth(i).checked(true);
							}
						}
					}
				}
				else{
					for(var i=0; i<checkBoxObj.length; i++){
						if(checkBoxObj.nth(i).attr("value") == objComp.defaultValue){
							checkBoxObj.nth(i).checked(true);
						}
					}
				}
			}
		}
		else{
			return onsite.messageBox("잘못 요청하였습니다. 다시 확인하시기 바랍니다.", "", "ALERT");
		}
	},

	___filterData : function(filter, filterInfo){

		var filterData = filter;
		var filterObj = [];

		filterObj.push(filterData.filter(function(root){return root[filterInfo.text] == filterInfo.value}))
		return filterObj;
	},

	/* ========================================== 공통코드 onsite 함수  끝 ========================================== */

	/* ========================================== report onsite 함수  시작 ========================================== */
	/**
	 * dataset을 rd string으로 변환한다.
	 * @param {dataset} dataObj dataset 객체
	 * @param {String} gubun 데이터 구분자
	 * @param {Object} option data formatting 적용 할 정보
	 * @returns {String} 변환된 문자열
	 * @example
	 * onsite.makeRdData(dataset, "^", option);
	 */
    makeRdData:function(dataObj, gubun, option){
		var objRv 		= dataObj.getAllRow("RV");
		var objRdata 	= dataObj.getAllRow("RDATA");

		var strRv = "";
		jQuery.each(objRv, function(key, value){
			strRv  = "/rv";
			jQuery.each(value,function(key,value){
				if( typeof(option)!=="undefined" )
					strRv += " "+key+"["+onsite.makeTypeFormat(option[key], value)+"]";
				else
					strRv += " "+key+"["+value+"]";
			});
		});

		var strRdata = "";
		jQuery.each(objRdata, function(key, value){
			jQuery.each(value,function(key,value){
				if( typeof(option)!=="undefined" )
					strRdata += onsite.makeTypeFormat(option[key], value) + gubun;
				else
					strRdata += value + gubun;
			});
			strRdata += "^@@^";	//"\r\n";
		});
		if( strRdata!="" )
			strRdata = "/rdata ["+strRdata+"]";

		return strRv + " " + strRdata;
	},
	/**
	 * rv데이터 만들어준다.
	 * @param {dataset} dataObj dataset 객체
	 * @param {String} dataGroup List 명
	 * @param {Object} option data formatting 적용 할 정보
	 * @returns {String} 변환된 문자열
	 * @example
	 * onsite.makeRVData(dataset, "RV_DATA", option);
	 */
	makeRVData:function(dataObj, dataGroup, option){
		var objData = dataObj.getAllRow(dataGroup);	//dataObj.getDataObject(dataGroup);
		var rtnStr = "";
		jQuery.each(objData, function(key, value){
			jQuery.each(value,function(key,value){
				if( typeof(option)!=="undefined" )
					rtnStr += key + "["+onsite.makeTypeFormat(option[key], value)+"] ";
				else
					rtnStr += key+"["+value+"] ";
			});
		});
		return rtnStr;
	},
	/**
	 * rdata를 만들어준다.
	 * @param {dataset} dataObj dataset 객체
	 * @param {String} dataGroup List 명
	 * @param {String} gubun 데이터 구분자
	 * @param {Object} option data formatting 적용 할 정보
	 * @returns {String} 변환된 문자열
	 * @example
	 * onsite.makeRData(dataset, "RDATA", "|", option);
	 */
	makeRData:function(dataObj, dataGroup, gubun, option){
		var objData = dataObj.getAllRow(dataGroup);

		var strRdata = "";
		jQuery.each(objData, function(key, value){
			jQuery.each(value,function(key,value){
				if( typeof(option)!=="undefined" )
					strRdata += onsite.makeTypeFormat(option[key], value) + gubun;
				else
					strRdata += value + gubun;
			});
			strRdata += "^@@^";	//"\r\n";
		});
		if( strRdata!="" )
			strRdata = "/rdata ["+strRdata+"] ";

		return strRdata;
	},
	/**
	 * 다수의 dataset으로 페이징 RDATA를 만든다.
	 * @param {dataset} dataObj dataset 객체
	 * @param {String} dataGroup List 명. 구분자 ","
	 * @param {String} gubun 데이터 구분자
	 * @param {Object} option data formatting 적용 할 정보
	 * @returns {String} 변환된 문자열
	 * @example
	 * onsite.makeRDataPage(dataset, "RDATA1,RDATA2,RDATA3", "|", option);
	 */
	makeRDataPage:function(dataObj, dataGroup, gubun, option){
		var arrGroup = dataGroup.split(',');
		var objData = null;
		var strRdata = "";

		for( var m=0, cntArr=arrGroup.length; m< cntArr; m++ )
		{
			//Model 이름 설정
			onsite.log("dataset >> " + arrGroup[m].refModel + "\n");

			var logCnt = 0;
			objData = dataObj.getAllRow(arrGroup[m]);//getDataObject(arrGroup[i].replace(/\s/g,''));
			jQuery.each(objData, function(key, value){
				jQuery.each(value,function(key,value){
					if( typeof(option)!=="undefined" )
						strRdata += onsite.makeTypeFormat(option[key], value) + gubun;
					else
						strRdata += value + gubun;
					logCnt++;
					onsite.log(  logCnt + "   " + key + "   " + value);
				});
				strRdata += "^@@^";	//"\r\n";
			});

			strRdata += "//EOR//^@@^";
//			strBuffer += "\n\n";
			onsite.log( "\n\n");
		}
		if( strRdata!="" )
			strRdata = "/rdata ["+strRdata+"] ";
		return strRdata;
	},
	/**
	 * 다수의 dataobject로 페이징 RDATA를 만든다.
	 * @param {dataset} dataObj dataset 객체
	 * @param {String} dataGroup List 명. 구분자 ","
	 * @param {String} gubun 데이터 구분자
	 * @param {Object} option data formatting 적용 할 정보
	 * @param {Object} colNames : 정의된 컬럼이름 목록 modelGroup이 List 형식이므로 해당 그룹 구분은 '|'로 컬럼간 구분은 ','로 구분해서 세팅해주면 된다.
	 * @returns {String} 변환된 문자열
	 * @example
	 * onsite.makeRDataPageNew(dataset, "RDATA", "|", option, colNames);
	 */
	makeRDataPageNew:function(dataObj, dataGroup, gubun, option, colNames){
		var colGroup = colNames.split('|'); //dataGroup 에 따른 분리
		var arrGroup = dataGroup.split(',');
		var objData = null;
		var strRdata = "";
		var colLst = "";
		var eqCheck = false;

		var cnt = 0;				//컬럼 순번 count
		onsite.log("colNames = " +colNames);	//전체 데이터그룹 컬럼 표시

		//dataset별 for loop
		for( var i=0, cntArr=arrGroup.length; i<cntArr; i++ )
		{
			//모델 이름 설정
			onsite.log("dataset " + arrGroup[i].refModel + "\n");
			onsite.log("colLst =" + colGroup[i]); //해당 데이터셋 컬럼 표시

			objData = dataObj.getAllRow(arrGroup[i].replace(/\s/g,'')); //dataset name 세팅
			colLst = colGroup[i].split(',');

			jQuery.each(objData, function(key, value){
				cnt = 0;// 컬럼번호 초기화
				//컬럼에 맞는 데이터만 세팅함.
				for( var j=0; j<colLst.length; j++ ){
					jQuery.each(value,function(key,value){
						eqCheck = false;
						if(key ===  colLst[j] && !naw.isNull(value)){
							eqCheck = true;
							if( typeof(option)!=="undefined" ){
								strRdata += onsite.makeTypeFormat(option[key], value) + gubun;
							}else{
								strRdata += value + gubun;
							}
							cnt++;
							onsite.log(  cnt + "   " + key + "   " + value);
							return false;
						}
					});
					if(!eqCheck){
						strRdata += gubun;
					}
				}
				strRdata += "^@@^";	//strRdata += "\r\n";
				onsite.log("\r\n");
			});

			strRdata += "//EOR//^@@^";
			onsite.log( "\n\n");
		}

		if( strRdata!="" )
			strRdata = "/rdata ["+strRdata+"] ";
		return strRdata;
	},
	/**
	 * 다수의 dataobject로 멀티건에 대한 페이징 RV, RDATA를 만든다.
	 * @param {dataset} dataObj dataset 객체
	 * @param {String} rvDataGroup List 명. 구분자 ","
	 * @param {String} rDataGroup List 명
	 * @param {String} gubun 데이터 구분자
	 * @param {Object} option data formatting 적용 할 정보
	 * @param {Object} multiSelSize
	 * @returns {String} 변환된 문자열
	 * @example
	 * onsite.makeMultiRvRDataPage(dataset, "RDATA1,dsRDATA2,dsRDATA3', "RDATA", "^", option, 1);
	 */
	makeMultiRvRDataPage:function(dataObj, rvDataGroup, rDataGroup, gubun, option, multiSelSize){
		var arrGroup = rvDataGroup.split(',');
		var objData = null;
		var objRdata = null;
		var strRdata = "";
		var size = 0;
		size = multiSelSize;
		for (var i=0; i < size; i++) {

			for (var z=0; z < arrGroup.length; z++) {

				objData = dataObj.getAllRow(arrGroup[z].replace(/\s/g,''));

				var value = objData[i];

				jQuery.each(value,function(key,value){
					if( typeof(option)!=="undefined" )
						strRdata += onsite.makeTypeFormat(option[key], value) + gubun;
					else
						strRdata += value + gubun;
				});

			}
			strRdata += "^@@^";	//"\r\n";
			strRdata += "//EOR//";
			strRdata += "^@@^";	//"\r\n";

			objRdata = dataObj.getDataObject(rDataGroup);

			var rDataValue = objRdata[i];

			for (var y = 0; y < rDataValue.length; y++) {

				var value = rDataValue[y];

				jQuery.each(value, function(key, value){
					if (typeof(option) !== "undefined")
						strRdata += onsite.makeTypeFormat(option[key], value) + gubun;
					else
						strRdata += value + gubun;
				});

				strRdata += "^@@^";	//"\r\n"
			}
			strRdata += "//EOR//";
			strRdata += "^@@^";
		}
		return strRdata;
	},


	/**
	 * jsonData를 xml로 변환
	 * @param {object} dataObj dataset 또는 jonsData
	 * @param {object} options rootName, recordName,  camel(boolena, default->true), type(xml, str -> default는 str),
	 * @returns {Xml||String} 변환된 xml 또는 문자열
	 * @example
	 * onsite.jsonToXml(dataset, options);
	 */
	jsonToXml : function(dataset, options){
		var datasetJson;
		var xmlOptions = {};

		if(!options){
			xmlOptions = {
				rootName : "ROOT",
				recordName : "record",
				type : "str",
				camel : true
			};
		}
		else{
			if(naw.isEmpty(options.rootName)){
				xmlOptions.rootName = "ROOT";
			}

			if(naw.isEmpty(options.recordName)){
				xmlOptions.recordName = "record";
			}

			if(naw.isEmpty(options.type)){
				xmlOptions.type = "str";
			}

			if(naw.isEmpty(options.camel)){
				xmlOptions.camel = true;
			}

		}

		if(dataset.getName){
			datasetJosn = dataset.getJson();
		}
		else{
			datasetJosn = dataset;
		}

		//camel표기법 원복 시키는 함수.
		var __convertNotCamel__ = function(data){
			var tempData = data;
			if(!naw.isEmpty(tempData)){
				var camelChange = function(str){
					var tempStr = str[0];
					for(var i=1; i<str.length; i++){
						if(str[i].match("[A-Z]")){
							tempStr += "_"+str[i];
						}
						else{
							tempStr += str[i];
						}
					}
					return tempStr;
				}

				var tempObjStr = "{";
				for(var key in data){
					tempObjStr += '"'+camelChange(key).toUpperCase()+'"'+':'+'"'+data[key]+'"'+",";
				}
				tempObjStr += "}";

				var matchIndex = tempObjStr.match(/\,/g).length;
				var returnObj = naw.convertObject(naw.replaceNth(tempObjStr, matchIndex-1, "," , ""));

				return returnObj;
			}
		}

		var xmlStr = '<?xml version="1.0" encoding="UTF-8"?>';
			xmlStr += "<"+xmlOptions.rootName+">";
		var jsonXml;
		var keyCheckIdx = 0;
		if(xmlOptions.camel){
			for(var key in datasetJosn){
				if(Object.keys(datasetJosn)[keyCheckIdx].toLowerCase().indexOf("list") != -1){//다건일 경우
					var key2CheckIdx = 0;
					xmlStr += "<"+key+">";
					for(var key2 in datasetJosn[key]){
						xmlStr += naw.json2xmlStr(datasetJosn[key][key2CheckIdx], xmlOptions.recordName);
						key2CheckIdx++;
					}
					xmlStr += "</"+key+">";
				}
				else{//단건일 경우
					xmlStr += naw.json2xmlStr(datasetJosn[key], key);
				}
				keyCheckIdx ++;
			}
		}
		else{
			for(var key in datasetJosn){
				if(Object.keys(datasetJosn)[keyCheckIdx].toLowerCase().indexOf("list") != -1){//다건일 경우
					var key2CheckIdx = 0;
					xmlStr += "<"+key+">";
					for(var key2 in datasetJosn[key]){
						xmlStr += naw.json2xmlStr(__convertNotCamel__(datasetJosn[key][key2CheckIdx]), xmlOptions.recordName);
						key2CheckIdx++;
					}
					xmlStr += "</"+key+">";
				}
				else{//단건일 경우
					xmlStr += naw.json2xmlStr(__convertNotCamel__(datasetJosn[key]), key);
				}
				keyCheckIdx ++;
			}
		}

		xmlStr += "</"+xmlOptions.rootName+">";

		//문자열
		if(xmlOptions.type == "str"){
			return xmlStr;
		}
		else{//xml형식
			jsonXml = naw.parseXML(xmlStr);
			return jsonXml;
		}
	}
	/* ========================================== report onsite 함수  끝 ========================================== */

	//메뉴호출 함수. -->수정하지 마세요.
	,__getBizMenu__ : function(auth, isMobile){
		isMobile = (isMobile == undefined ? "N" : isMobile);

		return tmpJsonMenu = comm.getBizMenu({
			header:{
				url : "/admin/menuList.json"
			},
			user: {
				srchUpperId : auth, //1 : 관리자, 2: 경제성평가
				srchMobileYn : isMobile
			}
		});
	},
	getBizOrgan : function(){
		return comm.getBizOrgan({
			header:{
				url : "/admin/organList.json"
			},
			user :{}
		});
	}

	//sso인증체크(절대수정하거나 삭제하지 마세요).
	,__getSSOCheck__ : function(){
		if(!naw.__designMode__){

			if(naw.screenID != "nawlogon" && naw.screenID != "nawstart" && !onsite.eastPnlShowMode("mode")){
				var ssInfo = comm.sessionInfo({ //일단 세션 거래 날림.
					header :{url : "/main/sessionInfo.json"},
					user : {}
				});
//				console.log(ssInfo);
//				var ssInfo;
				if(!naw.isFwkMode && (ssInfo != null || ssInfo != undefined)){//새창일 경우로 판단.

					if(naw.isEmpty(naw.storage.getHeader()))
					naw.storage.setHeader(ssInfo);

					//메인 화면만 체크.
					if(naw.config.auth.loadable) {	//새창일 경우 권한이 없는 화면일때 redirect
						if(naw.endsWith(naw.screenID, "M") || naw.endsWith(naw.screenID, "m")) {
							var isAuth = false;
							var headerRoleList = naw.getHeader("roleList");
							for(var key in headerRoleList){
								if(naw.screenID == headerRoleList[key]["authId"]){
									isAuth = true;
								}
							}
							if (!isAuth) {
								window.location.href = "../../webfw/html/nawauth.html";
							}
						}
					}
				} else {
					if(naw.isEmpty(naw.getHeader("userId")) || ssInfo == null){//userId가 없으면 session이 없다고 판단.
						alert("세션 정보가 만료되었습니다. 다시 로그인해주십시오.");

						if(naw.screenID == "nawmain"){
							window.location.href = "./nawlogon.html"
						}
						else{
							if(naw.isFwkMode && naw.isPopup){	//fwk popup;
								top.window.location.href = "../nawlogon.html";
							}
							else{
								top.window.location.href = "../../../webfw/html/nawlogon.html";
							}
						}
					}
				}
			}

		}
	}
});