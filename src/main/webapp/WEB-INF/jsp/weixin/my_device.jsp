<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1,user-scalable=no" />
<meta http-equiv="cache-control" content="no-cache"> 
<jsp:include page="../common/common-include.jsp"></jsp:include>
<script src="${pageContext.request.contextPath}/static/js/base64.js"></script>
<script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/mydevice.css" >
<title>我的设备</title>
</head>
<body>
	<div class="container">
		<div class="container-fluid devices">
			<div class="row loading-row">
				<div class="col-xs-1"><div class="loading"></div></div>
				<div class="col-xs-11"><label class=" info">正在获取设备列表</label></div>
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

		function log(info) {
			if (typeof info == "object") {
				info = JSON.stringify(info);
			}
			$("#log").html($("#log").html() + "<br>" + info);
		}
		
		function showError(msg) {
			$(".loading").removeClass("loading");
			$(".info").text(msg);
			$(".loading-row").fadeIn();
		}
		
		$(document).ready(function(){
			
		});
		
	</script>
	
	
	<!-- 微信控制 -->
	<script type="text/javascript">
	var discoverDevices = {};
	wx.config({
	    debug: false,
	    appId: '${jsSign.appId}',
	    timestamp: '${jsSign.timestamp}',
	    nonceStr: '${jsSign.nonceStr}',
	    signature: '${jsSign.signature}',
	    jsApiList: [
			'openWXDeviceLib',
			'closeWXDeviceLib',
			'getWXDeviceInfos',
			'startScanWXDevice',
			'stopScanWXDevice',
			'connectWXDevice',
			'disconnectWXDevice',
			'sendDataToWXDevice'
	    ]
	});
	
	
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
		
	    //监听蓝牙状态
	    WeixinJSBridge.on('onWXDeviceBluetoothStateChange', function (argv) {
	        if (argv.state === 'off') {
	            showError('蓝牙已关闭');
	        }
	    });
	    
	  //获取设备列表
	    WeixinJSBridge.invoke('getWXDeviceInfos', {}, function (res) {
	    	if (res.err_msg != 'getWXDeviceInfos:ok') {
	            showError('获取信息失败，请刷新页面');
	        }
	        var num = res.deviceInfos.length;
			if (num == 0) {
				showError('尚未绑定设备');
				return;
			}
			$(".devices").children().slideUp();
	        for (var i = 0; i < num; i++) {
	        	var deviceId = res.deviceInfos[i].deviceId;
	        	var state = res.deviceInfos[i].state;
	        	
	        	if ($("#" + deviceId).length == 0) {
	        		var row = $('<div class="row device-row" style="display:none">'+
	    	      	'<div class="col-xs-1"><label class="index">0</label></div>'+
	    	      	'<div class="col-xs-8"><label class="modal-title name" style="display:none">蓝牙灯</label></div>'+
	    	        '<div class="col-xs-3 status text-right"><p class="text-success">已连接</p></div>'+
	    	        '</div>');
	        		row.attr("id", deviceId);
	        		$(".index", row).text(i + 1);
	        		row.bind("click", rowClick);
	        		renderRowStatus(row, state);
	        		$(".devices").append(row);

	        		row.fadeIn();
	        		getName(deviceId, function(_deviceId, _deviceName) {
        				var _row = $("#" + _deviceId);
	        			var nameField = $(".name", _row);
	        			nameField.text(_deviceName);
	        			nameField.fadeIn();
        			});
	        	}
	        }
	      
	    });
	  //设备状态改变
	    WeixinJSBridge.on('onWXDeviceStateChange', function (argv) {
	    	var deviceId = argv.deviceId;
	    	var state = argv.state;
	    	var row = $("#" + deviceId)
	    	renderRowStatus(row, state);
	    	if (state == "connected") {
    			getDeviceInfo(deviceId);
    		}
		});

	    //监听设备消息
	    WeixinJSBridge.on('onReceiveDataFromWXDevice', function (argv) {
	        Sender.receiveData(argv);
	    });
	});
	 
	function rowClick() {
		var deviceId = $(this).attr("id");
		var row = $("#" + deviceId);
		if ($(".status p", row).text() == "已连接") {
			location.href = "control?deviceid=" +deviceId;
		}else {
			alert("\"" + $(".name", row).text() +"\"还未连接成功.")
		}
		 
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
	
	function renderRowStatus(row, state) {
		if (state == "connected") {
			$(".status p", row).text("已连接").attr("class","").addClass("text-success");
		}else if (state == "connecting") {
			$(".status p", row).text("连接中").attr("class","").addClass("text-warning");
		}else if (state == "reconnecting") {
			$(".status p", row).text("重连中").attr("class","").addClass("text-warning");
		}else{
			$(".status p", row).text("未连接").attr("class","").addClass("text-danger");
		}
	}
	</script>
	
	<script type="text/javascript">
	var Sender = {};
	//队列发送
	(function(namespace) {
		namespace.sending = false;
		namespace.sendQueue = [];
		namespace.taskQueue = {};
		namespace.currentTaskId;
		namespace.taskTimeOut = 1; // 秒
		
		namespace.startSend = false;
		namespace.lastSend = {};

		var count = 0;
		
		namespace.sendTask = function(deviceId, dataStr, callback) {
			var sequence = Date.now();
			if (this.taskQueue[sequence]) {
				alert("sequence same");
			}
			var sendData = dataStr.replace("{sequence}", sequence);
			this.taskQueue[sequence] = {
					'sequence':sequence,
					'sendData':sendData,
					'deviceId':deviceId,
					'callback':callback
			}

			if (Object.keys(this.taskQueue).length == 1) {
				this.performNextTask();
			}
		},
		
		namespace.performNextTask = function() {
			var keys = Object.keys(this.taskQueue);
			if (keys.length == 0) {
				return;
			}
			var task = this.taskQueue[keys[0]];
			this.sendData(task.deviceId, task.sendData);
			task.taskId = setTimeout(function(){
				delete namespace.taskQueue[task.sequence];
				namespace.performNextTask();
			}, this.taskTimeOut * 2000);
		},
		
		namespace.receiveData = function(data) {
			var deviceId = data.deviceId;
	        var b64d = data.base64Data;
	        var result = base64_decode(b64d);
	        log(result);
	        result = result.substring(0, result.indexOf(";"));
	        var resultArray = result.split(":");
	        if (resultArray.length == 2) {
	        	var res = resultArray[1].split(",");
	        	var sequence = res.shift();
	        	var task = this.taskQueue[sequence];
	        	if (task) {
	        		task.callback(deviceId, res);
	        		clearTimeout(task.taskId);
	        		delete this.taskQueue[sequence];
	        		this.performNextTask();
	        	}
	        }
		},
		
		//发送数据
		namespace.sendData = function(deviceId, dataStr) {
	    	dataStr += ";";
			if (this.lastSend[deviceId] == dataStr) {
				return;
			}
			this.lastSend[deviceId] = dataStr;
			
			if (this.sending) {
				this.sendQueue.push({'deviceId':deviceId, 'dataStr': dataStr});
				return;
			}
			var buf = base64_encode(dataStr)
	        var _data = {"deviceId": deviceId, "base64Data": buf};
			log("count:" + (++count) +",send: " + dataStr);
			
	        WeixinJSBridge.invoke('sendDataToWXDevice', _data, function (res) {
	            var str='send:'+base64_decode(buf)+res.err_msg;
	            namespace.sending = false;
				if (namespace.sendQueue.length) {
					var task = that.sendQueue.shift();
					namespace.sendData(task.deviceId, task.taskStr);
				}
	        });
	    }
		
	})(Sender);

	
	</script>
</body>
</html>