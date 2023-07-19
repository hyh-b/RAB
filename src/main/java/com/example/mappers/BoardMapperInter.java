package com.example.mappers;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.model.BoardListTO;
import com.example.model.BoardTO;

@Mapper
public interface BoardMapperInter {
	
	//list
	@Select( "SELECT u_seq, m_seq, u_subject, u_category, u_hit, u_commentcount, u_content, u_wdate, u_filename, u_filesize, u_writer, u_profilename "
			+ " FROM UserBoard " )
	public abstract ArrayList<BoardTO> boardList(BoardListTO listTo);
	
	// writeOK
	@Insert("INSERT INTO UserBoard (u_subject, u_category, u_hit, u_commentcount, u_content, u_wdate, u_filename, u_filesize, u_writer, u_profilename) "
			+ "VALUES ( #{u_subject}, #{u_category}, 0, 0, #{u_content}, now(), #{u_filename}, #{u_filesize}, #{u_writer}, #{u_profilename})")
	public abstract int write_ok(BoardTO to);
	
	// view : seq 넣어야한다
	@Select(" SELECT u_seq, m_seq, u_subject, u_category, u_hit, u_commentcount, u_content, u_wdate, u_filename, u_filesize, u_writer, u_profilename "
			+ " FROM UserBoard "
			+ " WHERE u_seq=#{u_seq} ")
	public abstract BoardTO view(BoardTO to);
	
	// view_hit
	@Update("UPDATE UserBoard SET hit = hit + 1 WHERE u_seq = #{u_seq}")
	public abstract int viewHit(BoardTO to);
	
	//modify
		@Select(" SELECT u_seq, m_seq, u_subject, u_category, u_hit, u_commentcount, u_content, u_wdate, u_filename, u_filesize, u_writer, u_profilename "
				+ " FROM UserBoard "
				+ " WHERE u_seq=#{u_seq} ")
		public abstract BoardTO modify(BoardTO to);
		
		// 부모글 조회
		@Select("select u_seq, filename from UserBoard where u_seq = #{u_seq}")
		public abstract BoardTO modify_ok_select_parentInfo (BoardTO to);
		
		// 파일도 수정 
		@Update("UPDATE UserBoard "
				+ "SET u_subject = #{u_subject}, "
				+ "    u_category = #{u_category}, "
				+ "    u_content = #{u_content}, "
				+ "    u_filename = #{u_filename}, "
				+ "    u_filesize = #{u_filesize}, "
				+ "WHERE u_seq = #{u_seq}" )
		public abstract int modify_ok_withFile(BoardTO to);

		// 파일 없이 글만 수정
		@Update("UPDATE UserBoard "
				+ "SET u_subject = #{u_subject}, "
				+ "    u_category = #{u_category}, "
				+ "    u_content = #{u_content}, "
				+ "WHERE u_seq = #{u_seq}" )
		public abstract int modify_ok_noFile(BoardTO to);
		
		@Delete("delete from UserBoard where u_seq = #{u_seq}")
		public abstract int delete_ok(BoardTO to);
		
		
	
}
