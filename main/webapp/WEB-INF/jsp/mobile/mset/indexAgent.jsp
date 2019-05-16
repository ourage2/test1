<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script>
var vMain;

jQuery(function($) {

	vMain = new Vue({
		el: '#main',
		methods: {
			carTemp: function (e) {
				user.agentTempList();
			},
			cargoTemp: function (e) {
				user.cargoTempList();
			},
			carPos: function (e) {
				user.carPos();
			}
		}
	});

	user.mainInit();
});

var user = {
	//메인페이지 초기화
	mainInit: function () {
		user.indexAgent();
	},

	indexAgent: function () {
		onm.ajax({
			url: _contextPath_ + '/mobile/mset/indexAgent.json',
			success: function (res) {
				vMain.setData(res.view, 'view');
			}
		});
	},

	agentTempList: function () {
		location.href = _contextPath_ + '/mobile/car/agentTempList.m';
	},

	cargoTempList: function () {
		location.href = _contextPath_ + '/mobile/cargo/tempList.m';
	},

	carPos: function () {
		location.href = _contextPath_ + '/mobile/car/deliList.m';
	}
}
</script>

<header>
	<div class="title_area">
		<%--<a href="javascript:history.back()" class="layout_back" alt="이전으로"></a>--%>
		<h2>차량 창고 현황</h2>
	</div>
</header>
<div id="main">
	<div class="page_info h_170">
		<div class="m_dash left">
			<h2>총 차량수</h2>
			<div class="dash_data"><span>{{ view.totCarCnt }}<em>대</em></span></div>
		</div>
		<div class="m_dash right">
			<h2>총 창고수</h2>
			<div class="dash_data"><span>{{ view.totCargoCnt }}<em>개</em></span></div>
		</div>
		<table>
			<colgroup>
				<col width="20%"/>
				<col width="25%"/>
				<col width="*"/>
				<col width="25%"/>
			</colgroup>
			<tr>
				<th></th>
				<th>정상운행</th>
				<th>미운행<br><span>통신불량</span></th>
				<th class="error">이상온도</th>
			</tr>
			<tr>
				<th>차량</th>
				<td></td>
				<td></td>
				<td class="error"></td>
			</tr>
			<tr>
				<th>창고</th>
				<td></td>
				<td></td>
				<td class="error"></td>
			</tr>
		</table>
	</div>
	<div class="menu_group">
	<h2>업무선택</h2>
	<div class="menu_link agent"><button type="button" class="menu_link_btn car_srch" v-on:click="carTemp">차량온도</button></div>
	<div class="menu_link agent"><button type="button" class="menu_link_btn car_ondo" v-on:click="cargoTemp">창고온도</button></div>
	<div class="menu_link agent"><button type="button" class="menu_link_btn car_loc" v-on:click="carPos">납품차량 위치 조회</button></div>
	</div>
</div>