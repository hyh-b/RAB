package com.example.controller;

import java.io.File;
import java.math.BigDecimal;
import java.security.Principal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
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
import com.example.model.MainDAO;
import com.example.model.MainTO;
import com.example.model.MemberDAO;
import com.example.model.MemberTO;
import com.example.model.MypageDAO;
import com.example.model.MypageTO;
import com.example.security.CustomUserDetails;
import com.example.model.MainDAO;
import com.example.model.MainTO;

@Controller
public class ConfigController {
	
	@Autowired
	private MemberDAO mDao;
	
	BCryptPasswordEncoder bcry = new BCryptPasswordEncoder();
	@Autowired
	private MypageDAO mydao;
	
	
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
		//원하는 유저 정보 가져오기 - security패키지의 CustomUserDetails 설정
		//로그인한(인증된) 사용자의 정보를 authentication에 담음
		authentication = SecurityContextHolder.getContext().getAuthentication();
		//authentication에서 사용자 정보를 가져와 오브젝트에 담음
		Object principal = authentication.getPrincipal();
		// principal 객체를 CustomUserDetails 타입으로 캐스팅
		CustomUserDetails customUserDetails = (CustomUserDetails) principal;
		System.out.println("seq가져와 "+customUserDetails.getM_seq());
		
		//유저 Id가져오기
		String mId = authentication.getName(); 
		//유저 Id를 통하여 정보가져오는 메서드
        MemberTO member = mDao.findByMId(mId); 
        // 권한 확인 후 정보입력 페이지로 넘김
        if("SIGNUP".equals(member.getM_role())) {
        	modelAndView.setViewName("redirect:/signup2.do");
        	return modelAndView;
        }
		
		//이미 저장된 세션을 가져옵니다.
	    HttpSession session = request.getSession();
	    
	    // 세션에서 m_seq 값을 가져옵니다.
	    String mSeq = (String) session.getAttribute("m_seq");
	    
	    // 콘솔에 m_seq 값을 출력합니다.
	    System.out.println("세션의 m_seq 값: " + mSeq);
		
        //정보
        ArrayList<MainTO> lists = dao.main_data();
        
        //음식 데이터
        ArrayList<MainTO> datas = dao.data_meals();
        
        map.addAttribute("user", member);
		modelAndView.addObject("lists", lists);
		modelAndView.addObject("datas", datas);
		
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

		if (upload != null && !upload.isEmpty()) {
		    myto.setM_filesize(upload.getSize());
		} else {
		    myto.setM_filesize(0);
		}
		
		int flag = mydao.MypageModifyOk(myto);
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("mypageModifyOK");
		modelAndView.addObject("flag" , flag);
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
	
	@RequestMapping("/exercise.do")
	public ModelAndView tables() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("exercise");
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
		   String gender = request.getParameter("gender");
		   String tel = request.getParameter("tel");
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
		   if(tel == "") {
			   tel=null;
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
	   @ResponseBody
	   @RequestMapping("/idCheck.do")
	   public int idCheck(@RequestParam("id") String id) {
		   int flag = mDao.idCheck(id);
			
		   return flag; 
	   }
	   //정보입력 닉네임 중복체크
	   @ResponseBody
	   @RequestMapping("/nameCheck.do")
	   public int nameCheck(@RequestParam("name") String name) {
		   int flag = mDao.nameCheck(name);
			
		   return flag; 
	   }
	   
	   @RequestMapping("/pra.do")
		public ModelAndView ds() {
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.setViewName("pra");
			return modelAndView; 
		}
	  
}
