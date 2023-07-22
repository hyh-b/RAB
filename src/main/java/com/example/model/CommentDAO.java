package com.example.model;

import java.util.ArrayList;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.mappers.CommentMapper;

@Repository
@MapperScan("com.example.mapper")
public class CommentDAO {
	@Autowired
	CommentMapper mapper;
	
	// 답글 리스트
	public ArrayList<CommentTO> commentList(BoardTO bto) {
		ArrayList<CommentTO> comments = (ArrayList<CommentTO>)mapper.listComment(bto);
		return comments;
	}
	
	// 답글 쓰기
	public int CommentOk(CommentTO to) {
		int flag = 1;
		int result = mapper.CommentOK(to);
		
		if(result == 1) {
			int update = mapper.CommentUpdate(to);
			System.out.println("답글 업데이트 " + update);
			flag = 0;
		} else {
			flag = 1;
		}
		
		return flag;
	}

}
