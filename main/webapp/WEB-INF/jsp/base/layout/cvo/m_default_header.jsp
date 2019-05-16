<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<spring:eval expression="@config['server.mode']" var="serverMode" />
<c:set value="${pageContext.request.contextPath}" var="contextPath" />

<script>

function maxHeight(el$) {
	return Math.max(el$.outerHeight(true), el$.prop('scrollHeight'));
}

function calcParentHeight(el$) {
	el$.parentsUntil('body').each(function () {
		var that = this;

		var arr = $.map($(this).siblings().filter(':visible').not(':hidden,script'), function (item) {
			return that !== item ? maxHeight($(item)) : 0;
		});

		var h = arr.length > 0 ? arr.reduce(function (a, b) {
			return a + b;
		}) : 0;

		if (h > 0) {
			$(that).css('height', 'calc(100% - ' + h + 'px)');
		} else {
			$(that).css('height', '100%');
		}
	});
}

function calcHeight(el$, css) {
	if($.type(css) === 'null' || $.type(css) === 'undefined') {
		css = {};
	}
	var arr1 = $.map(el$.siblings().filter(':visible').not(':hidden,script'), function (item) {
		return maxHeight($(item));
	});

	if (arr1.length > 0) {
		var h = arr1.reduce(function (a, b) {
			return a + b;
		});
		h += el$.outerHeight(true) - el$.height();
		if (h > 0) {
			$.extend(true, css, {'height': 'calc(100% - ' + h + 'px)'});
		} else {
			$.extend(true, css, {'height': '100%'});
		}

		el$.css(css);
	}
}

function fnLogout() {
	if (confirm('로그아웃 하시겠습니까?')) {
		if (typeof(mCVO) !== 'undefined') {
			mCVO.msgLogOut('Y');
			return false;
		} else {
			window.location.href = _contextPath_ + '/mobile/mmain/mlogout.m';
			return false;
		}

	}
}

jQuery(function($) {

	$('.top_allmenu').on('click', function () {
		$('#leftlist').css({'display': 'inline-block'});
	});

	$('.logtop_close').on('click', function () {
		$('#leftlist').hide();
	});

	$('.m_srch_toggle').on('click', function () {
		var flag = $(this).hasClass('on');

		if (flag) {
			$('.srch_box').hide();
		} else {
			$('.srch_box').show();
		}

		$(this).toggleClass('on').toggleClass('off');

		calcHeight($('#main'));
	});


	var main$ = $('#main');
	calcParentHeight(main$);
	calcHeight(main$);

// 	onm.ajax({
// 		url: _contextPath_ + '/mobile/mmain/alarmCnt.json',
// 		async: false,
// 		success: function (res) {
// 			$('#pushCnt').text(res.alarmCnt);
// 		}
// 	});
});
</script>


<c:set var="mAuthCd" value="${sessionScope[cmnConst.sesUserData].mAuthCd}"/>

<c:if test="${mAuthCd eq '1' or mAuthCd eq '2'}">
	<c:set var="indexUrl" value="${contextPath}${'/mobile/mset/indexCenter.m'}"/>
</c:if>
<c:if test="${mAuthCd eq '3'}">
	<c:set var="indexUrl" value="${contextPath}${'/mobile/mset/indexDeli.m'}"/>
</c:if>
<c:if test="${mAuthCd eq '5'}">
	<c:set var="indexUrl" value="${contextPath}${'/mobile/mset/indexManage.m'}"/>
</c:if>
<c:if test="${mAuthCd eq '6'}">
	<c:set var="indexUrl" value="${contextPath}${'/mobile/mset/indexAgent.m'}"/>
</c:if>

<div id="header">
	<div class="head_area">
		<a href="javascript:;" class="top_allmenu" alt="전체메뉴"></a>
		<h1 class="logo"><a href="${indexUrl}" class="top_logo">온도 관제 시스템</a></h1>
		<a href="${contextPath}/mobile/mset/alarmList.m" class="top_alarm" alt="알림" title="알림">
<!-- 			<div class="top_alarm_count" id="pushCnt"></div> -->
		</a>
	</div>

	<aside id="leftlist" class="reveal-left-nav" style="display: none; transform: translateX(260px) translateY(0px); width: 260px; left: -260px;">
		<div class="lf_wrap" style="overflow: hidden; z-index: 2000; height: 640px;">
			<div class="mcom_scroll" style="position: absolute; z-index: 1999; left: 0px; top: 0px; transition-property: -webkit-transform; transform: translate(0px, 0px); width: 100%;">
				<div class="logwrap">
					<div class="logtop">
<!-- 						<a href="javascript:;" style="display:none"><span class="ico_user">&nbsp;</span><span class="tx">로그인 해주세요</span></a> -->
						<a href="javascript:;"><span class="ico_user">&nbsp;</span><span class="tx">${sessionScope[cmnConst.sesUserData].userNm}[${sessionScope[cmnConst.sesUserData].userId}]님</span></a>
						<div class="logtop_right">
							<button type="button" class="logtop_close">전체 서비스 보기 닫기</button>
						</div>
					</div>
				</div>
				<div class="m_article">
					<h2 class="h2">온도 관제 시스템</h2>
					<div class="main_menu_area">
						<ul class="main_menu">

							<c:if test="${mAuthCd eq '1' or mAuthCd eq '2'}">
								<li class="main_menu_tt">
									<a href="javascript:;" >차량 관리</a>
								</li>
								<li>
									<a href="${contextPath}/mobile/car/nowList.m"><span class="nav_icon car_loc">&nbsp;</span>실시간 차량 위치<span>&nbsp;</span></a>
								</li>
								<li>
									<a href="${contextPath}/mobile/car/pathList.m"><span class="nav_icon car_srch">&nbsp;</span>운행 경로<span>&nbsp;</span></a>
								</li>

								<li class="main_menu_tt">
									<a href="javascript:;" >온도 관리</a>
								</li>
								<li>
									<a href="${contextPath}/mobile/car/tempNowList.m"><span class="nav_icon car_ondo">&nbsp;</span>실시간 차량 온도<span>&nbsp;</span></a>
								</li>
								<li>
									<a href="${contextPath}/mobile/car/tempList.m"><span class="nav_icon ondo_list">&nbsp;</span>온도 내역<span>&nbsp;</span></a>
								</li>
							</c:if>
							<c:if test="${mAuthCd eq '3'}">
								<li>
									<a href="${contextPath}/mobile/deli/infoList.m"><span class="nav_icon car_loc">&nbsp;</span>납품 정보 수신<span>&nbsp;</span></a>
								</li>
								<li>
									<a href="${contextPath}/mobile/deli/deliList.m"><span class="nav_icon car_srch">&nbsp;</span>납품 내역 조회<span>&nbsp;</span></a>
								</li>
								<li>
									<a href="${contextPath}/mobile/car/tempList.m"><span class="nav_icon car_ondo">&nbsp;</span>차량 온도 조회<span>&nbsp;</span></a>
								</li>
							</c:if>
							<c:if test="${mAuthCd eq '5'}">
								<li>
									<a href="${contextPath}/mobile/deli/inoutList.m"><span class="nav_icon car_geton">&nbsp;</span>현장 출고<span>&nbsp;</span></a>
								</li>
								<li>
									<a href="${contextPath}/mobile/deli/chkList.m"><span class="nav_icon car_getoff">&nbsp;</span>하차 검수<span>&nbsp;</span></a>
								</li>
							</c:if>
							<c:if test="${mAuthCd eq '6'}">
								<li>
									<a href="${contextPath}/mobile/car/agentTempList.m"><span class="nav_icon car_ondo">&nbsp;</span>차량 온도 조회<span>&nbsp;</span></a>
								</li>
								<li>
									<a href="${contextPath}/mobile/cargo/tempList.m"><span class="nav_icon car_ondo">&nbsp;</span>창고 온도 조회<span>&nbsp;</span></a>
								</li>
								<li>
									<a href="${contextPath}/mobile/car/deliList.m"><span class="nav_icon car_loc">&nbsp;</span>납품차량 위치 조회<span>&nbsp;</span></a>
								</li>
							</c:if>
						</ul>
					</div>
				</div>
				<div class="lf_setlist">
					<ul class="lf_set">
						<li>
							<a href="${contextPath}/mobile/mset/noticeList.m"><span class="icon_notice">&nbsp;</span>공지사항</a>
						</li>
						<li>
							<a href="${contextPath}/mobile/mset/pwdView.m"><span class="icon_pass">&nbsp;</span>비밀번호 변경</a>
						</li>
<!-- 						<li> -->
<!-- 							<a href="javascript:;" onclick="fnLogin()"><span class="icon_login">&nbsp;</span>로그인</a> -->
<!-- 						</li> -->
						<li>
							<a href="javascript:;" onclick="fnLogout();"><span class="icon_logout">&nbsp;</span>로그아웃</a>
						</li>
					</ul>
				</div>
			</div>
		</div>

		<div id="_mcom_aside_lft" class="mcom_aside_lft sm mcom_aside_lft_v2" style="height: 640px; overflow: hidden;">
			<div id="_mcom_ctg" class="mcom_ctg" style="z-index:1000">
			</div>
		</div>
	</aside>
</div>






