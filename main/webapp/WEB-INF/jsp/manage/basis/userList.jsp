<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script>
var srch$;
var view1$;
var grid1$;

var agentAuthCdList;
var centerAuthCdList;

jQuery(function($) {
	srch$ = com.toBox($('#divSrch'));
	view1$ = com.toBox($('#divView1'));

	grid1$ = $('#grid1').jqGrid({
		url: _contextPath_ + '/manage/basis/userList.json',
		pager:'#grid1Pg',
		height: 300,
		postData: com.getData(srch$),

		colNames:['순번', '구분', '소속(센터/대리점)', '아이디', '성명', '권한', '전화번호', '핸드폰', '이메일', '알림여부', '사용여부', 'centerCd', 'agentCd', 'authCenterCd', 'authCd', 'acDiv', 'pushYn', 'useYn'],
		colModel:[
			{name:'rnum', index:'rnum', width:4, align:'right', sortable:false},
			{name:'acDivNm', index:'AC_DIV', width:5, sortable:false},
			{name:'acNm', index:'AC_NM', width:9, sortable:false},
// 			{name:'authCenterNm', index:'AUTH_CENTER_CD', width:9, formatter:'center', sortable:false},
			{name:'userId', index:'USER_ID', width:7, key: true},
			{name:'userNm', index:'USER_NM', width:8},
			{name:'authNm', index:'AUTH_CD', width:10, sortable:false},
			{name:'telNo', index:'TEL_NO', width:10, formatter: 'tel'},
			{name:'hpNo', index:'HP_NO', width:10, formatter: 'tel'},
// 			{name:'faxNo', index:'FAX_NO', width:10, formatter: 'tel'},
			{name:'email', index:'EMAIL', width:10},
			{name:'pushYnNm', index:'PUSH_YN', width:5},
			{name:'useYnNm', index:'USE_YN', width:5},
// 			{name:'insertDt', index:'INSERT_DT', width:10, formatter:'datetime'},
// 			{name:'lastConDt', index:'LAST_CON_DT', width:13, formatter:'datetime'},
			{name:'centerCd', index:'CENTER_CD', hidden: true},
			{name:'agentCd', index:'AGENT_CD', hidden: true},
			{name:'authCenterCd', index:'AUTH_CENTER_CD', hidden: true},
			{name:'authCd', index:'AUTH_CD', hidden: true},
			{name:'acDiv', index:'AC_DIV', hidden: true},
			{name:'pushYn', index:'PUSH_YN', hidden: true},
			{name:'useYn', index:'USE_YN', hidden: true},
		],

		onSelectRow: function(rowId) {
			$('#pwdTh').show();
			$('#pwdTd').show();

			user.acDivDisplay(grid1$.getRowData(rowId).acDiv);
			com.setVal(view1$, grid1$.getRowData(rowId));
			if (grid1$.getRowData(rowId).acDiv == 'A') {
				view1$.find('[name=agentNm]').val(grid1$.getRowData(rowId).acNm);
			}
			view1$.find('[name=acDiv]').prop('disabled', true);
		}

	});

	$('#btnView1New').on('click', function() {user.userInit();}); //사용자 신규
	$('#btnView1Save').on('click', function() {user.userSave(com.getFlag(view1$));}); //사용자 저장
	$('#btnView1Del').on('click', function() {user.userSave('D');}); //사용자 삭제

// 	$('#btnSrchAgentFind').on('click', function() {user.agentFindPop();}); //대리점찾기 팝업(검색시)
	$('#btnAgentFind').on('click', function() {user.agentFindPop();}); //대리점찾기 팝업
	$('#btnPwdReset').on('click', function() {user.userPwdResetUpdate();}); //사용자 패스워드 초기화

	view1$.find('[name=acDiv]').on('change', function() {
		user.acDivDisplay($(this).val());
		view1$.find('[name=authCd]').val('');
	});

	$('select[name=pageUnit]').on('change', function () {
		$('#srchBtn').trigger('click');
	});

	//엑셀다운로드
	$('#btnGrid1Xls').on('click', function() {
		cvo.ajaxFileDown({url: _contextPath_ + '/manage/basis/userList.xls', data: com.getData(srch$)});
	});

	//검색
	$('#srchBtn').on('click', function() {
		com.init(view1$, true);
		$('#pwdTh').show();
		$('#pwdTd').show();
		grid1$.setGridParam({postData: com.getData(srch$, $('select[name=pageUnit]').val()), page: 1}).trigger('reloadGrid');
	});

	user.init();
});

var user = {
	init: function() {

		com.setCombo('select', $('#main'), 'pageUnit', '${paramBox.pageUnit}', com.getCdList('PAGE_UNIT'), null, 60);
		// 	com.setChk(srch$, 'srchCenterCd', '${paramBox.srchCenterCd}'); //checkbox일경우 lib
		com.setCombo('select', srch$, 'srchAuthCd', '${paramBox.srchAuthCd}', com.getCdList('AUTH_CD'), '전체'); //콤보 list를 가지고 그릴 경우
		com.setCombo('select', srch$, 'srchUseYn', '${paramBox.srchUseYn}'); //이미 콤보가 그려져 있는 경우
		com.setCombo('select', srch$, 'srchMethod', '${paramBox.srchMethod}'); //이미 콤보가 그려져 있는 경우
	// 	com.setCombo('select', srch$, 'srchCenterCd', '${paramBox.srchCenterCd}', 'cmn.centerList'); //서버에서 콤보 list를 가져와 그릴 경우
		com.setCombo('select', srch$, 'srchCenterCd', '${paramBox.srchCenterCd}', com.sAuthCenterList()); //콤보 list를 가지고 그릴 경우
		srch$.find('[name=srchWord]').val('${paramBox.srchWord}');

	// 	com.setCombo('checkbox', view1$, 'centerCd', null, 'cmn.centerList', '전체');
		com.setCombo('select', view1$, 'centerCd', null, gCenterList);
		com.setCombo('checkbox', view1$, 'authCenterCd', null, gCenterList, '전체');
	// 	com.setCombo('select', view1$, 'centerCd', null, gCenterList);

		agentAuthCdList = fnAuthCdList('A');
		centerAuthCdList = fnAuthCdList('C');
		com.setCombo('select', view1$, 'authCd', null, centerAuthCdList);

		com.init(view1$, true);
		$('#srchBtn').trigger('click');
	},

	//사용자 신규
	userInit: function() {
		com.init(view1$, false);
		com.setFlag(view1$, 'C');

		view1$.find('[name=acDiv][value=C]').prop('checked', true);
		view1$.find('[name=pushYn][value=Y]').prop('checked', true);
		view1$.find('[name=useYn][value=Y]').prop('checked', true);
		user.acDivDisplay('C');
		$('#pwdTh').hide();
		$('#pwdTd').hide();
	},

	acDivDisplay: function(val) {
		if (val == 'C') {
			view1$.find('[name=centerCd]').show();
			view1$.find('[name=agentNm]').hide();
			$('#btnAgentFind').hide();

			com.setCombo('select', view1$, 'authCd', null, centerAuthCdList);
			$('#authTh').show();
			$('#authTd').show();
		} else if(val == 'A') {
			view1$.find('[name=centerCd]').hide();
			view1$.find('[name=agentNm]').show();
			$('#btnAgentFind').show();

			com.setCombo('select', view1$, 'authCd', null, agentAuthCdList);
			$('#authTh').hide();
			$('#authTd').hide();
		}
	},

	//사용자 저장
	userSave: function(action) {
		if (action == 'D') {
			if (!confirm('이용중인 사용자를 삭제할 시 시스템에 영향을 끼칠 수 있습니다.\n정말 삭제하시겠습니까?')) { return false; }
		}
// 		if (action != 'D') {
// 			if (action == 'C') {
// 				if (view1$.get('userPwd') == '') { onm.alert('패스워드를 입력해 주세요.'); return false; }
// 			}
// 			if (view1$.get('userPwd') != '') {
// 				if (view1$.get('confirmUserPwd') == '') { onm.alert('패스워드 재확인을 입력해 주세요.'); return false; }
// 				if (view1$.get('userPwd') != view1$.get('confirmUserPwd')) { onm.alert('패스워드를 다시 확인해 주세요.'); return false; }
// 			}
// 		}

		onm.ajax({
			url: _contextPath_ + '/manage/basis/userSave.json',
			beforeSend: function() {
				if (!com.beforeChk(view1$, action)) { return false; } //저장전 flag 체크
				if (action != 'D') {if(!user.valid(view1$)) { return false; }} //입력값유효성 체크
				if (action != 'D') {if(!user.bizValid(view1$)) { return false; }} //업무유효성 체크
			},
			data: com.set(view1$, action),
			success: function(res) {
				com.afterSave(res, view1$, action, true);
				$('#pwdTh').show();
				$('#pwdTd').show();
				$('#srchBtn').trigger('click');
			}
		});
	},

	//사용자 패스워드 초기화
	userPwdResetUpdate: function() {
		onm.ajax({
			url: _contextPath_ + '/manage/basis/userPwdResetUpdate.json',
			beforeSend: function() {
				if (!confirm('패스워드를 초기화 하시겠습니까?')) { return false; }
			},
			data: com.set(view1$),
			success: function(res) {
				onm.alert('패스워드를 초기화 했습니다.');
			}
		});
	},

	//대리점찾기 팝업
	agentFindPop: function() {
		onm.ajaxModal({
			url: _contextPath_ + '/manage/basis/agentFindList.pop',
			dialogOptions: { title: '대리점찾기'},
			callback:function(row) {
				view1$.put('agentCd', row.agentCd);
				view1$.put('agentNm', row.agentNm);
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

			if (!/^[a-zA-Z0-9\s]+$/.test(area.find('[name=userId]').val())) {
				onm.alert('아이디는 영문과 숫자만 가능합니다.');
				return false;
			}
			if (area.find('[name=userId]').val().length < 4) {
				onm.alert('아이디는 4자이상 가능합니다.');
				return false;
			}

			if (area.find('[name=acDiv]:checked').val() == 'C') {
				if (!area.find('[name=centerCd]').val()) {
					onm.alert('소속 센터는 필수선택 입니다.');
					return false;
				}
			}
			if (area.find('[name=acDiv]:checked').val() == 'A') {
				if (!area.find('[name=agentCd]').val()) {
					onm.alert('소속 대리점은 필수선택 입니다.');
					return false;
				}
			}

			if (area.find('[name=authCenterCd]:checked').length == 0) {
				onm.alert('권한센터는 하나이상 선택하셔야합니다.');
				return false;
			}

			return true;
		}
	}
}
</script>

<header>
	<div id="divSrch">
		<div class="loc_info"><span>사용자관리</span><span>기준정보</span><span>Home</span></div>
		<h2 class="content_title"><span>사용자관리</span></h2>
		<div class="srch_box">
			<table>
				<colgroup>
					<col width="8%">
					<col width="7%">
					<col width="8%">
					<col width="19%">
					<col width="8%">
					<col width="14%">
					<col width="7%">
					<col width="12%">
					<col width="*">
				</colgroup>
				<tr>
					<th>구분</th>
					<td>
						<select name="srchAcDiv">
							<option value="">전체</option>
							<option value="C">센터</option>
							<option value="A">대리점</option>
						</select>
					</td>
					<th>센터</th>
					<td>
	<!-- 					<label><input type="checkbox" name="srchCenterCd" value="">전체</label>&nbsp;&nbsp;&nbsp; -->
	<!-- 					<label><input type="checkbox" name="srchCenterCd" value="1200">평택공장</label>&nbsp;&nbsp;&nbsp; -->
	<!-- 					<label><input type="checkbox" name="srchCenterCd" value="1300">진천공장</label>&nbsp;&nbsp;&nbsp; -->
						<select name="srchCenterCd" class="chosen" multiple data-placeholder="전체"></select>
					</td>
					<th>사용여부</th>
					<td>
						<select name="srchUseYn">
							<option value="">전체</option>
							<option value="Y">사용</option>
							<option value="N">사용정지</option>
						</select>
					</td>
					<th>권한</th>
					<td>
						<select name="srchAuthCd">
	<!-- 						<option value="">전체</option> -->
	<%-- 						<option value="300" <c:if test="${paramBox.srchAuthCd eq '300'}">selected="selected"</c:if>>배송기사</option> --%>
	<%-- 						<option value="104" <c:if test="${paramBox.srchAuthCd eq '104'}">selected="selected"</c:if>>웹관리자</option> --%>
	<%-- 						<option value="100" <c:if test="${paramBox.srchAuthCd eq '100'}">selected="selected"</c:if>>최고관리자</option> --%>
	<%-- 						<option value="500" <c:if test="${paramBox.srchAuthCd eq '500'}">selected="selected"</c:if>>현장관리자</option> --%>
						</select>
					</td>
					<td>
						<div class="srch_btn">
							<button type="button" id="srchBtn" class="btn_srch "><span class="ico_srch"></span>검색</button>
						</div>
					</td>
				</tr>
				<tr>
					<th>알람여부</th>
					<td>
						<select name="srchPushYn">
							<option value="">전체</option>
							<option value="Y">수신</option>
							<option value="N">미수신</option>
						</select>
					</td>
					<th>대리점명</th>
					<td>
						<input type="text" name="srchAgentNm" maxlength="30" class="enterSrch" />
					</td>
					<th>검색어</th>
					<td colspan="4">
						<select name="srchMethod">
							<option value="userId">아이디</option>
							<option value="userNm">성명</option>
							<option value="telNo">전화번호</option>
							<option value="hpNo">핸드폰</option>
<!-- 							<option value="faxNo">팩스</option> -->
							<option value="email">이메일</option>
						</select>
	<%-- 					<input type="text" name="srchWord" class="enterSrch" value="${paramBox.srchWord}" /> --%>
						<input type="text" name="srchWord" class="enterSrch" />
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

<!-- 	<div class="colgroup-wrap"> -->
<!-- 		<div class="colgroup-1-3"> -->
<!-- 			<table id="grid1"></table> -->
<!-- 			<div id="grid1Pg"></div> -->
<!-- 		</div> -->
<!-- 		<div class="colgroup-2-3"> -->
<!-- 			<table id="grid2"></table> -->
<!-- 			<div id="grid2Pg"></div> -->
<!-- 		</div> -->
<!-- 	</div> -->

	<div class="colgroup-wrap mT20">
		<div id="divView1">
			<div class="caption-pnl">
				<h2>사용자 상세정보</h2>
				<span class="buttonset fr">
					<button type="button" class="btn_list_rd" id="btnView1New"><span class="ico_add"></span>신규</button>
					<button type="button" class="btn_list_rd" id="btnView1Save"><span class="ico_save"></span>저장</button>
					<button type="button" class="btn_list_rd" id="btnView1Del"><span class="ico_del"></span>삭제</button>
				</span>
			</div>

			<table class="dtl_tbl">
				<colgroup>
					<col width="11%">
					<col width="14%">
					<col width="11%">
					<col width="14%">
					<col width="11%">
					<col width="14%">
					<col width="11%">
					<col width="14%">
				</colgroup>
				<tr>
					<th class="state-required">구분</th>
					<td>
						<label><input type="radio" name="acDiv" value="C" />센터</label>&nbsp;&nbsp;&nbsp;
						<label><input type="radio" name="acDiv" value="A" />대리점</label>
					</td>
					<th class="state-reqif">소속(센터/대리점)<button type="button" id="btnAgentFind" class="btn_list_sm" style="display:none;" ><span class="ico_srch"></span>찾기</button></th>
					<td>
						<select name="centerCd"></select>
						<input type="hidden" name="agentCd" />
						<input type="text" name="agentNm" maxlength="50" read noinput style="display:none;" />
					</td>
					<th class="state-required"><span class="icon_key" title="key(중복주의)"></span>아이디</th>
					<td><input type="text" name="userId" maxlength="20" read /></td>
					<th>성명</th>
					<td><input type="text" name="userNm" maxlength="50" /></td>
				</tr>
				<tr>
					<th>전화번호</th>
					<td><input type="text" name="telNo" maxlength="13" tel /></td>
					<th>핸드폰</th>
					<td><input type="text" name="hpNo" maxlength="13" tel /></td>
<!-- 					<th>팩스</th> -->
<!-- 					<td><input type="text" name="faxNo" maxlength="13" tel /></td> -->
					<th>이메일</th>
					<td><input type="text" name="email" maxlength="50" email /></td>
					<td colspan="2"></td>
				</tr>

				<tr>
					<th class="state-required">권한</th>
					<td>
						<select name="authCd"></select>
					</td>
					<th class="state-required">알림여부</th>
					<td>
						<label><input type="radio" name="pushYn" value="Y" />수신</label>&nbsp;&nbsp;&nbsp;
						<label><input type="radio" name="pushYn" value="N" />미수신</label>
					</td>
					<th class="state-required">사용여부</th>
					<td>
		<!-- 				<select name="useYn"> -->
		<!-- 					<option value="Y">사용</option> -->
		<!-- 					<option value="N">사용정지</option> -->
		<!-- 				</select> -->
						<label><input type="radio" name="useYn" value="Y" />사용</label>&nbsp;&nbsp;&nbsp;
						<label><input type="radio" name="useYn" value="N" />사용정지</label>
					</td>
					<th id="pwdTh">비밀번호 초기화</th>
					<td id="pwdTd"><button type="button" id="btnPwdReset" class="btn_list_sm"><span class="ico_setting"></span>초기화</button></td>
				</tr>
				<tr>
					<th id="authTh">권한센터</th>
					<td id="authTd" colspan="7">
						<div name="authCenterCd"></div>
		<!-- 					<select name="centerCd" class="chosen" multiple data-placeholder="선택해 주세요."></select> -->
		<!-- 				<label><input type="checkbox" name="centerCd" value="1400" />경산공장</label>&nbsp;&nbsp;&nbsp; -->
		<!-- 				<label><input type="checkbox" name="centerCd" value="1300" />광주공장</label>&nbsp;&nbsp;&nbsp; -->
		<!-- 				<label><input type="checkbox" name="centerCd" value="2700" />군포센터</label>&nbsp;&nbsp;&nbsp; -->
		<!-- 				<label><input type="checkbox" name="centerCd" value="2200" />평택물류(매일)</label> -->
					</td>
				</tr>
			</table>
		</div>
	</div>
</div>
