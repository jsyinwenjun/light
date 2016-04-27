<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1" />
<jsp:include page="../common/common-include.jsp"></jsp:include>

<title>创建设备</title>
</head>
<body>
	<div>
		<div class="container">
			<h1>创建设备</h1>
		</div>
	</div>

	<div class="container">
		<form action="update" method="POST" class="form-horizontal">
			<div class="form-group">
				<label for="deviceId" class="col-sm-2 control-label">Device ID</label>
				<div class="col-sm-10">
					<input type="text" class="form-control" id="deviceId" placeholder="Device ID" disabled="disabled" value="${device.deviceId }">
				</div>
			</div>
			
			<div class="form-group">
				<label for="mac" class="col-sm-2 control-label">MAC Address</label>
				<div class="col-sm-10">
					<input type="text" class="form-control" id="mac" placeholder="MAC Address" value="${device.mac }">
				</div>
			</div>
			<div class="form-group">
				<div class="col-sm-offset-2 col-sm-10">
					<button type="submit" class="btn btn-default">保存</button>
				</div>
			</div>
		
		
		</form>
	</div>

</body>
</html>