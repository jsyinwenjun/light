<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib  uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> 
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1" />

<jsp:include page="../common/common-include.jsp"></jsp:include>




<title>设备列表</title>
</head>
<body>
	<div>
		<div class="container">
			<h1>设备列表</h1>
		</div>
	</div>


	<div class="container">
		<div class="table-responsive">
			<table class="table table-striped table-hover">
				<thead>
					<tr>
						<th>#</th>
						<th>Device ID</th>
						<th>MAC</th>
						<th>QRTicket</th>
						<th>Action</th>
					</tr>
				</thead>
				
				<tbody>
				<c:if test="${empty devices}">
					<tr>
						<td colspan="3" style="text-align:center">设备列表为空。</td>
					</tr>
				
				</c:if>
				 
				<c:if test="${!empty devices}">
					<c:forEach items="${devices}" var="device" varStatus="status">
						<tr>
							<td>${status.index + 1}</td>
							<td>${device.deviceId}</td>   
							<td>${device.mac}</td>
							<td>${device.qrticket}</td>
							<td><a href="edit?deviceid=${device.deviceId}">编辑</a></td>
						</tr>
					</c:forEach>
				</c:if>
				
				</tbody>
			</table>
		</div>
		
		<form action="create" method="GET">
			<button type="submit" class="btn btn-primary">创建</button>
		</form>
	</div>
</body>
</html>