package com.chitek.model.service;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.chitek.model.dao.UserMapper;
import com.chitek.model.entity.User;

@Service("userService")
public class UserService {

	@Resource
	private UserMapper dao;
	
	public User getUserByName(String userName) {
		return dao.selectByName(userName);
	}
	
	public User getUserById(Integer id) {
		return dao.selectByPrimaryKey(id);
	}
}
