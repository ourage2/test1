var mapObj = null;

/** 마커 이미지들 **/
var centerMarkerImage = new daum.maps.MarkerImage(_contextPath_ + '/resources/image/cmn/ico_loc_center.png', new daum.maps.Size(25, 36));
//var deliveryMarkerImage = new daum.maps.MarkerImage(_contextPath_ + '/resources/image/map/branch.png',new daum.maps.Size(40, 40));
var deliveryMarkerImage = new daum.maps.MarkerImage(_contextPath_ + '/resources/image/map/branch.png',new daum.maps.Size(30, 30));

//var startMarkerImage = new daum.maps.MarkerImage(_contextPath_ + '/resources/image/map/m_start.png', new daum.maps.Size(20, 20) );
//var startMarkerImage = new daum.maps.MarkerImage(_contextPath_ + '/resources/image/cmn/ico_loc_start.png', new daum.maps.Size(40, 58) );
var startMarkerImage = new daum.maps.MarkerImage(_contextPath_ + '/resources/image/cmn/ico_loc_start.png', new daum.maps.Size(25, 36) );

var midMarkerImage = new daum.maps.MarkerImage(_contextPath_ + '/resources/image/map/m_middle_green.png', new daum.maps.Size(16, 17));

//var endMarkerImage = new daum.maps.MarkerImage(_contextPath_ + '/resources/image/map/m_end.png',new daum.maps.Size(20, 20));
//var endMarkerImage = new daum.maps.MarkerImage(_contextPath_ + '/resources/image/cmn/ico_loc_end.png', new daum.maps.Size(40, 58));
var endMarkerImage = new daum.maps.MarkerImage(_contextPath_ + '/resources/image/cmn/ico_loc_end.png', new daum.maps.Size(25, 36));

/** 차량 ON **/
//var markerImage = new daum.maps.MarkerImage(_contextPath_ + '/resources/image/map/marker01.png', new daum.maps.Size(31, 35) );
//var markerImage = new daum.maps.MarkerImage(_contextPath_ + '/resources/image/cmn/ico_loc_on.svg', new daum.maps.Size(40, 45) );
var markerImage = new daum.maps.MarkerImage(_contextPath_ + '/resources/image/cmn/ico_loc_green.png', new daum.maps.Size(35, 21) );

/** 차량 OFF **/
//var markerOffImage = new daum.maps.MarkerImage(_contextPath_ + '/resources/image/map/marker_off01.png', new daum.maps.Size(31, 35) );
//var markerOffImage = new daum.maps.MarkerImage(_contextPath_ + '/resources/image/cmn/ico_loc_off.svg', new daum.maps.Size(40, 45) );
var markerOffImage = new daum.maps.MarkerImage(_contextPath_ + '/resources/image/cmn/ico_loc_off.png', new daum.maps.Size(35, 21) );

/** 차량 온도이상 **/
//var markerVioImage = new daum.maps.MarkerImage(_contextPath_ + '/resources/image/map/marker_off01.png', new daum.maps.Size(31, 35) );
var markerVioImage = new daum.maps.MarkerImage(_contextPath_ + '/resources/image/cmn/ico_loc_on_error.svg', new daum.maps.Size(35, 21) );
var markerVioImageHistory = new daum.maps.MarkerImage(_contextPath_ + '/resources/image/cmn/ico_loc_error.png', new daum.maps.Size(25, 36) );

var clusterer;

var imageSize = new daum.maps.Size(32, 32);
var selector = null;

var opts = null;
var lastOverlayCarInfo = null;


/** 좌표 객체 배열 **/
//차량
var carObjArray = new Array();
//history
var routeObjArray = new Array();
var routeObjArray2 = new Array();

//센터
var centerObjArray = new Array();
//대리점
var deliveryObjArray = new Array();

//차량번호 custmer overlay
var carNos = new Array();

var markers = new Array();


/** 폴리라인 담는 객체들 **/
var locationHistoryPolyline = null;
var locationHistoryPolyline2 = null;

/** 마커 담는 객체들 **/
var carArrayList = new Array();
var centerArrayList = new Array();
var deliveryArrayList = new Array();
var startMarker = null;
var midMarker = null;
var endMarker = null;
var centerMarker = null;

var selectedMarker = null;

var selectedCarId = null;

/** 선택 팀(센터) 정보 저장 **/
var selected;

$.fn.CvoMap = function(o, init){
	selector = $(this).get(0);

	o = getDefaultOpts(o);

	opts = o;
	if( init == null || init ){
		$.CvoMapLayer.INIT.mapLayer($(this));
	}
	mapSetting();

};

$.extend({
	CvoMap:{
		SET: {
			center : function(pos){
				//현재 맵의 중앙을 지정한다
				setMapCenter(pos);
			},
			zoom : function(lv){
				//맵의 줌 레벨을 변경
				setZoom(lv);
			},
			selector : function(obj){
				if( obj != null && obj.length > 0 ){
					selector = obj.get(0);
				}
			},
			mapmode : function(type){
				//맵의 형태 변경
				changeMapType(type);
			},
			bounds : function(){
				//맵의 bound 설정
				setBounds();
			},
		},
		GET : {
			mapObj : function(){
				return mapObj;
			},
			opts : function(){
				return opts;
			}
		},
		REMOVE: {
			cars : function(){
				removeCarMarker();
			},
			center : function(){
				removeCenterMarker();
			},
			carnumber : function(){
				removeCarNo();
			},

		},
		UTIL: {
			refresh : function(){
				if( mapObj != null ){
					mapObj.relayout();
					mapObj.setCenter( mapObj.getCenter() );
					mapObj.setLevel( mapObj.getLevel() );
				}
			}
		},
		DRAW : {
			cars : function(datas){
				gridCarMarker(datas);
				//gridCarMarker1(datas);
			},
			selectCar : function(data){
				//carInfoOverlay(null, data.carId, data.carNo);
				gridSelectedMarker(data);

			},
			center : function(data){
				drawCenterMarker(data);

			},
			selectedMarker : function(data){
				gridSelectedMarker(data);
			},
			agentMarker: function(data) {
				gridDeliveryMarker(data);
			},
			route : function(routes){
				removeCarMarker();

				if( locationHistoryPolyline != null ){
					locationHistoryPolyline.setMap(null);
					routeObjArray = new Array();
					locationHistoryPolyline = null;
				}

				if( locationHistoryPolyline2 != null ){
					locationHistoryPolyline2.setMap(null);
					routeObjArray2 = new Array();
					locationHistoryPolyline2 = null;
				}

				locationHistoryPolyline = getLocationHistory(routes);
				locationHistoryPolyline.setMap(mapObj);
			},
			allRoute : function(routes){
				if( locationHistoryPolyline2 != null ){
					locationHistoryPolyline2.setMap(null);
					routeObjArray2 = new Array();
					locationHistoryPolyline2 = null;
				}
				locationHistoryPolyline2 = getLocationAllHistory(routes);
				locationHistoryPolyline2.setMap(mapObj);
			},
			midMarker: function(data) {
				drawMidMarker(data);
			}
		},
		INIT : {

		}

	}
});

function mapSetting(){
	var mapOpt = getMapOpt();
	if(mapObj == null) mapObj = new daum.maps.Map(selector, mapOpt );
	var control = new daum.maps.ZoomControl();
	mapObj.addControl(control, daum.maps.ControlPosition.TOPRIGHT);

	clusterer = new daum.maps.MarkerClusterer({
	    map: mapObj, // 마커들을 클러스터로 관리하고 표시할 지도 객체
	    averageCenter: true, // 클러스터에 포함된 마커들의 평균 위치를 클러스터 마커 위치로 설정
	    minLevel: 10, // 클러스터 할 최소 지도 레벨
	    disableClickZoom: true // 클러스터 마커를 클릭했을 때 지도가 확대되지 않도록 설정한다
	});

	daum.maps.event.addListener(mapObj, 'zoom_changed', function() {
	    //console.log(mapObj.getLevel());
	    var dispCarNo = null;
	    if (mapObj.getLevel() <= 10) {
	    	dispCarNo = mapObj;
	    }
	    for(var i=0; i<carNos.length; i++){
			//source.extend(carNos[i]);
    		carNos[i].setMap(dispCarNo);
		}
	});

	$.CvoMap.UTIL.refresh();
}


//지도 기본 형태
function getMapOpt(){
	startPoint = convertPos(37.566826005485716,126.9786567859313);
	var zoomLv = 10;
	mapOpt = {
		center: startPoint,
		level: zoomLv
	};

	return mapOpt;
}

// 좌표형태 변경
function convertPos(x, y){
	var cx = x, cy = y;

	if( Number(x) == 0 && Number(y) == 0 ){
		return null;
	}else{
		return new daum.maps.LatLng(cx , cy);
	}
}

// 지도 타입 변경
function changeMapType(type){
	switch (type) {
		case 'hybrid':
			mapObj.setMapTypeId(daum.maps.MapTypeId.HYBRID);
			break;
		case 'sky':
			mapObj.setMapTypeId(daum.maps.MapTypeId.SKYVIEW );
			break;
		case 'normal':
		default :
			mapObj.setMapTypeId(daum.maps.MapTypeId.ROADMAP );
			break;
	}
}

// 지도 option 로딩
function getDefaultOpts(o){

	var opts = {
        zoomLv: 13, // 1~14
    };
	if( o != null  ){
		$.each(opts, function(key, value) {
			if( o[key] == null ){
				o[key] = opts[key];
			}
		});

	}else{
		o = opts;
	}
	return o;
}

// 지도 setCenter
function setMapCenter(pos){
	if(mapObj != null) mapObj.setCenter(pos);
}

// 지도 setZoom
function setZoom(lv){
	if(mapObj != null) mapObj.setLevel(lv);
}

//지도 트래픽 type 추가
function addRoadTraffic(obj){

	if( obj != null ){
		controllArray[2] = (controllArray[2] + 1) % 2;
		if( $(obj).prop("checked") ){
			mapObj.addOverlayMapTypeId(daum.maps.MapTypeId.TRAFFIC);
		}else{
			mapObj.removeOverlayMapTypeId(daum.maps.MapTypeId.TRAFFIC);
		}

	}
}

function setBounds(){
	var source = new daum.maps.LatLngBounds();

	if( carObjArray != null && carObjArray.length > 0 ){
		for(var i=0; i<carObjArray.length; i++){
			source.extend(carObjArray[i]);
		}
	}

	if( routeObjArray != null && routeObjArray.length > 0 ){
		for(var i=0; i<routeObjArray.length; i++){
			if(routeObjArray[i] != null) {
				source.extend(routeObjArray[i]);
			}
		}
	}

	if( startMarker != null){
		source.extend(startMarker.getPosition());
	}

	if( endMarker != null){
		source.extend(endMarker.getPosition());
	}

	if( centerObjArray != null && centerObjArray.length > 0 ){
		for(var i=0; i<centerObjArray.length; i++){
			if(centerObjArray[i] != null) {
				source.extend(centerObjArray[i]);
			}
		}
	}

	if( deliveryObjArray != null && deliveryObjArray.length > 0 ){
		for(var i=0; i<deliveryObjArray.length; i++){
			if(deliveryObjArray[i] != null) {
				source.extend(deliveryObjArray[i]);
			}
		}
	}

	if( source !=null && !source.isEmpty() ){
		mapObj.setBounds(source);
	}
}

// 전체 차량 아이콘 생성
function gridCarMarker(data, isRemove){
	if(isRemove == null)
		isRemove = true;

	if(isRemove){
		removeCarMarker();
		removeCarNo();
		closeDetailPop();
		if (selectedCarId == null) {
			removeDeliveryMarker();
		}
	}

	var carMarkerImg;
	$.each(data, function (index, car) {
		if( car.xpos != "null" && car.ypos != "null" && car.lv == "1" ){
			var pos = convertPos(car.xpos , car.ypos);
			if( pos != null ){

				if (car.ch1Vio == "E" || car.ch2Vio == "E")
					carMarkerImg = markerVioImage;
				else {
					if ( car.turnOnOff != null && car.turnOnOff == "OFF" ) carMarkerImg = markerOffImage;
					else carMarkerImg = markerImage;
				}

				marker = new daum.maps.Marker({
			    	map: mapObj,
			        position: pos,
			        title : car.carNo,
			        image : carMarkerImg ,
			        zIndex : 1004
			    });
			    //$(marker.a).append("<img class='carSelectMark' id='carselect_0_"+car.carId+"' src='/resources/image/map/car_focus_icon.png' style='width: 62px; left: -11px; top: -8px; position: absolute; display:none; z-index: -1' />");

			    makeCarNo(car.carNo, pos);

			    if( car != null ){
			    	marker.setClickable(true);
			    	daum.maps.event.addListener(marker, 'click', function(){
			    		carInfoOverlay(car.carId, car.carNo, null);
			    	});
			    }

			    carArrayList.push(marker);
			    carObjArray.push(pos);
			}
		}
	});

	if (selectedCarId == null) {
		$.CvoMap.SET.bounds();
	} else {
		if( carObjArray != null && carObjArray.length > 0 ){
			$.CvoMap.SET.center(carObjArray[0]);
		}
	}
}

function gridCarMarker1(data, isRemove){
	//console.log(clusterer);

	if(isRemove == null)
		isRemove = true;

	if(isRemove){
		removeCarMarker();
		removeCarNo();
		closeDetailPop();
		if (selectedCarId == null) {
			removeDeliveryMarker();
		}
	}

	var carMarkerImg;
	$.each(data, function (index, car) {
		if( car.xpos != "null" && car.ypos != "null" && car.lv == "1" ){
			var pos = convertPos(car.xpos , car.ypos);
			if( pos != null ){

				if (car.ch1Vio == "E" || car.ch2Vio == "E")
					carMarkerImg = markerVioImage;
				else {
					if ( car.turnOnOff != null && car.turnOnOff == "OFF" ) carMarkerImg = markerOffImage;
					else carMarkerImg = markerImage;
				}

				marker = new daum.maps.Marker({
			    	position: pos,
			        title : car.carNo,
			        image : carMarkerImg ,
			        zIndex : 1004
			    });

				makeCarNo(car.carNo, pos);

			    if( car != null ){
			    	marker.setClickable(true);
			    	daum.maps.event.addListener(marker, 'click', function(){
			    		carInfoOverlay(car.carId, car.carNo, null);
			    	});
			    }

				carArrayList.push(marker);
				carObjArray.push(pos);

			}
		}
	});
	clusterer.addMarkers(carArrayList);

	daum.maps.event.addListener(clusterer, 'clusterclick', function(cluster) {
        var level = mapObj.getLevel()-1;
        mapObj.setLevel(level, {anchor: cluster.getCenter()});
    });

	if (selectedCarId == null) {
		$.CvoMap.SET.bounds();
	} else {
		if( carObjArray != null && carObjArray.length > 0 ){
			$.CvoMap.SET.center(carObjArray[0]);
		}
	}

}

// 선택된 차량
function gridSelectedMarker(data, isRemove){
	onm.ajax({
		url: _contextPath_ + '/manage/center/tempNowDtl.json',
		data: {"carId":data.carId},
		success: function(res) {
			$.CvoMap.DRAW.cars(res.list);
			if (data.carId != selectedCarId) {
				gridDeliveryMarker(res.deliDtlList);
			}
			//makeCarDtlInfo(res);
			selectedCarId = data.carId;
		}
	});
}

// 차량번호 그리기
function makeCarNo(carNo, pos){
	var carNoTxt = carNo == "" ? "정보가 없습니다." : carNo;
	if( carNos != null ){
		var content = "<div ondragstart='return false' onselectstart='return false' ";
			content +=	" style=\"";
			content +=	"color: #000000!important; ";
			content +=	"white-space: nowrap; ";
			content +=	"padding: 0px 4px; ";
			content +=	"font-family: ";
			content +=	"'Nanum Gothic'; ";
			content +=	"font-size: 11px; ";
			content +=	"font-weight: bold; ";
			content +=	"z-index: 100; ";
			content +=	"display: block; ";
			//content +=	"background-color: #FFFFFF; ";
			content +=	" -ms-filter: 'progid:DXImageTransform.Microsoft.gradient(startColorstr=#FFFFFF endColorstr=#FFFFFF)';  zoom:1;";
			//content +=	"border: 2px solid #868181;";
			//content +=	"margin-top: -5px;";
			content +=	" \" >"+carNoTxt+"</div> ";

	    var customOverlay = new daum.maps.CustomOverlay({
	        //map: mapObj,
	        clickable: false,
	        content: content,
	        position: pos,
	        xAnchor: 0.5,
	        yAnchor: -0.2,
	        zIndex: 1003
	    });

	    //customOverlay.setMap(mapObj);
	    carNos.push(customOverlay);

	}
}

// 차량정보 infowindow 그리기
function carInfoOverlay(carId, carNo, opt){
	onm.ajax({
		url: _contextPath_ + '/manage/center/tempNowDtl.json',
		data: {"carId":carId},
		success: function(res) {
			if (carId != selectedCarId) {
				//gridDeliveryMarker(res.deliDtlList);
			}

			makeCarDtlInfo(res, opt);
		}
	});
}

function makeCarDtlInfo(datas, pos) {
	var contentLayout = '';

    if( lastOverlayCarInfo != null ){
    	lastOverlayCarInfo.setMap(null);
    }

    var data = datas.list;
	if (data.length > 0) {

		if (pos == null)
			pos = convertPos(data[0].xpos , data[0].ypos);

		contentLayout += ' <div id="carInfoOverlay" class="popup_table" style="display: block;"  >';
		contentLayout += "<table>";
		contentLayout += "	<colgroup>";
		contentLayout += "		<col width=\"105\">";
		contentLayout += "		<col width=\"140\">";
		contentLayout += "		<col width=\"105\">";
		contentLayout += "		<col width=\"140\">";
		contentLayout += "	</colgroup>";
		contentLayout += "	<thead>";
		contentLayout += "		<tr>";

		contentLayout += "		<th colspan=\"4\">";

		if (data[0].ch1Vio == "E" || data[0].ch2Vio == "E")
			contentLayout += "		<span class=\"pt_vio\">이상</span>";
		else {
			if ( data[0].turnOnOff != null && data[0].turnOnOff == "OFF" )
				contentLayout += "		<span class=\"pt_off\">OFF</span>";
			else
				contentLayout += "		<span class=\"pt_on\">ON</span>";
		}

		contentLayout += "	" + data[0].carNo;
		contentLayout += "		<a href=\"javascript:closeDetailPop();\" class=\"closePopClass\">X</a>";
		contentLayout += "		</th>";
		contentLayout += "		</tr>";
		contentLayout += "	</thead>";
		contentLayout += "	<tbody>";

		contentLayout += "		<tr>";
		contentLayout += "		<td class=\"pt_head no_b\">현위치</td>";
		contentLayout += "		<td colspan=\"3\">"+data[0].jibunAddr+"</td>";
		contentLayout += "		</tr>";

		contentLayout += "		<tr>";
		contentLayout += "		<td class=\"pt_head no_b\">단말기번호</td>";
		contentLayout += "		<td>"+data[0].carTid+"</td>";
		contentLayout += "		<td class=\"pt_head\">시동상태</td>";
		contentLayout += "		<td>"+data[0].turnOnOff+"</td>";
		contentLayout += "		</tr>";

		contentLayout += "		<tr>";
		contentLayout += "		<td class=\"pt_head no_b\">일운행거리</td>";
		contentLayout += "		<td>"+data[0].dayDis+" km</td>";
		contentLayout += "		<td class=\"pt_head\">속도</td>";
		contentLayout += "		<td>"+data[0].spd+" km/h</td>";
		contentLayout += "		</tr>";

		contentLayout += "		<tr>";
		contentLayout += "		<td class=\"pt_head no_b\">CH1온도</td>";
		contentLayout += "		<td>"+data[0].ch1;

		if (data[0].ch1Vio != "") {
			contentLayout += 	" ℃ " + (data[0].ch1Vio == "E" ? "(이탈온도)" : "(정상온도)");
		}

		contentLayout += "		</td>";
		contentLayout += "		<td class=\"pt_head\">CH2온도</td>";
		contentLayout += "		<td>"+data[0].ch2;

		if (data[0].ch2Vio != "") {
			contentLayout += 	" ℃ " + (data[0].ch2Vio == "E" ? "(이탈온도)" : "(정상온도)");
		}

		contentLayout += "		</tr>";

		contentLayout += "		<tr>";
		contentLayout += "		<td class=\"pt_head no_b\">최근시동OFF</td>";
		contentLayout += "		<td colspan=\"3\">"+data[0].recentOffDt+"</td>";
		contentLayout += "		</tr>";

		contentLayout += "		<tr>";
		contentLayout += "		<td class=\"pt_head no_b\">최종 보고시간</td>";
		contentLayout += "		<td>"+data[0].lastTempDt+"</td>";
		contentLayout += "		<td colspan=\"2\" style=\"text-align:right; padding-right:5px;\">";
		contentLayout += "		<a href=\"javascript:void(0);\" onclick=\"openRoadView("+data[0].xpos+","+data[0].ypos+")\" >로드뷰</a>";
		contentLayout += "		</td>";
		contentLayout += "		</tr>";
		contentLayout += "	</tbody>";
		contentLayout += "</table>";
		contentLayout += ' </div> ';

		var customOverlay = new daum.maps.CustomOverlay({
	        map: mapObj,
	        clickable: false,
	        content: contentLayout,
	        position: pos,
	        xAnchor: 0.5,
	        yAnchor: -0.2,
	        zIndex: 1005
	    });
	    customOverlay.setMap(mapObj);
	    lastOverlayCarInfo = customOverlay;

	    if (selectedCarId != null) {
		    //$.CvoMap.SET.zoom(4);
	    }

	    $.CvoMap.SET.center(pos);
	}
}

//대리점 그리기
function gridDeliveryMarker(data){
	removeDeliveryMarker();

	$.each(data, function (index, delivery) {
		var pos = convertPos(delivery.xpos , delivery.ypos);
		if( pos != null ){
		    marker = new daum.maps.Marker({
		    	map: mapObj,
		        position: pos,
		        title : delivery.agentNm,
		        image : deliveryMarkerImage,
		        zIndex : 1001
		    });
		    //$(marker.a).append("<img class='deliverySelectMark' id='deliverySelect_"+delivery.agentCd+"' src='/resources/images/marker/branch_focus_icon.png' style='width: 52px; left: -10px; top: -10px; position: absolute; display:none; ' />");
		    deliveryArrayList.push(marker);
		    deliveryObjArray.push(pos);
		}
	});

	$.CvoMap.SET.bounds();
	$.CvoMap.SET.refresh;
}

// 운행시작 마커
function drawStartMarker(pos){
	if( startMarker != null ){
		startMarker.setMap(null);
	}

    var marker = new daum.maps.Marker({
    	map: mapObj,
        position: pos,
        title : "운행 시작",
        image : startMarkerImage,
        zIndex : 1002
    });

    startMarker = marker;
}

// 운행경로 마커
function drawMidMarker(data){
	console.log(data);
	if( midMarker != null ){
		midMarker.setMap(null);
	}

	var pos = convertPos(data.xpos , data.ypos);
	var marker = new daum.maps.Marker({
    	map: mapObj,
        position: pos,
        title : data.devDt,
        image : midMarkerImage,
        zIndex : 1002
    });

    midMarker = marker;
    $.CvoMap.SET.center(pos);
	$.CvoMap.SET.zoom(4);
}

// 운행종료 마커
function drawEndMarker(pos){
	if( endMarker != null ){
		endMarker.setMap(null);
	}

    var marker = new daum.maps.Marker({
    	map: mapObj,
        position: pos,
        title : "운행 종료",
        image : endMarkerImage,
        zIndex : 1002
    });

    endMarker = marker;
}

function drawCenterMarker(data){
	if( centerMarker != null ){
		centerMarker.setMap(null);
	}

	var pos = convertPos(data.xpos , data.ypos);
	var marker = new daum.maps.Marker({
    	map: mapObj,
        position: pos,
        title : data.centerNm,
        image : centerMarkerImage,
        zIndex : 1002
    });

    centerMarker = marker;
}

// 차량운행 내역 그리기
function getLocationHistory(route){
	var path = new Array();
	$.each(route, function (index, data) {
		var pos = convertPos(data.xpos, data.ypos);
		if( pos != null ){
			if(index == 0){
				drawStartMarker(pos);
			}

			if (data.tempDevDt != "") {
				marker = new daum.maps.Marker({
			    	map: mapObj,
			        position: pos,
			        title : data.devDt,
			        image : markerVioImageHistory ,
			        zIndex : 1001
			    });
			    carArrayList.push(marker);
			    carObjArray.push(pos);
			}

			/*
		    if( data != null ){
		    	marker.setClickable(true);
		    	daum.maps.event.addListener(marker, 'click', function(){
		    		carInfoOverlay(car.carId, car.carNo, null);
		    	});
		    }
		    */
			path.push(pos);
			routeObjArray.push(pos);
		}
	});

	if( path.length > 0 ){
		drawEndMarker( path[path.length - 1] );
	}

	var polyline = new daum.maps.Polyline({
	    path: path,
	    strokeWeight: 3,
	    strokeColor: '#2B42E6',
	    strokeOpacity: 1,
	    strokeStyle: 'solid',
	    zIndex: 1999
	});

	$.CvoMap.SET.bounds();
	return polyline;
}

//전체차량운행 내역 그리기
function getLocationAllHistory(route){
	var path = new Array();
	$.each(route, function (index, data) {
		var pos = convertPos(data.xpos, data.ypos);
		if( pos != null ){
			path.push(pos);
			routeObjArray2.push(pos);
		}
	});

	var polyline = new daum.maps.Polyline({
	    path: path,
	    strokeWeight: 2,
	    strokeColor: '#FF0000',
	    strokeOpacity: 0.6,
	    strokeStyle: 'solid',
	    zIndex: 1999
	});

	return polyline;
}

// 로드맵 팝업
function openRoadView(xpos, ypos) {
	onm.ajaxModal({
		url: _contextPath_ + '/manage/center/roadViewPop.pop',
		data: {
			"xpos" : xpos,
			"ypos" : ypos
		},
		dialogOptions: { title: '로드뷰'}
	});
}


// infowindow 닫기
function closeDetailPop(carId){
	if( lastOverlayCarInfo != null ){
    	lastOverlayCarInfo.setMap(null);
    }
}

// 차량 마커 지우기
function removeCarMarker(){
	var a = new Array();
	a = carArrayList == null ? new Array() : carArrayList;

	clusterer.clear();

	for (var i = 0; i < a.length; i++) {
		a[i].setMap(null);
	}

	if(!isNull(startMarker))
		startMarker.setMap(null);

	if(!isNull(midMarker))
		midMarker.setMap(null);

	if(!isNull(endMarker))
		endMarker.setMap(null);

	if(!isNull(selectedMarker))
		selectedMarker.setMap(null);

	startMarker = null;
	midMarker = null;
	endMarker = null;
	selectedMarker = null;

	a = new Array();
	carArrayList = new Array();
	carObjArray = new Array();
}

// 차량명 overlay 지우기
function removeCarNo(){
	var cn = new Array();
	cn = carNos == null ? new Array() : carNos;

	for (var i = 0; i < cn.length; i++) {
		cn[i].setMap(null);
	}

	cn = new Array();
	carNos = new Array();
}

// 대리점 마커 지우기
function removeDeliveryMarker(){
	deliveryArrayList = deliveryArrayList == null ? new Array() : deliveryArrayList;

	for (var i = 0; i < deliveryArrayList.length; i++) {
		deliveryArrayList[i].setMap(null);
	}

	deliveryArrayList = new Array();
	deliveryObjArray = new Array();
}

function isNull(str){
	if( typeof str == "number" ){
		str = String(str);
	}

	if( str == null || str.length <= 0 || str == "undefined" || str == undefined || str == "null" ){
		return true;
	}else{
		return false;
	}
}

