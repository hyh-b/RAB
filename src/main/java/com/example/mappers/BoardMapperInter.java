package com.example.mappers;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.model.BoardListTO;
import com.example.model.BoardTO;

@Mapper
public interface BoardMapperInter {
	
	// list : 답글 추가
		@Select("SELECT nvl(a.u_commentcount,0) AS 'u_commentcount', "
				+ " a.u_seq, a.u_subject, a.u_writer, a.u_filename, a.u_filesize, DATE_FORMAT(a.u_wdate, '%Y-%m-%d') AS u_wdate, "
				+ " u_hit, DATEDIFF(NOW(), a.u_wdate) AS wgap "
				+ " FROM UserBoard a "
				+ " ORDER BY a.u_seq DESC")
		public abstract ArrayList<BoardTO> boardList(BoardListTO listTo);
		
		// write_ok
		@Insert("INSERT INTO UserBoard VALUES( 0, #{m_seq}, #{u_subject}, 0, 0, #{u_content}, NOW(), #{u_filename}, #{u_filesize}, #{u_writer} )")
		public abstract int write_ok(BoardTO to);
		
		// view_hit
		@Update("UPDATE UserBoard SET u_hit = u_hit + 1 WHERE u_seq = #{u_seq}")
		public abstract int viewHit(BoardTO to);
		
		// view : seq 넣어야한다
		@Select("select u_seq, u_subject , u_writer ,u_wdate , u_hit, u_content, u_filename, u_filesize from UserBoard where u_seq=#{u_seq}")
		public abstract BoardTO view(BoardTO to);
		
		// 이전글
		@Select("SELECT u_seq, u_subject FROM UserBoard WHERE u_seq < #{u_seq} ORDER BY u_seq DESC LIMIT 1")
		public abstract BoardTO view_prev(BoardTO to);
		
		// 다음글
		@Select("SELECT u_seq, u_subject FROM UserBoard WHERE u_seq > #{u_seq} ORDER BY u_seq ASC LIMIT 1 ")
		public abstract BoardTO view_next(BoardTO to);
		
		//modify
		@Select("select u_seq, u_subject, u_content, u_filename from UserBoard where u_seq= #{u_seq}")
		public abstract BoardTO modify(BoardTO to);
		
		// 부모글 조회
		@Select("select u_seq, u_filename from UserBoard where u_seq = #{u_seq}")
		public abstract BoardTO modify_ok_select_parentInfo (BoardTO to);
		
		// 파일도 수정 
		@Update("update UserBoard set u_subject=#{u_subject}, u_content=#{u_content}, u_filename=#{u_filename}, u_filesize=#{u_filesize} where u_seq=#{u_seq}")
		public abstract int modify_ok_withFile(BoardTO to);

		// 파일 없이 글만 수정
		@Update("update UserBoard set u_subject=#{u_subject}, u_content=#{u_content} where u_seq=#{u_seq}")
		public abstract int modify_ok_noFile(BoardTO to);
		
		
		@Delete("delete from UserBoard where u_seq=#{u_seq}")
		public abstract int delete_ok(BoardTO to);
		
	
}
