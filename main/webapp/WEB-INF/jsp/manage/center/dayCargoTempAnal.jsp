<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script type="text/javascript" src="<c:url value="/resources/js/highchart/highcharts.js"/>"></script>
<script type="text/javascript" src="<c:url value="/resources/js/highchart/module/boost.js"/>"></script>
<script type="text/javascript" src="<c:url value="/resources/js/highchart/module/broken-axis.js"/>"></script>

<script>
var srch$;
var grid1$;
var grid2$;
var chart1$;

jQuery(function($) {
	srch$ = com.toBox($('#divSrch'));
	
	grid1$ = $('#grid1').jqGrid({
		url: _contextPath_ + '/manage/center/dayCargoTempAnal.json',
		height: 200,
		postData: com.getData(srch$),
		colNames:[
			'순번', '날짜', '센터명', '창고명', '창고ID', 
			'수집횟수(분당)', '이상온도횟수', '위반횟수(50분연속)', '온도준수율', 'CH_CNT',
			'ch1Nm', 'ch2Nm', 'ch3Nm', 'ch4Nm', 'ch5Nm', 'ch6Nm'
		],
		cmTemplate: {
			align: 'center'
		},
		colModel:[
			{name:'rnum', index:'rnum', width:3, align:'right', sortable:false},
			{name:'stdDate', index:'A.STD_DATE', width:10},
			{name:'centerNm', index:'B.CENTER_NM', width:14},
			{name:'cargoNm', index:'C.CARGO_NM', width:13},
			{name:'devId', index:'C.DEV_ID', width:10},
			{name:'totCnt', index:'A.TOT_CNT', width:10},
			{name:'vioCnt', index:'A.VIO_CNT', width:10},
			{name:'vioLongCnt', index:'A.VIO_LONG_CNT', width:10},
			{name:'norRt', index:'NOR_RT', width:10},
			{name:'chCnt', index:'CH_CNT', hidden:true},
			{name:'ch1Nm', index:'CH1_NM', hidden:true},
			{name:'ch2Nm', index:'CH2_NM', hidden:true},
			{name:'ch3Nm', index:'CH3_NM', hidden:true},
			{name:'ch4Nm', index:'CH4_NM', hidden:true},
			{name:'ch5Nm', index:'CH5_NM', hidden:true},
			{name:'ch6Nm', index:'CH6_NM', hidden:true}
		],
		onSelectRow: function (rowId) {
			var rowData = $(this).getRowData(rowId);
			var postData = {
				stdDate: rowData.stdDate,
				devId: rowData.devId
			};

			var chNms = ['ch1Nm', 'ch2Nm', 'ch3Nm', 'ch4Nm', 'ch5Nm', 'ch6Nm'];
			var chs = ['ch1', 'ch2', 'ch3', 'ch4', 'ch5', 'ch6'];
			$.each(chNms, function (index, item) {
				var chNm = chs[index].toUpperCase();
				if (rowData[item]) {
					chNm += '<br/>(' + rowData[item] + ')'
				}
				grid2$.setLabel(chs[index], chNm);
			});
			
			grid2$.setGridParam({postData: postData}).trigger('reloadGrid');
		}
	});
	
	grid2$ = $('#grid2').jqGrid({
		url: _contextPath_ + '/manage/center/dayCargoTempAnalDtl.json',
		pager:'#grid2Pg',
		height: 200,
		colNames:[
			'순번', '시간', 'CH1', 'CH2', 'CH3', 
			'CH4', 'CH5', 'CH6', '온도상태', '위반상태',
			'seq', 'tempVioCd', 'vioDesc'
		],
		cmTemplate: {
			align: 'center'
		},
		colModel:[
			{name:'rnum', index:'rnum', width:3, align:'right', sortable:false},
			{name:'devDt', index:'A.DEV_DT', width:10, formatter:formatterHms},
			{name:'ch1', index:'A.CH1', width:10, formatter:'integer'},
			{name:'ch2', index:'A.CH2', width:10, formatter:'integer'},
			{name:'ch3', index:'A.CH3', width:10, formatter:'integer'},
			{name:'ch4', index:'A.CH4', width:10, formatter:'integer'},
			{name:'ch5', index:'A.CH5', width:10, formatter:'integer'},
			{name:'ch6', index:'A.CH6', width:10, formatter:'integer'},
			{name:'tempStat', index:'TEMP_STAT', width:14, sortable:false},
			{name:'tempVioNm', index:'D.CD_NM', width:13},
			{name:'seq', index:'SEQ', width:5, hidden: true},
			{name:'tempVioCd', index:'TEMP_VIO_CD', width:5, hidden: true},
			{name:'vioDesc', index:'VIO_DESC', width:5, hidden: true}
		],
		ondblClickRow: function () {
			onm.ajaxModal({
				url: _contextPath_ + '/manage/center/cargoVioInputView.pop',
				dialogOptions: {
					title: '온도 이상 사유',
					width: 300,
					height: 285,
					open: function (event, ui) {
						user.initVioPopup($(this));
					}
				}
			});
		}
	});
	
	function formatterHms(cellvalue, options, rowdata) {
		return onm.formatTimeToDate(user.roundSec(cellvalue), 'HH:mm:ss') || '';
	}

	//검색
	$('#srchBtn').on('click', function() {
		grid2$.clearGridData();
		grid1$.setGridParam({postData: com.getData(srch$)}).trigger('reloadGrid');
	});
	
	//엑셀다운로드
	$('#xlsBtn').on('click', function() {
		cvo.ajaxFileDown({url: _contextPath_ + '/manage/center/dayCargoTempAnal.xls', data: com.getData(srch$)});
	});
	
	//엑셀다운로드
	$('#xlsBtn2').on('click', function() {
		var postData = grid2$.getGridParam('postData');
		cvo.ajaxFileDown({url: _contextPath_ + '/manage/center/dayCargoTempAnalDtl.xls', data: postData});
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
				title: '창고 온도 세부 내역',
				width: 1100,
				height: 500,
				open: function (event, ui) {
					var chartData = user.makeSeriesData();
					user.initChart(chartData);
				}
			}
		});
	});

	user.mainInit();
});

var user = {
	//메인페이지 초기화
	mainInit : function() {
		
		com.setCombo('select', srch$, 'srchCenterCd', '', com.sAuthCenterList());
		
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
	
	makeSeriesData: function() {
		var i;
		var list = grid2$.getGridData();
		if (list.length <= 0) return null;
		
		var chCnt = Number(grid1$.getSelGridData()[0].chCnt);

		var series = [];
		for (i = 1; i <= chCnt; i++) {
			series.push({
				gapSize: 1,
				name: 'ch' + i,
				data: []
			})
		}
		
		var row, devDt, j, propNm;
		for (i=0; i<list.length; i++) {
			row = list[i];
			devDt = user.roundSec(row.devDt);
			for (j=0; j<series.length; j++) {
				propNm = series[j].name;
				var v = (row[propNm] == null ? 0 : Number(row[propNm]));
				series[j].data.push([devDt, v]);
			}
		}
		
		return series;
	},
	
	roundSec: function(devDt) {
		var dt = new Date(devDt);
		if (dt.getSeconds() > 50) {
			dt.setSeconds(0, 0);
			return dt.getTime() + (1000 * 60);
		} else {
			dt.setSeconds(0, 0);
			return dt.getTime();
		}
	},
	
	initChart: function(series) {
		
		var plotLineOpt1 = {
			id: 'plotLineOpt1',
			value: 4,
			color: '#ff0000',
			dashStyle: 'shortdash',
			width: 2
		};
		
		series.push({
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
                zoomType: 'x'
            },
			xAxis: {
				type: 'datetime',
				tickInterval: 60 * 60 * 1000,
				labels: {
					format: '{value:%H:%M}',
					align: 'center'
				},
				events: {
					afterSetExtremes: function (e) {
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
				align: 'right',
				verticalAlign: 'top',
				borderWidth: 0
			},
			tooltip: {
				shared: true,
				crosshairs: true,
				xDateFormat: '%k:%M',
				valueSuffix: String.fromCharCode(8451)
			},
			plotOptions: {
				series: {
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
			series: series
		};
		
		chart1$ = Highcharts.chart('chart1', opt);
	},
	
	initVioPopup: function(popup$) {
		
		var vioCdList = $.grep(window.gCdList, function (item) {
			return item.grpCd === 'VIO_CD'
		});

		var cargoTempHtml = '<label><input type="radio" name="tempVioCd" value="">선택</label>';

		$.each(vioCdList, function (index, item) {
			switch (item.etc1) {
				case 'CARGO_TEMP':
					cargoTempHtml += '<br/><label><input type="radio" name="tempVioCd" value="' + item.cd + '">' + item.nm + '</label>';
					break;
			}
		});

		var rowData = grid2$.getSelGridData()[0];

		popup$.find('#divCarTemp').append($(cargoTempHtml));
		
		popup$.find('input[name=tempVioCd]').filter(function (index, el) {
			return $(el).val() === (rowData.tempVioCd || '');
		}).prop('checked', true);
		
		popup$.find('textarea[name=vioDesc]').val(rowData.vioDesc || '');
		
		//저장
		popup$.find('#btnPopSave').on('click', function () {
			var tempVioCd = popup$.find('input[name=tempVioCd]:checked').val();
			var vioDesc = popup$.find('textarea[name=vioDesc]').val();
			
			var tempVioChanged = tempVioCd !== (rowData.tempVioCd || '');
			var vioDescChanged = vioDesc !== (rowData.vioDesc || '');

			if (tempVioChanged || vioDescChanged) {
				onm.confirm('저장하시겠습니까?', function () {
					var data = {
						seq: rowData.seq,
						tempVioCd: tempVioCd,
						vioDesc: vioDesc
					};

					onm.ajax({
						url: _contextPath_ + '/manage/center/cargoVioInputSave.json',
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
		<div class="loc_info"><span>일자별 창고 온도 내역</span><span>센터 관리</span><span>Home</span></div>
		<h2 class="content_title"><span>일자별 창고 온도 내역</span></h2>
		<div class="srch_box">
			<table>
				<colgroup>
					<col style="width: 5%">
					<col style="width: 17%">
					<col style="width: 7%">
					<col style="width: 21%">
					<col style="width: 7%">
					<col style="width: 20%">
					<col style="width: auto">
				</colgroup>

				<tr>
					<th>소속</th>
					<td>
						<select name="srchCenterCd" class="chosen" multiple data-placeholder="전체"></select>
					</td>
					
					<th>검색어</th>
					<td>
						<select name="srchMethod">
							<option value="cargoNm">창고명</option>
						</select>
						<input type="text" name="srchWord" maxlength="30" class="enterSrch" />
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
			</table>
		</div>
	</div>
</header>

<div id="main">
	<div class="colgroup-wrap">
		<div class="caption-pnl">
			<h2><span class="x-icon"></span><span class="x-label">일자별 창고 온도 내역</span></h2>
			<span class="buttonset fr">
				<button type="button" id="xlsBtn" class="btn_list" ><span class="ico_xls ico_only"></span></button>
			</span>
		</div>
		<table id="grid1"></table>
	</div>
	<div class="colgroup-wrap mT20">
		<div class="caption-pnl">
			<h2><span class="x-icon"></span><span class="x-label">창고 온도 세부 내역</span></h2>
			<span class="buttonset fr">
				<button type="button" id="chartBtn" class="btn_srch" ><span class="ico_srch"></span>그래프</button>
				<button type="button" id="xlsBtn2" class="btn_list" ><span class="ico_xls ico_only"></span></button>
			</span>
		</div>
		<table id="grid2"></table>
		<div id="grid2Pg"></div>
	</div>
</div>