<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<div class="popup-content">
	<div class="caption-pnl hidden">
		<ul class="agent-status">
			<li><span class="ico-agent start">S</span><span class="reg-txt">출발지</span></li>
			<li><span class="ico-agent end">E</span><span class="reg-txt">도착지</span></li>
			<li><span class="ico-agent fixed"></span><span class="reg-txt">정시도착</span></li>
			<li><span class="ico-agent delay"></span><span class="reg-txt">지연도착</span></li>
		</ul>
	</div>
	<div id="chart1"></div>
</div>