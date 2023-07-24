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

