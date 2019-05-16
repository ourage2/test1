package com.enpem.web.common.spring;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Inherited;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Inherited
public @interface MethodInfo {

	/**
	 * In xml vo.
	 *
	 * @return the class
	 */
	Class<?> inXml() default void.class;

	/**
	 * Out xml vo.
	 *
	 * @return the class
	 */
	Class<?> outXml() default void.class;

	/**
	 * Valid form.
	 *
	 * @return the string
	 */
	String validForm() default "";
}
