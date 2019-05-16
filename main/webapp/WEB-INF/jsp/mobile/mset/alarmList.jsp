<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script>
var vMain;
var srch$;

jQuery(function($) {
	srch$ = com.toBox($('#divSrch'));

	vMain = new Vue({
		el: '#main',
		updated: function () {
			$('pre img').each(function() {
				if ($(this).width() > 380) {
					$(this).width(380);
				}
			});
		},
		methods: {
			moreList: function () {
				vMain.incPg(srch$);
				user.alarmList();
			},
			alarmView: function(e, i, item) { //알림내역 조회 상세
// 				$('.book_detailview').eq(i).toggle({duration : 300});
			},
			sortChange: function(e) {
 				this.list.reverse();
			}
		},
	});

	//검색
	$('#srchBtn').on('click', function() {
		if (!com.validChk(srch$)) return false;
		vMain.resetPg(srch$);
		user.alarmList();
	});

	//더보기
// 	$('#btnMore').on('click', function () {
// 		vMain.incPg(srch$);
// 		user.alarmList();
// 	});

	user.mainInit();
});

var user = {
	//메인페이지 초기화
	mainInit : function() {
		//검색조건 기본값 설정
		onm.setDatePeriod(srch$.find('[name=srchStrDt]'), srch$.find('[name=srchEndDt]'), '1m')

		$('#srchBtn').trigger('click');

	},

	alarmList: function () {
		onm.ajax({
			url: _contextPath_ + '/mobile/mset/alarmList.json',
			data: vMain.srch,
			success: function (res) {
				vMain.setPaginatedList(res);
			}
		});
	},

}
</script>
<style>
pre{
	width:100%;
	overflow:hidden;
	word-break:break-all;
	word-break:break-word;
	line-height:21px;
	white-space: pre-wrap;	   /* CSS 3 */
	white-space: -moz-pre-wrap;  /* Mozilla, since 1999 */
	white-space: -pre-wrap;	  /* Opera 4-6 */
	white-space: -o-pre-wrap;	/* Opera 7 */
	word-wrap: break-word;	   /* Internet Explorer 5.5+ */
}
</style>

<header>
	<div class="title_area">
		<a href="javascript:history.back()" class="layout_back" alt="이전으로"></a>
		<h2>알림내역 조회</h2>
	</div>

	<div id="divSrch">
<!-- 		<button class="m_srch_toggle on">조회설정<span class="sr_off"><span class="blind">열기</span></span><span class="sr_on"><span class="blind">닫기</span></span></button> -->
		<!--조회설정  class="m_srch_toggle on" 조건 나타남   div class="srch_box" display:block 처리-->
		<!--조회설정  class="m_srch_toggle off" 조건 숨김  div class="srch_box"  display:none 처리-->
		<div class="srch_box" style="display: block">
			<table>
				<colgroup>
					<col width="25%">
					<col width="75%">
				</colgroup>
				<tr>
					<th>발송일<span class="required"></span></th>
					<td colspan="2">
						<input type="text" name="srchStrDt" class="calendar" mindateid="srchEndDt" /> ~ <input type="text" name="srchEndDt" class="calendar" maxdateid="srchStrDt" />
					</td>
				</tr>
				<tr>
					<th>검색어</th>
					<td>
						<select name="srchMethod" class="w40">
							<option value="title" selected="selected">제목</option>
							<option value="cont">본문</option>
							<option value="multi">제목 + 본문</option>
						</select>
						<input type="text" name="srchWord" maxlength="30" class="enterSrch w40" />
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<button type="button" id="srchBtn" class="btn_srch m_srch"><span class="ico_srch"></span>검색</button>
					</td>
				</tr>
			</table>
		</div>
	</div>
</header>

<div id="main">
	<div class="sort_area">
		<select name="sortOrder" v-model="srch.sortOrder" v-on:change="sortChange($event)">
			<template v-for="item in sortOrder">
				<option v-bind:value="item.value">{{ item.text }}</option>
			</template>
		</select>
	</div>
	<ul class="grid_list">
		<template v-if="list.length > 0">
			<template v-for="(item, i) in list">
				<li>
					<dl class="book_info" v-on:click="alarmView($event, i, item)">
						<dt class="book_tit">{{ item.sendTitle }}</dt>
						<dd class="book_writer">
							<span>{{ item.sendNm }}[{{ item.sendId }}]</span>
							<span>{{ getYmd(item.sendDt) }}</span>
							<span>{{ getHms(item.sendDt) }}</span>
						</dd>
					</dl>
					<div class="book_detailview">
						<pre v-html="item.sendTxt"></pre>
					</div>
				</li>
			</template>
			<p class="paging_more">
				<button type="button" v-bind:disabled="hasMore()" id="btnMore">{{ btnMoreTxt() }}</button>
			</p>
		</template>
		<template v-else>
			<li><dl class="book_info"><dt class="book_tit">{{ emptyList }}</dt><dd></dd></dl></li>
		</template>
	</ul>

	<p class="paging_more">
		<template v-if="list.length > 0">
			<button type="button" v-bind:disabled="hasMore()"  v-on:click="moreList()" id="btnMore">{{ btnMoreTxt() }}</button>
		</template>
	</p>

</div>

