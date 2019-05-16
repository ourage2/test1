<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<div class="popup-content">

	<table class="dtl_tbl">
		<colgroup>
			<col style="width: 98px">
			<col style="width: 100px">
			<col style="width: 98px">
			<col style="width: auto">
		</colgroup>
		<tr>
			<th colspan="2">대리점 출도착 위반 사유</th>
			<th colspan="2">온도 위반 사유</th>
		</tr>
		<tr>
			<td colspan="2"><div id="divArr"></div></td>
			<td colspan="2"><div id="divCarTemp"></div></td>
		</tr>
		<tr>
			<th>세부<br>내역</th>
			<td colspan="3"><textarea name="vioDesc" cols="40" rows="3" maxlength="100"></textarea></td>
		</tr>
	</table>
	
	<div class="colgroup-wrap acenter mT10">
		<span class="buttonset">
			<button type="button" class="btn_page_rd" id="btnPopSave"><span class="ico_save"></span>저장</button>
			<button type="button" class="btn_page_rd" id="btnPopCancel"><span class="ico_cancle"></span>취소</button>
		</span>
	</div>
</div>
