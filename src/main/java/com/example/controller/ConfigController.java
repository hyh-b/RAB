package com.example.controller;

import java.io.File;
import java.security.Principal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.ArrayList;

import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
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
	public ModelAndView main(Authentication authentication, ModelMap map, HttpServletRequest request) {

		ModelAndView modelAndView = new ModelAndView();

		// 이거 뭔가요? to hyh
		String mId = authentication.getName(); // Retrieve the m_id of the authenticated user
		MemberTO member = m_dao.findByMId(mId); // Retrieve the user details based on the m_id

		// 정보
		ArrayList<MainTO> lists = dao.main_data();

		// 음식 데이터
		ArrayList<MainTO> datas = dao.data_meals();

		System.out.println("     m_id: " + member.getM_id());
		System.out.println("     m_mail: " + member.getM_mail());

		// 지울것
		String id = request.getParameter("id");
		MemberTO member_id = dao.data_member(request, id);
		System.out.println(" member_id ->  " + member_id);
		//

		map.addAttribute("user", member);
		modelAndView.addObject("lists", lists);
		modelAndView.addObject("datas", datas);

		modelAndView.setViewName("main");
		return modelAndView;
	}

// ---------------- 마이 페이지 -----------------------------------
	@RequestMapping("/profile.do")
	public ModelAndView profile(HttpServletRequest request) {

		MypageTO myto = new MypageTO();

		myto = mydao.Mypage(myto);

		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("profile");
		modelAndView.addObject("myto", myto);
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
		modelAndView.setViewName("mypageDeleteOK");
		modelAndView.addObject("flag", flag);
		modelAndView.addObject("myto", myto);
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
		// 로그인 되어있는 사용자가 로그인페이지에 접근하면 main페이지로 돌려보냄
		if (principal != null && principal.getName() != null) {

			modelAndView.setViewName("redirect:/main.do");

			// 지울것
			String id = request.getParameter("id");
			MemberTO member_id = dao.data_member(request, id);
			System.out.println(" member_id ->  " + member_id);
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
		// 로그인 되어있는 사용자가 회원가입페이지에 접근하면 main페이지로 돌려보냄
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

		System.out.println("유저정보" + userInfo.toString());

		Object idObject = userInfo.get("id");
		Object emailObject = userInfo.get("email");
		String id = String.valueOf(idObject);
		String email = String.valueOf(emailObject);

		ModelAndView modelAndView = new ModelAndView();
		if (m_dao.confirmKakao(email) != null) { // 가입한 회원이면
			session.setAttribute("userInfo", email);
			session.setAttribute("access_token", access_token);
			modelAndView.addObject("login", "login");
			System.out.println("로그인");
		}

		System.out.println("아이디는 :" + id);
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
		String access_Token = (String) session.getAttribute("access_Token");
		System.out.println("로그아웃토큰" + access_Token);
		OAuthService oau = new OAuthService();
		ModelAndView modelAndView = new ModelAndView();
		if (access_Token != null) {
			oau.kakaoLogout((String) session.getAttribute("access_token"));
			session.removeAttribute("acces_token");
			session.removeAttribute("userInfo");
			System.out.println("세션제거성공");
		}
		modelAndView.setViewName("redirect:/");
		return modelAndView;
	}

}
