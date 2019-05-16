package com.enpem.web.common.biz;

import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.stereotype.Component;

import com.enpem.web.common.data.Box;

@Component
public class MsgLocator implements ApplicationListener<ContextRefreshedEvent> {
	protected Logger log = LoggerFactory.getLogger(this.getClass());

	private boolean initialized = false;
	private String messageData;
	ConcurrentMap<String, ConcurrentMap<String, Box>> msgMap = new ConcurrentHashMap<String, ConcurrentMap<String, Box>>();

	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSessionTemplate dao;

	public Box getMsgBox(String msgId) {
		ConcurrentMap<String, Box> msgInfoMap = msgMap.get(msgId);
		Box msgBox = null;
		if(msgId != null && msgInfoMap != null) {
			msgBox = msgInfoMap.get(msgId);
		}
		return msgBox;
	}

	public void initialize() {

		List<Box> msgList = dao.selectList("cmn.msgAllList");
		ConcurrentMap<String, Box> msgInfoMap = null;
		Box inBox = null;
		for(int i=0, s=msgList.size(); i<s; i++) {
			inBox = msgList.get(i);
			msgInfoMap = msgMap.get(inBox.nvl("msgId"));
			if(msgInfoMap == null) {
				msgInfoMap = new ConcurrentHashMap<String, Box>();
				msgMap.put(inBox.nvl("msgId"), msgInfoMap);
			}
			msgInfoMap.put(inBox.nvl("msgId"), inBox);
		}

		if (null != msgList && !msgList.isEmpty()) {
			try {
				this.fileCreate(msgList);
			} catch (Exception e) {
				log.error(e.getMessage(), e);
			}
		}
	}

	public String getData() {
		return messageData;
	}

	public void fileCreate(List<Box> list) throws Exception {

		StringBuffer sb = new StringBuffer();
		StringBuffer rows = new StringBuffer();
		sb.append("window['gMsgList'] =\n");
		sb.append("	[\n");
		sb.append("		%rows%");
		sb.append("	]\n");
		String line = "	{'msgId': '%msgId%', 'msgType': '%msgType%', 'msgTypeNm': '%msgTypeNm%', 'msgNm': '%msgNm%'"
					+ ", 'msgDesc': '%msgDesc%', 'cd': '%msgId%', 'nm': '%msgNm%'},\n";

		for (int idx = 0; idx < list.size(); idx++) {
			String str = "";
			Box inBox = (Box)list.get(idx);
			if (null != inBox) {
				str = line.replaceAll("%msgId%", inBox.nvl("msgId").trim())
						.replaceAll("%msgType%", inBox.nvl("msgType").trim())
						.replaceAll("%msgTypeNm%", inBox.nvl("msgTypeNm").trim())
						.replaceAll("%msgNm%", inBox.nvl("msgNm").trim())
						.replaceAll("%msgDesc%", inBox.nvl("msgDesc").trim());
				rows.append(str);
			}
		}
		messageData = sb.toString().replaceAll("%rows%", rows.toString());

//		BufferedWriter out = new BufferedWriter(new FileWriter(repo + "msgList.jss"));
//		out.write(sb.toString().replaceAll("%rows%", rows.toString()));
//		out.close();
	}

	public void afterPropertiesSet() throws Exception {
		initialize();
	}

	@Override
	public void onApplicationEvent(ContextRefreshedEvent event) {
		if (!initialized) {
			initialize();
			initialized = true;
		}
	}
}
