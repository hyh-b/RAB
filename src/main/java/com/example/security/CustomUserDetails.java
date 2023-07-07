package com.example.security;

import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.Objects;

import com.example.model.MemberTO;
import java.util.stream.Collectors;

import lombok.Getter;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
@Getter
public class CustomUserDetails implements UserDetails {
	// 기본 getter이 필요한 필드들
    private String username;
    private String password;
    private boolean accountNonLocked =true;
    private boolean accountNonExpired =true;
    private boolean isCredentialsNonExpired =true;
    private boolean enabled =true;
    private Collection<? extends GrantedAuthority> authorities;
    //사용하고 싶은 추가 데이터 설정
    private String m_seq;
    private String m_name;
    public CustomUserDetails(MemberTO to) {
        this.username = to.getM_id();
        this.password = to.getM_pw();
        this.m_seq = to.getM_seq();
        this.m_name = to.getM_name();
        // 권한 목록 확인
        List<String> roles = Collections.singletonList(to.getM_role());

        Collection<GrantedAuthority> authorities = roles.stream()
        	.filter(Objects::nonNull)
            .map(role -> new SimpleGrantedAuthority("ROLE_" + role.trim()))
            .collect(Collectors.toList());

        this.authorities = authorities;
    }
  
    
}
