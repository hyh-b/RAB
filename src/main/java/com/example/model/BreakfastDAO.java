package com.example.model;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.mappers.BreakfastMapper;

@Repository
@MapperScan("com.example.mappers")
public class BreakfastDAO {
	
	@Autowired
	private BreakfastMapper mapper;
	
	
	public int insertBreakfast(BreakfastTO to) {
		int flag = 0;
		int result = mapper.insertBreakfast(to);
		if(result == 1) {
			flag = 1;
		} else {
			flag = 0;
		}
		return flag;
	}
	
	
	
	
	
}
