<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script>
var srch$;
var view1$;
var grid1$;

jQuery(function($) {
	srch$ = com.toBox($('#divSrch'));
	view1$ = com.toBox($('#divView1'));

	grid1$ = $('#grid1').jqGrid({
		url: _contextPath_ + '/manage/basis/cargoDevList.json',
// 		multiselect: true,
		pager:'#grid1Pg',
		height: 270,
		postData: com.getData(srch$),

		colNames: [
			'순번','센터명', '창고명', '단말ID', '단말명', '담당자', '전화번호', '핸드폰', '채널수', 'CH1온도', 'CH2온도', 'CH3온도', 'CH4온도', 'CH5온도', 'CH6온도', '알림여부', '사용여부',
			'채널명1', '채널1MIN', '채널1MAX', '채널명2', '채널2MIN', '채널2MAX', '채널명3', '채널3MIN', '채널3MAX', '채널명4', '채널4MIN', '채널4MAX', '채널명5', '채널5MIN', '채널5MAX', '채널명6', '채널6MIN', '채널6MAX',
			'useYn', 'centerCd', 'chargeId', 'pushYn', 'pushIds', 'pushNms'
		],
		colModel: [
			{name:'rnum', index:'rnum', width:3, align:'right', sortable:false},
			{name:'centerNm', index:'CENTER_NM', width: 5},
			{name:'cargoNm', index:'CARGO_NM', width: 6},
			{name:'devId', index:'DEV_ID', width: 4, key: true},
			{name:'devNm', index:'DEV_NM', width: 7},
			{name:'chargeNm', index:'CHARGE_ID', width: 7, sortable:false},
			{name:'chargeTel', index:'CHARGE_ID', width: 7, sortable:false, formatter: 'tel'},
			{name:'chargeHp', index:'CHARGE_ID', width: 7, sortable:false, formatter: 'tel'},
			{name:'chCnt', index:'CH_CNT', width: 3, align:'right'},
			{name:'ch1Dp', index:'CH1_DP', width: 4, align:'center', sortable:false},
			{name:'ch2Dp', index:'CH2_DP', width: 4, align:'center', sortable:false},
			{name:'ch3Dp', index:'CH3_DP', width: 4, align:'center', sortable:false},
			{name:'ch4Dp', index:'CH4_DP', width: 4, align:'center', sortable:false},
			{name:'ch5Dp', index:'CH5_DP', width: 4, align:'center', sortable:false},
			{name:'ch6Dp', index:'CH6_DP', width: 4, align:'center', sortable:false},
			{name:'pushYnNm', index:'PUSH_YN', width: 4},
			{name:'useYnNm', index:'USE_YN', width: 5},
			{name:'ch1Nm', index:'CH1_NM', hidden: true},
			{name:'ch1Min', index:'CH1_MIN', hidden: true},
			{name:'ch1Max', index:'CH1_MAX', hidden: true},
			{name:'ch2Nm', index:'CH2_NM', hidden: true},
			{name:'ch2Min', index:'CH2_MIN', hidden: true},
			{name:'ch2Max', index:'CH2_MAX', hidden: true},
			{name:'ch3Nm', index:'CH3_NM', hidden: true},
			{name:'ch3Min', index:'CH3_MIN', hidden: true},
			{name:'ch3Max', index:'CH3_MAX', hidden: true},
			{name:'ch4Nm', index:'CH4_NM', hidden: true},
			{name:'ch4Min', index:'CH4_MIN', hidden: true},
			{name:'ch4Max', index:'CH4_MAX', hidden: true},
			{name:'ch5Nm', index:'CH5_NM', hidden: true},
			{name:'ch5Min', index:'CH5_MIN', hidden: true},
			{name:'ch5Max', index:'CH5_MAX', hidden: true},
			{name:'ch6Nm', index:'CH6_NM', hidden: true},
			{name:'ch6Min', index:'CH6_MIN', hidden: true},
			{name:'ch6Max', index:'CH6_MAX', hidden: true},
			{name:'useYn', index:'USE_YN', hidden: true},
			{name:'centerCd', index:'CENTER_CD', hidden: true},
			{name:'chargeId', index:'CHARGE_ID', hidden: true},
			{name:'pushYn', index:'PUSH_YN', hidden: true},
			{name:'pushIds', index:'PUSH_IDS', hidden: true},
			{name:'pushNms', index:'PUSH_NMS', hidden: true},
		],

		onSelectRow: function(rowId) {
			com.setVal(view1$, grid1$.getRowData(rowId));
			user.chDisplay(grid1$.getRowData(rowId).chCnt);

			$('#pushSpan').html('');
			com.pushShow(com.pushArry(grid1$.getRowData(rowId)));
		}
	});

// 	$('#btnView1New').on('click', function() {user.cargoDevInit();}); //창고단말 신규
	$('#btnView1Save').on('click', function() {user.cargoDevSave(com.getFlag(view1$));}); //창고단말 저장
// 	$('#btnView1Del').on('click', function() {user.cargoDevSave('D');}); //창고 삭제

	$('#btnUserFind').on('click', function() {user.userFindPop();}); //담당자찾기 팝업
	$('#btnUserDel').on('click', function() {user.userDel();}); //담당자 삭제
	$('#btnPushFind').on('click', function() {user.pushFindPop();}); //알림수신자찾기 팝업
	$('#btnPushAllDel').on('click', function() {com.pushAllDel(view1$);}); //알림수신자 전체삭제

// 	$('#btnGrid1Del').on('click', function() {user.cargoDevBatchSave('D');}); //일괄삭제

	view1$.find('[name=chCnt]').on('change', function() {
		user.chDisplay($(this).val());
	});

	//엑셀다운로드
	$('#btnGrid1Xls').on('click', function() {
		cvo.ajaxFileDown({url: _contextPath_ + '/manage/basis/cargoDevList.xls', data: com.getData(srch$)});
	});

	//검색
	$('#srchBtn').on('click', function() {
		com.init(view1$, true);
		$('#pushSpan').html('');
		grid1$.setGridParam({postData: com.getData(srch$)}).trigger('reloadGrid');
	});

	user.init();
});

var user = {
	//페이지 초기화
	init : function() {

		com.setCombo('select', srch$, 'srchCenterCd', '${paramBox.srchCenterCd}', com.sAuthCenterList()); //콤보 list를 가지고 그릴 경우
// 		com.setCombo('select', view1$, 'centerCd', null, gCenterList);

		com.init(view1$, true);
		$('#srchBtn').trigger('click');
	},

	//창고단말 신규
	cargoDevInit: function() {
		com.init(view1$, false);
		com.setFlag(view1$, 'C');
		$('#pushSpan').html('');

		view1$.find('[name=pushYn][value=Y]').prop('checked', true);
	},

	chDisplay: function(val) {
		view1$.find('[name=ch1Min]').attr('disabled', false);
		view1$.find('[name=ch1Max]').attr('disabled', false);
		view1$.find('[name=ch2Min]').attr('disabled', false);
		view1$.find('[name=ch2Max]').attr('disabled', false);
		view1$.find('[name=ch3Min]').attr('disabled', false);
		view1$.find('[name=ch3Max]').attr('disabled', false);
		view1$.find('[name=ch4Min]').attr('disabled', false);
		view1$.find('[name=ch4Max]').attr('disabled', false);
		view1$.find('[name=ch5Min]').attr('disabled', false);
		view1$.find('[name=ch5Max]').attr('disabled', false);
		view1$.find('[name=ch6Min]').attr('disabled', false);
		view1$.find('[name=ch6Max]').attr('disabled', false);

		if (val <= 5) {
			view1$.find('[name=ch6Min]').attr('disabled', true);
			view1$.find('[name=ch6Max]').attr('disabled', true);
		}
		if (val <= 4) {
			view1$.find('[name=ch5Min]').attr('disabled', true);
			view1$.find('[name=ch5Max]').attr('disabled', true);
		}
		if (val <= 3) {
			view1$.find('[name=ch4Min]').attr('disabled', true);
			view1$.find('[name=ch4Max]').attr('disabled', true);
		}
		if (val <= 2) {
			view1$.find('[name=ch3Min]').attr('disabled', true);
			view1$.find('[name=ch3Max]').attr('disabled', true);
		}
		if (val <= 1) {
			view1$.find('[name=ch2Min]').attr('disabled', true);
			view1$.find('[name=ch2Max]').attr('disabled', true);
		}
		if (val <= 0) {
			view1$.find('[name=ch1Min]').attr('disabled', true);
			view1$.find('[name=ch1Max]').attr('disabled', true);
		}
	},

	//창고단말 저장
	cargoDevSave: function(action) {
		if (action == 'D') {
			if (!confirm('사용중인 창고단말을 삭제할 시 시스템에 영향을 끼칠 수 있습니다.\n정말 삭제하시겠습니까?')) { return false; }
		}

		var data = com.set(view1$, action);
		onm.ajax({
			url: _contextPath_ + '/manage/basis/cargoDevSave.json',
			beforeSend: function() {
				if (!com.beforeChk(view1$, action)) { return false; } //저장전 flag 체크
				if (action != 'D') {if(!user.valid(view1$)) { return false; }} //입력값유효성 체크
				if (action != 'D') {if(!user.bizValid(view1$)) { return false; }} //업무유효성 체크
			},
			data: data,
			success: function(res) {
				com.afterSave(res, view1$, action, true);
				$('#srchBtn').trigger('click');
			}
		});
	},

	//창고단말 일괄 삭제
// 	cargoDevBatchSave: function(action) {
// 		if (action == 'D') {
// 			if (!confirm('사용중인 창고단말을 삭제할 시 시스템에 영향을 끼칠 수 있습니다.\n정말 삭제하시겠습니까?')) {
// 				return;
// 			}
// 		}

// 		var data = com.set(view1$, action);
// 		data.devIdArry = grid1$.getGridParam('selarrrow');
// 		onm.ajax({
// 			url: _contextPath_ + '/manage/basis/cargoDevSave.json',
// 			data: data,
// 			success: function(res) {
// 				com.afterSave(res, view1$, action, true);
// 				$('#srchBtn').trigger('click');
// 			}
// 		});
// 	},

	//담당자찾기 팝업
	userFindPop: function() {
		onm.ajaxModal({
			url: _contextPath_ + '/manage/basis/userFindList.pop',
			dialogOptions: { title: '담당자찾기'},
			data: {multiYn : 'N', srchAcDiv: 'C'},
			callback:function(row) {
				view1$.put('chargeId', row.userId);
				view1$.put('chargeNm', row.userNm);
			}
		});
	},

	//담당자삭제
	userDel: function() {
		if (!view1$.find('[name=chargeId]').val()) {
			onm.alert('삭제할 담당자가 없습니다.');
			return false;
		}

		view1$.put('chargeId', '');
		view1$.put('chargeNm', '');
	},

	//알림수신자찾기 팝업
	pushFindPop: function() {
		onm.ajaxModal({
			url: _contextPath_ + '/manage/basis/userFindList.pop',
			dialogOptions: { title: '알림수신자찾기'},
			data: {
				multiYn : 'Y',
				srchAcDiv: 'C',
				pushIds : view1$.find('[name=pushIds]').val()
			},
			callback:function(selIds, list) {
				var orgIds = view1$.find('[name=pushIds]').val().split(',');
				var orgNms = view1$.find('[name=pushNms]').val().split(',');
				var selNms = [];
				for (var idx = 0; idx < list.length; idx++) {
					selNms.push(list[idx].userNm);
				}

				if (orgIds[0]) {
					selIds = selIds.concat(orgIds);
					selNms = selNms.concat(orgNms);
				}
				if (selIds.length > 99) {
					onm.alert('99명 이상 등록할 수 없습니다.');
					return false;
				}

				view1$.find('[name=pushIds]').val(selIds.join(','));
				view1$.find('[name=pushNms]').val(selNms.join(','));
				com.pushShow(list);
			}
		});
	},

	//입력값 유효성 체크
	valid: function(area) {
		var isValid = com.validChk(area); //필수, 길이, 형식등의 유효성 체크
		if (isValid) {
			var ch1Min = area.find('[name=ch1Min]').val();
			var ch1Max = area.find('[name=ch1Max]').val();
			var ch2Min = area.find('[name=ch2Min]').val();
			var ch2Max = area.find('[name=ch2Max]').val();
			var ch3Min = area.find('[name=ch3Min]').val();
			var ch3Max = area.find('[name=ch3Max]').val();
			var ch4Min = area.find('[name=ch4Min]').val();
			var ch4Max = area.find('[name=ch4Max]').val();
			var ch5Min = area.find('[name=ch5Min]').val();
			var ch5Max = area.find('[name=ch5Max]').val();
			var ch6Min = area.find('[name=ch6Min]').val();
			var ch6Max = area.find('[name=ch6Max]').val();

			if (area.find('[name=chCnt]').val() >= 1) {
				if (!ch1Min || !ch1Max) {
					onm.alert('채널1온도를 입력해주세요.');
					return false;
				}
				if (parseInt(ch1Min) > parseInt(ch1Max)) {
					onm.alert('온도MAX보다 온도MIN이 더 클 수 없습니다.');
					return false;
				}
			}
			if (area.find('[name=chCnt]').val() >= 2) {
				if (!ch2Min || !ch2Max) {
					onm.alert('채널2온도를 입력해주세요.');
					return false;
				}
				if (parseInt(ch2Min) > parseInt(ch2Max)) {
					onm.alert('온도MAX보다 온도MIN이 더 클 수 없습니다.');
					return false;
				}
			}
			if (area.find('[name=chCnt]').val() >= 3) {
				if (!ch3Min || !ch3Max) {
					onm.alert('채널3온도를 입력해주세요.');
					return false;
				}
				if (parseInt(ch3Min) > parseInt(ch3Max)) {
					onm.alert('온도MAX보다 온도MIN이 더 클 수 없습니다.');
					return false;
				}
			}
			if (area.find('[name=chCnt]').val() >= 4) {
				if (!ch4Min || !ch4Max) {
					onm.alert('채널4온도를 입력해주세요.');
					return false;
				}
				if (parseInt(ch4Min) > parseInt(ch4Max)) {
					onm.alert('온도MAX보다 온도MIN이 더 클 수 없습니다.');
					return false;
				}
			}
			if (area.find('[name=chCnt]').val() >= 5) {
				if (!ch5Min || !ch5Max) {
					onm.alert('채널5온도를 입력해주세요.');
					return false;
				}
				if (parseInt(ch5Min) > parseInt(ch5Max)) {
					onm.alert('온도MAX보다 온도MIN이 더 클 수 없습니다.');
					return false;
				}
			}
			if (area.find('[name=chCnt]').val() >= 6) {
				if (!ch6Min || !ch6Max) {
					onm.alert('채널6온도를 입력해주세요.');
					return false;
				}
				if (parseInt(ch6Min) > parseInt(ch6Max)) {
					onm.alert('온도MAX보다 온도MIN이 더 클 수 없습니다.');
					return false;
				}
			}
		}
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
		<div class="loc_info"><span>센터창고관리</span><span>기준정보</span><span>Home</span></div>
		<h2 class="content_title"><span>센터창고관리</span></h2>
		<div class="srch_box">
			<table>
				<colgroup>
					<col width="8%">
					<col width="20%">
					<col width="8%">
					<col width="14%">
					<col width="8%">
					<col width="10%">
					<col width="8%">
					<col width="10%">
					<col width="*">
				</colgroup>
				<tr>
					<th>센터</th>
					<td>
						<select name="srchCenterCd" class="chosen" multiple data-placeholder="전체"></select>
					</td>
					<th>창고명</th>
					<td>
						<input type="text" name="srchCargoNm" maxlength="20" class="enterSrch" />
					</td>
					<th>채널수</th>
					<td>
						<select name="srchChCnt">
							<option value="">전체</option>
							<option value="0">없음</option>
							<option value="1">1</option>
							<option value="2">2</option>
							<option value="3">3</option>
							<option value="4">4</option>
							<option value="5">5</option>
							<option value="6">6</option>
						</select>
					</td>
					<th>사용여부</th>
					<td>
						<select name="srchUseYn">
							<option value="">전체</option>
							<option value="Y">사용</option>
							<option value="N">미사용</option>
						</select>
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
		<div class="caption-pnl">
			<h2></h2>
			<span class="buttonset fr">
				<button type="button" class="btn_list" id="btnGrid1Xls" ><span class="ico_xls ico_only"></span></button>
<!-- 				<button type="button" class="btn_list_rd" id="btnGrid1Del"><span class="ico_del"></span>삭제</button> -->
			</span>
		</div>
		<table id="grid1"></table>
		<div id="grid1Pg"></div>
	</div>

	<div class="colgroup-wrap mT20">
		<div id="divView1">
			<div class="caption-pnl">
				<h2>창고단말 상세정보</h2>
				<span class="buttonset fr">
<!-- 					<button type="button" class="btn_list_rd" id="btnView1New"><span class="ico_add"></span>신규</button> -->
					<button type="button" class="btn_list_rd" id="btnView1Save"><span class="ico_save"></span>저장</button>
<!-- 					<button type="button" class="btn_list_rd" id="btnView1Del"><span class="ico_del"></span>삭제</button> -->
				</span>
			</div>

			<input type="hidden" name="chargeId" />
			<input type="hidden" name="pushIds" />
			<input type="hidden" name="pushNms" />

			<table class="dtl_tbl">
				<colgroup>
					<col width="7%">
					<col width="11%">
					<col width="7%">
					<col width="11%">
					<col width="7%">
					<col width="9%">
					<col width="7%">
					<col width="9%">
					<col width="7%">
					<col width="9%">
					<col width="7%">
					<col width="*">
				</colgroup>

				<tbody>
					<tr>
						<th>소속센터</th>
						<td><input type="text" name="centerNm" maxlength="20" read /></td>
						<th>창고명</th>
						<td colspan="3"><input type="text" name="cargoNm" maxlength="50" /></td>
						<th class="state-required"><span class="icon_key" title="key(중복주의)"></span>단말ID</th>
						<td colspan="2"><input type="text" name="devId" maxlength="20" read /></td>
						<th>단말명</th>
						<td colspan="2"><input type="text" name="devNm" maxlength="20" read /></td>
					</tr>
					<tr>
						<th class="state-required">채널수</th>
						<td>
							<select name="chCnt" style="width:100px;">
								<option value="0">없음</option>
								<option value="1">1</option>
								<option value="2">2</option>
								<option value="3">3</option>
								<option value="4">4</option>
								<option value="5">5</option>
								<option value="6">6</option>
							</select>
						</td>
						<th>사용여부</th>
						<td>
							<label><input type="radio" name="useYn" value="Y" />사용</label>&nbsp;
							<label><input type="radio" name="useYn" value="N" />미사용</label>
						</td>
						<th>담당자</th>
						<td colspan="3">
							<input type="text" name="chargeNm" maxlength="20" read style="width:120px;" />
							<button type="button" id="btnUserDel" class="btn_list_sm"><span class="ico_del"></span>삭제</button>
							<button type="button" id="btnUserFind" class="btn_list_sm"><span class="ico_srch"></span>찾기</button>
						</td>
						<th>전화번호</th>
						<td><input type="text" name="chargeTel" maxlength="13" read tel /></td>
						<th>핸드폰</th>
						<td><input type="text" name="chargeHp" maxlength="13" read tel /></td>
					</tr>
					<tr>
						<th>채널명1</th>
						<td><input type="text" name="ch1Nm" maxlength="50" read /></td>
						<th>채널명2</th>
						<td><input type="text" name="ch2Nm" maxlength="50" read /></td>
						<th>채널명3</th>
						<td><input type="text" name="ch3Nm" maxlength="50" read /></td>
						<th>채널명4</th>
						<td><input type="text" name="ch4Nm" maxlength="50" read /></td>
						<th>채널명5</th>
						<td><input type="text" name="ch5Nm" maxlength="50" read /></td>
						<th>채널명6</th>
						<td><input type="text" name="ch6Nm" maxlength="50" read /></td>
					</tr>
					<tr>
						<th>채널1MIN</th>
						<td><input type="text" name="ch1Min" maxlength="3" num /></td>
						<th>채널2MIN</th>
						<td><input type="text" name="ch2Min" maxlength="3" num /></td>
						<th>채널3MIN</th>
						<td><input type="text" name="ch3Min" maxlength="3" num /></td>
						<th>채널4MIN</th>
						<td><input type="text" name="ch4Min" maxlength="3" num /></td>
						<th>채널5MIN</th>
						<td><input type="text" name="ch5Min" maxlength="3" num /></td>
						<th>채널6MIN</th>
						<td><input type="text" name="ch6Min" maxlength="3" num /></td>
					</tr>
					<tr>
						<th>채널1MAX</th>
						<td><input type="text" name="ch1Max" maxlength="3" num /></td>
						<th>채널2MAX</th>
						<td><input type="text" name="ch2Max" maxlength="3" num /></td>
						<th>채널3MAX</th>
						<td><input type="text" name="ch3Max" maxlength="3" num /></td>
						<th>채널4MAX</th>
						<td><input type="text" name="ch4Max" maxlength="3" num /></td>
						<th>채널5MAX</th>
						<td><input type="text" name="ch5Max" maxlength="3" num /></td>
						<th>채널6MAX</th>
						<td><input type="text" name="ch6Max" maxlength="3" num /></td>
					</tr>
					<tr>
						<th class="state-required">알림여부</th>
						<td>
							<label><input type="radio" name="pushYn" value="Y" />수신</label>&nbsp;
							<label><input type="radio" name="pushYn" value="N" />미수신</label>
						</td>
						<th>알림수신자</th>
						<td colspan="9">
							<div id="divAllim" style="max-height:50px;overflow-y:auto;">
								<button type="button" id="btnPushAllDel" class="btn_list_sm"><span class="ico_del"></span>전체삭제</button>
								<button type="button" id="btnPushFind" class="btn_list_sm"><span class="ico_srch"></span>찾기</button>
								<span id="pushSpan" style="line-height:2.0;"></span>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
</div>