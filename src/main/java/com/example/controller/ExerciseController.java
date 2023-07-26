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
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
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
	
	private HttpSession httpSession;
	
	// S3에서 이미지 불러오는 url = https://rabfile.s3.ap-northeast-2.amazonaws.com/파일명
	
	private final S3FileUploadService s3FileUploadService;
	
	// S3에 업로드 성공시 생성되는 url의 고정 부분
	String base = "https://s3.ap-northeast-2.amazonaws.com/rabfile/";

	public ExerciseController(S3FileUploadService s3FileUploadService) {
        this.s3FileUploadService = s3FileUploadService;
    }
	
	@Autowired
	private CustomUserDetailsService customUserDetailsService;
	
	@RequestMapping("/exercise.do")
	public ModelAndView exercise() {
		//String accessToken = (String) httpSession.getAttribute("access_token");
        //System.out.println("Access Token: " + accessToken);
		customUserDetailsService.updateUserDetails();
		CustomUserDetails customUserDetails = customUserDetailsService.getCurrentUserDetails();
		
		String m_seq =  customUserDetails.getM_seq();
		String m_name = customUserDetails.getM_name();
		String m_profile = customUserDetails.getM_profilename();
		
		/*System.out.println("닉네임"+m_name);
		System.out.println("성별"+m_gender);
		System.out.println("애스이큐"+m_seq);
		*/
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("exercise");
		modelAndView.addObject("m_name",m_name);
		modelAndView.addObject("m_profile",m_profile);
		return modelAndView; 
	}
	
	//이미지 업로드
	@PostMapping("/exUpload")
	public int exUpload(@RequestParam("upload") MultipartFile upload,Authentication authentication) {
		authentication = SecurityContextHolder.getContext().getAuthentication();
		Object principal = authentication.getPrincipal();
		CustomUserDetails customUserDetails = (CustomUserDetails) principal;
		
		String m_seq = customUserDetails.getM_seq();
		
		ExerciseAlbumTO to = new ExerciseAlbumTO();
		
		int flag = 2;
		
		try {
            // S3에 파일 업로드 
            String fileUrl = s3FileUploadService.upload(upload);
            //System.out.println("수정전"+fileUrl);
            // 파일이 성공적으로 업로드 시 db에 데이터 저장
            if (fileUrl != null) {
            	// S3에 업로드 성공시 생성되는 URL에서 파일명만 잘라냄
            	String fileName = fileUrl.substring(base.length());
            	//System.out.println("수정"+fileName);
                to.setM_seq(m_seq);
                to.setAlbum_name(fileName);
                to.setAlbum_size(upload.getSize());
                flag = eaDao.exerciseAlbum_ok(to);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

		return flag;
	}
	
	// 이미지 출력
	@GetMapping("/imgSlide")
	public ResponseEntity<ArrayList<ExerciseAlbumTO>> imgSlide(Authentication authentication) {
		authentication = SecurityContextHolder.getContext().getAuthentication();
		Object principal = authentication.getPrincipal();
		CustomUserDetails customUserDetails = (CustomUserDetails) principal;
		
		String m_seq = customUserDetails.getM_seq();
		
		ArrayList<ExerciseAlbumTO> eaList = eaDao.exerciseAlbumList(m_seq);
		
		return ResponseEntity.ok(eaList);
	}
	
	// 사진전체보기에서 이미지 파일 삭제
	@PostMapping("/exDelete")
	public ResponseEntity<String> deleteImage(@RequestParam("aSeq") String aSeq) {
	    ExerciseAlbumTO to = new ExerciseAlbumTO();
	    // aJax로 받아온 aSeq값 입력
	    to.setA_seq(aSeq); 
	    //aSeq값을 이용해 파일URL가져온 뒤 파일명으로 가공
	    String fileName = (String)eaDao.exerciseAlbumName(aSeq);
	    
	    int flag = 2;
	    flag = eaDao.exerciseAlbumDelete_ok(to); 
	    
	    if (flag == 1) {
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

	public ResponseEntity<String> addExercise(@RequestBody Map<String, Object> getEx, Authentication authentication) {

		authentication = SecurityContextHolder.getContext().getAuthentication();
		Object principal = authentication.getPrincipal();
		CustomUserDetails customUserDetails = (CustomUserDetails) principal;
		
		String m_seq = customUserDetails.getM_seq();
		

		List<String> exercise = (List<String>)getEx.get("exercise");

		String date = (String)getEx.get("date"); 
		
		try {
            for (String exerciseName : exercise) {
                ExerciseTO to = new ExerciseTO();
                to.setEx_name(exerciseName);
                to.setM_seq(m_seq);  
                to.setEx_day(date);
                eDao.addExercise_ok(to);
            }
            return new ResponseEntity<>("운동 추가 성공", HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
        }
	}
	// 추가한 사용자설정운동 db에 저장
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
	        to.setEx_day(payload.get("selectedDate"));
	    } catch (NumberFormatException e) {
	        return new ResponseEntity<>(Map.of("result", "Error"), HttpStatus.INTERNAL_SERVER_ERROR);
	    }
	    
	    int result = eDao.addCustomExercise_ok(to);
	    
	    eDao.totalCalorie(m_seq,payload.get("selectedDate"));
	    
	    if(result > 0) {
	        return new ResponseEntity<>(Map.of("result", "Success"), HttpStatus.OK);
	    } else {
	        return new ResponseEntity<>(Map.of("result", "Error"), HttpStatus.INTERNAL_SERVER_ERROR);
	    }
	}
	
	// 운동칸에 당일 추가한 운동 보여주기
	@RequestMapping("/viewExercise")
    public List<Map<String, Object>> viewExercises(Authentication authentication,HttpServletRequest request, @RequestParam(value = "selectedDate") String selectedDate) {
		authentication = SecurityContextHolder.getContext().getAuthentication();
		Object principal = authentication.getPrincipal();
		CustomUserDetails customUserDetails = (CustomUserDetails) principal;
		
		String m_seq = customUserDetails.getM_seq();
		
		List<Map<String, Object>> responseList = new ArrayList<>();
		// true, false로 운동과 사용자설정 운동 구분
		ExerciseTO to = new ExerciseTO();
		
		to.setM_seq(m_seq);
		to.setEx_custom(false);
		to.setEx_day(selectedDate);
		
		List<ExerciseTO> exercises = eDao.viewExercise(to);
		
		for(ExerciseTO to1 : exercises) {
			Map<String, Object> response = new HashMap<>();
			
			String ex_name = to1.getEx_name();
			int ex_time = to1.getEx_time();
			BigDecimal ex_used_kcal = to1.getEx_used_kcal();
			
			response.put("ex_name",ex_name);
			response.put("ex_time",ex_time);
			response.put("ex_used_kcal",ex_used_kcal);
			
			responseList.add(response);
		}

		
		to.setM_seq(m_seq);
		to.setEx_custom(true);
		to.setEx_day(selectedDate);
		
		List<ExerciseTO> exercises2 = eDao.viewExercise(to);
		
		for(ExerciseTO to1 : exercises2) {
			Map<String, Object> response = new HashMap<>();
			
			String ex_name = to1.getEx_name();
			int ex_time = to1.getEx_time();
			BigDecimal ex_used_kcal = to1.getEx_used_kcal();
			
			response.put("ex_name2",ex_name);
			response.put("ex_time2",ex_time);
			response.put("ex_used_kcal2",ex_used_kcal);
			
			responseList.add(response);
		}
		return responseList;
    }
	
	// 운동시간 대비 소모 칼로리 구한 뒤 db저장
	@RequestMapping(value = "/calculateCalories", method = RequestMethod.POST)
	public List<ExerciseTO> updateExercise(@RequestBody Map<String, Object> payload,Authentication authentication) {

	    authentication = SecurityContextHolder.getContext().getAuthentication();
	    Object principal = authentication.getPrincipal();
	    CustomUserDetails customUserDetails = (CustomUserDetails) principal;
	    
	    String m_seq = customUserDetails.getM_seq();

	    List<Map<String, Object>> exercisesMap = (List<Map<String, Object>>) payload.get("exerciseItems");
	    String selectedDate = (String) payload.get("selectedDate");
	    List<ExerciseTO> exercises = exercisesMap.stream().map(map -> {
	        ExerciseTO exercise = new ExerciseTO();
	        exercise.setEx_name((String) map.get("ex_name"));
	        exercise.setEx_time(Integer.parseInt((String) map.get("ex_time")));
	        exercise.setM_seq(m_seq);
	        return exercise;
	    }).collect(Collectors.toList());
	    

	    exercises.forEach(exercise -> {
	    	// 소모 칼로리 계산 - 운동종목에 따른 분당 칼로리 * 운동 시간
	        BigDecimal ex_used_kcal = mDao.getCalorise(exercise.getEx_name()).multiply(new BigDecimal(exercise.getEx_time()));
	        exercise.setEx_used_kcal(ex_used_kcal);
	        exercise.setM_seq(m_seq);

	        exercise.setEx_day(selectedDate);

	        // 소모 칼로리 계산 후 db에 업데이트
	        eDao.updateExercise(exercise);
	    });
	    // 당일 총 소모칼로리 IntakeData에 업데이트
	    eDao.totalCalorie(m_seq,selectedDate);
	    return exercises; 
	}
	
	// 추가한 운동 종목 삭제
	@RequestMapping(value = "/deleteExercise", method = RequestMethod.POST)
    public ResponseEntity<String> deleteExercise(@RequestBody ExerciseTO to, Authentication authentication) {
		authentication = SecurityContextHolder.getContext().getAuthentication();
		Object principal = authentication.getPrincipal();
		CustomUserDetails customUserDetails = (CustomUserDetails) principal;
		    
		String m_seq = customUserDetails.getM_seq();
		
		to.setM_seq(m_seq);
        int result = eDao.deleteExercise(to);
        if (result > 0) {
        	// 당일 총 소모칼로리 IntakeData에 업데이트
    	    eDao.totalCalorie(m_seq,to.getEx_day());
            return new ResponseEntity<>("Exercise deleted successfully", HttpStatus.OK);
        } else {
            return new ResponseEntity<>("Failed to delete exercise", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

}
