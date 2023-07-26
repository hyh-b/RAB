package com.example.rab;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.PropertySource;

@SpringBootApplication
@PropertySource("classpath:application.properties")
@ComponentScan(basePackages = {"com.example.jwt","com.example.kakaoicloud","com.example.upload","com.example.rab","com.example.kakao","com.example.security","com.example.controller","com.example.model", "com.example.boardmodel", "com.example.mappers"})
<<<<<<< HEAD
=======

>>>>>>> 38f5ce4d9fc5a75a63a6ffd042f530f545b1ce9f
public class RabApplication extends SpringBootServletInitializer {
	
	@Override
	protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
		return builder.sources(RabApplication.class);
	}
	
	public static void main(String[] args) {
		SpringApplication.run(RabApplication.class, args);
		
	}	
	
}
