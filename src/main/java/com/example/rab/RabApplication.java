package com.example.rab;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

@SpringBootApplication
@ComponentScan(basePackages = {"com.example.rab","com.example.kakao","com.example.security","com.example.controller","com.example.model", "com.example.boardmodel", "com.example.mappers"})
public class RabApplication {

	public static void main(String[] args) {
		SpringApplication.run(RabApplication.class, args);
	}

}
