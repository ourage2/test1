<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script>
var grid1$;
var srch$;

jQuery(function($) {
	srch$ = com.toBox($('#divSrch'));

	grid1$ = $('#grid1').jqGrid({
		url: _contextPath_ + '/manage/crate/sapIfResultList.json',
		pager:'#grid1Pg',
		height: 480,
		scrollrows: true,
		postData: com.getData(srch$),
		colNames:['순번', '센터명', '납품예정일', '선적번호', '납품번호', '출고수량전송여부', '회수수량전송여부', '업무완료여부', '수동전송'],
		cmTemplate: {
			align:'center'
		},
		colModel:[
			{name:'rnum', index:'rnum', width:3, align:'right', sortable:false},
			{name:'centerNm', index:'CENTER_NM', width:10},
			{name:'shipReqDate', index:'SHIP_REQ_DATE', width:10},
			{name:'shipNo', index:'A.SHIP_NO', width:10},
			{name:'deliNo', index:'B.DELI_NO', width:10},
			{name:'outCntIfStat', index:'OUT_CNT_IF_STAT', width:10},
			{name:'inCntIfStat', index:'IN_CNT_IF_STAT', width:10},
			{name:'deliYn', index:'DELI_YN', width:10},
			{name:'canManualSend', index:'CAN_MANUAL_SEND', width:10, sortable:false, formatter:formatManualSendBtn, hidden: !com.updateAuthChk()}
		]
	});
	
	function formatManualSendBtn(cellvalue, options, rowObject) {
		if (cellvalue == 'Y') {
			return '<button class="btn_list_rd"><span class="ico_apply"></span>수동전송</button>';
		}
		else
			return '';
	}

	//검색
	$('#srchBtn').on('click', function() {
		grid1$.setGridParam({postData: com.getData(srch$)}).trigger('reloadGrid');
	});
	
	//엑셀다운로드
	$('#xlsBtn').on('click', function() {
		cvo.ajaxFileDown({url: _contextPath_ + '/manage/crate/sapIfResultList.xls', data: com.getData(srch$)});
	});
	
	grid1$.on('click', '[aria-describedby=grid1_canManualSend] button', user.sapIfManualSend);

	user.mainInit();
});
	
var user = {
	//메인페이지 초기화
	mainInit : function() {
		
		com.setCombo('select', srch$, 'srchCenterCd', '', com.sAuthCenterList());
		
		//검색조건 기본값 설정
		srch$.find('[name=srchStrDt]').val(onm.getBeforeMonth());
		srch$.find('[name=srchEndDt]').val(onm.todayFmt());
		
		$('#srchBtn').trigger('click');
	},

	sapIfManualSend: function (event) {
		var rowid = $(this).closest('tr').attr('id');
		var rowData = grid1$.getRowData(rowid);

		var sendData = {
			shipNo: rowData.shipNo,
			deliNo: rowData.deliNo
		};
		
		onm.ajax({
			url: _contextPath_ + '/manage/crate/sapIfManualSend.json',
			data: sendData,
			success: function () {
				var postData = grid1$.getGridParam('postData');
				grid1$.trigger('reloadGrid', {page: postData.pg, current: true});
			}
		});
	}
}
</script>

<header>
	<div id="divSrch">
		<div class="loc_info"><span>SAP전송여부조회</span><span>크레이트 관리</span><span>Home</span></div>
		<h2 class="content_title"><span>SAP전송여부조회</span></h2>
		<div class="srch_box">
			<table>
				<colgroup>
					<col width="7%">
					<col width="10%">
					<col width="7%">
					<col width="10%">
					<col width="7%">
					<col width="10%">
					<col width="7%">
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
					
					<th>납품번호</th>
					<td>
						<input type="text" name="srchDeliNo" maxlength="10" class="enterSrch" />
					</td>
					
					<th>조회기간</th>
					<td>
						<input type="text" name="srchStrDt" class="calendar" mindateid="srchEndDt" /> ~ <input type="text" name="srchEndDt" class="calendar" maxdateid="srchStrDt" />
					</td>
				</tr>
				<tr>
					<th>전송여부</th>
					<td colspan="6">
						<select name="srchSendStat">
							<option value="">전체</option>
							<option value="R">전송대기</option>
							<option value="M">미전송</option>
							<option value="Y">성공</option>
							<option value="N">실패</option>
						</select>
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