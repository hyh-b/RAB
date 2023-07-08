package com.example.model;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.mappers.DinnerMapperInter;

@Repository
@MapperScan( "com.example.mappers" )
public class DinnerDAO {
	
	@Autowired
	DinnerMapperInter mapper;
	
	
	public int insertDinnerData(DinnerTO to) {
		int flag=0;
		
		int result = mapper.insertDinnerData(to);
		
		if(result == 1) {
			flag = 1;
		} 
		
		return flag;
	}
	
	
}
