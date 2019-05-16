<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>
<script>
jQuery(function($) {
	var date1$ = $('#date1');
	var datetime1$ = $('#datetime1');
	
	$('#btnFormatDate').on('click', function() {
		onm.alert(onm.formatDate(date1$.val()));
	});
	
	$('#btnFormatDatetime').on('click', function() {
		onm.alert(onm.formatTimeToDate(datetime1$.val()));
	});
});
</script>
<h2 class=content_title>Script Function</h2>
<input type="text" name="date1" id="date1" value="20151201" />
<span class="btn_pack large"><input type="button" value="날짜포맷" id="btnFormatDate" /></span>

<input type="text" name="datetime1" id="datetime1" value="1427696186720" />
<span class="btn_pack large"><input type="button" value="시간포맷" id="btnFormatDatetime" /></span>
