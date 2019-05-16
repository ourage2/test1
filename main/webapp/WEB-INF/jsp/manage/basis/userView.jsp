<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script>
var view1$;

jQuery(function($) {
	view1$ = $('#divView1');

	$('#btnPwdUpdate').on('click', function() {pwdUpdate()}); //비밀번호변경

	init();
});

function init() {
	onm.ajax({
		url: _contextPath_+'/manage/basis/userView.json',
		data: {},
		success:function(data) {
			var row = data.view;
			com.setVal(view1$, data.view);
			view1$.find('[name=lastConDt]').val(onm.formatTimeToDate(row.lastConDt, 'yyyy-MM-dd HH:mm:ss') || '');
			view1$.find('[name=telNo]').val(naw.valMask(row.telNo, 'tel'));
			view1$.find('[name=hpNo]').val(naw.valMask(row.hpNo, 'tel'));
// 			view1$.find('[name=faxNo]').val(naw.valMask(row.faxNo, 'tel'));

			var authCenterCds = data.view.authCenterCd.split(',');
			var authCenterNm = '';
			for (var idx = 0; idx < authCenterCds.length; idx++) {
				authCenterNm += com.getCenter(authCenterCds[idx]) + ',';
			}
			view1$.find('[name=authCenterNm]').val(authCenterNm.substring(0, authCenterNm.length - 1));

		}
	});
}

function pwdUpdate() {
	var data = com.set(view1$);
	if (data.userPwd == '' || data.confirmUserPwd == '') {
		onm.alert('비밀번호를 입력해주세요.');
		return false;
	}
	if (data.userPwd != data.confirmUserPwd) {
		onm.alert('비밀번호를 다시 확인해주세요.');
		return false;
	}
	if (!confirm('비밀번호를 변경하시겠습니까?')) {
		return false;
	}

	onm.ajax({
		url: _contextPath_ + '/manage/basis/userPwdUpdate.json',
		data: data,
		success: function(res) {
			if (res.result != '0') {
				view1$.find('[name=userPwd]').val('');
				view1$.find('[name=confirmUserPwd]').val('');
				onm.alert('비밀번호가 변경되었습니다.');
			} else {
				onm.alert('비밀번호가 변경에 실패했습니다.');
			}
		},
		error: function() {
		}
	});
}
</script>

<div id="divView1">
	<div class="caption-pnl">
		<h2>사용자 상세정보</h2>
		<span class="buttonset fr">
			<button type="button" class="btn_list_rd" id="btnPwdUpdate"><span class="ico_save"></span>비밀번호 변경</button>
		</span>
	</div>
	<table class="dtl_tbl">
		<colgroup>
			<col width="6%">
			<col width="14%">
			<col width="6%">
			<col width="14%">
			<col width="6%">
			<col width="14%">
			<col width="6%">
			<col width="14%">
			<col width="6%">
			<col width="14%">
		</colgroup>
		<tr>
			<th>아이디</th>
			<td><input type="text" name="userId" maxlength="20" read /></td>
			<th>성명</th>
			<td><input type="text" name="userNm" maxlength="50" read /></td>
			<th>권한</th>
			<td><input type="text" name="authNm" maxlength="20" read /></td>
			<th>사용여부</th>
			<td><input type="text" name="useYnNm" maxlength="10" read /></td>
			<th>최종접속</th>
			<td><input type="text" name="lastConDt" maxlength="20" read /></td>
		</tr>
		<tr>
			<th>전화번호</th>
			<td><input type="text" name="telNo" maxlength="12" read /></td>
			<th>핸드폰</th>
			<td><input type="text" name="hpNo" maxlength="12" read /></td>
<!-- 			<th>팩스</th> -->
<!-- 			<td><input type="text" name="faxNo" maxlength="12" read /></td> -->
			<th>이메일</th>
			<td><input type="text" name="email" maxlength="50" read /></td>
			<th>비밀번호</th>
			<td><input type="password" name="userPwd" maxlength="12" /></td>
			<th>비밀번호 재확인 </th>
			<td><input type="password" name="confirmUserPwd" maxlength="12" /></td>
		</tr>
		<tr>
			<th>소속센터</th>
			<td><input type="text" name="centerNm" maxlength="20" read /></td>
			<th>권한센터</th>
			<td colspan="7"><input type="text" name="authCenterNm" maxlength="20" read /></td>
		</tr>
	</table>

</div>
