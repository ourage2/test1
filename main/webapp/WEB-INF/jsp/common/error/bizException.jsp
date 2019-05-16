<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<%@ page import="com.cvo.web.common.constants.CmnConst"%>
<%@ page import="com.cvo.web.common.util.StringUtil"%>
<%@ page import="java.io.*" %>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>
<%
String msgId = (String)request.getAttribute(CmnConst.RES_CODE);
if(StringUtil.isEmpty(msgId)) {
	msgId = "Server Error";
}
String msg = (String)request.getAttribute(CmnConst.RES_MSG);
if(StringUtil.isEmpty(msg)) {
	msg = "Server Error";
}
if(StringUtil.isEmpty(msg)) {
	msg = exception.getMessage();
}

request.setAttribute("msgId", msgId);
request.setAttribute("msg", msg);
%>

<script>
jQuery(function($) {
	if (window.frameElement && window.frameElement.nodeName == 'IFRAME') {
		$('#layout_header').hide();
	}
// 	var url = location.href;
// 	var urls = url.substring(url.lastIndexOf('/') + 1, url.lastIndexOf('?')).split('.');
// 	if (urls[1] == 'm') {
// 		$('#layout_header').hide();
// 		$('.layout_bg').hide();
// 		$('head').append('<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width" />');
// 	}

	if ('<%=msgId%>' == 'F401') {
		fnLogin();
	} else {
		$('.error_container').show();
	}
});

function fnLogin() {
// 	console.log(window.location.href);

	if (window.location.href.indexOf('/mobile') > -1) {
		if (typeof(mCVO) !== 'undefined') {
			mCVO.msgLogOut('Y');
			return false;
		} else {
			window.location.href = _contextPath_ + '/mobile/mmain/mlogin.m';
			return false;
		}
	} else {
		cvo.goUrl('/main/login.do');
		return false;
	}
}

</script>


<div class="error_container mT100" style="height:300px;display:none">
	<table class="error_table">
		<colgroup>
			<col style="width:20%;" />
			<col style="width:80%;" />
		</colgroup>
		<tr>
			<th>Error Code</th>
			<td>${msgId}</td>
		</tr>
		<tr>
			<th>Error Message</th>
			<td>${msg}</td>
		</tr>
	</table>

	<c:if test="${empty sessionScope[cmnConst.sesUserId]}">
		<span class="buttonset fc mT20">
			<button type="button" class="btn_list_rd" onclick="fnLogin()">로그인 페이지로</button>
		</span>
	</c:if>
</div>