package com.example.controller;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.websocket.Session;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.example.model.MemberDAO;
import com.example.model.MemberTO;

@Controller
public class ConfigController {
	
	@Autowired
	private MemberDAO m_dao;
	
	//------------------------------------------------------------------------------------
	
	@RequestMapping("/")
	public ModelAndView index() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("index");
		return modelAndView; 
	}
	
	
	//------------------------------------------------------------------------------------
	
	@RequestMapping("/main.do")
	public ModelAndView main(HttpSession session) {
		ModelAndView modelAndView = new ModelAndView();
		
		if (session.getAttribute("user") == null) {
			
	        // 사용자가 로그인하지 않은 경우, 로그인 페이지로 이동
	        modelAndView.setViewName("signin");
	        return modelAndView;
	    }
	     
		modelAndView.setViewName("main");
		return modelAndView; 
	}
	
	//------------------------------------------------------------------------------------
	
	@RequestMapping("/profile.do")
	public ModelAndView profile() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("profile");
		return modelAndView; 
	}
	
	//------------------------------------------------------------------------------------
	
	@RequestMapping("/settings.do")
	public ModelAndView settings() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("settings");
		return modelAndView; 
	}
	
	//------------------------------------------------------------------------------------
	
	@RequestMapping("/buttons.do")
	public ModelAndView buttons() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("buttons");
		return modelAndView; 
	}
	
	//------------------------------------------------------------------------------------
	
	@RequestMapping("/tabs.do")
	public ModelAndView tabs() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("tabs");
		return modelAndView; 
	}
	
	//------------------------------------------------------------------------------------
	
	@RequestMapping("/modals.do")
	public ModelAndView modals() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("modals");
		return modelAndView; 
	}

	//------------------------------------------------------------------------------------
	
	@RequestMapping("/signin.do")
	public ModelAndView signin() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("signin");
		return modelAndView; 
	}
	
	//------------------------------------------------------------------------------------
	@RequestMapping("/signup.do")
	public ModelAndView signup() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("signup");
		return modelAndView; 
	}
	
	//------------------------------------------------------------------------------------
	
	@RequestMapping("/calendar.do")
	public ModelAndView calendar() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("calendar");
		return modelAndView; 
	}
	
	//------------------------------------------------------------------------------------
	
	@RequestMapping("/task-list.do")
	public ModelAndView task_list() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("calendar");
		return modelAndView; 
	}
	
	//------------------------------------------------------------------------------------
	
	@RequestMapping("/task-kanban.do")
	public ModelAndView task_kanban() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("task-kanban");
		return modelAndView; 
	}
	
	//------------------------------------------------------------------------------------
	
	@RequestMapping("/tables.do")
	public ModelAndView tables() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("tables");
		return modelAndView; 
	}

	//------------------------------------------------------------------------------------
	
	@RequestMapping("/index-ecommerce.do")
	public ModelAndView index_ecommerce() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("index-ecommerce");
		return modelAndView; 
	}
	
	//------------------------------------------------------------------------------------
	
	@RequestMapping("/alerts.do")
	public ModelAndView alerts() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("alerts");
		return modelAndView; 
	}
	
	//------------------------------------------------------------------------------------
	
	@RequestMapping("/cards.do")
	public ModelAndView cards() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("cards");
		return modelAndView; 
	}
	
	//------------------------------------------------------------------------------------
	
	@RequestMapping("/chart.do")
	public ModelAndView chart() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("chart");
		return modelAndView; 
	}
	
	//------------------------------------------------------------------------------------
	
	@RequestMapping("/reset-password.do")
	public ModelAndView reset_password() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("reset-password");
		return modelAndView; 
	}
	
	//------------------------------------------------------------------------------------
	
	@RequestMapping("/inbox.do")
	public ModelAndView inbox() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("inbox");
		return modelAndView; 
	}
	
	//------------------------------------------------------------------------------------
	
	@RequestMapping("/form-elements.do")
	public ModelAndView form_elements() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("form-elements");
		return modelAndView; 
	}
	
	//------------------------------------------------------------------------------------
	
	@RequestMapping("/form-layout.do")
	public ModelAndView form_layout() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("form-layout");
		return modelAndView; 
	}
	
	//------------------------------------------------------------------------------------
	
	@RequestMapping("/signup_ok.do")
	public ModelAndView signup_ok(HttpServletRequest request) {
		MemberTO to = new MemberTO();
		to.setM_id(request.getParameter("id"));
		to.setM_password(request.getParameter("password"));
		to.setM_mail(request.getParameter("mail"));
		
		int flag = m_dao.signup_ok(to);
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("signup_ok");
		modelAndView.addObject("flag", flag);
		return modelAndView; 
	}
	
	//------------------------------------------------------------------------------------
	
	@RequestMapping("/signin_ok.do")
	public ModelAndView signin_ok(HttpServletRequest request, HttpSession session, HttpServletResponse response) {
		
		MemberTO to = new MemberTO();
		to.setM_id(request.getParameter("id"));
		to.setM_password(request.getParameter("password"));
		
		MemberTO Authentication = m_dao.signin_ok(to);
		
		ModelAndView modelAndView = new ModelAndView();
		
		if (Authentication != null) {
			
	        //로그인 인증 성공시 세션에 정보 저장
	        session.setAttribute("user", Authentication);
	        modelAndView.setViewName("main");
	        
	        //로그인 하면 singin_ok.do가 도메인에 되어있음
	        //새로고침하면 main.do로 들어가지지만, sendredirection으로 보내는 방법 강구 필요
	        
//	        String url = "http://localhost:8080/main.do";
//	       
//	        try {
//				response.sendRedirect(url);
//			} catch (IOException e) {
//				// TODO Auto-generated catch block
//				e.printStackTrace();
//			}
	        
	    } else {
	        // 로그인 인증 실패시 로그인 화면으로
	        modelAndView.setViewName("signin");
	        modelAndView.addObject("error", "아이디와 비밀번호를 확인해주세요");
	    }

	    return modelAndView;
	}
	
	//------------------------------------------------------------------------------------
	
	 @RequestMapping("/logout.do")
	    public ModelAndView logout(HttpSession session) {
	        session.invalidate(); // 세션삭제
	        
	        ModelAndView modelAndView = new ModelAndView();
	        modelAndView.setViewName("index"); 
	        return modelAndView;
	    }
	
	//------------------------------------------------------------------------------------
		
		//---------------------------------- messages안씀, 테스트 페이지로 쓰자.
		@RequestMapping("/test.do")
		public ModelAndView test() {
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.setViewName("test");
			return modelAndView; 
		}
		
		
	
}
