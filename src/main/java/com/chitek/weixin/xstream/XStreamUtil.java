package com.chitek.weixin.xstream;

import java.io.Writer;

import com.thoughtworks.xstream.XStream;
import com.thoughtworks.xstream.core.util.QuickWriter;
import com.thoughtworks.xstream.io.HierarchicalStreamWriter;
import com.thoughtworks.xstream.io.xml.PrettyPrintWriter;
import com.thoughtworks.xstream.io.xml.XppDriver;
import com.thoughtworks.xstream.mapper.DefaultMapper;

public class XStreamUtil {

	public static final String[] ignoreCData = {
			MsgConstants.CreateTime
	};
	
	
	
	public static XStream mapXStream() {
		XStream xs = new XStream(new XppDriver() {  
            @Override  
            public HierarchicalStreamWriter createWriter(Writer out) {  
                return new PrettyPrintWriter(out) {
                	
                	boolean cdata = false;
                	@Override  
                    public void startNode(String name) {  
                        super.startNode(name);
                        if (!name.equals("xml")) {  
                        	for (String nodeName : ignoreCData) {
                            	if (nodeName.equals(name)) {
                            		cdata = false;
                            		return;
                            	}
                            }
                            cdata = true; 
                        }else {
                        	cdata = false; 
                        }
                    } 
                	
                	@Override
                    protected void writeText(QuickWriter writer, String text) {
                		if (cdata) {
                			writer.write("<![CDATA[" + text + "]]>");  
                		}else {
                			writer.write(text);  
                		}
                    }  
                };  
            }  
        });
		xs.registerConverter(new MapCunstomConverter(new DefaultMapper(XStreamUtil.class.getClassLoader())));
		return xs;
	}
}
