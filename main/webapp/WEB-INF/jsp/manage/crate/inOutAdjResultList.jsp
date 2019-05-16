<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script>
var grid1$;
var srch$;

jQuery(function($) {
	srch$ = com.toBox($('#divSrch'));

	grid1$ = $('#grid1').jqGrid({
		url: _contextPath_ + '/manage/crate/inOutAdjResultList.json',
		pager:'#grid1Pg',
		height: 480,
		postData: com.getData(srch$),
		colNames:['순번', '납품요청일', '선적번호', '차량번호', '납품번호', '대리점코드', '대리점명', '포장재항목', '현재<br/>출고수량', '전산<br/>출고수량', '하차수량', '하차<br/>조정수량', '회수수량', '회수<br/>조정수량'],
		cmTemplate: {
			align:'center'
		},
		colModel:[
			{name:'rnum', index:'rnum', width:4, align:'right', sortable:false},
			{name:'shipReqDate', index:'DELI.SHIP_REQ_DATE', width:10},
			{name:'shipNo', index:'DELI.SHIP_NO', width:10},
			{name:'carId', index:'DELI.CAR_ID', width:10},
			{name:'deliNo', index:'DELI_DTL.DELI_NO', width:10},
			{name:'agentCd', index:'DELI_DTL.AGENT_CD', width:10},
			{name:'agentNm', index:'DELI_DTL.AGENT_NM', width:10},
			{name:'pkgNm', index:'CD_NM', width:10},
			{name:'outCnt', index:'PKG.OUT_CNT', width:7},
			{name:'sapOutCnt', index:'SAP_OUT_CNT', width:7},
			{name:'agentOutCnt', index:'PKG_AGENT.OUT_CNT', width:7},
			{name:'agentOutAdjCnt', index:'PKG_AGENT.OUT_ADJ_CNT', width:7},
			{name:'agentInCnt', index:'PKG_AGENT.IN_CNT', width:7},
			{name:'agentInAdjCnt', index:'PKG_AGENT.IN_ADJ_CNT', width:7}
		]
	});

	//검색
	$('#srchBtn').on('click', function() {
		grid1$.setGridParam({postData: com.getData(srch$)}).trigger('reloadGrid');
	});
	
	//엑셀다운로드
	$('#xlsBtn').on('click', function() {
		cvo.ajaxFileDown({url: _contextPath_ + '/manage/crate/inOutAdjResultList.xls', data: com.getData(srch$)});
	});

	user.mainInit();
});
	
var user = {
	//메인페이지 초기화
	mainInit : function() {
		
		com.setCombo('select', srch$, 'srchCenterCd', '', com.sAuthCenterList());
		
		com.setCombo('select', srch$, 'srchPkgCd', '', com.getCdList('PKG_CD'), '전체');
		
		//검색조건 기본값 설정
		srch$.find('[name=srchStrDt]').val(onm.getBeforeMonth());
		srch$.find('[name=srchEndDt]').val(onm.todayFmt());
		
		$('#srchBtn').trigger('click');
	}
}
</script>

<header>
	<div id="divSrch">
		<div class="loc_info"><span>관리자수정 이력조회</span><span>크레이트 관리</span><span>Home</span></div>
		<h2 class="content_title"><span>관리자수정 이력조회</span></h2>
		<div class="srch_box">
			<table>
				<colgroup>
					<col width="7%">
					<col width="14%">
					<col width="7%">
					<col width="8%">
					<col width="7%">
					<col width="8%">
					<col width="6%">
					<col width="10%">
					<col width="*">
				</colgroup>
				<tr>
					<th>센터</th>
					<td>
						<select name="srchCenterCd" class="chosen" multiple data-placeholder="전체"></select>
					</td>
					
					<th>선적번호</th>
					<td>
						<input type="text" name="srchShipNo" maxlength="10" class="enterSrch" />
					</td>
					
					<th>차량번호</th>
					<td>
						<input type="text" name="srchCarId" maxlength="10" class="enterSrch" />
					</td>
					
					<th>포장재</th>
					<td>
						<select name="srchPkgCd"></select>
					</td>
					
					<td>
					</td>
				</tr>
				
				<tr>
					<th>조회기간</th>
					<td colspan="7">
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
			<span class="buttonset fr">
				<button type="button" id="xlsBtn" class="btn_list" ><span class="ico_xls ico_only"></span></button>
			</span>
		</div>
		<table id="grid1"></table>
		<div id="grid1Pg"></div>
	</div>
</div>