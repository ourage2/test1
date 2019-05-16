<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp"%>

<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js?autoload=false"></script><!-- 다음주소찾기 -->

<script>
var view1p$;
var addr$;
var map$;
var addrFind$;
var data;
var daumMap;
var daumBounds;
var daumGeocoder;
var initCnt = 0;
var xpos = 37.56683321058658;
var ypos = 126.97864093719429;

jQuery(function($) {
	view1p$ = com.toBox($('#popView1'));
	addr$ = com.toBox($('#popAddr'));

	data = JSON.parse('${paramBox.data}');
	com.setVal(addr$, data);

	if (data.xpos) { xpos = data.xpos;}
	if (data.ypos) { ypos = data.ypos;}

	var opt = {center : new daum.maps.LatLng(xpos, ypos)};
	map$ = new daum.maps.Map(document.getElementById('popMap'), opt);
	daum.maps.event.addListener(map$, 'tilesloaded', mapInit);
	var newMarker = new daum.maps.Marker();

	addrFind$ = document.getElementById('divAddrFind');
	addrInit();

	//다음지도 로드
	function mapInit() {
		initCnt++;
// 		console.log(initCnt);
		var loc = new daum.maps.LatLng(xpos, ypos);
		map$.setCenter(loc);

		map$.relayout();

		if (initCnt >= 3) {
			if (data.xpos) {
				var markerPosition = new daum.maps.LatLng(xpos, ypos);
				var oldMarker = new daum.maps.Marker({
						position: markerPosition,
						image: deliveryMarkerImage // 마커이미지 설정
					});
	//	 		oldMarker.setPosition(map$.getCenter());
				oldMarker.setMap(map$);

				// 인포윈도우로 장소에 대한 설명을 표시합니다
				var infowindow = new daum.maps.InfoWindow({
					content : '<div style="width:' + data.agentNm.length * 17 + 'px;text-align:center;padding:6px 0;">' + data.agentNm + '</div>',
	//	 			removable : true
				});
				infowindow.open(map$, oldMarker);
			}

			var control = new daum.maps.ZoomControl();
			map$.addControl(control, daum.maps.ControlPosition.TOPRIGHT);

			// 지도에 클릭 이벤트를 등록합니다
			daum.maps.event.addListener(map$, 'click', function(mouseEvent) {
				// 클릭한 지도위치의 위도, 경도 정보를 가져옵니다
				var latlng = mouseEvent.latLng;
// 				console.log(latlng)
				newMarker.setMap(null);
				newMarker = new daum.maps.Marker({
					position: latlng,
					map: map$
				});

				// 마커 위치를 클릭한 위치로 옮깁니다
	 			newMarker.setPosition(latlng);

				var geocoder = new daum.maps.services.Geocoder();
				//위도 경도로 주소 가져오기
				geocoder.coord2Address(latlng.ib, latlng.jb, function(result, status) {
					if (status === daum.maps.services.Status.OK) {
// 						console.log(result);

						// 마커에 클릭이벤트를 등록합니다
						daum.maps.event.addListener(newMarker, 'click', function() {
							if (confirm('해당 위치로 대리점의 좌표를 지정하시겠습니까?')) {
								var row = {};

								if (result[0].road_address) {
				 					row.cvoSi = result[0].road_address.region_1depth_name;
				 					row.cvoZip = result[0].road_address.zone_no;
				 					row.cvoAddr = result[0].road_address.address_name;
								} else {
									row.cvoSi = result[0].address.region_1depth_name;
// 				 					row.cvoZip = result[0].address.zip_code; //(구)우편번호는 저장하지 않는다 - 다음지도/주소에서도 null로 넘어옴
				 					row.cvoAddr = result[0].address.address_name;
								}
								row.xpos = latlng.jb;
								row.ypos = latlng.ib;
								view1p$.data('callback').apply(this, [row]);
								$('#btnPopView1Close').trigger('click');
							}
						});
					}
				});

			});
			daum.maps.event.removeListener(map$, 'tilesloaded', mapInit); //tiles로드 제거
		}
	}

	//주소 로드
	function addrInit() {
		daum.postcode.load(function(){
			new daum.Postcode({
				oncomplete: function(choiceInfo) {
// 					console.log(choiceInfo);

					var geocoder = new daum.maps.services.Geocoder();
					// 주소로 좌표를 검색합니다
					geocoder.addressSearch(choiceInfo.roadAddress, function(result, status) {
// 						console.log(result);

						// 정상적으로 검색이 완료됐으면
						if (status === daum.maps.services.Status.OK) {
// 							console.log(result[0].y + ', ' + result[0].x);
// 							if (confirm('해당 위치로 대리점의 좌표를 지정하시겠습니까?')) {
// 								addr$.put('xpos', result[0].y);
// 								addr$.put('ypos', result[0].x);
// 								addr$.put('cvoAddr', data.roadAddress);
// 							}

							var coords = new daum.maps.LatLng(result[0].y, result[0].x);
							// 결과값으로 받은 위치를 마커로 표시합니다
							newMarker.setMap(null);
							newMarker = new daum.maps.Marker({
								position : coords,
								map : map$
							});
				 			newMarker.setPosition(coords);

							// 인포윈도우로 장소에 대한 설명을 표시합니다
// 							var infowindow = new daum.maps.InfoWindow({
// 								content : '<div style="width:200px;text-align:center;padding:6px 0;">' + data.agentNm + '</div>',
// 								removable : true
// 							});
// 							infowindow.open(map$, marker);

							// 마커에 클릭이벤트를 등록합니다
							daum.maps.event.addListener(newMarker, 'click', function() {
								// 마커 위에 인포윈도우를 표시합니다
// 								infowindow.open(map$, marker);
								if (confirm('해당 위치로 대리점의 좌표를 지정하시겠습니까?')) {
									var row = {};
// 	 								addr$.put('xpos', result[0].y);
// 	 								addr$.put('ypos', result[0].x);
// 	 								addr$.put('cvoAddr', choiceInfo.roadAddress);
// 	 								addr$.put('cvoSi', choiceInfo.sigungu);

	 								row.cvoSi = choiceInfo.sido;
									row.cvoZip = choiceInfo.zonecode;
	 								row.cvoAddr = choiceInfo.roadAddress;
	 								row.xpos = result[0].y;
	 								row.ypos = result[0].x;
	 								view1p$.data('callback').apply(this, [row]);
	 								$('#btnPopView1Close').trigger('click');
								}
							});

							// 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
							map$.setCenter(coords);
// 							map$.relayout();

						}
					});
				},
				onresize : function(size) {
					//console.log(size);
					addrFind$.style.height = '465px';
// 					view1p$.css('height', '100%');
				},
				onclose : function(state) {
					//state는 우편번호 찾기 화면이 어떻게 닫혔는지에 대한 상태 변수 이며, 상세 설명은 아래 목록에서 확인하실 수 있습니다.
					if (state === 'FORCE_CLOSE') {
						//사용자가 브라우저 닫기 버튼을 통해 팝업창을 닫았을 경우, 실행될 코드를 작성하는 부분입니다.
						//console.log('1111');
					} else if (state === 'COMPLETE_CLOSE') {
						//사용자가 검색결과를 선택하여 팝업창이 닫혔을 경우, 실행될 코드를 작성하는 부분입니다.
						//oncomplete 콜백 함수가 실행 완료된 후에 실행됩니다.
						//addrFind$.remove();
					}
				},
				width : '100%',
				height : '100%'
			}).embed(addrFind$, {autoClose : false});
		});
	}

});
</script>

<div id="popView1" class="popup-content" style="width: 1160px;">
	<div>
		<font color="blue">
			* 마커를 지정하려면 주소를 검색해서 선택하거나 지도에서 위치를 클릭하세요. &nbsp;&nbsp;&nbsp;&nbsp; *대리점 좌표를 저장하려면 저장하려는 마커를 선택해 주세요.
		</font>
	</div>

	<div class="colgroup-wrap">
		<div class="colgroup-2-5">
			<div id="popAddr">
				<table class="dtl_tbl">
					<colgroup>
						<col width="24%">
						<col width="26%">
						<col width="20%">
						<col width="30%">
					</colgroup>
					<tr>
						<th>대리점명</th>
						<td colspan="3"><input type="text" name="agentCdNm" read /></td>
					</tr>
					<tr>
						<th>SAP주소</th>
						<td colspan="3"><input type="text" name="si" read /></td>
					</tr>
<!-- 					<tr> -->
<!-- 						<th>CVO우편번호</th> -->
<!-- 						<td colspan="3"><input type="text" name="cvoZip" read /></td> -->
<!-- 					</tr> -->
					<tr>
						<th>CVO주소</th>
						<td colspan="3"><input type="text" name="cvoAddr" read /></td>
					</tr>
					<tr>
						<th>위도</th>
						<td><input type="text" name="xpos" read /></td>
						<th>경도</th>
						<td><input type="text" name="ypos" read /></td>
					</tr>
					<tr>
						<td colspan="4">
							<div id="divAddrFind" style="margin:5px 0;position:relative"></div>
						</td>
					</tr>
				</table>
			</div>
		</div>

		<div class="colgroup-3-5">
			<div id="popMap" style="border: 1px solid; height: 590px;"></div>
		</div>
	</div>
</div>
