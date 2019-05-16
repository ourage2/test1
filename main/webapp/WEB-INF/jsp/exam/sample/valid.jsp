<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/include/tag_declare.jsp" %>
<script>
jQuery(function($) {
	$('#btnUserId').on('click', function() {
		onm.ajax({
			url:'<c:url value="/exam/sample/validTest1.json" />',
			data:{userId:$('#userId').val()},
			success:function() {
				onm.alert('passed');
			}
		});
	});
	
	$('#btnUserAge').on('click', function() {
		onm.ajax({
			url:'<c:url value="/exam/sample/validTest2.json" />',
			data:{userAge:$('#userAge').val()},
			success:function() {
				onm.alert('passed');
			}
		});
	});
	
	$('#btnBirthday').on('click', function() {
		onm.ajax({
			url:'<c:url value="/exam/sample/validTest3.json" />',
			data:{birthday:$('#birthday').val()},
			success:function() {
				onm.alert('passed');
			}
		});
	});
	
	$('#btnNicname').on('click', function() {
		onm.ajax({
			url:'<c:url value="/exam/sample/validTest4.json" />',
			data:{nicname:$('#nicname').val()},
			success:function() {
				onm.alert('passed');
			}
		});
	});
	
	$('#btnUrl').on('click', function() {
		onm.ajax({
			url:'<c:url value="/exam/sample/validTest5.json" />',
			data:{protocol:$('#protocol').val(), ip:$('#ip').val()},
			success:function() {
				onm.alert('passed');
			}
		});
	});
});
</script>
<h2 class=content_title>Validation</h2>

<table class="dtl_tbl">
	<colgroup>
		<col style="width:40%;" />
		<col style="width:40%;" />
		<col style="width:20%;" />
	</colgroup>
	<tr>
		<th>사용자아이디 (필수 - Required, 패턴 - mask (^[a-zA-Z][a-zA-Z0-9_]{5,15}$))</th>
		<td>
			<input type="text" name="userId" id="userId" class="w90" value="" />
		</td>
		<td>
			<span class="btn_pack large"><button type="submit" id="btnUserId">전송</button></span>
		</td>
	</tr>
	<tr>
		<th>나이 (숫자 - integer, 범위 - range (1 ~ 150)</th>
		<td>
			<input type="text" name="userAge" id="userAge" class="w90" value="200" />
		</td>
		<td>
			<span class="btn_pack large"><button type="submit" id="btnUserAge">전송</button></span>
		</td>
	</tr>
	<tr>
		<th>샏년월일 (날짜 - date (yyyy.MM.dd))</th>
		<td>
			<input type="text" name="birthday" id="birthday" class="w90" value="2015-05-01" />
		</td>
		<td>
			<span class="btn_pack large"><button type="submit" id="btnBirthday">전송</button></span>
		</td>
	</tr>
	<tr>
		<th>별명 (최소길이 - minlength (6), 최대길이 - maxlength (12))</th>
		<td>
			<input type="text" name="nicname" id="nicname" class="w90" value="군산피바다" />
		</td>
		<td>
			<span class="btn_pack large"><button type="submit" id="btnNicname">전송</button></span>
		</td>
	</tr>
	<tr>
		<th>Protocol</th>
		<td>
			<input type="text" name="protocol" id="protocol" class="w90" />
		</td>
		<td rowspan="2">
			<span class="btn_pack large"><button type="submit" id="btnUrl">전송</button></span>
		</td>
	</tr>
	<tr>
		<th>IP</th>
		<td>
			<input type="text" name="ip" id="ip" class="w90" value="127.0.0.1" />
		</td>
	</tr>
</table>