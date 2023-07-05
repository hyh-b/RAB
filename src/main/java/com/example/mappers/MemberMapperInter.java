package com.example.mappers;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;


import com.example.model.MemberTO;

@Mapper
public interface MemberMapperInter {
	
	@Insert("insert into Member(m_seq, m_id,m_pw,m_mail,m_iskakao,m_join_date) values (0,#{m_id},#{m_pw},#{m_mail},0,now());")
	public int signup_ok(MemberTO to);
	
	@Insert("insert into Member(m_seq, m_id,m_pw,m_mail,m_iskakao,m_join_date) values (0,#{m_id},#{m_pw},#{m_mail},1,now());")
	public int kSignup_ok(MemberTO to);
	
	@Select("select * from Member where m_id=#{m_id} and m_pw=#{m_pw}")
	public MemberTO signin_ok(MemberTO to);
	
	@Select("SELECT * FROM Member WHERE m_id = #{mId}")
	public MemberTO findByMId(String mId);
	
	@Select("select m_id from Member where m_id = #{kId}")
	public MemberTO confirmKakao(String kId);
	

}
