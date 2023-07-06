package com.example.controller;

import java.security.Principal;
import java.io.File;
import java.security.Principal;
import java.text.SimpleDateFormat;
import java.util.Date;
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

import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.example.kakao.OAuthService;
import com.example.model.MemberDAO;
import com.example.model.MemberTO;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.example.model.MypageDAO;
import com.example.model.MypageTO;

import com.example.model.MainDAO;
import com.example.model.MainTO;

@Controller
public class ConfigController {
	
	@Autowired
	private MemberDAO m_dao;
	
	@Autowired
	private MypageDAO mydao;
	
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
	public ModelAndView main(Authentication authentication, ModelMap map, HttpServletRequest request, String mId) {
		
		ModelAndView modelAndView = new ModelAndView();
		
		mId = authentication.getName(); // Retrieve the m_id of the authenticated user
        MemberTO member = m_dao.findByMId(mId); // Retrieve the user details based on the m_id
        
        //v_memberIntakeData 정보
        ArrayList<MainTO> lists = dao.main_data(mId);
        int flag = dao.InsertData(mId);
        

        System.out.println("     m_id: " + member.getM_id());
        System.out.println("     m_mail: " + member.getM_mail());
  
        map.addAttribute("user", member);
        
        
		modelAndView.addObject("lists", lists);
		modelAndView.addObject("flag", flag);
		
		modelAndView.setViewName("main");
		return modelAndView; 
	}
	

	@RequestMapping("/profile.do")
	public ModelAndView profile(HttpServletRequest request) {
		
		MypageTO myto = new MypageTO();
		System.out.println("main에서 온 seq" + myto.getM_seq());
		System.out.println( myto.getM_join_date() );
		myto.setM_id(  request.getParameter("userId")  );
		System.out.println("request.getParameter(\"userId\") :  " + request.getParameter("userId") );
		
		myto = mydao.Mypage(myto);
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("profile");
		modelAndView.addObject("myto" , myto );
		return modelAndView; 
	}
	
	@RequestMapping("/mypageModify.do")
	public ModelAndView mypageModify(HttpServletRequest request) {
		MypageTO myto = new MypageTO();
		myto.setM_id(  request.getParameter("id")  );
		
		myto = mydao.Mypage(myto);
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("mypageModify");
		modelAndView.addObject("myto" , myto );
		return modelAndView; 
	}
	
	@RequestMapping("/mypageModifyOK.do")
	public ModelAndView mypageModifyOK(HttpServletRequest request, @RequestParam("upload") MultipartFile upload) throws Exception {
		MypageTO myto = new MypageTO();
		myto.setM_id(  request.getParameter("memberid")  );
		
		myto.setM_name( request.getParameter( "name" ) );
		myto.setM_tel( request.getParameter( "phoneNumber" ) );
		myto.setM_height( request.getParameter("cm") );
		myto.setM_weight( request.getParameter("kg") );
		myto.setM_target_calorie( request.getParameter("takeKcal") );
		myto.setM_target_weight( request.getParameter("targetScale") );
		myto.setM_mail( request.getParameter("email") );
		myto.setM_birthday( request.getParameter( "birthday" ) );
		

		// transferTo : 메모리에 있는거를 실제 파일에 적용
		String originalFilename = upload.getOriginalFilename();
		String extension = originalFilename.substring(originalFilename.lastIndexOf("."));
		
		// 중복 파일명 처리를 위해 파일명에 타임스탬프 추가
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmssSSS");
		String timestamp = sdf.format(new Date() );
		
		String newFilename = originalFilename.replace(extension, "_" + timestamp + extension);
		
		// 업로드
		upload.transferTo(new File(newFilename));
		
		myto.setM_filename(newFilename);

//		if (upload != null && !upload.isEmpty()) {
//		    myto.setM_filesize(upload.getSize());
//		} else {
//		    myto.setM_filesize(0);
//		}
//		
//		int flag = mydao.MypageModifyOk(myto);
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("mypageModifyOK");
		//modelAndView.addObject("flag" , flag);
		modelAndView.addObject("myto" , myto);
		return modelAndView; 
	}
	
	@RequestMapping("/mypageDelete.do")
	public ModelAndView mypageDelete(HttpServletRequest request) {
		MypageTO myto = new MypageTO();
		myto.setM_seq( Integer.parseInt( request.getParameter("seq") ) );
		myto.setM_id(  request.getParameter("id")  );
		
		int flag = mydao.MypageDeleteOk(myto);
		
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("mypageDelete");
		modelAndView.addObject("flag" , flag);
		modelAndView.addObject("myto" , myto);
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
	      
	      System.out.println( "  kakaoid =>" + id +"\n");
	      
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
}
