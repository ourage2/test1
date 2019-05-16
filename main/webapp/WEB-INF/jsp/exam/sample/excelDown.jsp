<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>
<script>
jQuery(function($) {
});
</script>
<h2 class=content_title>엑셀다운로드</h2>

<table class="dtl_tbl">
	<colgroup>
		<col style="width:40%;" />
		<col style="width:60%;" />
	</colgroup>
	<tr>
		<th>공통코드</th>
		<td>
			<span class="btn_pack large"><a href="<c:url value="/exam/sample/codeExcelDown.xls" />">엑셀다운로드</a></span>
		</td>
	</tr>
	<%-- 
	<tr>
		<th>API로그</th>
		<td>
			<span class="btn_pack large"><a href="<c:url value="/exam/sample/apiLogExcelDown.xls" />">엑셀다운로드</a></span>
		</td>
	</tr>
	--%>
</table>