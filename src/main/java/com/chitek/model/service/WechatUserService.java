package com.chitek.model.service;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.chitek.model.dao.WechatUserMapper;
import com.chitek.model.entity.WechatUser;

@Service("wechatUserService")
public class WechatUserService {

	@Resource
	private WechatUserMapper dao;
	
	public WechatUser getUserByOpenid(String openid) {
		return dao.selectByPrimaryKey(openid);
	}
	
	public int insert(WechatUser record) {
		return dao.insert(record);
	}
	
	public int update(WechatUser record) {
		return dao.updateByPrimaryKey(record);
	}
}
