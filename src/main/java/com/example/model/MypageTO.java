package com.example.model;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class MypageTO {
	private String m_seq;
	private String m_id;
	private String m_pw;
	private String m_name;
	private String m_gender;
	private String m_height;
	private String m_weight;
	private String m_mail;
	private String m_role;
	private String m_birthday;
	private String m_tel;
	private String m_target_calorie;
	private String m_target_weight;
	private String m_join_date;
	private String m_profilename;
	private long m_profilesize;
	private String m_backgroundfilename;
	private long m_backgroundfilesize;
	
	// modify_ok
		private String oldProFileFilename;
		private String oldBackgroundFilename;
		private String uploadPath;
		
	public MypageTO() {
		// TODO Auto-generated constructor stub
		this.oldProFileFilename = "";
		this.oldBackgroundFilename = "";
		this.m_profilename = "";
		this.uploadPath = "C:/java/project/RAB/RAB/src/main/webapp/src/images/upload";
	}

	@Override
	public String toString() {
		return "MypageTO [m_seq=" + m_seq + ", m_id=" + m_id + ", m_pw=" + m_pw + ", m_name=" + m_name + ", m_gender="
				+ m_gender + ", m_height=" + m_height + ", m_weight=" + m_weight + ", m_mail=" + m_mail + ", m_role="
				+ m_role + ", m_birthday=" + m_birthday + ", m_tel=" + m_tel + ", m_target_calorie=" + m_target_calorie
				+ ", m_target_weight=" + m_target_weight + ", m_join_date=" + m_join_date + ", m_profilename="
				+ m_profilename + ", m_profilesize=" + m_profilesize + ", m_backgroundfilename=" + m_backgroundfilename
				+ ", m_backgroundfilesize=" + m_backgroundfilesize +"]";
	}
	
	
	
}
