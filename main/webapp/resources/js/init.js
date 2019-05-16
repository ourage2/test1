/**
 * 각종 js lib 초기화및 기초 세팅
 *
 */

// jquery ajax에서 block 사용시 전달할 메시지
//var gBlockMessage = '';

//센터 목록
//onm.ajax({
//	url: _contextPath_ + '/cmn/objList.json',
//	data: {'queryId': 'cmn.centerList'},
//	success: function(res) {
//		for (var idx = 0; idx < res.list.length; idx++) {
//			var obj = {};
//			obj.cd = res.list[idx].cd;
//			obj.nm = res.list[idx].nm;
//			gCenterList.push(obj);
//		}
//	}
//});

var gHolidayList = null;
var gHolidayTitle= null;
//$.ajax({
//	url: contextPath + '/common/HolidayList.json',
//	cache: true,
//	success: function(rs) {
//		if (!rs) return;
//
//		gHolidayList = new Array();
//		gHolidayTitle= new Array();
//		for (var nIdx=0; nIdx<rs.length; nIdx++) {
//			gHolidayList[nIdx] = new Date(rs[nIdx].hldydt);
//			gHolidayTitle[nIdx]= rs[nIdx].hldynm;
//		}
//	}
//});


/**
 * 입력받은 date가 공휴일인지 확인한다. 사용법: fnIsHoliday(new Date('yyyy/MM/dd'));
 * fnIsHoliday('yyyy/MM/dd');
 *
 * @param date:
 *            Date객체 또는 YYYYMMDD, YYYY-MM-DD, YYYY/MM/DD포맷의 문자열
 */
function fnIsHoliday(date) {
	var targetDate = null;
	if (null==gHolidayList || 1>gHolidayList.length) {
		return false;
	}

	if (typeof date=="object") {	//Date객체 이므로 그냥 사용
		targetDate = date;
	}
	else if (typeof date=="string") {
		if (8==date.length) {	//YYYYMMDD포맷
			targetDate = new Date(date.substr(0,4) + '/' + date.substr(4,2) + '/' + date.substr(6,2));
		}
		else if (10==date.length) {	//YYYY-MM-DD포맷, YYYY/MM/DD포맷
			while (-1!=date.indexOf('-')) {
				date = date.replace('-', '/');
			}
			targetDate = new Date(date);
		}
		else {
			return false;
		}
	}
	else {
		return false;
	}

	var strTargetDay = targetDate.getFullYear() + targetDate.getMonth() + targetDate.getDate();
	for (var nIdx=0; nIdx<gHolidayList.length; nIdx++) {
		var strHoliDay = gHolidayList[nIdx].getFullYear() + gHolidayList[nIdx].getMonth() + gHolidayList[nIdx].getDate();
		if (strHoliDay==strTargetDay) {
			return true;
		}
		if (gHolidayList[nIdx]>targetDate) {
			return false;
		}
	}

	return false;
}

/**
 * 입력받은 date가 공휴일이면 gHolidayList변수의 인덱스를 반환한다.
 * 사용법: fnIsHoliday(new Date('yyyy/MM/dd'));
 * 		  fnIsHoliday('yyyy/MM/dd');
 * @param date: Date객체 또는 YYYYMMDD, YYYY-MM-DD, YYYY/MM/DD포맷의 문자열
 */
function fnGetHolidayIdx(date) {
	var targetDate = null;
	if (null==gHolidayList || 1>gHolidayList.length) {
		return -1;
	}

	if (typeof date=='object') {	//Date객체 이므로 그냥 사용
		targetDate = date;
	}
	else if (typeof date=='string') {
		if (8==date.length) {	//YYYYMMDD포맷
			targetDate = new Date(date.substr(0,4) + '/' + date.substr(4,2) + '/' + date.substr(6,2));
		}
		else if (10==date.length) {	//YYYY-MM-DD포맷, YYYY/MM/DD포맷
			while (-1!=date.indexOf('-')) {
				date = date.replace('-', '/');
			}
			targetDate = new Date(date);
		}
		else {
			return -1;
		}
	}
	else {
		return -1;
	}

	var strTargetDay = targetDate.getFullYear().toString();
	strTargetDay 	+= targetDate.getMonth().toString();
	strTargetDay 	+= targetDate.getDate().toString();
	for (var nIdx=0; nIdx<gHolidayList.length; nIdx++) {
		var strHoliDay = gHolidayList[nIdx].getFullYear().toString();
		strHoliDay	+= gHolidayList[nIdx].getMonth().toString();
		strHoliDay	+= gHolidayList[nIdx].getDate().toString();
		if (strHoliDay==strTargetDay) {
			return nIdx;
		}
		if (gHolidayList[nIdx]>targetDate) {
			return -1;
		}
	}

	return -1;
}


function fnChkByte(obj, maxByte){
	var str = obj.value;
	var str_len = str.length;

	var rbyte = 0;
	var rlen = 0;
	var one_char = '';
	var str2 = '';

	for(var i=0; i<str_len; i++){
		one_char = str.charAt(i);
		if(escape(one_char).length > 4){
			rbyte += 2;                                         //한글2Byte
		}else{
			rbyte++;                                            //영문 등 나머지 1Byte
		}

		if(rbyte <= maxByte){
			rlen = i+1;                                          //return할 문자열 갯수
		}
	}

	if(rbyte > maxByte){
		alert('한글 '+(maxByte/2)+'자 / 영문 '+maxByte+'자를 초과 입력할 수 없습니다.');
		str2 = str.substr(0,rlen);                                  //문자열 자르기
		obj.value = str2;
		fnChkByte(obj, maxByte);
	}else{
		document.getElementById('byteInfo').innerText = rbyte;
	}
}

// datepicker용 기본 options
var gDatepickerOpts = {
		dateFormat:		'yy-mm-dd',
		changeMonth:	true,
		changeYear:		true,
		monthNames:		['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
		monthNamesShort:['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
		dayNames:		['일', '월', '화', '수', '목', '금', '토'],
		dayNamesMin:	['일', '월', '화', '수', '목', '금', '토'],
		dayNamesShort:	['일', '월', '화', '수', '목', '금', '토'],
		beforeShowDay: function (date) {
			var result;
			switch (date.getDay()) {
			case 0:
				// 일요일
				result = [true, 'date-sunday'];
				break;
			case 6:
				// 토요일
				result = [true, 'date-saturday'];
				break;
			default:
				result = [true, ''];
				break;
			}
			var nIdx = fnGetHolidayIdx(date);
			if (-1 != nIdx) {
				result = [true, 'date-holiday', gHolidayTitle[nIdx]];
			}
			return result;
		},
		onSelect: function(dateText, inst) {
			// minDate/maxDate 설정 사용법
			// => mindateid="targetid", 현재 datepicker의 값이 minDate가 되는 대상 datepicker의 id를 지정
			// => maxdateid="targetid", 현재 datepicker의 값이 maxDate가 되는 대상 datepicker의 id를 지정
			var $input = $(this); // input
			var mindateid = $input.attr('mindateid');
			var maxdateid = $input.attr('maxdateid');
			if (mindateid) $('[name=' + mindateid + ']').datepicker( 'option', 'minDate', dateText );
			if (maxdateid) $('[name=' + maxdateid + ']').datepicker( 'option', 'maxDate', dateText );
		},
		beforeShow: function () {
			var this$ = $(this);
			var rangeday = this$.attr('rangeday');
			if (rangeday) {
				var arr = rangeday.split(',');
				if (arr[0] && this.name === arr[0]) {
					var addMin = arr.length > 1 && arr[1] ? Number(arr[1]) : 7;
					var addMax = arr.length > 2 && arr[2] ? Number(arr[2]) : 30;
					var $strDt = $('input[name=' + this$.attr('maxdateid') + ']');
					var minDate = $strDt.datepicker('getDate');
					this$.datepicker('option', 'minDate', onm.addDate(minDate, addMin));
					this$.datepicker('option', 'maxDate', onm.addDate(minDate, addMax));
				}
			}
		},
		onClose: function () {
			var this$ = $(this);
			var rangeday = this$.attr('rangeday');
			if (rangeday) {
				var arr = rangeday.split(',');
				if (arr[0] && this.name !== arr[0]) {
					var addMin = arr.length > 1 && arr[1] ? Number(arr[1]) : 7;
					var addMax = arr.length > 2 && arr[2] ? Number(arr[2]) : 30;
					var $endDt = $('input[name=' + this$.attr('mindateid') + ']');
					var minDate = this$.datepicker('getDate');
					$endDt.datepicker('option', 'minDate', onm.addDate(minDate, addMin));
					$endDt.datepicker('option', 'maxDate', onm.addDate(minDate, addMax));
				}
			}
		}

//		onClose: function(){ $(this).parent().find("label[class=error]").remove(); $(this).parent().find("input").removeClass("error"); }
		// $('.error', $(this).parent().find('label')).remove();  $('.error', $(this).parent().find('label')).removeClass("error");
	};

$.MonthPicker = {
	i18n: {
		year: '',
		prevYear: '전년',
		nextYear: '다음년',
		next12Years: '이전 12년',
		prev12Years: '다음 12년',
		nextLabel: '다음달',
		prevLabel: '이전달',
		buttonText: '달력',
		jumpYears: '연도 선택',
		backTo: '월 선택',
		months: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월']
	}
};

var gMonthPickerOpts = {
	Button: '<img class="ui-datepicker-trigger" src="' + _contextPath_ + '/resources/image/cmn/calendar.gif">',
	MonthFormat: 'yy-mm',
	OnBeforeMenuOpen: function (e) {
		var $input = $(this),
			mindateid = $input.attr('maxdateid'),
			maxdateid = $input.attr('mindateid');

		if (mindateid) {
			var $min = $('[name=' + mindateid + ']');
			$input.MonthPicker('option', 'MinMonth', $min.MonthPicker('GetSelectedDate'));
		}

		if (maxdateid) {
			var $max = $('[name=' + maxdateid + ']');
			$input.MonthPicker('option', 'MaxMonth', $max.MonthPicker('GetSelectedDate'));
		}
	}
};

// jgrid에서 jquery ajax 사용시 ajaxStart, ajaxStop 이벤트 미적용을 위해 global 프로퍼티 설정
//$.jgrid.ajaxOptions = { error: fnAjaxError };
// jgrid에서 페이징을 사용하지 않는 경우 rowNum을 무제한으로 설정
//$.jgrid.defaults.rowNum = -1;



//세션 처리
var sUserId;
var sUserNm;
var sUserData;

if (window.frameElement && window.frameElement.nodeName == 'IFRAME') {
	sUserId = parent.sUserId;
	sUserNm = parent.sUserNm;
	sUserData = parent.sUserData;
} else {
	if (location.href.indexOf('main/login.do') <= -1 && location.href.indexOf('mmain/mlogin.m') <= -1) {
		onm.ajax({
			url: _contextPath_ + '/main/sessionInfo.json',
			async: false,
			data: {},
			success: function(res) {
				sUserId = res.userId;
				sUserNm = res.userNm;
				sUserData = res;
			}
		});
	}
}
var fnMonthCal;
$(function($) {

	/**
	 * input 달력
	 *
	 * 사용자 입력시 mask 셋팅
	 * autoTab을 사용할 경우 form을 기반으로 다음 input을 찾는데 감싸고 있는 form이 없는 경우는
	 * 스크립트 에러가 발생하기 때문에 autoTab을 사용하지 않는다.
	 */
	$('input[type=text].calendar')
		.attr('maxlength', '10')
		.css('width', window.location.href.indexOf('/mobile') > -1 ? '90' : '75')
		.on('click', function() {this.select();})
		.datepicker(gDatepickerOpts)
//		.setMask({ mask : '9999-19-39', autoTab: false })
		.focusout(function(e) {
			if (!e.currentTarget.value) return;
			var selDt = e.currentTarget.value;
			if (selDt.length == 8) {
				e.currentTarget.value = selDt.substring(0, 4) + '-' + selDt.substring(4, 6) + '-' + selDt.substring(6, 8);
			}

			if (!naw.isDate(e.currentTarget.value)) {
				alert('[' + e.currentTarget.value + ']은 존재하지 않는 날짜입니다.\n다시 입력하세요.');
				e.currentTarget.value = '';
				e.preventDefault();
				return;
			}

			var $input		= $(e.currentTarget),
				mindateid	= $input.attr('maxdateid'),
				maxdateid	= $input.attr('mindateid');

			if (mindateid) {
				var $min = $('[name=' + mindateid + ']'),
					minVal = $min.val();
				if (minVal) {
					var srcs	= $input.val().split('-'),
						mins	= minVal.split('-'),
						srcDate	= new Date(srcs[0], srcs[1] - 1, srcs[2]),
						minDate	= new Date(mins[0], mins[1] - 1, mins[2]);
					if (srcDate.getTime() < minDate.getTime()) {
						alert('입력일이 시작일보다 작습니다.');
						e.currentTarget.value = '';
						e.preventDefault();
						return;
					}
				}
			}
			if (maxdateid) {
				var $max = $('[name=' + maxdateid + ']'),
					maxVal = $max.val();
				if (maxVal) {
					var srcs	= $input.val().split('-'),
						maxs	= maxVal.split('-'),
						srcDate	= new Date(srcs[0], srcs[1] - 1, srcs[2]),
						maxDate	= new Date(maxs[0], maxs[1] - 1, maxs[2]);
					if (srcDate.getTime() > maxDate.getTime()) {
						alert('입력일이 종료일보다 큽니다.');
						e.currentTarget.value = '';
						e.preventDefault();
						return;
					}
				}
			}
		});

	fnMonthCal = function () { $('input[type=text].monthPicker')
		.css('width', '60')
		.attr('maxlength', '7')
		.MonthPicker(gMonthPickerOpts)
		.focusout(function (e) {
			if (!e.currentTarget.value) return;
			var selYm = e.currentTarget.value;
			if (selYm.length == 6) {
				e.currentTarget.value = selYm.substring(0, 4) + '-' + selYm.substring(4, 6);
			}

			var srcDate = $(this).MonthPicker('Validate');

			if ($.type(srcDate) !== 'date') {
				alert('[' + e.currentTarget.value + ']은 존재하지 않는 년월입니다.\n다시 입력하세요.');
				e.currentTarget.value = '';
				e.preventDefault();
				return;
			}

			var $input = $(e.currentTarget),
				mindateid = $input.attr('maxdateid'),
				maxdateid = $input.attr('mindateid');

			if (mindateid) {
				var $min = $('[name=' + mindateid + ']'),
					minVal = $min.val();
				if (minVal) {
					var minDate = $min.MonthPicker('GetSelectedDate');
					if (srcDate.getTime() < minDate.getTime()) {
						alert('입력년월이 시작년월보다 작습니다.');
						e.currentTarget.value = '';
						e.preventDefault();
						return;
					}
				}
			}
			if (maxdateid) {
				var $max = $('[name=' + maxdateid + ']'),
					maxVal = $max.val();
				if (maxVal) {
					var maxDate = $max.MonthPicker('GetSelectedDate');
					if (srcDate.getTime() > maxDate.getTime()) {
						alert('입력년월이 종료년월보다 큽니다.');
						e.currentTarget.value = '';
						e.preventDefault();
						return;
					}
				}
			}
		});
	}
	fnMonthCal();

	$('textarea').each(function(){
//		console.log(editMaxCnt);
		var $this = $(this);
		if ('none' == $this.css('display')) { return; }
		var	maxLen = parseInt($this.attr('maxlength')) || editMaxCnt;
		if ($this.parent().find('span') == 'undefined' || $this.parent().find('span').length == 0) {
			var htmlStr = '<span class="textareaCnt"></span>';
			$this.parent().append(htmlStr);
		}
		$this.parent().find('span.textareaCnt').text(0 + '/' + maxLen + ' byte').css('font-weight', 'bold').css('vertical-align', 'bottom');
	});

	$(document).on('keyup', 'textarea', function(e) {
		var $this = $(e.target);
		var	maxLen = parseInt($this.attr('maxlength')) || editMaxCnt;
		var valLen = naw.getByteLength($this.val());
		if (valLen >= maxLen) {
			$this.val(naw.substrByte($this.val(), 0, maxLen));
			$this.parent().find('span.textareaCnt').text(maxLen + '/' + maxLen + ' byte');
		} else {
			$this.parent().find('span.textareaCnt').text(valLen + '/' + maxLen + ' byte');
		}
	});

	$('.enterSrch').keydown(function(event) {
		if (event.which == 13) {
//				$('#btnRSearch').trigger('click');
			$(this).parent().parent().parent().find('#srchBtn, button').each(function(){
				if(this.type == 'button' || this.id == 'srchBtn') {
					$(this).trigger('click');
				}
			});
		}
	});

	//그리드가 같은 영역에 wrap이 안되 있기때문에 주석처리 - 미사용
//	$('.content_title>span').css('cursor', 'pointer');
//	$('.content_title>span').on('click' , function() {
//		$(this).parent().siblings('span, div, table').each(function() {
//			if ($(this).css('display') == 'none') {
//				$(this).slideDown();
//			} else {
//				$(this).slideUp();
//			}
//		});
//	});

	if (location.href.indexOf('exam/sample') > -1) { $('.layout_bg').hide(); }
	if (location.href.indexOf('main/logout') > -1) { $('.layout_bg').hide(); }
	$('span.ico_xls').attr('title', '엑셀다운로드');
	$('.chosen').chosen({width: '95%'});
	$('.content_title').hide();

	//권한처리
	if (typeof(sUserData) !== 'undefined') {
		authCheck();
	}
});


function authCheck() {

	var uri = location.href;
	var ext = uri.substring(uri.lastIndexOf(".") + 1, uri.length);
	var menuCd = uri.substring(uri.lastIndexOf("/") + 1, uri.lastIndexOf("."));
	var roleList = sUserData.roleList;
	if (ext.startsWith('m')) { return; } //모바일일 경우 권한 컨트롤을 하지 않는다.
//		console.log(menuCd);
//		console.log(ext);

	var btn$ = $('button');
	for (var idx = 0; idx < roleList.length; idx++) {
		var idNm;
		for (var jdx = 0; jdx < btn$.size(); jdx++) {
			idNm = btn$.eq(jdx).attr('id') || '';
			if (null != idNm && idNm != '') {
				idNm = idNm.toLowerCase();
			}
//				console.log(roleList[idx]);
//				console.log(idNm);
			if (menuCd.indexOf(roleList[idx].menuCd) > -1 && roleList[idx].insertYn == 'N') {
				if (idNm.indexOf('new') > -1) { btn$.eq(jdx).hide(); }
			}
			if (menuCd.indexOf(roleList[idx].menuCd) > -1 && roleList[idx].updateYn == 'N') {
				if (idNm.indexOf('save') > -1) { btn$.eq(jdx).hide(); }
			}
			if (menuCd.indexOf(roleList[idx].menuCd) > -1 && roleList[idx].deleteYn == 'N') {
				if (idNm.indexOf('del') > -1) { btn$.eq(jdx).hide(); }
			}
			if (menuCd.indexOf(roleList[idx].menuCd) > -1 && roleList[idx].excelYn == 'N') {
				if (idNm.indexOf('xls') > -1) { btn$.eq(jdx).hide(); }
			}

			//insertYn == 'Y'일시 저장버튼을 부활한다. (단 save시에 별도의 체크로직으로 update 권한이 없을때 걸러낸다)
			if (menuCd.indexOf(roleList[idx].menuCd) > -1 && roleList[idx].insertYn == 'Y') {
				if (idNm.indexOf('save') > -1) { btn$.eq(jdx).show(); }
			}
		}
	}
}
