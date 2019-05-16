<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script>
var srch$;
var view1$;
var grid1$;
var grid2$;
var grid3$;

jQuery(function($) {
	srch$ = com.toBox($('#divSrch'));
	view1$ = com.toBox($('#divView1'));

	grid1$ = $('#grid1').jqGrid({
		url: _contextPath_ + '/manage/basis/authList.json',
		height: 250,
		postData: com.getData(srch$),
		colNames:['순번', '코드', '권한', '비고', '사용여부', 'useYn', 'authUserCnt'],
		colModel:[
			{name:'rnum', index:'rnum', width:4, align:'right', sortable:false},
			{name:'cd', index:'CD', width:4, key: true},
			{name:'cdNm', index:'CD_NM', width:7},
			{name:'cdDesc', index:'CD_DESC', width:10},
			{name:'useYnNm', index:'USE_YN', width:5},
			{name:'useYn', index:'USE_YN', hidden: true},
			{name:'authUserCnt', index:'AUTH_USER_CNT', hidden: true},
		],

		onSelectRow: function(rowId) {
			com.setVal(view1$, grid1$.getRowData(rowId));
// 			grid2$.setGridParam({postData: {'authCd': String(rowId)} }).trigger('reloadGrid');
			grid3$.setGridParam({postData: {'authCd': String(rowId)} }).trigger('reloadGrid');
		}
	});

	/*
	grid2$ = $('#grid2').jqGrid({
		url:  _contextPath_ + '/manage/basis/authUserList.json',
		height: 160,
// 		multiselect: true,
// 		postData: com.getData(srch$),
		colNames:['순번', '소속센터', '성명', '아이디', '전화번호', '사용여부', 'centerCd', 'authCd', 'useYn'],
		colModel:[
			{name:'rnum', index:'rnum', width:4, align:'right', sortable:false},
			{name:'centerNm', index:'CENTER_CD', width:9, formatter:'center', sortable:false},
			{name:'userNm', index:'USER_NM', width:8},
			{name:'userId', index:'USER_ID', width:7, key: true},
			{name:'telNo', index:'TEL_NO', width:10, formatter: 'tel'},
			{name:'useYnNm', index:'USE_YN', width:6},
			{name:'centerCd', index:'CENTER_CD', hidden: true},
			{name:'authCd', index:'AUTH_CD', hidden: true},
			{name:'useYn', index:'USE_YN', hidden: true},
		],

		onSelectRow: function(rowId) {
// 			com.setVal(grid3$, grid2$.getRowData(rowId));
		}
	});*/

	grid3$ = $('#grid3').jqGrid({
		url:  _contextPath_ + '/manage/basis/menuAuthList.json',
		height: 500,
// 		multiselect: true,
// 		postData: com.getData(srch$),
		colNames:['대메뉴', '메뉴', '전체', '조회', '등록', '수정', '삭제', '엑셀', 'authCd', 'menuCd', 'selectYn', 'insertYn', 'updateYn', 'deleteYn', 'excelYn'],
		colModel:[
			{name:'lMenuNm', index:'L_MENU_NM', width:9, sortable:false},
			{name:'menuNm', index:'MENU_NM', width:12, sortable:false},
			{name:'rowChk', index:'rowChk', width:6, align:'center', sortable:false},
			{name:'selectChk', index:'SELECT_YN', width:6, align:'center', sortable:false},
			{name:'insertChk', index:'INSERT_YN', width:6, align:'center', sortable:false},
			{name:'updateChk', index:'UPDATE_YN', width:6, align:'center', sortable:false},
			{name:'deleteChk', index:'DELETE_YN', width:6, align:'center', sortable:false},
			{name:'excelChk', index:'EXCEL_YN', width:6, align:'center', sortable:false},
			{name:'authCd', index:'AUTH_CD', hidden: true},
			{name:'menuCd', index:'MENU_CD', hidden: true, key: true},
			{name:'selectYn', index:'SELECT_YN', hidden: true},
			{name:'insertYn', index:'INSERT_YN', hidden: true},
			{name:'updateYn', index:'UPDATE_YN', hidden: true},
			{name:'deleteYn', index:'DELETE_YN', hidden: true},
			{name:'excelYn', index:'EXCEL_YN', hidden: true},

		],

		gridComplete: function() {
			var ids = grid3$.getDataIDs();
			for (var idx = 0; idx < ids.length; idx++) {
				var menuCd = ids[idx];
				var rowChk = grid3$.getCell(menuCd, 'rowChk');
				var selectChk = grid3$.getCell(menuCd, 'selectChk');
				var insertChk = grid3$.getCell(menuCd, 'insertChk');
				var updateChk = grid3$.getCell(menuCd, 'updateChk');
				var deleteChk = grid3$.getCell(menuCd, 'deleteChk');
				var excelChk = grid3$.getCell(menuCd, 'excelChk');

// 				var rowYn = grid3$.getCell(menuCd, 'rowYn');
				var selectYn = grid3$.getCell(menuCd, 'selectYn');
				var insertYn = grid3$.getCell(menuCd, 'insertYn');
				var updateYn = grid3$.getCell(menuCd, 'updateYn');
				var deleteYn = grid3$.getCell(menuCd, 'deleteYn');
				var excelYn = grid3$.getCell(menuCd, 'excelYn');

				var selectStr = selectYn == 'N' ? '' : 'checked="checked"';
				var insertStr = insertYn == 'N' ? '' : 'checked="checked"';
				var updateStr = updateYn == 'N' ? '' : 'checked="checked"';
				var deleteStr = deleteYn == 'N' ? '' : 'checked="checked"';
				var excelStr = excelYn == 'N' ? '' : 'checked="checked"';
				var rowStr = selectYn == 'Y' && insertYn == 'Y' && updateYn == 'Y' && deleteYn == 'Y' && excelYn == 'Y' ? 'checked="checked"' : '';

				var rowChkStr = '<input type="checkbox" value="Y" onclick="user.fnChk(\'rowYn\', \'' + menuCd + '\', this.checked)" ' + rowStr + ' />';
				var selectChkStr = '<input type="checkbox" value="Y" onclick="user.fnChk(\'selectYn\', \'' + menuCd + '\', this.checked)" ' + selectStr + ' />';
				var insertChkStr = '<input type="checkbox" value="Y" onclick="user.fnChk(\'insertYn\', \'' + menuCd + '\', this.checked)" ' + insertStr + ' />';
				var updateChkStr = '<input type="checkbox" value="Y" onclick="user.fnChk(\'updateYn\', \'' + menuCd + '\', this.checked)" ' + updateStr + ' />';
				var deleteChkStr = '<input type="checkbox" value="Y" onclick="user.fnChk(\'deleteYn\', \'' + menuCd + '\', this.checked)" ' + deleteStr + ' />';
				var excelChkStr = '<input type="checkbox" value="Y" onclick="user.fnChk(\'excelYn\', \'' + menuCd + '\', this.checked)" ' + excelStr + ' />';

				grid3$.setRowData(menuCd, {rowChk: rowChkStr, selectChk: selectChkStr, insertChk: insertChkStr, updateChk: updateChkStr, deleteChk: deleteChkStr, excelChk: excelChkStr});
			}
		}

	});

	$('#btnView1New').on('click', function() {user.authInit();}); //권한 신규
	$('#btnView1Save').on('click', function() {user.authSave(com.getFlag(view1$));}); //권한 저장
	$('#btnView1Del').on('click', function() {user.authSave('D');}); //권한 삭제

	$('#btnGrid3Save').on('click', function() {user.menuAuthBatchSave();}); //메뉴별권한 일괄저장

	//검색
	$('#srchBtn').on('click', function() {
// 		grid2$.clearGridData();
		grid3$.clearGridData();
		com.init(view1$, true);
		grid1$.setGridParam({postData: com.getData(srch$)}).trigger('reloadGrid');
	});

	user.init();
});

var user = {
	//페이지 초기화
	init : function() {
		com.init(view1$, true);
		$('#srchBtn').trigger('click');
	},

	//권한 신규
	authInit: function() {
		com.init(view1$, false);
		com.setFlag(view1$, 'C');

		view1$.find('[name=useYn][value=Y]').prop('checked', true);
	},

	//권한 체크박스 선택시 event
	fnChk : function(colNm, menuCd, isChk) {
		if (colNm == 'rowYn') {
			$('#' + menuCd).find('input[type=checkbox]').prop('checked', isChk);
			grid3$.setCell(menuCd, 'selectYn', isChk ? 'Y' : 'N');
			grid3$.setCell(menuCd, 'insertYn', isChk ? 'Y' : 'N');
			grid3$.setCell(menuCd, 'updateYn', isChk ? 'Y' : 'N');
			grid3$.setCell(menuCd, 'deleteYn', isChk ? 'Y' : 'N');
			grid3$.setCell(menuCd, 'excelYn', isChk ? 'Y' : 'N');
		} else {
			grid3$.setCell(menuCd, colNm, isChk ? 'Y' : 'N');
		}

		if (grid3$.getCell(menuCd, 'selectYn') == 'Y' && grid3$.getCell(menuCd, 'insertYn') == 'Y' && grid3$.getCell(menuCd, 'updateYn') == 'Y'
			&& grid3$.getCell(menuCd, 'deleteYn') == 'Y' && grid3$.getCell(menuCd, 'excelYn') == 'Y') {
			$('#' + menuCd).find('input[type=checkbox]').prop('checked', true);
		}
		if (grid3$.getCell(menuCd, 'selectYn') == 'N' && grid3$.getCell(menuCd, 'insertYn') == 'N' && grid3$.getCell(menuCd, 'updateYn') == 'N'
			&& grid3$.getCell(menuCd, 'deleteYn') == 'N' && grid3$.getCell(menuCd, 'excelYn') == 'N') {
			$('#' + menuCd).find('input[type=checkbox]').prop('checked', false);
		}

		//등록,수정,삭제,엑셀을 선택했을 경우 selectYn이 선택되어 있지 않은 경우 강제로 선택한다
		if (colNm != 'rowYn' && colNm != 'selectYn' && grid3$.getCell(menuCd, 'selectYn') != 'Y') {
			$('#' + menuCd).find('input[type=checkbox]:eq(1)').prop('checked', true);
			grid3$.setCell(menuCd, 'selectYn', 'Y');
		}
		//selectYn을 선택제거할 경우 등록,수정,삭제,엑셀을 동시에 제거한다
		if (colNm == 'selectYn' && grid3$.getCell(menuCd, 'selectYn') == 'N') {
			$('#' + menuCd).find('input[type=checkbox]').prop('checked', false);
			grid3$.setCell(menuCd, 'insertYn', 'N');
			grid3$.setCell(menuCd, 'updateYn', 'N');
			grid3$.setCell(menuCd, 'deleteYn', 'N');
			grid3$.setCell(menuCd, 'excelYn', 'N');
		}
	},

	//권한 저장
	authSave: function(action) {
		if (action == 'D') {
			if (parseInt(grid1$.getRowData(grid1$.getGridParam('selrow')).authUserCnt) > 0) {
				onm.alert('해당 권한으로 등록된 사용자가 존재합니다.');
				return;
			}
			if (!confirm('사용중인 권한을 삭제할 시 시스템에 영향을 끼칠 수 있습니다.\n정말 삭제하시겠습니까?')) { return false; }
		}

		onm.ajax({
			url: _contextPath_ + '/manage/basis/authSave.json',
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

	//메뉴별권한 일괄저장
	menuAuthBatchSave: function() {
		if (!grid1$.getGridParam('selrow')) {
			onm.alert('권한을 선택해주세요.');
			return;
		}

		var data = {};
		data.gridData = JSON.stringify(grid3$.getRowData());
// 		data.gridData = grid3$.getRowData();
		data.authCd = grid1$.getGridParam('selrow');
		onm.ajax({
			url: _contextPath_ + '/manage/basis/menuAuthSave.json',
			data: data,
			success: function(res) {
				onm.alert('메뉴별 권한정보가 저장되었습니다.');
			}
		});
	},

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
	}
}
</script>

<header>
	<div id="divSrch">
		<div class="loc_info"><span>권한관리</span><span>기준정보</span><span>Home</span></div>
		<h2 class="content_title"><span>권한관리</span></h2>
		<div class="srch_box">
			<table>
				<colgroup>
					<col width="9%">
					<col width="20%">
					<col width="*">
				</colgroup>
				<tr>
					<th>권한명</th>
					<td>
						<input type="text" name="srchWord" class="enterSrch" />
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
		<div class="colgroup-2-5">
			<div class="caption-pnl">
				<h2>권한정보</h2>
			</div>
			<table id="grid1"></table>
<!-- 			<div class="caption-pnl"> -->
<!-- 				<h2>권한별 사용자정보</h2> -->
<!-- 			</div> -->
<!-- 			<table id="grid2"></table> -->

			<div class="colgroup-wrap mT20">
				<div id="divView1">
					<div class="caption-pnl">
						<h2>권한관리</h2>
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
							<th class="state-required"><span class="icon_key" title="key(중복주의)"></span>권한코드</th>
							<td><input type="text" name="cd" maxlength="3" read /></td>
						</tr>
						<tr>
							<th class="state-required">권한명</th>
							<td><input type="text" name="cdNm" maxlength="50" /></td>
						</tr>
						<tr>
							<th>비고</th>
							<td><input type="text" name="cdDesc" maxlength="500" /></td>
						</tr>
						<tr>
							<th>사용여부</th>
							<td>
								<label><input type="radio" name="useYn" value="Y" />사용</label>&nbsp;
								<label><input type="radio" name="useYn" value="N" />사용안함</label>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</div>
		<div class="colgroup-3-5">
			<div class="caption-pnl">
				<h2>메뉴별 권한정보</h2>
				<span class="buttonset fr">
					<button type="button" class="btn_list_rd" id="btnGrid3Save"><span class="ico_save"></span>설정저장</button>
				</span>
			</div>
			<table id="grid3"></table>
		</div>
	</div>


</div>