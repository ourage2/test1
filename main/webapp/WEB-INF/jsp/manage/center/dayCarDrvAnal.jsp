<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script type="text/javascript" src="<c:url value="/resources/js/highchart/highcharts.js"/>"></script>
<script type="text/javascript" src="<c:url value="/resources/js/highchart/module/boost.js"/>"></script>
<script type="text/javascript" src="<c:url value="/resources/js/highchart/module/broken-axis.js"/>"></script>

<style>
	div.highcharts-tooltip span {
		background-color: #ffffff;
	}
</style>

<script>
var srch$;
var grid1$;
var grid2$;
var chart1$;

jQuery(function($) {
	srch$ = com.toBox($('#divSrch'));

	grid1$ = $('#grid1').jqGrid({
		url: _contextPath_ + '/manage/center/dayCarDrvAnal.json',
		pager:'#grid1Pg',
		height: 240,
		shrinkToFit: false,
		postData: user.getGrid1PostData(),
		colNames:[
			'순번', '센터명', '조회일', '소속운송사', '차량번호',
			'운전자', '운행거리', '운행시간', '최종 대리점 출발 시간', '업무거리',
			'업무시간', '선적건수', '납품건수', 'SAP기준<br>정시/위반 납품', '구간기준<br>정시/위반 납품',
			'사유건수', '온도수집건', '기준온도<br>위반건', 'HACCP 온도<br>위반건', '사유건수',
			'상태정보', 'carId', 'chCnt', 'bizCd'
		],
		cmTemplate: {
			align:'center'
		},
		colModel:[
			{name:'rnum', index:'rnum', width:30, align:'right', sortable:false},
			{name:'centerNm', index:'A.CENTER_NM', width:90},
			{name:'stdDate', index:'A.STD_DATE', width:70},
			{name:'companyNm', index:'A.COMPANY_NM', width:130},
			{name:'carNo', index:'A.CAR_NO', width:90, align:'right'},

			{name:'drvNm', index:'A.DRV_NM', width:70},
			{name:'totDis', index:'TOT_DIS', width:70, align:'right'},
			{name:'totTm', index:'TOT_TM', width:80, align:'right'},
			{name:'lastAgentStrTm',index:'A.LAST_AGENT_STR_DT', width:70},
			{name:'drvDis', index:'A.DRV_DIS', width:70, align:'right'},

			{name:'drvTm', index:'A.DRV_SEC', width:80, align:'right'},
			{name:'shipCnt', index:'A.SHIP_CNT', width:70},
			{name:'deliCompCnt', index:'A.DELI_COMP_CNT', width:80},
			{name:'arrNorVioCnt', index:'A.ARR_NOR_CNT', width:90},
			{name:'arrAgentNorVioCnt', index:'A.ARR_AGENT_NOR_CNT', width:90},

			{name:'inputArrVioCnt', index:'A.INPUT_ARR_VIO_CNT', width:70},
			{name:'tempTotCnt', index:'A.TEMP_TOT_CNT', width:70},
			{name:'tempVioLongCnt', index:'A.TEMP_VIO_LONG_CNT', width:70},
			{name:'tempHaccpVioLongCnt', index:'A.TEMP_HACCP_VIO_LONG_CNT', width:80},
			{name:'inputTempVioCnt', index:'A.INPUT_TEMP_VIO_CNT', width:70},

			{name:'restNm', index:'A.REST_NM', width:70},
			{name:'carId', index:'CAR_ID', hidden:true},
			{name:'chCnt', index:'CH_CNT', hidden:true},
			{name:'bizCd', index:'BIZ_CD', hidden:true}
		],
		onSelectRow: function (rowId) {
			var postData = user.getGrid2PostData();
			grid2$.setGridParam({postData: postData}).trigger('reloadGrid');
			$('input[name=srchDtlDiv]').prop('disabled', false);
		}
	});

	grid2$ = $('#grid2').jqGrid({
		url: _contextPath_ + '/manage/center/dayCarDrvAnalDtl.json',
		height: 240,
		shrinkToFit: false,
		colNames:[
			'순번', '보고시간', '주소', '속도', '누적운행거리',
			'CH1', 'CH2', '선적번호', '납품번호', '대리점코드',
			'대리점명', '도착 위반여부', '위반사유', '온도상태', '온도위반여부',
			'온도위반사유', '배송이벤트',
			'zoneType', 'delayYn', 'seq', 'arrVioCd', 'tempVioCd', 'vioDesc', 'agentDelayYn'
		],
		cmTemplate: {
			align:'center',
			sortable:false
		},
		colModel:[
			{name:'rnum', index:'rnum', width:30, align:'right', sortable:false},
			{name:'devTm', index:'DEV_TM', width:60},
			{name:'jibunAddr', index:'JIBUN_ADDR', width:190, align:'left'},
			{name:'spd', index:'SPD', width:60},
			{name:'dayTotDis', index:'DAY_TOT_DIS', width:60},

			{name:'ch1', index:'CH1', width:60, formatter:'number'},
			{name:'ch2', index:'CH2', width:60, formatter:'number'},
			{name:'shipNo', index:'SHIP_NO', width:80},
			{name:'deliNo', index:'DELI_NO', width:80},
			{name:'agentCd', index:'AGENT_CD', width:80},

			{name:'agentNm', index:'AGENT_NM', width:100},
			{name:'delayTxt', index:'DELAY_TXT', width:60},
			{name:'arrVioNm', index:'ARR_VIO_NM', width:80},
			{name:'vioTxt', index:'VIO_TXT', width:60},
			{name:'vioLongTxt', index:'VIO_LONG_TXT', width:60},

			{name:'tempVioNm', index:'TEMP_VIO_NM', width:60},
			{name:'event', index:'EVENT', width:150, align:'left'},

			{name:'zoneType', index:'ZONE_TYPE', width:5, hidden: true},
			{name:'delayYn', index:'DELAY_YN', width:5, hidden: true},
			{name:'seq', index:'SEQ', width:5, hidden: true},
			{name:'arrVioCd', index:'ARR_VIO_CD', width:5, hidden: true},
			{name:'tempVioCd', index:'TEMP_VIO_CD', width:5, hidden: true},
			{name:'vioDesc', index:'VIO_DESC', width:5, hidden: true},
			{name:'agentDelayYn', index:'VIO_DESC', width:5, hidden: true},
		],
		ondblClickRow: function (rowId) {
			var rowData = $(this).getGridData(rowId);
			if (rowData.agentDelayYn === 'Y' || rowData.vioLongTxt) {
				onm.ajaxModal({
					url: _contextPath_ + '/manage/center/carVioInputView.pop',
					dialogOptions: {
						title: '대리점 도착 위반 / 온도 이상 사유',
						width: 440,
						height: 295,
						open: function (event, ui) {
							user.initVioPopup($(this));
						}
					}
				});
			}
		}
	});

	//검색
	$('#srchBtn').on('click', function() {

		var srchMethod = srch$.find('select[name=srchMethod]').val();
		var srchWord = srch$.find('input[name=srchWord]').val();

		switch (srchMethod) {
			case 'carNo':
				if (srchWord !== '' && $.trim(srchWord).length < 3) {
					onm.alert('차량번호 숫자 3자리 이상 입력하세요.');
					return false;
				}
				break;

		}

		srch$.find('input[name=srchWord]').val($.trim(srchWord));

		grid1$.setGridParam({postData: user.getGrid1PostData(), page: 1}).trigger('reloadGrid');
		grid2$.clearGridData();
	});

	//엑셀다운로드
	$('#xlsBtn1').on('click', function () {
		cvo.ajaxFileDown({url: _contextPath_ + '/manage/center/dayCarDrvAnal.xls', data: user.getGrid1PostData()});
	});

	//세부검색조건
	$('input[name=srchDtlDiv]').on('change', function () {
		if (grid1$.getGridParam('selrow')) {
			var postData = user.getGrid2PostData();
			grid2$.setGridParam({postData: postData}).trigger('reloadGrid');
		}
	});

	//그래프
	$('#chartBtn').on('click', function() {

		if ($.type(grid2$.getGridData()) !== 'array' || grid2$.getGridData().length === 0) {
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
					var chartData = user.makeSeriesData();
					user.initChart(chartData);
				}
			}
		});
	});

	$('#xlsBtn2').on('click', function () {
		cvo.ajaxFileDown({url: _contextPath_ + '/manage/center/dayCarDrvAnalDtl.xls', data: user.getGrid2PostData()});
	});

	user.mainInit();
});

var user = {
	//메인페이지 초기화
	mainInit : function() {

		com.setCombo('select', srch$, 'srchCenterCd', '', com.sAuthCenterList());
		com.setCombo('select', srch$, 'srchBizCd', '', com.getCdList('020'));

		//검색조건 기본값 설정
		var minDate = onm.addDate(new Date(), -2);
		var maxDate = onm.addDate(new Date(), -1);

		//조회기간시작
		srch$.find('[name=srchStrDt]')
			.datepicker('option', 'maxDate', maxDate)
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

	getGrid1PostData: function() {
		var postData = com.getData(srch$);
		// IE: 500, 기타: 1000
		postData.paramPaginateRecordSize = !!document.documentMode ? 500 : 1000;
		return postData;
	},

	getGrid2PostData: function() {
		var rowData = grid1$.getSelGridData()[0];
		return {
			srchDtlDiv: $('input[name=srchDtlDiv]:checked').val(),
			stdDate: rowData.stdDate,
			carId: rowData.carId,
			bizCd: rowData.bizCd
		};
	},

	makeSeriesData: function() {
		var i;
		var list = grid2$.getGridData();
		if (list.length <= 0) return null;

		var chCnt = Number(grid1$.getSelGridData()[0].chCnt);

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
				var v = (row[propNm] == null ? 0 : Number(row[propNm]));
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

	initChart: function(chartData) {

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
				// min: -5,
				// max: 10,
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

	initVioPopup: function(popup$) {

		var vioCdList = $.grep(window.gCdList, function (item) {
			return item.grpCd === 'VIO_CD'
		});

		var agentArrHtml = '<label><input type="radio" name="arrVioCd" value="">선택</label>';
		var carTempHtml = '<label><input type="radio" name="tempVioCd" value="">선택</label>';

		$.each(vioCdList, function (index, item) {
			switch (item.etc1) {
				case 'ARR':
					// if (agentArrHtml.length > 0) agentArrHtml += '<br/>';
					agentArrHtml += '<br/><label><input type="radio" name="arrVioCd" value="' + item.cd + '">' + item.nm + '</label>';
					break;
				case 'CAR_TEMP':
					// if (carTempHtml.length > 0) carTempHtml += '';
					carTempHtml += '<br/><label><input type="radio" name="tempVioCd" value="' + item.cd + '">' + item.nm + '</label>';
					break;
			}
		});

		var rowData = grid2$.getSelGridData()[0];

		popup$.find('#divArr').append($(agentArrHtml));
		popup$.find('#divCarTemp').append($(carTempHtml));

		popup$.find('input[name=arrVioCd]').filter(function (index, el) {
			return $(el).val() === (rowData.arrVioCd || '');
		}).prop('checked', true);

		popup$.find('input[name=tempVioCd]').filter(function (index, el) {
			return $(el).val() === (rowData.tempVioCd || '');
		}).prop('checked', true);

		popup$.find('textarea[name=vioDesc]').val(rowData.vioDesc || '');

		//저장
		popup$.find('#btnPopSave').on('click', function () {
			var arrVioCd = popup$.find('input[name=arrVioCd]:checked').val();
			var tempVioCd = popup$.find('input[name=tempVioCd]:checked').val();
			var vioDesc = popup$.find('textarea[name=vioDesc]').val();

			var arrVioChanged = arrVioCd !== (rowData.arrVioCd || '');
			var tempVioChanged = tempVioCd !== (rowData.tempVioCd || '');
			var vioDescChanged = vioDesc !== (rowData.vioDesc || '');

			if (arrVioChanged || tempVioChanged || vioDescChanged) {
				onm.confirm('저장하시겠습니까?', function () {
					var data = {
						seq: rowData.seq,
						arrVioCd: arrVioCd,
						tempVioCd: tempVioCd,
						vioDesc: vioDesc
					};

					onm.ajax({
						url: _contextPath_ + '/manage/center/carVioInputSave.json',
						data: data,
						success: function (res) {
							if (res.result > 0) {
								grid2$.trigger('reloadGrid');
								popup$.dialog('close');
							} else {
							}
						}
					});
				});
			} else {
				onm.alert('변경된 데이터가 없습니다.');
			}
		});

		//취소
		popup$.find('#btnPopCancel').on('click', function () {
			popup$.dialog('close');
		});
	}
}
</script>

<header>
	<div id="divSrch">
		<div class="loc_info"><span>일자별 차량 운행 내역</span><span>센터 관리</span><span>Home</span></div>
		<h2 class="content_title"><span>일자별 차량 운행 내역</span></h2>
		<div class="srch_box">
			<table>
				<colgroup>
					<col style="width: 9%">
					<col style="width: 14%">

					<col style="width: 6%">
					<col style="width: 23%">

					<col style="width: 7%">
					<col style="width: 20%">

					<col style="width: auto">
				</colgroup>

				<tr>
					<th>센터</th>
					<td>
						<select name="srchCenterCd" class="chosen" multiple data-placeholder="전체"></select>
					</td>

					<th>검색어</th>
					<td>
						<select name="srchMethod">
							<option value="carNo">차량번호</option>
							<option value="drvNm">운전자</option>
							<option value="companyNm">소속운송사</option>
						</select>
						<input type="text" name="srchWord" maxlength="30" class="enterSrch" />
					</td>

					<th>조회기간</th>
					<td>
						<input type="text" name="srchStrDt" class="calendar" mindateid="srchEndDt" /> ~ <input type="text" name="srchEndDt" class="calendar"/>
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
			<h2><span class="x-icon"></span><span class="x-label">일자별 차량 운행 내역</span></h2>
			<span class="buttonset fr">
				<button type="button" id="xlsBtn1" class="btn_list" ><span class="ico_xls ico_only"></span></button>
			</span>
		</div>
		<table id="grid1"></table>
		<div id="grid1Pg"></div>
	</div>
	<div class="colgroup-wrap mT20">
		<div class="caption-pnl">
			<h2><span class="x-icon"></span><span class="x-label">일자별 차량 운행 세부 내역</span></h2>
			<span class="buttonset fr">
				<span style="font-weight: bold;">세부검색조건</span>
				<label><input type="radio" name="srchDtlDiv" disabled value="" checked>전체</label>&nbsp;
				<label><input type="radio" name="srchDtlDiv" disabled value="1">업무</label>&nbsp;
				<label><input type="radio" name="srchDtlDiv" disabled value="2">배송 이벤트</label>&nbsp;
				<label><input type="radio" name="srchDtlDiv" disabled value="3">온도/도착 위반</label>&nbsp;

				<button type="button" id="chartBtn" class="btn_srch" ><span class="ico_srch"></span>그래프</button>
				<button type="button" id="xlsBtn2" class="btn_list" ><span class="ico_xls ico_only"></span></button>
			</span>
		</div>
		<table id="grid2"></table>
	</div>
</div>