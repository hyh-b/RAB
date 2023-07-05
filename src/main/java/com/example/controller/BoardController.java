package com.example.controller;
//import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class BoardController {


	@RequestMapping("/board_list.do")
	public ModelAndView board_list() {
		
		ModelAndView modelAndView = new ModelAndView();
		
		modelAndView.setViewName("board_list");
		return modelAndView;
	}
}
