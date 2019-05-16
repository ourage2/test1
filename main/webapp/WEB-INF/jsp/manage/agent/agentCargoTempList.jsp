<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script type="text/javascript" src="<c:url value="/resources/js/highchart/highcharts.js"/>"></script>
<script type="text/javascript" src="<c:url value="/resources/js/highchart/module/boost.js"/>"></script>
<script type="text/javascript" src="<c:url value="/resources/js/highchart/module/broken-axis.js"/>"></script>

<script>
var srch$;
var grid1$;
var grid2$;

jQuery(function($) {
	srch$ = com.toBox($('#divSrch'));
	
	grid1$ = $('#grid1').jqGrid({
		url: _contextPath_ + '/manage/agent/agentCargoTempList.json',
		pager:'#grid1Pg',
		height: 240,
		postData: user.getGrid1PostData(),
		colNames:[
			'순번', '날짜', '대리점명', '창고명', '창고ID', 
			'수집횟수', '이상온도횟수', '위반횟수', '온도준수율', 'CH_CNT'
		],
		cmTemplate: {
			align: 'center'
		},
		colModel:[
			{name:'rnum', index:'rnum', width:3, align:'right', sortable:false},
			{name:'stdDate', index:'STD_DATE', width:10},
			{name:'agentNm', index:'AGENT_NM', width:14, align: 'left'},
			{name:'cargoNm', index:'CARGO_NM', width:13, align: 'left'},
			{name:'devId', index:'DEV_ID', width:10},
			{name:'totCnt', index:'TOT_CNT', width:10},
			{name:'vioCnt', index:'VIO_CNT', width:10},
			{name:'vioLongCnt', index:'VIO_LONG_CNT', width:10},
			{name:'norRt', index:'NOR_RT', width:10},
			{name:'chCnt', index:'CH_CNT', hidden:true}
		],
		onSelectRow: function (rowId) {
			var rowData = $(this).getRowData(rowId);
			var postData = {
				stdDate: rowData.stdDate,
				devId: rowData.devId
			};
			
			grid2$.setGridParam({postData: postData}).trigger('reloadGrid');
		}
	});
	
	grid2$ = $('#grid2').jqGrid({
		url: _contextPath_ + '/manage/agent/agentCargoTempDtlList.json',
		pager:'#grid2Pg',
		height: 240,
		colNames:[
			'순번', '시간', 'CH1', 'CH2', 'CH3', 
			'CH4', 'CH5', 'CH6'
		],
		cmTemplate: {
			align: 'center'
		},
		colModel:[
			{name:'rnum', index:'rnum', width:3, align:'right', sortable:false},
			{name:'devDt', index:'DEV_DT', width:10, formatter:formatterHms},
			{name:'ch1', index:'CH1', width:10, formatter:'integer'},
			{name:'ch2', index:'CH2', width:10, formatter:'integer'},
			{name:'ch3', index:'CH3', width:10, formatter:'integer'},
			{name:'ch4', index:'CH4', width:10, formatter:'integer'},
			{name:'ch5', index:'CH5', width:10, formatter:'integer'},
			{name:'ch6', index:'CH6', width:10, formatter:'integer'}
		]
	});
	
	function formatterHms(cellvalue, options, rowdata) {
		return onm.formatTimeToDate(user.roundSec(cellvalue), 'HH:mm:ss') || '';
	}

	//검색
	$('#srchBtn').on('click', function() {
		grid1$.setGridParam({postData: user.getGrid1PostData(), page: 1}).trigger('reloadGrid');
		grid2$.clearGridData();
	});
	
	//엑셀다운로드
	$('#xlsBtn').on('click', function() {
		cvo.ajaxFileDown({url: _contextPath_ + '/manage/agent/agentCargoTempList.xls', data: com.getData(srch$)});
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
		
		//검색조건 기본값 설정
		srch$.find('[name=srchStrDt]').val(onm.getBeforeMonth());
		srch$.find('[name=srchEndDt]').val(onm.todayFmt());
		
		$('#srchBtn').trigger('click');
	},
	
	getGrid1PostData: function() {
		var postData = com.getData(srch$);
		postData.paramPaginateRecordSize = 1000;
		return postData;
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
	
	initChart: function(series) {
		
		var plotLineOpt1 = {
			id: 'plotLineOpt1',
			value: 5,
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
					<col style="width: 7%">
					<col style="width: 21%">
					<col style="width: 7%">
					<col style="width: 20%">
					<col style="width: auto">
				</colgroup>

				<tr>
					<th>검색어</th>
					<td>
						<select name="srchMethod">
							<option value="cargoNm">창고명</option>
						</select>
						<input type="text" name="srchWord" maxlength="30" class="enterSrch" />
					</td>

					<th>조회기간</th>
					<td>
						<input type="text" name="srchStrDt" class="calendar" mindateid="srchEndDt" /> ~ <input type="text" name="srchEndDt" class="calendar" maxdateid="srchStrDt" />
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
			<h2><span class="x-icon"></span><span class="x-label">창고 온도 내역</span></h2>
			<span class="buttonset fr">
				<button type="button" id="xlsBtn" class="btn_list" ><span class="ico_xls ico_only"></span></button>
			</span>
		</div>
		<table id="grid1"></table>
		<div id="grid1Pg"></div>
	</div>
	<div class="colgroup-wrap mT20">
		<div class="caption-pnl">
			<h2><span class="x-icon"></span><span class="x-label">창고 온도 세부 내역</span></h2>
			<span class="buttonset fr">
				<button type="button" id="chartBtn" class="btn_srch" ><span class="ico_srch"></span>그래프</button>
			</span>
		</div>
		<table id="grid2"></table>
		<div id="grid2Pg"></div>
	</div>
</div>