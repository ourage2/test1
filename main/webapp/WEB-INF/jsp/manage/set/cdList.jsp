<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script>
var srch$;
var view1$;
var view2$;
var grid1$;
var grid2$;

jQuery(function($) {
	srch$ = com.toBox($('#divSrch'));
	view1$ = com.toBox($('#divView1'));
	view2$ = com.toBox($('#divView2'));

	grid1$ = $('#grid1').jqGrid({
		url: _contextPath_ + '/manage/set/grpCdList.json',
		height: 300,
		postData: com.getData(srch$),
		colNames:['순번', '그룹코드', '그룹코드명', '사용여부', 'aplStrDd', 'aplEndDd', 'grpDesc', 'grpUseYn'],
		colModel:[
			{name:'rnum', index:'rnum', width:4, align:'right', sortable:false},
			{name:'grpCd', index:'GRP_CD', width:8, key: true},
			{name:'grpNm', index:'GRP_NM', width:9},
			{name:'useYnNm', index:'USE_YN', width:4},
			{name:'aplStrDd', index:'APL_STR_DD', hidden: true},
			{name:'aplEndDd', index:'APL_END_DD', hidden: true},
			{name:'grpDesc', index:'GRP_DESC', hidden: true},
			{name:'grpUseYn', index:'USE_YN', hidden: true},
		],

		onSelectRow: function(rowId) {
			com.init(view2$, true);
			com.setVal(view1$, grid1$.getRowData(rowId));
			grid2$.setGridParam({postData: {'grpCd': String(rowId)} }).trigger('reloadGrid');
		}
	});

	grid2$ = $('#grid2').jqGrid({
		url:  _contextPath_ + '/manage/set/cdList.json',
		height: 300,
// 		multiselect: true,
// 		postData: com.getData(srch$),
		colNames:['순번', '그룹코드', '코드', '코드명', '사용여부', '정렬번호', 'grpNm', 'aplStrDd', 'aplEndDd', 'cdDesc', 'etc1', 'etc2', 'etc3', 'useYn'],
		colModel:[
			{name:'rnum', index:'rnum', width:4, align:'right', sortable:false},
			{name:'grpCd', index:'GRP_CD', width:6, sortable:false},
			{name:'cd', index:'CD', width:7, key: true},
			{name:'cdNm', index:'CD_NM', width:9},
			{name:'useYnNm', index:'USE_YN', width:4},
			{name:'seq', index:'SEQ', width:4},
			{name:'grpNm', index:'GRP_NM', hidden: true},
			{name:'aplStrDd', index:'APL_STR_DD', hidden: true},
			{name:'aplEndDd', index:'APL_END_DD', hidden: true},
			{name:'cdDesc', index:'CD_DESC', hidden: true},
			{name:'etc1', index:'ETC1', hidden: true},
			{name:'etc2', index:'ETC2', hidden: true},
			{name:'etc3', index:'ETC3', hidden: true},
			{name:'useYn', index:'USE_YN', hidden: true},
		],

		onSelectRow: function(rowId) {
			com.setVal(view2$, grid2$.getRowData(rowId));
		}
	});

	$('#btnView1New').on('click', function() {user.grpCdInit();}); //그룹코드 신규
	$('#btnView1Save').on('click', function() {user.grpCdSave(com.getFlag(view1$));}); //그룹코드 저장
	$('#btnView1Del').on('click', function() {user.grpCdSave('D');}); //그룹코드 삭제

	$('#btnView2New').on('click', function() {user.cdInit();}); //코드 신규
	$('#btnView2Save').on('click', function() {user.cdSave(com.getFlag(view2$));}); //코드 저장
	$('#btnView2Del').on('click', function() {user.cdSave('D');}); //코드 삭제

	$('#btnGrid2Del').on('click', function() {user.cdBatchSave('D');}); //일괄삭제
	//엑셀다운로드
// 	$('#btnGrid2Xls').on('click', function() {
// 		cvo.ajaxFileDown({url: _contextPath_ + '/manage/set/grpCdList.xls', data: com.getData(srch$)});
// 	});


	//검색
	$('#srchBtn').on('click', function() {
		grid2$.clearGridData();
		com.init(view1$, true);
		com.init(view2$, true);
		grid1$.setGridParam({postData: com.getData(srch$)}).trigger('reloadGrid');
	});


	user.init();
});

var user = {
	//페이지 초기화
	init : function() {
		com.init(view1$, true);
		com.init(view2$, true);
		$('#srchBtn').trigger('click');
	},

	//그룹코드 신규
	grpCdInit: function() {
		com.init(view1$, false);
		com.setFlag(view1$, 'C');

		view1$.find('[name=grpUseYn][value=Y]').prop('checked', true);
	},

	//그룹코드 저장
	grpCdSave: function(action) {
		if (action == 'D') {
			if (grid2$.getGridParam('records') > 0) {
				onm.alert('해당 그룹코드에 상세코드가 존재합니다.');
				return;
			}
			if (!confirm('사용중인 코드를 삭제할 시 시스템에 영향을 끼칠 수 있습니다.\n정말 삭제하시겠습니까?')) { return false; }
		}

		onm.ajax({
			url: _contextPath_ + '/manage/set/grpCdSave.json',
			beforeSend: function() {
				if (!com.beforeChk(view1$, action)) { return false; } //저장전 flag 체크
				if (action != 'D') {if(!user.valid(view1$)) { return false; }} //입력값유효성 체크
				if (action != 'D') {if(!user.bizValid(view1$)) { return false; }} //업무유효성 체크
			},
			data: com.set(view1$, action),
			success: function(res) {
				com.afterSave(res, view1$, action, true);
				$('#srchBtn').trigger('click');
			}
		});
	},

	//코드 신규
	cdInit: function() {
		if (!grid1$.getGridParam('selrow')) {
			onm.alert('선택된 그룹코드가 없습니다.');
			return;
		}

		com.init(view2$, false);
		com.setFlag(view2$, 'C');

		var row = grid1$.getRowData(grid1$.getGridParam('selrow'));
		view2$.find('[name=grpCd]').val(row.grpCd);
		view2$.find('[name=grpNm]').val(row.grpNm);
		view2$.find('[name=seq]').attr('readonly', true);
		view2$.find('[name=useYn][value=Y]').prop('checked', true);
	},

	//코드 저장
	cdSave: function(action) {
		if (action == 'D') {
			if (!confirm('사용중인 코드를 삭제할 시 시스템에 영향을 끼칠 수 있습니다.\n정말 삭제하시겠습니까?')) { return false; }
		}

		//pk수정시 데이터 기존키값 추가 전달(cd)
		var data = com.set(view2$, action);
		if (action == 'U' && view2$.find('[name=cd]').val() != grid2$.getGridParam('selrow')) {
			data.oldCd = grid2$.getGridParam('selrow');
		}

		onm.ajax({
			url: _contextPath_ + '/manage/set/cdSave.json',
			beforeSend: function() {
				if (!com.beforeChk(view2$, action)) { return false; } //저장전 flag 체크
				if (action != 'D') {if(!user.valid(view2$)) { return false; }} //입력값유효성 체크
				if (action != 'D') {if(!user.bizValid(view2$)) { return false; }} //업무유효성 체크
			},
			data: data,
			success: function(res) {
				com.afterSave(res, view2$, action, true);
				com.init(view2$, true);
// 				com.setVal(view1$, grid1$.getRowData(rowId));
				grid2$.setGridParam({postData: {'grpCd': grid1$.getGridParam('selrow')} }).trigger('reloadGrid');
			}
		});
	},

	//코드 일괄 삭제
// 	cdBatchSave: function(action) {
// 		if (action == 'D') {
// 			if (grid2$.getGridParam('selarrrow').length <= 0) {
// 				onm.alert('선택된 행이 없습니다.');
// 				return;
// 			}
// 			if (!confirm('사용중인 코드를 삭제할 시 시스템에 영향을 끼칠 수 있습니다.\n정말 삭제하시겠습니까?')) {
// 				return;
// 			}
// 		}

// 		var data = com.set(view2$, action);
// 		data.grpCd = grid1$.getGridParam('selrow');
// 		data.cdArry = grid2$.getGridParam('selarrrow');
// 		onm.ajax({
// 			url: _contextPath_ + '/manage/set/cdSave.json',
// 			data: data,
// 			success: function(res) {
// 				com.afterSave(res, view2$, action, true);
// 				com.init(view2$, true);
// 				grid2$.setGridParam({postData: {'grpCd': grid1$.getGridParam('selrow')} }).trigger('reloadGrid');
// 			}
// 		});
// 	},

	//입력값 유효성 체크
	valid: function(area) {
		var isValid = com.validChk(area); //필수, 길이, 형식등의 유효성 체크
// 		if (!isValid) {} //화면별 유효성 체크
		return isValid;
	},

	//업무유효성 체크
	bizValid: function(area) {
		if (area.attr('id') == 'divView1') {
			return true;
		}
		if (area.attr('id') == 'divView2') {
			return true;
		}
	}
}
</script>

<header>
	<div id="divSrch">
		<div class="loc_info"><span>코드관리</span><span>환경설정</span><span>Home</span></div>
		<h2 class="content_title"><span>코드관리</span></h2>
		<div class="srch_box">
			<table>
				<colgroup>
					<col width="9%">
					<col width="20%">
					<col width="9%">
					<col width="20%">
					<col width="9%">
					<col width="20%">
					<col width="*">
				</colgroup>
				<tr>
					<th>사용여부</th>
					<td>
						<select name="srchUseYn">
							<option value="">전체</option>
							<option value="Y">사용</option>
							<option value="N">미사용</option>
						</select>
					</td>
					<th>그룹코드</th>
					<td>
						<input type="text" name="srchGrpCd" class="enterSrch" />
					</td>
					<th>그룹코드명</th>
					<td>
						<input type="text" name="srchGrpNm" class="enterSrch" />
					</td>
					<td>
						<div class="srch_btn">
							<button type="button" id="srchBtn" class="btn_srch"><span class="ico_srch"></span>검색</button>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</div>
</header>

<div id="main">
	<div class="colgroup-wrap">
		<div class="colgroup-1-3">
			<div class="caption-pnl">
				<h2>그룹코드</h2>
			</div>
			<table id="grid1"></table>
		</div>
		<div class="colgroup-2-3">
			<div class="caption-pnl">
				<h2>상세코드</h2>
				<span class="buttonset fr">
<!-- 					<button type="button" class="btn_list_rd" id="btnGrid2Del"><span class="ico_del"></span>삭제</button> -->
				</span>
			</div>
			<table id="grid2"></table>
		</div>
	</div>

	<div class="colgroup-wrap mT20">
		<div class="colgroup-1-3" id="divView1">
			<div class="caption-pnl">
				<h2>그룹코드</h2>
				<span class="buttonset fr">
					<button type="button" class="btn_list_rd" id="btnView1New"><span class="ico_add"></span>신규</button>
					<button type="button" class="btn_list_rd" id="btnView1Save"><span class="ico_save"></span>저장</button>
					<button type="button" class="btn_list_rd" id="btnView1Del"><span class="ico_del"></span>삭제</button>
				</span>
			</div>
			<table class="dtl_tbl">
				<colgroup>
					<col width="30%">
					<col width="*">
				</colgroup>
				<tr>
					<th class="state-required"><span class="icon_key" title="key(중복주의)"></span>그룹코드</th>
					<td>
						<input type="text" name="grpCd" maxlength="20" read />
						<input type="hidden" name="aplStrDd" />
						<input type="hidden" name="aplEndDd" />
					</td>
				</tr>
				<tr>
					<th class="state-required">그룹코드명</th>
					<td><input type="text" name="grpNm" maxlength="50" /></td>
				</tr>
				<tr>
					<th>그룹코드상세</th>
					<td><input type="text" name="grpDesc" maxlength="500" /></td>
				</tr>
				<tr>
					<th>사용여부</th>
					<td>
						<label><input type="radio" name="grpUseYn" value="Y">사용</label>&nbsp;
						<label><input type="radio" name="grpUseYn" value="N">미사용</label>
					</td>
				</tr>
			</table>
		</div>

		<div class="colgroup-2-3" id="divView2">
			<div class="caption-pnl">
				<h2>상세코드</h2>
				<span class="buttonset fr">
					<button type="button" class="btn_list_rd" id="btnView2New"><span class="ico_add"></span>신규</button>
					<button type="button" class="btn_list_rd" id="btnView2Save"><span class="ico_save"></span>저장</button>
					<button type="button" class="btn_list_rd" id="btnView2Del"><span class="ico_del"></span>삭제</button>
				</span>
			</div>

			<input type="hidden" name="aplStrDd" />
			<input type="hidden" name="aplEndDd" />
			<table class="dtl_tbl">
				<colgroup>
					<col width="12%">
					<col width="21%">
					<col width="12%">
					<col width="21%">
					<col width="12%">
					<col width="21%">
				</colgroup>
				<tr>
					<th>그룹코드</th>
					<td>
						<input type="text" name="grpCd" maxlength="20" read noinput />
					</td>
					<th>그룹코드명</th>
					<td colspan="3"><input type="text" name="grpNm" maxlength="50" read noinput /></td>
				</tr>
				<tr>
					<th class="state-required"><span class="icon_key" title="key(중복주의)"></span>코드</th>
					<td><input type="text" name="cd" maxlength="20" /></td>
					<th class="state-required">코드명</th>
					<td><input type="text" name="cdNm" maxlength="50" /></td>
					<th>사용여부</th>
					<td>
						<label><input type="radio" name="useYn" value="Y">사용</label>&nbsp;
						<label><input type="radio" name="useYn" value="N">미사용</label>
					</td>
				</tr>
				<tr>
					<th>코드상세</th>
					<td><input type="text" name="cdDesc" maxlength="500" /></td>
					<th>정렬번호</th>
					<td colspan="3"><input type="text" name="seq" maxlength="10" /></td>
				</tr>
				<tr>
					<th>기타1</th>
					<td><input type="text" name="etc1" maxlength="2000" /></td>
					<th>기타2</th>
					<td><input type="text" name="etc2" maxlength="2000" /></td>
					<th>기타3</th>
					<td><input type="text" name="etc3" maxlength="2000" /></td>
				</tr>
			</table>
		</div>
	</div>
</div>