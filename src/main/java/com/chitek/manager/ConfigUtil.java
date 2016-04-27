package com.chitek.manager;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class ConfigUtil {

	private static Properties properties;
	
	static {
		InputStream inputStream = ConfigUtil.class.getClassLoader().getResourceAsStream("app.properties");
		properties = new Properties();
		try{
			properties.load(inputStream);
		} catch (IOException e1){
			e1.printStackTrace();
		}
	}
	
	public static String getProperty(String key) {
		return properties.getProperty(key);
	}
	
	public static String getProperty(String key, String defaultValue) {
		return properties.getProperty(key, defaultValue);
	}
	
	public static String loadConfigFile(String fileName) {
		String path = ConfigUtil.class.getClassLoader().getResource("config/" + fileName).getPath();
		return readString(path);
	}
	
	private static String readString(String path) {
		FileInputStream inStream = null;
		ByteArrayOutputStream bos = null;
        try {
			inStream = new FileInputStream(path);
			bos = new ByteArrayOutputStream();
			byte[] buffer=new byte[1024];
			int length=-1;
			while( (length = inStream.read(buffer)) != -1) {
			    bos.write(buffer,0,length);
			}
			return bos.toString();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}finally {
			try {
				bos.close();
				inStream.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
        return null;
    }
	
	public static void saveConfigFile(String fileName, String fileContent) {
		String path = ConfigUtil.class.getClassLoader().getResource("config/" + fileName).getPath();
		writeString(path, fileContent);
	}
	
	private static void writeString(String path,  String fileContent) {
		FileWriter fw = null;
		try {
		    fw = new FileWriter(new File(path));
		    fw.write(fileContent);
		    
		} catch (IOException e) {
		    e.printStackTrace();
		}finally {
			try {
				fw.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
    }
}
