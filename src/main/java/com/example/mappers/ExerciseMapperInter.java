package com.example.mappers;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.model.ExerciseAlbumTO;
import com.example.model.ExerciseTO;
import com.example.model.matTO;

@Mapper
public interface ExerciseMapperInter {
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
	
	// 운동종목 검색
	@Select("select * from mat where mat_name like concat('%', #{mat_name}, '%')")
	public List<matTO> searchExercise(String mat_name);
	
	// 운동종목 추가
	@Insert("insert into Exercise(m_seq,ex_name,ex_day,ex_custom) values(#{m_seq},#{ex_name},now(),0)")
	public int addExercise_ok(ExerciseTO to);
	
	// 사용자 설정 운동종목 추가
	@Insert("insert into Exercise(m_seq,ex_name,ex_time,ex_used_kcal,ex_day,ex_custom) values(#{m_seq},#{ex_name},#{ex_time},#{ex_used_kcal},now(),1)")
	public int addCustomExercise_ok(ExerciseTO to);
	
	// 당일 추가한 운동종목 표시
	@Select("select * from Exercise where ex_custom = #{ex_custom} and ex_day = #{ex_day} and m_seq=#{m_seq}")
	public List<ExerciseTO> viewExercise(ExerciseTO to);
	
	// 운동 정보에 따른 칼로리 구하기
	@Select("select mat_value from mat where mat_name=#{ex_name}")
	public BigDecimal getCalories(String ex_name);
	
	// 운동시간과 소모 칼로리 업데이트
	@Update("UPDATE Exercise SET ex_time=#{ex_time}, ex_used_kcal=#{ex_used_kcal} WHERE m_seq=#{m_seq} AND ex_day=CURDATE() AND ex_name=#{ex_name}")
	public int updateExercise(ExerciseTO to);
	
	// 당일 총 소모칼로리 IntakeData테이블에 삽입
	@Update("update IntakeData SET i_used_kcal = (SELECT SUM(ex_used_kcal)FROM Exercise WHERE m_seq=#{m_seq} AND ex_day=CURDATE()) WHERE m_seq = #{m_seq} AND i_day = CURDATE();")
	public int totalCalorie(String m_seq);
	
}
