package com.example.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class BoardTO {
    private String u_seq;
    private String m_seq;
    private String u_subject;
    private String u_category;
    private String u_content;
    private String u_wdate;
    private String u_filename;
    private int u_filesize;
    private int u_hit;
    private int u_commentcount;
    
    private String m_profilename;
    private String m_name;
	@Override
	public String toString() {
		return "BoardTO [u_seq=" + u_seq + ", m_seq=" + m_seq + ", u_subject=" + u_subject + ", u_category="
				+ u_category + ", u_content=" + u_content + ", u_wdate=" + u_wdate + ", u_filename=" + u_filename
				+ ", u_filesize=" + u_filesize + ", u_hit=" + u_hit + ", u_commentcount=" + u_commentcount
				+ ", m_profilename=" + m_profilename + ", m_name=" + m_name + "]";
	}
    
}
