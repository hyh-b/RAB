package com.example.mappers;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import com.example.model.ExerciseAlbumTO;

@Mapper
public interface ExerciseAlbumMapperInter {
	@Insert("INSERT INTO ExerciseAlbum(m_seq, album_name, album_size, album_day) VALUES (#{m_seq}, #{album_name}, #{album_size}, NOW());")
	public int exerciseAlbum_ok(ExerciseAlbumTO to);
	
	@Select("select a_seq, album_name,album_day from ExerciseAlbum where m_seq=#{m_seq} ORDER BY a_seq DESC")
	public ArrayList<ExerciseAlbumTO> exerciseAlbumList(String m_seq);
	
	@Delete("delete from ExerciseAlbum where album_name=#{album_name")
	public int exerciseAlbumDelete_ok(ExerciseAlbumTO to);
}
