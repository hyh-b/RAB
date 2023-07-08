package com.example.mappers;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.model.MypageTO;

@Mapper
public interface MypageMapperInter {
	
// 마이페이지
//	@Select(" SELECT * FROM Member WHERE m_id =#{m_id} ")
//	public MypageTO mypage(MypageTO to);
	
	@Select(" SELECT * FROM Member WHERE m_id ='jihyeon' ")
	public MypageTO mypage(MypageTO to);
	
// ----------------------- ModifyOK -------------------------------------
// 조회
//	@Select("select m_id, m_profilename, m_backgroundfilename from Member where m_id = #{m_id}")
//	public abstract MypageTO mypageModify_ok_select_parentInfo (MypageTO to);
	
	@Select("select m_id, m_profilename, m_backgroundfilename from Member where m_id = 'jihyeon'")
	public abstract MypageTO mypageModify_ok_select_parentInfo (MypageTO to);
	
	
	// 텍스트만 수정
//	@Update("UPDATE Member SET m_name=#{m_name}, m_height=#{m_height}, m_weight=#{m_weight}, m_mail=#{m_mail}, m_tel=#{m_tel}, "
//	        + "m_target_calorie=#{m_target_calorie}, m_target_weight=#{m_target_weight} "
//	        + "WHERE m_id = 'jihyeon'")
//	public abstract int mypageModify_ok_noFile(MypageTO to);

	
	@Update("UPDATE Member SET m_name=#{m_name}, m_height=#{m_height}, m_weight=#{m_weight}, m_mail=#{m_mail}, m_tel=#{m_tel}, "
	        + "m_target_calorie=#{m_target_calorie}, m_target_weight=#{m_target_weight} "
	        + "WHERE m_id = 'jihyeon'")
	public abstract int mypageModify_ok_noFile(MypageTO to);

	
	
	// 배사 수정
//	@Update("update Member set m_name=#{m_name}, m_height=#{m_height}, m_weight=#{m_weight}, m_mail=#{m_mail}, m_tel=#{m_tel}, "
//			+ " m_target_calorie=#{m_target_calorie}, m_target_weight=#{m_target_weight}, "
//			+ " m_backgroundfilename=#{m_backgroundfilename}, m_backgroundfilesize=#{m_backgroundfilesize}, "
//			+ "where m_id = #{m_id}")
//	public abstract int mypageModify_ok_Background(MypageTO to);
	
	@Update("update Member set m_name=#{m_name}, m_height=#{m_height}, m_weight=#{m_weight}, m_mail=#{m_mail}, m_tel=#{m_tel}, "
			+ " m_target_calorie=#{m_target_calorie}, m_target_weight=#{m_target_weight}, "
			+ " m_backgroundfilename=#{m_backgroundfilename}, m_backgroundfilesize=#{m_backgroundfilesize} "
			+ "where m_id = 'jihyeon'")
	public abstract int mypageModify_ok_Background(MypageTO to);
	
	
	// 프사 수정
//	@Update("update Member set m_name=#{m_name}, m_height=#{m_height}, m_weight=#{m_weight}, m_mail=#{m_mail}, m_tel=#{m_tel}, "
//			+ " m_target_calorie=#{m_target_calorie}, m_target_weight=#{m_target_weight}, "
//			+ " m_profilename=#{m_profilename}, m_profilesize=#{m_profilesize}, "
//			+ "where m_id = #{m_id}")
//	public abstract int mypageModify_ok_Profile(MypageTO to);
	
	@Update("update Member set m_name=#{m_name}, m_height=#{m_height}, m_weight=#{m_weight}, m_mail=#{m_mail}, m_tel=#{m_tel}, "
			+ " m_target_calorie=#{m_target_calorie}, m_target_weight=#{m_target_weight}, "
			+ " m_profilename=#{m_profilename}, m_profilesize=#{m_profilesize} "
			+ "where m_id = 'jihyeon'")
	public abstract int mypageModify_ok_Profile(MypageTO to);
	
	// 모두 다 수정
//	@Update("update Member set m_name=#{m_name}, m_height=#{m_height}, m_weight=#{m_weight}, m_mail=#{m_mail}, m_tel=#{m_tel}, "
//			+ " m_target_calorie=#{m_target_calorie}, m_target_weight=#{m_target_weight}, "
//			+ " m_profilename=#{m_profilename}, m_profilesize=#{m_profilesize}, m_backgroundfilename=#{m_backgroundfilename}, m_backgroundfilesize=#{m_backgroundfilesize} "
//			+ "where m_id = #{m_id}")
//	public abstract int mypageModify_ok_All(MypageTO to);
	
	@Update("update Member set m_name=#{m_name}, m_height=#{m_height}, m_weight=#{m_weight}, m_mail=#{m_mail}, m_tel=#{m_tel}, "
			+ " m_target_calorie=#{m_target_calorie}, m_target_weight=#{m_target_weight}, "
			+ " m_profilename=#{m_profilename}, m_profilesize=#{m_profilesize}, m_backgroundfilename=#{m_backgroundfilename}, m_backgroundfilesize=#{m_backgroundfilesize} "
			+ "where m_id = 'jihyeon'")
	public abstract int mypageModify_ok_All(MypageTO to);
	
	
	// 삭제
//	@Delete("delete from Member where m_id=#{m_id}")
//	public abstract int mypageDelete_ok(MypageTO to);
	
	@Delete("delete from Member where m_id='jihyeon'")
	public abstract int mypageDelete_ok(MypageTO to);
}
