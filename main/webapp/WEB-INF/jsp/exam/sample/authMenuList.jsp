<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>
<script>
(function($) {
	var authMenuList = $.parseJSON('${authMenuList}');
	$('#authMenuList').jqGrid({
		colNames:['번호','그룹ID','메뉴ID','메인페이지 사용여부','등록일시','등록자ID'],
		colModel:[
	           {name:'rnum',sortable:false,width:10,align:'center'},
	           {name:'groupId',index:'GROUP_ID',width:10},
	           {name:'menuId',index:'MENU_ID',width:10},
	           {name:'firstMenuYn',index:'FIRST_MENU_YN',width:10,align:'right'},
	           {name:'sysRegDtm',index:'SYS_REG_DTM',width:20,formatter:'datetime'},
	           {name:'sysRegId',index:'SYS_REG_ID',width:10},
	       ],
	       datatype:'local',
	       data:authMenuList,
	       rowNum:authMenuList.length,
	       pager:null
	}).trigger('reloadGrid');
}(jQuery));
</script>
<h1>권한별메뉴목록</h1>
<table id="authMenuList"></table>