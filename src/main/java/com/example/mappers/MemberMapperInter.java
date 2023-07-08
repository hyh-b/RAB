package com.example.mappers;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import org.springframework.beans.factory.annotation.Autowired;

import com.example.model.MemberTO;

@Mapper
public interface MemberMapperInter {
	
	//회원가입
	@Insert("insert into Member(m_seq, m_id,m_pw,m_mail,m_iskakao,m_role,m_join_date) values (0,#{m_id},#{m_pw},#{m_mail},0,#{m_role},now());")
	public int signup_ok(MemberTO to);
	//카카오 회원가입
	@Insert("insert into Member(m_seq, m_id,m_pw,m_mail,m_iskakao, m_role, m_join_date) values (0,#{m_id},#{m_pw},#{m_mail},1,#{m_role},now());")
	public int kSignup_ok(MemberTO to);
	//아이디를 통한 유저 정보조회
	@Select("SELECT * FROM Member WHERE m_id = #{m_id}")
	public MemberTO findByMId(String m_id);
	//카카오 회원여부 확인
	@Select("select m_id from Member where m_id = #{kId}")
	public MemberTO confirmKakao(String kId);
	//추가 정보입력 
	@Update("UPDATE Member SET m_name = #{m_name}, m_gender = #{m_gender} , m_weight = #{m_weight}, m_height = #{m_height}, m_tel = #{m_tel}, m_role = #{m_role}, m_target_calorie = #{m_target_calorie}, m_target_weight = #{m_target_weight},m_birthday = #{m_birthday} WHERE m_id = #{m_id};")
	public int signup2(MemberTO to);
	//아이디 중복확인
	@Select("SELECT count(m_id) FROM Member WHERE m_id = #{m_id}")
	public int idCheck(String m_id);
	//닉네임 중복확인
	@Select("SELECT count(m_name) FROM Member WHERE m_name = #{m_name}")
	public int nameCheck(String m_name);

}
