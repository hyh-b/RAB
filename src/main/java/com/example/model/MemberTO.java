package com.example.model;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class MemberTO {
	private String m_seq;
	private String m_id;
	private String m_password;
	private String m_mail;
	private String m_name;
	private String m_birthday;
	private String m_gender;
	private String m_phone;
	private String m_type;
	private String ROLE_USER;
	private String kakao;
}
