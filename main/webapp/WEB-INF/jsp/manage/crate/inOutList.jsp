<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script>
var srch$;
var grid1$;
var grid2$;
var view2$;
jQuery(function($) {
	srch$ = com.toBox($('#divSrch'));

	grid1$ = $('#grid1').jqGrid({
		url: _contextPath_ + '/manage/crate/inOutList.json',
		pager:'#grid1Pg',
		height: 213,
		scrollrows: true,
		postData: user.getPostData(),
		colNames:[
			'순번', '납품요청일', '선적번호', '차량<br>번호', '포장재',
			'현재<br>출고수', '입력자', '전산<br>출고수', '하차수', '회수수',
			'검수수', '입력자', '차이유무', '수정여부', '전표확인'
		],
		cmTemplate: {
			align:'center'
		},
		colModel:[
			{name:'rnum', index:'rnum', width:29, align:'right', sortable:false},
			{name:'shipReqDate', index:'SHIP_REQ_DATE', width:67},
			{name:'shipNo', index:'SHIP_NO', width:71},
			{name:'carId', index:'CAR_ID', width:38},
			{name:'pkgNm', index:'PKG_NM', width:62, align:'left', sortable:false},

			{name:'outCnt', index:'OUT_CNT', width:40},
			{name:'outId', index:'OUT_ID', width:40, hidden:true},
			{name:'sapOutCnt', index:'SAP_OUT_CNT', width:40},
			{name:'agentOutCnt', index:'AGENT_OUT_CNT', width:40},
			{name:'agentInCnt', index:'AGENT_IN_CNT', width:40},

			{name:'inCnt', index:'IN_CNT', width:40},
			{name:'inId', index:'IN_ID', width:40, hidden:true},
			{name:'inoutDifYn', index:'INOUT_DIF_YN', width:30},
			{name:'updateYn', index:'UPDATE_YN', width:30},
			{name:'rcptYnCnt', index:'RCPT_YN_CNT', width:30}
		],

		onSelectRow: function() {
			user.grid2Reload();
		}
	});

	view2$ = com.toBox($('#view2'));
	grid2$ = $('#grid2').jqGrid({
		url: _contextPath_ + '/manage/crate/inOutCntAdjList.json',
		pager:'#grid2Pg',
		height: 220,
		scrollrows: true,
		multiselect: true,
		postData: grid1$.getSelGridData()[0],
		cmTemplate: {
			align:'center',
			sortable:false
		},
		colNames:[
			'순번', '납품요청일', '선적번호', '대리점코드', '대리점명',
			'남품번호', '포장재', '전산<br>출고수', '하차수', '하차<br>조정수<span class="text-point">*</span>',
			'회수수', '회수<br>조정수<span class="text-point">*</span>', '사유<span class="text-point">*</span>', 'pkgCd', '전표<br>확인'
		],
		colModel:[
			{name:'rnum', index:'rnum', width:29, align:'right', key:true},
			{name:'shipReqDate', index:'SHIP_REQ_DATE', width:96, hidden:true},
			{name:'shipNo', index:'SHIP_NO', width:94, hidden:true},
			{name:'agentCd', index:'AGENT_CD', width:60, align:'left'},
			{name:'agentNm', index:'AGENT_NM', width:68, align:'left'},

			{name:'deliNo', index:'DELI_NO', width:71, align:'left'},
			{name:'pkgNm', index:'PKG_NM', width:62, align:'left'},
			{name:'sapOutCnt', index:'SAP_OUT_CNT', width:40},
			{name:'outCnt', index:'OUT_CNT', width:40},
			{name:'outAdjCnt', index: 'OUT_ADJ_CNT', width: 40, formatter:adjCntFormat, unformat:adjCntUnformat},

			{name:'inCnt', index:'IN_CNT', width:40},
			{name:'inAdjCnt', index:'IN_ADJ_CNT', width:40, formatter:adjCntFormat, unformat:adjCntUnformat},
			{name:'adjDesc', index:'ADJ_DESC', width:60, formatter:adjDescFormat, unformat:adjDescUnformat},
			{name:'pkgCd', index:'PKG_CD', width:10, hidden:true},
			{name:'rcptYn', index:'RCPT_YN', width:30, formatter:'checkbox', formatoptions:{disabled:false}, editoptions: {value:"Y:N"}}
		]
	});

	function adjCntFormat(cellvalue, options, rowObject) {
		var val = cellvalue;
		if (user.isEditable(rowObject.shipReqDate)) {
			var colNm = options.colModel.name;
			if (cellvalue === null) {
				if (colNm === 'outAdjCnt') {
					val = rowObject.outCnt;
				} else if (colNm === 'inAdjCnt') {
					val = rowObject.inCnt;
				}
			}
			return '<input type="text" name="' + colNm + '" maxlength="3" value="' + val + '" style="width: 90%; font-size: 12px;">';
		} else {
			val = val || 0;
			return val;
		}
	}

	function adjCntUnformat(cellvalue, options, cell) {
		var rowData = $(this).getGridData(options.rowId);
		if (user.isEditable(rowData.shipReqDate)) {
			return $(cell).find('input').val();
		} else {
			return cellvalue;
		}
	}

	function adjDescFormat(cellvalue, options, rowObject) {
		var val = cellvalue || '';
		if (user.isEditable(rowObject.shipReqDate)) {
			return '<input type="text" name="adjDesc" maxlength="1000" value="' + val + '" style="width: 90%; font-size: 12px;">';
		} else {
			return val;
		}
	}

	function adjDescUnformat(cellvalue, options, cell) {
		var rowData = $(this).getGridData(options.rowId);
		if (user.isEditable(rowData.shipReqDate)) {
			return $(cell).find('input').val();
		} else {
			return cellvalue;
		}
	}

	//검색
	$('#srchBtn').on('click', function() {
		grid1$.setGridParam({postData: user.getPostData()}).trigger('reloadGrid');
		user.grid2Reload(true);
	});

	//엑셀다운로드
	$('#xlsBtn').on('click', function() {
		var data = com.getData(srch$);
		data.srchIdVisible = $('select[name=srchIdVisible]').val();
		cvo.ajaxFileDown({url: _contextPath_ + '/manage/crate/inOutList.xls', data: data});
	});

	// 입력자 숨김, 표시
	$('select[name=srchIdVisible]').on('change', function () {
		var cols = ['outId', 'inId'];
		var visible = $(this).val();
		var gridWidth = grid1$.getGridParam('width');

		if (visible == 'show')
			grid1$.showCol(cols).setGridWidth(gridWidth);
		else
			grid1$.hideCol(cols).setGridWidth(gridWidth);
	});

	grid2$.on('blur', 'input[name=outAdjCnt],input[name=inAdjCnt]', function () {
		var el$ = $(this);
		var val = el$.val().trim();
		if (onm.isNumber(val)) {
			val = onm.stripStart(val, '0');
			if (val === '') {
				val = '0';
			}
		} else {
			onm.alert('숫자만 입력 가능합니다.', function () {
				el$.focus();
			});
		}
		$(this).val(val);
	});

	// 전표확인 체크박스 클릭
	grid2$.on('click', '[aria-describedby=grid2_rcptYn] input:checkbox', user.rcptYnClick);

	// 조정수량 저장 클릭
	$("#btnAdjCntSave").on('click', function(){ user.inOutCntAdjSave('U'); });

	// 전표확인 저장 클릭
	$("#btnRcptYnSave").on('click', function(){ user.rcptYnSave(); });

	user.mainInit();
});

var user = {
	//메인페이지 초기화
	mainInit : function() {

		com.setCombo('select', srch$, 'srchCenterCd', '', com.sAuthCenterList());

		com.setCombo('select', srch$, 'srchPkgCd', '', com.getCdList('PKG_CD'), '전체');

		//검색조건 기본값 설정
		srch$.find('[name=srchStrDt]').val(onm.todayFmt());
		srch$.find('[name=srchEndDt]').val(onm.formatDate(onm.addDate(new Date(), 1)));

		com.init(view2$, true);

		$('#srchBtn').trigger('click');
	},

	getPostData: function() {
		var postData = com.getData(srch$);
		postData.paramPaginateRecordSize = 80;
		return postData;
	},

	grid2Reload: function(clear) {

		var lbAdj$ = $('#lbAdj');

		if (true === clear) {
			lbAdj$.text('회수수량 조정' );
			grid2$.clearGridData();
		} else {
			var selGridData = grid1$.getSelGridData()[0];
			lbAdj$.text('회수수량 조정 - 선적번호: ' + selGridData.shipNo);
			grid2$.setGridParam({postData: selGridData}).trigger('reloadGrid');
		}
	},

	//회수수량조정 저장
	inOutCntAdjSave: function (action) {
		var rowDataArr = grid2$.getSelGridData();
		if (user.validateAdjCnt(rowDataArr) && rowDataArr.length > 0) {
			var msg = '선택된 ' + rowDataArr.length + '개의 행을 저장하시겠습니까?';
			onm.confirm(msg, function () {
				var elBtn$ = $('#btnAdjCntSave');
				elBtn$.prop('disabled', true);

				var paramDataArr = [];
				var shipNo;

				for(var i=0; i<rowDataArr.length; i++) {
					var item = rowDataArr[i];

					shipNo = item.shipNo;

					paramDataArr.push({
						shipNo: item.shipNo,
						agentCd: item.agentCd,
						deliNo: item.deliNo,
						pkgCd: item.pkgCd,
						outAdjCnt: item.outAdjCnt,
						inAdjCnt: item.inAdjCnt,
						adjDesc: item.adjDesc
					});
				}

				var payload = {
					list: paramDataArr,
					shipNo: shipNo
				};

				onm.ajax({
					url: _contextPath_ + '/manage/crate/inOutCntAdjSave.json',
					contentType: 'application/json;charset=UTF-8',
					data: JSON.stringify({payload: payload}),
					success: function (res) {
						user.grid2Reload();
					},
					complete: function () {
						elBtn$.prop('disabled', false);
					}
				});
			});
		}
	},

	isEditable: function (shipReqDate) {
		shipReqDate = onm.parseDate(shipReqDate);
		var nowDate = new Date();
		var diffMonth = onm.diffMonth(shipReqDate, nowDate);

		if (diffMonth === -1) {
			if (nowDate.getDate() > 10) {
				return false
			}
		} else if (diffMonth < -1) {
			return false;
		}

		return true;
	},

	validateAdjCnt: function(rowDataArr) {
		var i;
		if (!rowDataArr || rowDataArr.length === 0) {
			onm.alert('선택된 행이 없습니다.');
			return false;
		}

		for (i = 0; i < rowDataArr.length; i++) {
			var rowData = rowDataArr[i];
			if (rowData.adjDesc === '') {
				onm.alert('하차조정수, 회수조정수 변경 시 필수 입력입니다.', function () {
					var el$ = grid2$.find('tr[id=' + rowData.rnum + ']').find('*[name=adjDesc]');
					el$.focus();
				});
				return false;
			}
		}
		return true;
	},

	//전표확인 체크박스 클릭
	rcptYnClick: function (event) {
		var rowid = $(this).closest('tr').attr('id');
		var rowData = grid2$.getRowData(rowid);

		$.each(grid2$.getRowData(), function (idx, item) {
			if (item.agentCd === rowData.agentCd) {
				grid2$.setCell(item.rnum, 'rcptYn', rowData.rcptYn);
			}
		});
	},

	rcptYnSave: function () {

		var paramDataArr = [];
		var deliNoArr = [];

		var i;
		var rowDataArr = grid2$.getRowData();
		var gridDataArr = grid2$.getGridData();

		for (i = 0; i < rowDataArr.length; i++) {
			var item = rowDataArr[i];
			var gridData = gridDataArr[i];
			if (item.rcptYn !== gridData.rcptYn && deliNoArr.indexOf(item.deliNo) === -1) {
				paramDataArr.push({
					shipNo: item.shipNo,
					agentCd: item.agentCd,
					deliNo: item.deliNo,
					rcptYn: item.rcptYn
				});
				deliNoArr.push(item.deliNo);
			}
		}

		if (paramDataArr.length === 0) {
			onm.alert('변경된 전표확인 항목이 없습니다.');
			return false;
		}

		var msg = '변경된 전표확인 항목을 저장하시겠습니까?';
		onm.confirm(msg, function () {

			var elBtn$ = $('#btnRcptYnSave');
			elBtn$.prop('disabled', true);

			var payload = {
				list: paramDataArr
			};
			onm.ajax({
				url: _contextPath_ + '/manage/crate/rcptYnSave.json',
				contentType: 'application/json;charset=UTF-8',
				data: JSON.stringify({payload: payload}),
				success: function (res) {
					var postData = grid1$.getGridParam('postData');
					grid1$.trigger('reloadGrid', {page: postData.pg, current: true});

					var postData2 = grid2$.getGridParam('postData');
					grid2$.trigger('reloadGrid', {page: postData2.pg, current: true});
				},
				complete: function() {
					elBtn$.prop('disabled', false);
				}
			});
		})
	}
}
</script>

<header>
	<div id="divSrch">
		<div class="loc_info"><span>포장재 회수현황</span><span>크레이트 관리</span><span>Home</span></div>
		<h2 class="content_title"><span>포장재 회수현황</span></h2>
		<div class="srch_box">
			<table>
				<colgroup>
					<col width="7%">
					<col width="12%">
					<col width="7%">
					<col width="10%">
					<col width="7%">
					<col width="10%">
					<col width="7%">
					<col width="10%">
					<col width="7%">
					<col width="*">
				</colgroup>
				<tr>
					<th>센터</th>
					<td>
						<select name="srchCenterCd" class="chosen" multiple data-placeholder="전체"></select>
					</td>

					<th>선적번호</th>
					<td>
						<input type="text" name="srchShipNo" maxlength="10" class="enterSrch" />
					</td>

					<th>차량번호</th>
					<td>
						<input type="text" name="srchCarId" maxlength="5" class="enterSrch" />
					</td>

					<th>포장재</th>
					<td>
						<select name="srchPkgCd"></select>
					</td>

					<th>전표</th>
					<td>
						<select name="srchRcptCompYn">
							<option value="">전체</option>
							<option value="Y">완료</option>
							<option value="N">미완료</option>
						</select>
					</td>
				</tr>

				<tr>
					<th>차이유무</th>
					<td>
						<select name="srchInoutDifYn">
							<option value="">전체</option>
							<option value="Y">있음</option>
							<option value="N">없음</option>
						</select>
					</td>

					<th>수정여부</th>
					<td>
						<select name="srchUpdateYn">
							<option value="">전체</option>
							<option value="Y">있음</option>
							<option value="N">없음</option>
						</select>
					</td>

					<th>조회기간</th>
					<td colspan="3">
						<input type="text" name="srchStrDt" class="calendar" mindateid="srchEndDt" /> ~ <input type="text" name="srchEndDt" class="calendar" maxdateid="srchStrDt" />
					</td>

					<td colspan="2">
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
			<h2><span class="x-icon"></span><span class="x-label">회수현황</span></h2>
			<span class="buttonset fr">
				<select name="srchIdVisible">
					<option value="hide">입력자숨김</option>
					<option value="show">입력자표시</option>
				</select>
				<button type="button" id="xlsBtn" class="btn_list" ><span class="ico_xls ico_only"></span></button>
			</span>
		</div>
		<table id="grid1"></table>
		<div id="grid1Pg"></div>
	</div>

	<div class="colgroup-wrap mT20">
		<div class="caption-pnl">
			<h2><span class="x-icon"></span><span id="lbAdj" class="x-label">회수수량 조정</span></h2>
			<span class="buttonset fr">
				<button type="button" class="btn_list_rd" id="btnAdjCntSave"><span class="ico_save"></span>조정수량 저장</button>
				<button type="button" class="btn_list_rd" id="btnRcptYnSave"><span class="ico_save"></span>전표확인 저장</button>
			</span>
		</div>
		<table id="grid2"></table>
		<div id="grid2Pg"></div>
	</div>
</div>