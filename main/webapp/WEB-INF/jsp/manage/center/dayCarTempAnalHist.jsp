<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script>
jQuery(function($) {

	popupView1$ = com.toBox($('#popupDivView1'));

	popupGrid1$ = $('#popupGrid1').jqGrid({
		url: _contextPath_ + '/manage/center/dayCarTempAnalHist.json',
		height: 240,
		colNames:[
			'순번', '보고시간', '주소', '속도', 'CH1',
			'CH2', '온도상태', '온도위반(기준)', '온도상태', '온도위반(HACCP)',
			'Event내역', 'zoneType','agentNm', 'delayYn'
		],
		cmTemplate: {
			align:'center',
			sortable:false
		},
		colModel:[
			{name:'rnum', index:'rnum', width:3, align:'right'},
			{name:'devTm', index:'DEV_TM', width:6},
			{name:'jibunAddr', index:'JIBUN_ADDR', width:19, align:'left'},
			{name:'spd', index:'SPD', width:5},
			{name:'ch1', index:'CH1', width:4, formatter:'number'},

			{name:'ch2', index:'CH2', width:4, formatter:'number'},
			{name:'maeilTempStat1', index:'MAEIL_TEMP_STAT1', width:7},
			{name:'maeilTempStat2', index:'MAEIL_TEMP_STAT2', width:7},
			{name:'haccpTempStat1', index:'HACCP_TEMP_STAT1', width:7},
			{name:'haccpTempStat2', index:'HACCP_TEMP_STAT2', width:7},

			{name:'event', index:'EVENT', width:7},
			{name:'zoneType', index:'ZONE_TYPE', hidden:true},
			{name:'agentNm', index:'AGENT_NM', hidden:true},
			{name:'delayYn', index:'DELAY_YN', hidden:true}
		]
	});

	$('#chartBtnDayCarTempAnalHist').on('click', function () {
		if ($.type(popupGrid1$.getGridData()) !== 'array' || popupGrid1$.getGridData().length === 0) {
			onm.alert('그래프에 표출 할 데이터가 없습니다.');
			return false;
		}

		onm.ajaxModal({
			url: _contextPath_ + '/manage/center/dayCargoTempAnalChartView.pop',
			dialogOptions: {
				title: '채널별 온도 현황',
				width: 1100,
				height: 500,
				open: function (event, ui) {
					var popup$ = $(this);
					popup$.css('overflow', 'hidden');
					popup$.find('.caption-pnl').toggleClass('hidden');
					var chartData = user.popupMakeSeriesData();
					user.popupInitChart(chartData);
				}
			}
		});
	});

	$('#xlsBtnDayCarTempAnalHist').on('click', function () {
		var rowData = grid2$.getSelGridData()[0];
		cvo.ajaxFileDown({url: _contextPath_ + '/manage/center/dayCarTempAnalHist.xls', data: rowData});
	});

	user.popupInit();
});

</script>

<div class="popup-content" style="width:1200px;">
	<div class="colgroup-wrap">
		<div id="popupDivView1">
			<div class="caption-pnl">
				<h2><span class="x-icon"></span><span class="x-label">온도 준수율 상세정보</span></h2>
				<span class="buttonset fr">
					* 운행 상태가 정상 운행이 아닌 경우 업무 Event 는 등록이 되지 않습니다.
				</span>
			</div>

			<table class="dtl_tbl">
				<colgroup>
					<col width="7%">
					<col width="17%">

					<col width="7%">
					<col width="17%">

					<col width="7%">
					<col width="17%">

					<col width="7%">
					<col width="17%">
				</colgroup>
				<tbody>
					<tr>
						<th>조회일자</th>
						<td><input type="text" name="stdDate" read/></td>

						<th>소속센터</th>
						<td><input type="text" name="centerNm" read/></td>

						<th>소속운송사</th>
						<td><input type="text" name="companyNm" read/></td>

						<th>차량번호</th>
						<td><input type="text" name="carNo" read/></td>
					</tr>
					<tr>
						<th>운전자명</th>
						<td><input type="text" name="drvNm" read/></td>

						<th>전화번호</th>
						<td><input type="text" name="drvTelNo" read/></td>

						<th>핸드폰</th>
						<td><input type="text" name="drvHpNo" read/></td>

						<th>운행상태</th>
						<td><input type="text" name="restNm" read/></td>
					</tr>
					<tr>
						<th colspan="2">온도 준수율 (0℃ ~ 5℃)</th>
						<th>전체 온도 건수</th>
						<td><input type="text" name="tempTotCnt2" read/></td>

						<th>위반 온도 건수</th>
						<td><input type="text" name="tempVioLongCnt" read/></td>

						<th>온도 준수율</th>
						<td><input type="text" name="tempNorRt" read/></td>
					</tr>
					<tr>
						<th colspan="2">온도 준수율 (0℃ ~ 10℃)</th>
						<th>전체 온도 건수</th>
						<td><input type="text" name="tempTotCnt1" read/></td>

						<th>위반 온도 건수</th>
						<td><input type="text" name="tempHaccpVioLongCnt" read/></td>

						<th>온도 준수율</th>
						<td><input type="text" name="tempHaccpNorRt" read/></td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>

	<div class="colgroup-wrap mT20">
		<div class="caption-pnl">
			<span class="buttonset fr">
				<button type="button" id="chartBtnDayCarTempAnalHist" class="btn_srch" ><span class="ico_srch"></span>그래프</button>
				<button type="button" id="xlsBtnDayCarTempAnalHist" class="btn_list" ><span class="ico_xls ico_only"></span></button>
			</span>
		</div>
		<table id="popupGrid1"></table>
	</div>
</div>