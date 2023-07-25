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

	
	
	
}
