<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<%@ page import="com.cvo.web.common.constants.CmnConst"%>
<%@ page import="com.cvo.web.common.util.StringUtil"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>
<%
String msgId = (String)request.getAttribute(CmnConst.RES_CODE);
if(StringUtil.isEmpty(msgId)) {
	msgId = "404 Page Not Found";
}
String msg = (String)request.getAttribute(CmnConst.RES_MSG);
if(StringUtil.isEmpty(msg)) {
	msg = "The page you requested was not found.";
}
request.setAttribute("msgId", msgId);
request.setAttribute("msg", msg);
%>

<script>
jQuery(function($) {
	if (window.frameElement && window.frameElement.nodeName == 'IFRAME') {
		$('#layout_header').hide();
	}
});
</script>

<div class="error_container mT100" style="height:300px">
	<table class="error_table">
		<colgroup>
			<col style="width:20%;" />
			<col style="width:80%;" />
		</colgroup>
		<tr>
			<th>Code</th>
			<td>${msgId}</td>
		</tr>
		<tr>
			<th>Message</th>
			<td>${msg}</td>
		</tr>
	</table>
<%-- 	<c:if test="${empty sessionScope[cmnConst.sesUserId]}"> --%>
<!-- 		<div class="acenter mT20"> -->
<%-- 			<span class="btn_pack large"><a href="<c:url value="/" />">메인페이지</a></span> --%>
<!-- 		</div> -->
<%-- 	</c:if> --%>
</div>