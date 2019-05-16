<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script type="text/javascript" src="<c:url value="/resources/js/highchart/highcharts.js"/>"></script>
<script>

var chart1$;
var chart2$;
var chart3$;
var chart4$;
var chart5$;
var targetChart;

var centerCarTempList;
var centerCarTempIndex = 0;

var centerCargoTempList;
var centerCargoTempIndex = 0;


jQuery(function($) {

	$('#btnToggleDashboard').on('click', function () {
		var status = $(this).attr('status');

		var divCenter$ = $('#divCenter');
		var divAgent$ = $('#divAgent');

		if ('C' === status) {
			divCenter$.addClass('hidden');
			divAgent$.removeClass('hidden');
			$(this).attr('status', 'A').text('센터 Dashboard');
		} else {
			divCenter$.removeClass('hidden');
			divAgent$.addClass('hidden');
			$(this).attr('status', 'C').text('대리점 Dashboard');
		}
	});

	$('#dtlBtn1,#dtlBtn2,#dtlBtn3,#dtlBtn4,#dtlBtn5').on('click', function () {

		var that = this;

		switch (this.id) {
			case 'dtlBtn1':
				targetChart = chart1$;
				break;
			case 'dtlBtn2':
				targetChart = chart2$;
				break;
			case 'dtlBtn3':
				targetChart = chart3$;
				break;
			case 'dtlBtn4':
				targetChart = chart4$;
				break;
			case 'dtlBtn5':
				targetChart = chart5$;
				break;
			default:
				return false;
		}

		var title = $(that).closest('h2').text();

		onm.ajaxModal({
			url: _contextPath_ + '/manage/dash/chartView.pop',
			dialogOptions: {
				title: title,
				width: 740,
				height: 500,
				open: function () {
					var popupChart = Highcharts.chart('popupChart', targetChart.userOptions);
					popupChart.setSize(700, 420, false);
					if (targetChart === chart1$)
						user.toggleChart1Series(popupChart);
				}
			}
		});
	});

	//센터별 온도 준수율 이전- 차량
	$('#prevCenterCarTemp').on('click', function () {
		--centerCarTempIndex;
		if (centerCarTempIndex < 0) {
			centerCarTempIndex = centerCarTempList.length - 1;
		}
		user.centerCarTemp(centerCarTempList);
	});

	//센터별 온도 준수율 다음- 차량
	$('#nextCenterCarTemp').on('click', function () {
		++centerCarTempIndex;
		if (centerCarTempIndex >= centerCarTempList.length) {
			centerCarTempIndex = 0;
		}
		user.centerCarTemp(centerCarTempList);
	});

	//센터별 온도 준수율 이전- 창고
	$('#prevCenterCargoTemp').on('click', function () {
		--centerCargoTempIndex;
		if (centerCargoTempIndex < 0) {
			centerCargoTempIndex = centerCargoTempList.length - 1;
		}
		user.centerCargoTemp(centerCargoTempList);
	});

	//센터별 온도 준수율 다음- 창고
	$('#nextCenterCargoTemp').on('click', function () {
		++centerCargoTempIndex;
		if (centerCargoTempIndex >= centerCargoTempList.length) {
			centerCargoTempIndex = 0;
		}
		user.centerCargoTemp(centerCargoTempList);
	});

	user.init();
});


var user = {
	//페이지 초기화
	init : function() {

		user.chartSetOption();
		user.loadData();

		// user.initAgentChart1();
	},

	loadData: function() {
		onm.ajax({
			url: _contextPath_ + '/manage/dash/centerList.json',
			success: function (res) {
				if (res.hasOwnProperty('centerCntRt')) {

					var data = res.centerCntRt;
					var keys = ['totCarCnt', 'totCargoCnt', 'drvCarCnt', 'restCnt', 'repairCnt', 'rentCnt', 'etcCarCnt', 'devBknCnt',
						'carTempNorRt', 'cargoTempNorRt', 'deliPlanCnt', 'deliCompCnt',
						'deliIncompCnt', 'yesterdayArrNorRt', 'todayArrNorRt'];
					var key;
					for(var i=0; i<keys.length; i++) {
						key = keys[i];
						var val = onm.nvl(data[key], '0');
						val = key.endsWith('Cnt') ? onm.formatAmount(val) : val;
						$('#' + key).text(val);
					}
				}

				centerCarTempList = res.centerCarTempList;
				user.centerCarTemp();

				centerCargoTempList = res.centerCargoTempList;
				user.centerCargoTemp();

				user.initChart1(res.dayCarTempList, res.dayCenterTempList);
				user.initChart2(res.cargoTempList);
				user.initChart3(res.deliTranList);
				user.initChart5(res.deliTranList);
				user.initChart4(res.arrNorRtList);
			}
		});
	},

	makeSeries: function(list, config, option) {

		var indexKey = config.indexKey;
		var nameKey = config.nameKey;
		var xKey = config.xKey;
		var yKey = config.yKey;

		var idxArr = [];
		var dataArr = [];

		if ($.type(list) === 'array' && list.length > 0) {

			$.each(list, function (index, item) {

				var idx = idxArr.indexOf(item[indexKey]);
				var centerObj;
				if (idx === -1) {
					centerObj = {
						name: nameKey ? item[nameKey] : '',
						data: []
					};

					if ($.type(option) === 'object') {
						$.extend(true, centerObj, option);
					}

					idxArr.push(item[indexKey]);
					dataArr.push(centerObj);
				} else {
					centerObj = dataArr[idx];
				}

				centerObj.data.push([item[xKey], item[yKey]]);
			});
		}
		return dataArr;
	},

	chartSetOption: function() {

		//	차트 그래프 색상
		["#7cb5ec", "#434348", "#90ed7d", "#f7a35c", "#8085e9", "#f15c80", "#e4d354", "#2b908f", "#f45b5b", "#91e8e1"];

		Highcharts.setOptions({
			chart: {
			// 	spacing: [5, 5, 5, 5],
			// 	marginTop: 0,
        	// 	marginBottom: 50
				width: 304,
				height: 212
			},
			legend: {
				itemStyle:{
					fontSize:'9px'
				}
			}
		});
	},

	toggleChart1Series: function(popupChart) {
		var list = popupChart.series;
		$.each(list, function (index, item) {

			if (index === list.length - 1) {
			} else {
				var flag = item.visible;
				item.update({
					visible: !flag,
					showInLegend: !flag
				});
			}
		});
	},

	centerCarTemp: function () {
		if ($.type(centerCarTempList) !== 'array' || centerCarTempList.length === 0) {
			return false;
		}
		var item = centerCarTempList[centerCarTempIndex];
		var html = '<h3>' + item.centerNm + '</h3><span>' + item.carTempNorRt + '</span><em>%</em>';
		$('#centerCarTempDiv').html(html);
	},

	centerCargoTemp: function () {
		if ($.type(centerCargoTempList) !== 'array' || centerCargoTempList.length === 0) {
			return false;
		}
		var item = centerCargoTempList[centerCargoTempIndex];
		var html = '<h3>' + item.centerNm + '</h3><span>' + item.cargoTempNorRt + '</span><em>%</em>';
		$('#centerCargoTempDiv').html(html);
	},

	initChart1: function(dayCarTempList, dayCenterTempList) {

		var series = [];

		var dayCarTemp = {
			color: '#7cb5ec',
			name: '온도준수율',
			data: []
		};

		series.push(dayCarTemp);

		if ($.type(dayCarTempList) === 'array' && dayCarTempList.length > 0) {
			$.each(dayCarTempList, function (idx, item) {
				dayCarTemp.data.push([item.stdDt, item.tempNorRt]);
			});
		}

		var config = {indexKey: 'centerCd', nameKey: 'centerNm', xKey: 'stdDt', yKey: 'tempNorRt'};
		var seriesOpt = {visible: false, showInLegend: false};
		series = series.concat(user.makeSeries(dayCenterTempList, config, seriesOpt));

		var plotLineOpt1 = {
			id: 'plotLineOpt1',
			value: 95,
			color: '#ff0000',
			dashStyle: 'shortdash',
			width: 2
		};

		series.push({
			color: '#FF0000',
			name: '기준',
			dashStyle: 'shortdash',
			marker: {
				enabled: false
			},
			events: {
				legendItemClick: function () {
					if (this.visible) {
						this.chart.yAxis[0].removePlotLine(plotLineOpt1.id);
					}
					else {
						this.chart.yAxis[0].addPlotLine(plotLineOpt1);
					}
				}
			}
		});

		var opt = {
			chart: {
				marginTop: 5
			},
			xAxis: {
				type: 'datetime',
				tickWidth: 0,
				gridLineWidth: 1,
				tickInterval: 24 * 3600 * 1000,
				labels: {
					format: '{value:%b/%e}',
					align: 'center'
				}
			},
			yAxis: {
				max: 100,
				tickInterval: 10,
				plotLines: [plotLineOpt1]
			},
			tooltip: {
				shared: true,
				crosshairs: true,
				valueSuffix: '%'
			},
			legend: {
				align: 'center',
				verticalAlign: 'bottom',
				layout: 'horizontal'
			},
			plotOptions: {
				series: {
					label: {
						connectorAllowed: false
					}
				}
			},
			series: series
		};

		chart1$ = Highcharts.chart('chart1', opt);

	},

	initChart2: function(cargoTempList) {

		var series = [];
		var config = {indexKey: 'daysAgo', nameKey: 'daysAgoNm', xKey: 'centerNm', yKey: 'rt'};
		series = series.concat(user.makeSeries(cargoTempList, config));

		var opt = {
			chart: {
				type: 'column'
			},
			xAxis: {
				type: "category"
			},
			tooltip: {
				shared: true,
				crosshairs: true,
				valueSuffix: '%'
			},
			legend: {
				align: 'center',
				verticalAlign: 'bottom',
				layout: 'horizontal'
			},
			plotOptions: {
				series: {
					label: {
						connectorAllowed: false
					}
				}
			},
			series: series,

			responsive: {
				rules: [{
					condition: {
						maxWidth: 400
					},
					chartOptions: {
						legend: {
							enabled: false
						}
					}
				}]
			}
		};
		chart2$ = Highcharts.chart('chart2', opt);
	},

	initChart3: function(deliTranList) {

		var compData = [];
		var incompData = [];

		if ($.type(deliTranList) === 'array' && deliTranList.length > 0) {
			$.each(deliTranList, function (index, item) {
				if (item.bizCd === 'D') {
					compData.push({x: item.stdDt, y: item.deliCompCnt});
					incompData.push({x: item.stdDt, y: item.deliIncompCnt});
				}
			});
		}

		var opt = {
			chart: {
				type: 'column',
				marginTop: 5
			},
			xAxis: {
				type: 'datetime',
				tickWidth: 0,
				gridLineWidth: 1,
				labels: {
					format: '{value:%b/%e}',
					align: 'center'
				}
			},
			yAxis: {
				min: 0
			},
			tooltip: {
				shared: true,
				formatter: function () {
					var tot = 0;
					var html = '<span style="font-size: 10px">' + Highcharts.dateFormat('%Y-%b-%e %A', new Date(this.x)) + '</span><br/>';
					var html2 = '';
					this.points.forEach(function (obj) {
						html2 += '<span style="color: ' + obj.color + '">●</span> ' + obj.series.name + ': <b>' + obj.y + '건</b><br/>';
						tot += Number(obj.y);
					});
					html += '<span style="color: black">●</span> 총 배송 건수: <b>' + tot + '건</b><br/>';
					html += html2;
					return html;
				}
			},
			plotOptions: {
				column: {
					minPointLength: 3,
					stacking: 'normal'
				}
			},
			legend: {
				enabled: false
			},
			series: [{
				name: '배송 건수',
				color: '#7cb5ec',
				data: compData
			},{
				name: '미배송 건수',
				color: '#f45b5b',
				data: incompData
			}]
		};
		chart3$ = Highcharts.chart('chart3', opt);
	},

	initChart4: function (arrNorRtList) {

		var series = [];
		var config = {indexKey: 'stdDate', nameKey: 'stdDate', xKey: 'centerNm', yKey: 'arrNorRt'};
		var list = $.grep(arrNorRtList, function(item) {return item.bizCd === 'D'});
		series = series.concat(user.makeSeries(list, config));

		var opt = {
			chart: {
				type: 'column',
				marginTop: 5
			},
			tooltip: {
				shared: true,
				valueSuffix: '%'
			},
			xAxis: {
				type: "category"
			},
			yAxis: {
				min: 0,
				max: 100
			},
			plotOptions: {
				series: {
					minPointLength: 3
				}
			},
			series: series,

			responsive: {
				rules: [{
					condition: {
						maxWidth: 400
					},
					chartOptions: {
						legend: {
							enabled: false
						}
					}
				}]
			}
		};

		chart4$ = Highcharts.chart('chart4', opt);
	},

	initChart5: function (deliTranList) {

		var compData = [];
		var incompData = [];

		var cntSum = 0;
		var yAxisMax = null;

		if ($.type(deliTranList) === 'array' && deliTranList.length > 0) {
			$.each(deliTranList, function (index, item) {
				if (item.bizCd === 'T') {
					compData.push({x: item.stdDt, y: item.deliCompCnt});
					incompData.push({x: item.stdDt, y: item.deliIncompCnt});

					cntSum = Math.max(cntSum, Number(item.deliCompCnt) + Number(item.deliIncompCnt))
				}
			});
		}

		if (cntSum === 0) {
			yAxisMax = 1000;
		}

		var opt = {
			chart: {
				type: 'column',
				marginTop: 5
			},
			xAxis: {
				type: 'datetime',
				tickWidth: 0,
				gridLineWidth: 1,
				labels: {
					format: '{value:%b/%e}',
					align: 'center'
				}
			},
			yAxis: {
				min: 0,
				max: yAxisMax
			},
			tooltip: {
				shared: true,
				formatter: function () {
					var tot = 0;
					var html = '<span style="font-size: 10px">' + Highcharts.dateFormat('%Y-%b-%e %A', new Date(this.x)) + '</span><br/>';
					var html2 = '';
					this.points.forEach(function (obj) {
						html2 += '<span style="color: ' + obj.color + '">●</span> ' + obj.series.name + ': <b>' + obj.y + '건</b><br/>';
						tot += Number(obj.y);
					});
					html += '<span style="color: black">●</span> 총 수송 건수: <b>' + tot + '건</b><br/>';
					html += html2;
					return html;
				}
			},
			plotOptions: {
				column: {
					minPointLength: 3,
					stacking: 'normal'
				}
			},
			legend: {
				enabled: false
			},
			series: [{
				name: '수송 건수',
				color: '#7cb5ec',
				data: compData
			},{
				name: '미수송 건수',
				color: '#f45b5b',
				data: incompData
			}]
		};
		chart5$ = Highcharts.chart('chart5', opt);
	}
}

</script>

<header>
<h2 class="content_title_m">CVO Management Dashboard</h2>
</header>
<div id="main">
	<div id="divCenter" class="dash_wrap" >
		<div class="dash_box h_top">
			<ul class="dash_con_left ">
				<li><h2>차량수</h2><div class="dash_data"><span id="totCarCnt">0</span><em>대</em></div></li>
				<li><h2>창고수</h2><div class="dash_data"><span id="totCargoCnt">0</span><em>개</em></div></li>
			</ul>
			<ul class="dash_con_center">
				<li class="iconbg car1"><h2>운행차량</h2><div class="dash_data"><span id="drvCarCnt">0</span><em>대</em></div></li>
				<li class="iconbg car2"><h2>휴무차량</h2><div class="dash_data"><span id="restCnt">0</span><em>대</em></div></li>
				<li class="iconbg car3"><h2>사고 차량</h2><div class="dash_data"><span id="repairCnt">0</span><em>대</em></div></li>
				<li class="iconbg car4"><h2>용  차</h2><div class="dash_data"><span id="rentCnt">0</span><em>대</em></div></li>
				</ul>
			<ul class="dash_con_right">
				<li><h2>기타 미운행차량</h2><div class="dash_data"><span id="etcCarCnt">0</span><em>대</em></div></li>
				<li><h2>단말기 고장</h2><div class="dash_data"><span id="devBknCnt">0</span><em>대</em></div></li>
			</ul>
		</div>
		<div class="dash_box h_mid">
			<ul class="dash_con_left">
				<li class="car_ondo"><h2>전체 차량 온도 준수율</h2><div class="dash_data"><span id="carTempNorRt">0</span><em>%</em></div></li>
				<li>
					<h2>센터별 온도 준수율</h2>
					<div class="dash_data addbtn">
						<a href="javascript:;" class="dash_btn left" id="prevCenterCarTemp"></a>
						<div id="centerCarTempDiv" class="dash_data inner">
							<h3>-</h3>
							<span>-</span><em>%</em>
						</div>
						 <a href="javascript:;" class="dash_btn right" id="nextCenterCarTemp"></a>
					</div>
				</li>
			</ul>
			<div class="dash_con_center">
				<div class="dash_chart">
					<h2>
						일자별 차량 온도준수율
						<button type="button" id="dtlBtn1" class="btn_list_rd srch" ></button>
					</h2>
					<div id="chart1" class="chart_con"></div>
				</div>
				<div class="dash_chart">
					<h2>
						센터별 창고 준수율
						<button type="button" id="dtlBtn2" class="btn_list_rd srch" ></button>
					</h2>
					<div id="chart2" class="chart_con"></div>
				</div>
			</div>
			<ul class="dash_con_right">
				<li class="cargo"><h2>전체 창고 온도 준수율</h2><div class="dash_data"><span id="cargoTempNorRt">0</span><em>%</em></div></li>
				<li>
					<h2>센터별 온도 준수율</h2>
					<div class="dash_data addbtn">
						<a href="javascript:;" class="dash_btn left" id="prevCenterCargoTemp"></a>
						<div id="centerCargoTempDiv" class="dash_data inner">
							<h3>-</h3>
							<span>-</span><em>%</em>
						</div>
						<a href="javascript:;" class="dash_btn right" id="nextCenterCargoTemp"></a>
					</div>
				</li>
			</ul>
		</div>
		<div class="dash_box h_bot">
			<div class="dash_con_center" style="width: 986.5px; margin: 0;">
				<div class="dash_chart" style="width: 325.5px">
					<h2>
						배송 현황
						<button type="button" id="dtlBtn3" class="btn_list_rd srch" ></button>
					</h2>
					<div id="chart3" class="chart_con" ></div>
				</div>
				<div class="dash_chart" style="width: 325.5px; margin-left: 5px;">
					<h2>
						수송 현황
						<button type="button" id="dtlBtn5" class="btn_list_rd srch" ></button>
					</h2>
					<div id="chart5" class="chart_con" ></div>
				</div>
				<div class="dash_chart" style="width: 325.5px">
					<h2>
						대리점 정시도착률 현황
						<button type="button" id="dtlBtn4" class="btn_list_rd srch" ></button>
					</h2>
					<div id="chart4" class="chart_con" ></div>
				</div>
			</div>
			<ul class="dash_con_right" style="width: 209px;">
				<li><h2>금일정시도착</h2><div class="dash_data"><span id="todayArrNorRt">0</span><em>%</em></div></li>
				<li><h2>전일정시도착</h2><div class="dash_data"><span id="yesterdayArrNorRt">0</span><em>%</em></div></li>
			</ul>
		</div>
	</div>

</div>