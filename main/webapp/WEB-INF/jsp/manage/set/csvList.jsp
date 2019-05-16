<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script>
var grid1$;
var srch$;

jQuery(function($) {
	srch$ = com.toBox($('#divSrch'));

	grid1$ = $('#grid1').jqGrid({
		url: _contextPath_ + '/manage/set/csvList.json',
		pager:'#grid1Pg',
		height: 450,
		postData: com.getData(srch$),
		colNames: ['순번', '일련번호', '구분', '시작일', '종료일', '센터', '데이터수', '파일크기 (byte)', '다운로드', 'centerCd'],
		colModel: [
			{name:'rnum', index:'rnum', width:3, align:'right', sortable:false},
			{name:'csvSeq', index:'csvSeq', key: true, hidden:true},
			{name:'divNm', index:'DIV', width: 7},
			{name:'strDate', index:'STR_DATE', width: 8},
			{name:'endDate', index:'END_DATE', width: 8},
			{name:'centerNm', index:'CENTER_CD', width: 8, sortable:false},
			{name:'cnt', index:'CNT', width: 7, align: 'right', formatter:'amount'},
			{name:'fileSize', index:'FILE_SIZE', width: 7, align: 'right', formatter:'amount'},
			{name:'fileNm', index:'FILE_NM', width: 20, formatter:user.csvDown},
			{name:'centerCd', index:'CENTER_CD', hidden:true},
// 			{name:'saveFileNm', index:'SAVE_FILE_NM', hidden:true},
// 			{name:'saveFilePath', index:'SAVE_FILE_PATH', hidden:true}
		],

	});

	$('select[name=pageUnit]').on('change', function () {
		$('#srchBtn').trigger('click');
	});

	//검색
	$('#srchBtn').on('click', function() {
		grid1$.setGridParam({postData: com.getData(srch$, $('select[name=pageUnit]').val()), page: 1}).trigger('reloadGrid');
	});

	user.init();
});

var user = {
	//페이지 초기화
	init : function() {

		com.setCombo('select', $('#main'), 'pageUnit', '${paramBox.pageUnit}', com.getCdList('PAGE_UNIT'), null, 60);

		onm.setDatePeriod(srch$.find('[name=srchStrDt]'), srch$.find('[name=srchEndDt]'), '12m');
		com.setCombo('select', srch$, 'srchCenterCd', '${paramBox.srchCenterCd}', com.sAuthCenterList()); //콤보 list를 가지고 그릴 경우
		$('#srchBtn').trigger('click');
	},

	//대용량엑셀 다운로드
	csvDown: function(cellVal, options, rowdata) {
		return '<a href="javascript:com.csvDown(' + rowdata.csvSeq + ');">' + cellVal + '</a>';
	}

}
</script>


<header>
	<div id="divSrch">
		<div class="loc_info"><span>대용량엑셀 다운로드</span><span>환경설정</span><span>Home</span></div>
		<h2 class="content_title"><span>대용량엑셀 다운로드</span></h2>
		<div class="srch_box">
			<table>
				<colgroup>
					<col width="8%">
					<col width="20%">
					<col width="8%">
					<col width="10%">
					<col width="8%">
					<col width="20%">
					<col width="*">
				</colgroup>
				<tr>
					<th>시작일</th>
					<td>
						<input type="text" name="srchStrDt" class="calendar" mindateid="srchEndDt" /> ~ <input type="text" name="srchEndDt" class="calendar" maxdateid="srchStrDt" />
					</td>
					<th>구분</th>
					<td>
						<select name="srchDiv" style="width:100px;">
							<option value="">전체</option>
							<option value="CAR">차량</option>
							<option value="CARGO">창고</option>
						</select>
					</td>
					<th>센터</th>
					<td>
						<select name="srchCenterCd" class="chosen" multiple data-placeholder="전체"></select>
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
		<div class="caption-pnl">
			<span class="buttonset fr">
				<select name="pageUnit"></select>
			</span>
		</div>
		<table id="grid1"></table>
		<div id="grid1Pg"></div>
	</div>
</div>