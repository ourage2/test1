<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script>
	jQuery(function ($) {

		/*$('#btnWorkStat').on('click', function () {

		});*/

		//납품정보수신
		$('#btnDeliInfoList').on('click', function () {
			location.href = _contextPath_ + '/mobile/deli/infoList.m';
		});

		//납품내역조회
		$('#btnDeliList').on('click', function () {
			location.href = _contextPath_ + '/mobile/deli/deliList.m';
		});

		//차량온도조회
		$('#btnCarTempList').on('click', function () {
			location.href = _contextPath_ + '/mobile/car/tempList.m';
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
	<!-- 업무상태: 배송업무 시작전, 배송 업무 중, 배송 업무 완료 -->
	<%--<div class="page_info ">

		<span>업무진행 상태</span>
		<button id="btnWorkStat" type="button" class="menu_link_btn" >진행중</button>
	</div>--%>
	<div class="menu_link"><button id="btnDeliInfoList" type="button" class="menu_link_btn car_loc">납품 정보 수신</button></div>
	<div class="menu_link"><button id="btnDeliList" type="button" class="menu_link_btn car_srch">납품 내역 조회</button></div>
	<div class="menu_link"><button id="btnCarTempList" type="button" class="menu_link_btn car_ondo">차량 온도 조회</button></div>
</div>