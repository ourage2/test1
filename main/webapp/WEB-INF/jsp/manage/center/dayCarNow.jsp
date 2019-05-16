<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script type="text/javascript" src="<c:url value="/resources/js/highchart/highcharts.js"/>"></script>
<script type="text/javascript" src="<c:url value="/resources/js/highchart/module/boost.js"/>"></script>
<script type="text/javascript" src="<c:url value="/resources/js/highchart/module/broken-axis.js"/>"></script>

<!-- 카카오맵 api 로드 -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=<spring:eval expression="@config['daum.map.appkey']" />&libraries=services,clusterer"></script>

<script src="<c:url value="/resources/js/map/cvo.map.library.js" />"></script>
<script src="<c:url value="/resources/js/map/cvo.map.layout.util.js" />"></script>

<style>
#gview_grid1 .ui-jqgrid-hdiv { width:380px !important; }
#gview_grid2 .ui-jqgrid-hdiv { width:380px !important; }
.ui-datepicker select.ui-datepicker-year { width: 42% !important; }
.ui-datepicker select.ui-datepicker-month { width: 40% !important; }

.ui-state-gray { background-color: #e2e2e2; }
</style>

<script>
var daumMap;
var daumBounds;
var daumGeocoder;

var srch1$;
var grid1$;
var grid2$;
var grid3$;
var view1$;
var chart1$;

var selectedRow;

jQuery(function($) {
	srch1$ = com.toBox($('#divSrch1'));
	view1$ = com.toBox($('#divView1'));

	user.mapInit();

	grid1$ = $('#grid1').jqGrid({
		url: _contextPath_ + '/manage/center/dayCarNow.json',
		height: 288,
		scrollrows: true,
		postData: user.getPostData(),
		colNames:['순번', '수배송', '소속센터', '차량번호', '선적번호', '요청일', '차량ID', '온도채널수', '납풉요청일', '납품완료여부', '마감종류'],
		cmTemplate: {
			align:'center',
			sortable: false
		},
		colModel:[
			{name:'rnum', index:'RNUM', width:29, align:'right'},
			{name:'strBizCd', index:'STR_BIZ_CD', width:35},
			{name:'centerNm', index:'CAR_CENTER_NM', width:45},
			{name:'carNo', index:'CAR_NO', width:70},
			{name:'shipNo', index:'SHIP_NO', width:65},
			{name:'shipReqDate', index:'TXT_SHIP_REQ_DATE', width:40, formatter: user.calendarView},
			{name:'carId', index:'CAR_ID', hidden: true},
			{name:'chCnt', index:'CH_CNT', hidden: true},
			{name:'shipReqDate', index:'SHIP_REQ_DATE', hidden: true},
			{name:'deliyYn', index:'DELIY_YN', hidden: true},
			{name:'deliyDiv', index:'DELIY_DIV', hidden: true}
		],
		gridComplete: function(){
			var rows = grid1$.getDataIDs();
		    for (var i = 0; i < rows.length; i++)     {
		        var deliyDiv = grid1$.getCell(rows[i],"deliyDiv");
		        if(deliyDiv == "1") {
					//grid1$.setRowData(rows[i], false, { background:'#CECECE'});
					//console.log(rows[i]);
					$("#"+rows[i]).addClass("ui-state-gray");
				}
		    }
		},
		onSelectRow: function(rowId, status, e) {
			if (e == undefined || e.which == 1) {
				var data = grid1$.getRowData(rowId);
				$("#dtlCarNo").text(" - 차량번호: " + data.carNo + ", 선적번호: " + data.shipNo);

				if (selectedRow != undefined) {
					if (grid1$.getRowData(selectedRow).deliyDiv == "1") {
						$("#"+selectedRow).addClass("ui-state-gray");
					}
				}

				selectedRow = rowId;
				$("#"+rowId).removeClass("ui-state-gray");
				$("#"+rowId).addClass("ui-state-highlight");

				user.getCenterData(data);
				user.getDeliData(data);
				user.getHistData(data);
			}
		}
	});

	grid2$ = $('#grid2').jqGrid({
		url: _contextPath_ + '/manage/center/dayCarNowDtlList.json',
		height: 160,
		scrollrows: true,
		postData: user.getPostData(),
		colNames:['순번', '대리점명', '예정시간', '도착시간', '차이', '대리점코드', '선적번호', '납품번호', '납품요청일', '위도', '경도'],
		cmTemplate: {
			align:'center'
		},
		colModel:[
			{name:'rnum', index:'RNUM', width:29, align:'right', sortable:false},
			{name:'agentNm', index:'AGENT_NM', width:76},
			{name:'arrExpectDt', index:'ARR_EXPECT_DT', width:45},
			{name:'arrDt', index:'ARR_DT', width:45},
			{name:'arrGapSec', index:'ARR_GAP_SEC', width:30, formatter: user.gapSecView},
			{name:'agentCd', index:'AGENT_CD', hidden: true},
			{name:'shipNo', index:'SHIP_NO', hidden: true},
			{name:'deliNo', index:'DELI_NO', hidden: true},
			{name:'shipReqDate', index:'SHIP_REQ_DATE', hidden: true},
			{name:'xpos', index:'XPOS', hidden: true},
			{name:'ypos', index:'YPOS', hidden: true},
		],
		gridComplete: function(){
			var gridData = grid2$.getRowData();
			$.CvoMap.DRAW.agentMarker(gridData);
		},
		onSelectRow: function(rowId, status, e) {
			if (e == undefined || e.which == 1) {
				var data = grid2$.getRowData(rowId);
				if ($.isNumeric(data.xpos) && $.isNumeric(data.ypos)) {
					var pos = convertPos(data.xpos , data.ypos);
					$.CvoMap.SET.center(pos);
					$.CvoMap.SET.zoom(4);
				} else {
					alert("좌표 형태가 옳바르지 않습니다.");
				}

			}
		}
	});

	grid3$ = $('#grid3').jqGrid({
		url: _contextPath_ + '/manage/center/dayCarNowHistList.json',
		height: 160,
		autowidth:true,
		scrollrows: true,
		postData: user.getPostData(),
		colNames:['순번', '시간', '주소', '속도', '운행거리', 'CH1', 'CH2', 'CH3', 'CH4', '비고', '온도이상일시', '도착대리점명', '위도', '경도', '차량ID', '보고일시'],
		cmTemplate: {
			align:'center'
		},
		colModel:[
			{name:'rnum', index:'RNUM', width:29, align:'right', sortable:false},
			{name:'devDt', index:'DEV_DT', width:40},
			{name:'jibunAddr', index:'JIBUN_ADDR', width:145},
			{name:'spd', index:'SPD', width:30, formatter: user.spdView},
			{name:'dayDis', index:'DAY_DIS', width:40, formatter: user.dayDisView},
			{name:'ch1', index:'CH1', width:30, formatter: user.tempView},
			{name:'ch2', index:'CH2', width:30, formatter: user.tempView},
			{name:'ch3', index:'CH3', width:30, formatter: user.tempView},
			{name:'ch4', index:'CH4', width:30, formatter: user.tempView},
			{name:'', index:'BIGO', width:70, formatter: user.bigoView, sortable:false},
			{name:'tempDevDt', index:'TEMP_DEV_DT', hidden: true},
			{name:'agentNm', index:'AGENT_NM', hidden: true},
			{name:'xpos', index:'XPOS', hidden: true},
			{name:'ypos', index:'YPOS', hidden: true},
			{name:'carId', index:'CAR_ID', hidden: true},
			{name:'fullDevDt', index:'FULL_DEV_DT', hidden: true},
		],
		gridComplete: function(){
			var gridData = grid3$.getRowData();
			if (grid3$.getGridParam("sortname") == "") {
				$.CvoMap.DRAW.route(gridData);
			}
		},
		onSelectRow: function(rowId, status, e) {
			if (e == undefined || e.which == 1) {
				var data = grid3$.getRowData(rowId);
				$.CvoMap.DRAW.midMarker(data);
			}
		}
	});

	//검색
	$('#srchBtn').on('click', function() {
		com.init(view1$, true);

		grid1$.setGridParam({postData: user.getPostData()}).trigger('reloadGrid');
		grid2$.clearGridData();
		grid3$.clearGridData();

		$.CvoMap.DRAW.route(null);

		if(!isNull(centerMarker))
			centerMarker.setMap(null);

		centerMarker = null;

		$("#dtlCarNo").html("&nbsp;");
	});

	//선적엑셀다운로드
	$('#btnGrid1Xls').on('click', function() {
		cvo.ajaxFileDown({url: _contextPath_ + '/manage/center/dayCarNow.xls', data: user.getPostData()});
	});

	//선적엑셀다운로드
	$('#btnGrid3Xls').on('click', function() {
		var data = grid1$.getRowData(grid1$.getGridParam("selrow"));
		data.srchShipReqDate = srch1$.find('[name=srchShipReqDate]').val();
		cvo.ajaxFileDown({url: _contextPath_ + '/manage/center/dayCarNowHistList.xls', data: data});
	});

	//전체경로조회
	$('#totalHistBtn').on('click', function() {
		if ($.type(grid3$.getGridData()) !== 'array' || grid3$.getGridData().length === 0) {
			onm.alert('운행 데이터가 없습니다.');
			return false;
		}

		var data = grid1$.getRowData(grid1$.getGridParam("selrow"));
		data.srchShipReqDate = srch1$.find('[name=srchShipReqDate]').val();
		onm.ajax({
			url: _contextPath_ + '/manage/center/dayCarAllHistList.json',
			data: data,
			success: function(res) {
				var datas = res.list;
				if( locationHistoryPolyline2 != null ){
					locationHistoryPolyline2.setMap(null);
					routeObjArray2 = new Array();
					locationHistoryPolyline2 = null;
				} else {
					$.CvoMap.DRAW.allRoute(datas);
				}
			}
		});

	});

	//그래프
	$('#chartBtn').on('click', function() {
		if ($.type(grid3$.getGridData()) !== 'array' || grid3$.getGridData().length === 0) {
			onm.alert('그래프에 표출 할 데이터가 없습니다.');
			return false;
		}

		onm.ajaxModal({
			url: _contextPath_ + '/manage/center/dayCargoTempAnalChartView.pop',
			dialogOptions: {
				title: '차량 온도 세부 내역',
				width: 1100,
				height: 500,
				open: function (event, ui) {
					var chartData = user.makeSeriesData();
					user.initChart(chartData);
				}
			}
		});
	});

	user.init();
});

var user = {
		init : function() {
			com.setCombo('select', srch1$, 'srchBizCd', '', com.getCdList('020'), '전체', 75);
			com.setCombo('select', srch1$, 'srchCenterCd', '', com.sAuthCenterList(), '전체');
			srch1$.find('[name=srchShipReqDate]').val(onm.todayFmt());
		},
		getPostData: function() {
			var postData = com.getData(srch1$);
			postData.paramPaginateRecordSize = 80;
			return postData;
		},
		getDeliData: function(data) {
			grid2$.setGridParam({postData: data}).trigger('reloadGrid');
		},
		getHistData: function(data) {
			data.srchShipReqDate = srch1$.find('[name=srchShipReqDate]').val();
			grid3$.setGridParam({postData: data}).trigger('reloadGrid');
		},
		getCenterData: function(data) {
			onm.ajax({
				url: _contextPath_ + '/manage/center/dayCarNowCenter.json',
				data: data,
				success: function(res) {
					var datas = res.list;
					$.each(datas, function (index, center) {
						$.CvoMap.DRAW.center(center);
					});

				}
			});
		},
		gapSecView : function(e, options, rowObject) {
			var viewStr = e;
			if ($.isNumeric(viewStr)) {
				if (parseInt(viewStr) >= 0) viewStr = "+" + viewStr + "분";
				else viewStr = viewStr + "분";
			}
			return viewStr;
		},
		bigoView : function(e, options, rowObject) {
			var viewStr = "";
			if (rowObject.tempDevDt != "" && rowObject.agentNm != "") {
				viewStr = "<span style='color:#0000FF'>" + (rowObject.agentNm).replace(/\|\|/gi, "<BR />") + "</span><BR /><span style='color:#FF0000;'>온도이탈</span>";
			} else if (rowObject.tempDevDt != "" && rowObject.agentNm == "") {
				viewStr = "<span style='color:#FF0000;'>온도이탈</span>";
			} else if (rowObject.tempDevDt == "" && rowObject.agentNm != "") {
				viewStr = "<span style='color:#0000FF'>" + (rowObject.agentNm).replace(/\|\|/gi, "<BR />") + "</span>";
			} else {
				viewStr = "";
			}
			return viewStr;
		},
		calendarView : function(e, options, rowObject) {
			return e.substring(5, 10);
		},
		spdView : function(e, options, rowObject) {
			return e+" km/h";
		},
		dayDisView : function(e, options, rowObject) {
			return e+" km";
		},
		tempView : function(e, options, rowObject) {
			var viewStr = e;
			if (viewStr != "-") {
				viewStr += "℃";
			}
			return viewStr;
		},
		// 지도 초기화
		mapInit: function() {
			$("#divView1").CvoMap();
		},
		makeSeriesData: function() {
			var i;
			var list = grid3$.getGridData();
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
				devDt = user.roundSec(row.fullDevDt);
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
}

</script>

<header>
	<!-- <div class="loc_info"><span>실시간 온도 모니터링 </span><span>센터관리</span><span>Home</span></div> -->
	<h2 class="content_title"><span>실시간 온도 모니터링 / 차량 창고 현황</span></h2>
</header>
<div id="main">
	<div class="colgroup-wrap">
		<div class="colgroup-tempnowl">
			<div class="monitoring-left">
				<div class="srch_box" id="divSrch1">
					<table>
						<colgroup>
							<col width="23%">
							<col width="30%">
							<col width="20%">
							<col width="*">
						</colgroup>
						<tr>
							<th>센터</th>
							<td>
								<select name="srchCenterCd"></select>
							</td>
						</tr>
						<tr>
							<th>운행일자</th>
							<td>
								<input type="text" name="srchShipReqDate"  class="calendar" />
							</td>
							<th>수배송</th>
							<td>
								<select name="srchBizCd"></select>
							</td>
						</tr>
						<tr>
							<th>선적번호</th>
							<td colspan="2">
								<input type="text" name="srchShipNo" maxlength="30" class="w90 enterSrch" />
							</td>
						</tr>
						<tr>
							<th>차량번호</th>
							<td colspan="2">
								<input type="text" name="srchCarNo" maxlength="30" class="w90 enterSrch" />
							</td>
							<td>
								<div class="srch_btn">
									<button type="button" id="srchBtn" class="btn_srch"><span class="ico_srch"></span>검색</button>
								</div>
							</td>
						</tr>
					</table>
				</div>

				<div class="caption-pnl">
						<h2>선적 정보</h2>
						<span style="left:270px;"><button type="button" id="btnGrid1Xls" class="btn_list" ><span class="ico_xls ico_only"></span></button></span>
				</div>
				<table id="grid1"></table>

				<div class="caption-pnl mT10">
						<h2>납품 정보</h2>
				</div>
				<table id="grid2"></table>

			</div>

		</div>
		<div class="colgroup-tempnowr">
			<div class="monitoring-map daycar" id="divView1">
			<div class="map_btn max" onclick="javascript:$.CvoMapLayer.HIDE.leftArea();" style="z-index:100;"></div>
			<div class="map_btn min"  onclick="javascript:$.CvoMapLayer.SHOW.leftArea();" style="z-index:100; display:none;"></div>
			<!-- <div class="ico_carloc start" style="z-index:100;"></div>
			<div class="ico_carloc center" style="z-index:100;"></div>
			<div class="ico_carloc nor" style="z-index:100;"></div>
			<div class="ico_carloc error" style="z-index:100;"></div>
			<div class="ico_carloc end" style="z-index:100;"></div> -->
			</div>

			<div class="caption-pnl mT10">
				<h2>운행경로 <span id="dtlCarNo">&nbsp;</span></h2>
				<span class="buttonset fr">
					<button type="button" class="btn_list_rd" id="totalHistBtn">전체 경로 조회</button>
					<button type="button" class="btn_list_rd" id="chartBtn">그래프</button>
					<button type="button" id="btnGrid3Xls" class="btn_list" ><span class="ico_xls ico_only"></span></button>
				</span>
			</div>
			<!-- <div id="grid3" style="height:160px" ></div> -->
			<table id="grid3"></table>
		</div>
	</div>
</div>