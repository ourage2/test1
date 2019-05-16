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
			modifiableOutCnt: function () {
				return this.view.outCntIfStat === null || this.view.outCntIfStat === 'R';
			},
			
			modifiableInCnt: function () {
				return this.view.inCntIfStat === null || this.view.inCntIfStat === 'R';
			},
			
			//도착취소
			ioSaveRdyCancelSave: function (e) {
				user.ioSaveRdyCancelSave(this.view);
			},
			//저장
			agentInOutCntSave: function (e) {
				user.agentInOutCntSave(this.view, this.list);
			}
		},

		computed:  {
			visibleIoSaveRdyCancelSave: function() {
				return this.view.ioSaveRdyYn === 'Y' && this.view.ioSaveYn === 'N';
			}
		}
	});

	user.mainInit();
});

var user = {
	//메인페이지 초기화
	mainInit : function() {
		user.infoView();
	},

	infoView: function () {
		onm.ajax({
			url: _contextPath_ + '/mobile/deli/infoView.json',
			data: vMain.queryParam,
			success: function (res) {
				vMain.setData(res.view, 'view');
				vMain.setData(res.list, 'list', true);
			}
		});
	},

	//도착취소
	ioSaveRdyCancelSave: function (item) {
		var data = {
			shipNo: item.shipNo,
			carId: item.carId,
			agentCd: item.agentCd,
			deliNo: item.deliNo,
			ioSaveRdyYn: 'N'
		};

		onm.ajax({
			url: _contextPath_ + '/mobile/deli/ioSaveRdySave.json',
			data: data,
			success: function (res) {
				if (res.result > 0) {
					user.infoAgentList(item);
				} else {
				}
			}
		});
	},

	infoAgentList: function(item) {
		var q = $.param({
			shipNo: item.shipNo,
			carId: item.carId
		});
		location.replace(_contextPath_ + '/mobile/deli/infoAgentList.m?' + q)
	},

	//저장
	agentInOutCntSave: function(view, list) {
		var refs = [];
		$.each(vMain.$refs, function (key) {
			refs.push(key);
		});
		if (refs.length > 0) {
			if (!vMain.validRefs(refs)) return false;
		}

		var msg = '현장 출고 회수 수량을 저장 하시겠습니까 ?';
		if (view.lastIoSaveYn === 'Y') {
			msg += '\n예를 선택을 하시면 회수 수량을 수정을 할 수 없습니다.';
		}
		
		onm.confirm2(msg, function () {
			onm.stripList(list, ['inCnt', 'outCnt'], '0');

			var payload = {
				shipNo: vMain.view.shipNo,
				list: list
			};

			onm.ajax({
				url: _contextPath_ + '/mobile/deli/agentInOutCntSave.json',
				contentType: 'application/json;charset=UTF-8',
				data: JSON.stringify({payload: payload}),
				success: function (res) {
					if (res.sapIfYn === 'Y') {
						location.replace(_contextPath_ + '/mobile/deli/infoList.m');
					} else {
						user.infoAgentList(vMain.view);
					}
				}
			});
		});
	}
}
</script>

<header>
	<div class="title_area">
		<a href="javascript:history.back()" class="layout_back" alt="이전으로"></a>
		<h2>출고 회수 현황</h2>
	</div>
</header>

<div id="main" class="main_wrap">

	<table class="m_table">
		<colgroup>
			<col width="20%">
			<col width="80%">
		</colgroup>
		<tr>
			<th>선적번호</th>
			<td class="t_left">{{ view.shipNo }}</td>
		</tr>
		<tr>
			<th>대리점명</th>
			<td class="t_left">{{ view.agentNm }} ({{ view.deliNo }})</td>
		</tr>
	</table>

	<div class="t_center mT5 mB5">전체 출고 팔레트: {{ view.pltCnt }} 개</div>

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
				<td>
					<template v-if="modifiableOutCnt()">
						<input type="number" required min="0" max="999" style="font-size: 14pt;"
							   ref="outCnt" v-model="item.outCnt" v-on:focus="clearInput($event)" v-on:blur="determineInputVal($event, i, 'outCnt')">
					</template>
					<template v-else>
						{{ item.outCnt }}
					</template>
				</td>
				<td>
					<template v-if="modifiableInCnt()">
						<input type="number" required min="0" max="999" style="font-size: 14pt;"
							   ref="inCnt" v-model="item.inCnt" v-on:focus="clearInput($event)" v-on:blur="determineInputVal($event, i, 'inCnt')">
					</template>
					<template v-else>
						{{ item.inCnt }}
					</template>
				</td>
			</tr>
		</template>

	</table>

	<div class="t_center mT10">
		<template v-if="visibleIoSaveRdyCancelSave">
			<button type="button" class="btn_list_rd w30 m_btn" v-on:click="ioSaveRdyCancelSave"><span class="ico_cancle"></span>도착 취소</button>
		</template>
		
		<template v-if="modifiableOutCnt() || modifiableInCnt()">
			<button type="button" class="btn_list_rd w30 m_btn" v-on:click="agentInOutCntSave"><span class="ico_save"></span>저장</button>
		</template>
	</div>

</div>