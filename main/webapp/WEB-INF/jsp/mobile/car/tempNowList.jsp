<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script>

var vMain;
var srch$;

$(function () {
	$.widget("custom.carpicker", {

		visible: false,

		options: {
			centerCd: null,
			agentCd: null,
			carList: null,
			placeholder: '차량번호 또는 운전자',
			open: null,
			close: null,
			reset: null
		},

		_create: function () {

			var outerWidth = this.element.outerWidth();

			this.topDiv = $('<div>').css({display: 'inline-block'});
			this.wrapDiv = $('<div>').hide();
			this.valDiv = $('<div class="data-list-box">').text('선택하세요');

			this.element.after(this.topDiv);
			this.topDiv.append(this.wrapDiv);
			this.topDiv.append(this.valDiv);

			this.element.appendTo(this.wrapDiv);

			this.listDiv = $('<div class="data-list-wrap">').css({
			}).width(outerWidth - 20).hide();
			this.searchInput = $('<input>', {type: 'search', placeholder: this.options.placeholder}).width('100%');
			this.ul = $('<ul>').css({height: '150px', 'overflow-y': 'scroll'});

			this.listDiv.append(this.searchInput);
			this.listDiv.append(this.ul);

			// this.element.after(this.listDiv);
			this.topDiv.after(this.listDiv);

			this._on(this.searchInput, {
				input: 'filterCar'
			});

			this._on(this.ul, {
				click: 'chooseCar'
			});

			var that = this;
			// this._on(this.element, {
			this._on(this.valDiv, {
				click: function () {
					that.open();
				}
			});

			this._on(this.element, {
				click: function () {
					that.open();
				}
			});

			this._refresh();
		},
		_refresh: function () {
			var that = this;
			if (that.ul.children().length === 0) {
				$.each(this.options.carList, function (index, item) {
					that.ul.append($('<li>').data(item).text(item.carId + ' | ' + item.drvNm));
				});
			} else {
				that.searchInput.triggerHandler('input');
			}
		},
		_destroy: function () {
			this.listDiv.remove();
			$(document).off('click.custom.carpicker' + this.eventNamespace);
		},

		_setOptions: function () {
			this._superApply(arguments);
			this._refresh();
		},

		_setOption: function (key, value) {
			this._super(key, value);
		},

		filterCar: function(event) {
			var that = this;
			var srchVal = $(event.target).val();
			var toggle;

			this.ul.find('li').each(function (index, item) {
				var data = $(item).data();
				if (srchVal === '') {
					toggle = data.centerCd === that.options.centerCd;
				} else {
					toggle = data.centerCd === that.options.centerCd && (data.carId.indexOf(srchVal) > -1 || data.drvNm.indexOf(srchVal) > -1);
				}
				$(item).toggle(toggle);
			})
		},

		chooseCar: function (event) {
			var data = $(event.target).data();
			this.element.val(data.carId);
			this.valDiv.text($(event.target).text());
			this.close();
			// this.searchInput.val('');
			// this.searchInput.triggerHandler('input')
		},

		open: function () {
			if (!this.visible) {
				this.visible = true;
				this.listDiv.show();

				var that = this;
				$(document).on('click.custom.carpicker' + this.eventNamespace, function (event) {
					// if ($(event.target).closest(that.element).length === 0 && $(event.target).closest(that.listDiv).length === 0) {
					if ($(event.target).closest(that.topDiv).length === 0 && $(event.target).closest(that.listDiv).length === 0) {
						that.close();
					}
				});

				var carId = this.element.val();

				$.each(this.options.carList, function (index, item) {
					if (carId && item.carId === carId) {
						var offsetTop = that.ul.find('li').eq(index).prop('offsetTop');
						that.ul.prop('scrollTop', offsetTop);
						return false;
					}
				});

				// this.searchInput.val(carId);
				this.searchInput.focus();

				if ($.isFunction(this.options.open)) {
					this.options.open.apply(this.element);
				}
			}
		},

		close: function () {
			if (this.visible) {
				this.visible = false;
				this.listDiv.hide();

				$(document).off('click.custom.carpicker' + this.eventNamespace);
			}
			// this._super();
		},

		reset: function () {
			this.valDiv.text('선택하세요');
			this.searchInput.val('');
			this.element.val('');
		}
	});

	$('input[name=srchWord]').carpicker({
		open: function () {
			this.carpicker('option', 'centerCd', srch$.find('[name=srchCenterCd]').val());
		}
	});

	onm.ajax({
		url: _contextPath_ + '/cmn/objList.json',
		data: {'queryId': 'carPickerCarList'},
		success: function (res) {
			$('input[name=srchWord]').carpicker('option', 'carList', res.list);
		}
	});
});

jQuery(function($) {

	srch$ = com.toBox($('#divSrch'));

	vMain = new Vue({
		el: '#main'
	});

	srch$.find('select[name=srchCenterCd]').on('change', function () {
		$('input[name=srchWord]').carpicker('reset');
	});

	//검색
	$('#srchBtn').on('click', function() {
		if (!com.validChk(srch$)) return false;
		user.tempNowList();
	});

	user.mainInit();
});

var user = {
	//메인페이지 초기화
	mainInit: function () {
		com.setCombo('select', srch$, 'srchCenterCd', sUserData.centerCd, com.sAuthCenterList());

		if (sUserData.mAuthCd === '3') {
			var srchWord$ = srch$.find('input[name=srchWord]');
			srchWord$.prop('disabled', true).val(sUserData.userId);
			$('#srchBtn').triggerHandler('click');
		}
	},

	tempNowList: function () {
		onm.ajax({
			url: _contextPath_ + '/mobile/car/tempNowList.json',
			data: com.getData(srch$),
			success: function (res) {
				vMain.setData(res.list, 'list');
			}
		});
	}
}
</script>

<header>
	<div class="title_area">
		<a href="javascript:history.back()" class="layout_back" alt="이전으로"></a>
		<h2>실시간 차량 온도</h2>
	</div>

	<div id="divSrch">
		<%--<button class="m_srch_toggle on">조회설정<span class="sr_off"><span class="blind">열기</span></span><span class="sr_on"><span class="blind">닫기</span></span></button>--%>
		<div class="srch_box" style="display: block">
			<table>
				<colgroup>
					<col style="width: 25%;">
					<col style="width: 75%;">
				</colgroup>
				<tr>
					<th>센터</th>
					<td>
						<select name="srchCenterCd"></select>
					</td>
				</tr>
				<tr>
					<th >차량<span class="state-required"></span></th>
					<td>
						<%--<select name="srchMethod" class="w40">
							<option value="carNo" selected="selected">차량번호</option>
							<option value="drvNm">운전자명</option>
						</select>--%>
						<input type="text" name="srchWord" maxlength="30" class="enterSrch w80" placeholder="차량번호 또는 운전자" />
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

<div id="main" class="main_wrap">

	<table class="m_list">
		<colgroup>
			<col style="width: 12%">
			<col style="width: 25%">
			<col style="width: 35%">
			<col style="width: auto;">
		</colgroup>
		<tr>
			<th>No</th>
			<th>차량번호</th>
			<th>시간</th>
			<th>온도</th>
		</tr>
		<template v-if="list.length > 0">
			<template v-for="item in list">
				<tr>
					<td>{{ item.rnum }}</td>
					<td>{{ item.carNo }}</td>
					<td>{{ formatTimeToDate(item.devDt) }}</td>
					<td>{{ item.ch }}</td>
				</tr>
			</template>
		</template>
		<template v-else>
			<tr><td colspan="4">{{ emptyList }}</td></tr>
		</template>
	</table>
</div>