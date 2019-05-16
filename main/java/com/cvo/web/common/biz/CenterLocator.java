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
//public class CenterLocator implements ApplicationListener<ContextRefreshedEvent> {
public class CenterLocator {
	protected Logger log = LoggerFactory.getLogger(this.getClass());

	private boolean initialized = false;
	private String centerData;
	ConcurrentMap<String, ConcurrentMap<String, Box>> centerMap = new ConcurrentHashMap<String, ConcurrentMap<String, Box>>();

	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSessionTemplate dao;

	public Box getBox(String centerCd) {
		ConcurrentMap<String, Box> centerInfoMap = centerMap.get(centerCd);
		Box centerBox = null;
		if(centerCd != null && centerInfoMap != null) {
			centerBox = centerInfoMap.get(centerCd);
		}
		return centerBox;
	}

	public void initialize() {

		List<Box> centerList = dao.selectList("cmn.centerList");
		ConcurrentMap<String, Box> centerInfoMap = null;
		Box inBox = null;
		for(int i=0, s=centerList.size(); i<s; i++) {
			inBox = centerList.get(i);
			centerInfoMap = centerMap.get(inBox.nvl("cd"));
			if(centerInfoMap == null) {
				centerInfoMap = new ConcurrentHashMap<String, Box>();
				centerMap.put(inBox.nvl("cd"), centerInfoMap);
			}
			centerInfoMap.put(inBox.nvl("cd"), inBox);
		}

		if (null != centerList && !centerList.isEmpty()) {
			try {
				this.fileCreate(centerList);
			} catch (Exception e) {
				log.error(e.getMessage(), e);
			}
		}
	}

	public String getData() {
		return centerData;
	}

	public void fileCreate(List<Box> list) throws Exception {

		StringBuffer sb = new StringBuffer();
		StringBuffer rows = new StringBuffer();
		sb.append("window['gCenterList'] =\n");
		sb.append("	[\n");
		sb.append("		%rows%");
		sb.append("	]\n");

		String line = "	{'cd': '%cd%', 'nm': '%nm%', 'enpemZip': '%enpemZip%', 'enpemSi': '%enpemSi%', 'enpemAddr': '%enpemAddr%', 'xpos': '%xpos%', 'ypos': '%ypos%'},\n";
		for (int idx = 0; idx < list.size(); idx++) {
			String str = "";
			Box inBox = (Box)list.get(idx);
			if (null != inBox) {
				str = line.replaceAll("%cd%", inBox.nvl("cd").trim())
						.replaceAll("%nm%", inBox.nvl("nm").trim())
						.replaceAll("%enpemZip%", inBox.nvl("enpemZip").trim())
						.replaceAll("%enpemSi%", inBox.nvl("enpemSi").trim())
						.replaceAll("%enpemAddr%", inBox.nvl("enpemAddr").trim())
						.replaceAll("%xpos%", inBox.nvl("xpos").trim())
						.replaceAll("%ypos%", inBox.nvl("ypos").trim());
				rows.append(str);
			}
		}
		centerData = sb.toString().replaceAll("%rows%", rows.toString());

//		BufferedWriter out = new BufferedWriter(new FileWriter(repo + "centerList.jss"));
//		out.write(sb.toString().replaceAll("%rows%", rows.toString()));
//		out.close();
	}

	public void afterPropertiesSet() throws Exception {
		initialize();
	}

//	@Override
//	public void onApplicationEvent(ContextRefreshedEvent event) {
//		if (!initialized) {
//			initialize();
//			initialized = true;
//		}
//	}
}
