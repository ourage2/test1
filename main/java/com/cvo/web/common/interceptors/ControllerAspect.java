package com.enpem.web.common.interceptors;


import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.Signature;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.enpem.web.common.data.Box;
import com.enpem.web.common.util.ConfigUtil;
import com.enpem.web.common.util.SpringUtil;

@Aspect
@Component
public class ControllerAspect {

	protected Logger log = LoggerFactory.getLogger(this.getClass());

	/** The Constant LOGGING_LINE. */
	private static final String LOGGING_CONTROLLER_BEFORE_LINE = "******************************  Controller Before Infomation  ******************************";

	/** The Constant LOGGING_LINE. */
	private static final String LOGGING_CONTROLLER_AFTER_LINE = "******************************  Controller After Infomation  ******************************";

	@Value("#{config['aspect.log']}")
	private String aspectLog;


//	@Pointcut("execution(public * com.enpem.web..controller..*(..))")
	@Pointcut("execution(public * com.enpem.web..*Controller..*(..))")
	public void logging() {}

	/**
	 * Controller before.
	 *
	 * @param joinPoint the join point
	 * @return the string
	 */
	@Before("logging()")
	public void controllerBefore(JoinPoint joinPoint) {
		if ("BEFORE".equals(aspectLog) || "BOTH".equals(aspectLog)) {
			Signature signature = joinPoint.getSignature();
			String method = signature.getDeclaringTypeName().substring(signature.getDeclaringTypeName().lastIndexOf(".") + 1, signature.getDeclaringTypeName().length())
					+ "." + signature.getName();
			if (ConfigUtil.getString("log.except.method").indexOf(method) <= -1)  {
//			if (!"sessionInfo".equals(signature.getName())) {
				if (log.isDebugEnabled()) {
					StringBuffer sb = new StringBuffer();
					sb.append("\n")
						.append(LOGGING_CONTROLLER_BEFORE_LINE)
						.append("\n")
						.append(logging(joinPoint))
						.append("\n")
						.append(LOGGING_CONTROLLER_BEFORE_LINE);
					log.debug(sb.toString());
				}
			}
		}
	}

	/**
	 * Controller after.
	 *
	 * @param joinPoint the join point
	 * @return the string
	 */
	@After("logging()")
	public void controllerAfter(JoinPoint joinPoint) {
		if ("AFTER".equals(aspectLog) || "BOTH".equals(aspectLog)) {
			Signature signature = joinPoint.getSignature();
			String method = signature.getDeclaringTypeName().substring(signature.getDeclaringTypeName().lastIndexOf(".") + 1, signature.getDeclaringTypeName().length())
					+ "." + signature.getName();
			if (ConfigUtil.getString("log.except.method").indexOf(method) <= -1)  {
				if (log.isDebugEnabled()) {
					StringBuffer sb = new StringBuffer();
					sb.append("\n")
						.append(LOGGING_CONTROLLER_AFTER_LINE)
						.append("\n")
						.append(logging(joinPoint))
						.append("\n")
						.append(LOGGING_CONTROLLER_AFTER_LINE);
					log.debug(sb.toString());
				}
			}
		}
	}

	private String logging(JoinPoint joinPoint) {
		Signature signature = joinPoint.getSignature();
		StringBuffer logSb = new StringBuffer();

		String signatureStr = signature.toString();
		int paramStart = signatureStr.indexOf("(");
		String paramStr = null;
		if(paramStart > -1) {
			int paramEnd = signatureStr.lastIndexOf(")");
			if(paramEnd > -1) {
				paramStr = signatureStr.substring(paramStart+1, paramEnd);
			}
		}

		if (paramStr != null) {
			String[] param = paramStr.split(",");
			Object[] args = joinPoint.getArgs();
			int argsSize = args.length;
			if (argsSize == param.length) {
				logSb.append("URL : " + (null == SpringUtil.getRequestURL() ? "junit_test" : SpringUtil.getRequestURL() + "\n"));
				logSb.append("Arguments : \n");
				for (int i = 0; i < argsSize; i++) {
					if ("Box".equals(param[i])) {
						String boxNm = "";
						if (argsSize == 2 && i == 0) {
							boxNm = "Box	";
						} else if (argsSize == 2 && i == 1) {
							boxNm = "Model";
						} else {
							boxNm = param[i];
						}
						Box box = (Box)args[i];
						if(box != null) {
							logSb.append("\t")
								.append(boxNm)
								.append(" : ");
							logSb
								.append(box.entrySet())
								.append("\n");
						}
					} else {
						logSb.append("\t")
							.append(param[i])
							.append(" : ")
							.append(args[i])
							.append("\n");
					}
				}
			}
			logSb.deleteCharAt(logSb.toString().length() - 1);
		}
		return logSb.toString();
	}

}
