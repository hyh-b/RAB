package com.example.mappers;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.annotations.Select;


import com.example.model.NoticeAlbumTO;
import com.example.model.NoticeBoardTO;


@Mapper
public interface NoticeBoardMapperInter {
	
	@Select("SELECT * FROM NoticeBoard WHERE n_seq = #{n_seq}")
	public  NoticeBoardTO noticeBoardView(NoticeBoardTO to);

	@Select("SELECT * FROM  NoticeFile   WHERE n_seq = #{n_seq}")
	public NoticeAlbumTO noticeFileView(NoticeAlbumTO to);
	
	@Select("select * from NoticeBoard")
	List<NoticeBoardTO> getAllNoticeBoard(); 
	
	@Select("SELECT n.n_seq, n.m_seq, n.n_subject, n.n_content, DATE_FORMAT(n.n_wdate, '%Y-%m-%d') AS n_wdate, n.n_hit " +
	        "FROM NoticeBoard n")
	public abstract List<NoticeBoardTO> albumList();


	@Insert("INSERT INTO NoticeBoard (n_seq, m_seq, n_subject, n_content, n_wdate, n_hit)VALUES (#{n_seq}, #{m_seq}, #{n_subject}, #{n_content}, now(), 0) ")
	@Options(useGeneratedKeys = true, keyProperty = "n_seq", keyColumn = "n_seq")
	public abstract int writeOK(NoticeBoardTO to);
	// 이미지 파일 업로드
	@Insert("INSERT INTO NoticeFile( n_seq, nf_filename, nf_filesize) VALUES ( #{n_seq}, #{nf_filename}, #{nf_filesize})")
	public int noticeAlbumOk(NoticeAlbumTO to);
	// 이미지
	@Select("select * from NoticeFile where n_seq=#{n_seq}")
	public ArrayList<NoticeAlbumTO> NoticeAlbumList(String n_seq);
	
	// 이미지 삭제
	@Delete("delete from NoticeFile where nf_seq=#{n_seq}")
	public int noticeAlbumDelete_ok(NoticeAlbumTO to);
	// 이미지 url알아내기
	@Select("select nf_filename from NoticeFile where n_seq=#{n_seq}")
	public String noticeAlbumName(String n_seq);
	
	
	}



