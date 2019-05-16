<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>
<script>
(function($) {
	$('#btnSend').on('click', function() {
		var name = $('#name').val();
		var age = $('#age').val();
		$('#popup2').data('callback').apply(this, [name, age]);
	});
}(jQuery));
</script>
<div class="popup-content" id="popup2" style="width:800px">
	<form>
	<h1>팝업2</h1>
		<input type="text" name="name" id="name" value="홍길동" />
		<input type="text" name="age" id="age" value="30" />
		
		<div class="btn_input_area">
			<span class="btn_pack large"><button type="button" id="btnSend">데이터전송</button></span>
			<span class="btn_pack large"><button type="button" class="popup-close">닫기</button></span>
		</div>
	</form>
</div>
