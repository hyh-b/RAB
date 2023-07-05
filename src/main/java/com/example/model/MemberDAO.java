package com.example.model;


import org.mybatis.spring.annotation.MapperScan;
import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.mappers.MemberMapperInter;

@Repository
@MapperScan("com.example.mappers")
public class MemberDAO {
	
	@Autowired
	private MemberMapperInter mapper;
	
	public int signup_ok(MemberTO to) {
		int flag = 1;
		
		int result = mapper.signup_ok(to);
		
		if( result == 1 ) {
			flag = 0;
		}
       
		return flag;
	}
	
	public int kSignup_ok(MemberTO to) {
		int flag = 1;
		
		int result = mapper.kSignup_ok(to);
		
		if( result == 1 ) {
			flag = 0;
		}
       
		return flag;
	}
	
	public MemberTO signin_ok(MemberTO to) {
		
		return mapper.signin_ok(to);
	}
	
	
	
	public MemberTO findByMId(String mId) {
        return mapper.findByMId(mId);
    }
	
	public MemberTO confirmKakao(String kId) {
		return mapper.confirmKakao(kId);
	}

}
