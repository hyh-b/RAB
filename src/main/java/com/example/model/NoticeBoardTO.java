package com.example.model;

import java.sql.Date;
import java.util.List;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class NoticeBoardTO {

	public int n_seq ;
	public int m_seq ;
	public String n_subject ;
	public String n_content ;
	public Date n_wdate ;
	public int n_hit ;
	public int nf_seq;
	public String nf_filename;
	public int nf_filesize;
	private List<NoticeAlbumTO> noticeAlbumList;
    
    public List<NoticeAlbumTO> getNoticeAlbumList() {
        return noticeAlbumList;
    }
    
    public void setNoticeAlbumList(List<NoticeAlbumTO> noticeAlbumList) {
        this.noticeAlbumList = noticeAlbumList;
    }


}
