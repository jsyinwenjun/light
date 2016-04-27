<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1,user-scalable=no" />
<jsp:include page="../common/common-include.jsp"></jsp:include>
<script src="${pageContext.request.contextPath}/static/js/base64.js"></script>
<script src="${pageContext.request.contextPath}/static/js/jquery.knob.js"></script>
<script src="${pageContext.request.contextPath}/static/js/jquery.rgbw.js"></script>
<script src="${pageContext.request.contextPath}/static/js/bootstrap-slider.js"></script>
<script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<title>蓝牙灯</title>

<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/bootstrap-slider.css" >
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/common.css" >

</head>
<body>
<div style="position:absolute;word-break:break-all;top:0;">
	<label style="color:#fff" id="log">log</label>
</div>
<div class="back">
    <img src="${pageContext.request.contextPath}/static/images/background.jpg" class="img-responsive" style="height: 100%;width: 100%;" alt="">
</div>

<div class="load">
    <div class="point-scale-party">
        <div></div>
        <div></div>
        <div></div>
        <div></div>
    </div>
    <p class="center" id="load-text">连接中</p>
</div>

<div class="container hidden">
    <!-- 操作区域 -->
    <div class="row">
        <div class="col-xs-12">

            <!-- 亮度调节 -->
            <div id="bright-div" class="row">
                <div class="col-xs-12">
                    <div id="circle">
                        <div id="small_circle_div">

                        </div>

                        <div class="center-block text-center" id="change-light-knop">

                            <input class="change-light" data-angleoffset="-125" data-anglearc="250" data-fgcolor="#ffffff" data-bgcolor="rgba(255,255,255,0.3)" data-linecap="round" data-thickness=".05" value="35" data-min="1" id="change-light">
                            <div class="row">
                                <div class="col-xs-6">
                                    <p class="text-center light-text">&nbsp;&nbsp;1%</p>
                                </div>
                                <div class="col-xs-6">
                                    <p class="text-center light-text">100%</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- 颜色调节 -->
            <div id="color-div" class="row">
                <div class="col-xs-12">
                    <div id="circle">
                        <div id="small_circle_div">

                        </div>

                        <div class="center-block text-center">

                            <canvas id="color-canvas"></canvas>
                        </div>
                    </div>
                </div>
            </div>
            <!-- 控制按钮 -->

            <nav id="control-div" class="navbar navbar-fixed-bottom">

                <div class="container-fiuld">
                    <!-- 倒计时 -->

                    <div class="control-panel">
                        <div class="row">
                            <div class="col-xs-3">
                                <div class="switch-switch">
                                    <div class="img-responsive switch"> </div>
                                </div>
                                <p class="text-center" id="switch-switch">开灯</p>
                            </div>
                            <div class="col-xs-3">
                                <div class="switch-light">
                                    <div class="img-responsive bright disable"> </div>
                                </div>
                                <p class="text-center" id="switch-light">亮度</p>
                            </div>

                            <div class="col-xs-3">
                                <div class="switch-color">
                                    <div class="img-responsive color disable"> </div>
                                </div>

                                <p class="text-center">颜色</p>
                            </div>
                            <div class="col-xs-3">
                                <div class="switch-delay">
                                    <div class="img-responsive delay disable"> </div>
                                </div>
                                <p class="text-center" id="timer">延时</p>
                            </div>
                        </div>

                    </div>
                </div>
            </nav>

        </div>
    </div>
    
</div>

<!-- 灯列表 -->
    <!-- Modal -->
	<div class="modal" id="light-list" tabindex="-1" role="dialog" data-backdrop="false">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content" >
	      <div class="container-fluid">
		      
	      </div>
	    </div>
	  </div>
	</div>
	
	
<!-- 延时开关 -->
	<div class="modal fade" id="delay-list" tabindex="-1" role="dialog" data-backdrop="true">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content container-fluid" >
	    
	      <div class="modal-header row">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title col-xs-4">延时设定</h4>
	        <p class="info text-right col-xs-7">15分钟后关灯</p>
	      </div>
	      <div class="modal-body row">
	      	
	      	<div class="center" style="min-height:44px">
	      		<input id="delay-slider" type="hidden"  style="width: 80%"/>
	      	</div>
	        
	      </div>
	      <div class="modal-footer row">
	        <button type="button" class="btn btn-danger delete-delay">删除延时</button>
	        <button type="button" class="btn btn-primary start-delay">开启延时</button>
	      </div>
	    </div>
	  </div>
	</div>
<script type="text/javascript">

var delay_times = [
                    0,
                    15 * 60,
                    60 * 60,
                    3 * 60 * 60,
                   	8 * 60 * 60
                    ];
var delay_ticks = [0, 100, 200, 300, 400];
var delay_labels = ['Never', '15 min', '1 hr', '3hr', '8hr'];

var controlDeviceId = "";
var match = location.search.match(/deviceid=(\w*\d*)/)
if (match && match.length == 2) {
	controlDeviceId = match[1];
}


$(document).ready(function() {
	var _height = $(window).height();
    var _width = $(window).width();
    var controlHeight = $("#control-div").height();
    
	$(".back").height(_height);
	
	$("#bright-div,#color-div").css("margin-top", (_height - controlHeight) * 0.2);
	$("#bright-div,#color-div,#control-div").hide()
	$(".container").removeClass("hidden")
	
	$(document).bind("touchmove", function(e) {
		e.preventDefault();
	});
	
	//开关按钮
	$(".switch-switch").bind("click", function() {
		if (Control.controlDevice.powerState) {
			hideAllControl(true);
			Control.sendCommand("powerOff");
			renderDelayButton();
		}else {
			showLastControl();
			Control.sendCommand("powerOn");
		}
    });
	
	//设置颜色按钮
	$(".switch-color").bind("touchend", function(){
		if ($(".color", this).is(".disable,.selected")) {
			return;
		}
		hideBrightControl();
		showColorControl();
		e.preventDefault();
	});
	
	//绑定延时按钮
	$(".switch-delay").bind("touchend", function(e) {
		if ($(".delay", this).is(".disable,.selected")) {
			return;
		}
		e.preventDefault();
		var delayValue = 0;
		if (!Control.controlDevice) {
			delayValue = 100;
		}else {
			var delay = Control.controlDevice.delay;
			if (delay) {
				for (i in delay_times) {
					if  (delay <= delay_times[i]) {
						delayValue = delay_ticks[i - 1] + parseFloat(delay - delay_times[i - 1]) / (delay_times[i] - delay_times[i - 1]) * 100;
						break;
					}
				}
			}
		}
		
		$("#delay-list").bind("shown.bs.modal", function() {
			if ($("#delay-slider-view").length) {
				$("#delay-slider").slider("destroy");
			}
			var slider = $("#delay-slider").slider({
				id: "delay-slider-view",
				ticks: delay_ticks,
			    ticks_labels: delay_labels,
			    ticks_snap_bounds: 10,
			   	value:parseInt(delayValue),
			   	formatter: function(val) {
					
					var index = parseInt(val / 100);
					if (delay_times[index + 1]) {
						var delay = delay_times[index] + (delay_times[index + 1] - delay_times[index]) * parseFloat(val % 100) / 100;
					}else {
						var delay = delay_times[index];
					}
					var hr = parseInt(delay / 60 / 60);
					var min = delay / 60 % 60;
					var minInt = Math.ceil(min);
					if (hr > 0) {
						if (min == 0) {
							$("#delay-list .info").text(hr + "小时后关灯");
						}else {
							$("#delay-list .info").text(hr + "小时" + minInt + "分钟" + "后关灯");
						}
					}else if (min > 0) {
						
						$("#delay-list .info").text(minInt + "分钟" + "后关灯");
					}else {
						$("#delay-list .info").text("长亮");
					}
					
					$("#delay-list").data("delay", hr * 60 * 60 + minInt * 60);
					return (hr < 10 ? "0" : "") + hr + ":" + (minInt < 10 ? "0" : "") + minInt ;
			   	}
				
			})
		});
		
		$("#delay-list").modal();
		
		$(".modal-dialog", "#delay-list").css({
			"position": "relative",
			"top": function () {
				return _height / 2 - 200;
			}
		});
		
	});
	
	$("#delay-list .delete-delay").bind("click", function() {
		Control.controlDevice.changeDelay(0);
		$("#delay-list").modal("hide");
		renderDelayButton();
	});
	$("#delay-list .start-delay").bind("click", function() {
		Control.controlDevice.changeDelay($("#delay-list").data("delay"));
		$("#delay-list").modal("hide");
		renderDelayButton();
	});
	
	setInterval(function() {
		if (Control.controlDevice) {
			if (Control.controlDevice.delay) {
				var leftTime = Control.controlDevice.delay - (Date.now() - Control.controlDevice.delayStartDate) / 1000;
				if (leftTime > 0) {
					var hr = parseInt(leftTime / 60 / 60);
					var min = parseInt(leftTime / 60 % 60);
					var sec = parseInt(leftTime % 60);
					$("#timer").text((hr < 10 ? "0" : "") + hr + ":" + (min < 10 ? "0" : "") + min + ":" + (sec < 10 ? "0" : "") + sec);
					return;
				}else if (leftTime < 0) {
					Control.controlDevice.delay = 0;
					if (Control.controlDevice.powerState) {
						$(".switch-switch").click();
					}
				}
			}
			$("#timer").text("延时");
		}
		
	}, 1000);
	
	//亮度控制按钮
	$(".switch-light").bind("touchend", function(){
		if ($(".bright", this).is(".disable,.selected")) {
			return;
		}
		hideColorControl();
		showBrightControl();
		e.preventDefault();
	});
	
	//初始化画布
	$(".change-light").knob({
		'release': function (v) {
			
			Control.changeLight(v, true);
			Control.stopSend();
        }
		,'change': function(V) {
			Control.startSend();
			Control.changeLight(V, false)
		}
        ,width:Math.round(_width*0.7)
        ,height:Math.round(_width*0.7)
	});
	
	$("#color-canvas").rgbw({
		'start':function(color) {
			Control.startSend();
		},
		'change':function(color) {
			Control.changeRGBW(color, false)
		},
		'release':function(color) {
			Control.stopSend();
			Control.changeRGBW(color, true);
		},
		width:Math.round(_width*0.7)
        ,height:Math.round(_width*0.7)
	});

	
	$("#light-list").bind('shown.bs.modal', function(){
		
		var dialogHeight = $("#light-list .modal-dialog").height();
		if (dialogHeight > _height * 0.95) {
			var scrollStartPos = 0;
			$("#light-list .modal-content").height(_height * 0.95).bind("touchstart", function(e){
				scrollStartPos = $(this).scrollTop() + e.originalEvent.pageY;
				e.preventDefault();
				
			}).bind("touchmove", function(e) {
				$(this).scrollTop(scrollStartPos - e.originalEvent.pageY);
				e.preventDefault();
			});
		}else {
			$("#light-list .modal-dialog").animate({"margin-top": _height / 2 - dialogHeight / 2});
		}
	})
	preload();
	
	
	
	
	/////////////////// debug
	/* Control.controlDevice = {}
	Control.controlDevice.delay = 60 * 60;
	$(".switch-delay .delay").removeClass("disable");
	$(".switch-delay").trigger("click");  */  
	
});

function preload() {
	var images = [
	              '${pageContext.request.contextPath}/static/images/switch.png',
	              '${pageContext.request.contextPath}/static/images/bright.png',
	              '${pageContext.request.contextPath}/static/images/bright_selected.png',
	              '${pageContext.request.contextPath}/static/images/bright_disable.png',
	              '${pageContext.request.contextPath}/static/images/delay.png',
	              ]
	for (index in images) {
		var img = new Image();
		img.src = images[index];
	}
}


/**
 * 刷新界面
 */
function log(info) {
	if (typeof info == "object") {
		info = JSON.stringify(info);
	}
	$("#log").html(info + "<br>" + $("#log").html());
}

function showError(info) {
    $("#load-text").html(info);
    $(".container").hide();
    hideAllControl();
    $(".load .point-scale-party").hide();
    $(".load").show();
}

function showLoading(info) {
	$("#load-text").html(info);
    $(".container").hide();
    hideAllControl();
    $(".load .point-scale-party").show();
    $(".load").show();
}

function showBrightControl() {
	$(".back").show();
	$("#bright-div").show();
	$(".bright").addClass("selected");
}
function hideBrightControl() {
	$(".back").hide();
	$("#bright-div").hide();
	$(".bright").removeClass("selected");
}

function showColorControl() {
	$(".back").show();
	$("#color-div").show();
	$(".color").addClass("selected");
}
function hideColorControl() {
	$(".back").hide();
	$("#color-div").hide();
	$(".color").removeClass("selected");
}

function hideAllControl(animate) {
	$(".bright,.color,.delay").addClass("disable").removeClass("selected");
	var lastControl = $("#bright-div:not(:hidden),#color-div:not(:hidden)")
	if (animate) {
		$(".back").fadeOut();
		$(".back").data("lastControl",lastControl)
		lastControl.fadeOut();
	}else {
		$(".back").hide();
		lastControl.hide();
	}
	$("#delay-list").modal("hide");
}

function renderDelayButton() {
	if (Control.controlDevice && Control.controlDevice.delay) {
		$(".switch-delay .delay").addClass("delaying");
	}else {
		$(".switch-delay .delay").removeClass("delaying");
	}
}

function showLastControl() {
	$(".bright,.color,.delay").removeClass("disable");
	$(".back").fadeIn();
	var lastControl = $(".back").data("lastControl");
	if (!lastControl) {
		lastControl = $("#bright-div");
	}
	if (lastControl.is("#bright-div")) {
		$(".bright").addClass("selected");
	}else {
		$(".color").addClass("selected");
	}
	$(lastControl).fadeIn();
	
}

function getDeviceDetailInfos() {
	var connected = 0;
	var connecting = false;
	var reconnecting = false;
	for (deviceId in Control.deviceList) {
		var device = Control.deviceList[deviceId];
		if (device.state == "connected") {
			connected++;
		}else if (device.state == "connecting") {
			connecting = true;
		}else if (device.state == "reconnecting") {
			reconnecting = true;
		}
	}
	if (connected) {
		if (controlDeviceId) {
			Control.controlDevice = Control.deviceList[controlDeviceId];
			if (Control.controlDevice) {
				Control.getDeviceInfo(controlDeviceId, function() {
					startControl();
				});
			}else {
				showError('尚未绑定该设备');
			}
			
			return;
		}
		
		
		var devicesIds = Object.keys(Control.deviceList);
		if (devicesIds.length == 1) {
			
			Control.controlDevice = Control.deviceList[devicesIds[0]];
			Control.getDeviceInfo(devicesIds[0], function() {

				startControl();
			});
		}else if (devicesIds.length > 1) {
			Control.controlDevice = null;
			
			var rowStr = '<div class="modal-header row device-row">'+
	      	'<div class="col-xs-1 index">0</div>'+
	      	'<div class="col-xs-8"><label class="modal-title name" style="display:none">设备1</label></div>'+
	        '<div class="col-xs-3 status text-right"><p class="text-success">已连接</p></div>'+
	        '</div>';
			var index = 1;
			var container = $("#light-list .container-fluid");
			container.children().remove();
			for (deviceId in Control.deviceList) {
				var device = Control.deviceList[deviceId];
				
				var row = $(rowStr);
				container.append(row);
				
				row.data("deviceId", device.deviceId);
				row.attr("id", device.deviceId);
				$(".index", row).text(index);
				renderRowStatus(row);
				if (!device.name) {
					getName(deviceId, function(_deviceId, _deviceName){
						var _row = $("#" + _deviceId);
						Control.deviceList[_deviceId].name = _deviceName;
						var nameField = $(".name", _row);
						nameField.text(_deviceName);
						nameField.fadeIn();
					});
				}
				
				row.bind("click", function(){
					
					var deviceId = $(this).data("deviceId");
					var device = Control.deviceList[deviceId];
					if (device.state = "connected") {
						Control.controlDevice =  Control.deviceList[deviceId];
						startControl();
						$("#light-list").modal("hide");
					}
				});
				
				if (device.state != "connected" || !device.type) {
					row.hide();
					Control.getDeviceInfo(device.deviceId, function(_devicesId) {
						var _row = $("#" + _devicesId);
						_row.show();
						$(".device-row:not(:hidden)").each(function(index) {
							$(".index", this).text(index + 1);
						});
						$("#light-list").trigger('shown.bs.modal');
					});
				}
				index++
			}
			$("#light-list").modal();
		}
	}else if (connecting) {
		showLoading('连接中');
		return;
	}else if (reconnecting) {
		showLoading('设备断开连接,正在尝试重连');
		return;
	}else {
		showError('附近没有可连接的设备');
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
function renderRowStatus(row) {
 	var device = Control.deviceList[row.attr("id")];
	if (device.state == "connected") {
		$(".status p", row).text("已连接").attr("class","").addClass("text-success");
	}else if (device.state == "connecting") {
		$(".status p", row).text("连接中").attr("class","").addClass("text-warning");
	}else if (device.state == "reconnecting") {
		$(".status p", row).text("重连中").attr("class","").addClass("text-warning");
	}else{
		$(".status p", row).text("未连接").attr("class","").addClass("text-danger");
	}
}

function startControl() {
	if (Control.controlDevice.state == "connected") {
		
		/* if(Control.controlDevice.name) {
			$("title").text(Control.controlDevice.name);
		} else {
			getName(Control.controlDevice.deviceId, function(_deviceId, _deviceName) {
				Control.controlDevice.name = _deviceName;
				$("title").text(_deviceName);
			})
		} */
		
		$(".container").show();
		$(".load").hide();
		if (Control.controlDevice.powerState) {
			showLastControl();
		}else {
			hideAllControl();
		}
		$(".change-light").val((Control.controlDevice.bright - 30) / 2.25).trigger("change");
	    $("#control-div").slideDown();
	    renderDelayButton()
		return;
	}else if (Control.controlDevice.state == "connecting") {
		showLoading('连接中');
	}else if (Control.controlDevice.state == "reconnecting") {
		showLoading('设备断开连接,正在尝试重连');
	}else {
		showError('附近没有可连接的设备');
	}
	
	if(Object.keys(Control.deviceList).length > 1) {
		getDeviceDetailInfos()
	}
}
</script>



<!-- 微信控制 -->
<script type="text/javascript">
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
		
        for (var i = 0; i < num; i++) {
        	var deviceId = res.deviceInfos[i].deviceId;
        	var state = res.deviceInfos[i].state;
        	
        	if (Control.deviceList[deviceId] == undefined) {
        		var device = new Device();
        		device.state = state;
        		device.deviceId = deviceId;
        		device.getStatus();
        		Control.deviceList[deviceId] = device;
        	}
        }
        getDeviceDetailInfos();
    });
	
  //设备状态改变
    WeixinJSBridge.on('onWXDeviceStateChange', function (argv) {
    	
    	var device = Control.deviceList[argv.deviceId];
    	device.state = argv.state;
    	var row = $("#" + device.deviceId);
    	if (row.length) {
        	renderRowStatus(row);
        	if (device.state == "connected") {
        		row.show();
        	}else {
        		row.hide();
        	}
        	$("#light-list").trigger('shown.bs.modal');
    	}
    	if (!Control.controlDevice) {
    		getDeviceDetailInfos();
    	}else if (device.deviceId == Control.controlDevice.deviceId) {
    		startControl();
    	}
    });
    //监听设备消息
    WeixinJSBridge.on('onReceiveDataFromWXDevice', function (argv) {
        Sender.receiveData(argv);
        
    });
    //监听蓝牙状态
    WeixinJSBridge.on('onWXDeviceBluetoothStateChange', function (argv) {
        if (argv.state === 'off') {
            showError('蓝牙关闭，设备断开连接');
        }
    });
    
});

</script>


<script type="text/javascript">

function Device() {
	
	var that = this;
	this.name = "";
	this.deviceId = "";
	this.state = "";
	this.type = "";
	this.delay = 0;
	this.delayStartDate;
	
	this.bright = 50;
	this.rgbw = {
			red:0,
			green:0,
			blue:0,
			white:0,
	}
	this.powerState = false;//true -> on, false ->off
	
	this.powerOn = function() {
		Sender.sendData(this.deviceId, "poweron");
		this.powerState = true;
	}
	
	this.powerOff = function() {
		Sender.sendData(this.deviceId, "poweroff");
		this.powerState = false;
	}
	
	this.changeBright = function(bright) {
		this.bright = bright;
		Sender.sendData(this.deviceId, "bright:" + parseInt(bright));

	}
	
	this.changRGBW = function(rgbw) {
		this.rgbw = rgbw;
		var data = "color:" + this.rgbw.red + "," + this.rgbw.green + "," + this.rgbw.blue + "," + this.rgbw.white;
		Sender.sendData(this.deviceId, data);
	}
	
	this.changeDelay = function(delay) {
		this.delay = delay;
		this.delayStartDate = Date.now();
		var data = "delay:" + this.delay;
		Sender.sendData(this.deviceId, data);
	}
	
	this.getStatus = function() {
		
	}
	
	this.sendStatus = function() {
		var data = "status:" + parseInt(this.bright) + "," + this.rgbw.red + "," + this.rgbw.green + "," + this.rgbw.blue + "," + this.rgbw.white;
		Sender.sendData(this.deviceId, data);
		
	}
	
	
}
var Control = {};
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
	namespace.sendingInterval = (function() {
		if (navigator.userAgent.indexOf("QQBrowser") != -1) {
			return;
		}
		return setInterval(function(){
			if (namespace.startSend) {
				Control.controlDevice.sendStatus();
			}
		}, 100);
	})()
		
		
		
		
		
	
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

(function (namespace) {

	namespace.deviceList = {};
	namespace.controlDevice;
	
	namespace.sendCommand = function (cmd) {
		this.controlDevice[cmd]();
	}
	
	namespace.changeLight = function (value, needSend) {
		var bright = 30 + 2.25 * value;
		
		if (needSend) {
			this.controlDevice.changeBright(bright);
		}else {
			this.controlDevice.bright = bright;
		}
	}

	namespace.changeRGBW = function (rgbw, needSend) {
		if (needSend) {
			this.controlDevice.changRGBW(rgbw);
		}else {
			this.controlDevice.rgbw = rgbw;
		}
	}

	namespace.startSend = function () {
		Sender.startSend = true;
	}

	namespace.stopSend = function () {
		Sender.startSend = false;
	}
	
	namespace.getDeviceInfo = function(deviceId, callback) {
		Sender.sendTask(deviceId, "getinfo:{sequence}", function(_deviceId, args) {
			var device = namespace.deviceList[_deviceId];
			device.type = args[0];
			//device.name = unescape(base64_decode(args[1]));
			device.powerState = args[2] == "on";
			if (device.powerState) {
				device.delay = parseInt(args[3]);
			}else {
				device.delay = 0;
			}
			device.delayStartDate = Date.now();
			device.bright = parseInt(args[4]);
			device.rgbw.red = parseInt(args[5]);
			device.rgbw.green = parseInt(args[6]);
			device.rgbw.blue = parseInt(args[7]);
			device.rgbw.white = parseInt(args[8]);
			callback(_deviceId)
		});
	}
	
})(Control)

</script>
</body>
</html>