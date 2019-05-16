<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script>
jQuery(function($) {

	popupView1$ = com.toBox($('#popupDivView1'));

	popupGrid1$ = $('#popupGrid1').jqGrid({
		url: _contextPath_ + '/manage/center/dayAgentArrAnalHist.json',
		height: 240,
		colNames:[
			'순번', '보고시간', '주소', '속도', '일누적<br>운행거리',
			'구간설정', '도착±30', 'Event내역'
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
			{name:'dayTotDis', index:'DAY_TOT_DIS', width:6},

			{name:'agentDelayStat', index:'AGENT_DELAY_STAT', width:7},
			{name:'delayStat', index:'DELAY_STAT', width:7},
			{name:'event', index:'EVENT', width:7}
		]
	});

	user.popupInit();
});

</script>

<div class="popup-content" style="width:1200px;">
	<div class="colgroup-wrap">
		<div id="popupDivView1">
			<div class="caption-pnl">
				<h2><span class="x-icon"></span><span class="x-label">대리점 정시 도착 준수율 상세정보</span></h2>
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
						<th colspan="2">도착시간 ±30분 반영</th>
						<th>정시도착</th>
						<td><input type="text" name="arrNorCnt" read/></td>

						<th>위반도착</th>
						<td><input type="text" name="arrVioCnt" read/></td>

						<th>정시도착률</th>
						<td><input type="text" name="arrNorRt" read/></td>
					</tr>
					<tr>
						<th colspan="2">도착시간 구간 설정 반영</th>
						<th>정시도착</th>
						<td><input type="text" name="arrAgentNorCnt" read/></td>

						<th>위반도착</th>
						<td><input type="text" name="arrAgentVioCnt" read/></td>

						<th>정시도착률</th>
						<td><input type="text" name="arrAgentNorRt" read/></td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>

	<div class="colgroup-wrap mT20">
		<table id="popupGrid1"></table>
	</div>
</div>