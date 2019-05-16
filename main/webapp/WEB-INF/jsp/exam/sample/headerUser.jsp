<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>
<script>
jQuery(function($) {
	var custNm$ = $('#custNm');
	var suid$ = $('#suid');
	var custAge$ = $('#custAge');

	$('#btnUserView').on('click', function() {
		onm.setCustomerInfo(custNm$.val(), suid$.val(), custAge$.val());
	});
	$('#btnUserClear').on('click', function() {
		onm.clearCustomerInfo();
	});
});
</script>
<h2 class=content_title>Header User</h2>
<input type="text" name="custNm" id="custNm" value="홍길동" />
<input type="text" name="suid" id="suid" value="SID00000001" />
<input type="text" name="custAge" id="custAge" value="19801201" />

<span class="btn_pack large"><input type="button" value="사용자 설정" id="btnUserView" /></span>
<span class="btn_pack large"><input type="button" value="사용자 초기화" id="btnUserClear" /></span>

<div>
<table>
	<tr>
		<th colspan="2"> * page Control Button 주요 업무를 컨트롤 하는 버튼 업무 흐르므의 최종 위치 하단 우측 위치</th>
	</tr>
	<tr>
		<th> commit</th>
		<td>
			<button class="btn_page_rd"><span class="ico_apply"></span>확인</button>
			<button class="btn_page_rd"><span class="ico_apply"></span>등록</button>
			<button class="btn_page_rd"><span class="ico_apply"></span>선택</button>
			<button class="btn_page_rd"><span class="ico_save"></span>저장</button>
		</td>
	</tr>
	<tr>
		<th> General</th>
		<td>
			<button class="btn_page"><span class="ico_add"></span>추가</button>
			<button class="btn_page"><span class="ico_del"></span>삭제</button>
			<button class="btn_page"><span class="ico_edit"></span>수정</button>
			<button class="btn_page"><span class="ico_cancle"></span>취소</button>
			<button class="btn_page"><span class="ico_cancle"></span>닫기</button>
			<button class="btn_page"><span class="ico_list"></span>목록</button>
			<button class="btn_page"><span class="ico_print"></span>인쇄</button>
			<button class="btn_page"><span class="ico_initial"></span>초기화</button>
			<button class="btn_page btn_disabled"><span class="ico_initial"></span>선택안됨</button>
		</td>
	</tr>
</table>

<table>
	<tr>
		<th colspan="2"> * Grid Control Button 상단 배ㅣ 그리드 컨트롤</th>
	</tr>
	<tr>
		<th> commit</th>
		<td>
			<button class="btn_list_rd"><span class="ico_add"></span>신규계획 등록</button>
			<button class="btn_list_rd"><span class="ico_save"></span>저장</button>
			<button class="btn_list_rd"><span class="ico_apply"></span>선택</button>
		</td>
	</tr>
	<tr>
		<th> General</th>
		<td>
			<button class="btn_list"><span class="ico_xls"></span>엑셀</button>
			<button class="btn_list"><span class="ico_upload"></span>엑셀업로드</button>
			<button class="btn_list"><span class="ico_setting"></span>설정</button>
			<button class="btn_list"><span class="ico_bul"></span>기타버튼</button>
			<button class="btn_list btn_disabled"><span class="ico_bul"></span>선택안됨</button>
		</td>
	</tr>
	<tr>
		<th> info </th>
		<td>

		</td>
	</tr>
</table>
<div class="srch_box">
			<table>
				<colgroup>
					<col width="8%">
					<col width="12%">
					<col width="10%">
					<col width="12%">
					<col width="10%">
					<col width="12%">
					<col width="10%">
					<col width="12%">
					<col width="*">
				</colgroup>
				<tbody><tr>
					<th>센터</th>
					<td>
						<select name="srchCenterCd" class="chosen" multiple="" data-placeholder="전체" style="display: none;">
						<option value="1400">경산공장</option>
						</select>
					</td>
					<th>사용여부</th>
					<td>
						<select name="srchUseYn">
							<option value="">전체</option>
						</select>
					</td>
					<th>단말장착</th>
					<td>
						<select name="srchDevYn" style="width:100px">
							<option value="">전체</option>
						</select>
					</td>
					<th>관제여부</th>
					<td>
						<select name="srchDtgYn" style="width:100px">
							<option value="">전체</option>
						</select>
					</td>
					<td rowspan="3">
						<div class="srch_btn">
							<button type="button" id="xlsBtn" class="btn line"><span class="ico_xls"></span>엑셀다운로드</button>
							<button type="button" id="srchBtn" class="btn "><span class="ico_srch"></span>검색</button>
						</div>
					</td>
				</tr>

			</tbody></table>
		</div>
		<div >
			<div class="caption-pnl">
				<h2><span class="x-icon"></span><span class="x-label">창고 상세정보</span></h2>
				<span class="buttonset fr">
					<button type="button" class="btn_list_rd" id="btnView1New"><span class="ico_add"></span>신규</button>
					<button type="button" class="btn_list_rd" id="btnView1Save"><span class="ico_save"></span>저장</button>
					<button type="button" class="btn_list_rd" id="btnView1Del"><span class="ico_del"></span>삭제</button>
				</span>
			</div>
			<table class="dtl_tbl">
				<colgroup>
					<col width="15%">
					<col width="35%">
					<col width="15%">
					<col width="35%">
				</colgroup>
				<tbody>
					<tr>
						<th class="state-required">창고ID</th>
						<td><input type="text" name="cargoId" maxlength="10" read="" noinput="" disabled="disabled"></td>
						<th class="state-required">창고명</th>
						<td><input type="text" name="cargoNm" maxlength="50" disabled="disabled"></td>
					</tr>

				</tbody>
			</table>
		</div>
</div>