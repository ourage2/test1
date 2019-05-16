<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>
<c:set value="${pageContext.request.contextPath}" var="contextPath" />

<script>
jQuery(function($) {
	$('.book_list ul>li>ul>li').on('click', function() {
		if (!$(this).attr('url')) { onm.alert('개발중입니다'); return; }
			location.href = $(this).attr('url');
		});
});
</script>

<div class="book_list">
	<ul>
		<li><a href="javascript:;">공통</a>
			<ul>
				<li url="${contextPath}/mobile/mset/noticeList.m"><a href="javascript:;">공지사항</a></li>
				<li url="${contextPath}/mobile/mset/pwdView.m"><a href="javascript:;">패스워드변경</a></li>
				<li url="${contextPath}/mobile/mset/alarmList.m"><a href="javascript:;">알림내역조회</a></li>
			</ul>
		</li>
		<li><a href="javascript:;">Index</a>
			<ul>
				<li url="${contextPath}/mobile/mset/indexManage.m"><a href="javascript:;">현장관리자</a></li>
				<li url="${contextPath}/mobile/mset/indexDeli.m"><a href="javascript:;">배송기사</a></li>
				<li url="${contextPath}/mobile/mset/indexCenter.m"><a href="javascript:;">센터담당자</a></li>
				<li url="${contextPath}/mobile/mset/indexAgent.m"><a href="javascript:;">대리점관리자</a></li>
			</ul>
		</li>
		<li><a href="javascript:;">차량</a>
			<ul>
				<li url="${contextPath}/mobile/car/nowList.m"><a href="javascript:;">차량현위치 조회</a></li>
				<li url="${contextPath}/mobile/car/pathList.m"><a href="javascript:;">차량위치경로 조회</a></li>
				<li url="${contextPath}/mobile/car/tempNowList.m"><a href="javascript:;">차량현재온도 조회</a></li>
				<li url="${contextPath}/mobile/car/tempList.m"><a href="javascript:;">차량온도 내역</a></li>
				<li url="${contextPath}/mobile/car/deliList.m"><a href="javascript:;">납품차량위치 조회</a></li>
				<li url="${contextPath}/mobile/car/agentTempList.m"><a href="javascript:;">대리점 차량현재온도 조회</a></li>
			</ul>
		</li>
		<li><a href="javascript:;">창고</a>
			<ul>
				<li url="${contextPath}/mobile/cargo/tempList.m"><a href="javascript:;">창고온도 내역</a></li>
			</ul>
		</li>
		<li><a href="javascript:;">배송</a>
			<ul>
				<li url="${contextPath}/mobile/deli/inoutList.m"><a href="javascript:;">현장출고</a></li>
				<li url="${contextPath}/mobile/deli/chkList.m"><a href="javascript:;">하차검수</a></li>
				<li url="${contextPath}/mobile/deli/infoList.m"><a href="javascript:;">납품정보 수신</a></li>
				<li url="${contextPath}/mobile/deli/deliList.m"><a href="javascript:;">납품내역 조회</a></li>
			</ul>
		</li>
	</ul>
</div>