package com.enpem.web.common.biz;

import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;
import java.util.concurrent.CopyOnWriteArrayList;

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
public class CdLocator implements ApplicationListener<ContextRefreshedEvent> {
	protected Logger log = LoggerFactory.getLogger(this.getClass());

	private boolean initialized = false;
	private String cdData;
	private static final String CD_GROUP_KEY = "_ROOT_";
	ConcurrentMap<String, CopyOnWriteArrayList<Box>> cdListMap = new ConcurrentHashMap<String, CopyOnWriteArrayList<Box>>();
	ConcurrentMap<String, ConcurrentMap<String, Box>> cdMap = new ConcurrentHashMap<String, ConcurrentMap<String, Box>>();

	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSessionTemplate dao;

	public List<Box> getCdList(String grpCd) {
		return cdListMap.get(grpCd);
	}

	public Box getCdBox(String grpCd, String cd) {
		ConcurrentMap<String, Box> cdDetailMap = cdMap.get(grpCd);
		Box cdBox = null;
		if(cd != null && cdDetailMap != null) {
			cdBox = cdDetailMap.get(cd);
		}
		return cdBox;
	}

	public void initialize() {

		List<Box> cdList = dao.selectList("cmn.cdAllList");
		Box cdBox = null;
		ConcurrentMap<String, Box> cdDetailMap = null;
		CopyOnWriteArrayList<Box> cdDetailList = null;
		for(int i=0, s=cdList.size(); i<s; i++) {
			cdBox = cdList.get(i);
			cdDetailMap = cdMap.get(cdBox.nvl("grpCd"));
			if(cdDetailMap == null) {
				cdDetailMap = new ConcurrentHashMap<String, Box>();
				cdMap.put(cdBox.nvl("grpCd"), cdDetailMap);
			}
			cdDetailMap.put(cdBox.nvl("cd"), cdBox);
			if(CD_GROUP_KEY.equals(cdBox.nvl("grpCd"))) {
				if("Y".equals(cdBox.nvl("useYn"))) {
					cdListMap.put(cdBox.nvl("cd"), new CopyOnWriteArrayList<Box>());
				}
				continue;
			}
			cdDetailList = cdListMap.get(cdBox.nvl("grpCd"));
			if(cdDetailList != null) {
				if("Y".equals(cdBox.nvl("useYn"))) {
					cdDetailList.add(cdBox);
				}
			}
		}
		if (null != cdList && !cdList.isEmpty()) {
			try {
				this.fileCreate(cdList);
			} catch (Exception e) {
				log.error(e.getMessage(), e);
			}
		}
	}

	public String getData() {
		return cdData;
	}

	public void fileCreate(List<Box> list) throws Exception {

		StringBuffer sb = new StringBuffer();
		StringBuffer rows = new StringBuffer();
		sb.append("window['gCdList'] =\n");
		sb.append("	[\n");
		sb.append("		%rows%");
		sb.append("	]\n");
		String line = "	{'grpCd': '%grpCd%', 'grpNm': '%grpNm%', 'cd': '%cd%', 'useYn': '%useYn%', 'useYnNm': '%useYnNm%', 'cdNm': '%cdNm%'"
						+ ", 'nm': '%cdNm%', 'aplStrDd': '%aplStrDd%', 'aplEndDd': '%aplEndDd%', 'cdDesc': '%cdDesc%'"
						+ ", 'etc1': '%etc1%', 'etc2': '%etc2%', 'etc3': '%etc3%', 'seq': '%seq%'},\n";
		for (int idx = 0; idx < list.size(); idx++) {
			String str = "";
			Box inBox = (Box)list.get(idx);
			if (null != inBox) {
				str = line.replaceAll("%grpCd%", inBox.nvl("grpCd").trim())
						.replaceAll("%grpNm%", inBox.nvl("grpNm").trim())
						.replaceAll("%cd%", inBox.nvl("cd").trim())
						.replaceAll("%useYn%", inBox.nvl("useYn").trim())
						.replaceAll("%useYnNm%", inBox.nvl("useYnNm").trim())
						.replaceAll("%cdNm%", inBox.nvl("cdNm").trim())
						.replaceAll("%aplStrDd%", inBox.nvl("aplStrDd").trim())
						.replaceAll("%aplEndDd%", inBox.nvl("aplEndDd").trim())
						.replaceAll("%cdDesc%", inBox.nvl("cdDesc").trim())
						.replaceAll("%etc1%", inBox.nvl("etc1").trim())
						.replaceAll("%etc2%", inBox.nvl("etc2").trim())
						.replaceAll("%etc3%", inBox.nvl("etc3").trim())
						.replaceAll("%seq%", inBox.nvl("seq").trim());
				rows.append(str);
			}
		}
		cdData = sb.toString().replaceAll("%rows%", rows.toString());

//		BufferedWriter out = new BufferedWriter(new FileWriter(repo + "cdList.jss"));
//		out.write(sb.toString().replaceAll("%rows%", rows.toString()));
//		out.close();
	}


	public void afterPropertiesSet() throws Exception {
		initialize();
	}

	/* (non-Javadoc)
	 * @see org.springframework.context.ApplicationListener#onApplicationEvent(org.springframework.context.ApplicationEvent)
	 */
	@Override
	public void onApplicationEvent(ContextRefreshedEvent event) {
		if (!initialized) {
			initialize();
			initialized = true;
		}
	}

	public static void main(String[] args) {

	}
}
