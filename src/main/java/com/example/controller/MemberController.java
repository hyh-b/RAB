package com.example.controller;

import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.security.Principal;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClient;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClientService;
import org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.stereotype.Controller;

import com.example.jwt.JwtTokenUtil;
import com.example.kakao.OAuthService;
import com.example.model.ExerciseTO;
import com.example.model.MainDAO;
import com.example.model.MemberDAO;
import com.example.model.MemberTO;
import com.example.model.PasswordResetTokenTO;
import com.example.security.CustomUserDetails;
import com.example.security.CustomUserDetailsService;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;

@RestController
public class MemberController {
	
	@Value("${myapp.secret-key}")
    private String jwtSecretKey;
	
	@Autowired
	private CustomUserDetailsService customUserDetailsService;
	
	@Autowired
	private JavaMailSender javaMailSender;
	
	@Autowired
	private MemberDAO mDao;
	
	@Autowired
	private MainDAO mainDao;
	
	//@Autowired
	//private OAuth2AuthorizedClientService authorizedClientService;
	
	@Autowired
	private JwtTokenUtil jwtTokenUtil;
	
	BCryptPasswordEncoder bcry = new BCryptPasswordEncoder();
	
	@RequestMapping("/signin.do")
	public ModelAndView signin(Principal principal, HttpServletRequest request) {
		
		ModelAndView modelAndView = new ModelAndView();
		// 로그인 되어있는 사용자가 로그인페이지에 접근하면  main페이지로 돌려보냄
		if (principal != null && principal.getName() != null) {
	        modelAndView.setViewName("redirect:/main.do");
	    }else {
	        
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
		ModelAndView modelAndView = new ModelAndView();
		
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
		System.out.println("세션값:"+(String)session.getAttribute("access_token"));
		
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
	public ModelAndView klogout(HttpServletRequest request, HttpServletResponse response,Authentication authentication) {
			
		// 로그아웃 처리
	   /* new SecurityContextLogoutHandler().logout(request, response, authentication);

	    // OAuth2AuthenticationToken을 통해 OAuth2AuthorizedClient 얻기
	    OAuth2AuthenticationToken oauthToken = (OAuth2AuthenticationToken)authentication;
	    OAuth2AuthorizedClient client = authorizedClientService.loadAuthorizedClient(
	        oauthToken.getAuthorizedClientRegistrationId(), 
	        oauthToken.getName());

	    // access token 가져오기
	    String accessToken = client.getAccessToken().getTokenValue();
	    System.out.println("토큰호출"+accessToken);
	    OAuthService oAuthService = new OAuthService();
	    // 카카오 로그아웃 API 호출
	    oAuthService.kakaoLogout(accessToken);*/
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("kLogout");
		
		return modelAndView; 
	}
	
	//회원가입 후 추가 정보입력
	@RequestMapping("/signup2.do")
	public ModelAndView signup2(Authentication authentication) {
		customUserDetailsService.updateUserDetails();
		authentication = SecurityContextHolder.getContext().getAuthentication();
		Object principal = authentication.getPrincipal();
		CustomUserDetails customUserDetails = (CustomUserDetails) principal;
		String mId= customUserDetails.getM_id();

		int flag = mainDao.InsertDataForMain(mId);
		//System.out.println("플래그:"+flag);
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("signup2");
		return modelAndView; 
	}
	
	@RequestMapping("/signup2_ok.do")
	public ModelAndView signup2_ok(HttpServletRequest request,Authentication authentication) {
		customUserDetailsService.updateUserDetails();
		authentication = SecurityContextHolder.getContext().getAuthentication();
		Object principal = authentication.getPrincipal();
		CustomUserDetails customUserDetails = (CustomUserDetails) principal;
		
		String m_seq = customUserDetails.getM_seq();
		
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
		   
		BigDecimal weight = new BigDecimal(sWeight);
		BigDecimal height = new BigDecimal(sHeight);
		Integer targetCalorie = Integer.parseInt(targetCalorieStr);
		BigDecimal target_weight = new BigDecimal(targetWeightStr);
		
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
	
	// 아이디 찾기
	@PostMapping("/findId")
    public List<String> findId(@RequestBody Map<String, String> request) {
		String m_mail = request.get("email");
		//System.out.println("시작");
		//System.out.println("메일"+m_mail);
		List<MemberTO> members = mDao.findId(m_mail);
	    List<String> id = new ArrayList<>();
	    for(MemberTO member : members) {
	        id.add(member.getM_id());
	    }
	    return id;
    }
	
	// 비밀번호 찾기 - 메일 전송
	@PostMapping("/findPw")
	public int findPw(@RequestBody MemberTO to) {
		//System.out.println(to.getM_id());
		//System.out.println(to.getM_mail());
		
		int flag = mDao.findPw(to);
				
		if(flag== 1) {
			long expirationTimeMillis = 3600000; // 토큰의 유효 시간 (1시간)
			
			PasswordResetTokenTO tokenTO = new PasswordResetTokenTO();
	        tokenTO.setId(to.getM_id());
	        tokenTO.setTimestamp(System.currentTimeMillis());
	        // 토큰에 만료 시간 설정
	        tokenTO.setExpiration(System.currentTimeMillis() + expirationTimeMillis);
	        String m_id = to.getM_id();
	        
	        String secretKey = jwtSecretKey; 
	        //System.out.println("컨트롤러 키:"+secretKey);
	        // 페이지에서 받은 아이디값을 넣은 jwt토큰 생성
	        String token = Jwts.builder()
	                .setSubject(m_id)
	                .claim("data", tokenTO)
	                .setExpiration(new Date(tokenTO.getExpiration()))
	                .signWith(SignatureAlgorithm.HS512, secretKey.getBytes(StandardCharsets.UTF_8))
	                .compact();
	       // System.out.println("토큰: "+token);
			String toEmail = to.getM_mail();
			String toName = "RockAtYourBody";
			String subject = "RAB 비밀번호 재설정";
			String content = "비밀번호를 재설정하려면 다음 링크를 클릭하세요(유효시간-60분): <a href='http://localhost:8080/reset_password?token=" + token + "'>클릭하세요</a>)";
			
			this.mailSender1(toEmail, toName, subject, content);
		}
		
		return flag;
	}
	
	// 메일 전송 메서드
	public void mailSender1(String toEmail,String toName, String subject, String content) {
	    try {
	        MimeMessage mimeMessage = javaMailSender.createMimeMessage();
	        MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true);

	        helper.setTo(toEmail);
	        helper.setSubject(subject);
	        helper.setText(content, true);
	        helper.setSentDate(new Date());

	        javaMailSender.send(mimeMessage);

	        //System.out.println("전송 완료");
	    } catch (MessagingException e) {
	        e.printStackTrace();
	    }
	}
	
	// 비밀번호 재설정 페이지
	@RequestMapping("/reset_password")
	public ModelAndView boardManagement() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("reset_password");
		return modelAndView;
	}
	
	// 비밀번호 재설정 확인
	@PostMapping("/reset_password_ok")
	public ModelAndView handlePasswordReset(@RequestParam("token") String token,@RequestParam("password") String password) {
	    ModelAndView modelAndView = new ModelAndView();
	    modelAndView.setViewName("reset_password_ok");
		//System.out.println("받은 토큰"+token);
		try {
	        // 토큰에서 사용자 ID 추출
	        String userId = jwtTokenUtil.getUserIdFromToken(token);
	        MemberTO to = new MemberTO();
	        to.setM_id(userId);
	        to.setM_pw(bcry.encode(password));
            int flag = mDao.changePw(to);
            
            if(flag == 1) {
            	modelAndView.addObject("ok","ok");
            }
            
	    } catch (Exception e) {
	    	//System.out.println("에러: "+e.getMessage());
	    }
	    return modelAndView;
	}
	
	// 신규,탈퇴 회원 수
	@PostMapping("/memberState")
    public Map<String, Integer> getMemberStats(@RequestParam("date") String date) {
        int newMemberCount = mDao.newMember(date);
        int deletedMemberCount = mDao.deletedMember(date);

        Map<String, Integer> response = new HashMap<>();
        response.put("newMember", newMemberCount);
        response.put("deletedMember", deletedMemberCount);

        return response;
    }
	
	// 이미 로그인 되어있는 유저가 카카오 로그인 접속시
	@RequestMapping("/alreadyLogin.do")
	public ModelAndView reset_password() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("alreadyLogin");
		return modelAndView; 
	}
	
	@RequestMapping("/signup3.do")
	public ModelAndView signup3(Authentication authentication) {
		customUserDetailsService.updateUserDetails();
		authentication = SecurityContextHolder.getContext().getAuthentication();
		Object principal = authentication.getPrincipal();
		CustomUserDetails customUserDetails = (CustomUserDetails) principal;
		
		String m_seq = customUserDetails.getM_seq();
		BigDecimal m_weight = customUserDetails.getM_weight();
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("signup3");
		//System.out.println("적용몸무게2:"+m_weight);
		mDao.MandIweightsynced(m_seq);
		return modelAndView; 
	}
	
}	
