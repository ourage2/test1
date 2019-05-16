var leftAreaId = ".colgroup-tempnowl";
var rightAreaId = "#drive_right";
var topAreaId = "#top_area";
var searchAreaId = "#search_area";
var multiviewId = "#view_right_map";
var bottomAreaId1 = "#view_left_bottom";
var bottomAreaId2 = "#view_right_bottom";

var mapContainer = null;

/*var centerList = getSessionStorage('cvoCenterList');
var centerList = getSessionStorage('cvoCenterList');
var vhclList =  getSessionStorage('cvoCarInfoForCenter');*/

var centerList;
var vhclList;

var schParams = {
		selectedCode : '', 
		isCenter : false
	};
$.extend({
	CvoMapLayer:{
		INIT : {
			mapLayer : function(selector){
				
				mapContainer = selector != null ? selector : mapContainer;
				
				var height = $( document ).height() - 8;
				var width = $( document ).width() - 5;
				var leftObj = $(leftAreaId);
				var rightObj = $(rightAreaId);
				
				var leftLayer = $(leftObj);
				var rightLayer = $(rightObj);
				
				if( $(leftLayer)[0] != null && $(leftLayer).is(':visible') ){
					width = width - $(leftLayer).width();
				}

				if( $(rightLayer)[0] != null && $(rightLayer).is(':visible') ){
					width = width - $(rightLayer).width(); 
				}
				
				//console.log("width ===> " + width);
				//$(mapContainer).css("width", width-20 + "px");
				$(mapContainer).css("width", width + "px");
								
				$.CvoMap.UTIL.refresh();
				$.CvoMap.SET.bounds();
			}
		},
		SHOW : {
			leftArea : function(){
				$(".map_btn.min").hide();				
				$.CvoMap.UTIL.refresh();
				
				$(leftAreaId).fadeIn(300, function(){
					$(".map_btn.max").show();
					$.CvoMapLayer.INIT.mapLayer(null,false);
					
					if ( $("#grid3").length > 0 ) {
						$('#grid3').jqGrid("setGridWidth", $(mapContainer).width());
					}
				});
			}
		},
		HIDE : {
			leftArea : function(){
				$(".map_btn.max").hide();
				$(leftAreaId).fadeOut(300, function(){
					$(".map_btn.min").show();
					//$(mapContainer).css("margin-right","0px");
					$.CvoMapLayer.INIT.mapLayer(null);
					
					if ( $("#grid3").length > 0 ) {
						$('#grid3').jqGrid("setGridWidth", $(mapContainer).width());
					}
				});
			}
		}
		
	}
});