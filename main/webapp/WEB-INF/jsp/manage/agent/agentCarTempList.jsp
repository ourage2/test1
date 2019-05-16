<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script>
var srch$;
var grid1$;
var grid2$;

jQuery(function($) {
	srch$ = com.toBox($('#divSrch'));
	
	grid1$ = $('#grid1').jqGrid({
		url: _contextPath_ + '/manage/agent/agentCarTempList.json',
		height: 250,
		shrinkToFit: false,
		sortable: false,
		footerrow: true,
		colNames:[
			'순번', '대리점', '차량<br>소속', '차량<br>번호', '운전자', 
			'최고', '최저', '평일<br>평균', '휴일<br>평균',
			'1', '2', '3', '4', '5', '6', '7', '8', '9', '10', 
			'11', '12', '13', '14', '15', '16', '17', '18', '19', '20', 
			'21', '22', '23', '24', '25', '26', '27', '28', '29', '30', 
			'31',
			'CAR_ID'
		],
		cmTemplate: {
			align:'center'
		},
		colModel:[
			{name:'rnum', index:'rnum', width:30, align:'right', sortable:false},
			{name:'agentNm', index:'AGENT_NM', width:86},
			{name:'companyCd', index:'COMPANY_CD', width:80},
			{name:'carNo', index:'CAR_NO', width:80},
			{name:'drvNm', index:'DRV_NM', width:50},
			{name:'maxRt', index:'MAX_RT', width:50, formatter:'number'},
			{name:'minRt', index:'MIN_RT', width:50, formatter:'number'},
			{name:'normalRt', index:'NORMAL_RT', width:50, formatter:'number'},
			{name:'weekendRt', index:'WEEKEND_RT', width:50, formatter:'number'},
			{name:'day1', index:'day1', width:35, formatter:'number'},
			{name:'day2', index:'day2', width:35, formatter:'number'},
			{name:'day3', index:'day3', width:35, formatter:'number'},
			{name:'day4', index:'day4', width:35, formatter:'number'},
			{name:'day5', index:'day5', width:35, formatter:'number'},
			{name:'day6', index:'day6', width:35, formatter:'number'},
			{name:'day7', index:'day7', width:35, formatter:'number'},
			{name:'day8', index:'day8', width:35, formatter:'number'},
			{name:'day9', index:'day9', width:35, formatter:'number'},
			{name:'day10', index:'day10', width:35, formatter:'number'},
			{name:'day11', index:'day11', width:35, formatter:'number'},
			{name:'day12', index:'day12', width:35, formatter:'number'},
			{name:'day13', index:'day13', width:35, formatter:'number'},
			{name:'day14', index:'day14', width:35, formatter:'number'},
			{name:'day15', index:'day15', width:35, formatter:'number'},
			{name:'day16', index:'day16', width:35, formatter:'number'},
			{name:'day17', index:'day17', width:35, formatter:'number'},
			{name:'day18', index:'day18', width:35, formatter:'number'},
			{name:'day19', index:'day19', width:35, formatter:'number'},
			{name:'day20', index:'day20', width:35, formatter:'number'},
			{name:'day21', index:'day21', width:35, formatter:'number'},
			{name:'day22', index:'day22', width:35, formatter:'number'},
			{name:'day23', index:'day23', width:35, formatter:'number'},
			{name:'day24', index:'day24', width:35, formatter:'number'},
			{name:'day25', index:'day25', width:35, formatter:'number'},
			{name:'day26', index:'day26', width:35, formatter:'number'},
			{name:'day27', index:'day27', width:35, formatter:'number'},
			{name:'day28', index:'day28', width:35, formatter:'number'},
			{name:'day29', index:'day29', width:35, formatter:'number'},
			{name:'day30', index:'day30', width:35, formatter:'number'},
			{name:'day31', index:'day31', width:35, formatter:'number'},
			{name:'carId', index:'CAR_ID', width:35, hidden:true}
		],
		onSelectRow: function(rowId) {
			var rowData = $(this).getRowData(rowId);
			var postData = com.getData(srch$);
			postData.carId = rowData.carId;
			grid2$.setGridParam({postData: postData}).trigger('reloadGrid');
		}
	});
	
	grid1$.on('jqGridLoadComplete', function (event, data) {
		if (!data.hasOwnProperty('list') || 0 === data.list.length) {
			return false;
		}

		var grid$ = $(this);
		var colNmArr = [];

		$.each(grid$.getGridParam('colModel'), function (index, item) {
			var colNm = item.name;
			if (colNm.endsWith('Rt') || colNm.startsWith('day')) {
				colNmArr.push(colNm);
			}
		});

		var footerData = {
			centerNm: '계'
		};

		$.each(colNmArr, function (idx, item) {
			footerData[item] = grid$.jqGrid('getCol', item, false, 'avg');
		});

		grid$.footerData2('set', footerData);
	});
	
	grid2$ = $('#grid2').jqGrid({
		url: _contextPath_ + '/manage/agent/agentCarTempDtlList.json',
		height: 250,
		// postData: com.getData(srch$),
		colNames:[
			'순번', '일자', '차량구분', '전체온도건수', '적정온도건수', 
			'온도준수율', '전체온도건수', '적정온도건수', '온도준수율'
		],
		cmTemplate: {
			align:'center',
			sortable:false
		},
		colModel:[
			{name:'rnum', index:'rnum', width:4, align:'right'},
			{name:'restDate', index:'REST_DATE', width:12},
			{name:'restNm', index:'REST_NM', width:12},
			{name:'tempTotCnt1', index:'TEMP_TOT_CNT', width:12, formatter: 'integer'},
			{name:'tempHaccpNorCnt', index:'TEMP_HACCP_NOR_CNT', width:12, formatter: 'integer'},
			{name:'tempHaccpNorRt', index:'TEMP_HACCP_NOR_RT', width:12, formatter: 'number'},
			{name:'tempTotCnt2', index:'TEMP_TOT_CNT', width:12, formatter: 'integer'},
			{name:'tempNorCnt', index:'TEMP_NOR_CNT', width:12, formatter: 'integer'},
			{name:'tempNorRt', index:'TEMP_NOR_RT', width:12, formatter: 'number'}
		]
	});
	
	grid2$.setGroupHeaders({
		useColSpanStyle: true,
		groupHeaders: [
			{startColumnName: 'tempTotCnt1', numberOfColumns: 3, titleText: '정상차량 온도 준수율(0도 ~ 10도)'},
			{startColumnName: 'tempTotCnt2', numberOfColumns: 3, titleText: '정상차량 온도 준수율(0도 ~ 5도)'}
		]
	});

	//검색
	$('#srchBtn').on('click', function() {
		
		user.changeGrid1Header();
		
		grid1$.setGridParam({postData: com.getData(srch$)}).trigger('reloadGrid');
		grid1$.clearFooterData();
		
		grid2$.clearGridData();
	});

	user.mainInit();
});

var user = {
	//메인페이지 초기화
	mainInit : function() {
		
		com.setCombo('select', srch$, 'srchCarAnalDiv', '', com.getCdList('CAR_ANAL_DIV', {etc1: 'TEMP'}));
		com.setCombo('select', srch$, 'srchBizCd', '', com.getCdList('020'));
		
		//검색조건 기본값 설정
		srch$.find('[name=srchStrDt]').val(onm.getBeforeMonth());
		srch$.find('[name=srchEndDt]').val(onm.todayFmt());
		
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
				bgArr.push('white');
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
					<col style="width: 7%">
					<col style="width: 10%">
					
					<col style="width: 7%">
					<col style="width: 20%">
					
					<col style="width: 9%">
					<col style="width: 12%">
					
					<col style="width: 7%">
					<col style="width: 9%">
					
					<col style="width: auto">
				</colgroup>

				<tr>
					
					<th>세부지표</th>
					<td>
						<select name="srchCarAnalDiv"></select>
					</td>
					
					<th>조회기간</th>
					<td>
						<input type="text" name="srchStrDt" class="calendar" mindateid="srchEndDt" rangeday="srchEndDt,7,30" /> ~ <input type="text" name="srchEndDt" class="calendar" maxdateid="srchStrDt" rangeday="srchEndDt,7,30" />
					</td>
					
					<th>업무구분</th>
					<td>
						<select name="srchBizCd"></select>
					</td>
					
					<th>차량번호</th>
					<td>
						<input type="text" name="srchCarNo" />
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
			<h2><span class="x-icon"></span><span class="x-label">온도 준수율</span></h2>
		</div>
		<table id="grid1"></table>
	</div>
	<div class="colgroup-wrap mT20">
		<div class="caption-pnl">
			<h2><span class="x-icon"></span><span class="x-label">온도 준수율 상세</span></h2>
		</div>
		<table id="grid2"></table>
	</div>
</div>