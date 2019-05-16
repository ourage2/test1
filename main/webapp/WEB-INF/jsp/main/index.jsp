<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>
<c:set value="${pageContext.request.contextPath}" var="contextPath" />
<%-- <c:if test="${not empty sessionScope[cmnConst.sesUserData] and util:uriStartsMatch(pageContext.request, '/manage,/main/index')}"> --%>

<c:choose>
	<c:when test="${empty sessionScope[cmnConst.sesUserData] }">
		<meta http-equiv="refresh" content="0;url=${pageContext.request.contextPath}/main/login.do">
	</c:when>

	<c:otherwise>
		<script>
			$(function($) {
				var menuHtml =
					  '<ul>'
					+ '	<li><a href="javascript:;">환경설정</a>'
					+ '		<ul>'
					+ '			<li url="${contextPath}/manage/set/noticeList.ifm"><a href="javascript:;">공지사항 관리</a></li>'
					+ '			<li url="${contextPath}/manage/set/qnaList.ifm"><a href="javascript:;">1:1문의 관리</a></li>'
					+ '			<li url="${contextPath}/manage/set/cdList.ifm"><a href="javascript:;">코드 관리</a></li>'
					+ '			<li url="${contextPath}/manage/set/msgList.ifm"><a href="javascript:;">메시지 관리</a></li>'
					+ '			<li url="${contextPath}/manage/set/userHistList.ifm"><a href="javascript:;">사용자접속 로그</a></li>'
					+ '			<li url="${contextPath}/manage/set/noregDevList.ifm"><a href="javascript:;">미등록단말기 내역</a></li>'
					+ '			<li url="${contextPath}/manage/set/noregAgentList.ifm"><a href="javascript:;">미등록대리점 내역</a></li>'
					+ '			<li url="${contextPath}/manage/set/alarmSend.ifm"><a href="javascript:;">알림발송</a></li>'
					+ '			<li url="${contextPath}/manage/set/alarmHistList.ifm"><a href="javascript:;">알림발송 이력</a></li>'
					+ '			<li url="${contextPath}/manage/set/csvList.ifm"><a href="javascript:;">대용량엑셀 다운로드</a></li>'
					+ '		</ul>'
					+ '	</li>'
					+ '	<li><a href="javascript:;">기준정보</a>'
					+ '		<ul>'
					+ '			<li url="${contextPath}/manage/basis/carList.ifm"><a href="javascript:;">센터 차량관리</a></li>'
					+ '			<li url="${contextPath}/manage/basis/cargoDevList.ifm"><a href="javascript:;">센터 창고관리</a></li>'
					+ '			<li url="${contextPath}/manage/basis/agentCarList.ifm"><a href="javascript:;">대리점 차량관리</a></li>'
					+ '			<li url="${contextPath}/manage/basis/agentCargoList.ifm"><a href="javascript:;">대리점 창고관리</a></li>'
					+ '			<li url="${contextPath}/manage/basis/userList.ifm"><a href="javascript:;">사용자 관리</a></li>'
					+ '			<li url="${contextPath}/manage/basis/agentList.ifm"><a href="javascript:;">대리점 관리</a></li>'
					+ '			<li url="${contextPath}/manage/basis/restList.ifm"><a href="javascript:;">차량 휴무관리</a></li>'
					+ '			<li url="${contextPath}/manage/basis/authList.ifm"><a href="javascript:;">권한그룹 설정</a></li>'
					+ '		</ul>'
					+ '	</li>'
					+ '	<li><a href="javascript:;">크레이트 관리</a>'
					+ '		<ul>'
					+ '			<li url="${contextPath}/manage/crate/sapIfList.ifm"><a href="javascript:;">SAP인터페이스 현황</a></li>'
					+ '			<li url="${contextPath}/manage/crate/inOutList.ifm"><a href="javascript:;">포장재 회수현황</a></li>'
					+ '			<li url="${contextPath}/manage/crate/inOutAdjResultList.ifm"><a href="javascript:;">관리자수정 이력조회</a></li>'
					+ '			<li url="${contextPath}/manage/crate/inOutAnalList.ifm"><a href="javascript:;">포장재 회수현황 통계관리</a></li>'
					+ '			<li url="${contextPath}/manage/crate/sapIfResultList.ifm"><a href="javascript:;">SAP전송여부 조회</a></li>'
					+ '		</ul>'
					+ '	</li>'
					+ '	<li><a href="javascript:;">센터 관리</a>'
					+ '		<ul>'
					+ '			<li url="${contextPath}/manage/center/agentDeliList.ifm"><a href="javascript:;">대리점배송 모니터링</a></li>'
					+ '			<li url="${contextPath}/manage/center/tempNowList.ifm"><a href="javascript:;">실시간온도 모니터링</a></li>'
					+ '			<li url="${contextPath}/manage/center/dayCarNow.ifm"><a href="javascript:;">일자별차량 운행현황</a></li>'
					+ '			<li url="${contextPath}/manage/center/dayCarDrvAnal.ifm"><a href="javascript:;">일자별차량 운행내역</a></li>'
					+ '			<li url="${contextPath}/manage/center/dayCargoTempAnal.ifm"><a href="javascript:;">일자별창고 온도내역</a></li>'
					+ '			<li url="${contextPath}/manage/center/dayAnal.ifm"><a href="javascript:;">일자별누적 내역현황</a></li>'
					<%--+ '			<li url="${contextPath}/manage/center/dayChArrAnal.ifm"><a href="javascript:;">일자별채널별 정시도착율</a></li>'--%>
					+ '			<li url="${contextPath}/manage/center/dayTempAnal.ifm"><a href="javascript:;">일자별 온도준수율</a></li>'
					+ '			<li url="${contextPath}/manage/center/dayAgentArrAnal.ifm"><a href="javascript:;">일자별대리점 정시도착율</a></li>'
					+ '			<li url="${contextPath}/manage/center/carDayAnal.ifm"><a href="javascript:;">차량별 누적 현황</a></li>'
					+ '			<li url="${contextPath}/manage/center/carAnal.ifm"><a href="javascript:;">차량 운행현황</a></li>'

					+ '		</ul>'
					+ '	</li>'
					+ '	<li><a href="javascript:;">대리점 관리</a>'
					+ '		<ul>'
					+ '			<li url="${contextPath}/manage/agent/agentNowCarList.ifm"><a href="javascript:;">대리점 실시간차량</a></li>'
					+ '			<li url="${contextPath}/manage/agent/agentNowCargoList.ifm"><a href="javascript:;">대리점창고 모니터링</a></li>'
					+ '			<li url="${contextPath}/manage/agent/agentCarTempList.ifm"><a href="javascript:;">대리점차량 온도현황</a></li>'
					+ '			<li url="${contextPath}/manage/agent/agentCargoTempList.ifm"><a href="javascript:;">대리점창고 온도현황</a></li>'
					+ '		</ul>'
					+ '	</li>'
					+ '</ul>'
				$('#mega-menu li').append(menuHtml);
				$('#mega-menu').dcMegaMenu({rowItems: '7', speed: 'fast', effect: 'fade'});

				menuCnt = 2;
				menu$ = $('#menuTab').tabs();
				menu$.find('.ui-tabs-nav').sortable({
					axis: 'x',
					stop: function() {
						menu$.tabs('refresh');
					}
				});

				$('#mega-menu li>ul>li').on('click', function() {
					$('div.sub-container>.sub').hide();
					if (!$(this).attr('url')) { onm.alert('오류입니다'); return; }
					goLink($(this).attr('url'), $(this).find('a').text() || 'Menu ' + menuCnt);
				});

				menu$.on('click', 'div.ui-icon-arrowrefresh-1-s', function(e) {
	//		 		menu$.tabs('option', 'active', $('div.ui-icon-close').length - 1);
					var menuId = $(this).parent().find('a').attr('href');
					var menuIdx = menu$.find('a[href="' + menuId + '"]').parent().index();
					menu$.tabs('option', 'active', menuIdx);
					var menuFrame = $(menuId + ' iframe');
					var menuUrl = menuFrame.attr('src');
					menuFrame.attr('src', menuUrl);
				});

				menu$.on('click', 'div.ui-icon-close', function() {
					if ($('div.ui-icon-close').length > 1) {
						var panelId = $(this).closest('li').remove().attr('aria-controls');
						$('#' + panelId).remove();
						menu$.tabs('refresh');
					} else {
						onm.alert('마지막 메뉴입니다.');
					}
				});

				$.ajax({
					url: _contextPath_ + '/main/sessionInfo.json',
					data: {},
					success: function(res) {
						//권한에 없는 메뉴를 hide한다
						var menuLi = $('.dc-mega-li>div>ul>div>li>ul>li');
						var menuUrl;
						var roleList = res.roleList || [];
						menuLi.each(function() {
							menuUrl = $(this).attr('url') || '';
							for (var menuIdx = 0; menuIdx < roleList.length; menuIdx++) {
								if (menuUrl != '') {
									if (menuUrl.indexOf(roleList[menuIdx].menuCd) > -1 && roleList[menuIdx].selectYn == 'N') {
										$(this).hide();
									}
								} else {
									$(this).hide();
								}
							}
						});
					}
				});

				$('#frame_1').attr('src', '${contextPath}/manage/dash/centerList.ifm');
			});
		</script>
		<div id="top_menu" class="grey">
			<ul id="mega-menu" class="mega-menu">
				<li><a href="javascript:;">환경설정</a></li>
				<li><a href="javascript:;">기준정보</a></li>
				<li><a href="javascript:;">크레이트 관리</a></li>
				<li><a href="javascript:;">센터 관리</a></li>
				<li><a href="javascript:;">대리점 관리</a></li>
			</ul>
		</div>

		<div id="menuTab">
			<ul>
				<li><a href="#tab-1">Dash Board</a><div class="ui-icon ui-icon-arrowrefresh-1-s sel hidden" title="새로고침">새로고침</div><div class="ui-icon ui-icon-close sel hidden" title="화면닫기">화면닫기</div></li>
			</ul>
			<div id="tab-1" class="tab_div"><iframe id="frame_1" onload="resizeFrame(this, 'dash')" class="tab_frame" src=""></iframe></div>
		</div>
	</c:otherwise>
</c:choose>

