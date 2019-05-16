<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<c:if test="${not empty sessionScope[cmnConst.sesUserData] }">
	<meta http-equiv="refresh" content="0;url=${pageContext.request.contextPath}/mobile/mmain/mindex.m">
</c:if>

<script>
var view1$;

jQuery(function($) {
	view1$ = $('#divView1');

	//로그인
	$('#loginBtn').on('click', function() {

		if (view1$.find('[name=userId]').val() == '') {
			onm.alert('ID를 입력해 주세요.');
			return;
		}
		if (view1$.find('[name=userPwd]').val() == '') {
			onm.alert('비밀번호를 입력해 주세요.');
			return;
		}

		var data = com.getData(view1$);
		data.app = '2'; //safari login의 경우엔 2를 넣는다
		onm.ajax({
			url: _contextPath_+'/main/login.json',
			data: data,
			success:function(res) {
				if ($('#saveYn').prop('checked')) {
					window.localStorage.setItem('saveYn', 'Y');
					window.localStorage.setItem('saveId', view1$.find('[name=userId]').val());
				} else {
					window.localStorage.setItem('saveYn', 'N');
					window.localStorage.setItem('saveId', null);
				}


				$("#frm").find('[name=userId]').val(res.token);
				$("#frm").find('[name=safariYn]').val(res.safariYn);
				$("#frm").attr("target", "_self");
				$("#frm").attr("action", _contextPath_ + res.redirectUrl).submit();

// 				window.location.href = _contextPath_ + res.redirectUrl + '?userId=' + res.token + '&safariYn=' + res.safariYn;
			}
		});
	});

	$('.enterLogin').keydown(function(event) {
		if (event.which == 13) {
			$(this).parent().parent().find('#loginBtn, button').each(function(){
				if(this.type == 'button' || this.id == 'loginBtn') {
					$(this).trigger('click');
				}
			});
		}
	});

	init();
});

function init() {
	$('.login_content').show();
	$('#header').hide();
// 	$('#srchBtn').trigger('click');

	if (window.localStorage.getItem('saveYn') == 'Y') {
		$('#saveYn').attr('checked', true);
		if (window.localStorage.getItem('saveId')) {
			view1$.find('[name=userId]').val(window.localStorage.getItem('saveId'));
		}
	}
}
</script>

<div class="login_content" style="display:none">
	<div class="login_wrap"></div>
	<div class="h1_wrap"><h1 class="sys_ci"></h1></div>
	<p class="sys_logo">
	Cold Chain<br>Management System</p>
	<div id="divView1" class="login_form">
		<div><span>아이디</span><input type="text" name="userId" maxlength="12" style="width:60%;" placeholder="아이디를 입력해주세요" /></div>
		<div><span>비밀번호</span><input type="password" name="userPwd" maxlength="12" style="width:60%;" class="enterLogin" value="" placeholder="비밀번호를 입력해주세요" /></div>
		<div><input type="button" id="loginBtn" value="로그인" class="login_btn" /></div>
		<div><input type="checkbox" id="saveYn" class="id_chk" /> <span>아이디 저장</span></div>
	</div>
	<div class="maeil_h"></div>
	<div class="login_helpdesk"></div>
</div>


<div class="m_intro"></div>

<form name="frm" id="frm" method="post" >
	<input type="hidden" name="userId" value="" />
	<input type="hidden" name="safariYn" value="" />
</form>

