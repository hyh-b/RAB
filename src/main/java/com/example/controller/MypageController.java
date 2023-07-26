package com.example.controller;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.amazonaws.services.s3.AmazonS3Client;
import com.example.model.ExerciseAlbumDAO;
import com.example.model.ExerciseAlbumTO;
import com.example.model.MypageDAO;
import com.example.model.MypageTO;
import com.example.security.CustomUserDetails;
import com.example.security.CustomUserDetailsService;
import com.example.upload.S3FileUploadService;

@RestController
public class MypageController {
	// @Autowired
	// CustomUserDetailsService customUserDetailsService = new
	// CustomUserDetailsService();

	@Autowired
	private MypageDAO mydao;

	// 프로퍼티에서 버킷 이름 할당
	@Value("${cloud.aws.s3.bucket}")
	private String bucket;

	// 프로퍼티에서 지역 코드 할당
	@Value("${cloud.aws.region.static}")
	private String region;

	// 버킷에 저장되어있는 url과 일치시키는 작업
	String bucketUrl = "https://rabfile.s3.ap-northeast-2.amazonaws.com/";

	private final S3FileUploadService s3FileUploadService;
	// 업로드 시 db에 저장되는 url중 고정 부분
	String base = "https://s3.ap-northeast-2.amazonaws.com/rabfile/";

	public MypageController(S3FileUploadService s3FileUploadService) {
		this.s3FileUploadService = s3FileUploadService;
	}

	@RequestMapping("/profile.do")
	public ModelAndView profile(HttpServletRequest request, Authentication authentication) {
		ModelAndView modelAndView = new ModelAndView();

		MypageTO myto = new MypageTO();

		// 원하는 유저 정보 가져오기 - security패키지의 CustomUserDetails 설정
		// 로그인한(인증된) 사용자의 정보를 authentication에 담음
		authentication = SecurityContextHolder.getContext().getAuthentication();
		// authentication에서 사용자 정보를 가져와 오브젝트에 담음
		Object principal = authentication.getPrincipal();
		// principal 객체를 CustomUserDetails 타입으로 캐스팅
		CustomUserDetails customUserDetails = (CustomUserDetails) principal;
		String seq = customUserDetails.getM_seq();

		myto.setM_seq(seq);

		myto = mydao.Mypage(myto);


		modelAndView.setViewName("profile");
		modelAndView.addObject("myto", myto);
		modelAndView.addObject("seq", seq);
		return modelAndView;
	}

	@RequestMapping("/mypageModify.do")
	public ModelAndView mypageModify(HttpServletRequest request, Authentication authentication) {
		MypageTO myto = new MypageTO();

		// 원하는 유저 정보 가져오기 - security패키지의 CustomUserDetails 설정
		// 로그인한(인증된) 사용자의 정보를 authentication에 담음
		authentication = SecurityContextHolder.getContext().getAuthentication();
		// authentication에서 사용자 정보를 가져와 오브젝트에 담음
		Object principal = authentication.getPrincipal();
		// principal 객체를 CustomUserDetails 타입으로 캐스팅
		CustomUserDetails customUserDetails = (CustomUserDetails) principal;
		String seq = customUserDetails.getM_seq();
		myto.setM_seq(seq);

		myto = mydao.Mypage(myto);

		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("mypageModify");
		modelAndView.addObject("myto", myto);
		modelAndView.addObject("seq", seq);
		return modelAndView;
	}

	// --------------------------- 마이페이지 수정 -----------------------------------
	@RequestMapping("/mypageModifyOK.do")
	public ModelAndView mypageModifyOK(HttpServletRequest request,
			@RequestParam(value = "profile", required = false) MultipartFile profileUpload,
			@RequestParam(value = "cover", required = false) MultipartFile coverUpload, Authentication authentication)
			throws Exception {

		MypageTO myto = new MypageTO();

		Object principal = authentication.getPrincipal();
		CustomUserDetails customUserDetails = (CustomUserDetails) principal;
//		System.out.println("마이페이지 수정OK seq가져와 " + customUserDetails.getM_seq());
		String seq = customUserDetails.getM_seq();
		myto.setM_seq(seq);

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
//			System.out.println("컨트롤러에서 글만 변경합니다");
			int flag = mydao.modifyTextOnly(myto);

			// 결과를 담을 ModelAndView 객체 생성 및 설정
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.setViewName("mypageModifyOK");
			modelAndView.addObject("flag", flag);
			modelAndView.addObject("seq", seq);
			modelAndView.addObject("myto", myto);
			return modelAndView;
		}

		// 프로필 사진 변경
		if (profileUpload != null && !profileUpload.isEmpty()) {
//			System.out.println("컨트롤러에서 프로필사진만 변경합니다");
			try {
				// S3에 파일 업로드
				String fileUrl = s3FileUploadService.upload(profileUpload);
				String profileName = fileUrl.substring(base.length());
				// 파일이 성공적으로 업로드 시 db에 데이터 저장
				if (fileUrl != null) {
//					System.out.println("프사가 성공적으로 업로드");
					myto.setM_profilename(profileName);
					myto.setM_profilesize(profileUpload.getSize());
				}

			} catch (Exception e) { e.printStackTrace(); }
		}

		// 배경 사진 변경
		if (coverUpload != null && !coverUpload.isEmpty()) {
//			System.out.println("컨트롤러에서 배경사진만 변경합니다");
			try {
				// S3에 파일 업로드
				String fileUrl = s3FileUploadService.upload(coverUpload);

				// db에 저장된 파일url에서 파일 이름만 가져옴
				String backgroundfileName = fileUrl.substring(base.length());

				// 파일이 성공적으로 업로드 시 db에 데이터 저장
				if (fileUrl != null) {
//					System.out.println("배사가 성공적으로 업로드");
					myto.setM_backgroundfilename(backgroundfileName);
					myto.setM_backgroundfilesize(coverUpload.getSize());
				}

			} catch (Exception e) { e.printStackTrace(); }
		}
		
		// DAO 메서드 호출하여 마이페이지 수정 처리
		int flag = mydao.MypageModifyOk(myto);
//		System.out.println("컨트롤러 수정 flag : " + flag);

		// 결과를 담을 ModelAndView 객체 생성 및 설정
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("mypageModifyOK");
		modelAndView.addObject("flag", flag);
		modelAndView.addObject("seq", seq);
		modelAndView.addObject("myto", myto);
		return modelAndView;
	}

	@RequestMapping("/mypageDeleteOK.do")
	public ModelAndView mypageDelete(HttpServletRequest request, Authentication authentication, MultipartFile upload) {
	    MypageTO myto = new MypageTO();

	    Object principal = authentication.getPrincipal();
	    CustomUserDetails customUserDetails = (CustomUserDetails) principal;
	    System.out.println("마이페이지 삭제OK seq 가져와: " + customUserDetails.getM_seq());
	    String seq = customUserDetails.getM_seq();
	    myto.setM_seq(seq);

	    int flag = mydao.MypageDeleteOk(myto);

//	    if (flag == 0) {
//	        String profileName = myto.getM_profilename();
//	        String backgroundfileName = myto.getM_backgroundfilename();
//
//	        s3FileUploadService.deleteFile(backgroundfileName);
//	        s3FileUploadService.deleteFile(profileName);
//
//	        System.out.println("파일 삭제 완료!");
//	    }

	    ModelAndView modelAndView = new ModelAndView();
	    modelAndView.setViewName("mypageDeleteOK");
	    modelAndView.addObject("flag", flag);
	    modelAndView.addObject("seq", seq);
	    modelAndView.addObject("myto", myto);
	    return modelAndView;
	}

}
