<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<div class="popup-content">
	<table class="dtl_tbl">
		<colgroup>
			<col style="width: 25%">
			<col style="width: 25%">
			<col style="width: 25%">
			<col style="width: 25%">
		</colgroup>
		<tr>
			<th colspan="4">온도 위반 사유</th>
		</tr>
		<tr>
			<td colspan="4"><div id="divCarTemp"></div></td>
		</tr>
		<tr>
			<th>세부내역</th>
			<td colspan="3"><textarea name="vioDesc" cols="20" rows="3" maxlength="100"></textarea></td>
		</tr>
	</table>
	
	<div class="colgroup-wrap acenter mT10">
		<span class="buttonset">
			<button type="button" class="btn_page_rd" id="btnPopSave"><span class="ico_save"></span>저장</button>
			<button type="button" class="btn_page_rd" id="btnPopCancel"><span class="ico_cancle"></span>취소</button>
		</span>
	</div>
</div>
