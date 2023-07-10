package com.example.mappers;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;

import com.example.model.ExerciseAlbumTO;

@Mapper
public interface ExerciseAlbumMapperInter {
	@Insert("INSERT INTO ExerciseAlbum(m_seq, album_name, album_size, album_day) VALUES (#{m_seq}, #{album_name}, #{album_size}, NOW());")
	public int exerciseAlbum_ok(ExerciseAlbumTO to);
}
