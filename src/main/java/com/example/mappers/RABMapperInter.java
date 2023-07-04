package com.example.mappers;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import com.example.model.MainTO;
import com.example.model.MemberTO;

@Mapper
public interface RABMapperInter {
	
	@Insert("insert into member values(0,#{m_id},#{m_password},#{m_mail},null,null,null,null,default,null,null)")
	public int signup_ok(MemberTO to);
	
	@Select("SELECT * FROM member WHERE m_id = #{mId}")
	public MemberTO findByMId(String mId);
	
	
	@Select("SELECT * FROM IntakeData WHERE DATE(i_day) = CURDATE()")
	public MainTO dataForMember();
	
}
