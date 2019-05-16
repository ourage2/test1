<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>
<c:set var="sessionHomeUrl" value="${sessionScope[cmnConst.sessionHomeUrl]}" />
<c:choose>
<%-- 	<c:when test="${not empty sessionScope[cmnConst.sessionUser] and not empty sessionHomeUrl}"> --%>
<%-- 		<c:redirect url="${sessionHomeUrl}" /> --%>
<%-- 	</c:when> --%>
	<c:when test="${not empty sessionScope[cmnConst.sesUserId] }">
		<c:redirect url="/main/index.do" />
	</c:when>
	<c:otherwise>
		<c:redirect url="/main/login.do" />
	</c:otherwise>
</c:choose>
