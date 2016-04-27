package com.chitek.model.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.chitek.manager.HttpUtil;
import com.chitek.model.dao.BLEDeviceMapper;
import com.chitek.model.entity.BLEDevice;
import com.chitek.wechat.Wechat;

import net.sf.json.JSONObject;

@Service("deviceServcie")
public class BLEDeviceService {

	@Resource
	private BLEDeviceMapper dao;
	
	public BLEDevice getDeviceById(String deviceId) {
		return dao.selectByPrimaryKey(deviceId);
	}
	

	public List<BLEDevice> listAll() {
		return dao.selectAll();
	}
	
	public BLEDevice createDevice() {
		JSONObject json = HttpUtil.doGet("https://api.weixin.qq.com/device/getqrcode?access_token=" + Wechat.shareInfo().getAccessToken()+"&product_id=" + Wechat.lightProductID);
		JSONObject resp = json.getJSONObject("base_resp");
		
		BLEDevice device = new BLEDevice();
		
		int retCode = resp.getInt("errcode");
		if (retCode == 0) {
			device.setDeviceId(json.getString("deviceid"));
 			device.setQrticket(json.getString("qrticket"));
			device.setDeviceLicence(json.getString("devicelicence"));
			dao.insert(device);
			
		}else {
			throw new RuntimeException("devcie create faild, " + resp);
		}
		
		return device;
	}
	
	public Boolean update(BLEDevice device) {
		
		
		Map<String, String> deviceMap = new HashMap<String, String>();
		deviceMap.put("id", device.getDeviceId());
		deviceMap.put("mac", device.getMac());
		deviceMap.put("connect_protocol", device.getConnectProtocol());
		deviceMap.put("auth_key", device.getAuthKey());
		deviceMap.put("close_strategy", device.getCloseStrategy().toString());
		deviceMap.put("conn_strategy", device.getConnStrategy().toString());
		deviceMap.put("crypt_method", device.getCryptMethod().toString());
		deviceMap.put("auth_ver", device.getAuthKey());
		deviceMap.put("manu_mac_pos", device.getManuMacPos().toString());
		deviceMap.put("ser_mac_pos", device.getSerMacPos().toString());
		
		if (device.getBleSimpleProtocol() == -1) {
			deviceMap.put("ble_simple_protocol", device.getDeviceId());
		}
		

		List<Map<String, String>> deviceList = new ArrayList<Map<String, String>>();
		deviceList.add(deviceMap);	
		
		JSONObject param = new JSONObject();
		param.put("device_num", "1");
		param.put("op_type", "1");
		param.put("device_list", deviceList);
		
		JSONObject json = HttpUtil.doPost("https://api.weixin.qq.com/device/authorize_device?access_token=" + Wechat.shareInfo().getAccessToken(), param);
		dao.updateByPrimaryKey(device);
		return true;
		
		
	}
	
	public Boolean updateName(String deviceId, String deviceName) {
		BLEDevice device = getDeviceById(deviceId);
		if (device == null) {
			return false;
		}
		device.setDeviceName(deviceName);
		dao.updateByPrimaryKey(device);
		return true;
	}
	
}
