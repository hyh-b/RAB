package com.example.ex01;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.ComponentScans;

@SpringBootApplication
@ComponentScan(basePackages = {"com.example.controller","com.example.model","com.example.ex01"})
public class Ex01Application {

	public static void main(String[] args) {
		SpringApplication.run(Ex01Application.class, args);
	}

}
