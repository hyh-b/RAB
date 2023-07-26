package com.example.rab;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.PropertySource;

@SpringBootApplication
@PropertySource("classpath:application.properties")
@ComponentScan(basePackages = {"com.example.jwt","com.example.kakaoicloud","com.example.upload","com.example.rab","com.example.kakao","com.example.security","com.example.controller","com.example.model", "com.example.boardmodel", "com.example.mappers"})
public class RabApplication extends  SpringBootServletInitializer {

	public static void main(String[] args) {
		SpringApplication.run(RabApplication.class, args);
		
	}	

}
