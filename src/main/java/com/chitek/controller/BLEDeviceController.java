package com.chitek.controller;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.chitek.model.entity.BLEDevice;
import com.chitek.model.service.BLEDeviceService;

@Controller
@RequestMapping("/device")
public class BLEDeviceController {
	
	@Resource
	private BLEDeviceService deviceServcie;
	
	@RequestMapping("/list")
	public String list(HttpServletRequest request,Model model) {
		List<BLEDevice> devices = deviceServcie.listAll();
		model.addAttribute("devices", devices);
		return "device/list";
	}
	
	@RequestMapping("/create")
	public String create(HttpServletRequest request,Model model) {
		BLEDevice device = deviceServcie.createDevice();
		model.addAttribute("device", device);
		return "device/create";
	}
	
	@RequestMapping("/edit")
	public String edit(HttpServletRequest request,Model model) {
		String deviceId = request.getParameter("deviceid");
		
		BLEDevice device = deviceServcie.getDeviceById(deviceId);
		model.addAttribute("device", device);
		
		return "device/edit";
	}
	
	@RequestMapping("/update")
	public String commit(HttpServletRequest request,Model model) {
		
		BLEDevice device = new BLEDevice();
		device.setDeviceId(request.getParameter("deviceId"));
		device.setQrticket(request.getParameter("qrticket"));
		device.setDeviceLicence(request.getParameter("deviceLicence"));
		device.setCustomData(request.getParameter("customData"));
		device.setMac(request.getParameter("mac"));
		String[] protocols = request.getParameterValues("connectProtocol");
		String protoStr = "";
		for (String proto : protocols) {
			protoStr += proto + "|";
		}
		if (StringUtils.isEmpty(protoStr)) {
			protoStr = "3";
		}else {
			protoStr = protoStr.substring(0, protoStr.length() - 1);
		}
		
		device.setConnectProtocol(protoStr);
		device.setAuthKey(request.getParameter("authKey"));
		device.setCloseStrategy(Integer.valueOf(request.getParameter("closeStrategy")));
		device.setConnStrategy(Integer.valueOf(request.getParameter("connStrategy")));
		device.setCryptMethod(Integer.valueOf(request.getParameter("cryptMethod")));
		device.setAuthVer(Integer.valueOf(request.getParameter("authVer")));
		device.setManuMacPos(Integer.valueOf(request.getParameter("manuMacPos")));
		device.setSerMacPos(Integer.valueOf(request.getParameter("serMacPos")));
		device.setBleSimpleProtocol(Integer.valueOf(request.getParameter("bleSimpleProtocol")));

		Boolean success = deviceServcie.update(device);
		if (success) {
			return "device/success";
		}else {
			return "device/fail";
		}
		
	}
	
}
