<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>
<script>
jQuery(function($) {
	$('#btnCarNowList').on('click', function() { user.carNowList(); });
	$('#btnCarPathList').on('click', function() { user.carPathList(); });

	$('.popup-content button').css({
		'height': '165px'
	});
});
</script>

<div class="popup-content" style="width: 300px; height: 260px;">
	<div class="menu_group pop">
		<div class="menu_link" style="margin: 0 !important;">
			<button id="btnCarNowList" type="button" class="menu_link_btn car_loc">실시간<br/>차량위치</button>
		</div>
		<div class="menu_link" style="margin: 0 !important;">
			<button id="btnCarPathList" type="button" class="menu_link_btn car_srch">운행경로</button>
		</div>
	</div>
</div>