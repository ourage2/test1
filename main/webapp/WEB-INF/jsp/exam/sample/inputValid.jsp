<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>
<script>
jQuery(function($) {
	var frm$ = $('#frm');
	var srchStartDt$ = $('#srchStartDt').val(onm.getBeforeMonth());
	var srchEndDt$ = $('#srchEndDt').val(onm.todayFmt());
	var srchStartDt2$ = $('#srchStartDt2').val(onm.getBeforeMonth());
	var srchEndDt2$ = $('#srchEndDt2').val(onm.todayFmt());
	var srchRequired$ = $('#srchRequired');
	var srchNum$ = $('#srchNum');
	var srchNum2$ = $('#srchNum2');
	var srchEnNum$ = $('#srchEnNum');
	var srchEnNum2$ = $('#srchEnNum2');
	var srchUserId$ = $('#srchUserId');
	var srchPassword$ = $('#srchPassword');

	frm$.on('submit', function() {
// 		if(!onm.checkDate(srchStartDt$, '달력항목(시작일자)')) {
// 			return false;
// 		}
// 		if(!onm.checkDate(srchStartDt2$, '달력항목(시작일자)2')) {
// 			return false;
// 		}
		if(!onm.checkRequired(srchRequired$, '필수항목')) {
			return false;
		}
		if(!onm.checkNumber(srchNum$, '숫자항목')) {
			return false;
		}
		if(!onm.checkNumber(srchNum2$, '숫자항목2')) {
			return false;
		}
		if(!onm.checkEnNum(srchEnNum$, '영문숫자항목')) {
			return false;
		}
		if(!onm.checkEnNum(srchEnNum2$, '영문숫자항목2')) {
			return false;
		}
		if(!onm.checkUserId(srchUserId$, '아이디항목')) {
			return false;
		}
		if(!onm.checkPassword(srchPassword$, '비밀번호항목')) {
			return false;
		}

		alert('전송');
		return false;
	});
});
</script>
<h2 class=content_title>입력 유효성 체크</h2>

<form name="frm" id="frm">
	<table class="dtl_tbl">
		<colgroup>
			<col style="width:20%;" />
			<col style="width:30%;" />
			<col style="width:20%;" />
			<col style="width:30%;" />
		</colgroup>
		<tr>
			<th>달력항목</th>
			<td>
				<input type="text" name="srchStartDt" id="srchStartDt" class="inputDatePicker" /> ~ <input type="text" name="srchEndDt" id="srchEndDt" class="inputDatePicker" />
			</td>
			<th>달력항목2</th>
			<td>
				<input type="text" name="srchStartDt2" id="srchStartDt2" /> ~ <input type="text" name="srchEndDt2" id="srchEndDt2" />
			</td>
		</tr>
		<tr>
			<th>필수항목<span class="required"></span></th>
			<td colspan="3"><input type="text" name="srchRequired" id="srchRequired" value="필수" /></td>
		</tr>
		<tr>
			<th>숫자항목</th>
			<td><input type="text" name="srchNum" id="srchNum" class="inputNumber" value="123" /></td>
			<th>숫자항목2</th>
			<td><input type="text" name="srchNum2" id="srchNum2" value="123" /></td>
		</tr>
		<tr>
			<th>영문숫자항목</th>
			<td><input type="text" name="srchEnNum" id="srchEnNum" class="inputEnNum" value="123abc" /></td>
			<th>영문숫자항목2</th>
			<td><input type="text" name="srchEnNum2" id="srchEnNum2" value="123abc" /></td>
		</tr>
		<tr>
			<th>아이디항목</th>
			<td><input type="text" name="srchUserId" id="srchUserId" value="userid12_" /></td>
			<th>비밀번호항목</th>
			<td><input type="text" name="srchPassword" id="srchPassword" value="pw12@!" /></td>
		</tr>
	</table>

	<div class="btn_input_area">
		<span class="btn_pack large"><button type="submit">저장</button></span>
	</div>
</form>