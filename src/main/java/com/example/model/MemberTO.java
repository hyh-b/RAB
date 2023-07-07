package com.example.model;

import java.math.BigDecimal;
import java.util.Collection;
import java.util.Collections;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class MemberTO implements UserDetails{
	
	private static final long serialVersionUID = 1L;
	
	private String m_seq;
	private String m_id;
	private String m_pw;
	private String m_name;
	private String m_gender;
	private BigDecimal m_weight;
	private BigDecimal m_height;
	private String m_mail;
	private Boolean m_iskakao;
	private String m_role;
	private String m_tel;
	private String m_filename;
	private int m_filesize;
	private String m_join_date;
	private Integer m_target_calorie;
	private BigDecimal m_target_weight;
	private String m_birthday;
	
	public MemberTO(/*String m_seq,String m_id,String m_pw,String m_name,String m_gender,BigDecimal m_weight,BigDecimal m_height,String m_mail,Boolean m_iskakao,String m_role,String m_tel,String m_filename,int m_filesize,String m_join_date,Integer m_target_calorie,BigDecimal m_target_weight,String m_birthday */) {
		/*this.m_seq = m_seq;
		this.m_id = m_id;
	    this.m_pw = m_pw;
	    this.m_name = m_name;
	    this.m_gender = m_gender;
	    this.m_weight = m_weight;
	    this.m_height = m_height;
	    this.m_mail = m_mail;
	    this.m_iskakao = m_iskakao;
	    this.m_role = m_role;
	    this.m_tel = m_tel;
	    this.m_filename = m_filename;
	    this.m_filesize = m_filesize;
	    this.m_join_date = m_join_date;
	    this.m_target_calorie = m_target_calorie;
	    this.m_target_weight = m_target_weight;
	    this.m_birthday = m_birthday;*/
	}
	//권한 확인 
	public Collection<? extends GrantedAuthority> getAuthorities(){
		if (m_role != null && !m_role.trim().isEmpty()) {
	        return Collections.singletonList(new SimpleGrantedAuthority(m_role));
	    } else {
	    	return Collections.emptyList();
	    }
	}
	
	@Override
	public boolean isEnabled() {
		// TODO Auto-generated method stub
		return true;
	}
	
	@Override
	public boolean isCredentialsNonExpired() {
		// TODO Auto-generated method stub
		return true;
	}
	
	@Override
	public boolean isAccountNonExpired() {
		// TODO Auto-generated method stub
		return true;
	}
	
	@Override
	public boolean isAccountNonLocked() {
		// TODO Auto-generated method stub
		return true;
	}
	//로그인 pw를 m_pw로 설정
	@Override
	public String getPassword() {
		// TODO Auto-generated method stub
		return m_pw;
	}
	//로그인 아이디를 m_id로 설정
	@Override
	public String getUsername() {
		// TODO Auto-generated method stub
		return m_id;
	}
	
}
