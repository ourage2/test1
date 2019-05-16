<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script>
var view1p$;
var srchp$;
var grid1p$;
var multiYn = '${paramBox.multiYn}';

jQuery(function($) {
	view1p$ = com.toBox($('#popView1'));
	srchp$ = com.toBox($('#popSrch'));

	var gridDefault = {
		url: _contextPath_ + '/manage/basis/userFindList.json',
		pager:'#grid1pPg',
		height: 300,
		postData: com.getData(srchp$),

		colNames:['순번', '센터', '권한', '아이디', '성명', '전화번호', '핸드폰', '팩스', 'centerCd', 'agentCd', 'authCenterCd', 'authCd', 'acDiv', 'pushYn', 'useYn'],
		colModel:[
			{name:'rnum', index:'rnum', width:4, align:'right', sortable:false},
			{name:'acNm', index:'AC_NM', width:9, sortable:false},
			{name:'authNm', index:'AUTH_CD', width:10, sortable:false},
			{name:'userId', index:'USER_ID', width:7, key: true},
			{name:'userNm', index:'USER_NM', width:8},
			{name:'telNo', index:'TEL_NO', width:10, formatter: 'tel'},
			{name:'hpNo', index:'HP_NO', width:10, formatter: 'tel'},
			{name:'faxNo', index:'FAX_NO', width:10, formatter: 'tel'},
			{name:'centerCd', index:'CENTER_CD', hidden: true},
			{name:'agentCd', index:'AGENT_CD', hidden: true},
			{name:'authCenterCd', index:'AUTH_CENTER_CD', hidden: true},
			{name:'authCd', index:'AUTH_CD', hidden: true},
			{name:'acDiv', index:'AC_DIV', hidden: true},
			{name:'pushYn', index:'PUSH_YN', hidden: true},
			{name:'useYn', index:'USE_YN', hidden: true},
		],

		gridComplete: function() {
		 	srchp$.find('[name=srchCenterCd]').chosen({width: '95%'});
			grid1p$.setGridWidth($('#popView1').width() - 18);

// 			if (grid1p$.getGridParam('records') == 1) {
// 				$("#grid1p tr").eq(1).trigger("click");
// 			}
		},

// 		loadComplete: function(data) {
// 			if (data.list.length == 1) {
// 				$(this).setSelection(data.list[0].userId);
// 			}
// 		}
	}

	//단일선택시 onSeletRow에 이벤트를 삽입, 멀티선택시 버튼및 함수에 이벤트삽입, grid 옵션 multiselect: true 추가
	if (multiYn == 'Y') {
		$.extend(gridDefault, {multiselect: true});
		$('#popSel').show();
	} else {
		$.extend(gridDefault, {
			onSelectRow: function(rowId) {
				view1p$.data('callback').apply(this, [grid1p$.getRowData(rowId)]);
				$('#btnPopView1Close').trigger('click');
			}
		});
		$('#popSel').hide();
	}

	grid1p$ = $('#grid1p').jqGrid(gridDefault);

	$('#btnSel').on('click', function() {fnSel();}); //사용자 선택

	//검색
	$('#srchPopBtn').on('click', function() {
		grid1p$.setGridParam({postData: com.getData(srchp$)}).trigger('reloadGrid');
	});

	init();
});


//페이지 초기화
function init() {

	srchp$.find('.enterSrch').keydown(function(event) {
		if (event.which == 13) {
			$(this).parent().parent().parent().find('button').each(function(){
				if(this.type == 'button') {
					$(this).trigger('click');
				}
			});
		}
	});

	com.setCombo('select', srchp$, 'srchCenterCd', '${paramBox.srchCenterCd}', com.sAuthCenterList()); //콤보 list를 가지고 그릴 경우
	com.setCombo('select', srchp$, 'srchAuthCd', '${paramBox.srchAuthCd}', fnAuthCdList('C'), '전체');
	if ('${paramBox.srchMethod}') {srchp$.find('[name=srchMethod]').val('${paramBox.srchMethod}');}
	srchp$.find('[name=srchWord]').val('${paramBox.srchWord}');

	$('#srchPopBtn').trigger('click');
}

//사용자 선택
function fnSel() {
	if (grid1p$.getGridParam('selarrrow').length <= 0) {
		onm.alert('사용자를 선택해주세요.');
		return;
	}

	var list = [];
	var selIds = grid1p$.getGridParam('selarrrow');
	for (var idx = 0; idx < selIds.length; idx++) {
		list.push(grid1p$.getRowData(selIds[idx]));
	}
	view1p$.data('callback').apply(this, [selIds, list]);
	$('#btnPopView1Close').trigger('click');
}

</script>


<div id="popView1" class="popup-content" style="width:1050px;">
	<header>
		<div id="popSrch">
			<div class="srch_box">

				<input type="hidden" name="srchAcDiv" value="${paramBox.srchAcDiv}" />
				<input type="hidden" name="srchUseYn" value="${paramBox.srchUseYn}" />
				<input type="hidden" name="srchAgentCd" value="${paramBox.srchAgentCd}" />
				<input type="hidden" name="pushIds" value="${paramBox.pushIds}" />

				<table>
					<colgroup>
						<col width="7%">
						<col width="20%">
						<col width="7%">
						<col width="9%">
						<col width="7%">
						<col width="9%">
						<col width="7%">
						<col width="24%">
						<col width="*">
					</colgroup>
					<tr>
						<th>센터</th>
						<td>
							<select name="srchCenterCd" class="chosen" multiple data-placeholder="전체"></select>
						</td>
						<th>권한</th>
						<td>
							<select name="srchAuthCd"></select>
						</td>
						<th>아이디</th>
						<td>
							<input type="text" name="srchUserId" maxlength="10" style="width:100px" class="enterSrch" />
						</td>
						<th>검색어</th>
						<td>
							<select name="srchMethod">
								<option value="userNm" selected="selected">성명</option>
								<option value="telNm">전화번호</option>
								<option value="hpNo">핸드폰</option>
								<option value="faxNo">팩스번호</option>
							</select>
							<input type="text" name="srchWord" maxlength="10" style="width:100px" class="enterSrch" />
						</td>
						<td>
							<div class="srch_btn">
								<button type="button" id="srchPopBtn" class="btn_srch"><span class="ico_srch"></span>검색</button>
							</div>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</header>

	<div class="colgroup-wrap">
		<div id="popSel" class="caption-pnl">
			<span class="buttonset fr">
				<button type="button" class="btn_list" id="btnSel" ><span class="ico_apply"></span>선택</button>
				<button type="button" class="btn_list popup-close" id="btnPopView1Close"><span class="ico_cancle"></span>닫기</button>
			</span>
		</div>
		<table id="grid1p"></table>
		<div id="grid1pPg"></div>
	</div>

</div>