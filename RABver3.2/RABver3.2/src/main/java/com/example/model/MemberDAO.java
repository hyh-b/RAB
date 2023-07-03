package com.example.model;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.ex01.MemberMapperInter;

@Repository
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
	
	public MemberTO signin_ok(MemberTO to) {
		
		return mapper.signin_ok(to);
	}
}
