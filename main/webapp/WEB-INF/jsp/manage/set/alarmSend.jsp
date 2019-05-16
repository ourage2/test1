<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script>
var view1$;

jQuery(function($) {
	view1$ = $('#divView1');

	view1$.find('[name=template]').on('change', function() {
		var msgDesc = com.getMsgDesc($(this).val()).replaceAll('nn', '\n');
		view1$.find('[name=sendTitle]').val(com.getMsg($(this).val()));
		view1$.find('[name=sendTxt]').val(msgDesc || com.getMsg($(this).val())).keyup();
	});

	$('#btnAlarmSendNew').on('click', function() {user.alarmSend()}); //알림발송
	$('#btnPushFind').on('click', function() {user.pushFindPop();}); //알림수신자찾기 팝업
	$('#btnPushAllDel').on('click', function() {com.pushAllDel(view1$);}); //알림수신자 전체삭제

	user.init();
});

var user = {

	init: function() {
		com.setCombo('select', view1$, 'template', null, com.getMsgList('I'), '-- 선택 ----');
	},

	alarmSend: function() {
		var data = com.set(view1$);
		if (data.sendTitle == '') {
			onm.alert('제목을 입력해주세요.');
			return false;
		}
		if (data.sendTxt == '') {
			onm.alert('내용을 입력해주세요.');
			return false;
		}
		if (data.pushIds == '') {
			onm.alert('발송대상을 선택해주세요.');
			return false;
		}

		if (!confirm('알림메시지를 발송시겠습니까?')) {
			return false;
		}

		onm.ajax({
			url: _contextPath_ + '/manage/set/alarmSend.json',
			data: data,
			success: function(res) {
				if (res.result != '0') {
					onm.alert('알림발송을 요청하였습니다.');
				} else {
					onm.alert('알림발송 요청에 실패했습니다.');
				}
			},
			error: function() {
			}
		});
	},

	//알림수신자찾기 팝업
	pushFindPop: function() {
		onm.ajaxModal({
			url: _contextPath_ + '/manage/basis/userFindList.pop',
			dialogOptions: { title: '알림수신자찾기'},
			data: {
				multiYn : 'Y', //사용자 멀티선택팝업
				pushIds : view1$.find('[name=pushIds]').val()
			},
			callback:function(selIds, list) {
				var orgIds = view1$.find('[name=pushIds]').val().split(',');
				var orgNms = view1$.find('[name=pushNms]').val().split(',');
				var selNms = [];
				for (var idx = 0; idx < list.length; idx++) {
					selNms.push(list[idx].userNm);
				}

				if (orgIds[0]) {
					selIds = selIds.concat(orgIds);
					selNms = selNms.concat(orgNms);
				}
				if (selIds.length > 99) {
					onm.alert('99명 이상 등록할 수 없습니다.');
					return false;
				}

				view1$.find('[name=pushIds]').val(selIds.join(','));
				view1$.find('[name=pushNms]').val(selNms.join(','));
				com.pushShow(list);
			}
		});
	}

}
</script>

<div id="divView1">
	<div class="caption-pnl">
		<h2>알림발송</h2>
		<span class="buttonset fr">
			<button type="button" class="btn_list_rd" id="btnAlarmSendNew"><span class="ico_apply"></span>발송</button>
		</span>
	</div>

	<input type="hidden" name="pushIds" />
	<input type="hidden" name="pushNms" />

	<table class="dtl_tbl">
		<colgroup>
			<col width="15%">
			<col width="35%">
			<col width="15%">
			<col width="35%">
		</colgroup>
		<tr>
			<th>템플릿</th>
			<td colspan="3"><select name="template"></select></td>
		</tr>
		<tr>
			<th>제목</th>
			<td colspan="3"><input type="text" name="sendTitle" maxlength="100" read placeholder="제목을 입력해 주세요."/></td>
		</tr>
		<tr>
			<th>내용</th>
			<td colspan="3"><textarea name="sendTxt" maxlength="2000" cols="160" rows="6" placeholder="내용을 입력해 주세요."></textarea></td>
		</tr>
		<tr>
			<th>발송대상</th>
			<td colspan="3">
				<div id="divAllim" style="max-height:150px;overflow-y:auto;">
					<button type="button" id="btnPushAllDel" class="btn_list_sm"><span class="ico_del"></span>전체삭제</button>
					<button type="button" id="btnPushFind" class="btn_list_sm"><span class="ico_srch"></span>찾기</button>
					<span id="pushSpan" style="line-height:2.0;"></span>
				</div>
			</td>
		</tr>
	</table>

	<div style="height:300px"></div>
</div>
