<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script>
var srch$;
var grid1$;

jQuery(function($) {
	srch$ = com.toBox($('#divSrch'));

	grid1$ = $('#grid1').jqGrid({
		url: _contextPath_ + '/manage/center/carAnal.json',
		pager:'#grid1Pg',
		sortable: false,
		height: 480,
		postData: com.getData(srch$),
		colNames:[
			'순번', '소속센터', '운송사', '대리점', '운행일자',
			'차량코드', '차량번호', '운전자명', '핸드폰', '운행<br>시간',
			'운행거리', '운행횟수', '공회전횟수', '과속횟수', '급가속횟수',
			'급감속횟수'
		],
		cmTemplate: {
			align:'center'
		},
		colModel:[
			{name:'rnum', index:'rnum', width:3, align:'right', sortable:false},
			{name:'centerNm', index:'CENTER_NM', width:7},
			{name:'companyNm', index:'COMPANY_NM', width:6},
			{name:'agentNm', index:'AGENT_NM', width:10},
			{name:'stdDate', index:'STD_DATE', width:8},
			{name:'carId', index:'CAR_ID', width:5},
			{name:'carNo', index:'CAR_NO', width:8},
			{name:'drvNm', index:'DRV_NM', width:6},
			{name:'drvHpNo', index:'DRV_HP_NO', width:9, formatter:'tel'},
			{name:'drvTm', index:'DRV_TM', width:9},
			{name:'drvDis', index:'DRV_DIS', width:5},
			{name:'drvCnt', index:'DRV_CNT', width:5},
			{name:'idleCnt', index:'IDLE_CNT', width:6},
			{name:'overSpdCnt', index:'OVER_SPD_CNT', width:6},
			{name:'burstSpdCnt', index:'BURST_SPD_CNT', width:6},
			{name:'dropSpdCnt', index:'DROP_SPD_CNT', width:6}
		]
	});

	//검색
	$('#srchBtn').on('click', function() {
		grid1$.setGridParam({postData: com.getData(srch$)}).trigger('reloadGrid');
	});
	
	//엑셀다운로드
	$('#xlsBtn').on('click', function() {
		cvo.ajaxFileDown({url: _contextPath_ + '/manage/center/carAnal.xls', data: com.getData(srch$)});
	});

	user.mainInit();
});

var user = {
	//메인페이지 초기화
	mainInit : function() {

		com.setCombo('select', srch$, 'srchCenterCd', '', com.sAuthCenterList());
		
		//검색조건 기본값 설정
		var minDate = onm.addDate(new Date(), -2);
		var maxDate = onm.addDate(new Date(), -1);
		
		//조회기간시작
		srch$.find('[name=srchStrDt]')
			.datepicker('option', 'maxDate', maxDate)
			.val(onm.formatDate(minDate));
		
		//조회기간종료
		srch$.find('[name=srchEndDt]')
			.datepicker('option', {
				'minDate': minDate,
				'maxDate': maxDate
			})
			.val(onm.formatDate(maxDate));

		$('#srchBtn').trigger('click');
	}
}
</script>

<header>
	<div id="divSrch">
		<div class="loc_info"><span>차량 운행 현황</span><span>센터 관리</span><span>Home</span></div>
		<h2 class="content_title"><span>차량 운행 현황</span></h2>
		<div class="srch_box">
			<table>
				<colgroup>
					<col style="width: 5%;">
					<col style="width: 17%;">
					<col style="width: 7%;">
					<col style="width: 20%;">
					<col style="width: 7%;">
					<col style="width: 45%;">
					<col style="width: auto;">
				</colgroup>

				<tr>
					<th>센터</th>
					<td>
						<select name="srchCenterCd" class="chosen" multiple data-placeholder="전체"></select>
					</td>

					<th>조회기간</th>
					<td>
						<input type="text" name="srchStrDt" class="calendar" mindateid="srchEndDt" /> ~ <input type="text" name="srchEndDt" class="calendar" />
					</td>

					<th>세부검색</th>
					<td>
						<select name="srchMethod">
							<option value="carNo">차량번호</option>
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
			<h2><span class="x-icon"></span><span class="x-label">차량 운행 현황</span></h2>
			<span class="buttonset fr">
				<button type="button" id="xlsBtn" class="btn_list" ><span class="ico_xls ico_only"></span></button>
			</span>
		</div>
		<table id="grid1"></table>
		<div id="grid1Pg"></div>
	</div>
</div>