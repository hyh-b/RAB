package com.example.model;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.mappers.ExerciseAlbumMapperInter;

@Repository
@MapperScan("com.example.mappers")
public class ExerciseAlbumDAO {
	
	@Autowired 
	ExerciseAlbumMapperInter mapper;
	
	public int exerciseAlbum_ok(ExerciseAlbumTO to) {
		int flag = 2;
		
		int result = mapper.exerciseAlbum_ok(to);
		
		if(result ==1) {
			flag = 0;
		}else if(result==0){
			flag=1;
		}
		return flag;
	}
	
}
