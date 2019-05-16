<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script>
var grid1$;
var srch$;

jQuery(function($) {
	srch$ = com.toBox($('#divSrch'));

	grid1$ = $('#grid1').jqGrid({
		url: _contextPath_ + '/manage/set/userHistList.json',
		pager:'#grid1Pg',
		height: 450,
		postData: com.getData(srch$),
		colNames: ['순번', '일련번호', '사용자ID', '성명', '접속IP', '접속일시', '구분', '웹/모바일', 'loginGb', 'webMobGb'],
		colModel: [
			{name:'rnum', index:'rnum', width:3, align:'right', sortable:false},
			{name:'seq', index:'SEQ', key: true, hidden:true},
			{name:'userId', index:'USER_ID', width: 10},
			{name:'userNm', index:'USER_ID', width: 10, sortable:false},
			{name:'ipAddr', index:'IP_ADDR', width: 15},
			{name:'insertDt', index:'INSERT_DT', width: 15, formatter:'datetime'},
			{name:'loginGbNm', index:'LOGIN_GB', width: 5},
			{name:'webMobGbNm', index:'WEB_MOB_GB', width: 5},
			{name:'loginGb', index:'LOGIN_GB', hidden:true},
			{name:'webMobGb', index:'WEB_MOB_GB', hidden:true}
		],

	});

	$('select[name=pageUnit]').on('change', function () {
		$('#srchBtn').trigger('click');
	});

	//엑셀다운로드
	$('#btnGrid1Xls').on('click', function() {
		cvo.ajaxFileDown({url: _contextPath_ + '/manage/set/userHistList.xls', data: com.getData(srch$)});
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
	}

}
</script>


<header>
	<div id="divSrch">
		<div class="loc_info"><span>사용자접속로그</span><span>환경설정</span><span>Home</span></div>
		<h2 class="content_title"><span>사용자접속로그</span></h2>
		<div class="srch_box">
			<table>
				<colgroup>
					<col width="8%">
					<col width="20%">
					<col width="6%">
					<col width="11%">
					<col width="9%">
					<col width="11%">
					<col width="6%">
					<col width="20%">
					<col width="*">
				</colgroup>
				<tr>
					<th>접속일</th>
					<td>
						<input type="text" name="srchStrDt" class="calendar" mindateid="srchEndDt" /> ~ <input type="text" name="srchEndDt" class="calendar" maxdateid="srchStrDt" />
					</td>

					<th>구분</th>
					<td>
						<select name="srchLoginGb" style="width:100px">
							<option value="">전체</option>
							<option value="1">로그인</option>
							<option value="2">로그아웃</option>
						</select>
					</td>
					<th>웹/모바일</th>
					<td>
						<select name="srchWebMobGb" style="width:100px">
							<option value="">전체</option>
							<option value="W">웹</option>
							<option value="M">모바일</option>
						</select>
					</td>
					<th>검색어</th>
					<td>
						<select name="srchMethod">
							<option value="srchUserId" selected="selected">사용자ID</option>
							<option value="srchUserNm">성명</option>
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
</div>