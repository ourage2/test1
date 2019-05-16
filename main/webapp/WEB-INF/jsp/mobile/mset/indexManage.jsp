<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script>
	jQuery(function ($) {
		//현장출고
		$('#btnRelease').on('click', function () {
			location.href = _contextPath_ + '/mobile/deli/inoutList.m';
		});

		//하차검수
		$('#btnUnloadChk').on('click', function () {
			location.href = _contextPath_ + '/mobile/deli/chkList.m';
		});
	});
</script>

<header>
	<div class="title_area">
		<%--<a href="javascript:history.back()" class="layout_back" alt="이전으로"></a>--%>
		<h2>업무 선택</h2>
	</div>
</header>


<div id="main">
	<div class="menu_link h_50p"><button id="btnRelease" type="button" class="menu_link_btn car_geton ">현장출고</button></div>
	<div class="menu_link h_50p"><button id="btnUnloadChk" type="button" class="menu_link_btn car_getoff ">하차검수</button></div>
</div>

