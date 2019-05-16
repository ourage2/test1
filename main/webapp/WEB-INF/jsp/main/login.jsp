<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<c:if test="${not empty sessionScope[cmnConst.sesUserData] }">
	<meta http-equiv="refresh" content="0;url=${pageContext.request.contextPath}/main/index.do">
</c:if>

<script>
var view1$;
var isFrame = window.frameElement && window.frameElement.nodeName == 'IFRAME';

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

				window.location.href = _contextPath_ + res.redirectUrl;
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
// 	$('#srchBtn').trigger('click');

	if (window.localStorage.getItem('saveYn') == 'Y') {
		$('#saveYn').attr('checked', true);
		if (window.localStorage.getItem('saveId')) {
			view1$.find('[name=userId]').val(window.localStorage.getItem('saveId'));
		}
	}

	if (isFrame) {
		top.location.href = self.location.href;
	} else {
		$('.layout_bg').hide();
		$('#layout_header').hide();
		$('#loginView').show();
	}


	/*
	var id = 0;

	//자동실행
	id = setInterval(function(){
		$('.right').trigger('click');
	},3000); // 3000은 3초

	$('.container').on({
		// 마우스 오브 일때 setInterval(오토) 삭제
		mouseenter:function(e){
			clearInterval(id);
		 	id = 0; // setInterval 삭제
		},
		// 마우스 아웃 일때 setInterval 다시 재생
		mouseleave:function(e){
			id = setInterval(function(){
				$('.right').trigger('click');
			},3000); // 3000은 3초
		}
	});

	$('.right').on('click',function(e){
		var $first = $('.slider > li:first');
		$('.slider').animate({'margin-left':-300},
		function(){
			$(this).css('margin-left',0);
			$(this).append($first);
		});// 이동시켜할 대상은 ul(.slider)태그입니다.

	//$('.slider').append($first);
	});

	$('.left').on('click',function(e){
		var $last = $('.slider > li:last');
		$('.slider').prepend($last).css('margin-left',-300);
		$('.slider').animate({'margin-left':0});
	});
	*/
}

</script>

<style>
* {
	padding: 0;
	margin: 0;
	box-sizing: border-box
}

ul {
	list-style: none
}

.container {
	width: 580px;
}

.view {
	overflow: hidden;
	width: 580px;
	height: 470px;
	/*  border:1px solid #000 */
}

.slider {
	width: 1500px
}

.slider:after {
	display: block;
	clear: both;
	content: ""
}

.slider li {
	float: left;
	width: 580px;
	height: 470px;
	line-height: 300px;
	font-size: 5em;
	color: #fff;
	text-align: center;
	background: gray
}
</style>


<div id="loginView" class="login_wrap">
	<h1 class="sys_ci">매일유업</h1>
	<div class="login_box">
	<div class="slide_wrap">
		<div class='container'>
			<div class='view'>
				<ul class='slider'>
					<li><img src="<c:url value="/resources/image/layout/slide_01.png" />" width="100%"   /></li>
					<li><img src="<c:url value="/resources/image/layout/slide_02.png" />" width="100%"   /></li>
				</ul>
			</div>
			<button type='button' class='left'>왼쪽버튼</button>
  			<button type='button' class='right'>오른쪽버튼</button>
		</div>
	</div>
	<div class="login_content">

		<p class="sys_logo"><strong> Cold Chain</strong><br>Management System
		</p>
		<div id="divView1" class="login_form">
			<div><span>아이디</span><input type="text" name="userId" maxlength="20" placeholder="아이디를 입력해주세요" /></div>
			<div><span>비밀번호</span><input type="password" name="userPwd" maxlength="20" class="enterLogin" value="" placeholder="비밀번호를 입력해주세요" /></div>
			<div><input type="button" id="loginBtn" value="로그인" class="login_btn" /></div>
			<div class="chk"><input type="checkbox" id="saveYn" class="id_chk" /><span>아이디 저장</span></div>
		</div>
		<div class="login_helpdesk">

		</div>
	</div>
	</div>
</div>
<!--
<div id="loginView" class="colgroup-wrap mB50 hidden">
	<div class="colgroup-1-3">&nbsp;</div>
	<div class="colgroup-1-3" id="divView1">
		<div id="divView1">
			<h2 class="content_title"><span>로그인</span></h2>
			<table class="dtl_tbl">
				<colgroup>
					<col width="20%">
					<col width="80%">
				</colgroup>
				<tbody>
					<tr>
						<th>로그인ID</th>
						<td><input type="text" name="userId" maxlength="20" value="guest1" placeholder="사용자ID" /></td>
					</tr>
					<tr>
						<th>패스워드</th>
						<td>
							<input type="password" name="userPwd" maxlength="20" class="enterLogin" value="0000" placeholder="비밀번호" />
							<span class="btn_pack large icon"><span class="search"></span><input type="button" id="loginBtn" value="로그인" /></span>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
	<div class="colgroup-1-3">&nbsp;</div>
</div>
-->