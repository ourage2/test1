<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script>
var view1$;

jQuery(function($) {
	view1$ = $('#divView1');

	$('#srchBtn').on('click', function() {pwdUpdate()}); //비밀번호변경

	init();
});

function init() {
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

<header>
	<div class="title_area">
		<a href="javascript:history.back()" class="layout_back" alt="이전으로"></a>
		<h2>비밀번호 변경</h2>
	</div>
</header>

<div id="main" style="height: calc(100% - 122px);">
	<div id="divView1">
		<div class="srch_box" style="display: block">
			<table>
				<colgroup>
					<col width="40%">
					<col width="60%">
				</colgroup>
				<tbody>
<!-- 					<tr> -->
<!-- 						<th>현재비밀번호</th> -->
<!-- 						<td> -->
<!-- 							<input type="password" name="nowUserPwd" maxlength="12" class="w98"> -->
<!-- 						</td> -->
<!-- 					</tr> -->
					<tr>
						<th>신규비밀번호</th>
						<td>
							<input type="password" name="userPwd" maxlength="12" class="w98">
						</td>
					</tr>
					<tr>
						<th>비밀번호 확인</th>
						<td>
							<input type="password" name="confirmUserPwd" maxlength="12" class="enterSrch w98">
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<button type="button" id="srchBtn" class="btn_srch m_srch">변경하기</button>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
</div>