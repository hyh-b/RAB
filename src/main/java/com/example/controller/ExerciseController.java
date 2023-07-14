package com.example.controller;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.security.Principal;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.amazonaws.services.s3.AmazonS3Client;
import com.example.model.ExerciseAlbumDAO;
import com.example.model.ExerciseAlbumTO;
import com.example.model.ExerciseDAO;
import com.example.model.ExerciseTO;
import com.example.model.MypageTO;
import com.example.model.matDAO;
import com.example.model.matTO;
import com.example.security.CustomUserDetails;
import com.example.security.CustomUserDetailsService;
import com.example.upload.S3FileUploadService;

@RestController
public class ExerciseController {
	//@Autowired
	//CustomUserDetailsService customUserDetailsService = new CustomUserDetailsService();
	
	@Autowired
	private ExerciseAlbumDAO eaDao;
	
	@Autowired
	private matDAO mDao;
	
	@Autowired
	private ExerciseDAO eDao;
	
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
	
	// 운동종목 검색
	@RequestMapping("/searchExercise")
	public List<matTO> searchExercise(@RequestParam String mat_name) {

		return mDao.searchMat(mat_name);
	}
	
	// 추가한 운동종목 db에 저장
	@RequestMapping(value = "/exerciseAdd", method = RequestMethod.POST)
	public ResponseEntity<String> addExercise(@RequestBody Map<String, List<String>> getEx, Authentication authentication) {
		authentication = SecurityContextHolder.getContext().getAuthentication();
		Object principal = authentication.getPrincipal();
		CustomUserDetails customUserDetails = (CustomUserDetails) principal;
		
		String m_seq = customUserDetails.getM_seq();
		
		List<String> exercise = getEx.get("exercise");
		
		try {
            for (String exerciseName : exercise) {
                ExerciseTO to = new ExerciseTO();
                to.setEx_name(exerciseName);
                to.setM_seq(m_seq);  
                eDao.addExercise_ok(to);
            }
            return new ResponseEntity<>("운동 추가 성공", HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
        }
	}
	// 추가한 사용자 설정운동 db에 저장
	@RequestMapping(value = "/addCustomExercise", method = RequestMethod.POST)
	public ResponseEntity<Map<String, String>> addCustomExercise(@RequestBody Map<String, String> payload, Authentication authentication) {
	    authentication = SecurityContextHolder.getContext().getAuthentication();
	    Object principal = authentication.getPrincipal();
	    CustomUserDetails customUserDetails = (CustomUserDetails) principal;
	    
	    String m_seq = customUserDetails.getM_seq();

	    ExerciseTO to = new ExerciseTO();
	    to.setM_seq(m_seq);

	    try {
	        to.setEx_name(payload.get("ex_name"));
	        to.setEx_time(Integer.parseInt(payload.get("ex_time")));
	        to.setEx_used_kcal(new BigDecimal(payload.get("ex_used_kcal")));
	    } catch (NumberFormatException e) {
	        System.out.println("Invalid number format");
	        return new ResponseEntity<>(Map.of("result", "Error"), HttpStatus.INTERNAL_SERVER_ERROR);
	    }
	    
	    int result = eDao.addCustomExercise_ok(to);
	    
	    eDao.totalCalorie(m_seq);
	    
	    if(result > 0) {
	        return new ResponseEntity<>(Map.of("result", "Success"), HttpStatus.OK);
	    } else {
	        return new ResponseEntity<>(Map.of("result", "Error"), HttpStatus.INTERNAL_SERVER_ERROR);
	    }
	}
	
	// 운동칸에 당일 추가한 운동 보여주기
	@RequestMapping("/viewExercise")
    public List<Map<String, Object>> viewExercises(Authentication authentication,HttpServletRequest request) {
		authentication = SecurityContextHolder.getContext().getAuthentication();
		Object principal = authentication.getPrincipal();
		CustomUserDetails customUserDetails = (CustomUserDetails) principal;
		
		String m_seq = customUserDetails.getM_seq();
		
		List<Map<String, Object>> responseList = new ArrayList<>();
		// true, false로 운동과 사용자설정 운동 구분
		List<ExerciseTO> exercises = eDao.viewExercise(false,m_seq);
		
		for(ExerciseTO to : exercises) {
			Map<String, Object> response = new HashMap<>();
			
			String ex_name = to.getEx_name();
			int ex_time = to.getEx_time();
			BigDecimal ex_used_kcal = to.getEx_used_kcal();
			
			response.put("ex_name",ex_name);
			response.put("ex_time",ex_time);
			response.put("ex_used_kcal",ex_used_kcal);
			
			responseList.add(response);
		}
		return responseList;
    }
	
	// 운동칸에 당일 추가한 사용자설정 운동 보여주기
	@RequestMapping("/viewCustomExercise")
    public List<Map<String, Object>> viewCustomExercises(Authentication authentication,HttpServletRequest request) {
		authentication = SecurityContextHolder.getContext().getAuthentication();
		Object principal = authentication.getPrincipal();
		CustomUserDetails customUserDetails = (CustomUserDetails) principal;
		
		String m_seq = customUserDetails.getM_seq();
		
		List<Map<String, Object>> responseList = new ArrayList<>();
		// true, false로 운동과 사용자설정 운동 구분
		List<ExerciseTO> exercises = eDao.viewExercise(true,m_seq);
		for(ExerciseTO to : exercises) {
			Map<String, Object> response = new HashMap<>();
			
			String ex_name = to.getEx_name();
			int ex_time = to.getEx_time();
			BigDecimal ex_used_kcal = to.getEx_used_kcal();
			
			response.put("ex_name",ex_name);
			response.put("ex_time",ex_time);
			response.put("ex_used_kcal",ex_used_kcal);
			
			responseList.add(response);
		}
		return responseList;
    }
	
	// 운동 시간에 따른 소모칼로리 구하기
	@RequestMapping(value = "/getCalories", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, BigDecimal> getCalories(@RequestBody Map<String, String> body) {
		// 운동 이름
		String ex_name = body.get("ex_name");
        // 운동 시간
        BigDecimal ex_time = new BigDecimal(body.get("ex_time"));
        // 운동 종목에 따른 분당 소모 칼로리
        BigDecimal getKcal = mDao.getCalorise(ex_name);
        // 운동시간과 분당 소모 칼로리를 곱해 해당 운동 총 소모칼로리 구힘
        BigDecimal totalCalories = ex_time.multiply(getKcal);

        return Map.of("calories", totalCalories);
    }
	
	// 운동 시간과 소모 칼로리 계산이 끝난 데이터 db에 업데이트
	@RequestMapping(value = "/updateExercise", method = RequestMethod.POST)
	@ResponseBody
	public String updateExercise(@RequestBody ExerciseTO to, Authentication authentication) {
		authentication = SecurityContextHolder.getContext().getAuthentication();
		Object principal = authentication.getPrincipal();
		CustomUserDetails customUserDetails = (CustomUserDetails) principal;
		
		String m_seq = customUserDetails.getM_seq();
		
		int updated = eDao.updateExercise(to, m_seq);
		
	    eDao.totalCalorie(m_seq);
	    if(updated > 0){
	        return "업데이트과 완료되었습니다";
	    }else{
	        throw new RuntimeException("업데이트에 실패했습니다");
	    }
	}
	
}
