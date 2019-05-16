<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script>
var vMain;

jQuery(function($) {
	vMain = new Vue({
		el: '#main'
	});

	user.mainInit();
});

var user = {
	//메인페이지 초기화
	mainInit : function() {
		user.deliView();
	},

	deliView: function () {
		onm.ajax({
			url: _contextPath_ + '/mobile/deli/deliView.json',
			data: vMain.queryParam,
			success: function (res) {
				vMain.setData(res.view, 'view');
				vMain.setData(res.list, 'list');
			}
		});
	}
}
</script>

<header>
	<div class="title_area">
		<a href="javascript:history.back()" class="layout_back" alt="이전으로"></a>
		<h2>납품 회수 현황 - 대리점별</h2>
	</div>
</header>

<div id="main" class="main_wrap">

	<table class="m_table">
		<colgroup>
			<col width="25%">
			<col width="75%">
		</colgroup>
		<tr>
			<th>선적번호</th>
			<td>{{ view.shipNo }}</td>
		</tr>
		<tr>
			<th>대리점명</th>
			<td>{{ view.agentNm }} ({{ view.deliNo }})</td>
		</tr>
	</table>
	
	<table class="m_list mT10">
		<colgroup>
			<col width="40%">
			<col width="20%">
			<col width="20%">
			<col width="20%">
		</colgroup>
		
		<tr>
			<th>구분</th>
			<th>송장출고</th>
			<th>하차</th>
			<th>회수</th>
		</tr>
		<template v-for="(item, i) in list">
			<tr>
				<td>{{ item.pkgNm }}</td>
				<td>{{ item.sapOutCnt }}</td>
				<td>{{ item.outCnt }}</td>
				<td>{{ item.inCnt }}</td>
			</tr>
		</template>
		
	</table>
	
</div>