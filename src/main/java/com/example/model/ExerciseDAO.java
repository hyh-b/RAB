package com.example.model;

import java.util.List;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.mappers.ExerciseMapperInter;

@Repository
@MapperScan("com.example.mappers")
public class ExerciseDAO {
	
	@Autowired
	private ExerciseMapperInter mapper;
	
	// 추가한 운동 db 등록
	public int addExercise_ok(ExerciseTO to) {
		
		int flag = mapper.addExercise_ok(to);
		
		return flag;
	}
	
	// 추가한 사용자 설정 운동 db 등록
	public int addCustomExercise_ok(ExerciseTO to) {
		
		int flag = mapper.addCustomExercise_ok(to);
		
		return flag;
	}
	
	// 추가한 운동들 운동칸에 보이기
	public List<ExerciseTO> viewExercise(Boolean ex_custom, String m_seq){
		
		return mapper.viewExercise(ex_custom, m_seq);
	}
	
	// 운동시간과 소모칼로리 계산된 데이터 db에 업데이트
	public int updateExercise(ExerciseTO to, String m_seq) {
		
		return mapper.updateExercise(to, m_seq);
	}
	
	// 당일 총 소모 칼로리 IntakeData에 업데이트
	public int totalCalorie(String m_seq) {
		
		return mapper.totalCalorie(m_seq);
	}
}
