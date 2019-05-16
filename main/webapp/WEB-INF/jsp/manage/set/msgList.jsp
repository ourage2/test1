<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script>
var grid1$;
var srch$;
var view1$;

jQuery(function($) {
	srch$ = com.toBox($('#divSrch'));
	view1$ = com.toBox($('#divView1'));

	grid1$ = $('#grid1').jqGrid({
		url: _contextPath_ + '/manage/set/msgList.json',
		pager:'#grid1Pg',
		height: 300,
		postData: com.getData(srch$),
		colNames:['순번', '메시지ID', '메시지유형', '메시지내용', 'msgType', 'msgDesc'],
		colModel:[
			{name:'rnum', index:'rnum', width:2, align:'right', sortable:false},
			{name:'msgId', index:'MSG_ID', width:10, align:'center', key: true},
			{name:'msgTypeNm', index:'MSG_TYPE', width:5, align:'center'},
			{name:'msgNm', index:'MSG_NM', width:20, align:'left'},
			{name:'msgType', index:'MSG_TYPE', hidden: true},
			{name:'msgDesc', index:'MSG_DESC', hidden: true}
		],

		onSelectRow: function(rowId) {
			com.setVal(view1$, grid1$.getRowData(rowId));
		}

	});

	$('#btnView1New').on('click', function() {user.msgInit();}); //메시지 신규
	$('#btnView1Save').on('click', function() {user.msgSave(com.getFlag(view1$));}); //메시지 저장
	$('#btnView1Del').on('click', function() {user.msgSave('D');}); //메시지 삭제

	$('select[name=pageUnit]').on('change', function () {
		$('#srchBtn').trigger('click');
	});

	//엑셀다운로드
	$('#btnGrid1Xls').on('click', function() {
		cvo.ajaxFileDown({url: _contextPath_ + '/manage/set/msgList.xls', data: com.getData(srch$)});
	});

	//검색
	$('#srchBtn').on('click', function() {
		com.init(view1$, true);
		grid1$.setGridParam({postData: com.getData(srch$, $('select[name=pageUnit]').val()), page: 1}).trigger('reloadGrid');
	});


	user.init();
});

var user = {
	//페이지 초기화
	init : function() {
		com.setCombo('select', $('#main'), 'pageUnit', '${paramBox.pageUnit}', com.getCdList('PAGE_UNIT'), null, 60);
		com.setCombo('select', srch$, 'srchMsgType', null, [{'cd': '', 'nm': '전체'}, {'cd': 'I', 'nm': '정보(I)'}, {'cd': 'W', 'nm': '경고(W)'}, {'cd': 'E', 'nm': '업무오류(E)'}, {'cd': 'F', 'nm': '시스템에러(F)'}, {'cd': 'S', 'nm': '성공(S)'}]);
		com.setCombo('select', view1$, 'msgType', null, [{'cd': 'I', 'nm': '정보(I)'}, {'cd': 'W', 'nm': '경고(W)'}, {'cd': 'E', 'nm': '업무오류(E)'}, {'cd': 'F', 'nm': '시스템에러(F)'}, {'cd': 'S', 'nm': '성공(S)'}]);

		com.init(view1$, true);
		$('#srchBtn').trigger('click');
	},

	//메시지 신규
	msgInit: function() {
		com.init(view1$, false);
		com.setFlag(view1$, 'C');
	},

	//메시지 저장
	msgSave: function(action) {
		onm.ajax({
			url: _contextPath_ + '/manage/set/msgSave.json',
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

	//입력값 유효성 체크
	valid: function(area) {
		var isValid = com.validChk(area); //필수, 길이, 형식등의 유효성 체크
// 		if (!isValid) {} //화면별 유효성 체크
		return isValid;
	},

	//업무유효성 체크
	bizValid: function(area) {
		if (area.attr('id') == 'divView1') {
			if (area.find('[name=msgId]').val().substring(0, 1) != area.find('[name=msgType]').val()) {
				onm.alert('잘못된 메시지유형입니다.');
				return false;
			}
			return true;
		}
	}
}
</script>


<header>
	<div id="divSrch">
		<div class="loc_info"><span>메시지관리</span><span>환경설정</span><span>Home</span></div>
		<h2 class="content_title"><span>메시지관리</span></h2>
		<div class="srch_box">
			<table>
				<colgroup>
					<col width="10%">
					<col width="20%">
					<col width="10%">
					<col width="20%">
					<col width="10%">
					<col width="20%">
					<col width="*">
				</colgroup>
				<tr>
					<th>메시지유형</th>
					<td><select name="srchMsgType"></select></td>
					<th>메시지ID</th>
					<td><input type="text" name="srchMsgId" class="enterSrch" maxlength="30" /></td>
					<th>메시지내용</th>
					<td><input type="text" name="srchWord" class="enterSrch" maxlength="30" /></td>
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
					<select name="pageUnit"></select>
					<button type="button" id="btnGrid1Xls" class="btn_list" ><span class="ico_xls ico_only"></span></button>
				</span>
			</div>
		<table id="grid1"></table>
		<div id="grid1Pg"></div>
	</div>

	<div class="colgroup-wrap">
		<div id="divView1">

			<div class="caption-pnl">
				<h2>메시지 상세정보</h2>
				<span class="buttonset fr">
					<button type="button" class="btn_list_rd" id="btnView1New"><span class="ico_add"></span>신규</button>
					<button type="button" class="btn_list_rd" id="btnView1Save"><span class="ico_save"></span>저장</button>
					<button type="button" class="btn_list_rd" id="btnView1Del"><span class="ico_del"></span>삭제</button>
				</span>
			</div>
			<table class="dtl_tbl">
				<colgroup>
					<col width="12%">
					<col width="13%">
					<col width="8%">
					<col width="17%">
					<col width="8%">
					<col width="17%">
					<col width="8%">
					<col width="17%">
				</colgroup>
				<tbody>
					<tr>
						<th class="state-required"><span class="icon_key" title="key(중복주의)"></span>메시지ID</th>
						<td><input type="text" name="msgId" maxlength="5" read /></td>
						<th class="state-required">메시지내용</th>
						<td colspan="3"><input type="text" name="msgNm" maxlength="50" /></td>
						<th class="state-required">메시지유형</th>
						<td><select name="msgType"></select></td>
					</tr>
					<tr>
						<th>메시지상세</th>
						<td colspan="7">
			<!-- 				<input type="text" name="msgDesc" /> -->
							<textarea name="msgDesc" maxlength="1000" cols="150" rows="4" placeholder="내용을 입력해 주세요."></textarea>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
</div>