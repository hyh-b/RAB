package com.example.controller;

import java.io.File;
import java.io.IOException;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.example.model.ExerciseAlbumDAO;
import com.example.model.ExerciseAlbumTO;
import com.example.security.CustomUserDetails;

@RestController
public class ExerciseController {
	
	@Autowired
	ExerciseAlbumDAO eaDao;
	
	@RequestMapping("/exercise.do")
	public ModelAndView tables(Authentication authentication) {
		authentication = SecurityContextHolder.getContext().getAuthentication();
		Object principal = authentication.getPrincipal();
		CustomUserDetails customUserDetails = (CustomUserDetails) principal;
		String m_name = customUserDetails.getM_name();
		String m_gender = customUserDetails.getM_gender();
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("exercise");
		modelAndView.addObject("m_name",m_name);
		modelAndView.addObject("m_gender",m_gender);
		return modelAndView; 
	}
	
	@RequestMapping("/exerciseAlbum_ok.do")
	public ModelAndView exerciseAlbum_ok(HttpServletRequest request, Authentication authentication, MultipartFile upload) {
		authentication = SecurityContextHolder.getContext().getAuthentication();
		Object principal = authentication.getPrincipal();
		CustomUserDetails customUserDetails = (CustomUserDetails) principal;
		String m_seq = customUserDetails.getM_seq();
		
		ExerciseAlbumTO to = new ExerciseAlbumTO();
		
		String uploadDirectory = "/src/main/webapp/src/images/upload";
		
		int flag = 2;
		
		try {
			String extension = upload.getOriginalFilename().substring(upload.getOriginalFilename().lastIndexOf("."));
			String filename = upload.getOriginalFilename().substring(0,upload.getOriginalFilename().lastIndexOf("."));
				
			long timestamp = System.currentTimeMillis();
			String newfilename = uploadDirectory + filename + "-"+timestamp + extension;
			
			String uploadPath = request.getSession().getServletContext().getRealPath(uploadDirectory);
			
			upload.transferTo(new File(uploadPath, newfilename));
				
			to.setM_seq(m_seq);
			to.setAlbum_name(newfilename);
			to.setAlbum_size(upload.getSize());
			flag = eaDao.exerciseAlbum_ok(to);
			
		} catch (IllegalStateException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("exerciseAlbum_ok");
		modelAndView.addObject("flag",flag);
		return modelAndView; 
	}
}
