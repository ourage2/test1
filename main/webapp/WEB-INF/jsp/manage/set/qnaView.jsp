<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/bootstrap.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/js/summernote/summernote.css" />

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/summernote/summernote.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/summernote/lang/summernote-ko-KR.js"></script>

<script>

jQuery(function($) {
	view1$ = com.toBox($('#divView1'));
	view2$ = com.toBox($('#divView2'));

	$('#btnView1New').on('click', function() {user.qnaInit();}); //1:1문의질문 신규
	$('#btnView1Save').on('click', function() {user.qnaSave(com.getFlag(view1$));}); //1:1문의질문 저장
	$('#btnView1Del').on('click', function() {user.qnaSave('D');}); //1:1문의질문 삭제
	$('#btnView1Add').on('click', function() {com.fileAdd(view1$);}); //파일추가
	$('#btnView1Ans').on('click', function() {view1$.hide();view2$.show();}); //답변
	//답변이 달렸을 경우 질문글을 수정 못하게 한다(필요없음)

	$('#btnView2New').on('click', function() {user.qnaAnsInit();}); //1:1문의답변 신규
	$('#btnView2Save').on('click', function() {user.qnaAnsSave(com.getFlag(view2$));}); //1:1문의답변 저장
	$('#btnView2Del').on('click', function() {user.qnaAnsSave('D');}); //1:1문의답변 삭제

	//첨부파일
	$('#uploadFile').on('change', function() {
		//파일정보 - fileDiv : QNA(1:1문의), fileKey : 게시판 번호(SEQ) [grpCd : FILE_DIV]
		com.fileUpload(view1$, edit1$, this.files, {'fileDiv' : 'QNA', 'fileKey' : view1$.get('seq')});
	});

	user.editorLoad(); //에디터 로딩
	if(grid1$.getGridParam('selrow')) {
		user.qnaView(grid1$.getGridParam('selrow'));
	} else {
		user.qnaInit();
		view1$.show();
		$('.ansTr').hide();
		$('#btnView1Del').hide();
		$('#btnView1Ans').hide();
	}
});
</script>

<div class="popup-content" style="width:1200px;">
	<div class="colgroup-wrap mT20">
		<div id="divView1" style="display:none">
			<div class="caption-pnl">
				<h2>문의하기</h2>
				<span class="buttonset fr">
<!-- 					<button type="button" class="btn_list_rd" id="btnView1New"><span class="ico_add"></span>신규</button> -->
					<button type="button" class="btn_list_rd" id="btnView1Save"><span class="ico_save"></span>저장</button>
					<button type="button" class="btn_list_rd" id="btnView1Del"><span class="ico_del"></span>삭제</button>
					<button type="button" class="btn_list" id="btnView1Add"><span class="ico_upload"></span>파일추가</button>
					<button type="button" class="btn_list" id="btnView1Ans"><span class="ico_edit"></span>답변</button>
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
						<th>질문자</th>
						<td><input type="text" name="queNm" maxlength="20" read noinput /></td>
						<th>질문일시</th>
						<td><input type="text" name="queModDt" maxlength="20" read noinput datetime /></td>
					</tr>
					<tr>
						<th class="state-required">제목</th>
						<td colspan="7"><input type="text" name="queTitle" maxlength="100" style="width:50%"/></td>
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
							<textarea name="queCont" rows="20" cols="150" style="display:none;"></textarea>
						</td>
					</tr>

					<tr class="ansTr"><td colspan="6">&nbsp;</td></tr>
					<tr class="ansTr">
						<th>답변자</th>
						<td><input type="text" name="ansNm" maxlength="20" read noinput /></td>
						<th>답변일시</th>
						<td colspan="3"><input type="text" name="ansModDt" maxlength="20" read noinput datetime /></td>
					</tr>
					<tr class="ansTr">
						<th>제목</th>
						<td colspan="5"><input type="text" name="ansTitle" maxlength="100" style="width:50%" read noinput/></td>
					</tr>
					<tr class="ansTr">
						<th>본문</th>
						<td colspan="5">
							<p name="ansCont"></p>
						</td>
					</tr>
				</tbody>
			</table>
		</div>

		<div id="divView2" style="display:none">
			<div class="caption-pnl">
				<h2>답변하기</h2>
				<span class="buttonset fr">
					<button type="button" class="btn_list_rd" id="btnView2New"><span class="ico_add"></span>신규</button>
					<button type="button" class="btn_list_rd" id="btnView2Save"><span class="ico_save"></span>저장</button>
					<button type="button" class="btn_list_rd" id="btnView2Del"><span class="ico_del"></span>삭제</button>
					<button type="button" class="btn_list popup-close" id="btnView2Close"><span class="ico_cancle"></span>닫기</button>
				</span>
			</div>

			<input type="file" id="uploadFile" name="uploadFile" class="hidden" multiple />
			<input type="hidden" name="editNm" />
			<table class="dtl_tbl">
				<colgroup>
					<col width="10%">
					<col width="23%">
					<col width="10%">
					<col width="23%">
					<col width="10%">
					<col width="23%">
				</colgroup>
				<tbody>
				<tbody>
					<tr>
						<th>ID</th>
						<td><input type="text" name="seq" maxlength="10" read noinput /></td>
						<th>질문자</th>
						<td><input type="text" name="queNm" maxlength="20" read noinput /></td>
						<th>질문일시</th>
						<td><input type="text" name="queModDt" maxlength="20" read noinput datetime /></td>
					</tr>
					<tr>
						<th class="state-required">제목</th>
						<td colspan="7"><input type="text" name="queTitle" maxlength="100" style="width:50%" read noinput/></td>
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
						<td colspan="5">
							<p name="queCont"></p>
						</td>
					</tr>
					<tr><td colspan="6">&nbsp;</td></tr>
					<tr>
						<th>답변자</th>
						<td><input type="text" name="ansNm" maxlength="20" read noinput /></td>
						<th>답변일시</th>
						<td colspan="3"><input type="text" name="ansModDt" maxlength="20" read noinput datetime /></td>
					</tr>
					<tr>
						<th class="state-required">제목</th>
						<td colspan="5"><input type="text" name="ansTitle" maxlength="100" style="width:50%"/></td>
					</tr>
					<tr>
						<th>본문</th>
						<td colspan="5">
							<div id="view2Cont" class="summernote"></div>
							<textarea name="ansCont" rows="20" cols="150" style="display:none;"></textarea>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
</div>