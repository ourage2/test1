<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>



<header>
	<div class="title_area">
		<a href="javascript:history.back()" class="layout_back" alt="이전으로"></a>
		<h2>차량 운행 경로</h2>
	</div>
	<div id="divSrch">
		<%--<button class="m_srch_toggle on">조회설정<span class="sr_off"><span class="blind">열기</span></span><span class="sr_on"><span class="blind">닫기</span></span></button>--%>
		<!--조회설정  class="m_srch_toggle on" 조건 나타남   div class="srch_box" display:block 처리-->
		<!--조회설정  class="m_srch_toggle off" 조건 숨김  div class="srch_box"  display:none 처리-->
		<div class="srch_box" style="display: block">
			<table>
				<colgroup>
					<col width="50%">
					<col width="50%">
				</colgroup>
				<tr>
					<td colspan="2">
						<input type="text" name="srchWord" maxlength="30" class="enterSrch w98" placeholder="차량번호 또는 운전자 번호를 입력하세요"/>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<button type="button" id="srchBtn" class="btn_srch m_srch"><span class="ico_srch"></span>검색</button>
					</td>
				</tr>
			</table>
		</div>
	</div>
</header>
<div id="main">
<ul class="now_sel row2">
	<li>
	<select name="srchMethod" class="w100">
		<option value="title" selected="selected">센터</option>
	</select>
	</li>
	<li>
	<select name="srchMethod" class="w100">
		<option value="title" selected="selected">차량</option>
	</select>
	</li>
	<li class="w100">
	<select name="srchMethod" class="w100">
		<option value="title" selected="selected">차량 번호</option>
	</select>
	</li>
</ul>
<div class="main_map">
</div>
<div class="now_time_wrap">
<ul class="now_time">
	<li>02:00</li>
	<li>02:00</li>
	<li>02:00</li>
	<li>02:00</li>
	<li>02:00</li>
	<li>02:00</li>
</ul>
</div>
<div class="now_addr"> 경기도 용인수 지수지고 1111 02 </div>
</div>