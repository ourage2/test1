<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script>
var vMain;

jQuery(function($) {
	vMain = new Vue({
		el: '#main',
		methods: {
			deliAgentList: function(e, i) {
				var item = this.list[i];
				user.deliAgentList(item);
			},
			moreList: function () {
				vMain.incPg();
				user.deliList();
			},
			shipNoColor: function (i) {
				var item = this.list[i];
				if (item.bizCd === 'T') {
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
		user.deliList();
	},

	getPostData: function () {
		return {carId: sUserData.userId, pg: vMain.srch.pg};
	},

	deliList: function () {
		onm.ajax({
			url: _contextPath_ + '/mobile/deli/deliList.json',
			data: user.getPostData(),
			success: function (res) {
				vMain.setPaginatedList(res);
			}
		});
	},
	
	deliAgentList: function(item) {
		var q = $.param({
			shipNo: item.shipNo
		});
		location.href = _contextPath_ + '/mobile/deli/deliAgentList.m?' + q;
	}
}
</script>

<header>
	<div class="title_area">
		<a href="javascript:history.back()" class="layout_back" alt="이전으로"></a>
		<h2>납품 내역 조회</h2>
	</div>
</header>

<div id="main">
	<ul class="grid_list">
		<template v-if="list.length > 0">
			<template v-for="(item, i) in list">
				<li v-on:click="deliAgentList($event, i)">
					<dl class="book_info f_left">
						<dt><a>[선적번호] <span v-bind:style="shipNoColor(i)">{{ item.shipNo }}</span></a></dt>
						<dd>납품요청일: {{ item.shipReqDate }}</dd>
					</dl>
					<div class="m_right_btn">
						{{ item.deliyDivTxt }}
					</div>
				</li>
			</template>
		</template>
		<template v-else>
			<li><div class="t_center">{{ emptyList }}</div></li>
		</template>
	</ul>
	
	<p class="paging_more">
		<template v-if="list.length > 0">
			<button type="button" v-bind:disabled="hasMore()" v-on:click="moreList()">{{ btnMoreTxt() }}</button>
		</template>
	</p>
</div>