<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script>
var grid1$;
var srch$;
var view1$;
var view2$;
var edit1$
var edit2$

jQuery(function($) {
	srch$ = com.toBox($('#divSrch'));

	grid1$ = $('#grid1').jqGrid({
		url: _contextPath_ + '/manage/set/qnaList.json',
		pager:'#grid1Pg',
		height: 480,
		postData: com.getData(srch$),
		colNames: ['순번', '질문', '질문자', '질문작성일시', '답변여부', '답변자', '답변작성일시', 'seq', 'ansYn', 'queId', 'anaYn'],
		colModel: [
			{name:'rnum', index:'rnum', width:3, align:'right', sortable:false},
			{name:'queTitle', index:'QUE_TITLE', width: 30},
			{name:'queNm', index:'QUE_ID', width: 7},
			{name:'queModDt', index:'QUE_MOD_DT', width: 10, formatter:'datetime'},
			{name:'ansYnNm', index:'ANS_YN', width: 7, align:'center'},
			{name:'ansNm', index:'ANS_ID', width: 7},
			{name:'ansModDt', index:'ANS_MOD_DT', width: 10, formatter:'datetime'},
			{name:'seq', index:'SEQ', hidden: true, key: true},
			{name:'ansYn', index:'ANS_YN', hidden: true},
			{name:'queId', index:'QUE_ID', hidden: true},
			{name:'ansId', index:'ANS_ID', hidden: true}
		],

		onSelectRow: function(rowId) {
			//질문자나 답변권한이 있는 사용자만 상세화면을 볼수 있게 한다 -> 답변권한은 수정권한으로 대체
			var menuAuth = com.___filterData(sUserData.roleList, {text: 'menuCd', value:'qnaList'})[0][0];
			if (grid1$.getRowData(rowId).queId != sUserData.userId && menuAuth.updateYn != 'Y') {
				onm.alert('권한이 없습니다.');
				return false;
			}
			user.qnaViewPop();
		}
	});

	//새글
	$('#btnMainNew').on('click', function() {
		grid1$.resetSelection();
		user.qnaViewPop();
	});

	$('select[name=pageUnit]').on('change', function () {
		$('#srchBtn').trigger('click');
	});

	//검색
	$('#srchBtn').on('click', function() {
		grid1$.setGridParam({postData: com.getData(srch$, $('select[name=pageUnit]').val()), page: 1}).trigger('reloadGrid');
	});

	user.mainInit();
});

var user = {
	//메인페이지 초기화
	mainInit : function() {
		//검색조건 기본값 설정
// 		srch$.find('[name=srchStrDt]').val(onm.getBeforeMonth());
// 		srch$.find('[name=srchEndDt]').val(onm.todayFmt());
		onm.setDatePeriod(srch$.find('[name=srchStrDt]'), srch$.find('[name=srchEndDt]'), '12m');
		com.setCombo('select', $('#main'), 'pageUnit', '${paramBox.pageUnit}', com.getCdList('PAGE_UNIT'), null, 60);

		$('#srchBtn').trigger('click');
	},

	//에디터 로딩
	editorLoad : function() {
		edit1$ = $('#view1Cont');
		edit1$.summernote({
			lang: 'ko-KR',
			placeholder: '내용을 써주세요...',
			disable: true,
			height: 370,
			width: 1050,
			toolbar: [
						['style', ['bold', 'italic', 'underline', 'clear']],
						['font', ['strikethrough', 'superscript', 'subscript']],
						['fontsize', ['fontsize']],
						['color', ['color']],
						['para', ['ul', 'ol', 'paragraph']],
						['height', ['height']]
					],
			callbacks: {
				onImageUpload: function(files, editor, welEditable) {
					//파일정보 - fileDiv : QNA(1:1문의), fileKey : 게시판 번호(SEQ) [grpCd : FILE_DIV]
					com.fileUpload(view1$, edit1$, files, {'fileDiv' : 'QNA', 'fileKey' : view1$.get('seq')});
				}
			}
		});

		edit2$ = $('#view2Cont');
		edit2$.summernote({
			lang: 'ko-KR',
			placeholder: '내용을 입력해주세요...',
			disable: true,
			height: 360,
			width: 1050,
			toolbar: [
						['style', ['bold', 'italic', 'underline', 'clear']],
						['font', ['strikethrough', 'superscript', 'subscript']],
						['fontsize', ['fontsize']],
						['color', ['color']],
						['para', ['ul', 'ol', 'paragraph']],
						['height', ['height']]
					],
			callbacks: {
				onImageUpload: function(files, editor, welEditable) {
					//파일정보 - fileDiv : QNA(1:1문의), fileKey : 게시판 번호(SEQ) [grpCd : FILE_DIV]
					com.fileUpload(view2$, edit2$, files, {'fileDiv' : 'QNA', 'fileKey' : view2$.get('seq')});
				}
			}
		});
	},

	//1:1문의 상세팝업
	qnaViewPop : function() {
		onm.ajaxModal({
			url: _contextPath_ + '/manage/set/qnaView.pop',
			dialogOptions: { title: '1:1문의'}
		});
	},

	//1:1문의질문 신규
	qnaInit: function() {
		var seq = view1$.find('[name=seq]').val();
		var flag = com.getFlag(view1$);

		com.init(view1$, false);
		com.setFlag(view1$, 'C');

// 		view1$.find('[name=showYn][value=Y]').prop('checked', true);
		view1$.find('[name=queNm]').val(sUserNm);
		edit1$.summernote('enable')
		edit1$.summernote('code', '');
		$('.fileLi').remove();

		if (flag == 'C' && seq != '') {
			view1$.find('[name=seq]').val(seq);
		} else {
			com.getSeq(view1$, 'seq', 'TB_QNA', 'SEQ');
		}

		user.fnAfterLoad();
	},

	//1:1문의(질문및 답변) 상세
	qnaView : function(rowId) {
		view1$.show();

		onm.ajax({
			url: _contextPath_ + '/manage/set/qnaView.json',
			data: grid1$.getRowData(rowId),
			success: function(res) {
				com.setVal(view1$, res.view);
				view1$.find('[name=ansCont]').html(res.view.ansCont);

				com.setVal(view2$, res.view);
				view2$.find('[name=ansNm]').val(sUserNm);
				view2$.find('[name=ansTitle]').val('[답변] ' + view1$.find('[name=queTitle]').val());
				view2$.find('[name=queCont]').html(res.view.queCont);

				edit1$.summernote('enable')
				edit1$.summernote('code', res.view.queCont);
				edit2$.summernote('enable')
				edit2$.summernote('code', res.view.ansCont);
				com.fileList(view1$, res.fileList);
				com.fileList(view2$, res.fileList);
				view2$.find('.delBtn').hide();
				if (res.view.ansYn != 'Y') {
					$('.ansTr').hide();
				} else {
					$('#btnView1New').hide();
				}

				user.fnAfterLoad();
			}
		});
	},

	//1:1문의질문 저장
	qnaSave: function(action) {
		//editer에 입력/수정된 값을 cont(textarea)에 삽입한다
		if (action != 'D') {
			view1$.find('[name=queCont]').val(edit1$.summernote('code'));
			view1$.find('[name=editNm]').val('queCont');
		}

		onm.ajax({
			url: _contextPath_ + '/manage/set/qnaSave.json',
			beforeSend: function() {
				if (!com.beforeChk(view1$, action)) { return false; } //저장전 flag 체크
				if (action != 'D') {if(!user.valid(view1$)) { return false; }} //입력값유효성 체크
				if (action != 'D') {if(!user.bizValid(view1$)) { return false; }} //업무유효성 체크
			},
			data: com.set(view1$, action, 'Y'),
			success: function(res) {
// 				com.afterSave(res, view1$, action, true);

				$('#btnView1Close').trigger('click');
				$('#srchBtn').trigger('click');
			}
		});
	},

	//1:1문의답변 신규
	qnaAnsInit: function() {
// 		var seq = view2$.find('[name=seq]').val();
// 		var flag = com.getFlag(view2$);

// 		com.init(view2$, false);
// 		com.setFlag(view2$, 'C');

		view2$.find('[name=ansTitle]').val('[답변] ' + view1$.find('[name=queTitle]').val());
		edit2$.summernote('enable')
		edit2$.summernote('code', '');
// 		$('.fileLi').remove();

// 		if (flag == 'C' && seq != '') {
// 			view1$.find('[name=seq]').val(seq);
// 		} else {
// 			com.getSeq(view2$, 'seq', 'TB_QNA', 'SEQ');
// 		}
	},

	//1:1문의답변 저장
	qnaAnsSave: function(action) {
		//editer에 입력/수정된 값을 cont(textarea)에 삽입한다
		if (action != 'D') {
			view2$.find('[name=ansCont]').val(edit2$.summernote('code'));
			view2$.find('[name=editNm]').val('ansCont');
		}

		onm.ajax({
			url: _contextPath_ + '/manage/set/qnaAnsSave.json',
			beforeSend: function() {
				if (!com.beforeChk(view2$, action)) { return false; } //저장전 flag 체크
				if (action != 'D') {if(!user.valid(view2$)) { return false; }} //입력값유효성 체크
				if (action != 'D') {if(!user.bizValid(view2$)) { return false; }} //업무유효성 체크
			},
			data: com.set(view2$, action, 'Y'),
			success: function(res) {
// 				com.afterSave(res, view2$, action, true);

				$('#btnView2Close').trigger('click');
				$('#srchBtn').trigger('click');
			}
		});
	},

	fnAfterLoad: function() {
		view1$.find('button').css('font-size', '12px');
		view1$.find('th').css('font-size', '13px');
		view1$.find('td').css('font-size', '12px');

		view2$.find('button').css('font-size', '12px');
		view2$.find('th').css('font-size', '13px');
		view2$.find('td').css('font-size', '12px');

		authCheck();
		var menuAuth = com.___filterData(sUserData.roleList, {text: 'menuCd', value:'qnaList'})[0][0];
		if (menuAuth.updateYn == 'N') {
			view1$.find('#btnView1Ans').hide();
		}
		if (menuAuth.insertYn == 'N' && menuAuth.updateYn == 'N') {
			view1$.find('#view1Cont').summernote('disable');
			com.disable(view1$, true);
			view1$.find('#btnView1Close').attr('disabled', false);

			view2$.find('#view2Cont').summernote('disable');
			com.disable(view2$, true);
			view2$.find('#btnView2Close').attr('disabled', false);
		}
	},

	//입력값 유효성 체크
	valid: function(area) {
		var isValid = com.validChk(area); //필수, 길이, 형식등의 유효성 체크
// 		if (!isValid) {} //화면별 유효성 체크
		return isValid;
	},

	//업무유효성 체크
	bizValid: function(area) {
		if (area.attr('id') == 'divView1') {
			if (view1$.find('[name=queCont]').val().length > editMaxCnt) {
				onm.alert('본문이 허용글자수를 초과했습니다.');
				return false;
			}
			return true;
		}

		if (area.attr('id') == 'divView2') {
			if (view2$.find('[name=ansCont]').val().length > editMaxCnt) {
				onm.alert('본문이 허용글자수를 초과했습니다.');
				return false;
			}
			return true;
		}
	}
}
</script>

<header>
	<div id="divSrch">
		<div class="loc_info"><span>1:1문의관리</span><span>환경설정</span><span>Home</span></div>
		<h2 class="content_title"><span>1:1문의관리</span></h2>
		<div class="srch_box">
			<table>
				<colgroup>
					<col width="10%">
					<col width="30%">
					<col width="10%">
					<col width="30%">
					<col width="*">
				</colgroup>
				<tr>
					<th>작성일<span class="required"></span></th>
					<td>
						<input type="text" name="srchStrDt" class="calendar" mindateid="srchEndDt" /> ~ <input type="text" name="srchEndDt" class="calendar" maxdateid="srchStrDt" />
					</td>
					<th>검색어</th>
					<td>
						<select name="srchMethod">
							<option value="title" selected="selected">제목</option>
							<option value="cont">본문</option>
							<option value="multi">제목 + 본문</option>
						</select>
						<input type="text" name="srchWord" maxlength="30" class="enterSrch" />
					</td>
					<td>
						<div class="srch_btn">
							<button type="button" id="srchBtn" class="btn_srch "><span class="ico_srch"></span>검색</button>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</div>
</header>

<div id="main">
	<div class="colgroup-wrap">
		<div class="caption-pnl">
			<span class="buttonset fr">
				<select name="pageUnit"></select>
				<button type="button" class="btn_list" id="btnMainNew"><span class="ico_edit"></span>문의하기</button>
			</span>
		</div>
		<table id="grid1"></table>
		<div id="grid1Pg"></div>
	</div>
</div>