<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1" />
<jsp:include page="../common/common-include.jsp"></jsp:include>
<title>编辑设备</title>
</head>
<body>

	<div>
		<div class="container">
			<h1>编辑设备</h1>
		</div>
	</div>

	<div class="container">
		<form action="update" method="POST" class="form-horizontal">
			<input type="hidden" name="connStrategy" value= "1">
			<input type="hidden" name="cryptMethod" value= "0">
			<input type="hidden" name=authVer value= "0">
			<input type="hidden" name=manuMacPos value= "-1">
			<input type="hidden" name=serMacPos value= "-1">
			<input type="hidden" name=bleSimpleProtocol value= "0">
		
			<div class="form-group">
				<label for="deviceId" class="col-sm-2 control-label">Device ID</label>
				<div class="col-sm-10">
					<input type="text" class="form-control" id="deviceId" name="deviceId" placeholder="Device ID" readonly value="${device.deviceId }">
				</div>
			</div>
			
			<div class="form-group">
				<label for="qrticket" class="col-sm-2 control-label">QR Ticket</label>
				<div class="col-sm-10">
					<input type="text" class="form-control" id="qrticket" name="qrticket" placeholder="QR Ticket" readonly value="${device.qrticket }">
				</div>
			</div>
			
			<div class="form-group">
				<label for="deviceLicence" class="col-sm-2 control-label">Device Licence</label>
				<div class="col-sm-10">
					<input type="text" class="form-control" id="deviceLicence" name="deviceLicence" placeholder="Device Licence" readonly value="${device.deviceLicence }">
				</div>
			</div>
			
			<div class="form-group">
				<label for="mac" class="col-sm-2 control-label">MAC Address</label>
				<div class="col-sm-10">
					<input type="text" class="form-control" id="mac" name="mac" placeholder="MAC Address, example:1234567890AB" value="${device.mac }">
				</div>
			</div>
			
			<div class="form-group">
				<label for="customData" class="col-sm-2 control-label">Custom Data</label>
				<div class="col-sm-10">
					<input type="text" class="form-control" id="customData" name="customData" placeholder="Custom Data" value="${device.customData }">
				</div>
			</div>
			
			<div class="form-group">
				<label for="connectProtocol" class="col-sm-2 control-label">Connect Protocol</label>
				<div class="col-sm-10">
					<div class="checkbox">
					
						<label><input type="checkbox" name="connectProtocol" value="1" ${fn:contains(device.connectProtocol, '1') ? 'checked' : '' }>android classic bluetooth</label>
						<label><input type="checkbox" name="connectProtocol" value="2" ${fn:contains(device.connectProtocol, '2') ? 'checked' : '' }>ios classic bluetooth</label>
						<label><input type="checkbox" name="connectProtocol" value="3" ${fn:contains(device.connectProtocol, '3') ? 'checked' : '' }>ble</label>
						<label><input type="checkbox" name="connectProtocol" value="4" ${fn:contains(device.connectProtocol, '4') ? 'checked' : '' }>wifi</label>
					</div>
				
				</div>
			</div>
			
			<div class="form-group">
				<label for="authKey" class="col-sm-2 control-label">Auth Key</label>
				<div class="col-sm-10">
					<input type="text" class="form-control" id="authKey" name="authKey" placeholder="Auth Key" value="${device.authKey }">
				</div>
			</div>
			
			<div class="form-group">
				<label for="closeStrategy" class="col-sm-2 control-label">Close Strategy (断开策略)</label>
				<div class="col-sm-10">
					<div class="checkbox">
						<input type="radio" name="closeStrategy" value="1" ${'1' eq device.closeStrategy ? 'checked' : '' }>退出公众号页面时即断开连接
						<input type="radio" name="closeStrategy" value="2" ${'2' eq device.closeStrategy ? 'checked' : '' }>退出公众号之后保持连接不断开
					</div>
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