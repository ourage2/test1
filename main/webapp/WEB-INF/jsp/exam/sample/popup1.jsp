<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>
<div class="popup-content" style="width:500px">
	<h1>팝업1</h1>
	<table class="dtl_tbl">
		<colgroup>
			<col style="width:15%;" />
			<col style="width:35%;" />
			<col style="width:15%;" />
			<col style="width:35%;" />
		</colgroup>
		<tr>
			<th>메뉴ID</th>
			<td></td>
			<th>메뉴명</th>
			<td></td>
		</tr>
		<tr>
			<th>메뉴상세</th>
			<td colspan="3"></td>
		</tr>
		<tr>
			<th>메뉴URL</th>
			<td colspan="3"></td>
		</tr>
		<tr>
			<th>메뉴순서</th>
			<td></td>
			<th>사용여부</th>
			<td></td>
		</tr>
	</table>
	
	<div class="btn_input_area">
		<span class="btn_pack large"><button type="button" class="popup-close">닫기</button></span>
	</div>
</div>