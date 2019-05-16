<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script>
var vMain;
var srch$;

jQuery(function($) {
	srch$ = com.toBox($('#divSrch'));

	vMain = new Vue({
		el: '#main',
		methods: {
			inoutView: function(e, i) {
				var item = this.list[i];
				var q = $.param({
					shipNo: item.shipNo
				});
				location.href = _contextPath_ + '/mobile/deli/inoutView.m?' + q;
			},
			moreList: function () {
				vMain.incPg(srch$);
				user.inoutList();
			}
		}
	});

	//검색
	$('#srchBtn').on('click', function() {
		if (!com.validChk(srch$)) return false;
		vMain.resetPg(srch$);
		user.inoutList();
	});

	user.mainInit();
});

var user = {
	//메인페이지 초기화
	mainInit : function() {
	},

	inoutList: function () {
		onm.ajax({
			url: _contextPath_ + '/mobile/deli/inoutList.json',
			data: vMain.srch,
			success: function (res) {
				vMain.setPaginatedList(res);
			}
		});
	}
}
</script>
<header>
<div class="title_area">
	<a href="javascript:history.back()" class="layout_back" alt="이전으로"></a>
	<h2>업무 선택</h2>
</div>
<div id="divSrch">
	<%--<button class="m_srch_toggle on">조회설정<span class="sr_off"><span class="blind">열기</span></span><span class="sr_on"><span class="blind">닫기</span></span></button>--%>
	<div class="srch_box" style="display: block">
		<table>
			<colgroup>
				<col width="25%">
				<col width="75%">
			</colgroup>
			<tr>
				<th class="state-required">차량번호</th>
				<td colspan="2">
					<input type="text" name="srchCarNo" maxlength="30" class="enterSrch w40"/>
				</td>
			</tr>
			<tr>
				<th>완료여부</th>
				<td>
					<select name="srchReleaseYn" class="w40">
						<option value="N">미완료</option>
						<option value="Y">완료</option>
					</select>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<button type="button" id="srchBtn" class="btn_srch m_srch "><span class="ico_srch"></span>검색</button>
				</td>
			</tr>
		</table>
	</div>
</div>
</header>
<div id="main">

	<ul class="grid_list">
		<template v-if="list.length > 0">
			<template v-for="(item, i) in list">
				<li v-on:click="inoutView($event, i)">
					<dl class="book_info f_left w70">
						<dt><a><span class="agent_name">선적번호</span> <span class="agent_no">{{ item.shipNo }}</span></a></dt>
						<dd><spn>납품요청일:<em> {{ item.shipReqDate }}</em></spn></dd>
					</dl>
					<div  class="m_right_btn">
						<span> {{ item.releaseYn === 'Y' ? '완료' : '미완료' }} </span>
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