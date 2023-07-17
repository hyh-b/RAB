package com.example.mappers;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import com.example.model.BoardListTO;
import com.example.model.BoardTO;
import com.example.model.MemberTO;

@Mapper
public interface BoardMapperInter {
	
	@Select( "SELECT UserBoard.*, Member.m_profilename, Member.m_name "
			+ " FROM UserBoard "
			+ " JOIN Member ON UserBoard.m_seq = Member.m_seq " )
	public abstract ArrayList<BoardTO> boardList(BoardTO to);
	
	
	
}
