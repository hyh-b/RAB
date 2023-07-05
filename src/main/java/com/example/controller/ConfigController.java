package com.example.controller;

import java.security.Principal;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.example.kakao.OAuthService;
import com.example.model.MemberDAO;
import com.example.model.MemberTO;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

@Controller
public class ConfigController {
	
	@Autowired
	private MemberDAO m_dao;
	
	@RequestMapping("/")
	public ModelAndView index() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("index");
		return modelAndView; 
	}
	
	@RequestMapping("/main.do")
	public ModelAndView main(Authentication authentication, ModelMap map) {
		String mId = authentication.getName(); // Retrieve the m_id of the authenticated user
        MemberTO member = m_dao.findByMId(mId); // Retrieve the user details based on the m_id

        
        System.out.println("m_id: " + member.getM_id());
        System.out.println("m_mail: " + member.getM_mail());

        
        map.addAttribute("user", member);
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("main");
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
	
	@RequestMapping("/signin.do")
	public ModelAndView signin(Principal principal) {
		ModelAndView modelAndView = new ModelAndView();
		// 로그인 되어있는 사용자가 로그인페이지에 접근하면  main페이지로 돌려보냄
	    if (principal != null && principal.getName() != null) {
	        
	        modelAndView.setViewName("redirect:/main.do");
	    } else {
	        
	        modelAndView.setViewName("signin");
	    }
		return modelAndView; 
	}
	
	@RequestMapping("/signup.do")
	public ModelAndView signup(Principal principal) {
		ModelAndView modelAndView = new ModelAndView();
		// 로그인 되어있는 사용자가 회원가입페이지에 접근하면  main페이지로 돌려보냄
	    if (principal != null && principal.getName() != null) {
	        
	        modelAndView.setViewName("redirect:/main.do");
	    } else {
	        
	        modelAndView.setViewName("signup");
	    }
		return modelAndView; 
	}
	
	@RequestMapping("/calendar.do")
	public ModelAndView calendar() {
		ModelAndView modelAndView = new ModelAndView();
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
	
	@RequestMapping("/tables.do")
	public ModelAndView tables() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("tables");
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
	
	@RequestMapping("/cards.do")
	public ModelAndView cards() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("cards");
		return modelAndView; 
	}
	
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
	
	
	@RequestMapping("/signup_ok.do")
	public ModelAndView signup_ok(HttpServletRequest request) {
		MemberTO to = new MemberTO();
		//System.out.println(request.getParameter("id"));
		//System.out.println(request.getParameter("password"));
		BCryptPasswordEncoder bcry = new BCryptPasswordEncoder();
		String password = bcry.encode(request.getParameter("password"));
		to.setM_id(request.getParameter("id"));
		to.setM_password(password);
		to.setM_mail(request.getParameter("mail"));
		
		int flag = m_dao.signup_ok(to);
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("signup_ok");
		modelAndView.addObject("flag", flag);
		return modelAndView; 
	}
	
	
	@RequestMapping("/kakao.do")
	public ModelAndView kakao(@RequestParam("code") String code) {
	    System.out.println(code);
	    OAuthService oau = new OAuthService();
	    //oau.getKakaoAccessToken(code);
	    String access_token = oau.getKakaoAccessToken(code);
	    String user_info = oau.getKakaoUserInfo(access_token);
	    
	    JsonParser parser = new JsonParser();
	    JsonObject jsonObject = parser.parse(user_info).getAsJsonObject();
	    String id = jsonObject.get("id").getAsString();
	    String email = jsonObject.getAsJsonObject("kakao_account").get("email").getAsString();
	    System.out.println("----id---"+id);
	    System.out.println("user_info : " + user_info);
	    
	    ModelAndView modelAndView = new ModelAndView();
	    //modelAndView.addObject("user_info", user_info);
	    modelAndView.addObject("userId", id);
	    modelAndView.addObject("userEmail", email);
	    modelAndView.setViewName("kakao");
	    return modelAndView;
	}
	
	@RequestMapping("/kSignup_ok.do")
	public ModelAndView kSignup_ok(HttpServletRequest request) {
		
		String userId = request.getParameter("userId");
		System.out.println("----------------------");
		 System.out.println("회원정보"+userId);
		 System.out.println(request.getParameter("email"));
		MemberTO to = new MemberTO();
		to.setM_mail(request.getParameter("userEmail"));
		to.setM_id(userId);
		to.setM_password(userId);
		
		int flag = m_dao.kSignup_ok(to);
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("kSignup_ok");
		modelAndView.addObject("flag", flag);
		return modelAndView; 
	}
	
	
}
