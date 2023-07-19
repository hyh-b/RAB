package com.example.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
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
	
	public void updateUserDetails() {
        // 현재 로그인한 사용자의 username 가져오기
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String username = auth.getName();

        // 새로운 UserDetails 불러오기
        UserDetails userDetails = this.loadUserByUsername(username);

        // 새로운 Authentication 객체 생성
        Authentication newAuth = new UsernamePasswordAuthenticationToken(userDetails, userDetails.getPassword(), userDetails.getAuthorities());
        
        // SecurityContextHolder에 새로운 Authentication 설정
        SecurityContextHolder.getContext().setAuthentication(newAuth);
    }
}
