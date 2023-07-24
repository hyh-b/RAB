package com.example.model;

import java.util.ArrayList;
import java.util.List;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;


import com.example.mappers.NoticeBoardMapperInter;

@Repository
@MapperScan("com.example.mappers")
public class NoticeAlbumDAO {
	
	@Autowired 
	NoticeBoardMapperInter mapper;
	
	// 이미지 업로드
	public int noticeAlbum_ok(NoticeAlbumTO to) {
		int flag = 0;
		
		int result = mapper.noticeAlbumOk(to);
		
		if(result ==1) {
			flag = 1;
		}else if(result==0){
			flag=2;
		}
		return flag;
	}
	public int updateNoticeAlbum(NoticeAlbumTO to) {
    	int flag =0;
	    int result = mapper.updateNoticeAlbum(to);
	    if (result == 1) {
	    	flag =1;  	
	    }
    	return flag;
    }
	// 이미지 리스트
	public ArrayList<NoticeAlbumTO> NoticeAlbumList(String n_seq){
		ArrayList<NoticeAlbumTO> noticeAlbumLists = mapper.NoticeAlbumList(n_seq);
		
		return noticeAlbumLists;
	}
	
	public NoticeAlbumTO noticeFileView(NoticeAlbumTO to) {
		return mapper.noticeFileView(to);
	}
	public int noticeFileDelete_ok(NoticeAlbumTO to) {
	    int flag = 2;

	    int result = mapper.noticeFileDelete_ok(to);

	    if(result == 1) {
	        flag = 0;
	    } else if(result == 0) {
	        flag = 1;
	    }
	    return flag;
	}


	public List<NoticeAlbumTO> noticeFilelistView(NoticeAlbumTO to) {
	    return mapper.noticeFilelistView(to);
	}
	
	
	// db에 저장된 album_name 가져오기
	public String NoticeAlbumName(String n_Seq) {
		String name = mapper.noticeAlbumName(n_Seq);
		
		return name;
	}
	
}
