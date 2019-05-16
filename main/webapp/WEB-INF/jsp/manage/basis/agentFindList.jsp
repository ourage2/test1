<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script>
var view1p$;
var srchp$;
var grid1p$;

jQuery(function($) {
	view1p$ = com.toBox($('#popView1'));
	srchp$ = com.toBox($('#popSrch'));

	grid1p$ = $('#grid1p').jqGrid({
		url: _contextPath_ + '/manage/basis/agentFindList.json',
		pager:'#grid1pPg',
		height: 300,
		postData: com.getData(srchp$),
		colNames:[
			'순번', '센터명', '대리점코드', '대리점명', '도시', '사업장', '영업그룹', '담당직원', '대리점장', '전화번호', '핸드폰'
			, 'CVO주소', '위도', '경도', '사용여부', 'centerCd', 'useYn', 'si', 'soNm', 'chNm', 'agentCdNm'
		],

		colModel:[
			{name:'rnum', index:'rnum', width:40, align:'right', sortable:false},
			{name:'centerNm', index:'CENTER_CD', width: 70},
			{name:'agentCd', index:'AGENT_CD', width: 80, key: true},
			{name:'agentNm', index:'AGENT_NM', width: 130},
			{name:'cvoSi', index:'CVO_SI', width: 80},
			{name:'soCd', index:'SO_CD', width: 60},
			{name:'chCd', index:'CH_CD', width: 60},
			{name:'empNo', index:'EMP_NO', width: 60},
			{name:'staffNm', index:'STAFF_NM', width: 60},
			{name:'cvoHpNo', index:'CVO_HP_NO', width: 100, formatter: 'tel'},
			{name:'cvoTelNo', index:'CVO_TEL_NO', width: 100, formatter: 'tel'},
			{name:'cvoAddr', index:'CVO_ADDR', width: 270},
			{name:'xpos', index:'XPOS', hidden: true},
			{name:'ypos', index:'YPOS', hidden: true},
			{name:'useYnNm', index:'USE_YN', hidden: true},
			{name:'centerCd', index:'CENTER_CD', hidden: true},
			{name:'useYn', index:'USE_YN', hidden: true},
			{name:'si', index:'SI', hidden: true},
			{name:'soNm', index:'SO_NM', hidden: true},
			{name:'chNm', index:'CH_NM', hidden: true},
			{name:'agentCdNm', index:'AGENT_CD_NM', hidden: true},
		],

		gridComplete: function() {
		 	srchp$.find('[name=srchCenterCd]').chosen({width: '95%'});
			grid1p$.setGridWidth($('#popView1').width());
		},

		onSelectRow: function(rowId) {
			view1p$.data('callback').apply(this, [grid1p$.getRowData(rowId)]);
			$('#btnPopView1Close').trigger('click');
		}
	});

	//검색
	$('#srchPopBtn').on('click', function() {

		if (srchp$.find('[name=srchMethod]').val() != 'staffNm') {
			if (srchp$.find('[name=srchWord]').val() != '' && srchp$.find('[name=srchWord]').val().length < 3) {
				onm.alert('검색어를 3자 이상 입력해주세요.');
				return false;
			}
		}
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

	com.setCombo('select', srchp$, 'srchCenterCd', '${paramBox.srchCenterCd}', com.sAuthCenterList());
	srchp$.find('[name=srchAgentNm]').val('${paramBox.srchAgentNm}');
// 	srchp$.find('[name=srchUseYn]').val('${paramBox.srchUseYn}');
	if ('${paramBox.srchMethod}') {srchp$.find('[name=srchMethod]').val('${paramBox.srchMethod}');}
	srchp$.find('[name=srchWord]').val('${paramBox.srchWord}');

	$('#srchPopBtn').trigger('click');
}


</script>


<div id="popView1" class="popup-content" style="width:1100px;">
	<header>
		<div id="popSrch">
			<div class="srch_box">
				<table>
					<colgroup>
						<col width="8%">
						<col width="22%">
						<col width="8%">
						<col width="10%">
						<col width="8%">
						<col width="30%">
						<col width="*">
					</colgroup>
					<tr>
						<th>센터</th>
						<td>
							<select name="srchCenterCd" class="chosen" multiple data-placeholder="전체"></select>
						</td>
						<th>대리점명</th>
						<td>
							<input type="text" name="srchAgentNm" maxlength="30" class="enterSrch" />
						</td>
<!-- 						<th>사용여부</th> -->
<!-- 						<td> -->
<!-- 							<select name="srchUseYn"> -->
<!-- 								<option value="">전체</option> -->
<!-- 								<option value="Y">사용</option> -->
<!-- 								<option value="N">사용안함</option> -->
<!-- 							</select> -->
<!-- 						</td> -->
						<th>검색어</th>
						<td>
							<select name="srchMethod">
								<option value="staffNm" selected="selected">대리점장</option>
								<option value="soCd">사업장</option>
								<option value="chCd">영업그룹</option>
								<option value="empNo">담당직원</option>
							</select>
							<input type="text" name="srchWord" maxlength="20" class="enterSrch" />
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
		<div class="caption-pnl">
			<span class="buttonset fr">
				<button type="button" class="btn_list popup-close" id="btnPopView1Close" style="display:none;"><span class="ico_cancle"></span>닫기</button>
			</span>
		</div>
		<table id="grid1p"></table>
		<div id="grid1pPg"></div>
	</div>
</div>