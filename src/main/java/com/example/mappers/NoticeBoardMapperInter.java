package com.example.mappers;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.annotations.Select;


import com.example.model.NoticeBoardTO;


@Mapper
public interface NoticeBoardMapperInter {
	
	
	@Select("select * from NoticeBoard")
	List<NoticeBoardTO> getAllNoticeBoard(); 
	
	@Select("SELECT n.n_seq, n.m_seq, n.n_subject, n.n_content, DATE_FORMAT(n.n_wdate, '%Y-%m-%d') AS n_wdate, n.n_hit " +
	        "FROM NoticeBoard n")
	public abstract List<NoticeBoardTO> albumList();


	@Insert("INSERT INTO NoticeBoard (n_seq, m_seq, n_subject, n_content, n_wdate, n_hit) "
	+ "VALUES (#{n_seq}, #{m_seq}, #{n_subject}, #{n_content}, now(), 0)")
	@Options(useGeneratedKeys = true, keyProperty = "n_seq", keyColumn = "n_seq")
	public abstract int writeOK(NoticeBoardTO to);
	}
