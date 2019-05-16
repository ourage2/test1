<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script>
var grid1$;
var grid2$;
var srch$;

jQuery(function($) {
	srch$ = com.toBox($('#divSrch'));

	grid1$ = $('#grid1').jqGrid({
		url: _contextPath_ + '/manage/set/noregAgentList.json',
		pager:'#grid1Pg',
		height: 450,
		postData: com.getData(srch$),
		colNames: ['순번', '일련번호', '서버수신시간', '납품예정일', '센터코드', '대리점코드', '납품번호', '연동TID 1', '연동TID 2'],
		colModel: [
			{name:'rnum', index:'rnum', width:4, align:'right', sortable:false},
			{name:'seq', index:'SEQ', key: true, hidden:true},
			{name:'insertDt', index:'INSERT_DT', width: 12, formatter:'datetime'},
			{name:'deliDt', index:'DELI_DT', width: 12, formatter:'datetime'},
			{name:'centerCd', index:'CENTER_CD', width: 9, sortable:false},
			{name:'agentCd', index:'AGENT_CD', width: 9},
			{name:'deliNo', index:'DELI_NO', width: 9},
			{name:'tid1', index:'TID1', width: 8},
			{name:'tid2', index:'TID2', width: 8},
		],
	});

// 	$('#btnNoregAgent').on('click', function() {user.noregAgentPop();}); //미등록대리점목록 팝업

	$('select[name=pageUnit]').on('change', function () {
		$('#srchBtn').trigger('click');
	});

	//엑셀다운로드
	$('#btnGrid1Xls').on('click', function() {
		cvo.ajaxFileDown({url: _contextPath_ + '/manage/set/noregAgentList.xls', data: com.getData(srch$)});
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
		//검색조건 기본값 설정
		srch$.find('[name=srchStrDt]').val(onm.getBeforeMonth());
		srch$.find('[name=srchEndDt]').val(onm.todayFmt());

		com.setCombo('select', $('#main'), 'pageUnit', '${paramBox.pageUnit}', com.getCdList('PAGE_UNIT'), null, 60);
		$('#srchBtn').trigger('click');
	},

	//미등록대리점목록 팝업
// 	noregAgentPop: function() {
// 		onm.ajaxModal({
// 			url: _contextPath_ + '/manage/set/noregAgentList.pop',
// 			dialogOptions: { title: '미등록대리점목록'},
// 			data: {
// 				data : JSON.stringify(com.getData(srch$))
// 			},
// 		});
// 	}

}
</script>


<header>
	<div id="divSrch">
		<div class="loc_info"><span>미등록대리점 내역</span><span>환경설정</span><span>Home</span></div>
		<h2 class="content_title"><span>미등록대리점 내역</span></h2>
		<div class="srch_box">
			<table>
				<colgroup>
					<col width="10%">
					<col width="20%">
					<col width="10%">
					<col width="17%">
					<col width="10%">
					<col width="17%">
					<col width="*">
				</colgroup>
				<tr>
					<th>조회기간</th>
					<td>
						<input type="text" name="srchStrDt" class="calendar" mindateid="srchEndDt" /> ~ <input type="text" name="srchEndDt" class="calendar" maxdateid="srchStrDt" />
					</td>

					<th>대리점코드</th>
					<td>
						<input type="text" name="srchAgentCd" maxlength="20" class="enterSrch" />
					</td>
					<th>납품번호</th>
					<td>
						<input type="text" name="srchDeliNo" maxlength="20" class="enterSrch" />
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
<!-- 				<button type="button" id="btnNoregAgent" class="btn_list"><span class="ico_srch" title="미등록대리점목록"></span>미등록대리점목록</button> -->
				<button type="button" id="btnGrid1Xls" class="btn_list" ><span class="ico_xls ico_only"></span></button>
			</span>
		</div>
		<table id="grid1"></table>
		<div id="grid1Pg"></div>
	</div>
</div>