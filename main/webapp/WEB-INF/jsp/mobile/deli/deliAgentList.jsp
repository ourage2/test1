<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script>
var vMain;

jQuery(function($) {

	vMain = new Vue({
		el: '#main',
		data: {
		},
		methods: {
			deliView: function(e, i) {
				
				if (this.view.bizCd === 'T') {
					return false;
				}
				
				var item = this.list[i];
				/*if (item.arrYn === 'N') {
					e.preventDefault();
					return false;
				}*/
				user.deliView(item);
			},
			shipNoColor: function () {
				if (this.view.bizCd === 'T') {
					return 'color: #d55e00;';
				}
				return 'color: #153d70;';
			}
		}
	});

	user.mainInit();
});

var user = {
	//메인페이지 초기화
	mainInit : function() {
		user.deliAgentList();
	},

	deliAgentList: function () {
		onm.ajax({
			url: _contextPath_ + '/mobile/deli/deliAgentList.json',
			data: vMain.queryParam,
			success: function (res) {
				vMain.setData(res.view, 'view');
				vMain.setData(res.list, 'list');
			}
		});
	},

	deliView: function (item) {
		var q = $.param({
			shipNo: item.shipNo,
			carId: item.carId,
			agentCd: item.agentCd,
			deliNo: item.deliNo
		});
		location.href = _contextPath_ + '/mobile/deli/deliView.m?' + q;
	}
}
</script>

<header>
	<div class="title_area">
		<a href="javascript:history.back()" class="layout_back" alt="이전으로"></a>
		<h2>납품 회수 현황</h2>
	</div>	
</header>

<div id="main">
	<table class="m_table">
		<colgroup>
			<col width="25%">
			<col width="75%">
		</colgroup>
		<tr>
			<th>선적번호</th>
			<td v-bind:style="shipNoColor()">{{ queryParam.shipNo }}</td>
		</tr>
	</table>
	
	<ul class="grid_list">
		<template v-if="list.length > 0">
			<template v-for="(item, i) in list">
				<li v-on:click="deliView($event, i)">
					<dl class="book_info f_left">
						<dt>[{{ item.agentNm }}] [{{ item.deliNo }}]</dt>
						<dd>납품예정시간: {{ item.arrExpectDt }}</dd>
					</dl>
				</li>
			</template>
		</template>
		<template v-else>
			<li><div class="t_center">{{ emptyList }}</div></li>
		</template>
	</ul>
	
</div>