<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script>
jQuery(function($) {

	popupView1$ = com.toBox($('#popupDivView1'));

	// 저장 클릭
	$("#btnView1Save").on('click', function(){ user.inOutCntAdjSave('U'); });

	popupGrid1$ = $('#popupGrid1').jqGrid({
		url: _contextPath_ + '/manage/crate/inOutCntAdjList.json',
		height: 240,
		postData: grid1$.getSelGridData()[0],
		colNames:['순번', '납품요청일', '선적번호', '대리점코드', '대리점명', '남품번호', '포장재항목', '전산출고수', '하차수', '하차조정수', '회수수', '회수조정수', '사유', 'pkgCd'],
		colModel:[
			{name:'rnum', index:'rnum', width:29, align:'right', sortable:false},
			{name:'shipReqDate', index:'SHIP_REQ_DATE', width:96, align:'center', sortable:false},
			{name:'shipNo', index:'SHIP_NO', width:96, align:'center', sortable:false},
			{name:'agentCd', index:'AGENT_CD', width:10, align:'center', sortable:false, hidden:true},
			{name:'agentNm', index:'AGENT_NM', width:96, align:'center', sortable:false},
			{name:'deliNo', index:'DELI_NO', width:96, align:'center', sortable:false},
			{name:'pkgNm', index:'PKG_NM', width:96, align:'center', sortable:false},
			{name:'sapOutCnt', index:'SAP_OUT_CNT', width:96, align:'center', sortable:false},
			{name:'outCnt', index:'OUT_CNT', width:96, align:'center', sortable:false},
			{name:'outAdjCnt', index:'OUT_ADJ_CNT', width:96, align:'center', sortable:false},
			{name:'inCnt', index:'IN_CNT', width:96, align:'center', sortable:false},
			{name:'inAdjCnt', index:'IN_ADJ_CNT', width:96, align:'center', sortable:false},
			{name:'adjDesc', index:'ADJ_DESC', width:101, align:'center', sortable:false},
			{name:'pkgCd', index:'PKG_CD', width:10, align:'center', hidden:true}
		],

		onSelectRow: function(rowId) {
			com.setVal(popupView1$, popupGrid1$.getRowData(rowId));
		}
	});

	user.inOutCntAdjInit();
});

</script>

<div class="popup-content" style="width:1200px;">
	<div class="colgroup-wrap mT20s">
		<table id="popupGrid1"></table>
	</div>
	<div class="colgroup-wrap mT20">
		<div id="popupDivView1">
			<div class="caption-pnl">
				<h2><span class="x-icon"></span><span class="x-label">메시지 상세정보</span></h2>
				<span class="buttonset fr">
					<button type="button" class="dosubmit" id="btnView1Save">저장</button>
				</span>
			</div>

			<table class="dtl_tbl">
				<colgroup>
					<col width="7%">
					<col width="17%">

					<col width="7%">
					<col width="17%">

					<col width="7%">
					<col width="17%">

					<col width="7%">
					<col width="17%">
				</colgroup>
				<tbody>
					<tr>
						<th>납품요청일</th>
						<td><input type="text" name="shipReqDate" read /></td>

						<th>선적번호</th>
						<td><input type="text" name="shipNo" read /></td>

						<th>대리점명</th>
						<td><input type="text" name="agentNm" read /></td>

						<th>납품번호</th>
						<td><input type="text" name="deliNo" read /></td>
					</tr>
					<tr>
						<th>포장재항목</th>
						<td><input type="text" name="pkgNm" read /></td>

						<th>전산출고수</th>
						<td><input type="text" name="sapOutCnt" read /></td>

						<th>하차수</th>
						<td><input type="text" name="outCnt" read /></td>

						<th class="state-required">하차조정수</th>
						<td><input type="text" name="outAdjCnt" maxlength="10" /></td>
					</tr>
					<tr>
						<th>회수수</th>
						<td><input type="text" name="inCnt" read /></td>

						<th class="state-required">회수조정수</th>
						<td><input type="text" name="inAdjCnt" maxlength="10" /></td>

						<th class="state-required">사유</th>
						<td colspan="3">
							<textarea name="adjDesc" maxlength="1000" cols="50" rows="4" placeholder="내용을 입력해 주세요."></textarea>
						</td>
					</tr>

				</tbody>
			</table>
		</div>
	</div>
</div>