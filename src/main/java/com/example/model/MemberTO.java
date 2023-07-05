package com.example.model;


import java.math.BigDecimal;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class MemberTO {
	private String m_seq;
	private String m_id;
	private String m_pw;
	private String m_name;
	private String gender;
	private BigDecimal m_weight;
	private BigDecimal m_height;
	private String m_mail;
	private Boolean m_iskakao;
	private String m_role;
	private String m_tel;
	private String m_filename;
	private int m_filesize;
	private String m_join_date;
	private int m_target_calorie;
	private BigDecimal m_target_weight;
	

}
