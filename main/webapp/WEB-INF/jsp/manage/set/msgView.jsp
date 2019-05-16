<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>
<h1>메시지 상세정보</h1>
<table class="dtl_tbl">
	<colgroup>
		<col style="width:15%;" />
		<col style="width:35%;" />
		<col style="width:15%;" />
		<col style="width:35%;" />
	</colgroup>
	<tr>
		<th>메시지ID</th>
		<td>${view.msgId}</td>
		<th>메시지내용</th>
		<td><c:out value="${view.msgNm}" /></td>
	</tr>
	<tr>
		<th>메시지유형</th>
		<td>${view.msgTypeNm}</td>
		<th>메시지상세</th>
		<td><c:out value="${view.msgDesc}" /></td>
	</tr>
</table>
