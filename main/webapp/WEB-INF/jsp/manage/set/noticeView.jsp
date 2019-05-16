<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/bootstrap.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/js/summernote/summernote.css" />

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap.js"></script>
<%-- <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/summernote/exif.js"></script> --%>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/summernote/summernote.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/summernote/lang/summernote-ko-KR.js"></script>

<script>

jQuery(function($) {
	view1$ = com.toBox($('#divView1'));

	$('#btnView1New').on('click', function() {user.noticeInit();}); //공지사항 신규
	$('#btnView1Save').on('click', function() {user.noticeSave(com.getFlag(view1$));}); //공지사항 저장
	$('#btnView1Del').on('click', function() {user.noticeSave('D');}); //공지사항 삭제
	$('#btnView1Add').on('click', function() {com.fileAdd(view1$);}); //파일추가

	//첨부파일
	$('#uploadFile').on('change', function() {
		//파일정보 - fileDiv : NOTICE(공지사항), fileKey : 게시판 번호(SEQ) [grpCd : FILE_DIV]
		com.fileUpload(view1$, edit$, this.files, {'fileDiv' : 'NOTICE', 'fileKey' : view1$.get('seq')});
	});


	user.editorLoad(); //에디터 로딩
	if(grid1$.getGridParam('selrow')) {
		user.noticeView(grid1$.getGridParam('selrow'));
	} else {
		user.noticeInit();
		$('#btnView1Del').hide();
	}
});
</script>

<div class="popup-content" style="width:1200px;">
	<div class="colgroup-wrap">
		<div id="divView1">
			<div class="caption-pnl">
				<h2>상세내용</h2>
				<span class="buttonset fr">
<!-- 					<button type="button" class="btn_list_rd" id="btnView1New"><span class="ico_add"></span>신규</button> -->
					<button type="button" class="btn_list_rd" id="btnView1Save"><span class="ico_save"></span>저장</button>
					<button type="button" class="btn_list_rd" id="btnView1Del"><span class="ico_del"></span>삭제</button>
					<button type="button" class="btn_list" id="btnView1Add"><span class="ico_upload"></span>파일추가</button>
					<button type="button" class="btn_list popup-close" id="btnView1Close"><span class="ico_cancle"></span>닫기</button>

				</span>
			</div>

			<input type="file" id="uploadFile" name="uploadFile" class="hidden" multiple />
			<input type="hidden" name="editNm" />
			<table class="dtl_tbl">
				<colgroup>
					<col width="8%">
					<col width="17%">
					<col width="8%">
					<col width="17%">
					<col width="8%">
					<col width="17%">
					<col width="8%">
					<col width="17%">
				</colgroup>
				<tbody>
					<tr>
						<th>ID</th>
						<td><input type="text" name="seq" maxlength="10" read noinput /></td>
						<th class="state-required">표시여부</th>
						<td>
							<label><input type="radio" name="showYn" value="Y"> 표시</label>&nbsp;&nbsp;&nbsp;
							<label><input type="radio" name="showYn" value="N"> 미표시</label>
						</td>
						<th>작성자</th>
						<td><input type="text" name="insertNm" maxlength="20" read noinput /></td>
						<th>작성일시</th>
						<td><input type="text" name="insertDt" maxlength="20" read noinput datetime /></td>
					</tr>
					<tr>
						<th class="state-required">제목</th>
						<td colspan="7"><input type="text" name="title" maxlength="100" style="width:50%"/></td>
					</tr>
					<tr>
						<th>첨부<br />파일</th>
						<td colspan="7">
							<div id="fileTable" style="height:70px;overflow-y:auto;">
							</div>
						</td>
					</tr>
					<tr>
						<th>본문</th>
						<td colspan="7">
							<div id="view1Cont" class="summernote"></div>
							<textarea name="cont" rows="20" cols="150" style="display:none;"></textarea>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
</div>