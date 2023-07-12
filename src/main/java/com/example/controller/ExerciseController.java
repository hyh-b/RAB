package com.example.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.amazonaws.services.s3.AmazonS3Client;
import com.example.model.ExerciseAlbumDAO;
import com.example.model.ExerciseAlbumTO;
import com.example.security.CustomUserDetails;
import com.example.security.CustomUserDetailsService;
import com.example.upload.S3FileUploadService;

@RestController
public class ExerciseController {
	//@Autowired
	//CustomUserDetailsService customUserDetailsService = new CustomUserDetailsService();
	
	@Autowired
	ExerciseAlbumDAO eaDao;
	// 프로퍼티에서 버킷 이름 할당
	@Value("${cloud.aws.s3.bucket}")
	private String bucket;
	//프로퍼티에서 지역 코드 할당
	@Value("${cloud.aws.region.static}")
	private String region;
	
	private final S3FileUploadService s3FileUploadService;
	// 업로드 시 db에 저장되는 url중 고정 부분
	String base = "https://s3.ap-northeast-2.amazonaws.com/rabfile/";

	public ExerciseController(S3FileUploadService s3FileUploadService) {
        this.s3FileUploadService = s3FileUploadService;
    }
	
	@RequestMapping("/exercise.do")
	public ModelAndView tables(Authentication authentication) {
		authentication = SecurityContextHolder.getContext().getAuthentication();
		Object principal = authentication.getPrincipal();
		CustomUserDetails customUserDetails = (CustomUserDetails) principal;
		
		String m_name = customUserDetails.getM_name();
		String m_gender = customUserDetails.getM_gender();
		String m_seq = customUserDetails.getM_seq();
		String m_id = authentication.getName();
		
		// 업로드 파일 삭제
		 /*s3FileUploadService.deleteFile("634fbbb7e5324555acaad4c8debd28c7.png"); */
		
		ArrayList<ExerciseAlbumTO> eaLists = eaDao.exerciseAlbumList(m_seq);
		// 버킷에 저장되어있는 url과 일치시키는 작업
		String bucketUrl = "https://" +bucket+".s3."+ region + ".amazonaws.com/";
		
		// 이미지 슬라이더에 넣을 이미지파일
		StringBuilder sbHtml = new StringBuilder();
		for(ExerciseAlbumTO to : eaLists) {
			// db에 저장된 파일url에서 파일 이름만 가져옴
			String fileName = to.getAlbum_name().substring(base.length());
			
			sbHtml.append("<div class=\"swiper-slide\">");
			sbHtml.append("<img src='"+bucketUrl+fileName+"'>");
			sbHtml.append("<div class=\"slideText\">"+to.getAlbum_day()+"</div>");
			sbHtml.append("</div>");
		}
		// 사진전체보기에 넣을 이미지 파일
		StringBuilder abHtml = new StringBuilder();
		for(ExerciseAlbumTO to2 : eaLists) {
			String fileName = to2.getAlbum_name().substring(base.length());
			abHtml.append( "{src: '"+bucketUrl+fileName+"', aSeq: '"+to2.getA_seq()+"'},");
		}
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("exercise");
		modelAndView.addObject("m_name",m_name);
		modelAndView.addObject("m_gender",m_gender);
		modelAndView.addObject("sbHtml",sbHtml);
		modelAndView.addObject("abHtml",abHtml.toString());
		return modelAndView; 
	}
	// 이미지 업로드
	@RequestMapping("/exerciseAlbum_ok.do")
	public ModelAndView exerciseAlbum_ok(HttpServletRequest request, Authentication authentication, MultipartFile upload) {
		authentication = SecurityContextHolder.getContext().getAuthentication();
		Object principal = authentication.getPrincipal();
		CustomUserDetails customUserDetails = (CustomUserDetails) principal;
		
		String m_seq = customUserDetails.getM_seq();
		
		ExerciseAlbumTO to = new ExerciseAlbumTO();
		
		int flag = 2;
		
		try {
            // S3에 파일 업로드 
            String fileUrl = s3FileUploadService.upload(upload);
            
            // 파일이 성공적으로 업로드 시 db에 데이터 저장
            if (fileUrl != null) {
                to.setM_seq(m_seq);
                to.setAlbum_name(fileUrl);
                to.setAlbum_size(upload.getSize());
                flag = eaDao.exerciseAlbum_ok(to);
            }

        } catch (Exception e) {
            
            e.printStackTrace();
        }
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("exerciseAlbum_ok");
		modelAndView.addObject("flag",flag);
		return modelAndView; 
	}
	// 사진전체보기에서 이미지 파일 삭제
	@RequestMapping(value="/album_delete.do", method=RequestMethod.POST)
	public ResponseEntity<String> deleteImage(@RequestParam("aSeq") String aSeq) {
	    ExerciseAlbumTO to = new ExerciseAlbumTO();
	    // aJax로 받아온 aSeq값 입력
	    to.setA_seq(aSeq); 
	    //aSeq값을 이용해 파일URL가져온 뒤 파일명으로 가공
	    String URL = (String)eaDao.exerciseAlbumName(aSeq);
	    String fileName = URL.substring(base.length());
	    
	    int flag = 2;
	    flag = eaDao.exerciseAlbumDelete_ok(to); 
	    
	    if (flag == 0) {
	    	//S3 버킷에서 파일 삭제
	    	s3FileUploadService.deleteFile(fileName);
	        return new ResponseEntity<String>("삭제 성공", HttpStatus.OK);
	    } else {
	        return new ResponseEntity<String>("삭제 실패", HttpStatus.INTERNAL_SERVER_ERROR);
	    }
	}
}
