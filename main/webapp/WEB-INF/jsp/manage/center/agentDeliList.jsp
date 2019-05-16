<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>

<header>
	<div id="divSrch">
	<div class="loc_info"><span>대리점 실시간 배송 현황</span><span>센터관리</span><span>Home</span></div>
	<h2 class="content_title"><span>대리점 실시간 배송 현황</span></h2>
		<div class="srch_box">
			<table>
				<colgroup>
					<col width="8%">
					<col width="12%">
					<col width="8%">
					<col width="12%">
					<col width="8%">
					<col width="12%">
					<col width="8%">
					<col width="10%">
					<col width="*">
				</colgroup>
				<tr>
					<th>소속</th>
					<td>
						<select name="">
							<option value="">전체</option>
						</select>
					</td>
					<th>차량번호</th>
					<td>
						<input type="text" name="" maxlength="30" class="enterSrch" />
					</td>
					<th>운전자</th>
					<td>
						<input type="text" name="" maxlength="30" class="enterSrch" />
					</td>
					<th>대리점</th>
					<td>
						<input type="text" name="" maxlength="30" class="enterSrch" />
					</td>
					<td rowspan="2">
						<div class="srch_btn">
							<button type="button" id="srchBtn" class="btn_srch "><span class="ico_srch"></span>검색</button>
						</div>
					</td>
				</tr>
				<tr>
					<th>배송상태</th>
					<td>
						<select name="">
							<option value="">전체</option>
						</select>
					</td>
					<th>동작시간</th>
					<td>
						<select name="">
							<option value="">1분</option>
						</select>
						<label><input type="checkbox" name="" value="" checked="checked">Auto play</label>
					</td>
				</tr>

			</table>
		</div>
	</div>
</header>
<div id="main">
	<div class="colgroup-wrap">
		<div id="divView1">

			<div class="caption-pnl">
				<h2>배송모니터링 <span >현재시간 : 2018년 10월 1일 12:12:34</span></h2>
				<span class="buttonset fr">
					<button type="button" class="btn_list_rd" id="btnView1Save">▶</button>
					<button type="button" class="btn_list_rd" id="btnView1Save">■</button>
					<select name="pageUnit"></select>
				</span>
				<ul class="agent-status">
					<li><span class="ico-agent start">S</span><span class="reg-txt">출발지</span></li>
					<li><span class="ico-agent end">E</span><span class="reg-txt">도착지</span></li>
					<li><span class="ico-agent fixed"></span><span class="reg-txt">정시도학</span></li>
					<li><span class="ico-agent missed"></span><span class="reg-txt">미도착</span></li>
					<li><span class="ico-agent delay"></span><span class="reg-txt">지연도착</span></li>
				</ul>
			</div>
			<div class="agtDetail_wrap">
				<ul class="gatDetail_ul">
					<li>
						<div class="agtDetal_table ">
						<table class="waiting">
							<colgroup>
							<col width="40%">
							<col>
							</colgroup>
							<tbody><tr>
								<th class="group01">선적번호</th><td class="group01">000021311021</td>
							</tr>
							<tr>
								<th>차량번호</th><td>51고1738</td>
							</tr>
							<tr>
								<th>운전자</th><td>김정훈</td>
							</tr>
							<tr>
								<th>연락처</th><td>010-4443-11**</td>
							</tr>
						</tbody></table>
					</div>
					</li>
					<li>
						<div class="icon_car"></div>
						<ul class="agt_monitoring">
							<li><div class="bar pass"></div><div class="group"><span class="ico-agent start create">S</span><div class="txt">평택공장</div></div> </li>
							<li><div class="bar pass"></div><div class="group"><span class="ico-agent end create"> </span><div class="txt">크로바 물류</div></div> </li>
							<li><div class="bar"></div><div class="group"><span class="ico-agent fixed create"> </span><div class="txt">오아시스푸드/김포공항 물류</div></div> </li>
							<li><div class="bar"></div><div class="group"><span class="ico-agent missed"> </span><div class="txt">민주푸드/태릉교통차고지_물류</div></div> </li>
							<li><div class="bar"></div><div class="group"><span class="ico-agent delay"> </span><div class="txt">브래댄코(의정부성모병원점_물류</div></div> </li>
							<li><div class="bar"></div><div class="group"><span class="ico-agent delay"> </span><div class="txt">브래댄코(의정부성모병원점_물류</div></div> </li>
							<li><div class="bar"></div><div class="group"><span class="ico-agent end">E</span><div class="txt">평택공장</div></div> </li>
						</ul>
					</li>
				</ul>
				<ul class="gatDetail_ul">
					<li>
						<div class="agtDetal_table ">
						<table class="delivery">
							<colgroup>
							<col width="40%">
							<col>
							</colgroup>
							<tbody><tr>
								<th class="group01">선적번호</th><td class="group01">000021311021</td>
							</tr>
							<tr>
								<th>차량번호</th><td>51고1738</td>
							</tr>
							<tr>
								<th>운전자</th><td>김정훈</td>
							</tr>
							<tr>
								<th>연락처</th><td>010-4443-11**</td>
							</tr>
						</tbody></table>
					</div>
					</li>
					<li>
						<div class="icon_car"></div>
						<ul class="agt_monitoring">
							<li><div class="bar pass"></div><div class="group"><span class="ico-agent start">S</span><div class="txt">평택공장</div></div></li>
							<li><div class="bar pass"></div><div class="group"><span class="ico-agent end"> </span><div class="txt">크로바 물류</div></div> </li>
							<li><div class="bar"></div><div class="group"><span class="ico-agent fixed"> </span><div class="txt">오아시스푸드/김포공항 물류</div></div> </li>
							<li><div class="bar"></div><div class="group"><span class="ico-agent missed"> </span><div class="txt ">민주푸드/태릉교통차고지_물류</div></div>
							<div class="agt_tooltip ">
							<div class="agtDetal_table ">
								<table >
									<colgroup>
									<col width="60%">
									<col>
									</colgroup>
									<tbody>
									<tr>
										<th class="group01" colspan="2">대리점 명인주푸드</th>
									</tr>
									<tr>
										<th class="group01">도착시간</th><td class="group01">16:00</td>
									</tr>
									<tr>
										<th>COV 도착시간 </th><td>14:00~16:00</td>
									</tr>
									<tr>
										<th>도착시간</th><td></td>
									</tr>
									<tr>
										<th>출발시간</th><td></td>
									</tr>
									<tr>
										<th>크리에이트 시간</th><td></td>
									</tr>
								</tbody></table>
							</div>
							<div class="arrow"></div>
							</div>
							 </li>
							<li><div class="bar"></div><div class="group"><span class="ico-agent delay"> </span><div class="txt">브래댄코(의정부성모병원점_물류</div></div> </li>
							<li><div class="bar"></div><div class="group"><span class="ico-agent delay"> </span><div class="txt">브래댄코(의정부성모병원점_물류</div></div> </li>
							<li><div class="bar"></div><div class="group"><span class="ico-agent end">E</span><div class="txt">평택공장</div></div> </li>
						</ul>
					</li>
				</ul>
				<ul class="gatDetail_ul">
					<li>
						<div class="agtDetal_table ">
						<table class="complete">
							<colgroup>
							<col width="40%">
							<col>
							</colgroup>
							<tbody><tr>
								<th class="group01">선적번호</th><td class="group01">000021311021</td>
							</tr>
							<tr>
								<th>차량번호</th><td>51고1738</td>
							</tr>
							<tr>
								<th>운전자</th><td>김정훈</td>
							</tr>
							<tr>
								<th>연락처</th><td>010-4443-11**</td>
							</tr>
						</tbody></table>
					</div>
					</li>
					<li>
						<div class="icon_car"></div>
						<ul class="agt_monitoring">
							<li><div class="bar pass"></div><div class="group"><span class="ico-agent start">S</span><div class="txt">평택공장</div></div> </li>
							<li><div class="bar pass"></div><div class="group"><span class="ico-agent end"> </span><div class="txt">크로바 물류</div></div> </li>
							<li><div class="bar"></div><div class="group"><span class="ico-agent fixed"> </span><div class="txt">오아시스푸드/김포공항 물류</div></div> </li>
							<li><div class="bar"></div><div class="group"><span class="ico-agent missed"> </span><div class="txt">민주푸드/태릉교통차고지_물류</div></div> </li>
							<li><div class="bar"></div><div class="group"><span class="ico-agent delay"> </span><div class="txt">브래댄코(의정부성모병원점_물류</div></div> </li>
							<li><div class="bar"></div><div class="group"><span class="ico-agent delay"> </span><div class="txt">브래댄코(의정부성모병원점_물류</div></div> </li>
							<li><div class="bar"></div><div class="group"><span class="ico-agent end">E</span><div class="txt">평택공장</div></div> </li>
						</ul>
					</li>
				</ul>
			</div>
		</div>
	</div>
</div>