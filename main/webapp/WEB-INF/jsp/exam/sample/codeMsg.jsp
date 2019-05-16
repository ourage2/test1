<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>
<h2 class="content_title">공통코드/메시지</h2>

<table class="dtl_tbl">
	<colgroup>
		<col style="width:40%;" />
		<col style="width:60%;" />
	</colgroup>
	<tr>
		<th>공통코드 (EXIT_CODE - COMPLETED)</th>
		<td>
			<util:code grpCd="EXIT_CODE" cd="COMPLETED" />
		</td>
	</tr>
	<tr>
		<th>메시지 (8010)</th>
		<td>
			<util:msg cd="8010" />
		</td>
	</tr>
	<tr>
		<th>메시지 (8011)</th>
		<td>
			<util:msg cd="8501" param="정보" />
		</td>
	</tr>
	<tr>
		<th>메시지 (8026)</th>
		<td>
			<util:msg cd="8026" params="${fn:split('크기|10', '|')}" />
		</td>
	</tr>
	<tr>
		<th>공통코드 Loop (EXIT_CODE)</th>
		<td>
			<c:forEach items="${util:cdList('EXIT_CODE')}" var="row">
				${row.cd} - ${row.cdNm}<br />
			</c:forEach>
		</td>
	</tr>
</table>