<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script>
var view1p$;

jQuery(function($) {
	view1p$ = com.toBox($('#popView1'));

	//엑셀다운로드
	$('#btnView1Xls').on('click', function() {
		cvo.ajaxFileDown({url: _contextPath_ + '/manage/basis/agentIoList.xls', data: com.getData(view1p$)});
	});

	//대리점출도착 일괄적용 파일업로드 및 처리
	$('#btnView1Apply').on('click', function() {
		fileProc();
	});

	init();
});

function init() {
	lastUpdateView();
}

function lastUpdateView() {
	onm.ajax({
		url: _contextPath_+'/manage/basis/agentLastUpdateView.json',
		data: com.set(view1p$),
		success:function(data) {
			var row = data.view;
			if (row != null) {
				view1p$.find('[name=lastUpdateDt]').val(onm.formatTimeToDate(row.lastUpdateDt, 'yyyy-MM-dd HH:mm:ss') || '');
				view1p$.find('[name=workNm]').val(row.workNm);
			} else {
				view1p$.find('[name=lastUpdateDt]').val('최초');
				view1p$.find('[name=workNm]').val('최초');
			}
		}
	});
}

function fileProc() {
	var formData = new FormData();
	var file = view1p$.find('[name=excelFile]')[0].files[0];
	if (typeof(file) === 'undefined') {
		onm.alert('대리점출도착 엑셀파일을 첨부해 주세요.');
		return false;
	}

	formData.append('file', file);
	formData.append('jsonData', JSON.stringify(com.getData(view1p$)));

	if (!(file.name).endsWith('xls') && !(file.name).endsWith('xlsx')) {
		onm.alert('엑셀파일만 가능합니다.');
		return false;
	}
	if (file.size > fileMaxSize) {
		onm.alert('첨부가능 용량(' + (fileMaxSize / 1000 / 1000) + 'M)을 초과했습니다.');
		return false;
	}

	onm.ajax({
		url: _contextPath_ + '/manage/basis/agentIoSave.json',
		data : formData,
		type: 'POST',
		contentType : false,
		processData : false,
		success : function(res) {
			$('#srchBtn').trigger('click');
			$('.popup-close').trigger('click');
			onm.alert('대리점출도착 일괄설정 완료. [전체: ' + res.result +'건]');
		}
	});
}

</script>

<div id="popView1" class="popup-content" style="width:900px;">
	<div class="caption-pnl">
		<h2>엑셀다운</h2>
		<span class="buttonset fr hidden">
			<button type="button" class="popup-close btn_list"><span class="ico_cancle"></span>닫기</button>
		</span>
	</div>

	<table class="dtl_tbl">
		<colgroup>
			<col width="15%">
			<col width="25%">
			<col width="15%">
			<col width="25%">
			<col width="*">
		</colgroup>
		<tr>
			<th>최종업데이트</th>
			<td><input type="text" name="lastUpdateDt" maxlength="20" readonly="readonly" /></td>
			<th>작업자</th>
			<td><input type="text" name="workNm" maxlength="50" readonly="readonly" /></td>
			<td><button type="button" id="btnView1Xls" class="btn_list" ><span class="ico_xls"></span>다운로드</button></td>
		</tr>
	</table>
	<div class="caption-pnl mT30">
		<h2>대리점출도착 일괄적용</h2>
	</div>
	<table class="dtl_tbl">
		<colgroup>
			<col width="25%">
			<col width="55%">
			<col width="20%">
		</colgroup>
		<tr>
			<th>엑셀파일</th>
			<td><input type="file" name="excelFile" /></td>
			<td><button type="button" class="btn_list_rd" id="btnView1Apply"><span class="ico_save"></span>적용</button></td>
		</tr>
	</table>

	<div class="mT30"></div>
</div>
