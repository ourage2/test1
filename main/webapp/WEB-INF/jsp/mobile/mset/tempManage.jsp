<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>
<script>
jQuery(function($) {
	$('#btnCarTempNowList').on('click', function() { user.carTempNowList(); });
	$('#btnCarTempList').on('click', function() { user.carTempList(); });

	$('.popup-content button').css({
		'height': '165px'
	});
});
</script>

<div class="popup-content" style="width: 300px; height: 260px;">

	<div class="menu_group pop">
		<div class="menu_link" style="margin: 0 !important;">
			<button id="btnCarTempNowList" type="button" class="menu_link_btn car_ondo">실시간<br/>차량온도</button>
		</div>
		<div class="menu_link" style="margin: 0 !important;">
			<button id="btnCarTempList" type="button" class="menu_link_btn ico_ondogye">온도내역</button>
		</div>
	</div>
</div>