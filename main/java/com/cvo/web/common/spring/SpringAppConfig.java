package com.enpem.web.common.spring;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.beans.factory.config.PropertiesFactoryBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.ComponentScan.Filter;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.context.annotation.FilterType;
import org.springframework.context.annotation.ImportResource;
import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.multipart.MultipartResolver;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;
import org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerMapping;
import org.springframework.web.servlet.view.BeanNameViewResolver;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.databind.module.SimpleModule;
import com.enpem.web.common.data.parse.BoxDeserializer;
import com.enpem.web.common.util.AppResourceUtil;

@Configuration
@ComponentScan(basePackages="com.enpem.web",
	includeFilters={@Filter(type=FilterType.ANNOTATION, value={Service.class, Repository.class})},
	excludeFilters={@Filter(type=FilterType.ANNOTATION, value={Controller.class, ControllerAdvice.class, Configuration.class})})
//@Import({SpringAppDataSourceConfig.class, SpringAppLocalDataSourceConfig.class, SpringAppValidatorConfig.class, SpringAppExecutorConfig.class})
@ImportResource({"classpath*:/config/spring/*.xml"})
@EnableAspectJAutoProxy
public class SpringAppConfig {

	@Value("#{config['file.upload.max.size']}")
	private Long fileUploadMaxSize;

	/**
	 * Object mapper.
	 *
	 * @return the object mapper
	 */
	@Bean
	@Primary
	@Qualifier(value="objectMapper")
	public ObjectMapper objectMapper() {
		ObjectMapper objectMapper = new ObjectMapper();
		SimpleModule module = new SimpleModule();
		BoxDeserializer boxDeserializer = new BoxDeserializer();
        module.addDeserializer(Map.class, boxDeserializer);
        objectMapper.registerModule(module);
		return objectMapper;
	}

	/**
	 * Object mapper format.
	 *
	 * @return the object mapper
	 */
	@Bean
	@Qualifier(value="objectMapperFormat")
	public ObjectMapper objectMapperFormat() {
		ObjectMapper objectMapper = new ObjectMapper();
		objectMapper.enable(SerializationFeature.INDENT_OUTPUT);
		return objectMapper;
	}

	/**
	 * Config.
	 *
	 * @return the properties factory bean
	 */
	@Bean
	public PropertiesFactoryBean config() {
	    PropertiesFactoryBean propBean = new PropertiesFactoryBean();
	    propBean.setLocation(AppResourceUtil.getConfigResource("/properties/config.xml"));
	    return propBean;
	}

	/**
	 * Multipart resolver.
	 *
	 * @return the multipart resolver
	 */
	@Bean
	public MultipartResolver multipartResolver() {
		CommonsMultipartResolver multipartResolver = new CommonsMultipartResolver();
		multipartResolver.setMaxUploadSize(fileUploadMaxSize);
		return multipartResolver;
	}

	/**
	 * Request mapping handler mapping.
	 *
	 * @return the request mapping handler mapping
	 */
//	@Bean
//	public RequestMappingHandlerMapping requestMappingHandlerMapping() {
//		RequestMappingHandlerMapping requestMappingHandlerMapping = new RequestMappingHandlerMapping();
//		requestMappingHandlerMapping.setOrder(0);
//		requestMappingHandlerMapping.setAlwaysUseFullPath(true);
////		requestMappingHandlerMapping.setInterceptors(interceptorRegistry.getInterceptors().toArray());
//		return requestMappingHandlerMapping;
//	}

	/**
	 * Custom request mapping handler adapter.
	 *
	 * @return the custom request mapping handler adapter
	 */
	@Bean
	public CustomRequestMappingHandlerAdapter customRequestMappingHandlerAdapter() {
		CustomRequestMappingHandlerAdapter handlerAdapter = new CustomRequestMappingHandlerAdapter();
		handlerAdapter.setOrder(0);
		List<HandlerMethodArgumentResolver> resolvers = new ArrayList<HandlerMethodArgumentResolver>();
		resolvers.add(new BoxHandlerMethodArgumentResolver());
		resolvers.add(new ModelBoxHandlerMethodArgumentResolver());
		resolvers.add(new XmlReqHandlerMethodArgumentResolver());
		handlerAdapter.setPreCustomArgumentResolvers(resolvers);
		return handlerAdapter;
	}

	/**
	 * Bean name view resolver.
	 *
	 * @return the bean name view resolver
	 */
	@Bean
	public BeanNameViewResolver beanNameViewResolver() {
		BeanNameViewResolver beanNameViewResolver = new BeanNameViewResolver();
		beanNameViewResolver.setOrder(0);
		return beanNameViewResolver;
	}
}
