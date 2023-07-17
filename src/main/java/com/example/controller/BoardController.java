package com.example.controller;



import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.example.model.BoardDAO;
import com.example.model.BoardListTO;
import com.example.model.BoardTO;
import com.example.model.MypageDAO;
import com.example.security.CustomUserDetails;

@Controller
public class BoardController {

	@Autowired
	private BoardDAO boardDAO;
	
	@RequestMapping("/board.do")
	public ModelAndView boardList(HttpServletRequest request, Authentication authentication) {
		ModelAndView modelAndView = new ModelAndView();
		
		BoardTO to = new BoardTO();
		
		authentication = SecurityContextHolder.getContext().getAuthentication();
		Object principal = authentication.getPrincipal();
		CustomUserDetails customUserDetails = (CustomUserDetails) principal;
		System.out.println("게시판리스트 seq가져와 " + customUserDetails.getM_seq());
		String seq = customUserDetails.getM_seq();
		
		System.out.println("Board to의 내용:");
		System.out.println(to.toString());
		
		// boardList
		ArrayList<BoardTO> boardLists = boardDAO.boardList(to);
		
		modelAndView.setViewName("board");
		
		// 데이터 넘겨주기
		modelAndView.addObject("boardLists" , boardLists );
		modelAndView.addObject("to" , to );
		modelAndView.addObject("seq" , seq );
		
		return modelAndView;
	}
}
