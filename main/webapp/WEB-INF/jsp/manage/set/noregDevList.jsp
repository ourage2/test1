<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script>
var grid1$;
var grid2$;
var srch$;

jQuery(function($) {
	srch$ = com.toBox($('#divSrch'));

	grid1$ = $('#grid1').jqGrid({
		url: _contextPath_ + '/manage/set/noregDevList.json',
		pager:'#grid1Pg',
		height: 450,
		postData: com.getData(srch$),
		colNames: ['순번', '일련번호', '서버수신시간', '단말기수신시간', '단말기ID', '차량번호', '시동ON/OFF', '위도', '경도', '운행거리', '속도', 'CH1', 'CH2', 'CH3', 'CH4'],
		colModel: [
			{name:'rnum', index:'rnum', width:4, align:'right', sortable:false},
			{name:'seq', index:'SEQ', key: true, hidden:true},
			{name:'insertDt', index:'INSERT_DT', width: 14, formatter:'datetime'},
			{name:'devDt', index:'DEV_DT', width: 14, formatter:'datetime'},
			{name:'carTid', index:'CAR_TID', width: 8, formatter:'tel'},
			{name:'carNo', index:'CAR_NO', width: 8},
			{name:'turnYnNm', index:'TURN_YN', width: 7, sortable:false},
			{name:'xpos', index:'XPOS', width: 7, sortable:false},
			{name:'ypos', index:'YPOS', width: 7, sortable:false},
			{name:'dayTotDis', index:'DAY_TOT_DIS', width: 6, sortable:false},
			{name:'spd', index:'SPD', width: 5, sortable:false},
			{name:'ch1', index:'CH1', width: 5, sortable:false},
			{name:'ch2', index:'CH2', width: 5, sortable:false},
			{name:'ch3', index:'CH3', width: 5, sortable:false},
			{name:'ch4', index:'CH4', width: 5, sortable:false},
// 			{name:'tempYnNm', index:'TEMP_YN', width: 7, sortable:false},
		],
	});

	$('#btnNoregCar').on('click', function() {user.noregCarPop();}); //미등록차량목록 팝업

	$('select[name=pageUnit]').on('change', function () {
		$('#srchBtn').trigger('click');
	});

	//엑셀다운로드
	$('#btnGrid1Xls').on('click', function() {
		cvo.ajaxFileDown({url: _contextPath_ + '/manage/set/noregDevList.xls', data: com.getData(srch$)});
	});

	//검색
	$('#srchBtn').on('click', function() {
		grid1$.setGridParam({postData: com.getData(srch$, $('select[name=pageUnit]').val()), page: 1}).trigger('reloadGrid');
	});

	user.init();
});

var user = {
	//페이지 초기화
	init : function() {
		//검색조건 기본값 설정
		srch$.find('[name=srchStrDt]').val(onm.getBeforeMonth());
		srch$.find('[name=srchEndDt]').val(onm.todayFmt());

		com.setCombo('select', $('#main'), 'pageUnit', '${paramBox.pageUnit}', com.getCdList('PAGE_UNIT'), null, 60);
		$('#srchBtn').trigger('click');
	},

	//미등록차량목록 팝업
	noregCarPop: function() {
		onm.ajaxModal({
			url: _contextPath_ + '/manage/set/noregCarList.pop',
			dialogOptions: { title: '미등록차량목록'},
			data: {
				data : JSON.stringify(com.getData(srch$))
			},
		});
	}

}
</script>


<header>
	<div id="divSrch">
		<div class="loc_info"><span>미등록단말기 내역</span><span>환경설정</span><span>Home</span></div>
		<h2 class="content_title"><span>미등록단말기 내역</span></h2>
		<div class="srch_box">
			<table>
				<colgroup>
					<col width="10%">
					<col width="20%">
					<col width="10%">
					<col width="17%">
					<col width="10%">
					<col width="17%">
					<col width="*">
				</colgroup>
				<tr>
					<th>조회기간</th>
					<td>
						<input type="text" name="srchStrDt" class="calendar" mindateid="srchEndDt" /> ~ <input type="text" name="srchEndDt" class="calendar" maxdateid="srchStrDt" />
					</td>

					<th>단말기ID</th>
					<td>
						<input type="text" name="srchCarTid" maxlength="20" class="enterSrch" />
					</td>
					<th>차량번호</th>
					<td>
						<input type="text" name="srchCarNo" maxlength="20" class="enterSrch" />
					</td>
					<td>
						<div class="srch_btn">
							<button type="button" id="srchBtn" class="btn_srch "><span class="ico_srch"></span>검색</button>
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
			<span class="buttonset fr">

				<select name="pageUnit"></select>
				<button type="button" id="btnNoregCar" class="btn_list"><span class="ico_srch" title="미등록차량목록"></span>미등록차량목록</button>
				<button type="button" id="btnGrid1Xls" class="btn_list" ><span class="ico_xls ico_only"></span></button>
			</span>
		</div>
		<table id="grid1"></table>
		<div id="grid1Pg"></div>
	</div>
</div>