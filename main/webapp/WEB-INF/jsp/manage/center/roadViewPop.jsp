<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<!-- 카카오맵 api 로드 -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=<spring:eval expression="@config['daum.map.appkey']" />&libraries=services,clusterer"></script>

<!-- 로드뷰를 표시할 div 입니다 -->

<div id="popView1" class="popup-content" style="width:620px;">
	<div id="roadview" style="width:600px;height:500px;"></div>
</div>



<script>
	try {
		var roadviewContainer = document.getElementById('roadview');
		var roadview = new daum.maps.Roadview(roadviewContainer);
		var roadviewClient = new daum.maps.RoadviewClient();

		var position = new daum.maps.LatLng(${xpos}, ${ypos});

		roadviewClient.getNearestPanoId(position, 50, function(panoId) {
		    roadview.setPanoId(panoId, position);
		});
	} catch (e) {
		console.log(e.message);
		var errMsg = e.message;
		var chkMsg = "Flash Player 10";
		if (errMsg.indexOf(chkMsg)) {
			window.location = 'http://get.adobe.com/flashplayer/';
		}
	}

</script>