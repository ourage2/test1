<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<spring:eval expression="@config['server.mode']" var="serverMode" />

<c:choose>
	<c:when test="${util:getUrlExt() eq 'do'}">

<script>
jQuery(function($) {
	var headerTimer$ = $('#headerTimer');
	var headerTimerApply = ('${sessionScope[cmnConst.sessionTimerApply]}'==='Y');
	var sesTime = onm.parseInt('<spring:eval expression="@config['session.timeout']" />');
	var sessionTimeoutManual = '<spring:eval expression="@config['session.timeout.manual']" />';
// 	onm.setTimer(headerTimer$, headerTimerApply, sesTime, sessionTimeoutManual);
});

var menuCnt;
var menu$;

function goLink(url, title) {
	if ($('#menuTab').length <= 0) {
		onm.alert('메인화면으로 이동후 선택해 주세요.');
		return;
	}
	if ($('div.ui-icon-close').length >= 10) {
		onm.alert('메뉴허용 갯수를 초과 했습니다.\n기존 메뉴를 닫고 선택해 주세요.');
		return;
	}

	var menuTmp = '<li><a href="#href#">#label#</a> <div class="ui-icon ui-icon-arrowrefresh-1-s sel" title="새로고침">새로고침</div><div class="ui-icon ui-icon-close sel" title="화면닫기">화면닫기</div></li>';
	var id = 'tab-' + menuCnt;
	var li = $(menuTmp.replace(/#href#/g, '#' + id).replace(/#label#/g, title));
	menu$.find('.ui-tabs-nav').append(li);
	menu$.append('<div class="tab_div" id="' + id + '">' + '<iframe id="frame_' + menuCnt + '" onload="resizeFrame(this)" class="tab_frame" src="' + url + '" ></iframe>' + '</div>');
	menu$.tabs('refresh');
	menu$.tabs('option', 'active', $('div.ui-icon-close').length - 1);
	menuCnt++;
}

function resizeFrame(frm, nm) {
// 	frm.style.height = 'auto';
	var contentHeight = frm.contentWindow.document.body.scrollHeight;
// 	console.log('top:'+contentHeight);

	frm.style.height = contentHeight + (nm != 'dash' ? 57 : 6) + 'px';
	if (nm == 'dash') {
		frm.style.width = '1205px';
		frm.style.display = 'block';
		frm.style.margin = '0 auto';
	}

	if (!nm) {
		frm.onload = null;
	}
}

</script>

<div id="layout_header">
	<div class="layout_header_top_carousel">
		<div class="layout_header_top_logo">
			<h1><a href="<c:url value="/main/index.do" />"><img src="<c:url value="/resources/image/cmn/sys_logo_name.png"/>" /></a></h1>
		</div>
		<div class="layout_header_top_logo_center">

		</div>
		<c:if test="${not empty sessionScope[cmnConst.sesUserData]}">
			<div class="layout_header_top_info">
				<ul class="layout_header_top_info_menu">
					<li class="userinfo"><span>${sessionScope[cmnConst.sesUserData].userNm}[${sessionScope[cmnConst.sesUserData].userId}]님</span>로그인.</li>
					<li class="timeinfo">최근접속: <fmt:formatDate value="${sessionScope[cmnConst.sesUserData].lastConDt}" pattern="yyyy-MM-dd HH:mm:ss" /></li>
					<li><a href="javascript:;" id="btnUserInfo" onclick="goLink('<c:url value="/manage/basis/userView.ifm"/>', '사용자정보')">사용자정보</a></li>
					<li class="logout"><a href="<c:url value="/main/logout.do" />">로그아웃</a></li>
					<c:if test="${util:startsWith(serverMode, 'LOCAL')}">
						<li style="margin:0 0 0 5px;"><a href="<c:url value="/exam/sample/index.do" />">샘플</a></li>
						<li style="margin:0 0 0 5px;"><a href="<c:url value="/mobile/mmain/mindex.m" />?userId=Z3Vlc3Qx">모바일</a></li>
					</c:if>
					<li style="margin:0 0 0 5px;"><button type="button" class="btn_list_sm" onclick="fnAllTabClose();">전체닫기</button></li>
				</ul>
			</div>
		</c:if>
	</div>
</div>


	</c:when>
	<c:when test="${util:getUrlExt() eq 'm'}">
	</c:when>
</c:choose>



