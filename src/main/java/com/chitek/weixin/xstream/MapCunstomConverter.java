package com.chitek.weixin.xstream;

import java.util.HashMap;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Map.Entry;

import com.thoughtworks.xstream.XStream;
import com.thoughtworks.xstream.converters.MarshallingContext;
import com.thoughtworks.xstream.converters.UnmarshallingContext;
import com.thoughtworks.xstream.converters.collections.AbstractCollectionConverter;
import com.thoughtworks.xstream.io.HierarchicalStreamReader;
import com.thoughtworks.xstream.io.HierarchicalStreamWriter;
import com.thoughtworks.xstream.mapper.Mapper;

public class MapCunstomConverter extends AbstractCollectionConverter {

	public MapCunstomConverter(Mapper mapper) {
		super(mapper);
	}

	@Override
	@SuppressWarnings("rawtypes")
	public boolean canConvert(Class type) {
		return type.equals(HashMap.class)  
                || type.equals(Hashtable.class)  
                || type.equals(LinkedHashMap.class);
	}

	@Override
	@SuppressWarnings("rawtypes")
	public void marshal(Object source, HierarchicalStreamWriter writer, MarshallingContext context) {
		writeMap((Map)source, writer);

	}
	
	@SuppressWarnings("rawtypes")
	private void writeMap(Map map, HierarchicalStreamWriter writer) {
		for (Iterator iterator = map.entrySet().iterator(); iterator.hasNext();) {  
            Entry entry = (Entry) iterator.next();  
            writer.startNode((String)entry.getKey());
            Object value = entry.getValue();
            if (value instanceof String) {
            	writer.setValue((String)value);
            }else if (value instanceof Map) {
            	writeMap((Map)value, writer);
            }
            writer.endNode();  
        }

	}

	@SuppressWarnings({ "rawtypes" })
	@Override
	public Object unmarshal(HierarchicalStreamReader reader, UnmarshallingContext context) {
		Map map = (Map) createCollection(context.getRequiredType());
		populateMap(reader, context, map);
		return map;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private void populateMap(HierarchicalStreamReader reader, UnmarshallingContext context, Map map) {
		while (reader.hasMoreChildren()) {  
            reader.moveDown();
            Object key = reader.getNodeName();
            Object value = null;
            if (reader.hasMoreChildren()) {
            	Map children = (Map) createCollection(context.getRequiredType());
            	populateMap(reader, context, children);
            	value = children;
            }else {
            	value = reader.getValue();
            }
            map.put(key, value);  
            reader.moveUp();  
        }
	}

	

	
	
	@SuppressWarnings({ "rawtypes" })
	public static void main(String[] args) {
		String testData = "<xml><ToUserName><![CDATA[gh_04940a19051e]]></ToUserName>"+
		"<FromUserName><![CDATA[omkhquKD-I-b-wZxs1bYL1oAQfKY]]></FromUserName>"+
		"<CreateTime>1461294371</CreateTime>"+
		"<MsgType><![CDATA[event]]></MsgType>"+
		"<Event><![CDATA[scancode_push]]></Event>"+
		"<EventKey><![CDATA[rselfmenu_0_1]]></EventKey>"+
		"<ScanCodeInfo><ScanType><![CDATA[qrcode]]></ScanType>"+
		"<ScanResult><![CDATA[http://we.qq.com/d/AQCaSGq4Z5Sbxk8FaIOPd2UHLcIUq1cP-dQ2gA-m]]></ScanResult>"+
		"</ScanCodeInfo>"+
		"</xml>";
		
		XStream xs = XStreamUtil.mapXStream();
		xs.alias("xml", Map.class);
		
		Map map = (Map) xs.fromXML(testData.toString());
		String xml = xs.toXML(map);
		System.out.println(xml);
	}
	
}
