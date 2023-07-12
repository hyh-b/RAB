package com.example.controller;

import java.math.BigDecimal;
import java.security.Principal;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.example.kakao.OAuthService;
import com.example.model.MemberDAO;
import com.example.model.MemberTO;

@RestController
public class MemberController {
	
	@Autowired
	private MemberDAO mDao;
	
	BCryptPasswordEncoder bcry = new BCryptPasswordEncoder();
	
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
	
	//회원가입
	@RequestMapping("/signup_ok.do")
	public ModelAndView signup_ok(HttpServletRequest request) {
		MemberTO to = new MemberTO();
		
		String id = request.getParameter("id");
		String pw = request.getParameter("password");
		String password = bcry.encode(request.getParameter("password"));
		
		to.setM_id(request.getParameter("id"));
		to.setM_pw(password);
		to.setM_mail(request.getParameter("mail"));
		to.setM_role("SIGNUP");
		
		int flag = mDao.signup_ok(to);
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("signup_ok");
		modelAndView.addObject("flag", flag);
		modelAndView.addObject("sId", id);
		modelAndView.addObject("sPw", pw);
			
		return modelAndView; 
	}
	
	//카카오 로그인
	@RequestMapping("/kakao.do")
	public ModelAndView kakao(@RequestParam("code") String code, HttpSession session) {
		//카카오 로그인을 처리하는 메서드가 담긴 클래스
		OAuthService oau = new OAuthService();
		//카카오에서 받은 코드를 다시 전달해 access_token 받음
		String access_token = oau.getKakaoAccessToken(code);
		//받은 access_token을 전달해 유저 정보를 받음 json형태로 받음. 받은 데이터는 해쉬맵에 저장
		HashMap<String, Object> userInfo = oau.getKakaoUserInfo(access_token);
		
		//자동 회원가입을 시키기 위해 정보추출
		Object idObject = userInfo.get("id");
		Object emailObject = userInfo.get("email");
		String id = String.valueOf(idObject);
		String email = String.valueOf(emailObject);
		session.setAttribute("userInfo", email);
		session.setAttribute("access_token", access_token);
		
		ModelAndView modelAndView = new ModelAndView();
		//가입한 회원이면 바로 로그인시키기 위해 login오브젝트 전달
		if(mDao.confirmKakao(email) != null) { 
			modelAndView.addObject("login", "login"); 
		}
	      	
		modelAndView.addObject("userEmail", email);
		modelAndView.addObject("userId", id);
		modelAndView.setViewName("kakao");
		
		return modelAndView;
	}
	
	//카카오 회원가입
	@RequestMapping("/kSignup_ok.do")
	public ModelAndView kSignup_ok(HttpServletRequest request) {
		//회원가입이 끝나면 알아서 로그인이 되기위해 정보전달
		String kId = request.getParameter("kId");
		String kPw = request.getParameter("kPw");
		
		String password = bcry.encode(kPw);
		MemberTO to = new MemberTO();
		
		to.setM_mail(kId);
		to.setM_id(kId);
		to.setM_pw(password);
		//추가 정보입력을 위해 기존 이용자들과 식별할 권한부여
		to.setM_role("SIGNUP");
		
		int flag = mDao.kSignup_ok(to);
		
		ModelAndView modelAndView = new ModelAndView();
		
		modelAndView.setViewName("kSignup_ok");
		
		modelAndView.addObject("flag", flag);
		modelAndView.addObject("kId", kId);
		modelAndView.addObject("kPw", kPw);
		
		return modelAndView; 
	}	
	
	//카카오 로그아웃
	@RequestMapping("/klogout.do")
	public ModelAndView klogout(HttpSession session) {
			
		String access_Token = (String)session.getAttribute("access_Token");
		OAuthService oau = new OAuthService();
		
		ModelAndView modelAndView = new ModelAndView();
		
		if(access_Token != null) {
			oau.kakaoLogout((String)session.getAttribute("access_token"));
			session.removeAttribute("acces_token"); session.removeAttribute("userInfo");
		}
			 
		modelAndView.setViewName("kLogout");
		
		return modelAndView; 
	}
	
	//회원가입 후 추가 정보입력
	@RequestMapping("/signup2.do")
	public ModelAndView signup2() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("signup2");
		return modelAndView; 
	}
	
	@RequestMapping("/signup2_ok.do")
	public ModelAndView signup2_ok(HttpServletRequest request,Authentication authentication) {
		MemberTO to = new MemberTO();
		   
		String id = authentication.getName();
		String name = request.getParameter("name");
		String realName = request.getParameter("realName");
		String gender = request.getParameter("gender");
		String tel = request.getParameter("tel1")+"-"+request.getParameter("tel2")+"-"+request.getParameter("tel3");
		String sWeight = request.getParameter("weight");
		String sHeight = request.getParameter("height");
		String targetCalorieStr = request.getParameter("target_calorie");
		String targetWeightStr = request.getParameter("target_weight");
		String birthday = request.getParameter("birthday_year")+"-"+request.getParameter("birthday_month")+"-"+request.getParameter("birthday_day");
		   
		BigDecimal weight = null;
		BigDecimal height = null;
		Integer targetCalorie = null;
		BigDecimal target_weight = null;
		//정보를 입력하지 않았을 경우 null처리
		if(name == "") {
			name=null;
		}	
		if(realName == "") {
			realName=null;
		}
		if(tel == "") {
			tel=null;
		}
		if(gender == "") {
			gender=null;
		}
		if(request.getParameter("birthday_year") ==""||request.getParameter("birthday_month")==""||request.getParameter("birthday_day")=="") {
			birthday = null;
		}
		if(sWeight != "") {
			weight = new BigDecimal(sWeight);
		}
		if(sHeight !="") {
			height = new BigDecimal(sHeight);
		}
		if (!targetCalorieStr.isEmpty()) {
			targetCalorie = Integer.parseInt(targetCalorieStr);
		}
		if(targetWeightStr !="") {
			target_weight = new BigDecimal(targetWeightStr);
		}
		
		to.setM_id(id);
		to.setM_name(name);
		to.setM_real_name(realName);
		to.setM_gender(gender);
		to.setM_birthday(birthday);
		to.setM_weight(weight);
		to.setM_height(height);
		to.setM_tel(tel);
		to.setM_target_calorie(targetCalorie);
		to.setM_target_weight(target_weight);
		//추가 정보입력을 위해 부여받은 권한 삭제
		to.setM_role(null);
		
		int flag = mDao.signup2_ok(to);
		   
		ModelAndView modelAndView = new ModelAndView();
			
		modelAndView.addObject("flag",flag);
		modelAndView.setViewName("signup2_ok");
		
		return modelAndView; 
	}
	
	//회원가입 아이디 중복체크
	@RequestMapping("/idCheck.do")
	public int idCheck(@RequestParam("id") String id) {
		int flag = mDao.idCheck(id);
			
		return flag; 
	}
	
	//정보입력 닉네임 중복체크
	@RequestMapping("/nameCheck.do")
	public int nameCheck(@RequestParam("name") String name) {
		int flag = mDao.nameCheck(name);
			
		return flag; 
	}
	
}	
