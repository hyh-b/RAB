package com.example.model;

import java.math.BigDecimal;
import java.util.List;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.mappers.ExerciseMapperInter;

@Repository
@MapperScan("com.example.mappers")
public class matDAO {

		@Autowired
		private ExerciseMapperInter mapper;
		
		// 운동종목 정보 
		public List<matTO> searchMat(String mat_name) {
			List<matTO> exerciseList = (List<matTO>)mapper.searchExercise(mat_name);
			
			return exerciseList;
		}
		
		// 운동 종목별 분당 소모칼로리
		public BigDecimal getCalorise(String ex_name) {
			return mapper.getCalories(ex_name);
		}
}
