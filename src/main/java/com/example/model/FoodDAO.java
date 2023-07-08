package com.example.model;

import java.util.Map;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.mappers.FoodMapperInter;

@Repository
@MapperScan("com.example.mappers")
public class FoodDAO {

	
	@Autowired
	private FoodMapperInter mapper;
	
	// 하나의 음식 찾기
	public Map<String, Object> selectFood(String foodName) {
	    return mapper.selectFood(foodName);
	}
	
}
