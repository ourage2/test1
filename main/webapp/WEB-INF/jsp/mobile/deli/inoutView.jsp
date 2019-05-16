<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script>
var vMain;
jQuery(function($) {
	vMain = new Vue({
		el: '#main',
		methods: {
			pkgOutCntSave: function (e, isTemp) {
				user.pkgOutCntSave(this.view.shipNo, isTemp, this.list);
			},
			isRelease: function() {
				return this.view.releaseYn === 'Y';
			}
		}
	});

	user.mainInit();
});

var user = {
	//메인페이지 초기화
	mainInit : function() {
		user.inoutView();
	},

	inoutView: function () {
		onm.ajax({
			url: _contextPath_ + '/mobile/deli/inoutView.json',
			data: vMain.queryParam,
			success: function (res) {
				vMain.setData(res.view, 'view');
				vMain.setData(res.list, 'list', true);
			}
		});
	},

	pkgOutCntSave: function(shipNo, isTemp, list) {

		if (!vMain.validRefs(['outCnt'])) return false;

		var msg;
		if (isTemp) msg = '현장 출고 수량을 임시저장 하시겠습니까?';
		else msg = '현장 출고 수량을 저장 하시겠습니까?';

		onm.confirm2(msg, function () {

			onm.stripList(list, ['outCnt'], '0');

			var payload = {
				shipNo: shipNo,
				list: list,
				tempYn: isTemp ? 'Y' : 'N'
			};

			onm.ajax({
				url: _contextPath_ + '/mobile/deli/pkgOutCntSave.json',
				contentType: 'application/json;charset=UTF-8',
				data: JSON.stringify({payload: payload}),
				success: function (res) {
					user.inoutView();
				}
			});
		});
	}
}
</script>

<header>
	<div class="title_area">
		<a href="javascript:history.back()" class="layout_back" alt="이전으로"></a>
		<h2>현장 출고 수량 입력</h2>
	</div>
</header>


<div id="main" class="main_wrap">

	<table class="m_table">
		<colgroup>
			<col width="25%">
			<col width="75%">
		</colgroup>
		<tr>
			<th>차량번호</th>
			<td class="t_left">{{ view.carNo }}</td>
		</tr>
		<tr>
			<th>선적번호</th>
			<td class="t_left">{{ view.shipNo }}</td>
		</tr>
	</table>

	<table class="m_list mT10">
		<colgroup>
			<col width="40%">
			<col width="60%">
		</colgroup>
		<tr>
			<th>구분</th>
			<th>하차수량</th>
		</tr>
		<template v-for="(item, i) in list">
			<tr>
				<td>{{ item.pkgNm }}</td>
				<td><input type="number" required min="0" max="999" v-model="item.outCnt" ref="outCnt" v-bind:readonly="isRelease()" v-on:focus="clearInput($event)" v-on:blur="determineInputVal($event, i, 'outCnt')"></td>
			</tr>
		</template>
	</table>

	<template v-if="!isRelease()">
		<div class="t_center mT10">
			<button type="button" class="btn_list_rd w40 m_btn" v-on:click="pkgOutCntSave($event, true)"><span class="ico_save"></span>임시 저장</button>
			<button type="button" class="btn_list_rd w40 m_btn" v-on:click="pkgOutCntSave($event, false)"><span class="ico_apply"></span>완료</button>
		</div>
	</template>
</div>