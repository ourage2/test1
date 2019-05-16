<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp"%>

<script>
var view1p$;
var srchp$;
var map$;
var daumMap;
var daumBounds;
var daumGeocoder;
var initCnt = 0;
var xpos = 37.56683321058658;
var ypos = 126.97864093719429;
var markers = [];
// var infos = [];
var customs = [];
var lastAgentCd;
var overlayHtml = '<div id="over_%agentCd%" class="popup_table" style="display: none;">'
			+ '<table>'
			+ '	<colgroup>'
			+ '		<col width="105">'
			+ '		<col width="140">'
			+ '		<col width="105">'
			+ '		<col width="140">'
			+ '	</colgroup>'
			+ '	<thead>'
			+ '		<tr>'
			+ '		<th colspan="4">'
			+ '		%agentNm% (%agentCd%)'
			+ '		<a href="javascript:fnOverClose(\'%agentCd%\');" class="closePopClass">닫기</a>'
			+ '		</th>'
			+ '		</tr>'
			+ '	</thead>'
			+ '	<tbody>'
// 			+ '		<tr>'
// 			+ '		<td class="pt_head no_b">대리점명</td>'
// 			+ '		<td>%agentNm%</td>'
// 			+ '		<td class="pt_head no_b">대리점코드</td>'
// 			+ '		<td>%agentCd%</td>'
// 			+ '		</tr>'
			+ '		<tr>'
			+ '		<td class="pt_head no_b">소속센터</td>'
			+ '		<td>%centerNm%</td>'
			+ '		<td class="pt_head no_b">담당자명</td>'
			+ '		<td>%staffNm%</td>'
			+ '		</tr>'
			+ '		<tr>'
			+ '		<td class="pt_head no_b">휴대폰</td>'
			+ '		<td>%staffHpNo%</td>'
			+ '		<td class="pt_head">전화번호</td>'
			+ '		<td>%staffTelNo%</td>'
			+ '		</tr>'
			+ '		<tr>'
			+ '		<td class="pt_head no_b">주소</td>'
			+ '		<td colspan="3">%cvoAddr%</td>'
			+ '		</tr>'
			+ '		<tr>'
			+ '		<td class="pt_head no_b">위도</td>'
			+ '		<td>%xpos%</td>'
			+ '		<td class="pt_head">경도</td>'
			+ '		<td>%ypos%</td>'
			+ '		</tr>'
			+ '	</tbody>'
			+ '</table>'
			+ '</div>';


jQuery(function($) {
	view1p$ = com.toBox($('#popView1'));
	srchp$ = com.toBox($('#popSrch'));

	var opt = {center : new daum.maps.LatLng(xpos, ypos)};
	map$ = new daum.maps.Map(document.getElementById('popMap'), opt);
	daum.maps.event.addListener(map$, 'tilesloaded', mapInit);

	//다음지도 로드
	function mapInit() {
		initCnt++;
// 		console.log(initCnt);
		var loc = new daum.maps.LatLng(xpos, ypos);
		map$.setCenter(loc);
		map$.relayout();

		if (initCnt >= 3) {
			var control = new daum.maps.ZoomControl();
			map$.addControl(control, daum.maps.ControlPosition.TOPRIGHT);
			srchp$.find('[name=srchCenterCd]').chosen({width: '95%'});
			daum.maps.event.removeListener(map$, 'tilesloaded', mapInit); //tiles로드 제거
		}
	}

	//페이지 초기화
	function init() {

		srchp$.find('.enterSrch').keydown(function(event) {
			if (event.which == 13) {
				$(this).parent().parent().parent().find('button').each(function(){
					if(this.type == 'button') {
						$(this).trigger('click');
					}
				});
			}
		});

		com.setCombo('select', srchp$, 'srchCenterCd', '${paramBox.srchCenterCd}', com.sAuthCenterList()); //콤보 list를 가지고 그릴 경우
		com.setCombo('select', srchp$, 'srchAreaCd', '${paramBox.srchAreaCd}', com.getCdList('AREA_CD'), '전체');
		srchp$.find('[name=srchWord]').val('${paramBox.srchWord}');

// 		$('#srchPopBtn').trigger('click');
	}

	//검색
	$('#srchPopBtn').on('click', function() {
// 		var agentMarker = new daum.maps.Marker();
// 		var infowindow = new daum.maps.InfoWindow();
		var customOverlay = new daum.maps.CustomOverlay();
		var posArry = new daum.maps.LatLngBounds();
		onm.ajax({
			url: _contextPath_ + '/manage/basis/agentLoc.json',
			data: com.set(srchp$),
			success: function(res) {

				var row;
				markerCnt = res.list.length;
				for (var idx = 0; idx < markers.length; idx++) {
					markers[idx].setMap(null);
// 					infos[idx].close();
					customs[idx].setMap(null);
				}
				markers = [];
// 				infos = [];
				customs = [];

				if (markerCnt > 0) {
					for (var idx = 0; idx < res.list.length; idx++) {
						row = res.list[idx];
						var pos = new daum.maps.LatLng(row.xpos, row.ypos);
						agentMarker = new daum.maps.Marker({
							position: pos,
							title: row.agentNm,
							image: midMarkerImage, // 마커이미지 설정
							zIndex : 1004,
							map: map$
						});

						// 인포윈도우로 장소에 대한 설명을 표시합니다
// 						infowindow = new daum.maps.InfoWindow({
// 							content : '<div style="width:' + row.agentNm.length * 17 + 'px;text-align:center;padding:6px 0;">' + row.agentNm + '</div>',
// 						});
// 						infowindow.open(map$, agentMarker);

						var overHtml = overlayHtml.replaceAll('%agentCd%', row.agentCd).replaceAll('%agentNm%', row.agentNm)
							.replaceAll('%centerNm%', row.centerNm).replaceAll('%staffNm%', row.staffNm).replaceAll('%staffHpNo%', $.fn.fmatter.tel(row.staffHpNo))
							.replaceAll('%staffTelNo%', $.fn.fmatter.tel(row.staffTelNo)).replaceAll('%cvoAddr%', row.cvoAddr).replaceAll('%xpos%', row.xpos)
							.replaceAll('%ypos%', row.ypos);
						customOverlay = new daum.maps.CustomOverlay({
							map: map$,
							clickable: false,
// 							content: '<div><font color="blue">' + row.agentNm + '</font></div>' + overHtml,
							content: '<div>&nbsp;</div>' + overHtml,
							position: pos,
							xAnchor: 0.5,
							yAnchor: -1.5,
							zIndex: 1005
						});

						daum.maps.event.addListener(agentMarker, 'click', markerClickListener(map$, row.agentCd, pos));
						function markerClickListener(thisMap, thisAgentCd, thisPos) {
							return function() {
// 								console.log($('[id*=over_]'));
								$('[id*=over_]').hide();
// 	 							console.log(thisAgentCd);
	 							thisMap.setLevel(5);
	 							thisMap.panTo(thisPos);
// 	 							if (lastAgentCd) { $('#over_' + lastAgentCd).hide(); }
								$('#over_' + thisAgentCd).show();
								lastAgentCd = thisAgentCd;
							};
						}

						/*
						(function(agentMarker, customOverlay) {
							// 마커에 mouseover 이벤트를 등록하고 마우스 오버 시 인포윈도우를 표시합니다
							daum.maps.event.addListener(agentMarker, 'click', function() {
	 							console.log(row.agentCd);
	 							map$.setLevel(4);
	 							map$.setCenter(pos);
	 							$('#over_' + row.agentCd).show();
// 	 							fnOverOpen(row.agentCd);
							});
						})(agentMarker, customOverlay);*/

						posArry.extend(pos);
						markers.push(agentMarker);
// 						infos.push(infowindow);
						customs.push(customOverlay);
					}

					map$.setBounds(posArry);
				}

			}
		});
	});

	init();
});

function fnOverClose(agentCd) {
	$('#over_' + agentCd).hide();
}
</script>

<style>
	.popup_table {/*position:absolute; top:238px; left:304px; */ width:490px; border:2px solid #3f5f87; background:#ffffff; z-index:1000; margin-top: -245px;}
	.popup_table th {background:#3f5f87; height:34px; line-height:32px; color:#ffffff; text-align:left; padding-left:35px;}
	.popup_table th a {display:inline; position:absolute; top:0px; right:0px; width:17px; height:17px; background:url("<c:url value="/resources/image/map/popup_close.gif" />") 0 0 no-repeat; text-indent:-999999em; margin:7px 7px 0 0;}
	.popup_table td {height:30px; line-height:30px; text-align:left; border-bottom:1px solid #d2d2d2; padding-left:10px; font-size:11px;}
	.popup_table .pt_head {background:#ececec; font-weight:bold; border-right:1px solid #d2d2d2;  border-left:1px solid #d2d2d2;}
	.popup_table .pt_on {background:#3f5f87 url("<c:url value="/resources/image/map/icon_on2.gif" />") 8px 12px no-repeat;}
	.popup_table .pt_off {background:#3f5f87 url("<c:url value="/resources/image/map/icon_off2.gif" />") 8px 12px no-repeat;}
	.popup_table .no_b {border-left:none;}
	.popup_table td a {display:inline; padding:2px 10px 4px 10px; border-radius:3px; margin-left:5px; font-weight:bold; border:1px solid #373737; background:#444444; color:#ffffff;}
</style>

<div id="popView1" class="popup-content" style="width: 1150px;">

	<header>
		<div id="popSrch">
			<div class="srch_box">

				<input type="hidden" name="locYn" value="Y" />
				<table>
					<colgroup>
						<col width="9%">
						<col width="15%">
						<col width="10%">
						<col width="25%">
						<col width="10%">
						<col width="17%">
						<col width="*">
					</colgroup>
					<tr>
						<th>지역</th>
						<td>
							<select name="srchAreaCd"></select>
						</td>
						<th>센터</th>
						<td>
							<select name="srchCenterCd" class="chosen" multiple data-placeholder="전체"></select>
						</td>
						<th>대리점명</th>
						<td>
							<input type="text" name="srchAgentNm" maxlength="20" style="width:100px" class="enterSrch" />
						</td>
						<td>
							<div class="srch_btn">
								<button type="button" id="srchPopBtn" class="btn_srch"><span class="ico_srch"></span>검색</button>
							</div>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</header>

	<div class="colgroup-wrap">
		<div id="popMap" style="border: 1px solid; height: 530px; z-index:0"></div>
	</div>

</div>
