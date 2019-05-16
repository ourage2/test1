<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>
<h2 class=content_title>권한체크</h2>

<table class="dtl_tbl">
	<colgroup>
		<col style="width:80%;" />
		<col style="width:20%;" />
	</colgroup>
	<tr>
		<th>주문내역상세 (F020104) - /product/orderHist/pchsScrbInfoDetail.do</th>
		<td>
			<onm:auth funcId="F020104">
				<span class="btn_pack large"><a href="<c:url value="/product/orderHist/pchsScrbInfoDetail.do" />">주문내역상세</a></span>
			</onm:auth>
		</td>
	</tr>
	<tr>
		<th>회원정보 조회 팝업 (F000001) - /customer/custInfo/custInfoListPopup.do</th>
		<td>
			<onm:auth funcId="F000001">
				<span class="btn_pack large"><a href="<c:url value="/customer/custInfo/custInfoListPopup.do" />">회원정보 조회 팝업</a></span>
			</onm:auth>
		</td>
	</tr>
	<tr>
		<th>비권한 주문내역상세 (F020104) - /product/orderHist/pchsScrbInfoDetail.do</th>
		<td>
			<onm:noAuth funcId="F020104">
				<span class="btn_pack large"><a href="<c:url value="/product/orderHist/pchsScrbInfoDetail.do" />">비권한 주문내역상세</a></span>
			</onm:noAuth>
		</td>
	</tr>
</table>