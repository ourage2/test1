<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<!-- 카카오맵 api 로드 -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=<spring:eval expression="@config['daum.map.appkey']" />&libraries=services,clusterer"></script>

<script src="<c:url value="/resources/js/map/cvo.map.library.js" />"></script>
<script src="<c:url value="/resources/js/map/cvo.map.layout.util.js" />"></script>

<script type="text/javascript" src="<c:url value="/resources/js/highchart/highcharts.js"/>"></script>
<script type="text/javascript" src="<c:url value="/resources/js/highchart/module/boost.js"/>"></script>
<script type="text/javascript" src="<c:url value="/resources/js/highchart/module/broken-axis.js"/>"></script>

<style>
/* 트리 헤더 숨기기 */
.ui-jqgrid-hdiv { display:none !important; }
.ui-jqgrid .ui-jqgrid-btable tbody .jqgrow { height: 35px; }

/* 트리 가운데 정렬 */
/* .ui-jqgrid .tree-wrap-ltr { margin-left:100px !important; } */
.ui-jqgrid .tree-wrap-ltr { margin-left:40px !important; }

.popup_table {/*position:absolute; top:238px; left:304px; */width:490px; border:2px solid #3f5f87; background:#ffffff; z-index:1000; margin-top: -260px;}
.popup_table th {background:#3f5f87; height:34px; line-height:32px; color:#ffffff; text-align:left; padding-left:10px;}
.popup_table th a {display:inline; position:absolute; top:0px; right:0px; width:17px; height:17px; background:url("<c:url value="/resources/image/map/popup_close.gif" />") 0 0 no-repeat; text-indent:-999999em; margin:7px 7px 0 0;}
.popup_table td {height:30px; line-height:30px; text-align:left; border-bottom:1px solid #d2d2d2; padding-left:10px; font-size:11px;}
.popup_table .pt_head {background:#ececec; font-weight:bold; border-right:1px solid #d2d2d2;  border-left:1px solid #d2d2d2;}

/* .popup_table .pt_on {background:#3f5f87 url("<c:url value="/resources/image/map/icon_on2.gif" />") 8px 12px no-repeat;} */
.popup_table .pt_on {width:100px; color:#FFFFFF; font-size:9px; background-color:#00B263; padding: 2px 5px 3px 5px;}
/* .popup_table .pt_off {background:#3f5f87 url("<c:url value="/resources/image/map/icon_off2.gif" />") 8px 12px no-repeat;} */
.popup_table .pt_off {width:100px; color:#FFFFFF; font-size:9px; background-color:#949494; padding: 2px 5px 3px 5px;}
.popup_table .pt_vio {width:100px; color:#FFFFFF; font-size:9px; background-color:#FF333D; padding: 2px 5px 3px 5px;}

.popup_table .no_b {border-left:none;}
.popup_table td a {display:inline; padding:2px 10px 4px 10px; border-radius:3px; margin-left:5px; font-weight:bold; border:1px solid #373737; background:#444444; color:#ffffff;}

.cell-wrapper { display:inline-block; margin-top:2px; }
.cell-wrapperleaf { display:inline-block; margin-top:2px; cursor:pointer; }

.monitoring-cago h3 { margin: 10px 0px -5px 0px !important; }
.center-list li { margin-top: 10px; }

.caricon_on {display:inline-block; width:17px; color:#FFFFFF; font-size:9px; background-color:#00B263; padding: 2px 5px 3px 5px; text-align: center;}
.caricon_off {display:inline-block; width:17px; color:#FFFFFF; font-size:9px; background-color:#949494; padding: 2px 5px 3px 5px; text-align: center;}

#divView2 { overflow:auto;}

.tempImg { height:15px; }

</style>

<script>
var carInterval = null;
var cargoInterval = null;
var daumMap;
var daumBounds;
var daumGeocoder;

var grid1$;
var grid2$;
var srch1$;
var srch2$;
var view1$;
var view2$;
var chart1$;

jQuery(function($) {
	srch1$ = com.toBox($('#divSrch1'));
	srch2$ = com.toBox($('#divSrch2'));
	view1$ = com.toBox($('#divView1'));
	view2$ = com.toBox($('#divView2'));

	user.mapInit();
	user.carOnOffCnt();

	grid1$ = $('#grid1').jqGrid({
		url: _contextPath_ + '/manage/center/tempNowList.json',
		height: 400,
		width:280,
		postData: com.getData(srch1$),
		treeGrid: true,
		treeGridModel: 'adjacency',
		ExpandColumn: 'CAR_NO_ICON',
		ExpandColClick: true,
		colNames:[
					'차량명', '센터코드', '시동ON/OFF', '위도', '경도', 'treeKey', 'lv', 'leaf', 'ex', '차량명', '차량ID', '운전자명', 'ch1Vio', 'ch2Vio', 'ch1', 'ch2'
		],
		colModel:[
			{name:'carNo', index:'CAR_NO_ICON', align: 'left', formatter: user.carIcon},
			{name:'grpCd', index:'GRP_CD', width:9, hidden: true},
			{name:'turnOnOff', index:'TURN_ON_OFF', hidden: true},
			{name:'xpos', index:'XPOS', hidden: true},
			{name:'ypos', index:'YPOS', hidden: true},
			{name:'treeKey', index:'TREE_KEY', hidden: true, key: true},
			{name:'lv', index:'LV', hidden: true},
			{name:'leaf', index:'LEAF', hidden: true},
			{name:'ex', index:'EX', hidden: true},
			{name:'carNo', index:'CAR_NO', hidden: true},
			{name:'carId', index:'CAR_ID', hidden: true},
			{name:'drvNm', index:'DRV_NM', hidden: true},
			{name:'ch1Vio', index:'CH1_VIO', hidden: true},
			{name:'ch2Vio', index:'CH2_VIO', hidden: true},
			{name:'ch1', index:'CH1', hidden: true},
			{name:'ch2', index:'CH2', hidden: true},

		],
		treeReader: {
			level_field:		"lv",
			parent_id_field:	"grpCd",
			leaf_field:			"leaf",
			expanded_field:		"ex"
		},

		gridComplete: function(){
			var gridData = grid1$.getRowData();
			$.CvoMap.DRAW.cars(gridData);
		},

 		onSelectRow: function(rowId, status, e) {
			if (e == undefined || e.which == 1) {
				var data = grid1$.getRowData(rowId);
				//console.log($("#"+rowId).hasClass("ui-state-highlight"));
				//console.log($("#"+rowId+" td:eq(0) div div").hasClass("ui-icon-triangle-1-s"));
				if (data.lv == 1) {
					if (data.xpos != "" && data.ypos != "") {
						$("input[name=srchCenterCd]").eq(0).val("");

						if(carInterval != null ){
					 		window.clearInterval(carInterval);
						}
						$.CvoMap.DRAW.selectCar(data);

						carInterval = setInterval(function() {
							//console.log("Car Select");
							$.CvoMap.DRAW.selectCar(data);
						}, 1000 * 55 );
					} else {
						alert("수신된 위치 좌표가 없습니다.");
					}
				}
			}
		}
	});

	grid2$ = $('#grid2').jqGrid({
		url: _contextPath_ + '/manage/center/tempNowCargoList.json',
		height: 400,
		postData: com.getData(srch2$),
		treeGrid: true,
		treeGridModel: 'adjacency',
		ExpandColumn: 'CARGO_NM_CNT',
		ExpandColClick: true,
		colNames:[
					'창고명', '센터코드', 'treeKey', 'lv', 'leaf', 'ex', '창고명', '창고ID', '단말명', '단말기숫자', '센터코드',
					'ch1', 'ch2', 'ch3', 'ch4', 'ch5', 'ch6','ch1Nm', 'ch2Nm', 'ch3Nm', 'ch4Nm', 'ch5Nm', 'ch6Nm', '최종보고시간', '채널수',
					'ch1Vio', 'ch2Vio', 'ch3Vio', 'ch4Vio', 'ch5Vio', 'ch6Vio'
		],
		colModel:[
			{name:'cargoNm', index:'CARGO_NM_CNT', width:9, align: 'left', formatter: user.cargoNmCnt},
			{name:'grpCd', index:'GRP_CD', width:9, hidden: true},
			{name:'treeKey', index:'TREE_KEY', hidden: true, key: true},
			{name:'lv', index:'LV', hidden: true},
			{name:'leaf', index:'LEAF', hidden: true},
			{name:'ex', index:'EX', hidden: true},
			{name:'cargoNm', index:'CARGO_NM', hidden: true},
			{name:'devId', index:'DEV_ID', hidden: true},
			{name:'devNm', index:'DEV_NM', hidden: true},
			{name:'cntCargo', index:'CNT_CARGO', hidden: true},
			{name:'centerCd', index:'CENTER_CD', hidden: true},
			{name:'ch1', index:'CH1', hidden: true},
			{name:'ch2', index:'CH2', hidden: true},
			{name:'ch3', index:'CH3', hidden: true},
			{name:'ch4', index:'CH4', hidden: true},
			{name:'ch5', index:'CH5', hidden: true},
			{name:'ch6', index:'CH6', hidden: true},
			{name:'ch1Nm', index:'CH1_NM', hidden: true},
			{name:'ch2Nm', index:'CH2_NM', hidden: true},
			{name:'ch3Nm', index:'CH3_NM', hidden: true},
			{name:'ch4Nm', index:'CH4_NM', hidden: true},
			{name:'ch5Nm', index:'CH5_NM', hidden: true},
			{name:'ch6Nm', index:'CH6_NM', hidden: true},
			{name:'lastTempDt', index:'LAST_TEMP_DT', hidden: true},
			{name:'chCnt', index:'CH_CNT', hidden: true},
			{name:'ch1Vio', index:'CH1_VIO', hidden: true},
			{name:'ch2Vio', index:'CH2_VIO', hidden: true},
			{name:'ch3Vio', index:'CH3_VIO', hidden: true},
			{name:'ch4Vio', index:'CH4_VIO', hidden: true},
			{name:'ch5Vio', index:'CH5_VIO', hidden: true},
			{name:'ch6Vio', index:'CH6_VIO', hidden: true}
		],
		treeReader: {
			level_field:		"lv",
			parent_id_field:	"grpCd",
			leaf_field:			"leaf",
			expanded_field:		"ex"
		},
		gridComplete: function(){
			var gridData = grid2$.getRowData();
			user.drawCargoList(gridData);
		},
		onSelectRow: function(rowId, status, e) {
			if (e == undefined || e.which == 1) {
				//var data = grid2$.getRowData(rowId);
				//user.selectCargoCenter(data.devId);
/*
				var data = grid2$.getRowData(rowId);
				if (data.lv == 0) {
					$("input[name=srchCenterCd]").eq(1).val(data.treeKey);
					// 추후 타이머 삽입

				}
*/

			}
		}
	});

	//검색
	$('#srch1Btn').on('click', function() {
		com.init(view1$, true);
		$("input[name=srchCenterCd]").eq(0).val("");
		selectedCarId = null;
		grid1$.setGridParam({postData: com.getData(srch1$)}).trigger('reloadGrid');
		user.carRefresh();
	});

	//검색
	$('#srch2Btn').on('click', function() {
	 	if(carInterval != null ){
	 		window.clearInterval(carInterval);
		}

		com.init(view2$, true);
		$("input[name=srchCenterCd]").eq(1).val("");
		selectedCarId = null;
		grid2$.setGridParam({postData: com.getData(srch2$)}).trigger('reloadGrid');
	});

	user.carTab();
	user.init1();
	//user.init2();
});


var orgExpandNode = $.fn.jqGrid.expandNode;
var orgCollapseNode = $.fn.jqGrid.collapseNode;
$.jgrid.extend({
	expandNode: function (rc) {
	    //console.log('expandNode: rowid="' + rc.treeKey + '", name="' + rc.carNo + '"');

	    // 실시간 차량 그리드 관련
	    if (this[0].id == "grid1") {
	    	$("#"+rc.treeKey).addClass("ui-state-highlight");
	    	$("input[name=srchCenterCd]").eq(0).val(rc.treeKey);
	    	selectedCarId = null;
	    	user.allCollapseCss();
		    user.selectCarCenter();
	    } else if (this[0].id == "grid2") {
	    	$("#"+rc.treeKey).addClass("ui-state-highlight");
	    	$("input[name=srchCenterCd]").eq(1).val(rc.treeKey);
	    	user.allCollapseCss();
	    	user.selectCargoCenter();
	    }

	    return orgExpandNode.call(this, rc);
	},
	collapseNode: function (rc) {
		//console.log('collapseNode: rowid="' + rc.treeKey + '", name="' + rc.carNo + '"');

		// 실시간 차량 그리드 관련
		if (this[0].id == "grid1") {
			user.allCollapseCss();
			if (rc.ex == true && rc.treeKey != $("input[name=srchCenterCd]").eq(0).val()) {
				$("input[name=srchCenterCd]").eq(0).val(rc.treeKey);
				selectedCarId = null;

			    $("#"+rc.treeKey).addClass("ui-state-highlight");
			    user.selectCarCenter();
			    this.jqGrid('expandRow', rc);
		    } else {
		    	$("input[name=srchCenterCd]").eq(0).val("");
		    	selectedCarId = null;
			    $("#"+rc.treeKey).removeClass("ui-state-highlight");
			    user.selectCarCenter();

			    return orgCollapseNode.call(this, rc);
		    }
		} else if (this[0].id == "grid2") {
			user.allCollapseCss();
			//console.log(rc.ex + "		||		" + rc.treeKey + "		||		" + $("input[name=srchCenterCd]").eq(1).val());
			if (rc.ex == true && rc.treeKey != $("input[name=srchCenterCd]").eq(1).val()) {
				$("input[name=srchCenterCd]").eq(1).val(rc.treeKey);
				$("#"+rc.treeKey).addClass("ui-state-highlight");
				user.selectCargoCenter();
			    this.jqGrid('expandRow', rc);

		    } else {
		    	$("input[name=srchCenterCd]").eq(1).val("");
		    	$("#"+rc.treeKey).removeClass("ui-state-highlight");
		    	user.selectCargoCenter();

			    return orgCollapseNode.call(this, rc);
		    }
		}
	}
});



var user = {
	//차량 페이지 초기화
	init1 : function() {
		$('#srch1Btn').trigger('click');
	},

	//창고 페이지 초기화
	init2 : function() {
		$('#srch2Btn').trigger('click');
	},

	carIcon: function(e, options, rowObject) {
		if (rowObject.xpos != null && rowObject.xpos != null) {
			//console.log(rowObject.carNo + " ==> " + rowObject.xpos + " || " + rowObject.ypos);
		}

		var btnStr = e;
		if (rowObject.grpCd != "_ROOT_") {
			switch(rowObject.turnOnOff) {
				case "ON" : btnStr = '<span class=\"caricon_on\">ON</span> ' + e; break;
				case "OFF" : btnStr = '<span class=\"caricon_off\">OFF</span> ' + e; break;
				case "" : btnStr = '' + e; break;
				default: btnStr = e; break;
			}

			btnStr += "(" + rowObject.drvNm + ")";

			if (rowObject.ch1 != "-") {
				btnStr +=	" : \t" + rowObject.ch1 + "℃ ";
				if (rowObject.ch1Vio != "") {
					btnStr += "<img class='tempImg' src='" + _contextPath_ + "/resources/image/cmn/ico_ondogye_red.png'/>";
				} else {
					btnStr += "<img class='tempImg' src='" + _contextPath_ + "/resources/image/cmn/ico_ondogye.png'/>";
				}
			}

			if (rowObject.ch2 != "-") {
				btnStr +=	"\t" + rowObject.ch2 + "℃ ";
				if (rowObject.ch2Vio != "") {
					btnStr += "<img class='tempImg' src='" + _contextPath_ + "/resources/image/cmn/ico_ondogye_red.png'/>";
				} else {
					btnStr += "<img class='tempImg' src='" + _contextPath_ + "/resources/image/cmn/ico_ondogye.png'/>";
				}
			}

		}

		return btnStr;
	},

	cargoNmCnt: function(e, options, rowObject) {
		var btnStr;
		if (rowObject.grpCd == "_ROOT_") {
			btnStr = rowObject.cargoNm + "(" + rowObject.cntCargo + ")";
		} else {
			//$("input[name=srchCenterCd]").eq(1).val(rc.treeKey);
			btnStr = "<span onclick=\"user.selectCargoCenter('" + rowObject.devId + "', '" + rowObject.centerCd + "');\" style=\"cursor:pointer;\">" + rowObject.cargoNm + "\t";
			if (Number(rowObject.chCnt) && Number(rowObject.chCnt) > 0) {
				if (rowObject.ch1 != "") {
					btnStr +=	" : \t" + rowObject.ch1 + "℃ ";
					if (rowObject.ch1Vio != "S") {
						btnStr += "<img class='tempImg' src='" + _contextPath_ + "/resources/image/cmn/ico_ondogye_red.png'/>";
					} else {
						btnStr += "<img class='tempImg' src='" + _contextPath_ + "/resources/image/cmn/ico_ondogye.png'/>";
					}
				}
				if (rowObject.ch2 != "") {
					btnStr +=	"\t" + rowObject.ch2 + "℃ ";
					if (rowObject.ch2Vio != "S") {
						btnStr += "<img class='tempImg' src='" + _contextPath_ + "/resources/image/cmn/ico_ondogye_red.png'/>";
					} else {
						btnStr += "<img class='tempImg' src='" + _contextPath_ + "/resources/image/cmn/ico_ondogye.png'/>";
					}
				}
				if (rowObject.ch3 != "") {
					btnStr +=	"\t" + rowObject.ch3 + "℃ ";
					if (rowObject.ch3Vio != "S") {
						btnStr += "<img class='tempImg' src='" + _contextPath_ + "/resources/image/cmn/ico_ondogye_red.png'/>";
					} else {
						btnStr += "<img class='tempImg' src='" + _contextPath_ + "/resources/image/cmn/ico_ondogye.png'/>";
					}
				}

				/* btnStr += rowObject.ch4 + (rowObject.ch4 == "-" ? ", " : "℃, ");
				btnStr += rowObject.ch5 + (rowObject.ch5 == "-" ? ", " : "℃, ");
				btnStr += rowObject.ch6 + (rowObject.ch6 == "-" ? "" : "℃ "); */
			}

			btnStr += "</span>";
		}
		return btnStr;
	},

	//차량 탭클릭시
	carTab: function() {
		$('#carTab').addClass('selected');
		$('#cargoTab').removeClass('selected');
		$('#tab1').show();
		$('#tab2').hide();
		srch1$.show();
		srch2$.hide();
		view1$.show();
		view2$.hide();

		user.init1();
// 		$("select[name=srchMethod] option:eq(0)").attr("selected", "selected");
// 		$("input[name=srchWord]").eq(1).val("");
// 		user.carOnOffCnt();

		//grid1$.setGridParam({postData: com.getData(srch1$)}).trigger('reloadGrid');
		//user.carRefresh();
	},

	//창고 탭클릭시
	cargoTab: function() {
		$('#cargoTab').addClass('selected');
		$('#carTab').removeClass('selected');
		$('#tab1').hide();
		$('#tab2').show();
		srch1$.hide();
		srch2$.show();
		view1$.hide();
		view2$.show();

		user.init2();

// 		$("input[name=srchWord]").eq(0).val("");
// 		if(carInterval != null ){
// 	 		window.clearInterval(carInterval);
// 		}
	},

	// 지도 초기화
	mapInit: function() {
		$("#divView1").CvoMap();
	},

	//차량운행정보-차량대수 표현
	carOnOffCnt: function() {
		$("#onCnt").html("");
		$("#offCnt").html("");
		$("#onoffTotCnt").html("");

		onm.ajax({
			url: _contextPath_ + '/manage/center/tempNowOnOffCnt.json',
			success: function(res) {
				var datas = res.list;
				if (datas.length > 0) {
					var onCnt, offCnt, onoffTotCnt;
					$.each(datas, function (index, data) {
						if (index == 0)	onCnt = parseInt(data.cnt, 10);
						else if (index == 1)	offCnt = parseInt(data.cnt, 10);
					});

					$("#onCnt").html(onCnt);
					$("#offCnt").html(offCnt);
					$("#onoffTotCnt").html(onCnt + offCnt);
				}
			}
		});
	},
	// treenode 접기시에 css 적용
	allCollapseCss: function() {
		var rows = $("#grid1").jqGrid('getGridParam','data');
		if (rows) {
			for (i=0;i<rows.length;i++) {
				if (rows[i].lv == "0") {
					//console.log(rows[i].carNo + " || " + rows[i].ex);
					$("#"+rows[i].treeKey).removeClass("ui-state-highlight");
				}

				//$("#"+rows[i].treeKey).removeClass("ui-state-highlight");
			}
		}
	},
	// 차량 - 센터 선택시
	selectCarCenter: function() {
		if(carInterval != null ){
	 		window.clearInterval(carInterval);
		}

		onm.ajax({
			url: _contextPath_ + '/manage/center/tempNowList.json',
			data: com.getData(srch1$),
			success: function(res) {
				var datas = res.list;
				$.CvoMap.DRAW.cars(datas);
			}
		});

		if(carInterval != null ){
	 		window.clearInterval(carInterval);
		}

		carInterval = setInterval(function() {
			console.log("Center Select");
			onm.ajax({
				url: _contextPath_ + '/manage/center/tempNowList.json',
				data: com.getData(srch1$),
				success: function(res) {
					var datas = res.list;
					$.CvoMap.DRAW.cars(datas);
				}
			});
		}, 1000 * 55 );

	},
	//차량 - 새로고침
	carRefresh: function() {
	 	if(carInterval != null ){
	 		window.clearInterval(carInterval);
		}

		carInterval = setInterval(function() {
			console.log("Total Select");
			onm.ajax({
				url: _contextPath_ + '/manage/center/tempNowList.json',
				data: com.getData(srch1$),
				success: function(res) {
					var datas = res.list;
					$.CvoMap.DRAW.cars(datas);
				}
			});
		}, 1000 * 55 );
	},
	// 창고 - 센터 선택시
	selectCargoCenter: function(devId, centerCd) {
		var postData;
		if (devId != undefined && devId != "") {
			postData = {"srchDevId" : devId, "srchCenterCd" : centerCd};
		} else {
			postData = com.getData(srch2$);
		}

		onm.ajax({
			url: _contextPath_ + '/manage/center/tempNowCargoList.json',
			data: postData,
			success: function(res) {
				var datas = res.list;
				if ($("input[name=srchCenterCd]").eq(1).val() == "") {
					user.drawCargoList(datas);
				} else {
					$("#divView2").html("");
					var contentLayout = '';
					var li_cnt = 0;
					$.each(datas, function (index, cargo) {
						if (postData.srchCenterCd == cargo.centerCd) {
							if (cargo.lv == "0") {
								contentLayout	+=	"<div style=\"height:200px;\">";
								contentLayout	+=	"<h3>" + cargo.cargoNm + "</h3>";
								contentLayout	+=	"<ul class=\"center-list\">";
							} else {
								contentLayout += "<li>";
								contentLayout += "<div class=\"center-cago\" onclick=\"user.getCargoNowList('"+cargo.devId+"', '" + cargo.lastTempDt + "', " + cargo.chCnt + ")\">";
								contentLayout += "<table>";
								contentLayout += "	<colgroup>";
								contentLayout += "	<col width=\"40%\">";
								contentLayout += "	<col>";
								contentLayout += "	</colgroup>";
								contentLayout += "	<tr>";
								contentLayout += "		<th class=\"group01\">창고명</th><td class=\"group01\">" + cargo.cargoNm + "</td>";
								contentLayout += "	</tr>";
								contentLayout += "	<tr>";
								contentLayout += "		<th>설치장소</th><td>입구앞</td>";
								contentLayout += "	</tr>";
								contentLayout += "	<tr>";
								contentLayout += "		<th>ID</th><td>"+ cargo.devId +"</td>";
								contentLayout += "	</tr>";
								contentLayout += "</table>";
								contentLayout += "<table>";
								contentLayout += "	<colgroup>";
								contentLayout += "	<col width=\"25%\">";
								contentLayout += "	<col width=\"25%\">";
								contentLayout += "	<col width=\"25%\">";
								contentLayout += "	<col width=\"25%\">";
								contentLayout += "	</colgroup>";
								contentLayout += "	<tr>";
								contentLayout += "		<th colspan=\"4\" class=\"group01\">온도현황</th>";
								contentLayout += "	</tr>";
								contentLayout += "	<tr>";
								contentLayout += "		<th>CH1</th><td>" + (cargo.ch1 != "" ? cargo.ch1 + "ºC" : "-") + "</td>";
								contentLayout += "		<th>CH2</th><td>" + (cargo.ch2 != "" ? cargo.ch2 + "ºC" : "-") + "</td>";
								contentLayout += "	</tr>";
								contentLayout += "	<tr>";
								contentLayout += "		<th>CH3</th><td>" + (cargo.ch3 != "" ? cargo.ch3 + "ºC" : "-") + "</td>";
								contentLayout += "		<th>CH4</th><td>" + (cargo.ch4 != "" ? cargo.ch4 + "ºC" : "-") + "</td>";
								contentLayout += "	</tr>";
								contentLayout += "	<tr>";
								contentLayout += "		<th>CH5</th><td>" + (cargo.ch5 != "" ? cargo.ch5 + "ºC" : "-") + "</td>";
								contentLayout += "		<th>CH6</th><td>" + (cargo.ch6 != "" ? cargo.ch6 + "ºC" : "-") + "</td>";
								contentLayout += "	</tr>";
								contentLayout += "</table>";
								contentLayout += "</div>";
								contentLayout += "</li>";

								li_cnt++;
							}
						}
					});

					if (li_cnt % 4 > 0 ) {
						for (var i=0; i < 4 - (li_cnt % 4); i++) {
							contentLayout	+=	"<li><div style=\"height:167px;\"></div></li>";
						}
					}
					contentLayout	+=	"</ul>";
					contentLayout	+=	"</div>";

					$("#divView2").html(contentLayout);
				}


			}
		});
	},
	drawCargoList: function(datas) {
		$("#divView2").html("");
		var contentLayout = '';
		var li_cnt = 0;
		$.each(datas, function (index, cargo) {
			if (cargo.lv == "0") {
				if (index > 0) {
					if (li_cnt % 4 > 0 ) {
						for (var i=0; i < 4 - (li_cnt % 4); i++) {
							contentLayout	+=	"<li><div style=\"height:167px;\"></div></li>";
						}
					}
					contentLayout	+=	"</ul>";
					contentLayout	+=	"</div>";
				}

				li_cnt = 0;
				contentLayout	+=	"<div style=\"height:200px;\">";
				contentLayout	+=	"<h3>" + cargo.cargoNm + "</h3>";
				contentLayout	+=	"<ul class=\"center-list\">";
			} else {
				contentLayout += "<li>";
				contentLayout += "<div class=\"center-cago\" onclick=\"user.getCargoNowList('"+cargo.devId+"', '" + cargo.lastTempDt + "', " + cargo.chCnt + ")\">";
				contentLayout += "<table>";
				contentLayout += "	<colgroup>";
				contentLayout += "	<col width=\"40%\">";
				contentLayout += "	<col>";
				contentLayout += "	</colgroup>";
				contentLayout += "	<tr>";
				contentLayout += "		<th class=\"group01\">창고명</th><td class=\"group01\">" + cargo.cargoNm + "</td>";
				contentLayout += "	</tr>";
				contentLayout += "	<tr>";
				contentLayout += "		<th>설치장소</th><td>입구앞</td>";
				contentLayout += "	</tr>";
				contentLayout += "	<tr>";
				contentLayout += "		<th>ID</th><td>"+ cargo.devId +"</td>";
				contentLayout += "	</tr>";
				contentLayout += "</table>";
				contentLayout += "<table>";
				contentLayout += "	<colgroup>";
				contentLayout += "	<col width=\"25%\">";
				contentLayout += "	<col width=\"25%\">";
				contentLayout += "	<col width=\"25%\">";
				contentLayout += "	<col width=\"25%\">";
				contentLayout += "	</colgroup>";
				contentLayout += "	<tr>";
				contentLayout += "		<th colspan=\"4\" class=\"group01\">온도현황</th>";
				contentLayout += "	</tr>";
				contentLayout += "	<tr>";
				contentLayout += "		<th>CH1</th><td>" + (cargo.ch1 != "" ? cargo.ch1 + "ºC" : "-") + "</td>";
				contentLayout += "		<th>CH2</th><td>" + (cargo.ch2 != "" ? cargo.ch2 + "ºC" : "-") + "</td>";
				contentLayout += "	</tr>";
				contentLayout += "	<tr>";
				contentLayout += "		<th>CH3</th><td>" + (cargo.ch3 != "" ? cargo.ch3 + "ºC" : "-") + "</td>";
				contentLayout += "		<th>CH4</th><td>" + (cargo.ch4 != "" ? cargo.ch4 + "ºC" : "-") + "</td>";
				contentLayout += "	</tr>";
				contentLayout += "	<tr>";
				contentLayout += "		<th>CH5</th><td>" + (cargo.ch5 != "" ? cargo.ch5 + "ºC" : "-") + "</td>";
				contentLayout += "		<th>CH6</th><td>" + (cargo.ch6 != "" ? cargo.ch6 + "ºC" : "-") + "</td>";
				contentLayout += "	</tr>";
				contentLayout += "</table>";
				contentLayout += "</div>";
				contentLayout += "</li>";

				li_cnt++;
			}

		});

		$("#divView2").html(contentLayout);
	},
	getCargoNowList:function(devId, devDt, chCnt) {
		if (devDt != "null" && devDt != "") {
			var postData = {
					stdDate: devDt,
					devId: devId
			};
			onm.ajax({
				url: _contextPath_ + '/manage/center/dayCargoTempAnalDtl.json',
				data: postData,
				success: function(res) {
					var chartData = user.makeSeriesData(res.list, chCnt);
					user.drawChart(chartData);

				}
			});
		} else {
			onm.alert("창고 온도 내역이 없습니다.");
		}
	},
	makeSeriesData: function(datas, chCnt) {
		var i;
		var list = datas;
		if (list.length <= 0) return null;

		var series = [];
		for (i = 1; i <= chCnt; i++) {
			series.push({
				gapSize: 1,
				name: 'ch' + i,
				data: []
			})
		}

		var row, devDt, j, propNm;
		for (i=0; i<list.length; i++) {
			row = list[i];
			devDt = user.roundSec(row.devDt);
			for (j=0; j<series.length; j++) {
				propNm = series[j].name;
				var v = (row[propNm] == null ? 0 : Number(row[propNm]));
				series[j].data.push([devDt, v]);
			}
		}
		return series;
	},
	drawChart: function(chartData) {
		onm.ajaxModal({
			url: _contextPath_ + '/manage/center/dayCargoTempAnalChartView.pop',
			dialogOptions: {
				title: '창고 온도 세부 내역',
				width: 1100,
				height: 500,
				open: function (event, ui) {
					user.initChart(chartData);
				}
			}
		});

	},
	roundSec: function(devDt) {
		var dt = new Date(devDt);
		if (dt.getSeconds() > 50) {
			dt.setSeconds(0, 0);
			return dt.getTime() + (1000 * 60);
		} else {
			dt.setSeconds(0, 0);
			return dt.getTime();
		}
	},
	initChart: function(series) {

		var plotLineOpt1 = {
			id: 'plotLineOpt1',
			value: 4,
			color: '#ff0000',
			dashStyle: 'shortdash',
			width: 2
		};

		series.push({
			color: '#ff0000',
			name: '기준',
			dashStyle: 'shortdash',
			marker: {
				enabled: false
			},
			events: {
				legendItemClick: function () {
					if (this.visible) {
						this.chart.yAxis[0].removePlotLine(plotLineOpt1.id);
					}
					else {
						this.chart.yAxis[0].addPlotLine(plotLineOpt1);
					}
				}
			}
		});

		var opt = {
			chart: {
                zoomType: 'x'
            },
			xAxis: {
				type: 'datetime',
				tickInterval: 60 * 60 * 1000,
				labels: {
					format: '{value:%H:%M}',
					align: 'center'
				},
				events: {
					afterSetExtremes: function (e) {
						var tickInterval = 60 * 60 * 1000;
						if (e.userMax !== undefined) {
							tickInterval = 60 * 1000;
						}
						this.chart.update({'xAxis': {'tickInterval': tickInterval}});
					}
				}
			},
			yAxis: {
				plotLines: [plotLineOpt1]
			},
			legend: {
				align: 'right',
				verticalAlign: 'top',
				borderWidth: 0
			},
			tooltip: {
				shared: true,
				crosshairs: true,
				xDateFormat: '%k:%M',
				valueSuffix: String.fromCharCode(8451)
			},
			plotOptions: {
				series: {
					lineWidth: 1,
					marker: {
						enabled: false
					},
					states: {
						hover: {
							enabled: false
						}
					}
				}
			},
			series: series
		};

		chart1$ = Highcharts.chart('chart1', opt);
	}

}
</script>

<header>
<!-- 	<div class="loc_info"><span>실시간 온도 모니터링 </span><span>센터관리</span><span>Home</span></div> -->
	<h2 class="content_title"><span>실시간 온도 모니터링 / 차량 창고 현황</span></h2>
</header>

<div id="main">
	<div class="colgroup-wrap">
		<div class="colgroup-tempnowl">
			<div class="tabbtn-group">
				<a href="javascript:user.carTab();" id="carTab" class="tabbtn">차량</a>
				<a href="javascript:user.cargoTab();" id="cargoTab" class="tabbtn">창고</a>
			</div>

			<div class="monitoring-left">
				<div class="srch_box" id="divSrch1">
					<table>
						<colgroup>
							<col width="85%">
							<col width="*">
						</colgroup>
						<tr>
							<td>
								<select name="srchMethod">
									<option value="carNo" selected="selected">차량번호</option>
									<option value="drvNm">운전자명</option>
								</select>
								<input type="text" name="srchWord" maxlength="30" class="enterSrch" />
								<input type="hidden" name="srchCenterCd" class="enterSrch" />
								<input type="hidden" name="srchCarId" class="enterSrch" />
							</td>
							<td>
								<div class="srch_btn">
									<button type="button" id="srch1Btn" class="btn_srch "><span class="ico_srch"></span>검색</button>
								</div>
							</td>
						</tr>
					</table>
				</div>
				<div class="srch_box" id="divSrch2">
					<table>
						<colgroup>
							<col width="85%">
							<col width="*">
						</colgroup>
						<tr>
							<td>
								<input type="text" name="srchWord" maxlength="30" placeholder="창고명을 입력해주세요." class="enterSrch" />
								<input type="hidden" name="srchCenterCd" class="enterSrch" />
							</td>
							<td>
								<div class="srch_btn">
									<button type="button" id="srch2Btn" class="btn_srch "><span class="ico_srch"></span>검색</button>
								</div>
							</td>
						</tr>
					</table>
				</div>
				<div id="tab1" class="mT10">
					<div class="monitoring-dash mB10">
						<h2>차량 운행정보</h2>
						<ul class="monitoring-ul">
							<li><span>ON</span><em id="onCnt"></em></li>
							<li><span>OFF</span><em id="offCnt"></em></li>
							<li><span>TOTAL</span><em id="onoffTotCnt"></em></li>
						</ul>
					</div>
					<table id="grid1"></table>
				</div>
				<div id="tab2" class="mT10">
					<!-- <div class="monitoring-dash mB10">
						<h2>창고 정보</h2>
						<ul class="monitoring-ul">
							<li><span>ON</span><em>112</em></li>
							<li><span>OFF</span><em>299</em></li>
							<li><span>TOTAL</span><em>405</em></li>
						</ul>
					</div> -->
					<table id="grid2"></table>
				</div>
			</div>
		</div>
		<div class="colgroup-tempnowr">

			<div class="monitoring-map" id="divView1">
				<!-- <div class="ico_car_status on"></div>
				<div class="ico_car_status off"></div>
				<div class="ico_car_status on_error"></div> -->
			</div>

			<div class="monitoring-cago" id="divView2">
			</div>

		</div>
	</div>
</div>