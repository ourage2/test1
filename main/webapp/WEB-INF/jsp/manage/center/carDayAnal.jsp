<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script type="text/javascript" src="<c:url value="/resources/js/highchart/highcharts.js"/>"></script>
<script type="text/javascript" src="<c:url value="/resources/js/highchart/module/boost.js"/>"></script>
<script type="text/javascript" src="<c:url value="/resources/js/highchart/module/broken-axis.js"/>"></script>

<script>
var srch$;
var grid1$;
var grid2$;

var gridOpt;

var popupView1$;
var popupGrid1$;

jQuery(function($) {
	srch$ = com.toBox($('#divSrch'));

	grid1$ = $('#grid1').jqGrid({
		url: _contextPath_ + '/manage/center/carDayAnal.json',
		height: 250,
		shrinkToFit: false,
		sortable: false,
		footerrow: true,
		postData: com.getData(srch$),
		colNames:[
			'순번', '센터', '차량<br>소속', '차량<br>번호', '운전자',
			'최고', '최저', '평일<br>평균', '휴일<br>평균',
			'총선적', '총납품', '실납품',
			'1', '2', '3', '4', '5', '6', '7', '8', '9', '10',
			'11', '12', '13', '14', '15', '16', '17', '18', '19', '20',
			'21', '22', '23', '24', '25', '26', '27', '28', '29', '30',
			'31',
			'CAR_ID'
		],
		cmTemplate: {
			align:'center',
			formatter: function(cellvalue, options, rowObject) {
				var grid$ = $(this);
				var colNm = options.colModel.name;
				var srchAnalDiv = grid$.getGridParam('postData').srchAnalDiv;
				if ('TEMP' === srchAnalDiv || 'ARR' === srchAnalDiv) {
					if(colNm.endsWith('Rt') || colNm.startsWith('day')) {
						var opt = {
							colModel: {
								formatoptions: {decimalSeparator: ".", thousandsSeparator: "", decimalPlaces: 1, defaultValue: "-"}
							}
						};
						return grid$.fmatter('number', cellvalue, opt);
					} else {
						return grid$.fmatter.defaultFormat(cellvalue, {});
					}
				} else {
					if(colNm.startsWith('day')) {
						return grid$.fmatter.defaultFormat(cellvalue, {defaultValue:'-'});
					} else if(colNm.endsWith('Cnt')) {
						var optInt = {
							colModel: {
								formatoptions: {thousandsSeparator: ",", defaultValue: "0"}
							}
						};
						return grid$.fmatter('integer', cellvalue, optInt);
					}
				}
				return grid$.fmatter.defaultFormat(cellvalue, {});
			}
		},
		colModel:[
			{name:'rnum', index:'rnum', width:30, align:'right', sortable:false},
			{name:'centerNm', index:'CENTER_NM', width:86},
			{name:'companyNm', index:'C.CD_NM', width:80},
			{name:'carNo', index:'CAR_NO', width:80},
			{name:'drvNm', index:'DRV_NM', width:50},
			{name:'maxRt', index:'MAX_RT', width:50},
			{name:'minRt', index:'MIN_RT', width:50},
			{name:'normalRt', index:'NORMAL_RT', width:50},
			{name:'weekendRt', index:'WEEKEND_RT', width:50},
			{name:'shipCnt', index:'SHIP_CNT', width:50, hidden:true},
			{name:'deliPlanCnt', index:'DELI_PLAN_CNT', width:50, hidden:true},
			{name:'deliCompCnt', index:'DELI_COMP_CNT', width:50, hidden:true},
			{name:'day1', index:'day1', width:38},
			{name:'day2', index:'day2', width:38},
			{name:'day3', index:'day3', width:38},
			{name:'day4', index:'day4', width:38},
			{name:'day5', index:'day5', width:38},
			{name:'day6', index:'day6', width:38},
			{name:'day7', index:'day7', width:38},
			{name:'day8', index:'day8', width:38},
			{name:'day9', index:'day9', width:38},
			{name:'day10', index:'day10', width:38},
			{name:'day11', index:'day11', width:38},
			{name:'day12', index:'day12', width:38},
			{name:'day13', index:'day13', width:38},
			{name:'day14', index:'day14', width:38},
			{name:'day15', index:'day15', width:38},
			{name:'day16', index:'day16', width:38},
			{name:'day17', index:'day17', width:38},
			{name:'day18', index:'day18', width:38},
			{name:'day19', index:'day19', width:38},
			{name:'day20', index:'day20', width:38},
			{name:'day21', index:'day21', width:38},
			{name:'day22', index:'day22', width:38},
			{name:'day23', index:'day23', width:38},
			{name:'day24', index:'day24', width:38},
			{name:'day25', index:'day25', width:38},
			{name:'day26', index:'day26', width:38},
			{name:'day27', index:'day27', width:38},
			{name:'day28', index:'day28', width:38},
			{name:'day29', index:'day29', width:38},
			{name:'day30', index:'day30', width:38},
			{name:'day31', index:'day31', width:38},
			{name:'carId', index:'CAR_ID', width:35, hidden:true}
		],
		onSelectRow: function(rowId) {
			var rowData = $(this).getRowData(rowId);
			var carId = rowData.carId;
			var postData = $(this).getGridParam('postData');
			postData.carId = carId;

			grid2$.setGridParam({postData: postData}).trigger('reloadGrid');
		}
	});

	grid1$.on('jqGridLoadComplete', function (event, data) {
		if (!data.hasOwnProperty('list') || 0 === data.list.length) {
			return false;
		}

		var grid$ = $(this);
		var footerData = {
			centerNm: '계'
		};
		$.extend(true, footerData, data.userData);

		grid$.footerData2('set', footerData);
	});

	gridOpt = {
		'ARR': {
			'gridParam': {
				url: _contextPath_ + '/manage/center/carDayAnalDtl.json',
				height: 250,
				postData: com.getData(srch$),
				colNames:[
					'순번', '운행일자', '정시', '위반', '정시도착률',
					'정시', '위반', '정시도착률', '차이', 'carId',
					'centerNm', 'companyNm', 'carNo', 'drvNm', 'drvTelNo',
					'drvHpNo', 'bizCd', 'restNm'
				],
				cmTemplate: {
					align:'center',
					sortable:false
				},
				colModel:[
					{name:'rnum', index:'rnum', width:4, align:'right'},
					{name:'stdDate', index:'STD_DATE', width:12},
					{name:'arrAgentNorCnt', index:'ARR_AGENT_NOR_CNT', width:12, formatter: 'integer'},
					{name:'arrAgentVioCnt', index:'ARR_AGENT_VIO_CNT', width:12, formatter: 'integer'},
					{name:'arrAgentNorRt', index:'ARR_AGENT_NOR_RT', width:12, formatter: 'number'},

					{name:'arrNorCnt', index:'ARR_NOR_CNT', width:12, formatter: 'integer'},
					{name:'arrVioCnt', index:'ARR_VIO_CNT', width:12, formatter: 'integer'},
					{name:'arrNorRt', index:'ARR_NOR_RT', width:12, formatter: 'number'},
					{name:'difRt', index:'DIF_RT', width:7, formatter: 'number'},
					{name:'carId', index:'CAR_ID', hidden:true},

					{name:'centerNm', index:'CENTER_NM', hidden:true},
					{name:'companyNm', index:'COMPANY_NM', hidden:true},
					{name:'carNo', index:'CAR_NO', hidden:true},
					{name:'drvNm', index:'DRV_NM', hidden:true},
					{name:'drvTelNo', index:'DRV_TEL_NO', hidden:true},

					{name:'drvHpNo', index:'DRV_HP_NO', hidden:true},
					{name:'bizCd', index:'BIZ_CD', hidden:true},
					{name:'restNm', index:'REST_NM', hidden:true}
				],
				ondblClickRow: function () {
					onm.ajaxModal({
						url: _contextPath_ + '/manage/center/dayAgentArrAnalHist.pop',
						dialogOptions: {
							title: '정시 도착 준수율 세부 현황'
						}
					});
				}
			},
			'groupHeader': {
				useColSpanStyle: true,
				groupHeaders: [
					{startColumnName: 'arrAgentNorCnt', numberOfColumns: 3, titleText: '도착시간 구간설정 반영'},
					{startColumnName: 'arrNorCnt', numberOfColumns: 3, titleText: '도착시간 ±30분 반영'}
				]
			}
		},
		'TEMP': {
			'gridParam': {
				url: _contextPath_ + '/manage/center/carDayAnalDtl.json',
				height: 250,
				postData: com.getData(srch$),
				colNames:[
					'순번', '일자', '차량구분', '전체온도건수', '온도위반건수',
					'온도준수율', '전체온도건수', '온도위반건수', '온도준수율', 'carId',
					'centerNm', 'companyNm', 'carNo', 'drvNm', 'drvTelNo',
					'drvHpNo', 'bizCd', 'chCnt'
				],
				cmTemplate: {
					align:'center',
					sortable:false
				},
				colModel:[
					{name:'rnum', index:'rnum', width:4, align:'right'},
					{name:'stdDate', index:'STD_DATE', width:12},
					{name:'restNm', index:'REST_NM', width:12},
					{name:'tempTotCnt2', index:'TEMP_TOT_CNT1', width:12, formatter: 'integer'},
					{name:'tempVioLongCnt', index:'TEMP_VIO_LONG_CNT', width:12, formatter: 'integer'},

					{name:'tempNorRt', index:'TEMP_NOR_RT', width:12, formatter: 'number'},
					{name:'tempTotCnt1', index:'TEMP_TOT_CNT2', width:12, formatter: 'integer'},
					{name:'tempHaccpVioLongCnt', index:'TEMP_HACCP_VIO_LONG_CNT', width:12, formatter: 'integer'},
					{name:'tempHaccpNorRt', index:'TEMP_HACCP_NOR_RT', width:12, formatter: 'number'},
					{name:'carId', index:'CAR_ID', hidden:true},

					{name:'centerNm', index:'CENTER_NM', hidden:true},
					{name:'companyNm', index:'COMPANY_NM', hidden:true},
					{name:'carNo', index:'CAR_NO', hidden:true},
					{name:'drvNm', index:'DRV_NM', hidden:true},

					{name:'drvTelNo', index:'DRV_TEL_NO', hidden:true},
					{name:'drvHpNo', index:'DRV_HP_NO', hidden:true},
					{name:'bizCd', index:'BIZ_CD', hidden:true},
					{name:'chCnt', index:'CH_CNT', hidden:true}
				],
				ondblClickRow: function () {
					onm.ajaxModal({
						url: _contextPath_ + '/manage/center/dayCarTempAnalHist.pop',
						dialogOptions: {
							title: '온도 준수율 세부 현황'
						}
					});
				}
			},
			'groupHeader': {
				useColSpanStyle: true,
				groupHeaders: [
					{startColumnName: 'tempTotCnt2', numberOfColumns: 3, titleText: '정상차량 온도 준수율(0도 ~ 5도)'},
					{startColumnName: 'tempTotCnt1', numberOfColumns: 3, titleText: '정상차량 온도 준수율(0도 ~ 10도)'}
				]
			}
		},
		'DELI': {
			'gridParam': {
				url: _contextPath_ + '/manage/center/carDayAnalDtl.json',
				height: 250,
				postData: com.getData(srch$),
				colNames:[
					'순번', '일자', '차량번호', '선적번호', '납품번호',
					'대리점명', '예상시간', 'CVO<br/>예상시간', '도착시간', '출발시간',
					'센터출발대기', '납품완료', '±30<br/>차이시간', '구간설정<br/>차이시간', '크레이트<br/>작업시간',
					'마감시간', '미준수<br/>여부'
				],
				cmTemplate: {
					align:'center'
				},
				colModel:[
					{name:'rnum', index:'rnum', width:3, align:'right', sortable:false},
					{name:'stdMd', index:'STD_MD', width:5, sortable:false},
					{name:'carNo', index:'CAR_NO', width:8, sortable:false},
					{name:'shipNo', index:'SHIP_NO', width:8},
					{name:'deliNo', index:'DELI_NO', width:7},
					{name:'agentNm', index:'AGENT_NM', width:11, align:'left'},
					{name:'arrExpectDt', index:'ARR_EXPECT_DT', width:7},
					{name:'cvoExpect', index:'CVO_EXPECT', width:8},
					{name:'arrDt', index:'ARR_DT', width:7},
					{name:'strDt', index:'STR_DT', width:7},
					{name:'centerRdyDt', index:'CENTER_RDY_DT', width:6},
					{name:'deliyDt', index:'DELIY_DT', width:6},
					{name:'arrGapMin', index:'ARR_GAP_MIN', width:7},
					{name:'agentGapMin', index:'AGENT_GAP_MIN', width:7},
					{name:'crateInputDt', index:'CRATE_INPUT_DT', width:7},
					{name:'sapIfDt', index:'SAP_IF_DT', width:7},
					{name:'delayYn', index:'DELAY_YN', width:6}
				]
			}
		}
	};

	user.determineGrid();

	//조회지표 변경
	srch$.find('[name=srchAnalDiv]').on('change', function () {
		var arr = com.getCdList('CAR_ANAL_DIV', {etc1: $(this).val()});
		var disabled;
		if (arr.length === 0) {
			disabled = true;
		} else {
			disabled = false;
		}
		com.setCombo('select', srch$, 'srchCarAnalDiv', '', arr);

		srch$.find('[name=srchCarAnalDiv]').prop('disabled', disabled);
	});

	//검색
	$('#srchBtn').on('click', function() {

		var srchAnalDivTxt = $('select[name=srchAnalDiv] option:selected').text();
		$('#pnlTitle1').text(srchAnalDivTxt);
		$('#pnlTitle2').text(srchAnalDivTxt + ' 상세');

		user.determineGrid();
		user.changeGrid1Header();

		grid1$.setGridParam({postData: com.getData(srch$)}).trigger('reloadGrid');

		grid1$.clearFooterData();

		user.showHideColGrid1();
	});

	//엑셀다운로드
	$('#xlsBtn1').on('click', function() {
		var xlsParam = com.getData(srch$);
		var xlsHeader = user.getXlsHeader(grid1$);

		xlsParam.xlsTitle = $('#pnlTitle1').text();
		xlsParam.xlsColLbs = xlsHeader.xlsColLbs.join(',');
		xlsParam.xlsColNms = xlsHeader.xlsColNms.join(',');

		cvo.ajaxFileDown({url: _contextPath_ + '/manage/center/carDayAnal.xls', data: xlsParam});
	});

	//엑셀다운로드
	$('#xlsBtn2').on('click', function() {
		var xlsParam = grid2$.getGridParam('postData');
		var xlsHeader = user.getXlsHeader(grid2$);

		xlsParam.xlsTitle = $('#pnlTitle2').text();
		xlsParam.xlsColLbs = xlsHeader.xlsColLbs.join(',');
		xlsParam.xlsColNms = xlsHeader.xlsColNms.join(',');

		cvo.ajaxFileDown({url: _contextPath_ + '/manage/center/carDayAnalDtl.xls', data: xlsParam});
	});

	user.mainInit();
});

var user = {
	//메인페이지 초기화
	mainInit : function() {
		com.setCombo('select', srch$, 'srchCenterCd', '', com.sAuthCenterList());
		com.setCombo('select', srch$, 'srchBizCd', '', com.getCdList('020'));

		//검색조건 기본값 설정
		var minDate = onm.addDate(new Date(), -7);
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

		srch$.find('[name=srchAnalDiv]').triggerHandler('change');

		$('#srchBtn').trigger('click');
	},

	changeGrid1Header: function () {
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
		var cols1 = ['maxRt', 'minRt', 'normalRt', 'weekendRt'];
		var cols2 = ['shipCnt', 'deliPlanCnt', 'deliCompCnt'];
		if ('DELI' === $('select[name=srchAnalDiv]').val()) {
			grid1$.showCol(cols2);
			grid1$.hideCol(cols1);
		} else {
			grid1$.showCol(cols1);
			grid1$.hideCol(cols2);
		}
	},

	determineGrid: function() {

		var prevSrchAnalDiv = grid1$.getGridParam('postData').srchAnalDiv;
		var srchAnalDiv = $('select[name=srchAnalDiv]').val();

		if (grid2$ && prevSrchAnalDiv === srchAnalDiv) {
			grid2$.clearGridData();
		} else {
			// grid2$.GridDestroy();
			if (grid2$) {
				grid2$.GridUnload();
			}

			var opt = gridOpt[srchAnalDiv];
			if (opt) {
				if (opt.gridParam) {
					grid2$ = $('#grid2').jqGrid(opt.gridParam);
				}
				if (opt.groupHeader) {
					grid2$.setGroupHeaders(opt.groupHeader);
				}
			}
		}
	},

	popupInit: function() {
		var rowData = grid2$.getSelGridData()[0];
		com.setVal(popupView1$, rowData);
		popupGrid1$.setGridWidth(1158);
		popupGrid1$.setGridParam({postData: rowData}).trigger('reloadGrid');
	},

	popupMakeSeriesData: function() {
		var i;
		var list = popupGrid1$.getGridData();
		if (list.length <= 0) return null;

		var chCnt = Number(grid2$.getSelGridData()[0].chCnt);

		var dt = new Date();

		var series = [];
		for (i = 1; i <= chCnt; i++) {
			series.push({
				gapSize: 2,
				name: 'ch' + i,
				data: []
			})
		}

		var row, devDt, j, propNm;
		for (i=0; i<list.length; i++) {
			row = list[i];
			devDt = user.makeTime(dt, row.devTm);
			for (j=0; j<series.length; j++) {
				propNm = series[j].name;
				var v = row[propNm];
				if (v !== null) {
					v = Number(v);
				}
				series[j].data.push([devDt, v]);
			}
		}

		var xPlotLines = [];
		$.each(list, function (index, item) {
			if (item.zoneType) {
				var time = user.makeTime(dt, item.devTm);

				for (var i=0; i<xPlotLines.length; i++) {
					if (xPlotLines[i].value === time) {
						return true;
					}
				}

				xPlotLines.push({
					value: time,
					width: 1,
					color: '#000000',
					zoneType: item.zoneType,
					delayYn: item.delayYn,
					agentNm: item.agentNm
				});
			}
		});

		return {
			series: series,
			xPlotLines: xPlotLines
		}
	},

	makeTime: function(dt, devTm) {
		var arr = devTm.split(':');
		dt.setHours(arr[0], arr[1], 0, 0);
		return dt.getTime();
	},

	popupInitChart: function(chartData) {

		function changeVisibilityPosition(chart, plotLinesAndBands) {
			$.each(plotLinesAndBands, function (idx, item) {
				var svgTxt = svgTxtArr[idx];
				var svgLbl = svgLblArr[idx];
				var el$ = $(svgTxt.element);
				if ('visible' === item.svgElem.visibility) {
					var left = Number(item.svgElem.d.split(' ')[1]) - el$.width() / 2;
					el$.css('left', left);
					svgTxt.show();

					svgLbl.translate(left - 20, svgLbl.y);
					svgLbl.show();
				} else {
					svgTxt.hide();
					svgLbl.hide();
				}
			});
		}

		var plotLineOpt1 = {
			id: 'plotLineOpt1',
			value: 5,
			color: '#ff0000',
			dashStyle: 'shortdash',
			width: 2
		};

		chartData.series.push({
			color: '#ff0000',
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
				zoomType: 'x',
				marginTop: 60,
				events: {
					redraw: function (e) {
						changeVisibilityPosition(this, this.xAxis[0].plotLinesAndBands);
					}
				}
			},
			xAxis: {
				type: 'datetime',
				tickInterval: 60 * 60 * 1000,
				labels: {
					format: '{value:%H:%M}',
					align: 'center'
				},
				plotLines: chartData.xPlotLines,
				events: {
					afterSetExtremes: function (e) {
						changeVisibilityPosition(this.chart, this.plotLinesAndBands);

						var tickInterval = 60 * 60 * 1000;
						if (e.userMax !== undefined) {
							tickInterval = 60 * 1000;
						}
						this.chart.update({'xAxis': {'tickInterval': tickInterval}});
					}
				}
			},
			yAxis: {
				plotLines: [plotLineOpt1]
			},
			legend: {
				align: 'center',
				verticalAlign: 'bottom',
				borderWidth: 0
			},
			tooltip: {
				shared: true,
				crosshairs: true,
				useHTML: true,
				xDateFormat: '%k:%M',
				valueSuffix: String.fromCharCode(8451)
			},
			plotOptions: {
				series: {
					dataLabels: {
						enabled: false
					},
					lineWidth: 1,
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
			series: chartData.series
		};

		var svgTxtArr = [];
		var svgLblArr = [];
		var centerNm = grid1$.getSelGridData()[0].centerNm;

		chart1$ = Highcharts.chart('chart1', opt, function (chart) {

			$.each(chart.xAxis[0].plotLinesAndBands, function (idx, item) {
				var val = item.options.value;
				var k = item.axis.series[0].xData.indexOf(val);
				var data = item.axis.series[0].data[k];
				var x = data.plotX + chart.plotLeft - 12;
				var y = 60;

				var lblX = x - 20;

				var html;
				var agentNm = '';

				if (item.options.zoneType === '1') {
					html = '<span class="ico-agent start">S</span>';
				} else if (item.options.zoneType === '2') {

					var agentClass = 'missed';
					switch (item.options.delayYn) {
						case 'Y':
							agentClass = 'delay';
							break;
						case 'N':
							agentClass = 'fixed';
							break;
					}

					html = '<span class="ico-agent ' + agentClass + '"></span>';
				} else if (item.options.zoneType === '3') {
					html = '<span class="ico-agent end">E</span>';
				}

				switch (item.options.zoneType) {
					case "1":
					case "3":
						agentNm = centerNm;
						break;
					case "2":
						agentNm = item.options.agentNm;
						break;
				}

				var lblY = 5;
				$.each(svgLblArr, function (_idx, _item) {
					var xCollision = _item.x <= lblX && (_item.x + _item.width) >= lblX;
					var yCollision = _item.y <= lblY && (_item.y + _item.height) >= lblY;
					if (xCollision && yCollision) {
						lblY = 85;
						return true;
					}
				});

				var svgLbl = chart.renderer.label(agentNm, lblX, lblY, 'callout', data.plotX + chart.plotLeft, chart.plotTop)
					.css({
						color: '#FFFFFF'
					})
					.attr({
						fill: 'rgba(0, 0, 0, 0.75)',
						padding: 8,
						r: 5,
						zIndex: 6
					})
					.add();

				svgLblArr.push(svgLbl);

				var svgTxt = chart.renderer.text(html, x, y, true).add();

				svgTxtArr.push(svgTxt);
			});
		});
	},

	getXlsHeader: function (grid$) {
		var colNames = grid$.getGridParam('colNames');
		var xlsColNms = [];
		var xlsColLbs = [];
		$.each(grid$.getGridParam('colModel'), function (index, item) {
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
		<div class="loc_info"><span>차량별 누적 현황</span><span>센터 관리</span><span>Home</span></div>
		<h2 class="content_title"><span>차량별 누적 현황</span></h2>
		<div class="srch_box">
			<table>
				<colgroup>
					<col style="width: 9%">
					<col style="width: 12%">

					<col style="width: 7%">
					<col style="width: 9%">

					<col style="width: 7%">
					<col style="width: 10%">

					<col style="width: 7%">
					<col style="width: 20%">

					<col style="width: auto">
				</colgroup>

				<tr>
					<th>센터</th>
					<td>
						<select name="srchCenterCd" class="chosen" multiple data-placeholder="전체"></select>
					</td>

					<th>조회지표</th>
					<td>
						<select name="srchAnalDiv">
							<option value="ARR">정시 도착률</option>
							<option value="TEMP">온도 준수율</option>
							<option value="DELI">납품 실적</option>
						</select>
					</td>

					<th>세부지표</th>
					<td>
						<select name="srchCarAnalDiv"></select>
					</td>

					<th>조회기간</th>
					<td>
						<input type="text" name="srchStrDt" class="calendar"/> ~ <input type="text" name="srchEndDt" class="calendar"/>
					</td>

					<td>
						<div class="srch_btn">
							<button type="button" id="srchBtn" class="btn_srch "><span class="ico_srch"></span>검색</button>
						</div>
					</td>
				</tr>

				<tr>
					<th>업무구분</th>
					<td>
						<select name="srchBizCd"></select>
					</td>

					<th>차량번호</th>
					<td>
						<input type="text" name="srchCarNo" maxlength="30" class="enterSrch" />
					</td>
				</tr>
			</table>
		</div>
	</div>
</header>

<div id="main">
	<div class="colgroup-wrap">
		<div class="caption-pnl">
			<h2><span class="x-icon"></span><span class="x-label" id="pnlTitle1"></span></h2>
			<span class="buttonset fr">
				<button type="button" id="xlsBtn1" class="btn_list" ><span class="ico_xls ico_only"></span></button>
			</span>
		</div>
		<table id="grid1"></table>
	</div>
	<div class="colgroup-wrap mT20">
		<div class="caption-pnl">
			<h2><span class="x-icon"></span><span class="x-label" id="pnlTitle2"></span></h2>
			<span class="buttonset fr">
				<button type="button" id="xlsBtn2" class="btn_list" ><span class="ico_xls ico_only"></span></button>
			</span>
		</div>
		<table id="grid2"></table>
	</div>
</div>