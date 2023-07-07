package com.example.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.example.model.MemberDAO;
import com.example.model.MemberTO;
@Service
public class CustomUserDetailsService implements UserDetailsService{
	@Autowired
	private MemberDAO memberDAO;
	
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		// 사용자 id로 정보 조회
		MemberTO to = memberDAO.findByMId(username);
		if(to == null) {
			throw new UsernameNotFoundException("User not found");
		}
		
		CustomUserDetails details = new CustomUserDetails(to);
		return details;
	}
}
