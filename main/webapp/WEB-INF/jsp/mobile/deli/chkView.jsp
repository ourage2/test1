<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script>
var vMain;

jQuery(function($) {

	vMain = new Vue({
		el: '#main',
		data: {
			editable: false
		},
		methods: {
			pkgInCntSave: function (e, isTemp) {
				user.pkgInCntSave(isTemp, this.list);
			},
			isEditable: function() {
				if (this.editable) {
					return false;
				}
				return this.view.unloadChkYn === 'Y';
			},
			setEditable: function(e, editable) {
				this.editable = editable;
			},
			getColor: function (i) {
				return this.list[i].difInCnt > 0 ? {color: 'red'} : {};
			}
		}
	});

	user.mainInit();
});

var user = {
	//메인페이지 초기화
	mainInit : function() {
		user.chkView();
	},

	chkView: function () {
		onm.ajax({
			url: _contextPath_ + '/mobile/deli/chkView.json',
			data: vMain.queryParam,
			success: function (res) {
				vMain.setData(res.view, 'view');
				vMain.setData(res.list, 'list', true);
			}
		});
	},

	pkgInCntSave: function (isTemp, list) {
		
		if (!vMain.validRefs(['inCnt'])) return false;
		
		var msg;
		if (isTemp) msg = '하차 검수 수량을 임시저장 하시겠습니까?';
		else msg = '하차 검수 수량을 저장 하시겠습니까?';

		onm.confirm2(msg, function () {
			
			onm.stripList(list, ['inCnt'], '0');
			
			var payload = {
				list: list,
				tempYn: isTemp ? 'Y' : 'N'
			};
			
			onm.ajax({
				url: _contextPath_ + '/mobile/deli/pkgInCntSave.json',
				contentType: 'application/json;charset=UTF-8',
				data: JSON.stringify({payload: payload}),
				success: function (res) {
					user.chkView();
					vMain.editable = false;
				}
			});
		});
	}
}
</script>

<header>
	<div class="title_area">
		<a href="javascript:history.back()" class="layout_back" alt="이전으로"></a>
		<h2>하차 검수 수량 입력</h2>
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

	<table class="m_list">
		<colgroup>
			<col width="40%">
			<col width="20%">
			<col width="20%">
			<col width="20%">
		</colgroup>
		<template v-if="!isEditable()">
			<tr>
				<th>구분</th>
				<th colspan="3">하차수량</th>
			</tr>
			<template v-for="(item, i) in list">
				<tr>
					<td class="t_right">{{ item.pkgNm }}</td>
					<td colspan="3"><input type="number" required min="0" max="999" v-model="item.inCnt" ref="inCnt" v-on:focus="clearInput($event)" v-on:blur="determineInputVal($event, i, 'inCnt')"></td>
				</tr>
			</template>
		</template>
		<template v-else>
			<tr>
				<th>구분</th>
				<th>기사</th>
				<th>검수</th>
				<th>차이</th>
			</tr>
			<template v-for="(item, i) in list">
				<tr v-bind:style="getColor(i)">
					<td class="t_right">{{ item.pkgNm }}</td>
					<td>{{ item.inCnt }}</td>
					<td>{{ item.agentInCnt }}</td>
					<td>{{ item.difInCnt }}</td>
				</tr>
			</template>
		</template>
	</table>
	
	
	<div class="t_center mT10">
		<template v-if="!isEditable()">
			<button type="button" class="btn_list_rd w40" v-on:click="pkgInCntSave($event, true)"><span class="ico_save"></span>임시 저장</button>
		</template>
		<template v-else>
			<button type="button" class="btn_list_rd w40" v-on:click="setEditable($event, true)"><span class="ico_save"></span>수정</button>
		</template>
		<button type="button" class="btn_list_rd w40" v-on:click="pkgInCntSave($event, false)"><span class="ico_save"></span>완료</button>
	</div>
	
</div>