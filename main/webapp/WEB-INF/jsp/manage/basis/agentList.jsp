<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<!-- 카카오맵 api 로드 -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=<spring:eval expression="@config['daum.map.appkey']" />&libraries=services"></script>
<script src="<c:url value="/resources/js/map/cvo.map.library.js" />"></script>
<script src="<c:url value="/resources/js/map/cvo.map.layout.util.js" />"></script>

<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js?autoload=false"></script><!-- 다음주소찾기 -->

<script>
var grid1$;
var srch$;
var view1$;
var selPg;
var selRow;

jQuery(function($) {
	srch$ = com.toBox($('#divSrch'));
	view1$ = com.toBox($('#divView1'));

	grid1$ = $('#grid1').jqGrid({
		url: _contextPath_ + '/manage/basis/agentList.json',
		pager:'#grid1Pg',
		height: 300,
		postData: com.getData(srch$),
		shrinkToFit: false,
// 		sortable: false,
// 		cmTemplate: {sortable : false},
// 		multiselect : true,
		colNames:[
			'순번', '센터명', '대리점코드', '대리점명', '도시', '사업장', '영업그룹', '담당직원', '대리점장', '전화번호', '핸드폰'
			, 'CVO주소', '위도', '경도', '사용여부', 'centerCd', 'useYn', 'si', 'soNm', 'chNm', 'agentCdNm', 'cvoZip', 'normalFrom', 'normalTo', 'weekendFrom', 'weekendTo', 'sapWeekUpdate'
		],

		colModel:[
			{name:'rnum', index:'rnum', width:40, align:'right', cellattr:user.fnCustom, sortable:false, frozen:true},
			{name:'centerNm', index:'CENTER_CD', width: 90, cellattr:user.fnCustom, frozen:true},
			{name:'agentCd', index:'AGENT_CD', width: 90, cellattr:user.fnCustom, frozen:true, key: true},
			{name:'agentNm', index:'AGENT_NM', width: 150, cellattr:user.fnCustom, frozen:true},
			{name:'cvoSi', index:'CVO_SI', width: 80},
			{name:'soCd', index:'SO_CD', width: 80},
			{name:'chCd', index:'CH_CD', width: 80},
			{name:'empNo', index:'EMP_NO', width: 60},
			{name:'staffNm', index:'STAFF_NM', width: 60},
			{name:'cvoHpNo', index:'CVO_HP_NO', width: 90, formatter: 'tel'},
			{name:'cvoTelNo', index:'CVO_TEL_NO', width: 90, formatter: 'tel'},
			{name:'cvoAddr', index:'CVO_ADDR', width: 300},
			{name:'xpos', index:'XPOS', width: 100},
			{name:'ypos', index:'YPOS', width: 100},
			{name:'useYnNm', index:'USE_YN', width: 60},
			{name:'centerCd', index:'CENTER_CD', hidden: true},
			{name:'useYn', index:'USE_YN', hidden: true},
			{name:'si', index:'SI', hidden: true},
			{name:'soNm', index:'SO_NM', hidden: true},
			{name:'chNm', index:'CH_NM', hidden: true},
			{name:'agentCdNm', index:'AGENT_CD', hidden: true},
			{name:'cvoZip', index:'CVO_ZIP', hidden: true},
			{name:'normalFrom', index:'NORMAL_FROM', hidden: true},
			{name:'normalTo', index:'NORMAL_TO', hidden: true},
			{name:'weekendFrom', index:'WEEKEND_FROM', hidden: true},
			{name:'weekendTo', index:'WEEKEND_TO', hidden: true},
			{name:'sapWeekUpdate', index:'SAP_WEEK_UPDATE', hidden: true},
		],

		gridComplete: function() {
			if (selRow) {
				grid1$.setSelection(selRow);
			}

			$('[name=srchAgentNm]').focus();
		},

		onSelectRow: function(rowId) {
			selRow = rowId;
			selPage = $('#' + grid1$.attr('id') + '_pg').val();
			com.setVal(view1$, grid1$.getRowData(rowId));
// 			console.log(grid1$.getRowData(rowId));
		}
	});

// 	grid1$.setFrozenColumns2();

// 	$('#btnView1New').on('click', function() {user.agentInit();}); //대리점 신규
	$('#btnView1Save').on('click', function() {user.agentSave(com.getFlag(view1$));}); //대리점 저장
// 	$('#btnView1Del').on('click', function() {user.agentSave('D');}); //대리점 삭제

	$('#btnAgentLoc').on('click', function() {user.agentLocPop();}); //대리점 위치조회 팝업
	$('#btnAgentIoBatch').on('click', function() {user.agentIoBatchPop();}); //대리점출도착 일괄설정 팝업
	$('#btnAgentMap').on('click', function() {user.agentMapPop();}); //대리점 좌표지정 팝업

	$('select[name=pageUnit]').on('change', function () {
		$('#srchBtn').trigger('click');
	});

	//엑셀다운로드
	$('#btnGrid1Xls').on('click', function() {
		cvo.ajaxFileDown({url: _contextPath_ + '/manage/basis/agentList.xls', data: com.getData(srch$)});
	});

	//검색
	$('#srchBtn').on('click', function() {
		com.init(view1$, true);
		if (srch$.find('[name=srchWord]').val() != '' && srch$.find('[name=srchWord]').val().length < 3) {
			onm.alert('검색어를 3자 이상 입력해주세요.');
			return false;
		}
		grid1$.setGridParam({postData: com.getData(srch$, $('select[name=pageUnit]').val()), page: 1}).trigger('reloadGrid');
	});

	user.init();
});


var user = {
	//페이지 초기화
	init : function() {

		com.setCombo('select', $('#main'), 'pageUnit', '${paramBox.pageUnit}', com.getCdList('PAGE_UNIT'), null, 60);
		com.setCombo('select', srch$, 'srchCenterCd', '${paramBox.srchCenterCd}', com.sAuthCenterList());
		srch$.find('[name=srchAgentNm]').val('${paramBox.srchAgentNm}');
		srch$.find('[name=srchUseYn]').val('${paramBox.srchUseYn}');
		if ('${paramBox.srchMethod}') {srch$.find('[name=srchMethod]').val('${paramBox.srchMethod}');}
		srch$.find('[name=srchWord]').val('${paramBox.srchWord}');

// 		com.setCombo('select', srch$, 'srchBizCd', '${paramBox.srchBizCd}', com.getCdList('020'), '전체');
// 		com.setCombo('select', view1$, 'chCd', null, com.getCdList('CH_CD'));
// 		com.setCombo('select', view1$, 'soCd', null, com.getCdList('SO_CD'));

		com.init(view1$, true);
		$('#srchBtn').trigger('click');
	},

	//대리점 신규
	agentInit: function() {
		com.init(view1$, false);
		com.setFlag(view1$, 'C');
	},

	fnCustom : function(rowId, val, rowData, cm) {
		var rtnStr = '';
		if (rowData.sapWeekUpdate == 1) {
			rtnStr = 'style="background-color:yellow;"';
		}
		return rtnStr;
	},

	//대리점출도착 일괄설정 팝업
	agentIoBatchPop : function() {
		onm.ajaxModal({
			url: _contextPath_ + '/manage/basis/agentIoBatch.pop',
			dialogOptions: { title: '대리점출도착 일괄설정'}
		});
	},

	//대리점 위치조회 팝업
	agentLocPop : function() {
		onm.ajaxModal({
			url: _contextPath_ + '/manage/basis/agentLoc.pop',
			dialogOptions: { title: '대리점 위치조회'}
		});
	},

	//대리점 좌표지정 팝업
	agentMapPop : function() {
		onm.ajaxModal({
			url: _contextPath_ + '/manage/basis/agentMap.pop',
			dialogOptions: { title: '대리점 좌표지정'},
			data: {
				data : JSON.stringify(com.getData(view1$))
			},
			callback:function(row) {
				view1$.put('cvoSi', row.cvoSi);
				view1$.put('cvoZip', row.cvoZip);
				view1$.put('cvoAddr', row.cvoAddr);
				view1$.put('xpos', row.xpos);
				view1$.put('ypos', row.ypos);
				view1$.put('posYn', 'Y'); //대리점 좌표지정 save 여부
				$('#btnView1Save').trigger('click');
			}
		});
	},

	//대리점 저장
	agentSave: function(action) {
// 		if (action == 'D') {
// 			if (!confirm('사용중인 대리점을 삭제할 시 시스템에 영향을 끼칠 수 있습니다.\n정말 삭제하시겠습니까?')) { return false; }
// 		}

		//사용여부 변경시 useChangeYn = 'Y'로 변경한다
		view1$.put('useChangeYn', '');
		if (view1$.find('[name=useYn]:checked').val() != grid1$.getRowData(view1$.get('agentCd')).useYn) {
			view1$.put('useChangeYn', 'Y');
		}

		onm.ajax({
			url: _contextPath_ + '/manage/basis/agentSave.json',
			beforeSend: function() {
				if (!com.beforeChk(view1$, action)) { return false; } //저장전 flag 체크
				if (action != 'D') {if(!user.valid(view1$)) { return false; }} //입력값유효성 체크
				if (action != 'D') {if(!user.bizValid(view1$)) { return false; }} //업무유효성 체크
			},
			data: com.set(view1$, action),
			success: function(res) {
				com.afterSave(res, view1$, action, true);
				if (view1$.find('[name=posYn]').val() == 'Y') {
					com.init(view1$, true);
					grid1$.setGridParam({postData: com.getData(srch$, $('select[name=pageUnit]').val()), page: selPage}).trigger('reloadGrid');
				} else {
					$('#srchBtn').trigger('click');
				}
			}
		});
	},

	//입력값 유효성 체크
	valid: function(area) {
		var isValid = com.validChk(area); //필수, 길이, 형식등의 유효성 체크
		if (isValid) {
			var normalFrom = area.find('[name=normalFrom]').val();
			var normalTo = area.find('[name=normalTo]').val();
			var weekendFrom = area.find('[name=weekendFrom]').val();
			var weekendTo = area.find('[name=weekendTo]').val();

			if (normalFrom != '' && !naw.isTime(normalFrom, 'hhmm')) {
				isValid = false;
				onm.alert('잘못된 평일출발시각입니다.');
			}
			if (normalTo != '' && !naw.isTime(normalTo, 'hhmm')) {
				isValid = false;
				onm.alert('잘못된 평일도착시각입니다.');
			}
			if (weekendFrom != '' && !naw.isTime(weekendFrom, 'hhmm')) {
				isValid = false;
				onm.alert('잘못된 주말출발시각입니다.');
			}
			if (weekendTo != '' && !naw.isTime(weekendTo, 'hhmm')) {
				isValid = false;
				onm.alert('잘못된 주말도착시각입니다.');
			}
			if (normalFrom > normalTo) {
				isValid = false;
				onm.alert('평일도착시각이 평일출발시각을 앞설수 없습니다.');
			}
			if (weekendFrom > weekendTo) {
				isValid = false;
				onm.alert('주말도착시각이 주말출발시각을 앞설수 없습니다.');
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
		<div class="loc_info"><span>대리점관리</span><span>기준정보</span><span>Home</span></div>
		<h2 class="content_title"><span>대리점관리</span></h2>
		<div class="srch_box">
			<table>
				<colgroup>
					<col width="6%">
					<col width="18%">
					<col width="10%">
					<col width="11%">
					<col width="7%">
					<col width="8%">
					<col width="7%">
					<col width="14%">
					<col width="*">
				</colgroup>
				<tr>
					<th>센터</th>
					<td>
						<select name="srchCenterCd" class="chosen" multiple data-placeholder="전체"></select>
					</td>
					<th>대리점코드/명</th>
					<td>
						<input type="text" name="srchAgentNm" maxlength="30" class="enterSrch" />
					</td>
					<th>사용여부</th>
					<td>
						<select name="srchUseYn">
							<option value="">전체</option>
							<option value="Y">사용</option>
							<option value="N">미사용</option>
						</select>
					</td>
					<th>검색어</th>
					<td colspan="5">
						<select name="srchMethod">
							<option value="soCd" selected="selected">사업장</option>
							<option value="chCd">영업그룹</option>
							<option value="empNo">담당직원</option>
<!-- 							<option value="agentCd">대리점코드</option> -->
						</select>
						<input type="text" name="srchWord" maxlength="30" class="enterSrch" />
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
			<span class="buttonset fr">
				<select name="pageUnit"></select>
				<button type="button" id="btnAgentLoc" class="btn_list"><span class="ico_srch" title="대리점위치 조회"></span>대리점위치 조회</button>
				<button type="button" id="btnAgentIoBatch" class="btn_list"><span class="ico_upload" title="엑셀업로드"></span>대리점출도착 일괄설정</button>
				<button type="button" id="btnGrid1Xls" class="btn_list"><span class="ico_xls ico_only"></span></button>
			</span>
		</div>
		<table id="grid1"></table>
		<div id="grid1Pg"></div>
	</div>

	<div class="colgroup-wrap mT20">
		<div id="divView1">
			<div class="caption-pnl">
				<h2>대리점 상세정보 <font color="blue">(최근 1주일동안 SAP에서 등록/업데이트된 대리점은 노란색 배경으로 표시됨)</font></h2>
				<span class="buttonset fr">
<!-- 					<button type="button" class="btn_list_rd" id="btnView1New"><span class="ico_add"></span>신규</button> -->
					<button type="button" class="btn_list_rd" id="btnView1Save"><span class="ico_save"></span>저장</button>
<!-- 					<button type="button" class="btn_list_rd" id="btnView1Del"><span class="ico_del"></span>삭제</button> -->
				</span>
			</div>

			<input type="hidden" name="agentCd" />
			<input type="hidden" name="agentNm" />
			<input type="hidden" name="centerCd" />
			<input type="hidden" name="useChangeYn" />
			<input type="hidden" name="cvoZip" />
			<input type="hidden" name="posYn" />

			<table class="dtl_tbl">
				<colgroup>
					<col width="10%">
					<col width="15%">
					<col width="10%">
					<col width="15%">
					<col width="10%">
					<col width="15%">
					<col width="10%">
					<col width="15%">
				</colgroup>
				<tbody>
					<tr>
						<th>센터명</th>
						<td><input type="text" name="centerNm" maxlength="50" read /></td>
						<th>대리점</th>
						<td><input type="text" name="agentCdNm" maxlength="100" read /></td>
						<th>사업장</th>
						<td><input type="text" name="soCd" maxlength="10" read /></td>
						<th>영업그룹</th>
						<td><input type="text" name="chCd" maxlength="10" read /></td>
					</tr>
					<tr>
						<th>담당직원</th>
						<td><input type="text" name="empNo" maxlength="7" read /></td>
						<th>대리점장</th>
						<td><input type="text" name="staffNm" maxlength="20" read /></td>
						<th>전화번호</th>
						<td><input type="text" name="cvoTelNo" maxlength="13" tel /></td>
						<th>핸드폰</th>
						<td><input type="text" name="cvoHpNo" maxlength="13" tel /></td>
					</tr>
					<tr>
						<th>SAP주소</th>
						<td colspan="3"><input type="text" name="si" maxlength="300" class="w90" read /></td>
						<th>도시</th>
						<td><input type="text" name="cvoSi" read /></td>
						<th>사용여부</th>
						<td>
							<label><input type="radio" name="useYn" value="Y" />사용</label>&nbsp;&nbsp;&nbsp;
							<label><input type="radio" name="useYn" value="N" />미사용</label>
						</td>
					</tr>
					<tr>
						<th>CVO주소</th>
						<td colspan="3">
							<input type="text" name="cvoAddr" maxlength="300" style="width:350px;" />
							<button type="button" id="btnAgentMap" class="btn_list_sm"><span class="ico_srch"></span>찾기</button>
						</td>
						<th>위도</th>
						<td><input type="text" name="xpos" maxlength="30" /></td>
						<th>경도</th>
						<td><input type="text" name="ypos" maxlength="30" /></td>
					</tr>
					<tr>
						<th>평일출발시각</th>
						<td><input type="text" name="normalFrom" maxlength="4" placeholder="형식: HHMI(시분), 예)2230" num /></td>
						<th>평일도착시각</th>
						<td><input type="text" name="normalTo" maxlength="4" placeholder="형식: HHMI(시분), 예)2230" num /></td>
						<th>주말출발시각</th>
						<td><input type="text" name="weekendFrom" maxlength="4" placeholder="형식: HHMI(시분), 예)2230" num /></td>
						<th>주말도착시각</th>
						<td><input type="text" name="weekendTo" maxlength="4" placeholder="형식: HHMI(시분), 예)2230" num /></td>
					</tr>
				</tbody>
			</table>

		</div>
	</div>
</div>
