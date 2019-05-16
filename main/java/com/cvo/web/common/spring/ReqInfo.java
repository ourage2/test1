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
public @interface ReqInfo {
	Class<?> inXmlVO() default void.class;
	Class<?> outXmlVO() default void.class;
	String validForm() default "";
}
