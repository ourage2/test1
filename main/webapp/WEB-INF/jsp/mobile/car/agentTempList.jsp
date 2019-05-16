<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script type="text/javascript" src="<c:url value="/resources/js/highchart/highcharts.js"/>"></script>
<script type="text/javascript" src="<c:url value="/resources/js/highchart/module/boost.js"/>"></script>
<script type="text/javascript" src="<c:url value="/resources/js/highchart/module/broken-axis.js"/>"></script>
<script>

var chart1;
var vMain;
var srch$;

jQuery(function($) {

	srch$ = com.toBox($('#divSrch'));

	vMain = new Vue({
		el: '#main',
		data: {
			last: {}
		}
	});

	//검색
	$('#srchBtn').on('click', function() {
		if (!com.validChk(srch$)) return false;
		user.tempList();
	});

	user.mainInit();
});

var user = {
	mainInit: function () {

		com.setCombo('select', srch$, 'srchCarId', null, 'car.cdCarList');

		var maxDate = onm.addDate(new Date(), -1);
		srch$.find('input[name=srchDt]')
			.datepicker('option', 'maxDate', maxDate)
			.val(onm.formatDate(maxDate));

		var series = user.makeSeriesData(null);
		user.chart1(series);
	},

	tempList: function () {
		onm.ajax({
			url: _contextPath_ + '/mobile/car/agentTempList.json',
			data: com.getData(srch$),
			success: function (res) {
				vMain.setData(res.list, 'list');
				if ($.type(res.list) === 'array' && res.list.length > 0) {
					vMain.setData(res.list[res.list.length - 1], 'last');
				}
				var series = user.makeSeriesData(res.list);
				user.chart1(series);
			}
		});
	},

	makeSeriesData: function (list) {

		var chCnt = vMain.last.chCnt || 1;
		var arr = ['ch1', 'ch2', 'ch3', 'ch4'];
		arr.splice(chCnt);

		var series = $.map(arr, function (item) {
			return {
				gapSize: 1,
				name: item,
				data: []
			}
		});

		var i, j, row, devDt, propNm;
		if ($.type(list) === 'array' && list.length > 0) {
			for (i = 0; i < list.length; i++) {
				row = list[i];
				devDt = new Date(row.devDt);
				devDt.setSeconds(0, 0);
				for (j = 0; j < arr.length; j++) {
					propNm = arr[j];
					var v = row[propNm] !== null ? Number(row[propNm]) : null;
					series[j].data.push([devDt.getTime(), v]);
				}
			}
		} else {
			var nowDt = new Date();
			nowDt.setSeconds(0, 0);

			var baseDt = new Date();
			baseDt.setHours(0, 0, 0, 0);

			series[0].data.push([baseDt.getTime(), null]);
			series[0].data.push([nowDt.getTime(), null]);
		}

		return series;
	},

	chart1: function (series) {

		var opt = {
			chart: {
				marginTop: 5,
				pinchType: 'x'
			},
			xAxis: {
				type: 'datetime',
				tickWidth: 0,
				gridLineWidth: 1,
				tickInterval: 60 * 1000,
				labels: {
					format: '{value:%k:%M}',
					align: 'center'
				}
			},
			yAxis: {
				tickInterval: 1
			},
			tooltip: {
				shared: true,
				crosshairs: true,
				valueSuffix: String.fromCharCode(8451)
			},
			legend: {
				enabled: false
			},
			plotOptions: {
				series: {
					lineWidth: 2,
					marker: {
						enabled: false
					},
					states: {
						hover: {
							enabled: false
						}
					}
				}
			},
			series: series
		};

		chart1 = Highcharts.chart('chart1', opt);
	}
}
</script>

<header>
	<div class="title_area">
		<a href="javascript:history.back()" class="layout_back" alt="이전으로"></a>
		<h2>차량 온도</h2>
	</div>
	<div id="divSrch">
		<%--<button class="m_srch_toggle on">조회설정<span class="sr_off"><span class="blind">열기</span></span><span class="sr_on"><span class="blind">닫기</span></span></button>--%>
		<div class="srch_box" style="display: block">
			<table>
				<colgroup>
					<col style="width: 25%;">
					<col style="width: 75%;">
				</colgroup>
				<tr>
					<th class="state-required">차량</th>
					<td>
						<select name="srchCarId"></select>
					</td>
				</tr>
				<tr>
					<th class="state-required">조회일</th>
					<td>
						<input type="text" name="srchDt" class="calendar" readonly/>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<button type="button" id="srchBtn" class="btn_srch m_srch "><span class="ico_srch"></span>검색</button>
					</td>
				</tr>
			</table>
		</div>
	</div>
</header>

<div id="main" class="main_wrap">
	<h2 class="t_center">현재 차량 온도</h2>
	<table class="m_table">
		<colgroup>
			<col width="25%">
			<col width="*">
			<col width="*">
			<col width="*">
			<col width="*">
			<col width="*">
		</colgroup>
		<tr>
			<th>최종수신시간</th>
			<th>CH1</th>
			<th>CH2</th>
			<th>CH3</th>
			<th>CH4</th>
			<th>비고</th>
		</tr>
		<tr>
			<td>{{ getHms(last.devDt) }}</td>
			<td>{{ last.chCnt > 0 ? last.ch1 : "" }}</td>
			<td>{{ last.chCnt > 1 ? last.ch2 : "" }}</td>
			<td>{{ last.chCnt > 2 ? last.ch3 : "" }}</td>
			<td>{{ last.chCnt > 3 ? last.ch4 : "" }}</td>
			<td></td>
		</tr>
	</table>

	<div id="chart1" class="w100" style="height: 250px;"></div>

	<table class="m_list">
		<colgroup>
			<col style="width: 12%">
			<col style="width: 25%">
			<col style="width: 35%">
			<col style="width: auto;">
		</colgroup>
		<tr>
			<th>No</th>
			<th>시간</th>
			<th>온도</th>
			<th>Event</th>
		</tr>
		<template v-if="list.length > 0">
			<template v-for="item in list">
				<tr>
					<td>{{ item.rnum }}</td>
					<td>{{ getHms(item.devDt) }}</td>
					<td>{{ item.ch }}</td>
					<td>{{ item.event }}</td>
				</tr>
			</template>
		</template>
		<template v-else>
			<tr><td colspan="4">{{ emptyList }}</td></tr>
		</template>
	</table>
</div>