package com.chitek.manager;


import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.apache.log4j.Logger;

import net.sf.json.JSONObject;

public class HttpUtil {

	private static Logger logger = Logger.getLogger(HttpUtil.class);
	
	public static JSONObject doGet(String url){
		DefaultHttpClient client = new DefaultHttpClient();
		HttpGet get = new HttpGet(url);
		JSONObject response = null;
		logger.info("get url:" + url);
		
		try {
			HttpResponse res = client.execute(get);
			if(res.getStatusLine().getStatusCode() == HttpStatus.SC_OK){
	    		HttpEntity entity = res.getEntity();
	    		String result = EntityUtils.toString(entity);
	    		response = JSONObject.fromObject(result);
	    		logger.info("response data:" + result);
	    	}
		}catch (Exception e) {
			throw new RuntimeException(e);
		}
		
	    return response;
	}
	
	public static JSONObject doPost(String url,String jsonStr){
		DefaultHttpClient client = new DefaultHttpClient();
	    HttpPost post = new HttpPost(url);
	    JSONObject response = null;
	    
	    logger.info("post url: " + url);
	    logger.info("post data: " + jsonStr);
	    
	    try {
	    	StringEntity s = new StringEntity(jsonStr, "utf8");
	    	s.setContentEncoding("UTF-8");
	    	s.setContentType("application/json");
	    	post.setEntity(s);
	    	HttpResponse res = client.execute(post);
	    	if(res.getStatusLine().getStatusCode() == HttpStatus.SC_OK){
	    		HttpEntity entity = res.getEntity();
	    		String result = EntityUtils.toString(entity);
	    		response = JSONObject.fromObject(result);
	    		logger.info("response data: " + result);
	    	    
	    	}
	    } catch (Exception e) {
	    	throw new RuntimeException(e);
	    }
	    return response;
	}
	
	public static JSONObject doPost(String url,JSONObject json){
		return doPost(url, json.toString());
	}
}
