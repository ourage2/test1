<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script type="text/javascript" src="<c:url value="/resources/js/highchart/highcharts.js"/>"></script>
<script type="text/javascript" src="<c:url value="/resources/js/highchart/module/series-label.js"/>"></script>
<script>
var srch$;
var grid1$;
var chart1;
jQuery(function($) {
	srch$ = com.toBox($('#divSrch'));

	grid1$ = $('#grid1').jqGrid({
		url: _contextPath_ + '/manage/center/dayAnal.json',
		height: 240,
		shrinkToFit: false,
		sortable: false,
		footerrow: true,
		postData: com.getData(srch$),
		colNames:['센터명', '창고명', '전체<br/>평균', '최고', '최저', '평일<br/>평균', '휴일<br/>평균',
			'1', '2', '3', '4', '5', '6', '7', '8', '9', '10',
			'11', '12', '13', '14', '15', '16', '17', '18', '19', '20',
			'21', '22', '23', '24', '25', '26', '27', '28', '29', '30',
			'31'
		],
		cmTemplate: {
			align:'center',
			sortable:false,
			formatter: 'number'
		},
		colModel:[
			{name:'centerNm', index:'CENTER_NM', width:86, formatter:''},
			{name:'cargoNm', index:'CARGO_NM', width:86, formatter:function (cellvalue) {return cellvalue || '';}},
			{name:'totRt', index:'TOT_RT', width:50},
			{name:'maxRt', index:'MAX_RT', width:50},
			{name:'minRt', index:'MIN_RT', width:50},
			{name:'normalRt', index:'NORMAL_RT', width:50},
			{name:'weekendRt', index:'WEEKEND_RT', width:50},
			{name:'day1', index:'day1', width:35},
			{name:'day2', index:'day2', width:35},
			{name:'day3', index:'day3', width:35},
			{name:'day4', index:'day4', width:35},
			{name:'day5', index:'day5', width:35},
			{name:'day6', index:'day6', width:35},
			{name:'day7', index:'day7', width:35},
			{name:'day8', index:'day8', width:35},
			{name:'day9', index:'day9', width:35},
			{name:'day10', index:'day10', width:35},
			{name:'day11', index:'day11', width:35},
			{name:'day12', index:'day12', width:35},
			{name:'day13', index:'day13', width:35},
			{name:'day14', index:'day14', width:35},
			{name:'day15', index:'day15', width:35},
			{name:'day16', index:'day16', width:35},
			{name:'day17', index:'day17', width:35},
			{name:'day18', index:'day18', width:35},
			{name:'day19', index:'day19', width:35},
			{name:'day20', index:'day20', width:35},
			{name:'day21', index:'day21', width:35},
			{name:'day22', index:'day22', width:35},
			{name:'day23', index:'day23', width:35},
			{name:'day24', index:'day24', width:35},
			{name:'day25', index:'day25', width:35},
			{name:'day26', index:'day26', width:35},
			{name:'day27', index:'day27', width:35},
			{name:'day28', index:'day28', width:35},
			{name:'day29', index:'day29', width:35},
			{name:'day30', index:'day30', width:35},
			{name:'day31', index:'day31', width:35}
		]
	});

	grid1$.on('jqGridLoadComplete', function (event, data) {
		if (!data.hasOwnProperty('list') || 0 === data.list.length) {
			return false;
		}
		user.makeSeriesData(data);

		user.sumColDateGrid1(data.userData);
	});

	//조회지표 변경
	srch$.find('[name=srchDayAnalDiv]').on('change', function () {
		var arr = com.getCdList('CAR_ANAL_DIV', {etc1: $(this).val()});
		var disabled;
		var bizCds;
		if (arr.length === 0) {
			disabled = true;
			bizCds = [];
		} else {
			disabled = false;
			bizCds = com.getCdList('020');
		}
		com.setCombo('select', srch$, 'srchCarAnalDiv', '', arr);
		com.setCombo('select', srch$, 'srchBizCd', '', bizCds);

		srch$.find('[name=srchCarAnalDiv]').prop('disabled', disabled);
		srch$.find('[name=srchBizCd]').prop('disabled', disabled);
	});

	//검색
	$('#srchBtn').on('click', function() {

		$('#pnlTitle').text($('select[name=srchDayAnalDiv] option:selected').text());

		user.changeHeaderGrid1();

		grid1$.setGridParam({postData: com.getData(srch$)}).trigger('reloadGrid');

		if (chart1 && chart1.options) {
			chart1.destroy();
		}
		grid1$.clearFooterData();

		user.showHideColGrid1();
	});

	//엑셀다운로드
	$('#xlsBtn').on('click', function() {
		var xlsParam = com.getData(srch$);
		var xlsHeader = user.getXlsHeader();
		xlsParam.xlsColLbs = xlsHeader.xlsColLbs.join(',');
		xlsParam.xlsColNms = xlsHeader.xlsColNms.join(',');
		cvo.ajaxFileDown({url: _contextPath_ + '/manage/center/dayAnal.xls', data: xlsParam});
	});

	user.mainInit();
});

var user = {
	//메인페이지 초기화
	mainInit : function() {

		com.setCombo('select', srch$, 'srchCenterCd', '', com.sAuthCenterList());

		com.setCombo('select', srch$, 'srchDayAnalDiv', '', [{cd: 'CARGO', nm: '센터별창고온도준수율'}, {cd: 'CARGO_NM', nm: '창고별온도준수율'}, {cd: 'ARR', nm: '대리점정시도착률'}, {cd: 'TEMP', nm: '차량온도준수율'}]);

		com.setCombo('select', srch$, 'srchBizCd', '', com.getCdList('020'));

		srch$.find('[name=srchDayAnalDiv]').triggerHandler('change');

		//검색조건 기본값 설정
		var minDate = onm.addDate(new Date(), -15);
		var maxDate = onm.addDate(new Date(), -1);

		//조회기간시작
		srch$.find('[name=srchStrDt]')
			.datepicker('option', {
				'maxDate': maxDate,
				onSelect: function (dateText, inst) {
					var selDate = $(this).datepicker('getDate');
					var after30DaysDate = onm.addDate(selDate, 30);
					var _maxDate = selDate > after30DaysDate ? selDate : after30DaysDate;
					if (_maxDate > maxDate) {
						_maxDate = maxDate;
					}
					srch$.find('[name=srchEndDt]').datepicker('option', {'minDate': selDate, 'maxDate': _maxDate});
				}
			})
			.val(onm.formatDate(minDate));

		//조회기간종료
		srch$.find('[name=srchEndDt]')
			.datepicker('option', {
				'minDate': minDate,
				'maxDate': maxDate
			})
			.val(onm.formatDate(maxDate));

		$('#srchBtn').trigger('click');
	},

	changeHeaderGrid1: function () {
		var colModel = grid1$.getGridParam('colModel');
		var srchStrDt = onm.parseDate(srch$.find('[name=srchStrDt]').val());
		var srchEndDt = onm.parseDate(srch$.find('[name=srchEndDt]').val());

		var bgArr = [];
		var i;
		var idxStr = -1;
		var idxEnd = -1;
		for (i = 0; i < colModel.length; i++) {
			if (/^day\d+$/.test(colModel[i].name)) {
				if (idxStr === -1) idxStr = i;
				idxEnd = i;
				bgArr.push('inherit');
			}
		}

		var colLabel;
		for (i = idxStr; i <= idxEnd; i++) {
			if (onm.diffDate(srchStrDt, srchEndDt) <= 0) {
				colLabel = (srchStrDt.getMonth() + 1) + '/<br/>' + onm.lpad(srchStrDt.getDate(), 2, '0');
				grid1$.setLabel(colModel[i].name, colLabel);

				switch (srchStrDt.getDay()) {
					case 0:
						bgArr[i - idxStr] = '#ffe0e0';
						break;
					case 6:
						bgArr[i - idxStr] = '#a4bed4';
						break;
				}
			} else {
				grid1$.setLabel(colModel[i].name, '-');
			}

			srchStrDt = onm.addDate(srchStrDt, 1);
		}

		$.each(bgArr, function (idx, item) {
			grid1$.setColProp('day' + (idx + 1), {
				cellattr: function () {
					return 'style="background-color:' + item + ';"'
				}
			});
		});
	},

	showHideColGrid1: function () {
		var srchDayAnalDiv = srch$.find('select[name=srchDayAnalDiv]').val();

		var cols1 = ['cargoNm'];
		if ('CARGO_NM' === srchDayAnalDiv) {
			grid1$.showCol(cols1);
		} else {
			grid1$.hideCol(cols1);
		}

		var cols2 = ['normalRt', 'weekendRt'];
		if ('ARR' === srchDayAnalDiv) {
			grid1$.showCol(cols2);
		} else {
			grid1$.hideCol(cols2);
		}
	},

	sumColDateGrid1: function (userData) {
		var footerData = {
			centerNm: '계'
		};
		$.extend(true, footerData, userData);
		grid1$.footerData2('set', footerData);
	},

	makeSeriesData: function(data) {
		if (!data.hasOwnProperty('list') || 0 === data.list.length) {
			return false;
		}

		var list = data.list;

		var srchDayAnalDiv = srch$.find('select[name=srchDayAnalDiv]').val();
		var series = [];
		$.each(list, function (index, item) {
			var seriesNm;
			if ('CARGO_NM' === srchDayAnalDiv) {
				seriesNm = item.cargoNm;
			} else {
				seriesNm = item.centerNm;
			}

			series.push({
				name: seriesNm,
				data: []
			});
		});

		var postData = grid1$.getGridParam('postData');

		for (var i=0; i<list.length; i++) {
			var srchStrDt = onm.parseDate(postData.srchStrDt);
			var srchEndDt = onm.parseDate(postData.srchEndDt);
			var row = list[i];
			var j = 1;

			for (;;) {
				if (onm.diffDate(srchStrDt, srchEndDt) > 0) {
					break;
				}
				series[i].data.push({
					x: srchStrDt.getTime(),
					y: (row['day' + j] == null ? 0 : row['day' + j])
				});

				srchStrDt = onm.addDate(srchStrDt, 1);
				j++;
			}
		}

		user.initChart(series);
	},

	initChart: function(series) {
		var opt = {
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
				max: 100
			},
			legend: {
				align: 'right',
				verticalAlign: 'top',
				borderWidth: 0
			},
			tooltip: {
				shared: true,
				crosshairs: true,
				valueSuffix: '%'
			},
			series: series
		};

		chart1 = Highcharts.chart('chart1', opt);
	},

	getXlsHeader: function () {
		var colNames = grid1$.getGridParam('colNames');
		var xlsColNms = [];
		var xlsColLbs = [];
		$.each(grid1$.getGridParam('colModel'), function (index, item) {
			if (item.hidden !== true) {
				xlsColNms.push(item.name);
				xlsColLbs.push(colNames[index].replace(/<.+>/g, ''));
			}
		});
		return {
			xlsColNms: xlsColNms,
			xlsColLbs: xlsColLbs
		};
	}
}
</script>

<header>
	<div id="divSrch">
		<div class="loc_info"><span>일자별 누적 내역 현황</span><span>센터관리</span><span>Home</span></div>
		<h2 class="content_title"><span>일자별 누적 내역 현황</span></h2>
		<div class="srch_box">
			<table>
				<colgroup>
					<col style="width:9%">
					<col style="width:14%">

					<col style="width:7%">
					<col style="width:12%">

					<col style="width:7%">
					<col style="width:10%">

					<col style="width:7%">
					<col style="width:20%">

					<col style="width:auto">
				</colgroup>

				<tr>
					<th>센터</th>
					<td>
						<select name="srchCenterCd" class="chosen" multiple data-placeholder="전체"></select>
					</td>

					<th>조회지표</th>
					<td>
						<select name="srchDayAnalDiv"></select>
					</td>

					<th>세부지표</th>
					<td>
						<select name="srchCarAnalDiv"></select>
					</td>

					<th>조회기간</th>
					<td>
						<input type="text" name="srchStrDt" class="calendar" mindateid="srchEndDt" /> ~ <input type="text" name="srchEndDt" class="calendar" />
					</td>

					<td>
						<div class="srch_btn">
							<button type="button" id="srchBtn" class="btn_srch "><span class="ico_srch"></span>검색</button>
						</div>
					</td>
				</tr>

				<tr>
					<th>차량업무구분</th>
					<td colspan="7">
						<select name="srchBizCd"></select>
					</td>
				</tr>
			</table>
		</div>
	</div>
</header>

<div id="main">
	<div class="colgroup-wrap">
		<div class="caption-pnl">
			<h2><span class="x-icon"></span><span class="x-label" id="pnlTitle"></span></h2>
			<span class="buttonset fr">
				※단위: %
				<button type="button" id="xlsBtn" class="btn_list" ><span class="ico_xls ico_only"></span></button>
			</span>
		</div>
		<table id="grid1"></table>
	</div>

	<div class="colgroup-wrap">
		<div id="chart1" style="margin-right: 18px; height: 340px;"></div>
	</div>
</div>
