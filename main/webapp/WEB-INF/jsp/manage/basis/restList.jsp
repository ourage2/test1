<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script>
var srch$;
var grid1$;
var grid2$;
// var firstWeek;

jQuery(function($) {
	srch$ = com.toBox($('#divSrch'));

	grid1$ = $('#grid1').jqGrid({
		url: _contextPath_ + '/manage/basis/restList.json',
		pager: '#grid1Pg',
		height: 480,
		postData: com.getData(srch$),
		shrinkToFit: false,
		colNames: [
			'순번', '센터명', '차량ID', '차량번호', '운전자', '휴무일수', 'stdYm',
			'1일', '2일', '3일', '4일', '5일', '6일', '7일', '8일', '9일', '10일',
			'11일', '12일', '13일', '14일', '15일', '16일', '17일', '18일', '19일', '20일',
			'21일', '22일', '23일', '24일', '25일', '26일', '27일', '28일', '29일', '30일', '31일'
		],
		colModel: [
			{name:'rnum', index:'rnum', width:30, align:'right', sortable:false},
			{name:'centerNm', index:'CENTER_NM', width: 100, sortable:false},
			{name:'carId', index:'CAR_ID', width: 50, sortable:false, key: true},
			{name:'carNo', index:'CAR_NO', width: 80, sortable:false},
			{name:'drvNm', index:'DRV_NM', width: 50, sortable:false},
			{name:'restCnt', index:'REST_CNT', width: 60, align:'right', sortable:false},
			{name:'stdYm', index:'STD_YM', hidden: true},

			{name:'day1', index:'DAY1', width: 40, align:'center', formatter: 'restCd', cellattr:user.fnCustom, sortable:false},
			{name:'day2', index:'DAY2', width: 40, align:'center', formatter: 'restCd', cellattr:user.fnCustom, sortable:false},
			{name:'day3', index:'DAY3', width: 40, align:'center', formatter: 'restCd', cellattr:user.fnCustom, sortable:false},
			{name:'day4', index:'DAY4', width: 40, align:'center', formatter: 'restCd', cellattr:user.fnCustom, sortable:false},
			{name:'day5', index:'DAY5', width: 40, align:'center', formatter: 'restCd', cellattr:user.fnCustom, sortable:false},
			{name:'day6', index:'DAY6', width: 40, align:'center', formatter: 'restCd', cellattr:user.fnCustom, sortable:false},
			{name:'day7', index:'DAY7', width: 40, align:'center', formatter: 'restCd', cellattr:user.fnCustom, sortable:false},
			{name:'day8', index:'DAY8', width: 40, align:'center', formatter: 'restCd', cellattr:user.fnCustom, sortable:false},
			{name:'day9', index:'DAY9', width: 40, align:'center', formatter: 'restCd', cellattr:user.fnCustom, sortable:false},
			{name:'day10', index:'DAY10', width: 40, align:'center', formatter: 'restCd', cellattr:user.fnCustom, sortable:false},
			{name:'day11', index:'DAY11', width: 40, align:'center', formatter: 'restCd', cellattr:user.fnCustom, sortable:false},
			{name:'day12', index:'DAY12', width: 40, align:'center', formatter: 'restCd', cellattr:user.fnCustom, sortable:false},
			{name:'day13', index:'DAY13', width: 40, align:'center', formatter: 'restCd', cellattr:user.fnCustom, sortable:false},
			{name:'day14', index:'DAY14', width: 40, align:'center', formatter: 'restCd', cellattr:user.fnCustom, sortable:false},
			{name:'day15', index:'DAY15', width: 40, align:'center', formatter: 'restCd', cellattr:user.fnCustom, sortable:false},
			{name:'day16', index:'DAY16', width: 40, align:'center', formatter: 'restCd', cellattr:user.fnCustom, sortable:false},
			{name:'day17', index:'DAY17', width: 40, align:'center', formatter: 'restCd', cellattr:user.fnCustom, sortable:false},
			{name:'day18', index:'DAY18', width: 40, align:'center', formatter: 'restCd', cellattr:user.fnCustom, sortable:false},
			{name:'day19', index:'DAY19', width: 40, align:'center', formatter: 'restCd', cellattr:user.fnCustom, sortable:false},
			{name:'day20', index:'DAY20', width: 40, align:'center', formatter: 'restCd', cellattr:user.fnCustom, sortable:false},
			{name:'day21', index:'DAY21', width: 40, align:'center', formatter: 'restCd', cellattr:user.fnCustom, sortable:false},
			{name:'day22', index:'DAY22', width: 40, align:'center', formatter: 'restCd', cellattr:user.fnCustom, sortable:false},
			{name:'day23', index:'DAY23', width: 40, align:'center', formatter: 'restCd', cellattr:user.fnCustom, sortable:false},
			{name:'day24', index:'DAY24', width: 40, align:'center', formatter: 'restCd', cellattr:user.fnCustom, sortable:false},
			{name:'day25', index:'DAY25', width: 40, align:'center', formatter: 'restCd', cellattr:user.fnCustom, sortable:false},
			{name:'day26', index:'DAY26', width: 40, align:'center', formatter: 'restCd', cellattr:user.fnCustom, sortable:false},
			{name:'day27', index:'DAY27', width: 40, align:'center', formatter: 'restCd', cellattr:user.fnCustom, sortable:false},
			{name:'day28', index:'DAY28', width: 40, align:'center', formatter: 'restCd', cellattr:user.fnCustom, sortable:false},
			{name:'day29', index:'DAY29', width: 40, align:'center', formatter: 'restCd', cellattr:user.fnCustom, sortable:false},
			{name:'day30', index:'DAY30', width: 40, align:'center', formatter: 'restCd', cellattr:user.fnCustom, sortable:false},
			{name:'day31', index:'DAY31', width: 40, align:'center', formatter: 'restCd', cellattr:user.fnCustom, sortable:false}
		],
	});

	$('#btnGrid1Pop').on('click', function() {user.restBatchPop();}); //차량휴무 일괄설정 팝업
	//엑셀다운로드
	$('#btnGrid1Xls').on('click', function() {
		var data = com.getData(srch$);
		data.title = '차량휴무_기준년월' + data.srchStdYm;
		cvo.ajaxFileDown({url: _contextPath_ + '/manage/basis/restList.xls', data: data});
	});

	//검색
	$('#srchBtn').on('click', function() {
		var lastDay = naw.getLastDayOfMonth(srch$.find('[name=srchStdYm]').val().substring(0, 4), srch$.find('[name=srchStdYm]').val().substring(5, 7));
		lastDay = lastDay.substring(lastDay.length - 2, lastDay.length);
// 		firstWeek = new Date(srch$.find('[name=srchStdYm]').val() + '-01').getDay();
		grid1$.showCol('day29');
		grid1$.showCol('day30');
		grid1$.showCol('day31');
		for (var idx = 31; idx > parseInt(lastDay); idx--) {
			grid1$.hideCol('day' + idx);
		}
		$('#dayMonth').text('[' + srch$.find('[name=srchStdYm]').val().substring(0, 4) + '년 ' + srch$.find('[name=srchStdYm]').val().substring(5, 7) + '월]');
		grid1$.setGridParam({postData: com.getData(srch$)}).trigger('reloadGrid');
	});

	user.init();
});

var user = {
	//페이지 초기화
	init : function() {
		com.setCombo('select', srch$, 'srchCenterCd', '', com.sAuthCenterList());
		srch$.find('[name=srchStdYm]').val(naw.getToday('yyyy-MM'));

// 		$('#srchBtn').trigger('click');
	},

	fnCustom : function(rowId, val, rowData, cm) {
		var rtnStr = '';
		var day = ((cm.name).substring(3, cm.name.length)).length == 1 ? '0' + (cm.name).substring(3, cm.name.length) : (cm.name).substring(3, cm.name.length);
		var dayWeek = new Date(srch$.find('[name=srchStdYm]').val() + '-' + day).getDay();
		if (dayWeek == 0) {
			rtnStr = 'style="background-color:#ffe0e0;"';
		} else if (dayWeek == 6) {
			rtnStr = 'style="background-color:#a4bed4;"';
		}
		return rtnStr;
	},

	//차량휴무 일괄설정 팝업
	restBatchPop : function() {
		onm.ajaxModal({
			url: _contextPath_ + '/manage/basis/restBatch.pop',
			dialogOptions: { title: '차량휴무 일괄설정'}
		});
	}

}
</script>

<header>
	<div id="divSrch">
		<div class="loc_info"><span>차량휴무관리</span><span>기준정보</span><span>Home</span></div>
		<h2 class="content_title"><span>차량휴무관리</span></h2>
		<div class="srch_box">
			<table>
				<colgroup>
					<col width="9%">
					<col width="20%">
					<col width="9%">
					<col width="15%">
					<col width="9%">
					<col width="25%">
					<col width="*">
				</colgroup>
				<tr>
					<th>센터</th>
					<td>
						<select name="srchCenterCd" class="chosen" multiple data-placeholder="전체"></select>
					</td>
					<th>조회년월</th>
					<td>
						<input type="text" name="srchStdYm" class="monthPicker" />
					</td>
<!-- 					<th>사용여부</th> -->
<!-- 					<td> -->
<!-- 						<select name="srchUseYn"> -->
<!-- 							<option value="">전체</option> -->
<!-- 							<option value="Y" selected="selected">사용</option> -->
<!-- 							<option value="N">미사용</option> -->
<!-- 						</select> -->
<!-- 					</td> -->
					<th>검색어</th>
					<td>
						<select name="srchMethod">
							<option value="carId" selected="selected">차량고유번호</option>
<!-- 							<option value="carNo">차량번호</option> -->
<!-- 							<option value="drvNm">운전자명</option> -->
						</select>
						<input type="text" name="srchWord" maxlength="30" class="enterSrch" />
					</td>
					<td>
						<div class="srch_btn">
							<button type="button" id="srchBtn" class="btn_srch"><span class="ico_srch"></span>검색</button>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</div>
</header>

<div id="main">
	<div class="colgroup-wrap">
		<div class="caption-pnl">
			<h2>차량휴무 <span id="dayMonth"></span> <font color="blue">(N.정상운행, 1.휴차, 2.단말기고장, 3.차량수리, 4.기타)</font></h2>
			<span class="buttonset fr">
				<button type="button" id="btnGrid1Pop" class="btn_list" ><span class="ico_upload"></span>차량휴무 일괄설정</button>
				<button type="button" id="btnGrid1Xls" class="btn_list" ><span class="ico_xls ico_only"></span></button>
			</span>
		</div>
		<table id="grid1"></table>
		<div id="grid1Pg"></div>
	</div>
</div>