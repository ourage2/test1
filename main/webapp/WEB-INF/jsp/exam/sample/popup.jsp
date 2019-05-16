<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>
<script>
jQuery(function($) {
	var menuTitle = $('#menuTitle');
	var menuTmp = '<li><a href="#href#">#label#</a> <div class="ui-icon ui-icon-arrowrefresh-1-s sel" title="새로고침">새로고침</div><div class="ui-icon ui-icon-close sel" title="화면닫기">화면닫기</div></li>';
	var menuCnt = 2;
	var menu$ = $('#menuTab').tabs();
	menu$.find('.ui-tabs-nav').sortable({
		axis: 'x',
		stop: function() {
			menu$.tabs('refresh');
		}
	});

	$('#btnAlert1').on('click', function() {
		onm.alert('정상적으로 처리되었습니다.');
	});

	$('#btnAlert2').on('click', function() {
		onm.alert('정상적으로\n 처리되었습니다.', function() {
			onm.alert('확인버튼 클릭 후 실행');
		});
	});

	$('#btnAlert3').on('click', function() {
		onm.alert({
			title:'확인',
			msg:'정상적으로 처리되었습니다.',
			callback:function() {
				onm.alert('확인버튼 클릭 후 실행');
			}
		});
	});

	$('#btnConfirm1').on('click', function() {
		onm.confirm('처리하시겠습니까?', function() {
			onm.alert('확인');
		});
	});

	$('#btnConfirm2').on('click', function() {
		onm.confirm('처리하시겠습니까?', function() {
			onm.alert('확인');
		}, function() {
			onm.alert('취소');
		});
	});

	$('#btnConfirm3').on('click', function() {
		onm.confirm({
			title:'확인',
			msg:'처리하시겠습니까?',
			confirm:function() {
				onm.alert('확인');
			},
			cancel:function() {
				onm.alert('취소');
			}
		});
	});

	$('#btnModal').on('click', function() {
		onm.ajaxModal({
			url: '<c:url value="/exam/sample/popup1.pop" />'
		});
	});

	$('#btnPopup1').on('click', function() {
		onm.ajaxPopup({
			url: '<c:url value="/exam/sample/popup1.pop" />',
			dialogOptions:{
				close:function() {
					alert('close');
				}
			}
		});
	});

	$('#btnPopup2').on('click', function() {
		onm.ajaxPopup({
			url:'<c:url value="/exam/sample/popup2.pop" />',
			callback:function(name, age) {
				onm.alert('이름 : ' + name + ', 나이 : ' + age);
			}
		});
	});

	$('#btnTab').on('click', function() {
		if ($('div.ui-icon-close').length >= 10) {
			onm.alert('메뉴허용 갯수를 초과 했습니다.\n기존 메뉴를 닫고 선택해 주세요.');
			return;
		}
		var menuNm = menuTitle.val() || 'Menu ' + menuCnt;
		var id = 'tab-' + menuCnt;
		var li = $(menuTmp.replace(/#href#/g, '#' + id).replace(/#label#/g, menuNm));
// 		var tabContentHtml = '탭의 내용입니다' || 'Tab ' + tabCounter + ' content.';
// 		$.ajax({
// 			url : '<c:url value="/exam/sample/menuList.ifm" />',
// 			data : {},
// 			success : function(data) {
				menu$.find('.ui-tabs-nav').append(li);
// 				menu$.append('<div id="' + id + '"><p>' + data + '</p></div>');
 				menu$.append('<div id="' + id + '"><p>' + '<iframe style="width:100%;height:600px;scrolling:auto;" src="' + '<c:url value="/exam/sample/menuList.ifm" />' + '" ></iframe>' + '</p></div>');
 				menu$.tabs('refresh');
 				menu$.tabs('option', 'active', $('div.ui-icon-close').length - 1);
				menuCnt++;
// 			}
// 		});

	});

	menu$.on('click', 'div.ui-icon-arrowrefresh-1-s', function() {
		var menuId = $(this).parent().find('a').attr('href');
		var menuFrame = $(menuId + ' iframe');
		var menuUrl = menuFrame.attr('src');
		menuFrame.attr('src', menuUrl);
	});

	menu$.on('click', 'div.ui-icon-close', function() {
		if ($('div.ui-icon-close').length > 1) {
			var panelId = $(this).closest('li').remove().attr('aria-controls');
			$('#' + panelId).remove();
			menu$.tabs('refresh');
		} else {
			onm.alert('마지막 메뉴입니다.');
		}
	});

});
</script>
<h2 class=content_title>팝업</h2>

<span class="btn_pack large"><button type="button" id="btnAlert1">Alert</button></span>
<span class="btn_pack large"><button type="button" id="btnAlert2">Alert Callback</button></span>
<span class="btn_pack large"><button type="button" id="btnAlert3">Alert Title</button></span>
<br />
<span class="btn_pack large"><button type="button" id="btnConfirm1">Confirm</button></span>
<span class="btn_pack large"><button type="button" id="btnConfirm2">Confirm Callback</button></span>
<span class="btn_pack large"><button type="button" id="btnConfirm3">Confirm Title</button></span>
<br />
<span class="btn_pack large"><button type="button" id="btnModal">Modal Popup</button></span>
<br />
<span class="btn_pack large"><button type="button" id="btnPopup1">Normal Popup1</button></span>
<span class="btn_pack large"><button type="button" id="btnPopup2">Normal Popup2</button></span>
<br />
<span class="btn_pack large"><button type="button" id="btnTab">add tab</button></span>

<br />
<input type="hidden" name="menuTitle" value="탭 제목" />

<div id="menuTab">
	<ul>
		<li><a href="#tab-1">메뉴 1</a><div class="ui-icon ui-icon-arrowrefresh-1-s sel" title="새로고침">새로고침</div><div class="ui-icon ui-icon-close sel" title="화면닫기">화면닫기</div></li>
	</ul>
	<div id="tab-1">내용1</div>
</div>
