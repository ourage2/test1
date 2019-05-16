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
		url: _contextPath_ + '/manage/basis/carList.json',
		pager:'#grid1Pg',
		height: 240,
		postData: com.getData(srch$),
		shrinkToFit: false,

		colNames:[
			'순번', '센터명', '운송사', '차량ID', '차량번호', '단말기번호', '운전자명', '전화번호', '핸드폰', '차종(톤)', '채널수', 'CH1온도', 'CH2온도', 'CH3온도', 'CH4온도', '용차여부', 'DTG연동', '알림여부', '업무표시구분', '사용여부',
			'centerCd', 'wetCd', 'useYn', 'dtgYn', 'rentYn', 'bizShowCd', 'companyCd', 'ch1Min', 'ch1Max', 'ch2Min', 'ch2Max', 'ch3Min', 'ch3Max', 'ch4Min', 'ch4Max',
			'drvZipNo', 'drvAddr1', 'drvAddr2', 'lastPosDt', 'lastTempDt', 'pushYn', 'pushIds', 'pushNms'
		],
		colModel:[
			{name:'rnum', index:'rnum', width:40, align:'right', sortable:false},
			{name:'centerNm', index:'CENTER_CD', width:90, sortable:false},
			{name:'companyNm', index:'COMPANY_CD', width:110, sortable:false},
			{name:'carId', index:'CAR_ID', width:70, align: 'right', key: true},
			{name:'carNo', index:'CAR_NO', width:90},
			{name:'carTid', index:'CAR_TID', width:90, formatter: 'tel'},
			{name:'drvNm', index:'DRV_NM', width:80},
			{name:'drvTelNo', index:'DRV_TEL_NO', width:90, formatter: 'tel'},
			{name:'drvHpNo', index:'DRV_HP_NO', width:90, formatter: 'tel'},
			{name:'wetNm', index:'WET_CD', width:60},
			{name:'chCnt', index:'CH_CNT', width:50, align: 'right'},
			{name:'ch1Dp', index:'CH1_DP', width: 60, align:'center', sortable:false},
			{name:'ch2Dp', index:'CH2_DP', width: 60, align:'center', sortable:false},
			{name:'ch3Dp', index:'CH3_DP', width: 60, align:'center', sortable:false},
			{name:'ch4Dp', index:'CH4_DP', width: 60, align:'center', sortable:false},
			{name:'rentYnNm', index:'RENT_YN', width:60, align: 'center'},
			{name:'dtgYnNm', index:'DTG_YN', width:60, align: 'center'},
			{name:'pushYnNm', index:'PUSH_YN', width:60, align: 'center'},
			{name:'bizShowNm', index:'BIZ_SHOW_CD', width:80, align: 'center'},
			{name:'useYnNm', index:'USE_YN', width:60, align: 'center'},

			{name:'centerCd', index:'CENTER_CD', hidden: true},
			{name:'wetCd', index:'WET_CD', hidden: true},
			{name:'useYn', index:'USE_YN', hidden: true},
			{name:'dtgYn', index:'DTG_YN', hidden: true},
			{name:'rentYn', index:'RENT_YN', hidden: true},
			{name:'bizShowCd', index:'BIZ_SHOW_CD', hidden: true},
			{name:'companyCd', index:'COMPANY_CD', hidden: true},
			{name:'ch1Min', index:'CH1_MIN', hidden: true},
			{name:'ch1Max', index:'CH1_MAX', hidden: true},
			{name:'ch2Min', index:'CH2_MIN', hidden: true},
			{name:'ch2Max', index:'CH2_MAX', hidden: true},
			{name:'ch3Min', index:'CH3_MIN', hidden: true},
			{name:'ch3Max', index:'CH3_MAX', hidden: true},
			{name:'ch4Min', index:'CH4_MIN', hidden: true},
			{name:'ch4Max', index:'CH4_MAX', hidden: true},
			{name:'drvZipNo', index:'DRV_ZIP_NO', hidden: true},
			{name:'drvAddr1', index:'DRV_ADDR1', hidden: true},
			{name:'drvAddr2', index:'DRV_ADDR2', hidden: true},
			{name:'lastPosDt', index:'LAST_POS_DT', hidden: true},
			{name:'lastTempDt', index:'LAST_TEMP_DT', hidden: true},
			{name:'pushYn', index:'PUSH_YN', hidden: true},
			{name:'pushIds', index:'PUSH_IDS', hidden: true},
			{name:'pushNms', index:'PUSH_NMS', hidden: true},
		],

		onSelectRow: function(rowId) {
			com.setVal(view1$, grid1$.getRowData(rowId));
			if (view1$.find('[name=carNo]').val() == '') {
				view1$.find('[name=rentYn]').attr('disabled', true);
			}
			user.chDisplay(grid1$.getRowData(rowId).chCnt);

			$('#pushSpan').html('');
			com.pushShow(com.pushArry(grid1$.getRowData(rowId)));
		}

	});

// 	$('#btnView1New').on('click', function() {user.carInit();}); //차량 신규
	$('#btnView1Save').on('click', function() {user.carSave(com.getFlag(view1$));}); //차량 저장
// 	$('#btnView1Del').on('click', function() {user.carSave('D');}); //차량 삭제

	$('#btnPushFind').on('click', function() {user.pushFindPop();}); //알림수신자찾기 팝업
	$('#btnPushAllDel').on('click', function() {com.pushAllDel(view1$);}); //알림수신자 전체삭제

	view1$.find('[name=chCnt]').on('change', function() {
		user.chDisplay($(this).val());
	});

	$('select[name=pageUnit]').on('change', function () {
		$('#srchBtn').trigger('click');
	});

	//엑셀다운로드
	$('#btnGrid1Xls').on('click', function() {
		cvo.ajaxFileDown({url: _contextPath_ + '/manage/basis/carList.xls', data: com.getData(srch$)});
	});

	//검색
	$('#srchBtn').on('click', function() {
		com.init(view1$, true);
		$('#pushSpan').html('');
		grid1$.setGridParam({postData: com.getData(srch$, $('select[name=pageUnit]').val()), page: 1}).trigger('reloadGrid');
	});

	user.init();
});


var user = {
	//페이지 초기화
	init : function() {
		com.setCombo('select', $('#main'), 'pageUnit', '${paramBox.pageUnit}', com.getCdList('PAGE_UNIT'), null, 60);

		var ctList = com.sAuthCenterList();
		ctList = $.grep(ctList, function(n, i) {return n.cd == '1100' || n.cd == '9999'}, true);
		com.setCombo('select', srch$, 'srchCenterCd', '${paramBox.srchCenterCd}', ctList);
		if ('${paramBox.srchMethod}') {srch$.find('[name=srchMethod]').val('${paramBox.srchMethod}');}
		srch$.find('[name=srchWord]').val('${paramBox.srchWord}');

		com.setCombo('select', srch$, 'srchWetCd', '${paramBox.srchWetCd}', com.getCdList('030'), '전체');

// 		com.setCombo('select', view1$, 'centerCd', null, gCenterList);
// 		com.setCombo('select', view1$, 'wetCd', null, com.getCdList('030'));

		com.init(view1$, true);
		$('#srchBtn').trigger('click');
	},

	//차량 신규
	carInit: function() {
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

	//차량 저장
	carSave: function(action) {
		if (action == 'D') {
			if (!confirm('사용중인 차량을 삭제할 시 시스템에 영향을 끼칠 수 있습니다.\n정말 삭제하시겠습니까?')) { return false; }
		}

		//용차여부변경시 인터페이스 상태값 P로 지정
		view1$.put('rentIfStat', '');
		if (view1$.find('[name=rentYn]:checked').val() != grid1$.getRowData(view1$.get('carId')).rentYn) {
			view1$.put('rentIfStat', 'P');
		}
		//용차이며 단말기번호가 변경됐을시  인터페이스 상태값 P로 지정
		if (view1$.find('[name=rentYn]:checked').val() == 'Y' && view1$.find('[name=carTid]').val() != grid1$.getRowData(view1$.get('carId')).carTid) {
			view1$.put('rentIfStat', 'P');
		}

		onm.ajax({
			url: _contextPath_ + '/manage/basis/carSave.json',
			beforeSend: function() {
				if (!com.beforeChk(view1$, action)) { return false; } //저장전 flag 체크
				if (action != 'D') {if(!user.valid(view1$)) { return false; }} //입력값유효성 체크
				if (action != 'D') {if(!user.bizValid(view1$)) { return false; }} //업무유효성 체크
			},
			data: com.set(view1$, action),
			success: function(res) {
				com.afterSave(res, view1$, action, true);
				$('#srchBtn').trigger('click');
			},
			error: function() {
			}
		});
	},

	//알림수신자찾기 팝업
	pushFindPop: function() {
		onm.ajaxModal({
			url: _contextPath_ + '/manage/basis/userFindList.pop',
			dialogOptions: { title: '알림수신자찾기'},
			data: {
				multiYn : 'Y', //사용자 멀티선택팝업
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
		<div class="loc_info"><span>센터차량관리</span><span>기준정보</span><span>Home</span></div>
		<h2 class="content_title"><span>센터차량관리</span></h2>
		<div class="srch_box">
			<table>
				<colgroup>
					<col width="8%">
					<col width="19%">
					<col width="9%">
					<col width="10%">
					<col width="7%">
					<col width="7%">
					<col width="7%">
					<col width="18%">
					<col width="*">
				</colgroup>
				<tr>
					<th>센터</th>
					<td>
						<select name="srchCenterCd" class="chosen" multiple data-placeholder="전체"></select>
					</td>
					<th>운송사</th>
					<td>
						<input type="text" name="srchCompanyNm" maxlength="20" class="enterSrch" />
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
						</select>
					</td>
					<th>차종(톤)</th>
					<td>
						<select name="srchWetCd"></select>
					</td>
					<td rowspan="2">
						<div class="srch_btn">
							<button type="button" id="srchBtn" class="btn_srch"><span class="ico_srch"></span>검색</button>
						</div>
					</td>
				</tr>
				<tr>
<!-- 					<th>차량등록일</th> -->
<!-- 					<td> -->
<!-- 						<input type="text" name="srchStrDt" class="calendar" mindateid="srchEndDt" /> ~ <input type="text" name="srchEndDt" class="calendar" maxdateid="srchStrDt" /> -->
<!-- 					</td> -->
					<th>용차여부</th>
					<td>
						<select name="srchRentYn" style="width:100px;">
							<option value="">전체</option>
							<option value="Y">용차</option>
							<option value="N">자차</option>
						</select>
					</td>
					<th>업무표시구분</th>
					<td>
						<select name="srchBizShowCd" style="width:100px;">
							<option value="">전체</option>
							<option value="D">배송</option>
							<option value="T">수송</option>
						</select>
					</td>
					<th>사용여부</th>
					<td>
						<select name="srchUseYn">
							<option value="">전체</option>
							<option value="Y" selected="selected">사용</option>
							<option value="N">미사용</option>
						</select>
					</td>
					<th>검색어</th>
					<td colspan="4">
						<select name="srchMethod">
							<option value="carId" selected="selected">차량ID</option>
							<option value="carNo">차량번호</option>
							<option value="carTid">단말기번호</option>
							<option value="drvNm">운전자명</option>
							<option value="drvTelNo">전화번호</option>
							<option value="drvHpNo">핸드폰</option>
						</select>
						<input type="text" name="srchWord" maxlength="30" class="enterSrch" />
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

	<div class="colgroup-wrap mT20">
		<div id="divView1">

			<div class="caption-pnl">
				<h2>차량 상세정보</h2>
				<span class="buttonset fr">
<!-- 					<button type="button" class="btn_list_rd" id="btnView1New"><span class="ico_add"></span>신규</button> -->
					<button type="button" class="btn_list_rd" id="btnView1Save"><span class="ico_save"></span>저장</button>
<!-- 					<button type="button" class="btn_list_rd" id="btnView1Del"><span class="ico_del"></span>삭제</button> -->
				</span>
			</div>

			<input type="hidden" name="rentIfStat" />
			<input type="hidden" name="pushIds" />
			<input type="hidden" name="pushNms" />

			<table class="dtl_tbl">
				<colgroup>
					<col width="8%">
					<col width="12%">
					<col width="8%">
					<col width="12%">
					<col width="8%">
					<col width="12%">
					<col width="8%">
					<col width="12%">
					<col width="8%">
					<col width="12%">
				</colgroup>
				<tbody>
					<tr>
						<th>소속센터</th>
						<td><input type="text" name="centerNm" maxlength="50" read /></td>
						<th>운송사</th>
						<td><input type="text" name="companyNm" maxlength="50" read /></td>
						<th class="state-required"><span class="icon_key" title="key(중복주의)"></span>차량ID</th>
						<td><input type="text" name="carId" maxlength="5" read /></td>
						<th>차량번호</th>
						<td><input type="text" name="carNo" maxlength="15" read /></td>
						<td colspan="2"></td>
					</tr>
					<tr>
						<th>운전자명</th>
						<td><input type="text" name="drvNm" maxlength="20" read /></td>
						<th>전화번호</th>
						<td><input type="text" name="drvTelNo" maxlength="13" tel read /></td>
						<th>핸드폰</th>
						<td><input type="text" name="drvHpNo" maxlength="13" tel read /></td>
						<th>차종(톤)</th>
						<td><input type="text" name="wetNm" maxlength="50" read /></td>
<!-- 						<td><select name="wetCd"></select></td> -->
						<th class="state-required">업무표시구분</th>
						<td>
							<label><input type="radio" name="bizShowCd" value="D" />배송</label>&nbsp;&nbsp;&nbsp;
							<label><input type="radio" name="bizShowCd" value="T" />수송</label>
						</td>
					</tr>

					<tr>
						<th class="state-required">채널수</th>
						<td>
							<select name="chCnt">
								<option value="0">없음</option>
								<option value="1">1</option>
								<option value="2">2</option>
								<option value="3">3</option>
								<option value="4">4</option>
							</select>
						</td>
						<th>단말기번호</th>
						<td><input type="text" name="carTid" maxlength="13" placeholder="핸드폰번호 형식" tel /></td>
						<th class="state-required">용차여부</th>
						<td>
							<label><input type="radio" name="rentYn" value="Y" />용차</label>&nbsp;&nbsp;&nbsp;
							<label><input type="radio" name="rentYn" value="N" />자차</label>
						</td>
						<th class="state-required">DTG연동여부</th>
						<td>
							<label><input type="radio" name="dtgYn" value="Y" />연동</label>&nbsp;&nbsp;&nbsp;
							<label><input type="radio" name="dtgYn" value="N" />미연동</label>
						</td>
						<th class="state-required">사용여부</th>
						<td>
							<label><input type="radio" name="useYn" value="Y" />사용</label>&nbsp;&nbsp;&nbsp;
							<label><input type="radio" name="useYn" value="N" />미사용</label>
						</td>
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
						<td colspan="2"></td>
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
						<td colspan="2"></td>
					</tr>
					<tr>
						<th class="state-required">알림여부</th>
						<td>
							<label><input type="radio" name="pushYn" value="Y">수신</label>&nbsp;
							<label><input type="radio" name="pushYn" value="N">미수신</label>
						</td>
						<th>알림수신자</th>
						<td colspan="7">
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
