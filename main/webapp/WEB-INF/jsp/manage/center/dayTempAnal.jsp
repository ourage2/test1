<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script>
var srch$;
var grid1$;
var grid2$;

var popupView1$;
var popupGrid1$;

jQuery(function($) {
	srch$ = com.toBox($('#divSrch'));

	grid1$ = $('#grid1').jqGrid({
		url: _contextPath_ + '/manage/center/dayTempAnal.json',
		pager:'#grid1Pg',
		height: 250,
		postData: com.getData(srch$),
		colNames:[
			'순번', '센터', '휴차', '단말기고장', '차량수리',
			'기타', '정상운행', '전체온도건수', '온도위반건수', '온도준수율',
			'전체온도건수', '온도위반건수', '온도준수율', '차이', 'CENTER_CD'
		],
		cmTemplate: {
			align:'center',
			sortable:false
		},
		colModel:[
			{name:'rnum', index:'rnum', width:3, align:'right'},
			{name:'centerNm', index:'CENTER_NM', width:13},
			{name:'restCnt', index:'REST_CNT', width:7},
			{name:'devBknCnt', index:'DEV_BKN_CNT', width:7},
			{name:'fixCnt', index:'FIX_CNT', width:7},

			{name:'etcCnt', index:'ETC_CNT', width:7},
			{name:'norCnt', index:'NOR_CNT', width:7},
			{name:'tempTotCnt2', index:'TEMP_TOT_CNT2', width:7, formatter: 'integer'},
			{name:'tempVioLongCnt', index:'TEMP_VIO_LONG_CNT', width:7, formatter: 'integer'},
			{name:'tempNorRt', index:'TEMP_NOR_RT', width:7, formatter: 'number'},

			{name:'tempTotCnt1', index:'TEMP_TOT_CNT1', width:7, formatter: 'integer'},
			{name:'tempHaccpVioLongCnt', index:'TEMP_HACCP_VIO_LONG_CNT', width:7, formatter: 'integer'},
			{name:'tempHaccpNorRt', index:'TEMP_HACCP_NOR_RT', width:7, formatter: 'number'},
			{name:'difRt', index:'DIF_RT', width:7, formatter: 'number'},
			{name:'centerCd', index:'CENTER_CD', width:7, hidden:true}
		],
		onSelectRow: function(rowId) {
			var postData = user.getGrid2PostData();
			grid2$.setGridParam({postData: postData}).trigger('reloadGrid');
		}

	});

	grid2$ = $('#grid2').jqGrid({
		url: _contextPath_ + '/manage/center/dayTempAnalDtl.json',
		pager:'#grid2Pg',
		height: 250,
		postData: com.getData(srch$),
		colNames:[
			'순번', '센터', '차량소속', '차량번호', '운전자',
			'차량구분', '전체온도건수', '온도위반건수', '온도준수율', '전체온도건수',
			'온도위반건수', '온도준수율', 'stdDate', 'carId', 'centerCd',
			'drvTelNo', 'drvHpNo', 'bizCd'
		],
		cmTemplate: {
			align:'center',
			sortable:false
		},
		colModel:[
			{name:'rnum', index:'rnum', width:3, align:'right', sortable:false},
			{name:'centerNm', index:'CENTER_NM', width:8},
			{name:'companyNm', index:'COMPANY_NM', width:10},
			{name:'carNo', index:'CAR_NO', width:9},
			{name:'drvNm', index:'DRV_NM', width:9},

			{name:'restNm', index:'REST_NM', width:9},
			{name:'tempTotCnt2', index:'TEMP_TOT_CNT2', width:8, formatter: 'integer'},
			{name:'tempVioLongCnt', index:'TEMP_VIO_LONG_CNT', width:8, formatter: 'integer'},
			{name:'tempNorRt', index:'TEMP_NOR_RT', width:8, formatter: 'number'},
			{name:'tempTotCnt1', index:'TEMP_TOT_CNT1', width:8, formatter: 'integer'},

			{name:'tempHaccpVioLongCnt', index:'TEMP_HACCP_VIO_LONG_CNT', width:8, formatter: 'integer'},
			{name:'tempHaccpNorRt', index:'TEMP_HACCP_NOR_RT', width:8, formatter: 'number'},
			{name:'stdDate', index:'STD_DATE', hidden:true},
			{name:'carId', index:'CAR_ID', hidden:true},
			{name:'centerCd', index:'CENTER_CD', hidden:true},

			{name:'drvTelNo', index:'DRV_TEL_NO', hidden:true},
			{name:'drvHpNo', index:'DRV_HP_NO', hidden:true},
			{name:'bizCd', index:'BIZ_CD', hidden:true}
		],
		ondblClickRow: function () {
			onm.ajaxModal({
				url: _contextPath_ + '/manage/center/dayCarTempAnalHist.pop',
				dialogOptions: {
					title: '온도 준수율 세부 현황'
				}
			});
		}
	});

	grid1$.setGroupHeaders({
		useColSpanStyle: true,
		groupHeaders: [
			{startColumnName: 'tempTotCnt2', numberOfColumns: 3, titleText: '정상차량 온도 준수율(0도 ~ 5도)'},
			{startColumnName: 'tempTotCnt1', numberOfColumns: 3, titleText: '정상차량 온도 준수율(0도 ~ 10도)'}
		]
	});

	grid2$.setGroupHeaders({
		useColSpanStyle: true,
		groupHeaders: [
			{startColumnName: 'tempTotCnt2', numberOfColumns: 3, titleText: '정상차량 온도 준수율(0도 ~ 5도)'},
			{startColumnName: 'tempTotCnt1', numberOfColumns: 3, titleText: '정상차량 온도 준수율(0도 ~ 10도)'}
		]
	});

	//검색
	$('#srchBtn').on('click', function() {
		grid2$.clearGridData();
		grid1$.setGridParam({postData: com.getData(srch$)}).trigger('reloadGrid');
	});

	// 엑셀다운로드
	$('#xlsBtn1').on('click', function () {
		cvo.ajaxFileDown({url: _contextPath_ + '/manage/center/dayTempAnal.xls', data: com.getData(srch$)});
	});

	//엑셀다운로드
	$('#xlsBtn2').on('click', function () {
		cvo.ajaxFileDown({url: _contextPath_ + '/manage/center/dayTempAnalDtl.xls', data: user.getGrid2PostData()});
	});

	user.mainInit();
});

var user = {
	//메인페이지 초기화
	mainInit : function() {

		com.setCombo('select', srch$, 'srchCenterCd', '', com.sAuthCenterList());
		com.setCombo('select', srch$, 'srchBizCd', '', com.getCdList('020'));

		//검색조건 기본값 설정
		var maxDate = onm.addDate(new Date(), -1);

		srch$.find('[name=srchDt]')
			.datepicker('option', 'maxDate', maxDate)
			.val(onm.formatDate(maxDate));

		$('#srchBtn').trigger('click');
	},

	getGrid2PostData: function () {
		var rowData = grid1$.getSelGridData()[0];
		var postData = grid1$.getGridParam('postData');
		postData.centerCd = rowData.centerCd;
		return postData;
	},

	popupInit: function() {
		var rowData = grid2$.getSelGridData()[0];
		com.setVal(popupView1$, rowData);
		popupGrid1$.setGridWidth(1158);
		popupGrid1$.setGridParam({postData: rowData}).trigger('reloadGrid');
	}
}
</script>

<header>
	<div id="divSrch">
		<div class="loc_info"><span>일자별 온도준수율</span><span>센터 관리</span><span>Home</span></div>
		<h2 class="content_title"><span>일자별 온도준수율</span></h2>
		<div class="srch_box">
			<table>
				<colgroup>
					<col style="width: 5%">
					<col style="width: 14%">

					<col style="width: 7%">
					<col style="width: 10%">

					<col style="width: 9%">
					<col style="width: 10%">

					<col style="width: auto">
				</colgroup>

				<tr>
					<th>센터</th>
					<td>
						<select name="srchCenterCd" class="chosen" multiple data-placeholder="전체"></select>
					</td>

					<th>조회일</th>
					<td>
						<input type="text" name="srchDt" class="calendar"/>
					</td>

					<th>차량업무구분</th>
					<td>
						<select name="srchBizCd"></select>
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
			<h2><span class="x-icon"></span><span class="x-label">센터별 차량 온도 준수율</span></h2>
			<span class="buttonset fr">
				<button type="button" id="xlsBtn1" class="btn_list" ><span class="ico_xls ico_only"></span></button>
			</span>
		</div>
		<table id="grid1"></table>
		<div id="grid1Pg"></div>
	</div>
	<div class="colgroup-wrap mT20">
		<div class="caption-pnl">
			<h2><span class="x-icon"></span><span class="x-label">차량별 온도 준수율</span></h2>
			<span class="buttonset fr">
				<button type="button" id="xlsBtn2" class="btn_list" ><span class="ico_xls ico_only"></span></button>
			</span>
		</div>
		<table id="grid2"></table>
		<div id="grid2Pg"></div>
	</div>
</div>