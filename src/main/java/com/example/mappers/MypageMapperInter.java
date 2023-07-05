package com.example.mappers;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.model.MypageTO;

@Mapper
public interface MypageMapperInter {
	
	@Select("SELECT m_seq, m_id, m_name, m_height, m_weight, m_mail,m_tel,"
			+ " m_target_calorie, m_target_weight, m_join_date, m_filename, m_filesize "
			+ " FROM Member WHERE m_id = #{m_id}")
	public MypageTO mypage(MypageTO to);
	
	
	// 조회
	@Select("select m_id, m_filename from album where m_id = #{m_id}")
	public abstract MypageTO mypageModify_ok_select_parentInfo (MypageTO to);
	
	@Update("update Member set m_name=#{m_name}, m_height=#{m_height}, m_weight=#{m_weight}, m_mail=#{m_mail}, m_tel=#{m_tel}, "
			+ " m_target_calorie=#{m_target_calorie}, m_target_weight=#{m_target_weight}, m_join_date=#{m_join_date}, m_filename=#{m_filename}, m_filesize=#{m_filesize}, "
			+ "where m_id = #{m_id}")
	public abstract int mypageModify_ok_withFile(MypageTO to);
	
	@Update("update Member set m_name=#{m_name}, m_height=#{m_height}, m_weight=#{m_weight}, m_mail=#{m_mail}, m_tel=#{m_tel}, "
			+ " m_target_calorie=#{m_target_calorie}, m_target_weight=#{m_target_weight}, m_join_date=#{m_join_date}, "
			+ "where m_id = #{m_id}")
	public abstract int mypageModify_ok_noFile(MypageTO to);
	
	@Delete("delete from Member where m_id=#{m_id}")
	public abstract int mypageDelete_ok(MypageTO to);
}
