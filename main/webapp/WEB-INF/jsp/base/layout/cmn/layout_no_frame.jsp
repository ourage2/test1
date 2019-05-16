<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
	<title><tiles:getAsString name="title" /></title>
	<tiles:insertAttribute name="resource" />
	<script>
	/*
		function autoScroll() {
			if (typeof top.document !== 'undefined') {
				var main = $('div#main');
				if (main.length > 0) {
					var height = main.css('height').replaceAll('px', '');
					var srchHeight = $('#divSrch').css('height') ? $('#divSrch').css('height').replaceAll('px', '') : 0;
					height = top.document.body.clientHeight - srchHeight - 240;
// 					console.log("clientHeight:" + top.document.body.clientHeight);
// 					console.log("srchHeight:" + srchHeight);
					console.log("inner height:" + height);
// 					main.css('height', height + 'px');
				}
			}
		}
		window.onload = function() {
// 			autoScroll();
		}
		$(function (e) { //브라우져 사이즈변경시 리사이즈
			e(parent.window).on('resize', function () {
				if (typeof autoScroll !== 'undefined') {
					autoScroll();
				}
			})
		});
		*/
	</script>
</head>
<body>

<div id="wrap">
	<tiles:insertAttribute name="content" />
</div>
</body>
</html>
