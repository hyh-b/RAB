package com.example.controller;

import java.security.Principal;
import java.io.File;
import java.math.BigDecimal;
import java.security.Principal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.ArrayList;

import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.example.kakao.OAuthService;
import com.example.model.MainTO;
import com.example.model.MemberDAO;
import com.example.model.MemberTO;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.example.model.MypageDAO;
import com.example.model.MypageTO;
import com.example.security.CustomUserDetails;
import com.example.model.MainTO;

@Controller
public class ConfigController {

	@RequestMapping("/")
	public ModelAndView index(Principal principal) {
		ModelAndView modelAndView = new ModelAndView();
		if (principal != null && principal.getName() != null) {
	        modelAndView.addObject("login","login");
	    }
		modelAndView.setViewName("index");
		return modelAndView;
	}

	@RequestMapping("/settings.do")
	public ModelAndView settings() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("settings");
		return modelAndView; 
	}
	
	@RequestMapping("/buttons.do")
	public ModelAndView buttons() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("buttons");
		return modelAndView; 
	}
	
	@RequestMapping("/tabs.do")
	public ModelAndView tabs() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("tabs");
		return modelAndView; 
	}
	
	@RequestMapping("/modals.do")
	public ModelAndView modals() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("modals");
		return modelAndView; 
	}
	
	// Calendar는 팝업 캘린더로 대체될듯함
	@RequestMapping("/calendar.do")
	public ModelAndView calendar() {
		
		ModelAndView modelAndView = new ModelAndView();
		
	      
        //ArrayList<MainTO> lists = dao.main_data();
        //modelAndView.addObject("lists", lists);
        
        
		modelAndView.setViewName("calendar");
		return modelAndView; 
	}
	
	@RequestMapping("/task-list.do")
	public ModelAndView task_list() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("calendar");
		return modelAndView; 
	}
	
	@RequestMapping("/task-kanban.do")
	public ModelAndView task_kanban() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("task-kanban");
		return modelAndView; 
	}
	
	@RequestMapping("/index-ecommerce.do")
	public ModelAndView index_ecommerce() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("index-ecommerce");
		return modelAndView; 
	}
	
	@RequestMapping("/alerts.do")
	public ModelAndView alerts() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("alerts");
		return modelAndView; 
	}
	
//	@RequestMapping("/cards.do")
//	public ModelAndView cards() {
//		ModelAndView modelAndView = new ModelAndView();
//		modelAndView.setViewName("cards");
//		return modelAndView; 
//	}
	
	@RequestMapping("/chart.do")
	public ModelAndView chart() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("chart");
		return modelAndView; 
	}
	
	
	@RequestMapping("/reset-password.do")
	public ModelAndView reset_password() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("reset-password");
		return modelAndView; 
	}
	
	@RequestMapping("/inbox.do")
	public ModelAndView inbox() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("inbox");
		return modelAndView; 
	}
	
	@RequestMapping("/form-elements.do")
	public ModelAndView form_elements() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("form-elements");
		return modelAndView; 
	}
	
	@RequestMapping("/form-layout.do")
	public ModelAndView form_layout() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("form-layout");
		return modelAndView; 
	}
	
	/*@RequestMapping("/admin.do")
	public ModelAndView admin() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("admin");
		return modelAndView;
	}*/

	
	@RequestMapping("/boardManagement.do")
	public ModelAndView boardManagerment(HttpServletRequest request , Authentication authentication) {
		//원하는 유저 정보 가져오기 - security패키지의 CustomUserDetails 설정
		//로그인한(인증된) 사용자의 정보를 authentication에 담음
		authentication = SecurityContextHolder.getContext().getAuthentication();
		//authentication에서 사용자 정보를 가져와 오브젝트에 담음
		Object principal = authentication.getPrincipal();
		// principal 객체를 CustomUserDetails 타입으로 캐스팅
		CustomUserDetails customUserDetails = (CustomUserDetails) principal;
		String seq = customUserDetails.getM_seq();
		System.out.println(seq);
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("adminBoardManagement");
		return modelAndView;
	}
	
	@RequestMapping("/adminAnnouncement.do")
	public ModelAndView adminAnnouncement() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("adminAnnouncement");
		return modelAndView;
	}
	
}

