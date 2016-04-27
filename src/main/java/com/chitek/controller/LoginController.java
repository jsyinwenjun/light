package com.chitek.controller;


import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.chitek.model.entity.User;
import com.chitek.model.service.UserService;


@Controller
@RequestMapping("/user")
public class LoginController {
	
	@Resource
	private UserService userService;
	
	@RequestMapping("/login")
	public String login(HttpServletRequest request,Model model) {
		if (request.getSession().getAttribute("user") != null) {
			return "redirect:/service/device/list";
		}
		return "user/login";
	}
	
	@RequestMapping("/dologin")
	public String doLogin(HttpServletRequest request,Model model) {
		String userName = request.getParameter("userName");
		String password = request.getParameter("password");
		
		User user = userService.getUserByName(userName);
		if (user != null) {
			if (user.getUserPassword().equals(password)) {
				request.getSession().setAttribute("user", user);
				return "redirect:/service/device/list";
			}
		}
		model.addAttribute("userName", userName);
		model.addAttribute("err_msg", "用户名或密码错误。");
		return "user/login";
		
	}
}
