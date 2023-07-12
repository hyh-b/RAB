package com.example.mappers;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import com.example.model.ExerciseAlbumTO;

@Mapper
public interface ExerciseAlbumMapperInter {
	// 이미지 파일 업로드
	@Insert("INSERT INTO ExerciseAlbum(m_seq, album_name, album_size, album_day) VALUES (#{m_seq}, #{album_name}, #{album_size}, NOW());")
	public int exerciseAlbum_ok(ExerciseAlbumTO to);
	// 이미지 슬라이드에 이미지 나열
	@Select("select a_seq, album_name,album_day from ExerciseAlbum where m_seq=#{m_seq} ORDER BY a_seq DESC")
	public ArrayList<ExerciseAlbumTO> exerciseAlbumList(String m_seq);
	// 이미지 삭제
	@Delete("delete from ExerciseAlbum where a_seq=#{a_seq}")
	public int exerciseAlbumDelete_ok(ExerciseAlbumTO to);
	// 이미지 url알아내기
	@Select("select album_name from ExerciseAlbum where a_seq=#{a_seq}")
	public String exerciseAlbumName(String a_seq);
}
