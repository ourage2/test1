<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>
<h1>메뉴상세정보</h1>
<table class="dtl_tbl">
	<colgroup>
		<col style="width:15%;" />
		<col style="width:35%;" />
		<col style="width:15%;" />
		<col style="width:35%;" />
	</colgroup>
	<tr>
		<th>메뉴ID</th>
		<td>${menuDetail.menuId}</td>
		<th>메뉴명</th>
		<td><c:out value="${menuDetail.menuNm}" /></td>
	</tr>
	<tr>
		<th>메뉴상세</th>
		<td colspan="3"><c:out value="${menuDetail.menuDesc}" /></td>
	</tr>
	<tr>
		<th>메뉴URL</th>
		<td colspan="3"><c:out value="${menuDetail.menuUrl}" /></td>
	</tr>
	<tr>
		<th>메뉴순서</th>
		<td>${menuDetail.menuOrd}</td>
		<th>사용여부</th>
		<td>${menuDetail.useYn}</td>
	</tr>
</table>
