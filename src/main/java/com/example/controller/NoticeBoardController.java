package com.example.controller;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.example.model.NoticeBoardDAO;
import com.example.model.NoticeBoardTO;
import com.example.model.NoticeListTO;

import com.example.security.CustomUserDetails;

@Controller
public class NoticeBoardController {

	@Autowired
	private NoticeBoardDAO dao;
	


	@RequestMapping("/notice_board.do")
	public ModelAndView notice_board(HttpServletRequest request, Authentication authentication) {
	    int cpage = 1;
	    if (request.getParameter("cpage") != null && !request.getParameter("cpage").equals("")) {
	        cpage = Integer.parseInt(request.getParameter("cpage"));
	    }

	    NoticeListTO listTO = new NoticeListTO();
	    listTO.setCpage(cpage);

	    listTO = dao.listTO(listTO);
	    
	    List<NoticeBoardTO> data = dao.totalRecord();
	    
	    ModelAndView modelAndView = new ModelAndView();

	    List<NoticeBoardTO> noticeBoardList = dao.getAllNoticeBoard();
	    int startIndex = (cpage - 1) * listTO.getRecordPerPage();
	    int endIndex = Math.min(startIndex + listTO.getRecordPerPage(), noticeBoardList.size());
	    List<NoticeBoardTO> paginatedList = noticeBoardList.subList(startIndex, endIndex);
	    
	    modelAndView.addObject("noticeBoardList", paginatedList);
	    modelAndView.addObject("listTO", listTO);
	    modelAndView.addObject("cpage", cpage);
	    modelAndView.addObject("data", data);
	    modelAndView.setViewName("notice_board");
	    return modelAndView;
	}

	
	@RequestMapping("/notice_board_view.do")
	public ModelAndView notice_board_view() {
		ModelAndView modelAndView = new ModelAndView();
		
		List<NoticeBoardTO> noticeBoardList = dao.getAllNoticeBoard();
		modelAndView.addObject("noticeBoardList", noticeBoardList);
		
		modelAndView.setViewName("notice_board_view");
		
		return modelAndView;
	}
	@RequestMapping("/notice_board_write.do")
	public ModelAndView notice_board_write() {
		ModelAndView modelAndView = new ModelAndView();
		
		List<NoticeBoardTO> noticeBoardList = dao.getAllNoticeBoard();
		modelAndView.addObject("noticeBoardList", noticeBoardList);
		
		modelAndView.setViewName("notice_board_write");
		
		return modelAndView;
	}
	
	
}
