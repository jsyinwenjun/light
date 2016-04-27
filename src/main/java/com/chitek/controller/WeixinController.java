package com.chitek.controller;

import java.io.IOException;
import java.util.Calendar;
import java.util.LinkedHashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletInputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.chitek.model.entity.BLEDevice;
import com.chitek.model.entity.WechatUser;
import com.chitek.model.service.BLEDeviceService;
import com.chitek.model.service.WechatUserService;
import com.chitek.wechat.Wechat;
import com.chitek.weixin.MsgType;
import com.chitek.weixin.xstream.MsgConstants;
import com.chitek.weixin.xstream.XStreamUtil;
import com.thoughtworks.xstream.XStream;

@Controller
@RequestMapping("/weixin")
public class WeixinController {

	private static Logger logger = Logger.getLogger(WeixinController.class);
	
	@Resource
	private WechatUserService wechatUserService;
	
	@Resource
	private BLEDeviceService deviceServcie;
	
	@RequestMapping("control")
	public String startControl(HttpServletRequest request,Model model) {
		System.out.println(request.getHeader("User-Agent"));
		Wechat wechat = Wechat.shareInfo();
		Map<String, String> jsSign = wechat.getJsSignMap(request);
		model.addAttribute("jsSign", jsSign);
		return "weixin/control";
	}
	
	
	@RequestMapping("lightlist")
	public String lightList(HttpServletRequest request,Model model) {
		Wechat wechat = Wechat.shareInfo();
		Map<String, String> jsSign = wechat.getJsSignMap(request);
		model.addAttribute("jsSign", jsSign);
		return "weixin/lightlist";
	}
	
	@RequestMapping("lightadd")
	public String lightAdd(HttpServletRequest request,Model model) {
		WechatUser wechatUser = (WechatUser)request.getSession().getAttribute("wechatUser");
		if (wechatUser == null) {
			return "redirect:https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx1c70081a271e4bbe&redirect_uri=http%3A%2F%2Fweixin.chi-tek.com%2Flight%2Fservice%2Fweixin%2Fget_open_id&response_type=code&scope=snsapi_userinfo&state=%2Fservice%2Fweixin%2Flightadd#wechat_redirect";
		}else {
			model.addAttribute("wechatUser", wechatUser);
		}
		
		Wechat wechat = Wechat.shareInfo();
		Map<String, String> jsSign = wechat.getJsSignMap(request);
		model.addAttribute("jsSign", jsSign);
		return "weixin/light_add";
	}
	
	@RequestMapping("mydevice")
	public String myDevice(HttpServletRequest request,Model model) {
		
		Wechat wechat = Wechat.shareInfo();
		Map<String, String> jsSign = wechat.getJsSignMap(request);
		model.addAttribute("jsSign", jsSign);
		
		
		return "weixin/my_device";
	}
	
	@RequestMapping("get_open_id")
	public String getOpenId(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String code = request.getParameter("code");
		String state = request.getParameter("state");
		WechatUser wechatUser = Wechat.shareInfo().getOpenidByCode(code);

		WechatUser user = wechatUserService.getUserByOpenid(wechatUser.getOpenid());
		if (user == null) {
			user = wechatUser;
			wechatUserService.insert(user);
		}else {

			user.setAccessToken(wechatUser.getAccessToken());
			user.setAccessTokenDate(wechatUser.getAccessTokenDate());
			user.setRefreshToken(wechatUser.getRefreshToken());
			user.setRefreshTokenDate(wechatUser.getRefreshTokenDate());
			user.setScope(wechatUser.getScope());
			wechatUserService.update(user);
		}
		
		request.getSession().setAttribute("wechatUser", user);
		return "redirect:" + state;
	}
	
	@RequestMapping("device/bind")
	public void bindDevice(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String ticket = request.getParameter("ticket");
		String deviceId = request.getParameter("device_id");
		String openid = request.getParameter("openid");
		
		boolean success = Wechat.shareInfo().bindDevice(ticket, deviceId, openid);
		
		if (success) {
			String deviceName = request.getParameter("device_name");
			deviceServcie.updateName(deviceId, deviceName);
		}
		
		response.setCharacterEncoding("utf8");
		
		response.getWriter().write("{\"success\":" + success +"}");
		
	}
	
	@RequestMapping("device/getname")
	public void getDeviceName(HttpServletRequest request, HttpServletResponse response) throws IOException {
		response.setCharacterEncoding("utf8");
		String deviceId = request.getParameter("device_id");
		BLEDevice device = deviceServcie.getDeviceById(deviceId);
		if (device == null) {
			response.getWriter().write("{\"success\":false, \"errmsg\":\"device not exist\"}");
		}else {
			response.getWriter().write("{\"success\":true, \"device_name\":\"" + device.getDeviceName() + "\", \"device_id\":\"" + device.getDeviceId() + "\"}");
		}
	}
	
	@RequestMapping("device/setname")
	public void setDeviceName(HttpServletRequest request, HttpServletResponse response) throws IOException {
		response.setCharacterEncoding("utf8");
		String deviceId = request.getParameter("device_id");
		String deviceName = request.getParameter("device_name");
		
		Boolean isSuccess = deviceServcie.updateName(deviceId, deviceName);
		response.getWriter().write("{\"success\":" + isSuccess + "}");
	}


	@RequestMapping("notify")
	public void messageGet(HttpServletRequest request, HttpServletResponse response) {
		boolean isGet = request.getMethod().toLowerCase().equals("get");
		if (isGet) {
            access(request, response);
        } else {
            // 进入POST聊天处理
            try {
                // 接收消息并返回消息
                acceptMessage(request, response);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
	}
	
	@SuppressWarnings("rawtypes")
	private void acceptMessage(HttpServletRequest request, HttpServletResponse response) throws IOException {
		ServletInputStream in = request.getInputStream(); 
		
		StringBuilder xmlMsg = new StringBuilder();  
        byte[] b = new byte[4096];  
        for (int n; (n = in.read(b)) != -1;) {  
            xmlMsg.append(new String(b, 0, n, "UTF-8"));  
        }
        
        System.out.println("####################################");
        System.out.println(xmlMsg);
        System.out.println("####################################");
        
        XStream xs = XStreamUtil.mapXStream();
		xs.alias("xml", LinkedHashMap.class);
		
		Map map = (Map) xs.fromXML(xmlMsg.toString());
		
		String servername = (String)map.get(MsgConstants.ToUserName);// 服务端  
        String custermname = (String)map.get(MsgConstants.FromUserName);// 客户端 
        Long returnTime = Calendar.getInstance().getTimeInMillis() / 1000;// 返回时间  
  
        // 取得消息类型  
        String msgType = (String)map.get(MsgConstants.MsgType);  
        // 根据消息类型获取对应的消息内容  
        if (msgType.equals(MsgType.Text.toString())) {  
            // 文本消息
  
        	Map<String, String> returnMap = new LinkedHashMap<String, String>();
        	returnMap.put(MsgConstants.ToUserName, custermname);
        	returnMap.put(MsgConstants.FromUserName, servername);
        	returnMap.put(MsgConstants.CreateTime, returnTime.toString());
        	returnMap.put(MsgConstants.MsgType, msgType);
        	returnMap.put(MsgConstants.Content, map.get(MsgConstants.Content).toString());

            response.setCharacterEncoding("utf8");
            
            String resp = xs.toXML(returnMap);
            System.out.println("####################################");
            System.out.println(resp);
            System.out.println("####################################");
            response.getWriter().write(resp);  
        }
		
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	private String access(HttpServletRequest request, HttpServletResponse response) {  
        // 验证URL真实性
        String signature = request.getParameter("signature");// 微信加密签名
        String timestamp = request.getParameter("timestamp");// 时间戳
        String nonce = request.getParameter("nonce");// 随机数
        String echostr = request.getParameter("echostr");// 随机字符串
        boolean isAuth =  Wechat.checkSignature(signature, timestamp, nonce);
        if (isAuth) {
            try {
                response.getWriter().write(echostr);
                logger.info("成功返回 echostr：" + echostr);
                return echostr;
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return null;  
    }
}
