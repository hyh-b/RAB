package com.example.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.amazonaws.services.s3.AmazonS3Client;
import com.example.model.ExerciseAlbumDAO;
import com.example.model.ExerciseAlbumTO;
import com.example.security.CustomUserDetails;
import com.example.upload.S3FileUploadService;

@RestController
public class ExerciseController {
	
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
		// 업로드 파일 삭제
		/* s3FileUploadService.deleteFile("ecc3bcb4b5134a5681a98ccf0e1cbfae.png"); */
		
		ArrayList<ExerciseAlbumTO> eaLists = eaDao.exerciseAlbumList(m_seq);
		// 버킷에 저장되어있는 url과 일치시키는 작업
		String bucketUrl = "https://" +bucket+".s3."+ region + ".amazonaws.com/";
		
		StringBuilder sbHtml = new StringBuilder();
		for(ExerciseAlbumTO to : eaLists) {
			// db에 저장된 파일url에서 파일 이름만 가져옴
			String fileName = to.getAlbum_name().substring(base.length());
			
			sbHtml.append("<div class=\"swiper-slide\">");
			sbHtml.append("<img src='"+bucketUrl+fileName+"'>");
			sbHtml.append("<div class=\"slideText\">"+to.getAlbum_day()+"</div>");
			sbHtml.append("</div>");
		}
		
		StringBuilder abHtml = new StringBuilder();
		for(ExerciseAlbumTO to2 : eaLists) {
			String fileName = to2.getAlbum_name().substring(base.length());
			abHtml.append( '"'+bucketUrl+fileName+'"'+",");
		}
		System.out.println(abHtml);
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("exercise");
		modelAndView.addObject("m_name",m_name);
		modelAndView.addObject("m_gender",m_gender);
		modelAndView.addObject("sbHtml",sbHtml);
		modelAndView.addObject("abHtml",abHtml.toString());
		return modelAndView; 
	}
	
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
}
