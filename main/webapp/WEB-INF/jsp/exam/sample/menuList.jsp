<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>
<script>
jQuery(function($) {
	var srchFrm$ = $('#srchFrm');
	var userGrid$ = $('#userList').jqGrid({
		url:srchFrm$.attr('action'),
		colNames:['번호','메뉴ID','메뉴명','메뉴순서','메뉴URL','사용여부','등록일자','등록일시','메뉴별권한',''],
		colModel:[
            {name:'rnum',sortable:false,width:10,align:'center'},
            {name:'menuId',index:'MENU_ID',width:10,formatter:'link',formatoptions:{dataAttr:{menuId:'menuId'},attr:{view:'view'}}},
            {name:'menuNm',index:'MENU_NM',width:10},
            {name:'menuOrd',index:'MENU_ORD',width:5,align:'right'},
            {name:'menuUrl',index:'MENU_URL',width:20},
            {name:'useYn',index:'USE_YN',width:5},
            {name:'sysRegDtm',index:'SYS_REG_DTM',width:20,formatter:'dateday'},
            {name:'sysRegDtm2',index:'SYS_REG_DTM2',width:20,formatter:'datetime'},
            {sortable:false,width:10,formatter:'button',formatoptions:{btnText:'보기', dataAttr:{menuId:'menuId'},attr:{auth:''}}},
            {sortable:false,width:10,formatter:'button',formatoptions:{btnText:'삭제'}}
        ]
	});

	<%-- 검색조건 기본값 설정 --%>
// 	$('#srchStartDt').val(onm.getBeforeWeek());
	$('#srchStartDt').val(onm.getBeforeMonth());
	$('#srchEndDt').val(onm.todayFmt());

	<%-- 검색 --%>
	srchFrm$.on('submit', function() {
		userGrid$.setGridParam({
			postData:srchFrm$.serializeJson()
		}).trigger('reloadGrid');
		return false;
	});

// 	onm.detailInit({titleText:'권한별메뉴목록'});
	onm.detailInit();

	<%-- 메뉴ID 클릭 --%>
	$(document).on('click', '[data-view]', function(e) {
		e.preventDefault();
		var menuId = $(this).attr('data-menuId');
		onm.detailView({
			url:'<c:url value="/exam/sample/menuDetail.do" />',
			data:{'menuId':menuId}
		});
	});

	<%-- 메뉴별권한 클릭 --%>
	$(document).on('click', '[data-auth]', function(e) {
		e.preventDefault();
		var menuId = $(this).attr('data-menuId');
		onm.detailView({
			url:'<c:url value="/exam/sample/authMenuList.do" />',
			data:{'menuId':menuId}
		});
	});

	$('#btnDetailClose').on('click', function() {
		onm.detailClose();
	});

});
</script>


<h2 class=content_title>메뉴목록</h2>
<form action="<c:url value="/exam/sample/menuList.json" />" id="srchFrm" name="srchFrm" method="post">
	<div class="srch_box">
		<table>
			<colgroup>
				<col style="width:10%;" />
				<col style="width:35%;" />
				<col style="width:10%;" />
				<col style="width:35%;" />
				<col style="width:10%;" />
			</colgroup>
			<tr>
				<th>등록일자<span class="required"></span></th>
				<td>
					<input type="text" name="srchStartDt" id="srchStartDt" class="inputDatePicker" /> ~ <input type="text" name="srchEndDt" id="srchEndDt" class="inputDatePicker" />
				</td>
				<th>사용여부</th>
				<td colspan="2">
					<select name="srchUseYn">
						<option value="">전체</option>
						<option value="Y">사용</option>
						<option value="N">미사용</option>
					</select>
				</td>
			</tr>
			<tr>
				<th>메뉴명</th>
				<td><input type="text" name="srchMenuNm" /></td>
				<th>메뉴URL</th>
				<td><input type="text" name="srchMenuUrl" /></td>
				<td><span class="btn_pack large icon"><span class="search"></span><input type="submit" value="검색" /></span></td>
			</tr>
		</table>
	</div>
</form>

<div class="btn_base_area">
	<span class="btn_pack medium"><button type="button" id="btnDetailClose">상세보기 닫기</button></span>
</div>

<table id="userList"></table>
<div id="pager"></div>
