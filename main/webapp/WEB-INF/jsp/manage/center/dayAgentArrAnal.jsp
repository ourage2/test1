<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script>
var srch$;
var grid1$;
var grid2$;

jQuery(function($) {
	srch$ = com.toBox($('#divSrch'));
	
	grid1$ = $('#grid1').jqGrid({
		url: _contextPath_ + '/manage/center/dayAgentArrAnal.json',
		height: 180,
		postData: com.getData(srch$),
		colNames:[
			'순번', '센터', '전체건수', '도착건수', '미도착건수',
			'정시', '위반', '정시도착율(%)', '정시', '위반',
			'정시도착율(%)', '차이(%)', 'CENTER_CD'
		],
		cmTemplate: {
			align:'center',
			sortable:false
		},
		colModel:[
			{name:'rnum', index:'rnum', width:3, align:'right'},
			{name:'centerNm', index:'CENTER_NM', width:13},
			{name:'deliPlanCnt', index:'DELI_PLAN_CNT', width:7, formatter: 'integer'},
			{name:'arrTotCnt', index:'ARR_TOT_CNT', width:7, formatter: 'integer'},
			{name:'inCompCnt', index:'IN_COMP_CNT', width:7, formatter: 'integer'},
			
			{name:'arrAgentNorCnt', index:'ARR_AGENT_NOR_CNT', width:7, formatter: 'integer'},
			{name:'arrAgentVioCnt', index:'ARR_AGENT_VIO_CNT', width:7, formatter: 'integer'},
			{name:'arrAgentNorRt', index:'ARR_AGENT_NOR_RT', width:7, formatter: 'number'},
			{name:'arrNorCnt', index:'ARR_NOR_CNT', width:7, formatter: 'integer'},
			{name:'arrVioCnt', index:'ARR_VIO_CNT', width:7, formatter: 'integer'},
			
			{name:'arrNorRt', index:'ARR_NOR_RT', width:7, formatter: 'number'},
			{name:'difRt', index:'DIF_RT', width:7, formatter: 'number'},
			{name:'centerCd', index:'CENTER_CD', width:7, hidden:true}
		],
		onSelectRow: function (rowId) {
			var postData = user.getGrid2PostData();
			grid2$.setGridParam({postData: postData}).trigger('reloadGrid');
		}
	});
	
	grid2$ = $('#grid2').jqGrid({
		url: _contextPath_ + '/manage/center/dayAgentArrAnalDtlList.json',
		pager:'#grid2Pg',
		height: 180,
		postData: com.getData(srch$),
		colNames:[
			'순번', '센터', '차량소속', '차량번호', '운전자',
			'차량구분', '납품완료건', '정시', '위반', '정시도착률',
			'정시', '위반', '정시도착률', '차이', 'stdDate',
			'carId', 'centerCd', 'drvTelNo', 'drvHpNo'
		],
		cmTemplate: {
			align:'center',
			sortable:false
		},
		colModel:[
			{name:'rnum', index:'rnum', width:3, align:'right'},
			{name:'centerNm', index:'CENTER_NM', width:9},
			{name:'companyNm', index:'COMPANY_NM', width:12},
			{name:'carNo', index:'CAR_NO', width:9},
			{name:'drvNm', index:'DRV_NM', width:9},
			
			{name:'restNm', index:'REST_NM', width:9},
			{name:'arrTotCnt', index:'ARR_TOT_CNT', width:7, formatter: 'integer'},
			{name:'arrAgentNorCnt', index:'ARR_AGENT_NOR_CNT', width:7, formatter: 'integer'},
			{name:'arrAgentVioCnt', index:'ARR_AGENT_VIO_CNT', width:7, formatter: 'integer'},
			{name:'arrAgentNorRt', index:'ARR_AGENT_NOR_RT', width:7, formatter: 'number'},
			
			{name:'arrNorCnt', index:'ARR_NOR_CNT', width:7, formatter: 'integer'},
			{name:'arrVioCnt', index:'ARR_VIO_CNT', width:7, formatter: 'integer'},
			{name:'arrNorRt', index:'ARR_NOR_RT', width:7, formatter: 'number'},
			{name:'difRt', index:'DIF_RT', width:7, formatter: 'number'},
			{name:'stdDate', index:'STD_DATE', hidden:true},
			
			{name:'carId', index:'CAR_ID', hidden:true},
			{name:'centerCd', index:'CENTER_CD', hidden:true},
			{name:'drvTelNo', index:'DRV_TEL_NO', hidden:true},
			{name:'drvHpNo', index:'DRV_HP_NO', hidden:true}
		]
	});
	
	grid1$.setGroupHeaders({
		useColSpanStyle: true,
		groupHeaders: [
			{startColumnName: 'arrAgentNorCnt', numberOfColumns: 3, titleText: '도착시간구간설정반영'},
			{startColumnName: 'arrNorCnt', numberOfColumns: 3, titleText: '도착시간±30분반영'}
		]
	});
	
	grid2$.setGroupHeaders({
		useColSpanStyle: true,
		groupHeaders: [
			{startColumnName: 'arrAgentNorCnt', numberOfColumns: 3, titleText: '도착시간구간설정반영'},
			{startColumnName: 'arrNorCnt', numberOfColumns: 3, titleText: '도착시간±30분반영'}
		]
	});

	//검색
	$('#srchBtn').on('click', function() {
		grid2$.clearGridData();
		grid1$.setGridParam({postData: com.getData(srch$)}).trigger('reloadGrid');
	});
	
	// 엑셀다운로드
	$('#xlsBtn1').on('click', function () {
		cvo.ajaxFileDown({url: _contextPath_ + '/manage/center/dayAgentArrAnal.xls', data: com.getData(srch$)});
	});

	//엑셀다운로드
	$('#xlsBtn2').on('click', function () {
		cvo.ajaxFileDown({url: _contextPath_ + '/manage/center/dayAgentArrAnalDtlList.xls', data: user.getGrid2PostData()});
	});

	user.mainInit();
});

var user = {
	//메인페이지 초기화
	mainInit : function() {
		
		com.setCombo('select', srch$, 'srchCenterCd', '', com.sAuthCenterList());
		com.setCombo('select', srch$, 'srchBizCd', '', com.getCdList('020'));
		
		//검색조건 기본값 설정
		var maxDate = onm.addDate(new Date(), -1);
		srch$.find('input[name=srchDt]')
			.datepicker('option', 'maxDate', maxDate)
			.val(onm.formatDate(maxDate));
		
		$('#srchBtn').trigger('click');
	},
	
	getGrid2PostData: function () {
		var rowData = grid1$.getSelGridData()[0];
		var postData = grid1$.getGridParam('postData');
		postData.centerCd = rowData.centerCd;
		return postData;
	}
}
</script>

<header>
	<div id="divSrch">
		<div class="loc_info"><span>일자별대리점 정시도착률</span><span>센터 관리</span><span>Home</span></div>
		<h2 class="content_title"><span>일자별대리점 정시도착률</span></h2>
		<div class="srch_box">
			<table>
				<colgroup>
					<col style="width: 5%">
					<col style="width: 14%">
					
					<col style="width: 7%">
					<col style="width: 10%">
					
					<col style="width: 9%">
					<col style="width: 10%">
					
					<col style="width: auto">
				</colgroup>
				
				<tr>
					<th>센터</th>
					<td>
						<select name="srchCenterCd" class="chosen" multiple data-placeholder="전체"></select>
					</td>

					<th>조회일자</th>
					<td>
						<input type="text" name="srchDt" class="calendar" />
					</td>
					
					<th>차량업무구분</th>
					<td>
						<select name="srchBizCd"></select>
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
			<h2><span class="x-icon"></span><span class="x-label">대리점 정시 도착률</span></h2>
			<span class="buttonset fr">
				<button type="button" id="xlsBtn1" class="btn_list" ><span class="ico_xls ico_only"></span></button>
			</span>
		</div>
		<table id="grid1"></table>
	</div>
	<div class="colgroup-wrap mT20">
		<div class="caption-pnl">
			<h2><span class="x-icon"></span><span class="x-label">차량별 대리점 도착률</span></h2>
			<span class="buttonset fr">
				<button type="button" id="xlsBtn2" class="btn_list" ><span class="ico_xls ico_only"></span></button>
			</span>
		</div>
		<table id="grid2"></table>
		<div id="grid2Pg"></div>
	</div>
</div>