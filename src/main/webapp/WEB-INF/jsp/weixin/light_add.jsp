<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1,user-scalable=no" />
<!-- <meta http-equiv="cache-control" content="no-cache">  -->
<jsp:include page="../common/common-include.jsp"></jsp:include>
<script src="${pageContext.request.contextPath}/static/js/base64.js"></script>
<script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/lightadd.css" >
<title>搜索设备</title>
</head>
<body>
	<div class="container">
		<div class="container-fluid devices">
			<!-- <div class="row">
				<div class="col-xs-1"><label>1</label></div>
				<div class="col-xs-9"><label class="search-label">灯1</label></div>
				<div class="col-xs-2"><label>></label></div>
			</div> -->
			<div class="row">
				<div class="col-xs-1"><div class="loading"></div></div>
				<div class="col-xs-11"><label class="search-label info">正在搜索可添加的蓝牙灯</label></div>
			</div>
		</div>
	</div>
	
	<div class="modal fade" id="device-add" tabindex="-1" role="dialog" data-backdrop="true">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content container-fluid" >
	    
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title">绑定设备</h4>
	      </div>
	      <div class="modal-body form-horizontal">
	      	<div class="form-group">
	      		<label class="col-xs-3 control-label" for="deviceid">ID</label>
	      		<div class="col-xs-9"><input type="text" class="form-control" id="deviceid" disabled/></div>
	      	</div>
			<div class="form-group">
	      		<label class="col-xs-3 control-label" for="devicename">名字</label>
	      		<div class="col-xs-9"><input type="text" class="form-control" id="devicename" /></div>
	      	</div>
	        
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" id="start-bind">绑定</button>
	      </div>
	    </div>
	  </div>
	</div>
	
	<div class="modal" id="loading" tabindex="-1" role="dialog" data-backdrop="static">
	  <div class="modal-dialog modal-sm tip" role="document">
	    <div class="modal-content container-fluid" >
	    	<div class="row">
	    		<div class="col-xs-4">
	    			<div class="loading"></div>
	    		</div>
	    		<div class="col-xs-8"><label>绑定中</label></div>
	    	</div>
	    </div>
	  </div>
	</div>
	
	<div class="modal" id="tip-message" tabindex="-1" role="dialog" data-backdrop="static">
	  <div class="modal-dialog modal-sm tip" role="document">
	    <div class="modal-content container-fluid" >
	    	<div class="row">
	    		<div class="col-xs-12 text-center">
	    			<label id="tip-label"></label>
	    		</div>
	    	</div>
	    </div>
	  </div>
	</div>

	
	<div style="position:absolute;word-break:break-all;bottom:0;">
		<label style="color:#333" id="log">log</label>
	</div>
	
	<div>
	</div>
	
	
	<!-- 界面 -->
	<script type="text/javascript">
		function showError(message) {
			$(".loading").removeClass("loading");
			$(".info").text(message);
		}
		
		function log(info) {
			if (typeof info == "object") {
				info = JSON.stringify(info);
			}
			$("#log").html($("#log").html() + "<br>" + info);
		}
		
		function refreshDeviceList() {
			for (deviceId in discoverDevices) {
				if ($("#" + deviceId).length == 0) {
					var row = $('<div class="row device" style="display:none">'+
									'<div class="col-xs-1"><label class="index">1</label></div>'+
									'<div class="col-xs-9"><label class="name">灯1</label></div>'+
									'<div class="col-xs-2"><label>></label></div>'+
								'</div>');
					$(".devices").append(row);
					row.attr("id", deviceId);
					row.bind("click", function() {
						var deviceId = $(this).attr("id");
						var device = discoverDevices[deviceId];
						$("#deviceid").val(deviceId.substring(deviceId.lastIndexOf("_") + 1, deviceId.length));
						$("#devicename").val(device.name);
						$("#device-add").data("deviceId", deviceId);
						$("#device-add").modal();
					});
					var device = discoverDevices[deviceId];
					if (!device.name) {
						getName(deviceId, function(_deviceId, name) {
							discoverDevices[_deviceId].name = name;
							var _row = $("#" + _deviceId);
							$(".name", _row).text(name);
							_row.fadeIn();
						});
					}else {
						$(".name", row).text(device.name);
						row.fadeIn();
					}
				}
			}
			refreshRowIndex();
		}
		
		function getName(deviceId, callBack) {
			var url = "device/getname";
			var data = {'device_id': deviceId};
			var success = function(res) {
				if (res.success) {
					var _deviceId = res["device_id"];
					var _deviceName = res["device_name"];
					callBack(_deviceId, _deviceName);
				}
			}
			$.ajax({
			  type: 'POST',
			  url: url,
			  data: data,
			  success: success,
			  dataType: 'json'
			});
		}
		
		function showLoading() {
			$("#loading").modal();
			$("#loading .modal-dialog").css({
				'margin-top':'30%'
			}).hide().fadeIn();
			
		}
		
		function hideLoading() {
			$("#loading").fadeOut("normal", function(){
				$("#loading").modal("hide");
			});
		}
		function refreshRowIndex() {
			var rows = $(".device:not(:hidden)");
			for (var i = 0; i < rows.length; i++) {
				$(".index", rows.eq(i)).text(i+1);
			}
		}
		
		var tipTimeoutId;
		
		function showTipMessage(msg, cssClass) {
			$("#tip-label").attr("class", "");
			$("#tip-label").addClass(cssClass);
			$("#tip-label").text(msg);
			$("#tip-message").modal();
			$("#tip-message .modal-dialog").css({
				'margin-top':'30%'
			}).hide().fadeIn();
			clearTimeout(tipTimeoutId);
			tipTimeoutId = setTimeout(function(){
				$("#tip-message").fadeOut("normal", function(){
					$("#tip-message").modal("hide");
				});
			}, 1000)
		}
		
		$(document).ready(function(){
			
			$("#start-bind").bind("click", function(){
				var openid = '${wechatUser.openid}';
				var deviceId = $("#device-add").data("deviceId");
				showLoading();
				var deviceName = $("#devicename").val();
				WeixinJSBridge.invoke("getWXDeviceTicket",{'deviceId':deviceId,'type':'1'}, function(res) {
					if (res['err_msg'] == "getWXDeviceTicket:ok") {
						var ticket = res['ticket'];
						var url = "${pageContext.request.contextPath}/service/weixin/device/bind"
						var data = {
								'ticket': ticket,
								'device_id': deviceId,
								'openid': openid,
								'device_name': deviceName
						}
						var success = function(res) {
							if (res.success) {
								hideLoading();
								showTipMessage("绑定成功", "text-success");
								$("#" + deviceId).slideUp();
								refreshRowIndex();
							}else {
								hideLoading();
								showTipMessage("绑定失败", "text-danger");
							}
							$("#device-add").modal("hide");
							
						};
						$.ajax({
							  type: 'POST',
							  url: url,
							  data: data,
							  success: success,
							  dataType: 'json'
							});
						
					}else {
						log(res)
					}
				});
			});
			
		});
		
	</script>
	
	
	<!-- 微信控制 -->
	<script type="text/javascript">
	var discoverDevices = {};
	var bindDevices = {};
	wx.config({
	    debug: false,
	    appId: '${jsSign.appId}',
	    timestamp: '${jsSign.timestamp}',
	    nonceStr: '${jsSign.nonceStr}',
	    signature: '${jsSign.signature}',
	    jsApiList: [
	        'openWXDeviceLib',
	        'getWXDeviceInfos',
	        'closeWXDeviceLib',
	        'getWXDeviceTicket',
	        'startScanWXDevice',
	        'stopScanWXDevice',
	    ]
	});
	
	var openid = '${wechatUser.openid}';
	log (openid)
	
	wx.error(function (res) {
		showError("加载失败，请重新打开页面");
	});
	
	
	wx.ready(function () {
		//初始化库
	    WeixinJSBridge.invoke('openWXDeviceLib', {}, function (res) {
	        if (res.err_msg != 'openWXDeviceLib:ok') {
	            showError('加载失败，请重新打开页面');
	            return;
	        }
	    });
	    
	    //开始扫搜设备
	    function startScan() {
	    	WeixinJSBridge.invoke('startScanWXDevice', {'connType':'blue'}, function(res) {
	    		if (res.err_msg != 'startScanWXDevice:ok') {
		            showError('加载失败，请重新打开页面');
		            return;
		        }
	    	});
	    	
	    }
	    startScan();	
	  //获取设备列表
	    WeixinJSBridge.invoke('getWXDeviceInfos', {}, function (res) {
	    	
	        var num = res.deviceInfos.length;
	        for (var i = 0; i < num; i++) {
	        	
	        	var deviceId = res.deviceInfos[i].deviceId;
	        	var state = res.deviceInfos[i].state;
	        	bindDevices[deviceId] = res.deviceInfos[i];
	        }
	      
	    });

	    //监听蓝牙状态
	    WeixinJSBridge.on('onWXDeviceBluetoothStateChange', function (argv) {
	        if (argv.state === 'off') {
	            showError('蓝牙关闭，停止搜索');
	        }else {
	        	startScan();
	        }
	    });
	    
	    //搜索到设备
	    WeixinJSBridge.on('onScanWXDeviceResult', function (argv) {
	    	
	        for (var i = 0; i < argv.devices.length; i++) {
	        	
	        	var device = argv.devices[i];
	        	if(bindDevices[device.deviceId]) {
	        		continue;
	        	}
	        	discoverDevices[device.deviceId] = device;
	        	log(device.deviceId);
	        }
	        refreshDeviceList();
	    });
	    
	});
	
	</script>
</body>
</html>