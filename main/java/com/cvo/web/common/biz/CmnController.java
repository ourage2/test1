package com.enpem.web.common.biz;

import java.io.BufferedOutputStream;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.StreamUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.enpem.web.common.data.Box;
import com.enpem.web.common.util.ConfigUtil;
import com.enpem.web.common.util.SessionUtil;

@Controller
@RequestMapping("cmn")
public class CmnController {

	protected Logger log = LoggerFactory.getLogger(this.getClass());

	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSessionTemplate dao;

	@Autowired
	private CmnService cmnService;

	@Autowired
	private CdLocator cdLocator;

	@Autowired
	private MsgLocator msgLocator;

	@Autowired
	private CenterLocator centerLocator;

	@Value("#{config['session.timeout']}")
	private int sessionTimeout;

	@Value("#{config['session.timeout.manual']}")
	private String sessionTimeoutManual;


	/**
	 * queryId로 Object 데이터 가져오기
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("objList.json")
	public void objList(Box box, ModelMap model) throws Exception {
		model.put("list", dao.selectList(box.nvl("queryId"), box));
	}

	@RequestMapping(value = "msgList.jss", method={RequestMethod.GET})
	public void msgList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ByteArrayOutputStream baos = null;
		BufferedOutputStream bout = null;
		ByteArrayInputStream bai = null;
		try {
			baos = new ByteArrayOutputStream();
			if ("Y".equals(ConfigUtil.getString("reload.yn"))) {
				msgLocator.initialize();
			}
			baos.write(msgLocator.getData().getBytes("UTF-8"));
			response.setContentType("application/x-javascript; charset=UTF-8");
			response.setContentLength(baos.size());

			OutputStream out = response.getOutputStream();
			bout = new BufferedOutputStream(out);
			bai = new ByteArrayInputStream(baos.toByteArray());
			StreamUtils.copy(bai, bout);
		} catch (UnsupportedEncodingException ex) {
			log.error(ex.getMessage(), ex);
		} catch (IOException ex) {
			log.error(ex.getMessage(), ex);
		} finally {
			try {
				if (baos != null) { baos.close(); }
				if (bout != null) { bout.close(); }
				if (bai != null) { bai.close(); }
			} catch (IOException ex) {
				log.error(ex.getMessage(), ex);
			}
		}
	}

	@RequestMapping(value = "cdList.jss", method = {RequestMethod.GET})
	public void cdList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ByteArrayOutputStream baos = null;
		BufferedOutputStream bout = null;
		ByteArrayInputStream bai = null;
		try {
			baos = new ByteArrayOutputStream();
			if ("Y".equals(ConfigUtil.getString("reload.yn"))) {
				cdLocator.initialize();
			}
			baos.write(cdLocator.getData().getBytes("UTF-8"));
			response.setContentType("application/x-javascript; charset=UTF-8");
			response.setContentLength(baos.size());

			OutputStream out = response.getOutputStream();
			bout = new BufferedOutputStream(out);
			bai = new ByteArrayInputStream(baos.toByteArray());
			StreamUtils.copy(bai, bout);
		} catch (UnsupportedEncodingException ex) {
			log.error(ex.getMessage(), ex);
		} catch (IOException ex) {
			log.error(ex.getMessage(), ex);
		} finally {
			try {
				if (baos != null) { baos.close(); }
				if (bout != null) { bout.close(); }
				if (bai != null) { bai.close(); }
			} catch (IOException ex) {
				log.error(ex.getMessage(), ex);
			}
		}
	}

	@RequestMapping(value = "centerList.jss", method={RequestMethod.GET})
	public void centerList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ByteArrayOutputStream baos = null;
		BufferedOutputStream bout = null;
		ByteArrayInputStream bai = null;
		try {
			baos = new ByteArrayOutputStream();
			if ("Y".equals(ConfigUtil.getString("reload.yn"))) {
				centerLocator.initialize();
			}
			baos.write(centerLocator.getData().getBytes("UTF-8"));
			response.setContentType("application/x-javascript; charset=UTF-8");
			response.setContentLength(baos.size());

			OutputStream out = response.getOutputStream();
			bout = new BufferedOutputStream(out);
			bai = new ByteArrayInputStream(baos.toByteArray());
			StreamUtils.copy(bai, bout);
		} catch (UnsupportedEncodingException ex) {
			log.error(ex.getMessage(), ex);
		} catch (IOException ex) {
			log.error(ex.getMessage(), ex);
		} finally {
			try {
				if (baos != null) { baos.close(); }
				if (bout != null) { bout.close(); }
				if (bai != null) { bai.close(); }
			} catch (IOException ex) {
				log.error(ex.getMessage(), ex);
			}
		}
	}

	@RequestMapping("reset.json")
	public void reset(Box paramBox, ModelMap modelMap) throws Exception {
	}

	@RequestMapping("modeChange.json")
	public void modeChange(Box paramBox, HttpSession session, ModelMap modelMap) throws Exception {
		if("Y".equals(sessionTimeoutManual)) {
			if("manual".equals(paramBox.getString("mode"))) {
				session.setMaxInactiveInterval(86400);
				SessionUtil.setTimerApply(session, "N");
			} else {
				session.setMaxInactiveInterval(sessionTimeout*60+5);
				SessionUtil.setTimerApply(session, "Y");
			}
		}
	}

	/**
	 * 첨부파일 업로드
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("fileUpload")
	public void fileUpload(Box box, MultipartHttpServletRequest mReq, ModelMap model) throws Exception {
		cmnService.fileUpload(box, mReq, model);
	}

	/**
	 * 첨부파일 다운로드
	 *
	 * @param box
	 * @param mReq
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("fileDown")
	public void fileDown(Box box, ModelMap model) throws Exception {
		cmnService.fileDown(box, model);
	}

	/**
	 * 대용량엑셀파일 다운로드
	 *
	 * @param box
	 * @param mReq
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("csvDown")
	public void csvDown(Box box, ModelMap model) throws Exception {
		cmnService.csvDown(box, model);
	}

	/**
	 * 시퀀스 증가후 조회
	 * @param box
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("seqView")
	public void seqView(Box box, ModelMap model) throws Exception {
		cmnService.seqView(box, model);
	}

	/**
	 * cdAllList test
	 *
	 * @param box the box
	 * @param model the model box
	 */
	@RequestMapping("cdTreeList.json")
	public void cdTreeList(Box box, ModelMap model) throws Exception {
		model.put("list", dao.selectList("cmn.cdTreeList", box));
	}
}

