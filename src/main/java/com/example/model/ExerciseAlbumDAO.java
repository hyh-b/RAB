package com.example.model;

import java.util.ArrayList;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.mappers.ExerciseMapperInter;

@Repository
@MapperScan("com.example.mappers")
public class ExerciseAlbumDAO {
	
	@Autowired 
	ExerciseMapperInter mapper;
	
	// 이미지 업로드
	public int exerciseAlbum_ok(ExerciseAlbumTO to) {
		
		int flag = mapper.exerciseAlbum_ok(to);
		
		return flag;
	}
	
	// 이미지 리스트
	public ArrayList<ExerciseAlbumTO> exerciseAlbumList(String m_id){
		ArrayList<ExerciseAlbumTO> eaLists = mapper.exerciseAlbumList(m_id);
		
		return eaLists;
	}
	
	// 이미지 삭제
	public int exerciseAlbumDelete_ok(ExerciseAlbumTO to) {
		
		int flag = mapper.exerciseAlbumDelete_ok(to);
		
		return flag;
	}
	
	// db에 저장된 album_name 가져오기
	public String exerciseAlbumName(String aSeq) {
		String name = mapper.exerciseAlbumName(aSeq);
		
		return name;
	}
}
