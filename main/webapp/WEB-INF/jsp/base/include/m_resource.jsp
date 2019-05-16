<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cvo.web.common.constants.CmnConst"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>
<%-- <link rel="stylesheet" href="<c:url value="/resources/ui/smoothness/jquery-ui-1.11.2.min.css" />" /> --%>
<link rel="stylesheet" href="<c:url value="/resources/ui/redmond/jquery-ui.css" />" />
<link rel="stylesheet" href="<c:url value="/resources/css/common.css" />" />
<link rel="stylesheet" href="<c:url value="/resources/css/ui.jqgrid.css" />" />
<link rel="stylesheet" href="<c:url value="/resources/css/jqgrid.custom.css" />" />
<link rel="stylesheet" href="<c:url value="/resources/css/jquery-ui.custom.css" />" />
<link rel="stylesheet" href="<c:url value="/resources/js/chosen/chosen.css" />" />
<%-- <link rel="stylesheet" href="<c:url value="/resources/js/megamenu/megamenu.css" />" /> --%>
<link rel="stylesheet" href="<c:url value="/resources/js/megamenu/grey.css" />" />
<link rel="stylesheet" href="<c:url value="/resources/css/monthPicker.css" />" >
<link rel="stylesheet" href="<c:url value="/resources/css/mobile.css"/>" />
<script>
	var _contextPath_= '${pageContext.request.contextPath}';
	var _recordSizeKey_ = '${cmnConst.paramPaginateRecordSize}';
	var _unauthorizedCode_ = '${cmnConst.resCdUnauthorized}';
	var _safariYn_ = '${sessionScope[cmnConst.sesUserData].safariYn}';

	var imgMaxCnt = parseInt('<spring:eval expression="@config['img.max.cnt']"/>');
	var fileMaxCnt = parseInt('<spring:eval expression="@config['file.max.cnt']"/>');
	var imgMaxSize = parseInt('<spring:eval expression="@config['img.max.size']"/>');
	var fileMaxSize = parseInt('<spring:eval expression="@config['file.max.size']"/>');
	var imgExt = '<spring:eval expression="@config['img.ext']"/>';
	var fileExt = '<spring:eval expression="@config['file.ext']"/>';
	var editMaxCnt = parseInt('<spring:eval expression="@config['edit.max.cnt']"/>');
</script>

<script src="<c:url value="/resources/js/naw-4.x.js" />"></script>
<script src="<c:url value="/webfw/nawconfig.js" />"></script>
<%-- <script src="<c:url value="/resources/js/jquery/jquery-1.11.2.js" />"></script> --%>
<script src="<c:url value="/resources/js/jquery/jquery-migrate-1.2.1.min.js" />"></script>
<script src="<c:url value="/resources/js/jquery/jquery-ui-1.11.2.js" />"></script>
<script src="<c:url value="/resources/js/jquery/jquery.ui.datepicker-ko.js" />"></script>
<script src="<c:url value="/resources/js/monthPicker.js" />"></script>
<script src="<c:url value="/resources/js/jquery.form.min.js" />"></script>
<%-- <script src="<c:url value="/resources/js/json2.js" />"></script> --%>
<script src="<c:url value="/resources/js/jqgrid/jquery.jqGrid-4.6.0.js" />"></script>
<script src="<c:url value="/resources/js/jqgrid/jqgrid.locale-kr.js" />"></script>
<script src="<c:url value="/resources/js/megamenu/jquery.hoverIntent.minified.js" />"></script>
<script src="<c:url value="/resources/js/megamenu/megamenu.js" />"></script>
<script src="<c:url value="/cmn/cdList.jss" />"></script>
<script src="<c:url value="/cmn/msgList.jss" />"></script>
<%-- <script src="<c:url value="/cmn/centerList.jss" />"></script> --%>

<script src="<c:url value="/resources/js/common.js" />"></script>
<script src="<c:url value="/resources/js/onm.js" />"></script>
<%-- <script src="<c:url value="/resources/js/lupin.js" />"></script> --%>
<script src="<c:url value="/resources/js/init.js" />"></script>
<script src="<c:url value="/resources/js/jquery.blockUI.js" />"></script>
<script src="<c:url value="/resources/js/old.cmn.js" />"></script>
<script src="<c:url value="/resources/js/jquery.fileDownload.js" />"></script>
<script src="<c:url value="/resources/js/chosen/chosen.jquery.js" />"></script>
<script src="<c:url value="/resources/js/cvo.js" />"></script>
<script src="<c:url value="/resources/js/com.js" />"></script>
<script src="<c:url value="/resources/js/vue/vue-2.5.13.js" />"></script>
<script src="<c:url value="/resources/js/vue/vue.mixin.js" />"></script>

<!--[if lt IE 9]>
<script src="<c:url value="/resources/js/html5shiv.min.js" />"></script>
<script src="<c:url value="/resources/js/html5shiv-printshiv.min.js" />"></script>
<![endif]-->

<iframe id="_cm" src="" style="display:none;"></iframe>