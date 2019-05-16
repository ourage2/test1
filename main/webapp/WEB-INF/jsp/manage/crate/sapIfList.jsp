<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script>
var grid1$;
var srch$;

jQuery(function($) {
	srch$ = com.toBox($('#divSrch'));

	grid1$ = $('#grid1').jqGrid({
		url: _contextPath_ + '/manage/crate/sapIfList.json',
		pager:'#grid1Pg',
		height: 480,
		postData: com.getData(srch$),
		colNames:[
			'순번', '센터명', '고유번호', '선적번호', '납품번호', 
			'송수신구분', '인터페이스구분', '전송결과', '전송메시지', '인터페이스일자'
		],
		cmTemplate: {
			align:'center'
		},
		colModel:[
			{name:'rnum', index:'rnum', width:3, align:'right', sortable:false},
			{name:'centerNm', index:'CENTER_NM', width:10},
			{name:'ifSeq', index:'IF_SEQ', width:10, key: true},
			{name:'shipNo', index:'SHIP_NO', width:10},
			{name:'deliNo', index:'DELI_NO', width:10},
			{name:'sendDiv', index:'SEND_DIV', width:8},
			{name:'ifDivNm', index:'CD_NM', width:9},
			{name:'succYn', index:'SUCC_YN', width:7},
			{name:'errMsg', index:'ERR_MSG', width:10},
			{name:'ifDt', index:'A.INSERT_DT', width:11}
		]
	});

	$('select[name=srchSendDiv]').on('change', function () {

		var obj;
		if ($(this).val()) {
			obj = com.getCdList('SAP_IF_DIV', {etc1: $(this).val()});
		} else {
			obj = com.getCdList('SAP_IF_DIV');
		}

		com.setCombo('select', srch$, 'srchIfDivCd', '', obj, '전체');
	});

	//검색
	$('#srchBtn').on('click', function() {
		grid1$.setGridParam({postData: com.getData(srch$)}).trigger('reloadGrid');
	});

	//엑셀다운로드
	$('#xlsBtn').on('click', function() {
		cvo.ajaxFileDown({url: _contextPath_ + '/manage/crate/sapIfList.xls', data: com.getData(srch$)});
	});

	user.mainInit();
});

var user = {
	//메인페이지 초기화
	mainInit : function() {

		com.setCombo('select', srch$, 'srchCenterCd', '', com.sAuthCenterList());

		com.setCombo('select', srch$, 'srchIfDivCd', '', com.getCdList('SAP_IF_DIV'), '전체');

		//검색조건 기본값 설정
		srch$.find('[name=srchStrDt]').val(onm.getBeforeMonth());
		srch$.find('[name=srchEndDt]').val(onm.todayFmt());

		$('#srchBtn').trigger('click');
	}
}
</script>

<header>
	<div id="divSrch">
		<div class="loc_info"><span>SAP인터페이스 현황</span><span>크레이트 관리</span><span>Home</span></div>
		<h2 class="content_title"><span>SAP인터페이스 현황</span></h2>
		<div class="srch_box">
			<table>
				<colgroup>
					<col width="8%">
					<col width="16%">
					<col width="9%">
					<col width="20%">
					<col width="9%">
					<col width="16%">
					<col width="*">
				</colgroup>
				<tr>
					<th>센터</th>
					<td>
						<select name="srchCenterCd" class="chosen" multiple data-placeholder="전체"></select>
					</td>

					<th>선적번호</th>
					<td>
						<input type="text" name="srchShipNo" maxlength="30" class="enterSrch" />
					</td>

					<th>업/다운</th>
					<td>
						<select name="srchSendDiv">
							<option value="">전체</option>
							<option value="U">업로드</option>
							<option value="D">다운로드</option>
						</select>
					</td>

					<td>
					</td>
				</tr>

				<tr>
					<th>인터페이스</th>
					<td>
						<select name="srchIfDivCd"></select>
					</td>

					<th>조회기간</th>
					<td>
						<input type="text" name="srchStrDt" class="calendar" mindateid="srchEndDt" /> ~ <input type="text" name="srchEndDt" class="calendar" maxdateid="srchStrDt" />
					</td>

					<th>전송결과</th>
					<td>
						<select name="srchSuccYn">
							<option value="">전체</option>
							<option value="Y">성공</option>
							<option value="N">실패</option>
						</select>
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
				<button type="button" id="xlsBtn" class="btn_list" ><span class="ico_xls ico_only"></span></button>
			</span>
		</div>
		<table id="grid1"></table>
		<div id="grid1Pg"></div>
	</div>
</div>