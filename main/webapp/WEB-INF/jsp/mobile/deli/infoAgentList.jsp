<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script>
var vMain;

jQuery(function($) {
	vMain = new Vue({
		el: '#main',
		methods: {
			//공장출발대기
			centerRdyYes: function (e) {
				user.centerRdyYes(this.view);
			},
			//공장출발대기취소
			centerRdyNo: function() {

				if (this.view.ioSaveCnt > 0) {
					onm.alert('크레이트 정보를 입력 후에는 공장 출발 대기 취소를 할 수 없습니다');
					return false;
				}

				if (this.disabledBtnCenterRdyNo()) {
					onm.alert('공장 출발 대기 취소를 할 수 없습니다');
					return false;
				}

				user.centerRdyNo(this.view);
			},

			//납품완료
			deliYes: function () {
				user.deliYes(this.view);
			},
			//납품완료취소
			deliNo: function () {
				user.deliNo(this.view);
			},

			ioSaveRdyRoute: function(e, i) {
				if (this.disabledBtnIoSaveRdyYes(i)) {
					this.infoView(e, i);
				} else {
					this.ioSaveRdyYes(e, i);
				}
			},

			//도착
			ioSaveRdyYes: function (e, i) {
				user.ioSaveRdyYes(this.list[i]);
			},
			infoView: function(e, i) {
				var item = this.list[i];

				if (item.ioSaveRdyYn === 'N') {
					e.preventDefault();
					return false;
				}

				user.infoView(item);
			},

			//공장출발대기 버튼
			disabledBtnCenterRdyYes: function () {
				return this.view.arrCnt > 0;
			},

			//공장출발대기취소 버튼
			disabledBtnCenterRdyNo: function () {
				var view = this.view;
				return view.arrCnt > 0 || view.refShipNoYn === 'Y' || view.deliYn === 'Y';
			},

			//납품완료 버튼
			disabledBtnDeliYes: function () {
				var view = this.view;
				return !(view.deliYn === 'N' && view.arrCnt > 0 && view.arrExpectCnt > 1 && view.ioSaveAfterArrYn === 'Y');
			},

			//납품완료취소 버튼
			showBtnDeliNo: function () {
				var view = this.view;
				return view.deliYn === 'Y' && view.deliyDiv === '2' && view.centerRtnYn === 'N';
			},

			//도착보고 버튼
			disabledBtnIoSaveRdyYes: function (i) {
				var item = this.list[i];
				return !((this.view.centerRdyYn === 'Y' || item.arrYn === 'Y') && item.ioSaveRdyYn === 'N');
			},

			btnIoSaveRdySuffixText: function (i) {
				var item = this.list[i];
				return item.ioSaveRdyYn === 'Y' ? '완료' : '보고';
			},

			btnIoSaveRdyStyle: function(i) {
				var item = this.list[i];
				return item.ioSaveRdyYn === 'Y' ? 'background: #c8c8c8; color: #000000;' : '';
			},

			arrDtText: function (i) {
				var item = this.list[i];
				var txt = item.arrExpectDt;
				if (item.arrTm) {
					txt += ' (' + item.arrTm + ')';
				}
				return txt;
			}
		}
	});

	user.mainInit();
});

var user = {
	//메인페이지 초기화
	mainInit : function() {
		user.infoAgentList();
		setInterval(function () {
			user.infoAgentList();
		}, 1000 * 60);
	},

	infoAgentList: function () {
		onm.ajax({
			url: _contextPath_ + '/mobile/deli/infoAgentList.json',
			data: vMain.queryParam,
			success: function (res) {
				vMain.setData(res.list, 'list');
				vMain.setData(res.view, 'view');
			}
		});
	},

	centerRdySave: function(data) {
		onm.ajax({
			url: _contextPath_ + '/mobile/deli/centerRdySave.json',
			data: data,
			success: function (res) {
				if (res.result > 0) {
					user.infoAgentList();
				} else {
					onm.alert(res.resMsg);
				}
			}
		});
	},

	// 공장출발대기
	centerRdyYes: function(item) {

		var msg;
		var data = {
			shipNo: item.shipNo,
			carId: item.carId,
			rdyYn: 'Y'
		};

		if (item.expectLinkShipNo) {
			msg = '이미 선택한 공장 출발 대기가 있습니다.\n[선적번호 - @shipNo@]과(와)\n[선적번호 - @linkShipNo@]를 연계배송 하시겠습니까?';
			msg = msg.replace(/@shipNo@/g, item.shipNo).replace(/@linkShipNo@/g, item.expectLinkShipNo);
			onm.confirm2(msg,
				function () {
					data.linkShipYn = 'Y';
					user.centerRdySave(data);
				});
		} else {
			msg = '[선적번호 - ' + item.shipNo + '] 공장 출발 대기를 선택 하시겠습니까?';
			onm.confirm2(msg, function () {
				user.centerRdySave(data);
			});
		}
	},

	// 공장출발대기취소
	centerRdyNo: function(item) {
		var msg = '[선적번호 - ' + item.shipNo + '] 공장 출발 대기를 취소 하시겠습니까?';
		var fnYes = function () {
			var data = {
				shipNo: item.shipNo,
				carId: item.carId,
				rdyYn: 'N'
			};

			user.centerRdySave(data);
		};
		onm.confirm2(msg, fnYes);
	},

	deliSave: function(data) {
		onm.ajax({
			url: _contextPath_ + '/mobile/deli/deliSave.json',
			data: data,
			success: function (res) {
				if (res.result > 0) {
					user.infoAgentList();
				} else {
					onm.alert(res.resMsg);
				}
			}
		});
	},

	//납품완료
	deliYes: function (item) {
		var msg = '';
		msg += '[선적번호 - ' + item.shipNo + '] 전체 배송이 완료 되었습니까?<br>예를 선택 후에는 납품완료 취소를 할 수 없습니다.';
		var fnYes = function () {
			var data = {
				shipNo: item.shipNo,
				carId: item.carId,
				deliYn: 'Y'
			};

			user.deliSave(data);
		};
		onm.confirm2(msg, fnYes);
	},

	//납품완료취소
	deliNo: function (item) {
		var msg = '[선적번호 - ' + item.shipNo + '] 납품 완료 취소 하시겠습니까?';
		var fnYes = function () {
			var data = {
				shipNo: item.shipNo,
				carId: item.carId,
				deliYn: 'N'
			};

			user.deliSave(data);
		};
		onm.confirm2(msg, fnYes);
	},

	// 도착
	ioSaveRdyYes: function (item) {
		var msg = '';
		if (item.arrYn !== 'Y') {
			msg += '대리점 미도착 상태입니다.\n';
		}

		msg += '[' + item.agentNm + ']에 도착 보고를 하시겠습니까?';
		var fnYes = function () {
			var data = {
				shipNo: item.shipNo,
				agentCd: item.agentCd,
				deliNo: item.deliNo,
				carId: item.carId,
				ioSaveRdyYn: 'Y'
			};

			onm.ajax({
				url: _contextPath_ + '/mobile/deli/ioSaveRdySave.json',
				data: data,
				success: function (res) {
					if (res.result > 0) {
						user.infoView(item);
					} else {
						onm.alert(res.resMsg);
					}
				}
			});
		};
		onm.confirm2(msg, fnYes);
	},

	infoView: function (item) {
		var q = $.param({
			shipNo: item.shipNo,
			agentCd: item.agentCd,
			deliNo: item.deliNo,
			carId: item.carId
		});
		location.href = _contextPath_ + '/mobile/deli/infoView.m?' + q;
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
	<div class="btnarea">
		<table>
			<colgroup>
				<col width="50%">
				<col width="*">
			</colgroup>
			<tr>
				<td>
					<template v-if="view.centerRdyYn === 'N'">
						<button type="button" class="btn_list_rd m_btn2" v-on:click="centerRdyYes">공장출발<br>대기</button>
					</template>
					<template v-else-if="view.centerRdyYn === 'Y'">
						<button type="button" class="btn_list_rd m_btn2 cancle_btn" v-on:click="centerRdyNo">공장출발<br>대기취소</button>
						<%--<template v-if="view.ioSaveCnt > 0">
							<button type="button" class="btn_list_rd m_btn2 cancle_btn state-disabled" v-on:click="centerRdyNoNotWork">공장출발<br>대기취소</button>
						</template>
						<template v-else>
							<button type="button" class="btn_list_rd m_btn2 cancle_btn" v-on:click="centerRdyNo">공장출발<br>대기취소</button>
						</template>--%>
					</template>
				</td>
				<td class="t_right">
					<button type="button" class="btn_list_rd m_right" v-bind:disabled="disabledBtnDeliYes()" v-on:click="deliYes">납품<br>완료</button>
					<%--<template v-else-if="showBtnDeliNo()">
						<button type="button" class="btn_list_rd m_btn" v-on:click="deliNo">납품완료취소</button>
					</template>--%>
				</td>
			</tr>
		</table>
	</div>

	<table class="m_table agenttb_no">
		<colgroup>
			<col width="25%">
			<col width="75%">
		</colgroup>
		<tr>
			<th>선적번호</th>
			<td>{{ queryParam.shipNo }}</td>
		</tr>
	</table>

	<ul class="grid_list line">
		<template v-if="list.length > 0">
			<template v-for="(item, i) in list">
				<li>
					<dl class="book_info f_left" v-on:click="infoView($event, i)" style="padding-left: 0;">
						<dt><span class="agent_name">{{ item.agentNm }}</span></dt>
						<dd><span class="agent_no" style="padding-left: 0;">{{ item.deliNo }}</span><span >납품예정시간: <em>{{ arrDtText(i) }}</em></span></dd>
					</dl>
					<div class="m_right_btn">
						<template v-if="view.centerRdyYn === 'Y' || item.arrYn === 'Y'">
							<button type="button" class="btn_list_rd m_right f_right" v-on:click="ioSaveRdyRoute($event, i)" v-bind:style="btnIoSaveRdyStyle(i)">도착<br>{{ btnIoSaveRdySuffixText(i) }}</button>
						</template>
					</div>
				</li>
			</template>
		</template>
		<template v-else>
			<li><div class="t_center">{{ emptyList }}</div></li>
		</template>
	</ul>

</div>