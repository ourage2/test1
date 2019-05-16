<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script>
var srch$;
var grid1$;
var grid2$;

jQuery(function($) {
	srch$ = com.toBox($('#divSrch'));

	//검색
	$('#srchBtn').on('click', function() {
		grid2$.clearGridData();
		grid1$.setGridParam({postData: com.getData(srch$)}).trigger('reloadGrid');
	});

	user.mainInit();
	
	$.when(user.agentChList())
		.then(function (res) {
			
			user.gridInit(res.list);
			
			$('#srchBtn').trigger('click');
		})
	
});

var user = {
	
	gridInit: function(agentChList) {
		var colNames = ['순번', '센터', 'CENTER_CD', '전체평균'];
		var colModel = [
			{name:'rnum', index:'rnum', width:4, align:'right', sortable:false},
			{name:'centerNm', index:'CENTER_NM', width:10},
			{name:'centerCd', index:'CENTER_CD', width:10, hidden:true},
			{name:'totRt', index:'TOT_RT', width:10, formatter:'number'}
		];
	
		$.each(agentChList, function (idx, item) {
			colNames.push(item.chNm);
			colModel.push({
				name: onm.toCamelCase(item.ch.toLowerCase()),
				index: item.ch,
				width: 10,
				formatter:'number'
			});
		});
		
		grid1$ = $('#grid1').jqGrid({
			url: _contextPath_ + '/manage/center/dayChArrAnal.json',
			height: 180,
			postData: com.getData(srch$),
			colNames: colNames,
			cmTemplate: {
				align:'center'
			},
			colModel: colModel,
			onSelectRow: function(rowId) {
				var rowData = $(this).getRowData(rowId);
				var postData = $(this).getGridParam('postData');
				postData.centerCd = rowData.centerCd;
				
				grid2$.setGridParam({postData: postData}).trigger('reloadGrid')
			}
		});
		
		grid2$ = $('#grid2').jqGrid({
			url: _contextPath_ + '/manage/center/dayChArrAnalDtl.json',
			height: 180,
			postData: com.getData(srch$),
			colNames:[
				'순번', '센터', '채널명', '전체건수', '보고건수', 
				'정시도착건수', '전송율', '정시도착율'
			],
			cmTemplate: {
				align:'center'
			},
			colModel:[
				{name:'rnum', index:'rnum', width:3, align:'right', sortable:false},
				{name:'centerNm', index:'CENTER_NM', width:13},
				{name:'chNm', index:'CH_NM', width:14},
				{name:'totCnt', index:'TOT_CNT', width:14, formatter:'integer'},
				{name:'arrCnt', index:'ARR_CNT', width:14, formatter:'integer'},
				{name:'norCnt', index:'NOR_CNT', width:14, formatter:'integer'},
				{name:'txRt', index:'TX_RT', width:14, formatter:'number'},
				{name:'norRt', index:'NOR_RT', width:14, formatter:'number'}
			]
		});
	},
	
	//메인페이지 초기화
	mainInit : function() {
		
		com.setCombo('select', srch$, 'srchCenterCd', '', com.sAuthCenterList());
		com.setCombo('select', srch$, 'srchBizCd', '', com.getCdList('020'));
		
		//검색조건 기본값 설정
		srch$.find('[name=srchStrDt]').val(onm.getBeforeMonth());
		srch$.find('[name=srchEndDt]').val(onm.todayFmt());
		
		// $('#srchBtn').trigger('click');
	},
	
	agentChList: function() {
		var deferred = $.Deferred();

		onm.ajax({
			url: _contextPath_ + '/cmn/objList.json',
			data: {'queryId': 'center.agentChList'},
			success: function (res) {
				deferred.resolve(res);
			},
			error: function() {
				deferred.reject();
			}
		});
		
		return deferred;
	}
}
</script>

<header>
	<div id="divSrch">
		<div class="loc_info"><span>일자별채널별 정시도착률</span><span>센터 관리</span><span>Home</span></div>
		<h2 class="content_title"><span>일자별채널별 정시도착률</span></h2>
		<div class="srch_box">
			<table>
				<colgroup>
					<col style="width: 5%">
					<col style="width: 14%">
					
					<col style="width: 7%">
					<col style="width: 20%">
					
					<col style="width: 9%">
					<col style="width: 10%">
					
					<col style="width: auto">
				</colgroup>

				<tr>
					<th>센터</th>
					<td>
						<select name="srchCenterCd" class="chosen" multiple data-placeholder="전체"></select>
					</td>
					
					<th>조회기간</th>
					<td>
						<input type="text" name="srchStrDt" class="calendar" mindateid="srchEndDt" /> ~ <input type="text" name="srchEndDt" class="calendar" maxdateid="srchStrDt" />
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
			<h2><span class="x-icon"></span><span class="x-label">물류 채녈별 정시 도착률</span></h2>
		</div>
		<table id="grid1"></table>
	</div>
	<div class="colgroup-wrap mT20">
		<div class="caption-pnl">
			<h2><span class="x-icon"></span><span class="x-label">물류 채널별 세부 정시 도착률</span></h2>
		</div>
		<table id="grid2"></table>
	</div>
</div>