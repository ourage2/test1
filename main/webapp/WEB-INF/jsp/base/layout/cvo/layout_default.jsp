<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<!DOCTYPE html>
<html>

<c:choose>
	<c:when test="${util:getUrlExt() eq 'do'}">


<head>
	<meta charset="UTF-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
	<title><tiles:getAsString name="title" /></title>
	<link rel="shortcut icon" href="<c:url value="/favicon.ico" />" type="image/x-icon">
	<link rel="icon" href="<c:url value="/favicon.ico" />" type="image/x-icon">
	<tiles:insertAttribute name="resource" />
</head>
<body class="ly_body">
	<div id="layout_wrap" class="ly_wrap">
		<div class="layout_bg"></div>
		<tiles:insertAttribute name="header" />
		<div id="layout_container" class="ly_container">
			<div id="layout_content_wrap" class="ly_content_wrap">
	<%-- 			<tiles:insertAttribute name="lnb" /> --%>
				<div id="layout_content">
					<tiles:insertAttribute name="content" />
				</div>
			</div>
		</div>
	</div>
	<tiles:insertAttribute name="footer" />
</body>


	</c:when>
	<c:when test="${util:getUrlExt() eq 'm'}">

<head>
	<meta charset="UTF-8" />
	<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width" />
<!-- 	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi" /> -->
	<meta name="format-detection" content="telephone=no" />
	<title><tiles:getAsString name="title" /></title>
	<link rel="shortcut icon" href="<c:url value="/favicon.ico" />" type="image/x-icon">
	<link rel="icon" href="<c:url value="/favicon.ico" />" type="image/x-icon">
	<tiles:insertAttribute name="resource" />
</head>
<body class="m_body">
	<div id="" class="m_wrap">
		<tiles:insertAttribute name="header" />
		<div id="" class="m_container">
			<div id="" class="m_content_wrap">
				<div id="">
					<tiles:insertAttribute name="content" />
				</div>
			</div>
		</div>
	</div>
	<tiles:insertAttribute name="footer" />
</body>

	</c:when>
</c:choose>

</html>