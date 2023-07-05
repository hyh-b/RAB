package com.example.controller;

import java.security.Principal;
import java.util.HashMap;
import java.util.ArrayList;

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
import com.example.model.MainDAO;
import com.example.model.MainTO;
import com.example.model.MemberDAO;
import com.example.model.MemberTO;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

@Controller
public class ConfigController {
	
	@Autowired
	private MemberDAO m_dao;
	
	BCryptPasswordEncoder bcry = new BCryptPasswordEncoder();
	@Autowired
	private MainDAO dao;
	
	@RequestMapping("/")
	public ModelAndView index() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("index");
		return modelAndView; 
	}
	
	@RequestMapping("/main.do")
	public ModelAndView main(Authentication authentication, ModelMap map, HttpServletRequest request) {
		
		ModelAndView modelAndView = new ModelAndView();
		
		
		//이거 뭔가요? to hyh
		String mId = authentication.getName(); // Retrieve the m_id of the authenticated user
        MemberTO member = m_dao.findByMId(mId); // Retrieve the user details based on the m_id
        
        //정보
        ArrayList<MainTO> lists = dao.main_data();
        
        //음식 데이터
        ArrayList<MainTO> datas = dao.data_meals();


        System.out.println("     m_id: " + member.getM_id());
        System.out.println("     m_mail: " + member.getM_mail());
        
        //지울것
        String id = request.getParameter("id");
        MemberTO member_id = dao.data_member(request, id);
	    System.out.println( " member_id ->  " + member_id);
	    //

        map.addAttribute("user", member);
		modelAndView.addObject("lists", lists);
		modelAndView.addObject("datas", datas);
		HttpSession session = request.getSession();
		String mSeq = (String)session.getAttribute("mSeq");
		System.out.println("메인세션:"+mSeq);
		modelAndView.setViewName("main");
		return modelAndView; 
	}
	
	@RequestMapping("/profile.do")
	public ModelAndView profile() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("profile");
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

	public ModelAndView signin(Principal principal, HttpServletRequest request) {
		ModelAndView modelAndView = new ModelAndView();
		// 로그인 되어있는 사용자가 로그인페이지에 접근하면  main페이지로 돌려보냄
	    if (principal != null && principal.getName() != null) {
	        
	    	
		    //지울것
	        String id = request.getParameter("id");
	        MemberTO member_id = dao.data_member(request, id);
	    	System.out.println( " member_id ->  " + member_id);
			modelAndView.addObject("member_id", member_id);
			//
			
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
		String id = request.getParameter("id");
		String pw = request.getParameter("password");
		String password = bcry.encode(request.getParameter("password"));
		to.setM_id(request.getParameter("id"));
		to.setM_pw(password);
		to.setM_mail(request.getParameter("mail"));
		
		int flag = m_dao.signup_ok(to);
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("signup_ok");
		modelAndView.addObject("flag", flag);
		modelAndView.addObject("sId", id);
		modelAndView.addObject("sPw", pw);
		return modelAndView; 
	}
	
	
	@RequestMapping("/kakao.do")
	public ModelAndView kakao(@RequestParam("code") String code, HttpSession session) {
		OAuthService oau = new OAuthService();
		String access_token = oau.getKakaoAccessToken(code);
		HashMap<String, Object> userInfo = oau.getKakaoUserInfo(access_token);
		
		System.out.println("유저정보"+userInfo.toString());
		
		Object idObject = userInfo.get("id");
		Object emailObject = userInfo.get("email");
		String id = String.valueOf(idObject);
		String email = String.valueOf(emailObject);
		
		ModelAndView modelAndView = new ModelAndView();
		  if(m_dao.confirmKakao(email) != null) { //가입한 회원이면
		  session.setAttribute("userInfo", email);
		  session.setAttribute("access_token", access_token);
		  modelAndView.addObject("login", "login"); System.out.println("로그인"); 
		  }
		 
		System.out.println("아이디는 :"+id);
		modelAndView.addObject("userEmail", email);
		modelAndView.addObject("userId", id);
	    modelAndView.setViewName("kakao");
	    return modelAndView;
	}
	
	@RequestMapping("/kSignup_ok.do")
	public ModelAndView kSignup_ok(HttpServletRequest request) {
		
		String userId = request.getParameter("userId");
		String email = request.getParameter("userEmail");
		
		String password = bcry.encode(userId);
		MemberTO to = new MemberTO();
		to.setM_mail(email);
		to.setM_id(email);
		to.setM_pw(password);
		
		int flag = m_dao.kSignup_ok(to);
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("kSignup_ok");
		modelAndView.addObject("flag", flag);
		return modelAndView; 
	}
	
	@RequestMapping("/klogout.do")
	public ModelAndView klogout(HttpSession session) {
		String access_Token = (String)session.getAttribute("access_Token");
		System.out.println("로그아웃토큰"+access_Token);
		OAuthService oau = new OAuthService();
		ModelAndView modelAndView = new ModelAndView();
		if(access_Token != null) {
			oau.kakaoLogout((String)session.getAttribute("access_token"));
			session.removeAttribute("acces_token");
			session.removeAttribute("userInfo");
			System.out.println("세션제거성공");
		}
		modelAndView.setViewName("redirect:/");
		return modelAndView; 
	}
	
	@RequestMapping("/signup2.do")
	public ModelAndView signup2(HttpServletRequest request) {
		ModelAndView modelAndView = new ModelAndView();
		if(request.getParameter("signup") != null) {
			modelAndView.setViewName("signup2");
		}
		modelAndView.setViewName("\"redirect:/main.do\"");
		return modelAndView; 
	}

	
}
