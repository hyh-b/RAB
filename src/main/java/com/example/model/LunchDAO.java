package com.example.model;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.mappers.LunchMapperInter;

@Repository
public class LunchDAO {
	
	@Autowired
	private LunchMapperInter mapper;
	
	
	public int insertLunchData(LunchTO to) {
		int flag = 0;
		int result = mapper.insertLunchData(to);
		if(result == 1) {
			flag = 1;
		} else {
			flag = 0;
		}
		return flag;
	}
	
}
