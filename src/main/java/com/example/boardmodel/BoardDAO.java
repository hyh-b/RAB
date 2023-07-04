package com.example.boardmodel;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.mappers.BoardMapperInter;


@Repository
@MapperScan("com.example.mappers")
public class BoardDAO {
	
	@Autowired
	private BoardMapperInter mapper;

}
