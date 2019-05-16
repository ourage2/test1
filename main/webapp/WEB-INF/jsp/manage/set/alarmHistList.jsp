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
		url: _contextPath_ + '/manage/set/alarmHistList.json',
		pager:'#grid1Pg',
		height: 450,
		postData: com.getData(srch$),
// 		colNames: ['순번', 'SEQ', '발송번호', '발송일시', '알림종류', '발송자', '수신자', '발송결과', '수신결과', '수신결과내용', '제목', 'sendTxt'],
		colNames: ['순번', 'SEQ', '발송번호', '발송일시', '알림종류', '발송자', '수신자', '발송결과', '수신결과', '제목', 'sendTxt'],
		colModel: [
			{name:'rnum', index:'rnum', width:3, align:'right', sortable:false},
			{name:'seq', index:'SEQ', key: true, hidden:true},
			{name:'sendNo', index:'SEND_NO', align:'right', width: 5},
			{name:'sendDt', index:'SEND_DT', width: 10, formatter:'datetime'},
			{name:'pushTypeNm', index:'PUSH_TYPE_NM', width: 7, sortable:false},
			{name:'sendNm', index:'SEND_NM', width: 9, sortable:false},
			{name:'recvNm', index:'RECV_NM', width: 9, sortable:false},
			{name:'sendFlag', index:'SEND_FLAG', width: 5},
			{name:'recvFlag', index:'RECV_FLAG', width: 5},
// 			{name:'recvTxt', index:'RECV_TXT', width: 7},
			{name:'sendTitle', index:'SEND_TITLE', width: 14},
			{name:'sendTxt', index:'SEND_TXT', hidden:true}
		],

		onSelectRow: function(rowId) {
			com.setVal(view1$, grid1$.getRowData(rowId));
		}

	});

	$('select[name=pageUnit]').on('change', function () {
		$('#srchBtn').trigger('click');
	});

	//엑셀다운로드
	$('#btnGrid1Xls').on('click', function() {
		cvo.ajaxFileDown({url: _contextPath_ + '/manage/set/alarmHistList.xls', data: com.getData(srch$)});
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
		com.init(view1$, true);

		com.setCombo('select', $('#main'), 'pageUnit', '${paramBox.pageUnit}', com.getCdList('PAGE_UNIT'), null, 60);
		$('#srchBtn').trigger('click');
	}

}
</script>


<header>
	<div id="divSrch">
		<div class="loc_info"><span>알림발송이력</span><span>환경설정</span><span>Home</span></div>
		<h2 class="content_title"><span>알림발송이력</span></h2>
		<div class="srch_box">
			<table>
				<colgroup>
					<col width="9%">
					<col width="22%">
					<col width="9%">
					<col width="20%">
					<col width="9%">
					<col width="15%">
					<col width="*">
				</colgroup>
				<tr>
					<th>발송일</th>
					<td>
						<input type="text" name="srchStrDt" class="calendar" mindateid="srchEndDt" /> ~ <input type="text" name="srchEndDt" class="calendar" maxdateid="srchStrDt" />
					</td>
					<th>발송결과</th>
					<td>
						<select name="srchSendFlag" style="width:100px">
							<option value="">전체</option>
							<option value="200">성공(200)</option>
							<option value="NOT">전송전</option>
							<option value="ETC">기타</option>
						</select>
					</td>
					<th>수신결과</th>
					<td>
						<select name="srchRecvFlag" style="width:100px">
							<option value="">전체</option>
							<option value="200">성공(200)</option>
							<option value="NOT">수신전</option>
							<option value="ETC">기타</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>알림종류</th>
					<td>
						<select name="srchPushType" style="width:100px">
							<option value="">전체</option>
							<option value="01">공장출발</option>
							<option value="02">차량온도이탈</option>
							<option value="03">창고온도이탈</option>
							<option value="04">기타전송</option>
						</select>
					</td>
					<th>검색어</th>
					<td colspan="3">
						<select name="srchMethod">
							<option value="sendId" selected="selected">발송자ID</option>
							<option value="sendNm">발송자명</option>
							<option value="recvId">수신자ID</option>
							<option value="recvNm">수신자명</option>
							<option value="sendTitle">제목</option>
						</select>
						<input type="text" name="srchWord" maxlength="30" class="enterSrch" />
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

<div id="main" style="height:calc(100% - 200px)">
	<div class="colgroup-wrap">
		<div class="colgroup-4-5">
			<div class="caption-pnl">
<!-- 				<h2>알림발송이력</h2> -->
				<span class="buttonset fr">
					<select name="pageUnit"></select>
					<button type="button" id="btnGrid1Xls" class="btn_list" ><span class="ico_xls ico_only"></span></button>
				</span>
			</div>
			<table id="grid1"></table>
			<div id="grid1Pg"></div>
		</div>

		<div class="colgroup-1-5" id="divView1">
			<div class="caption-pnl"></div>
			<table class="dtl_tbl">
				<colgroup>
					<col width="30%">
					<col width="*">
				</colgroup>
				<tr>
					<th colspan="2">발송내용</th>
				</tr>
				<tr>
					<td colspan="2">
						<textarea name="sendTxt" maxlength="2000" cols="30" rows="27" read></textarea>
					</td>
				</tr>
			</table>
		</div>

	</div>
</div>