package com.enpem.web.common.util;

import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

@Service
public class MailUtil {

	@Autowired
	private JavaMailSenderImpl mailSender;

	/**
	 * 이메일을 전송한다.
	 * @param toEmail 받는사람 이메일주소
	 * @param fromEmail 보내는사람 이메일주소
	 * @param personal 보내는사람 성명
	 * @param subject 이메일 제목
	 * @param text 이메일 확인시 컨텐츠 내용
	 * @return
	 */
	public boolean send(String toEmail, String fromEmail, String personal, String subject, String text) throws Exception {
		MimeMessage mimeMessage = mailSender.createMimeMessage();
		MimeMessageHelper helper = null;

		helper = new MimeMessageHelper(mimeMessage, true, "UTF-8");
		helper.setTo(toEmail);
		helper.setFrom(fromEmail, personal);
		helper.setSubject(subject);
		helper.setText(text, true);
//		DataSource ds = new FileDataSource("filePath");
//		helper.addAttachment(MimeUtility.encodeText("filePath", "UTF-8", "B"), ds);
		mailSender.send(mimeMessage);
		return true;
	}
}
