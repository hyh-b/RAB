package com.example.model;

import java.util.ArrayList;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.mappers.BoardMapperInter;


@Repository
@MapperScan("com.example.mappers")
public class BoardDAO {
	
	@Autowired
	private BoardMapperInter mapper;
	
	public ArrayList<BoardTO> boardList(BoardTO to) {
		ArrayList<BoardTO> boardList = (ArrayList<BoardTO>)mapper.boardList(to);
	    
	    return boardList;
	}

}
