package com.example.model;

import java.util.ArrayList;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.mappers.MemberMapperInter;

@Repository
@MapperScan("com.example.mappers")
public class MainDAO {
	
	@Autowired
	private MemberMapperInter mapper;
	
	public ArrayList<MainTO> food_data() {
		
		ArrayList<MainTO> lists = new ArrayList<>();
		
		return lists;
	}
	

}
