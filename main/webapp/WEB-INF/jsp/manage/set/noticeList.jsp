<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<script>
var grid1$;
var srch$;
var view1$;
var edit$

jQuery(function($) {
	srch$ = com.toBox($('#divSrch'));

	grid1$ = $('#grid1').jqGrid({
		url: _contextPath_ + '/manage/set/noticeList.json',
		pager:'#grid1Pg',
		height: 480,
		postData: com.getData(srch$),
		colNames:['순번', '제목', '작성자', '작성일시', '표시여부', 'seq', 'showYn', 'insertId'],
		colModel:[
			{name:'rnum', index:'rnum', width:2, align:'right', sortable:false},
			{name:'title', index:'TITLE', width:20, align:'center'},
			{name:'insertNm', index:'INSERT_ID', width:7, align:'center', sortable:false},
			{name:'insertDt', index:'INSERT_DT', width:10, align:'left', formatter:'datetime'},
			{name:'showYnNm', index:'SHOW_YN', width:5, align:'left'},
			{name:'seq', index:'SEQ', hidden: true, key: true},
			{name:'showYn', index:'SHOW_YN', hidden: true},
			{name:'insertId', index:'INSERT_ID', hidden: true}
		],

		onSelectRow: function(rowId) {
			user.noticeViewPop();
		}
	});

	//새글
	$('#btnMainNew').on('click', function() {
		grid1$.resetSelection();
		user.noticeViewPop();
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

	//상세페이지 초기화
// 	viewInit : function() {
// 		com.init(view1$, true);
// 	},

	//에디터 로딩
	editorLoad : function() {
		edit$ = $('#view1Cont');
		$('.summernote').summernote({
			lang: 'ko-KR',
			placeholder: '내용을 입력해주세요...',
//	 		minHeight: null,
//	 		maxHeight: null,
// 			focus: true,
			disable: true,
			height: 360,
			width: 1050,
			toolbar: [
						// [groupName, [list of button]]
						['style', ['bold', 'italic', 'underline', 'clear']],
						['font', ['strikethrough', 'superscript', 'subscript']],
						['fontsize', ['fontsize']],
						['color', ['color']],
						['para', ['ul', 'ol', 'paragraph']],
						['height', ['height']]
					],
			callbacks: {
				onImageUpload: function(files, editor, welEditable) {
// 					$('#view1Cont').summernote('insertImage', '${pageContext.request.contextPath}/resources/image/cmn/logo.png', files[0].name);

					//파일정보 - fileDiv : NOTICE(공지사항), fileKey : 게시판 번호(SEQ) [grpCd : FILE_DIV]
					com.fileUpload(view1$, edit$, files, {'fileDiv' : 'NOTICE', 'fileKey' : view1$.get('seq')});
				}
			}
		});

//	 	$('#view1Cont').summernote('code', '시작페이지');
// 		$('#view1Cont').summernote('code', view1$.find('[name=cont]').val());
//	 	$('#view1Cont').summernote('destroy');
//	 	$('#view1Cont').summernote('insertText', '내용삽입');
//	 	$('#view1Cont').summernote('undo');
//	 	$('#view1Cont').summernote('redo');
// 	 	$('#view1Cont').summernote('disable');
//	 	$('#view1Cont').summernote('enable');
//	 	$('#view1Cont').summernote('insertImage', url, filename);
	},

	//공지사항 상세팝업
	noticeViewPop : function() {
		onm.ajaxModal({
			url: _contextPath_ + '/manage/set/noticeView.pop',
			dialogOptions: { title: '공지사항 상세'}
		});
	},

	//공지사항 신규
	noticeInit: function() {
		var seq = view1$.find('[name=seq]').val();
		var flag = com.getFlag(view1$);

		com.init(view1$, false);
		com.setFlag(view1$, 'C');

		view1$.find('[name=showYn][value=Y]').prop('checked', true);
		view1$.find('[name=insertNm]').val(sUserNm);
		edit$.summernote('enable')
		edit$.summernote('code', '');
		$('.fileLi').remove();

		if (flag == 'C' && seq != '') {
			view1$.find('[name=seq]').val(seq);
		} else {
			com.getSeq(view1$, 'seq', 'TB_NOTICE', 'SEQ');
		}
	},

	//공지사항 상세
	noticeView : function(rowId) {
		onm.ajax({
			url: _contextPath_ + '/manage/set/noticeView.json',
			data: grid1$.getRowData(rowId),
			success: function(res) {
				com.setVal(view1$, res.view);
				edit$.summernote('enable')
				edit$.summernote('code', res.view.cont);
				com.fileList(view1$, res.fileList);

				view1$.find('button').css('font-size', '12px');
				view1$.find('th').css('font-size', '13px');
				view1$.find('td').css('font-size', '12px');
				view1$.find('td').eq(1).css('padding-top', '6px');
				authCheck();
				var menuAuth = com.___filterData(sUserData.roleList, {text: 'menuCd', value:'noticeList'})[0][0];
				if (menuAuth.insertYn == 'N' && menuAuth.updateYn == 'N') {
					view1$.find('#view1Cont').summernote('disable');
					com.disable(view1$, true);
					view1$.find('#btnView1Close').attr('disabled', false);
				}

			}
		});
	},

	//공지사항 저장
	noticeSave: function(action) {
		//editer에 입력/수정된 값을 cont(textarea)에 삽입한다
		if (action != 'D') {
			view1$.find('[name=cont]').val(edit$.summernote('code'));
			view1$.find('[name=editNm]').val('cont');
		}

		onm.ajax({
			url: _contextPath_ + '/manage/set/noticeSave.json',
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


	//입력값 유효성 체크
	valid: function(area) {
		var isValid = com.validChk(area); //필수, 길이, 형식등의 유효성 체크
// 		if (!isValid) {} //화면별 유효성 체크
		return isValid;
	},

	//업무유효성 체크
	bizValid: function(area) {
		if (area.attr('id') == 'divView1') {
			if (view1$.find('[name=cont]').val().length > editMaxCnt) {
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
		<div class="loc_info"><span>공지사항관리</span><span>환경설정</span><span>Home</span></div>
		<h2 class="content_title"><span>공지사항관리</span></h2>
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
				<button type="button" class="btn_list" id="btnMainNew"><span class="ico_edit"></span>새글</button>
			</span>
		</div>
		<table id="grid1"></table>
		<div id="grid1Pg"></div>
	</div>
</div>