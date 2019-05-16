var mapObj = null;
var mapObj2 = null;

/** 마커 이미지들 **/
var centerMarkerImage = new daum.maps.MarkerImage('/resources/images/marker/center.png', new daum.maps.Size(41, 40));
var deliveryMarkerImage = new daum.maps.MarkerImage('/resources/images/marker/branch.png',new daum.maps.Size(31, 35));
var startMarkerImage = new daum.maps.MarkerImage('/resources/images/marker/m_start.png', new daum.maps.Size(20, 20) );
var endMarkerImage = new daum.maps.MarkerImage('/resources/images/marker/m_end.png',new daum.maps.Size(20, 20));

/** 차량 ON **/
var markerImage = new daum.maps.MarkerImage('/resources/images/marker/marker01.png', new daum.maps.Size(31, 35) );
/** 차량 OFF **/
var markerOffImage = new daum.maps.MarkerImage('/resources/images/marker/marker_off01.png', new daum.maps.Size(31, 35) );

var imageSize = new daum.maps.Size(32, 32);
var selector = null;
var selector2 = null;

var opts = null;
var polyline = null;
var isLoadingOpen = true;
var carNosForMultiView = new Array();
var lastOverlayCarInfo = null;

/** 객체 배열 **/
var carObjArray = new Array();
var routeObjArray = new Array();
var routeObjArray2 = new Array();
var oldRouteObjArray = new Array();
var oldRouteObjArray2 = new Array();
var centerObjArray = new Array();
var deliveryObjArray = new Array();
var carNos = new Array();
var markers = new Array();


/** 폴리라인 담는 객체들 **/
var locationHistoryPolyline = null;
var locationHistoryPolyline2 = null;
var oldLocationHistoryPolyline = null;
var oldLocationHistoryPolyline2 = null;

/** 마커 담는 객체들 **/
var carArrayList = new Array();
var carArrayListForMultiView = new Array();
var centerArrayList = new Array();
var deliveryArrayList = new Array();
var startMarker = null;
var endMarker = null;
var startMarker2 = null;
var endMarker2 = null;
var oldStartMarker = null;
var oldEndMarker = null;
var oldStartMarker2 = null;
var oldEndMarker2 = null;
var selectedMarker = null;
var selectedMarker2 = null;

var carListForMdid = getSessionStorage('tmsCarListFormdId');
var centers = getSessionStorage('tmsCenterList');
var deliveryList = getSessionStorage('tmsDeliveryList');
/** 선택상태 저장 **/
var selectedCenterCode = null;

/** 선택 팀(센터) 정보 저장 **/
var selected

var allowControllBox = new Array('drivingStatus/drivingStatus','drivingRoute/drivingRoute');

$.fn.TmsMap = function(o, init){
	selector = $(this).get(0);
	
	o = getDefaultOpts(o);
	
	opts = o;
	if( init == null || init ){
		$.TmsMapLayer.INIT.mapLayer($(this));
	}
	mapSetting(1);

};

$.fn.TmsMap2 = function(o){
	selector2 = $(this).get(0);
	
	o = getDefaultOpts(o);
	
	opts = o;
	
	mapSetting(2);

};

$.extend({
	TmsMap:{
		SET: {
			
			center : function(pos, isMultiView){
				//현재 맵의 중앙을 지정한다
				setMapCenter(pos, isMultiView);
			},
			zoom : function(lv, isMultiView){
				//맵의 줌 레벨을 변경
				setZoom(lv, isMultiView);
			},
			selector : function(obj){
				if( obj != null && obj.length > 0 ){
					selector = obj.get(0);
				}
			},
			loadingOpen : function (boo){
				isLoadingOpen = boo;
			},
			mapmode : function(type){
				changeMapType(type);
			},
			bounds : function(isMultiView){
				setBounds(isMultiView);
			},			
		},
		GET : {
			mapObj : function(){
				return mapObj;
			},
			opts : function(){
				return opts;
			},
			addr2coord : function(addr, callback){
				
				if( addr == null || callback == null ){
					return;
				}
				
				var geocoder = new daum.maps.services.Geocoder();

				geocoder.addr2coord(addr, callback);				
				
			}
		},
		REMOVE: {
			
			cars : function(isMultiView){
				removeCarMarker(isMultiView);
			},
			centers : function(){
				removeCenterMarker();
			},
			delivery : function(){
				removeDeliveryMarker();
			},
			carnumber : function(isMultiView){
				removeCarNo(isMultiView);
			},
			routeAll : function(isMultiView){
				
				if( isMultiView == null )
					isMultiView = false;
				
				if( !isMultiView ){		
					
					if( locationHistoryPolyline != null ){
						locationHistoryPolyline.setMap(null);
						routeObjArray = new Array();
						locationHistoryPolyline = null;
					}

					if( oldLocationHistoryPolyline != null ){
						oldLocationHistoryPolyline.setMap(null);
						oldRouteObjArray = new Array();
						oldLocationHistoryPolyline = null;
					}					
					
				}else{

					if( locationHistoryPolyline2 != null ){
						locationHistoryPolyline2.setMap(null);
						routeObjArray2 = new Array();
						locationHistoryPolyline2 = null;
					}	

					if( oldLocationHistoryPolyline2 != null ){
						oldLocationHistoryPolyline2.setMap(null);
						oldRouteObjArray2 = new Array();
						oldLocationHistoryPolyline2 = null;
					}						
					
					
				}				
				
			}
			
		},
		VISIBLE: {},		
		UTIL: {
			refresh : function(){
				if( mapObj != null ){
					mapObj.relayout();
					mapObj.setCenter( mapObj.getCenter() );
					mapObj.setLevel( mapObj.getLevel() );
				}
				
				if( mapObj2 != null ){
					mapObj2.relayout();
					mapObj2.setCenter( mapObj2.getCenter() );
					mapObj2.setLevel( mapObj2.getLevel() );
				}
				
			},
			loadingOpen : function(){
				
				if(!isLoadingOpen) return;
					
				var layer = $("#mapLoad");
				
				closeProcessing();
				
				if( $(layer).get(0) != null ){
					$(layer).remove();
				}
				
				var loadingDiv =	$('<div>', {
					id: "mapLoad"
				}).appendTo(selector);
				
				processing(loadingDiv,"로딩중입니다.");				
			}
		},
		GRID : {
			cars : function(mdIds){
				if(isNull(mdIds)){
					mdIds = new Array();
					var cars = getSessionStorage('tmsCarInfoForCarNo');
					
					$.each(cars, function (index, car) {
						mdIds.push(car.mdmTrmno);
					});
					
				}
				
				var url = "/drivingStatus/drivingCarDetailStatus.do";
				
				
				$.ajax(
			            {
			                url: url,
			                type:"POST",
			                data : {carMdIds : mdIds.join(",") },
			                dataType : "text",
			                cache: false,
			                success: function(data){
			                	
			                	gridCarMarker( data );
								
			                },
			                error:function(obj,e,msg)
			                {
			                	//alert('데이터로딩 실패.\n(시스템문제)\n' + msg);
			                	closeProcessing();
				            }
			            }
			    );				
				
				
			},
			selectCar : function(mdId, isMultiView){
				var mdIds = new Array();
				mdIds.push(mdId);
				
				
				if( isMultiView == null )
					isMultiView = false;
				
				var url = "/drivingStatus/drivingCarDetailStatus.do";
				
				
				$.ajax(
			            {
			                url: url,
			                type:"POST",
			                dataType : "text",
			                data : { carMdIds : mdIds.join(",") },
			                cache: false,
			                success: function(data){
			                	
			                	if( typeof data == "string" ){
			                		data = JSON.parse(data);
			                	}
			                	
			                	gridCarMarker( data, null, isMultiView );
			                	
			                	var pos = convertPos(data.result[0].latitude , data.result[0].longitude);
			                	//$.TmsMap.SET.center(pos, isMultiView);
			                	
			                	$.TmsMap.SET.bounds();
			                	
			        			$(".carSelectMark").hide();
			        			$("#carselect_"+(isMultiView ? 1 : 0)+"_"+mdId).show();			                	
								
			                },
			                error:function(obj,e,msg)
			                {
			                	alert('데이터로딩 실패.\n(시스템문제)\n' + msg);
			                	closeProcessing();
				            }
			            }
			    );					
				
			},
			selectCarForPos : function(mdId, lat, lnt, isRemove){

				if( isRemove == null )
					isRemove = true;
				
				var data = {result : [{ modemId : mdId, seq : "", latitude : lat, longitude : lnt }] };
				
				gridCarMarker( data, isRemove );
				
            	var pos = convertPos(lat , lnt);
            	$.TmsMap.SET.center(pos);		
            	
    			$(".carSelectMark").hide();
    			$("#carselect_0_"+mdId).show();	
    			
				
			},
			centers : function(){
				
				gridCenterMarker(centers);
			},
			delivery : function(){
				gridDeliveryMarker(deliveryList);
			},
			deliveryForCenter : function(centerCode){
				removeDeliveryMarker();
				selectedCenterCode = centerCode;
				
				var array_d = new Array();
				
				$.each(deliveryList, function (i, v) {
					if( centerCode == v.lkgDataCntrC ){
						if( v.lttd != null && (v.lttd).length > 0 && v.lgtd != null && (v.lgtd).length > 0)
							array_d.push(v);
					}
				});			
				
				if(array_d.length > 0)
					gridDeliveryMarker(array_d);
				
			},
			route : function(routes, isMultiView){
				
				if( isMultiView == null )
					isMultiView = false;
				
				if( !isMultiView ){		
					
					if( locationHistoryPolyline != null ){
						locationHistoryPolyline.setMap(null);
						routeObjArray = new Array();
					}
					locationHistoryPolyline = getLineOptForLocationHistory(routes.result, isMultiView);
					locationHistoryPolyline.setMap(mapObj);
					
					if( oldLocationHistoryPolyline != null ){
						var tmpRoutePolyline = oldLocationHistoryPolyline;
						oldLocationHistoryPolyline.setMap(null);
						oldLocationHistoryPolyline = tmpRoutePolyline;
						
						oldLocationHistoryPolyline.setMap(mapObj);
						
					}
					
				}else{

					if( locationHistoryPolyline2 != null ){
						locationHistoryPolyline2.setMap(null);
						routeObjArray2 = new Array();
					}
					locationHistoryPolyline2 = getLineOptForLocationHistory(routes.result, isMultiView);
					locationHistoryPolyline2.setMap(mapObj2);	
					
					if( oldLocationHistoryPolyline2 != null ){
						
						var tmpRoutePolyline = oldLocationHistoryPolyline2;
						oldLocationHistoryPolyline2.setMap(null);
						oldLocationHistoryPolyline2 = tmpRoutePolyline;
						
						oldLocationHistoryPolyline2.setMap(mapObj2);						
					}
					
				}
				
			},
			oldRoute : function(routes, isMultiView){
				if( isMultiView == null )
					isMultiView = false;
				
				if( !isMultiView ){		
					
					if( oldLocationHistoryPolyline != null ){
						oldLocationHistoryPolyline.setMap(null);
						oldRouteObjArray = new Array();
					}
					oldLocationHistoryPolyline = getLineOptForOldLocationHistory(routes.result, isMultiView);
					oldLocationHistoryPolyline.setMap(mapObj);
					
				}else{

					if( oldLocationHistoryPolyline2 != null ){
						oldLocationHistoryPolyline2.setMap(null);
						oldRouteObjArray2 = new Array();
					}
					oldLocationHistoryPolyline2 = getLineOptForOldLocationHistory(routes.result, isMultiView);
					oldLocationHistoryPolyline2.setMap(mapObj2);					
					
				}
				
			},
			selectedMarker : function(data, isMultiView){
				gridSelectedMarker(data, isMultiView);
			}
		},
		INIT : {}
		
	}
});

function mapSetting(no){
	
	$.TmsMap.UTIL.loadingOpen();
	
	 var mapOpt = getMapOpt();
	 
	 
	 switch (no) {
	 	case 1:
			 if(mapObj == null) mapObj = new daum.maps.Map(selector, mapOpt );
			 var control = new daum.maps.ZoomControl();
			 mapObj.addControl(control, daum.maps.ControlPosition.TOPRIGHT);		
		 break;

	 	case 2:
			 if(mapObj2 == null) mapObj2 = new daum.maps.Map(selector2, mapOpt );
			 var control2 = new daum.maps.ZoomControl();
			 mapObj2.addControl(control2, daum.maps.ControlPosition.TOPRIGHT);
		 break;
	}
	 
	 var allowctlbox = false;
	 var loc = location.href;
	 
	 for( var i=0; i<allowControllBox.length; i++ ){
		 
		 if( loc.indexOf(allowControllBox[i]) != -1 ){
			 allowctlbox = true;
		 }
	 }
	 
	 if( allowctlbox ){
		 var controllbox = "";
		 $("#mapControllBox").remove();
		 
		 
		 controllbox += ' <div class="map_mark" id="mapControllBox" style="z-index: 9999;" > ';
		 controllbox += ' 	<p><input type="checkbox" id="cb1" > <label for="cb1">센터</label></p> ';
		 controllbox += ' <p><input type="checkbox" id="cb2"  > <label for="cb2">배송처</label></p> ';
		 controllbox += ' </div>	 ';
		 
		 $("body").append(controllbox);
		 
		 $("#cb1").click(function(){
			 if( $("#cb1").prop("checked") ){
				 $.TmsMap.GRID.centers();	 
				 $.TmsMap.SET.bounds();
			 }else{
				 $.TmsMap.REMOVE.centers();	
			 }
		 });
		 
		 $("#cb2").click(function(){
			 if( $("#cb2").prop("checked") ){
				 if( selectedCenterCode == null || selectedCenterCode.length <= 5 ){
					 alert("선택된 센터가 존재하지 않습니다.");
					 $(this).prop("checked", false);
					 
					 return;
				 }
				 
				 $.TmsMap.GRID.deliveryForCenter(selectedCenterCode);	 
			 }else{
				 $.TmsMap.REMOVE.delivery();	
			 }
		 });	 
	 }
	$.TmsMap.UTIL.refresh();
}



function getMapOpt(){
	startPoint = convertPos(37.566826005485716,126.9786567859313);
	
	var zoomLv = 10;
	

	mapOpt = {
		center: startPoint,
		level: zoomLv
	};
	
	return mapOpt;
}

function makeCarNo(carmdId, pos, isMultiView){
	
	var carInfo = carListForMdid[carmdId];
	
	var carNoTxt = carInfo == null ? "정보가 없습니다." : carInfo.vhcno;
	
	if( carNos != null ){
		var content = "<div class='carNoDiv'  ondragstart='return false' onselectstart='return false' ";
			content +=	" style=\"";
			content +=	"color: #000000!important; ";
			content +=	"white-space: nowrap; ";
			content +=	"padding: 2px 4px; ";
			content +=	"font-family: ";
			content +=	"'Nanum Gothic'; ";
			content +=	"font-size: 11px; ";
			content +=	"font-weight: bold; ";
			content +=	"z-index: 100; ";
			content +=	"left: 920.5px; ";
			content +=	"top: 470.5px; ";
			content +=	"display: block; ";
			content +=	" -ms-filter: 'progid:DXImageTransform.Microsoft.gradient(startColorstr=#7fFFFFFF endColorstr=#7fFFFFFF)';  zoom:1;";
			content +=	"border: 2px solid #868181;";
			content +=	" \" >"+carNoTxt+"</div> ";
		
	    var customOverlay = new daum.maps.CustomOverlay({
	        map: isMultiView ? mapObj2 : mapObj,
	        clickable: false,
	        content: content,
	        position: pos,
	        xAnchor: 0.5,
	        yAnchor: -0.2,
	        zIndex: 1003
	    });
			
	    //customOverlay.setMap(mapObj);
	    
	    if(isMultiView){
	    	carNosForMultiView.push(customOverlay);
	    }else{
	    	carNos.push(customOverlay);
	    }
	}
}

function removeCarNo(isMultiView){
	var cn = new Array();
	
	if( isMultiView ){
		cn = carNosForMultiView == null ? new Array() : carNosForMultiView;
	}else{
		cn = carNos == null ? new Array() : carNos;
	}
	
	 for (var i = 0; i < cn.length; i++) {
		 cn[i].setMap(null);
	 }    	
	
	 cn = new Array();	
}

function convertPos(x, y){
	
	var cx = x, cy = y;
	
	if( Number(x) > Number(y) ){
		cx = y;
		cy = x;
	}
	
	if( Number(x) == 0 && Number(y) == 0 ){
		return null;
	}else{
		return new daum.maps.LatLng(cx , cy); 	
	}
	
}


function changeMapType(type){
	
	switch (type) {
	case 'hybrid':
		mapObj.setMapTypeId(daum.maps.MapTypeId.HYBRID); 
		if( mapObj2 != null ){
			mapObj2.setMapTypeId(daum.maps.MapTypeId.HYBRID);	
		}
		break;
	case 'sky':
		mapObj.setMapTypeId(daum.maps.MapTypeId.SKYVIEW ); 
		if( mapObj2 != null ){
			mapObj2.setMapTypeId(daum.maps.MapTypeId.SKYVIEW);	
		}		
		break;
	case 'normal':
	default : mapObj.setMapTypeId(daum.maps.MapTypeId.ROADMAP ); 
	if( mapObj2 != null ){
		mapObj2.setMapTypeId(daum.maps.MapTypeId.ROADMAP);	
	}		
	break;
	}
	
}



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

function setMapCenter(pos, isMultiView){
	
	if( isMultiView != null && isMultiView ){
		if(mapObj2 != null) mapObj2.setCenter(pos);
	}else{
		if(mapObj != null) mapObj.setCenter(pos);	
	}
	
}

function setZoom(lv, isMultiView){
	
	if( isMultiView != null && isMultiView ){
		if(mapObj2 != null) mapObj2.setLevel(lv);
	}else{
		if(mapObj != null) mapObj.setLevel(lv);	
	}
	
}


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

function carInfoOverlay(opt, isMultiView, mdId, carNo){
	var contentLayout = '';
	
	contentLayout += ' <div id="carInfoOverlay" class="popup_table" style="position: relative; top: 0px; left: 0px;"  >';
	contentLayout += ' </div> ';
 	
	
    if( lastOverlayCarInfo != null ){
    	lastOverlayCarInfo.setMap(null);
    }
    var customOverlay = new daum.maps.CustomOverlay({
    	map: (isMultiView ? mapObj2 : mapObj),
        clickable: false,
        content: contentLayout,
        position: opt.position,
        xAnchor: 0.5,
        yAnchor: 60,
        zIndex: 1005
    });
    customOverlay.setMap((isMultiView ? mapObj2 : mapObj)); 
    lastOverlayCarInfo = customOverlay;
    
	var carInfoForMdId = getSessionStorage('tmsCarListFormdId');
	$("input[name=carMdIds]").val(mdId);
	$("input[name=carNo]").val(carNo);
	
	if( $("input[name=isOverLayPop]")[0] == null ){
		$("form[name=frmForDetail]").append(
			$("<input>",{
				type : "hidden"
				, name : "isOverLayPop"
				, value : "true"
			})
		
		);
	}
	
	processing();
	
	$("input[name=carInfo]").val( encodeURIComponent(JSON.stringify(carInfoForMdId[mdId])) );
	getListData("carInfoOverlay", "/drivingStatus/drivingStatusDetailPop.do", 'frmForDetail', function(){
		
	    $("#carInfoOverlay .closePopClass").bind('click',function(){
	    	$(this).unbind('click');
	    	customOverlay.setMap(null);
	    });		
		
		$(".carSelectMark").hide();
		$("#carselect_"+(isMultiView ? 1 : 0)+"_"+mdId).show();		
		
		$("input[name=isOverLayPop]").remove();
		closeProcessing();
	});
	
}

function gridSelectedMarker(data, isMultiView){
	if(isMultiView){
		if( selectedMarker2 != null ){
			selectedMarker2.setMap(null);
			selectedMarker2 = null;
		}
		
	}else{
		if( selectedMarker != null ){
			selectedMarker.setMap(null);
			selectedMarker = null;
		}
	}
	
	var selectedMarkerImage = new daum.maps.MarkerImage(
		    '/resources/images/marker/selected.gif',
		    new daum.maps.Size(25, 25)
		);

	if( data.lat != null && data.lng != null ){
		var pos = convertPos(data.lat , data.lng);
		if( pos != null ){
		    marker = new daum.maps.Marker({
		    	map: isMultiView ? mapObj2 : mapObj,
		        position: pos,
		        title : data.title == null ? "" : data.title,
		        image : selectedMarkerImage,
		        zIndex : 1004
		    });
		    
		    
		    if(isMultiView){
		    	selectedMarker2 = marker;
		    }else{
		    	selectedMarker = marker;
		    }
		}
	}
	
}

function gridCarMarker(data, isRemove, isMultiView){
	
	if(isRemove == null)
		isRemove = true;
	
	if(isRemove){
		removeCarMarker(isMultiView);
		removeCarNo(isMultiView);
	}
	
	if( typeof data == "string" ){
		data = JSON.parse(data);
	}
	
	$.each(data.result, function (index, car) {
		
		if( car.latitude != "null" && car.longitude != "null" ){
			var pos = convertPos(car.latitude , car.longitude);
			if( pos != null ){
				var carInfo = carListForMdid[car.modemId];
				
			    marker = new daum.maps.Marker({
			    	map: isMultiView ? mapObj2 : mapObj,
			        position: pos,
			        title : carInfo == null ? "정보가 없습니다." : carInfo.vhcno, 
			        image : ( car.dataStatus != null && car.dataStatus == '27' ) ? markerOffImage : markerImage ,
			        zIndex : 1004
			    });		
			    $(marker.a).append("<img class='carSelectMark' id='carselect_"+(isMultiView ? 1 : 0)+"_"+car.modemId+"' src='/resources/images/marker/car_focus_icon.png' style='width: 52px; left: -11px; top: -8px; position: absolute; display:none; z-index: -1' />");
			    
			    makeCarNo(car.modemId, pos, isMultiView);
			    
			    
			    if( car != null ){
			    	marker.setClickable(true);
			    	daum.maps.event.addListener(marker, 'click', function(){
			    		carInfoOverlay({
			    			position : pos
			    		}
			    		, isMultiView
			    		, car.modemId
			    		, carInfo.vhcno
			    		);
			    	});	    
			    }
			    
			    if(isMultiView){
			    	carArrayListForMultiView.push(marker);
			    }else{
			    	carArrayList.push(marker);
			    }
			    carObjArray.push(pos);
			}
		}
	    
	});
	if(!isMultiView){
		$.TmsMap.SET.bounds();
	}
	
	$('.grayscale').toggleClass('grayscale-off');
	
}

function removeCarMarker(isMultiView){
	
	if( isMultiView == null )
		isMultiView = false;
	
	var a = new Array();
	
    if(isMultiView){
    	a = carArrayListForMultiView == null ? new Array() : carArrayListForMultiView;
    }else{
    	a = carArrayList == null ? new Array() : carArrayList;
    }
    
	
	
	 for (var i = 0; i < a.length; i++) {
		 a[i].setMap(null);
	 }    	
	 
	 if( !isMultiView ){
		 
		 if(!isNull(startMarker))
			 startMarker.setMap(null);

		 if(!isNull(endMarker))
			 endMarker.setMap(null);
		 
		 if(!isNull(oldStartMarker))
			 oldStartMarker.setMap(null);
		 
		 if(!isNull(oldEndMarker))
			 oldEndMarker.setMap(null);
		 
		 if(!isNull(selectedMarker))
			 selectedMarker.setMap(null);
		 
		 startMarker = null;
		 endMarker = null;	
		 oldStartMarker = null;
		 oldEndMarker = null;	
		 selectedMarker = null;		 

	 } else {
		
		 if(!isNull(startMarker2))
			 startMarker2.setMap(null);

		 if(!isNull(endMarker2))
			 endMarker2.setMap(null);
		 
		 if(!isNull(oldStartMarker2))
			 oldStartMarker2.setMap(null);
		 
		 if(!isNull(oldEndMarker2))
			 oldEndMarker2.setMap(null);
		 
		 if(!isNull(selectedMarker2))
			 selectedMarker2.setMap(null);		
		 
		 startMarker2 = null;
		 endMarker2 = null;
		 oldStartMarker2 = null;
		 oldEndMarker2 = null;
		 selectedMarker2 = null;		 
		 
	 }
	 
	 a = new Array();
	 carObjArray = new Array();
}

function gridCenterMarker(data){
	
	var coltrollbox1 = $("#cb1");
	var coltrollbox2 = $("#cb1");
	
	if( isNull($(coltrollbox1)[0]) || isNull($(coltrollbox2)[0]) ){
		closeProcessing();
		return;
	}
	
	processing();
	removeCenterMarker();
	
	if( !$("#cb1").prop("checked") ){
		closeProcessing();
		return;
	}
	
	if( isNull(selectedCenterCode) ){
		alert("선택된 팀/센터 정보가 없습니다.");
		closeProcessing();
		return;
	}
	
	if( typeof data == "string" ){
		data = JSON.parse(data);
	}
	
	$.each(data, function (index, center) {
		
		var target =  selectedCenterCode.length <= 5 ? center.teamCode : center.lkgDataCntrC;
		
		if( (target).indexOf(selectedCenterCode) != -1 ){
		
			var pos = convertPos(center.lttd , center.lgtd);
			if( pos != null ){
			    marker = new daum.maps.Marker({
			    	map: mapObj,
			        position: pos,
			        title : center.cntrAbrNm, 
			        image : centerMarkerImage,
			        zIndex : 1003
			    });		
				
			    $(marker.a).append("<img class='centerSelectMark' id='centerSelect_"+center.lkgDataCntrC+"' src='/resources/images/marker/branch_focus_icon.png' style='width: 52px; left: -6px; top: -8px; position: absolute; display:none; ' />");
			    
			    centerArrayList.push(marker);
			    centerObjArray.push(pos);
			}
		    
		}
		
	});
	
	if( selectedCenterCode.length > 5 ){
		$.TmsMap.GRID.deliveryForCenter(selectedCenterCode);
	}else{
		$.TmsMap.SET.bounds();
		$.TmsMap.SET.refresh;
	}
	
	closeProcessing();
}

function removeCenterMarker(){
	
	centerArrayList = centerArrayList == null ? new Array() : centerArrayList;
	
	 for (var i = 0; i < centerArrayList.length; i++) {
		 centerArrayList[i].setMap(null);
	 }    	
	
	 centerArrayList = new Array();
	 centerObjArray = new Array();
}

function gridDeliveryMarker(data){
	removeDeliveryMarker();
	if( !$("#cb2").prop("checked") )
		return;
	
	if( isNull(selectedCenterCode) || selectedCenterCode.length <= 5 ){
		alert("선택된 센터 정보가 없습니다.");
		return;
	}	
	
	if( typeof data == "string" ){
		data = JSON.parse(data);
	}
	
	$.each(data, function (index, delivery) {
		if( (delivery.lkgDataCntrC).indexOf(selectedCenterCode) != -1 ){
			var pos = convertPos(delivery.lttd , delivery.lgtd);
			if( pos != null ){
			    marker = new daum.maps.Marker({
			    	map: mapObj,
			        position: pos,
			        title : delivery.dvybrNm + "\r\n" + delivery.repmNm, 
			        image : deliveryMarkerImage,
			        zIndex : 1001
			    });		
			    $(marker.a).append("<img class='deliverySelectMark' id='deliverySelect_"+delivery.lkgDataDvybrC+"' src='/resources/images/marker/branch_focus_icon.png' style='width: 52px; left: -10px; top: -10px; position: absolute; display:none; ' />");
			    deliveryArrayList.push(marker);
			    deliveryObjArray.push(pos);			
			}
		}
	});
	
	//if(deliveryObjArray != null && deliveryObjArray.length > 0)
		$.TmsMap.SET.bounds();	
		$.TmsMap.SET.refresh;
}

function removeDeliveryMarker(){
	
	deliveryArrayList = deliveryArrayList == null ? new Array() : deliveryArrayList;
	
	 for (var i = 0; i < deliveryArrayList.length; i++) {
		 deliveryArrayList[i].setMap(null);
	 }    	
	
	 deliveryArrayList = new Array();
	 deliveryObjArray = new Array();
}

function getLineOptForLocationHistory(route, isMultiView){
	
	var path = new Array();
	
	$.each(route, function (index, data) {
		var p = convertPos(data.latitude, data.longitude);
		if( p != null ){
			if(index == 0){
				gridStartMarker(p, isMultiView);
			}
			
			path.push(p);
			
			if( !isMultiView ){
				routeObjArray.push(p);
			}else{
				routeObjArray2.push(p);
			}
		}
	});
	
	if( path.length > 0 ){
		gridEndMarker( path[path.length - 1], isMultiView );
	}
	
	var polyline = new daum.maps.Polyline({
	    path: path, 
	    strokeWeight: 3, 
//	    strokeColor: '#FF0000',
	    strokeColor: '#2B42E6', 
	    strokeOpacity: 1, 
	    strokeStyle: 'solid',
	    zIndex: 1999
	});	
	$.TmsMap.SET.bounds(isMultiView);
	return polyline;
}


function getLineOptForOldLocationHistory(route, isMultiView){
	
	var path = new Array();
	
	$.each(route, function (index, data) {
		var p = convertPos(data.latitude, data.longitude);
		if( p != null ){
			if(index == 0){
				gridOldStartMarker(p, isMultiView);
			}
			
			path.push(p);
			
			if( !isMultiView ){
				oldRouteObjArray.push(p);
			}else{
				oldRouteObjArray2.push(p);
			}
		}
	});
	
	if( path.length > 0 ){
		gridOldEndMarker( path[path.length - 1], isMultiView );
	}
	
	var polyline = new daum.maps.Polyline({
	    path: path, 
	    strokeWeight: 3, 
//	    strokeColor: '#2B42E6',
	    strokeColor: '#FF0000', 
	    strokeOpacity: 1, 
	    strokeStyle: 'solid',
	    zIndex: 2000
	});	
	$.TmsMap.SET.bounds(isMultiView);
	return polyline;
}

function gridStartMarker(pos, isMultiView){
	
	if( !isMultiView ){
		if( startMarker != null ){
			startMarker.setMap(null);
		}
	}else{
		if( startMarker2 != null ){
			startMarker2.setMap(null);
		}		
	}
	
    marker = new daum.maps.Marker({
    	map: isMultiView ? mapObj2 : mapObj,
        position: pos,
        title : "경로 시작", 
        image : startMarkerImage,
        zIndex : 1002
    });		
	
    if( !isMultiView ){
    	startMarker = marker;
    }else{
    	startMarker2 = marker;
    }    
	
}

function gridEndMarker(pos, isMultiView){
	
	if( !isMultiView ){
		if( endMarker != null ){
			endMarker.setMap(null);
		}
	}else{
		if( endMarker2 != null ){
			endMarker2.setMap(null);
		}		
	}
	
    marker = new daum.maps.Marker({
    	map: isMultiView ? mapObj2 : mapObj,
        position: pos,
        title : "경로 종료", 
        image : endMarkerImage,
        zIndex : 1002
    });		
	
    if( !isMultiView ){
    	endMarker = marker;
    }else{
    	endMarker2 = marker;
    }

}


function gridOldStartMarker(pos, isMultiView){
	
	if( !isMultiView ){
		if( oldStartMarker != null ){
			oldStartMarker.setMap(null);
		}
	}else{
		if( oldStartMarker2 != null ){
			oldStartMarker2.setMap(null);
		}		
	}
	
    marker = new daum.maps.Marker({
    	map: isMultiView ? mapObj2 : mapObj,
        position: pos,
        title : "경로 시작", 
        image : startMarkerImage,
        zIndex : 1002
    });		
	
    if( !isMultiView ){
    	oldStartMarker = marker;
    }else{
    	oldStartMarker2 = marker;
    }    
	
}

function gridOldEndMarker(pos, isMultiView){
	
	if( !isMultiView ){
		if( oldEndMarker != null ){
			oldEndMarker.setMap(null);
		}
	}else{
		if( oldEndMarker2 != null ){
			oldEndMarker2.setMap(null);
		}		
	}
	
    marker = new daum.maps.Marker({
    	map: isMultiView ? mapObj2 : mapObj,
        position: pos,
        title : "경로 종료", 
        image : endMarkerImage,
        zIndex : 1002
    });		
	
    if( !isMultiView ){
    	oldEndMarker = marker;
    }else{
    	oldEndMarker2 = marker;
    }

}

function setBounds(isMultiView){
	
	if( isMultiView == null )
		isMultiView = false;
	
	var source = new daum.maps.LatLngBounds();
	
	if( carObjArray != null && carObjArray.length > 0 ){
		for(var i=0; i<carObjArray.length; i++){
			source.extend(carObjArray[i]);
		}
	}
	
	if( !isMultiView ){
		
		
		if( routeObjArray != null && routeObjArray.length > 0 ){
			for(var i=0; i<routeObjArray.length; i++){
				if(routeObjArray[i] != null) {
					source.extend(routeObjArray[i]);
				}
			}
		}

		if( oldRouteObjArray != null && oldRouteObjArray.length > 0 ){
			for(var i=0; i<oldRouteObjArray.length; i++){
				if(oldRouteObjArray[i] != null) {
					source.extend(oldRouteObjArray[i]);
				}
			}
		}		
		
		if( startMarker != null){
			source.extend(startMarker.getPosition());
		}
		
		if( endMarker != null){
			source.extend(endMarker.getPosition());
		}				
		
		if( oldStartMarker != null){
			source.extend(oldStartMarker.getPosition());
		}
		
		if( oldEndMarker != null){
			source.extend(oldEndMarker.getPosition());
		}			
		
	}else{
		
		if( routeObjArray2 != null && routeObjArray2.length > 0 ){
			for(var i=0; i<routeObjArray2.length; i++){
				if(routeObjArray2[i] != null) {
					source.extend(routeObjArray2[i]);
				}
			}
		}

		if( oldRouteObjArray2 != null && oldRouteObjArray2.length > 0 ){
			for(var i=0; i<oldRouteObjArray2.length; i++){
				if(oldRouteObjArray2[i] != null) {
					source.extend(oldRouteObjArray2[i]);
				}
			}
		}		
		
		if( startMarker2 != null){
			source.extend(startMarker2.getPosition());
		}
		
		if( endMarker2 != null){
			source.extend(endMarker2.getPosition());
		}	
		
		if( oldStartMarker2 != null){
			source.extend(oldStartMarker2.getPosition());
		}
		
		if( oldEndMarker2 != null){
			source.extend(oldEndMarker2.getPosition());
		}			
		
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
		if( !isMultiView ){
			mapObj.setBounds(source);
		}else{
			mapObj2.setBounds(source);
		}
	}
}