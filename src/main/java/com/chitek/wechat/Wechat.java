package com.chitek.wechat;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import com.chitek.manager.ConfigUtil;
import com.chitek.manager.HttpUtil;
import com.chitek.model.entity.WechatUser;

import net.sf.json.JSONObject;

public class Wechat {
	
	private static Logger logger = Logger.getLogger(Wechat.class);
	
	public static String appid = ConfigUtil.getProperty("weixin.appid");

	public static String secret = ConfigUtil.getProperty("weixin.secret");
	
	public static String lightProductID = ConfigUtil.getProperty("weixin.lightproductid");
	
	public static String token = ConfigUtil.getProperty("weixin.token");
	
	private static Wechat instance;
	private Timer timer;

	private String accessToken;
	private String jsapiTicket;
	
	private Date lastUpdateDate;

	public String getAccessToken() {
		return accessToken;
	}

	public void setAccessToken(String accessToken) {
		this.accessToken = accessToken;
	}

	public String getJsapiTicket() {
		return jsapiTicket;
	}

	public void setJsapiTicket(String jsapiTicket) {
		this.jsapiTicket = jsapiTicket;
	}

	public Date getLastUpdateDate() {
		return lastUpdateDate;
	}

	public void setLastUpdateDate(Date lastUpdateDate) {
		this.lastUpdateDate = lastUpdateDate;
	}
	
	public static Wechat shareInfo() {
		if (instance == null) {
			instance = new Wechat();
			instance.refreshToken();
		}
		return instance;
	}
	
	private Wechat() {}
	
	public void refreshToken() {
		if (timer != null) {
			timer.cancel();
		}
		
		JSONObject json = HttpUtil.doGet("https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid="+appid+"&secret="+secret+"");
		
		if (json.containsKey("errcode")) {
			int errcode = json.getInt("errcode");
			String errmsg = json.getString("errmsg");
			throw new RuntimeException("access_token refresh fail, error code: " + errcode + " error message: " + errmsg);
		}else {
			accessToken = json.getString("access_token");
			logger.info("accessToken: " + accessToken);
			
			int expires = json.getInt("expires_in");
			
			lastUpdateDate = new Date();
			
			timer = new Timer();
			timer.schedule(new TimerTask() {
				
				@Override
				public void run() {
					refreshToken();
					
				}
			}, expires * 1000 - 600000);
			
			refreshJsapiTicket();
		}
	}
	
	public void refreshJsapiTicket() {
		JSONObject json = HttpUtil.doGet("https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token="+ accessToken +"&type=jsapi");
		int errcode = json.getInt("errcode");
		if (errcode != 0) {
			String errmsg = json.getString("errmsg");
			throw new RuntimeException("jsapi_ticket refresh fail, error code: " + errcode + " error message: " + errmsg);
		}else {
			jsapiTicket = json.getString("ticket");
			logger.info("jsapiTicket: " + jsapiTicket);
		}
	}
	
	public Map<String, String> getJsSignMap(HttpServletRequest request) {
		String query = request.getQueryString();
		if (StringUtils.isEmpty(query)) {
			query = "";
		}else {
			query = "?" + query;
		}
		
		String url = request.getRequestURL() + query;
		Map<String, String> map = new HashMap<String, String>();  
		  
        String nonce_str = UUID.randomUUID().toString();  
        String timestamp = Long.toString(System.currentTimeMillis() / 1000);  
        String s = "jsapi_ticket=" + jsapiTicket + "&noncestr=" + nonce_str + "&timestamp=" + timestamp + "&url=" + url;  
 
        String signature = DigestUtils.sha1Hex(s);
        
        map.put("appId", appid);    
        map.put("nonceStr", nonce_str);  
        map.put("timestamp", timestamp);  
        map.put("signature", signature);

		return map;
	}

	

	
	public static boolean checkSignature(String signature, String timestamp, String nonce) {
		List<String> list = new ArrayList<String>();
		list.add(token);
		list.add(timestamp);
		list.add(nonce);
		Collections.sort(list);
		String str = "";
		for (int i = 0; i < list.size(); i++) {
			str += list.get(i);
		}
		String sign = DigestUtils.sha1Hex(str);

		return signature.equals(sign);
	}
	
	
	public void sendMenu(String menu) {
		JSONObject json = HttpUtil.doPost("https://api.weixin.qq.com/cgi-bin/menu/create?access_token=" + accessToken, menu);
		int errcode = json.getInt("errcode");
		if (errcode != 0) {
			String errmsg = json.getString("errmsg");
			throw new RuntimeException("menu create fail, error code: " + errcode + " error message: " + errmsg);
		}
	}
	
	//根据code返回用户openid
	public WechatUser getOpenidByCode(String code) {
		JSONObject json = HttpUtil.doGet("https://api.weixin.qq.com/sns/oauth2/access_token?appid=" + appid + "&secret=" + secret + "&code=" + code + "&grant_type=authorization_code");
		
		
		if (json.containsKey("errcode")) {
			int errcode = json.getInt("errcode");
			String errmsg = json.getString("errmsg");
			throw new RuntimeException("openid get faild, error code: " + errcode + " error message: " + errmsg);
		}
		
		String accessToken = json.getString("access_token");
		String refreshToken = json.getString("refresh_token");
		String openid = json.getString("openid");
		String scope = json.getString("scope");
		
		WechatUser user = new WechatUser();
		user.setOpenid(openid);
		user.setAccessToken(accessToken);
		user.setAccessTokenDate(new Date());
		user.setRefreshToken(refreshToken);
		user.setRefreshTokenDate(new Date());
		user.setScope(scope);
		return user;
		
	}
	
	//绑定设备
	public boolean bindDevice(String ticket, String deviceId, String openid) {
		Map<String, String> content = new HashMap<String, String>();
		content.put("ticket", ticket);
		content.put("device_id", deviceId);
		content.put("openid", openid);

		JSONObject contentJson = JSONObject.fromObject(content);
		
		JSONObject json = HttpUtil.doPost("https://api.weixin.qq.com/device/bind?access_token=" + accessToken, contentJson);
		JSONObject resp = json.getJSONObject("base_resp");
		
		int errcode = resp.getInt("errcode");
		if (errcode != 0) {
			String errmsg = resp.getString("errmsg");
			logger.error("device bind faild, error code: " + errcode + " error message: " + errmsg);
			return false;
		}else {
			return true;
		}
	}
	
}
