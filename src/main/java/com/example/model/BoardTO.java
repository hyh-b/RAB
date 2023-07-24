package com.example.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class BoardTO {
    private String u_seq;
    private String m_seq;
    private String u_subject;
    private int u_hit;
    private int u_commentcount;
    private String u_content;
    private String u_wdate;
    private String u_filename;
    private long u_filesize;
    private String u_writer;
    private String u_profilename;
	private int wgap;
    
 // view
 	private String prevSeq;
 	private String prevSubject;
 	private String nextSeq;
 	private String nextSubject;
    
	// modify_ok
	private String oldFilename;
	private String uploadPath;
	
	public BoardTO() {
		// TODO Auto-generated constructor stub
		this.oldFilename = "";
		this.prevSeq = "";
		this.nextSeq = "";
		this.oldFilename = "";
	}

	@Override
	public String toString() {
		return "BoardTO [u_seq=" + u_seq + ", m_seq=" + m_seq + ", u_subject=" + u_subject + ", u_hit=" + u_hit
				+ ", u_commentcount=" + u_commentcount + ", u_content=" + u_content + ", u_wdate=" + u_wdate
				+ ", u_filename=" + u_filename + ", u_filesize=" + u_filesize + ", u_writer=" + u_writer
				+ ", u_profilename=" + u_profilename + ", wgap=" + wgap + ", prevSeq=" + prevSeq + ", prevSubject="
				+ prevSubject + ", nextSeq=" + nextSeq + ", nextSubject=" + nextSubject + ", oldFilename=" + oldFilename
				+ ", uploadPath=" + uploadPath + "]";
	}
	
	
}
