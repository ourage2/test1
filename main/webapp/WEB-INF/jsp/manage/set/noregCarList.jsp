<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script>
var srchp$;
var grid1p$;

jQuery(function($) {
	srchp$ = com.toBox($('#popSrch'));
	data = JSON.parse('${paramBox.data}');
	com.setVal(srchp$, data);

	grid1p$ = $('#grid1p').jqGrid({
		url: _contextPath_ + '/manage/set/noregCarList.json',
		pager:'#grid1pPg',
		height: 300,
		postData: com.getData(srchp$),

		colNames:['순번', '일련번호', '차량번호', '단말기ID', '최종수신시간', '최종위도', '최종경도', '최종운행거리'],
		colModel:[
			{name:'rnum', index:'rnum', width:4, align:'right', sortable:false},
			{name:'seq', index:'B.SEQ', key: true, hidden:true},
			{name:'carNo', index:'B.CAR_NO', width:7},
			{name:'carTid', index:'B.CAR_TID', width:7},
			{name:'devDt', index:'B.DEV_DT', width:10, formatter: 'datetime'},
			{name:'xpos', index:'B.XPOS', width:7},
			{name:'ypos', index:'B.YPOS', width:7},
			{name:'dayTotDis', index:'B.DAY_TOT_DIS', width:7}
		],

		gridComplete: function() {
			grid1p$.setGridWidth($('#popView1').width() - 18);
		},
	});

	init();
});

//페이지 초기화
function init() {
	grid1p$.setGridParam({postData: com.getData(srchp$)}).trigger('reloadGrid');
}

</script>


<div id="popView1" class="popup-content" style="width:700px;">
	<header>
		<div id="popSrch">
			<input type="hidden" name="srchStrDt" value="" />
			<input type="hidden" name="srchEndDt" value="" />
			<input type="hidden" name="srchCarTid" value="" />
			<input type="hidden" name="srchCarNo" value="" />
		</div>
	</header>

	<div class="colgroup-wrap">
		<div id="popSel" class="caption-pnl">
			<span class="buttonset fr">
				<button type="button" class="btn_list popup-close" id="btnPopView1Close"><span class="ico_cancle"></span>닫기</button>
			</span>
		</div>
		<table id="grid1p"></table>
		<div id="grid1pPg"></div>
	</div>

</div>