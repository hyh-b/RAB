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

	@Autowired
	private MypageDAO mydao;
	
	@RequestMapping("/")
	public ModelAndView index() {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("index");
		return modelAndView;
	}

	@RequestMapping("/profile.do")
	public ModelAndView profile(HttpServletRequest request, Authentication authentication, ModelMap map) {
		ModelAndView modelAndView = new ModelAndView();

		MypageTO myto = new MypageTO();
		
		//원하는 유저 정보 가져오기 - security패키지의 CustomUserDetails 설정
				//로그인한(인증된) 사용자의 정보를 authentication에 담음
				authentication = SecurityContextHolder.getContext().getAuthentication();
				//authentication에서 사용자 정보를 가져와 오브젝트에 담음
				Object principal = authentication.getPrincipal();
				// principal 객체를 CustomUserDetails 타입으로 캐스팅
				CustomUserDetails customUserDetails = (CustomUserDetails) principal;
				System.out.println("마이페이지 seq가져와 "+customUserDetails.getM_seq());
				String m_seq = customUserDetails.getM_seq();

		myto = mydao.Mypage(myto);

		modelAndView.setViewName("profile");
		modelAndView.addObject("myto", myto);
		modelAndView.addObject("m_seq", m_seq );
		return modelAndView;
	}

	@RequestMapping("/mypageModify.do")
	public ModelAndView mypageModify(HttpServletRequest request) {
		MypageTO myto = new MypageTO();

		myto = mydao.Mypage(myto);

		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("mypageModify");
		modelAndView.addObject("myto", myto);
		return modelAndView;
	}

	// --------------------------- 마이페이지_수정 -----------------------------------
	@RequestMapping("/mypageModifyOK.do")
	public ModelAndView mypageModifyOK(HttpServletRequest request,
			@RequestParam(value = "profile", required = false) MultipartFile profileUpload,
			@RequestParam(value = "cover", required = false) MultipartFile coverUpload) throws Exception {

		MypageTO myto = new MypageTO();

		// 요청 파라미터에서 필요한 데이터를 가져와서 MypageTO 객체에 설정
		myto.setM_name(request.getParameter("name"));
		myto.setM_tel(request.getParameter("phoneNumber"));
		myto.setM_height(request.getParameter("cm"));
		myto.setM_weight(request.getParameter("kg"));
		myto.setM_target_calorie(request.getParameter("takeKcal"));
		myto.setM_target_weight(request.getParameter("targetScale"));
		myto.setM_mail(request.getParameter("email"));
		myto.setM_birthday(request.getParameter("birthday"));

//	    System.out.println("coverUpload>>>>>>>>>>>>>>>>>> " + coverUpload );
//	    System.out.println("profileUpload>>>>>>>>>>>>>>>>>> " + profileUpload );

		// 글만 수정하는 경우
		if ((profileUpload == null || profileUpload.isEmpty()) && (coverUpload == null || coverUpload.isEmpty())) {
			System.out.println("컨트롤러에서 글만 변경합니다");
			int flag = mydao.modifyTextOnly(myto);

			// 결과를 담을 ModelAndView 객체 생성 및 설정
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.setViewName("mypageModifyOK");
			modelAndView.addObject("flag", flag);
			modelAndView.addObject("myto", myto);
			return modelAndView;
		}

		// 중복 파일명 처리를 위해 파일명에 타임스탬프 추가
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmssSSS");
		String timestamp = sdf.format(new Date());

		// 프로필 사진 변경
		if (profileUpload != null && !profileUpload.isEmpty()) {
			System.out.println("컨트롤러에서 프로필사진만 변경합니다");
			String originalProfileFilename = profileUpload.getOriginalFilename();
			String profileExtension = originalProfileFilename.substring(originalProfileFilename.lastIndexOf("."));
			String newProfileFilename = originalProfileFilename.replace(profileExtension,
					"_" + timestamp + profileExtension);
			
			System.out.println("변경된 프로필 사진 >>>>" + newProfileFilename);
			
			// 업로드
			profileUpload.transferTo(new File(newProfileFilename));
			
			// 타임스탬프 파일명 적용
			myto.setM_profilename(newProfileFilename);
			
			// 새로운 파일 사이즈 적용
			if (profileUpload != null && !profileUpload.isEmpty()) {
				myto.setM_profilesize(profileUpload.getSize());
			} else {
				myto.setM_profilesize(0);
			}
			
		}

		// 배경 사진 변경
		if (coverUpload != null && !coverUpload.isEmpty()) {
			System.out.println("컨트롤러에서 배경사진만 변경합니다");
			String originalCoverFilename = coverUpload.getOriginalFilename();
			String coverExtension = originalCoverFilename.substring(originalCoverFilename.lastIndexOf("."));
			String newCoverFilename = originalCoverFilename.replace(coverExtension, "_" + timestamp + coverExtension);

			System.out.println("newCoverFilename>>>>>>>>>>>>>>>>" + newCoverFilename);
			// 업로드
			coverUpload.transferTo(new File(newCoverFilename));

			myto.setM_backgroundfilename(newCoverFilename);
			
			if (coverUpload != null && !coverUpload.isEmpty()) {
				myto.setM_backgroundfilesize(coverUpload.getSize());
			} else {
				myto.setM_backgroundfilesize(0);
			}
			
		}

		// DAO 메서드 호출하여 마이페이지 수정 처리
		int flag = mydao.MypageModifyOk(myto);
		System.out.println("컨트롤러 수정 flag : " + flag );

		// 결과를 담을 ModelAndView 객체 생성 및 설정
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("mypageModifyOK");
		modelAndView.addObject("flag", flag);
		modelAndView.addObject("myto", myto);
		return modelAndView;
	}

	@RequestMapping("/mypageDeleteOK.do")
	public ModelAndView mypageDelete(HttpServletRequest request) {
		MypageTO myto = new MypageTO();

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
	
}

