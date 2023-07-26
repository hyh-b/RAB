package com.example.rab;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
<<<<<<< HEAD
=======
import org.springframework.boot.builder.SpringApplicationBuilder;
>>>>>>> 42d0bae071d790e6980d066fa640bd7b00f50877
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.PropertySource;

@SpringBootApplication
@PropertySource("classpath:application.properties")
@ComponentScan(basePackages = {"com.example.jwt","com.example.kakaoicloud","com.example.upload","com.example.rab","com.example.kakao","com.example.security","com.example.controller","com.example.model", "com.example.boardmodel", "com.example.mappers"})
<<<<<<< HEAD
public class RabApplication extends  SpringBootServletInitializer {

=======
public class RabApplication extends SpringBootServletInitializer {
	
	@Override
	protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
		return builder.sources(RabApplication.class);
	}
	
>>>>>>> 42d0bae071d790e6980d066fa640bd7b00f50877
	public static void main(String[] args) {
		SpringApplication.run(RabApplication.class, args);
		
	}	
	
}
