package com.chitek.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.chitek.manager.ConfigUtil;
import com.chitek.wechat.Wechat;

@Controller
@RequestMapping("/system")
public class SystemController {

	private static String configFile = "weixin_menu.json";
	
	@RequestMapping("menucreate")
	public String menuCreate(HttpServletRequest request,Model model) {
		String menu = ConfigUtil.loadConfigFile(configFile);
		model.addAttribute("menu", menu);
		return "system/menu_create";
	}
	
	@RequestMapping("domenucreate")
	public String doMenuCreate(HttpServletRequest request,Model model) {
		String menu = request.getParameter("menu");
		
		Wechat.shareInfo().sendMenu(menu);
		ConfigUtil.saveConfigFile(configFile, menu);
		
		return "redirect:/service/system/menucreate";
	}
	
}
