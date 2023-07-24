package com.example.mappers;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.model.BoardTO;
import com.example.model.CommentTO;

@Mapper
public interface CommentMapper {
	
	// 답글 리스트
	@Select("SELECT c.uc_writer, c.uc_content, c.uc_wdate FROM UserCMT c "
			+ "INNER JOIN UserBoard a ON a.u_seq = c.u_seq WHERE a.u_seq = #{u_seq}")
	public abstract ArrayList<CommentTO> listComment(BoardTO bto);
    
	// 답글 쓰기
	@Insert(" INSERT INTO UserCMT (u_seq, uc_wdate, uc_content, uc_writer) "
			+ "VALUES (#{u_seq}, now(), #{uc_content}, #{uc_writer} )")
	public abstract int CommentOK (CommentTO to);
	
	// 답글쓰기 후 업데이트
	@Update("UPDATE UserBoard a  JOIN (select u_seq, COUNT(*) u_commentcount  FROM  UserCMT GROUP BY u_seq ) b ON a.u_seq = b.u_seq "
			+ "  SET a.u_commentcount = b.u_commentcount  WHERE a.u_seq = #{u_seq}" )
	public abstract int CommentUpdate (CommentTO to);
	
}
