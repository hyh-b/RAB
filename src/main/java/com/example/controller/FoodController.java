package com.example.controller;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.example.model.BreakfastDAO;
import com.example.model.BreakfastTO;
import com.example.model.DinnerDAO;
import com.example.model.DinnerTO;
import com.example.model.FoodDAO;
import com.example.model.LunchDAO;
import com.example.model.LunchTO;
import com.example.model.MemberTO;
import com.example.security.CustomUserDetails;

@RestController
public class FoodController {
	
	@Autowired
	FoodDAO fdao;
	
	@Autowired
	BreakfastDAO bdao;
	
	@Autowired
	LunchDAO ldao;
	
	@Autowired
	DinnerDAO ddao;
	
	@RequestMapping("/food.do")
	public ModelAndView food(HttpServletRequest request , Authentication authentication) {
//		MemberTO to = new MemberTO();
//		to.setM_seq((request.getParameter("seq")));
//		System.out.println(to.getM_seq());
//		String seq = to.getM_seq();
		
		//원하는 유저 정보 가져오기 - security패키지의 CustomUserDetails 설정
		//로그인한(인증된) 사용자의 정보를 authentication에 담음
		authentication = SecurityContextHolder.getContext().getAuthentication();
		//authentication에서 사용자 정보를 가져와 오브젝트에 담음
		Object principal = authentication.getPrincipal();
		// principal 객체를 CustomUserDetails 타입으로 캐스팅
		CustomUserDetails customUserDetails = (CustomUserDetails) principal;
		String seq = customUserDetails.getM_seq();
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("food");
		modelAndView.addObject("seq", seq);
		return modelAndView;
	}
	
	// 음식 데이터 찾기 
	@RequestMapping("/foodData")
	public Map<String, Object> foodData1(HttpServletRequest request) {
		String foodName = request.getParameter("data");
		System.out.println("foodName" + foodName);
		Map<String, Object> response = fdao.selectFood(foodName);
		return response;
	}
	
	// 아침 ajax 데이터 구문.
	@RequestMapping("/breakfastFoodData")
	public Map<String, Object> breakfastFoodData(HttpServletRequest request) {
	    System.out.println(request.getParameter("seq"));
	    
	    // 추가 데이터 처리
	    String additionalDataJson = request.getParameter("additionalData");
	    if (additionalDataJson != null) {
	        try {
	            JSONArray additionalDataArray = new JSONArray(additionalDataJson);
	            Map<String, Object> response = new HashMap<>();
	            for (int i = 0; i < additionalDataArray.length(); i++) {
	                JSONObject additionalData = additionalDataArray.getJSONObject(i);
	                String f_name = additionalData.getString("f_name");
	                BigDecimal f_kcal = new BigDecimal(additionalData.getString("f_kcal"));
	                BigDecimal f_carbohydrate_g = new BigDecimal(additionalData.getString("f_carbohydrate_g"));
	                BigDecimal f_protein_g = new BigDecimal(additionalData.getString("f_protein_g"));
	                BigDecimal f_fat_g = new BigDecimal(additionalData.getString("f_fat_g"));
	                BigDecimal f_sugar_g = new BigDecimal(additionalData.getString("f_sugar_g"));
	                BigDecimal f_cholesterol_mg = new BigDecimal(additionalData.getString("f_cholesterol_mg"));
	                BigDecimal f_sodium_mg = new BigDecimal(additionalData.getString("f_sodium_mg"));
	                
	                // 추가 데이터를 활용하여 새로운 BreakfastTO 객체 생성 후 DB에 저장
	                BreakfastTO additionalTO = new BreakfastTO();
	                additionalTO.setM_seq(Integer.parseInt(request.getParameter("seq")));
	                additionalTO.setB_name(f_name);
	                additionalTO.setB_kcal(f_kcal);
	                additionalTO.setB_carbohydrate_g(f_carbohydrate_g);
	                additionalTO.setB_protein_g(f_protein_g);
	                additionalTO.setB_fat_g(f_fat_g);
	                additionalTO.setB_sugar_g(f_sugar_g);
	                additionalTO.setB_cholesterol_mg(f_cholesterol_mg);
	                additionalTO.setB_sodium_mg(f_sodium_mg);
	                
	                int flag = bdao.insertBreakfast(additionalTO);
	                response.put("flag", flag);
	            }
	            
	            return response;
	            
	        } catch (JSONException e) {
	            e.printStackTrace();
	        }
	    }
		return null;
	}
	
	// 점심 ajax 구문
	@RequestMapping("/lunchFoodData")
	public Map<String, Object> lunchFoodData(HttpServletRequest request) {
		System.out.println(request.getParameter("seq"));
		
		// 추가 데이터 처리
		String additionalDataJson = request.getParameter("additionalData");
		if (additionalDataJson != null) {
			try {
				JSONArray additionalDataArray = new JSONArray(additionalDataJson);
				Map<String, Object> response = new HashMap<>();
				for (int i = 0; i < additionalDataArray.length(); i++) {
					JSONObject additionalData = additionalDataArray.getJSONObject(i);
					String l_name = additionalData.getString("f_name");
					BigDecimal l_kcal = new BigDecimal(additionalData.getString("f_kcal"));
					BigDecimal l_carbohydrate_g = new BigDecimal(additionalData.getString("f_carbohydrate_g"));
					BigDecimal l_protein_g = new BigDecimal(additionalData.getString("f_protein_g"));
					BigDecimal l_fat_g = new BigDecimal(additionalData.getString("f_fat_g"));
					BigDecimal l_sugar_g = new BigDecimal(additionalData.getString("f_sugar_g"));
					BigDecimal l_cholesterol_mg = new BigDecimal(additionalData.getString("f_cholesterol_mg"));
					BigDecimal l_sodium_mg = new BigDecimal(additionalData.getString("f_sodium_mg"));
					
					// 추가 데이터를 활용하여 새로운 BreakfastTO 객체 생성 후 DB에 저장
					LunchTO additionalTO = new LunchTO();
					additionalTO.setM_seq(Integer.parseInt(request.getParameter("seq")));
					additionalTO.setL_name(l_name);
					additionalTO.setL_kcal(l_kcal);
					additionalTO.setL_carbohydrate_g(l_carbohydrate_g);
					additionalTO.setL_protein_g(l_protein_g);
					additionalTO.setL_fat_g(l_fat_g);
					additionalTO.setL_sugar_g(l_sugar_g);
					additionalTO.setL_cholesterol_mg(l_cholesterol_mg);
					additionalTO.setL_sodium_mg(l_sodium_mg);
					
					int flag = ldao.insertLunchData(additionalTO);
					response.put("flag", flag);
				}
				
				return response;
				
			} catch (JSONException e) {
				e.printStackTrace();
			}
		}
		return null;
	}

	// 저녁 ajax 구문
	@RequestMapping("/dinnerFoodData")
	public Map<String, Object> dinnerFoodData(HttpServletRequest request) {
		System.out.println(request.getParameter("seq"));
		
		// 추가 데이터 처리
		String additionalDataJson = request.getParameter("additionalData");
		if (additionalDataJson != null) {
			try {
				JSONArray additionalDataArray = new JSONArray(additionalDataJson);
				Map<String, Object> response = new HashMap<>();
				for (int i = 0; i < additionalDataArray.length(); i++) {
					JSONObject additionalData = additionalDataArray.getJSONObject(i);
					String d_name = additionalData.getString("f_name");
					BigDecimal d_kcal = new BigDecimal(additionalData.getString("f_kcal"));
					BigDecimal d_carbohydrate_g = new BigDecimal(additionalData.getString("f_carbohydrate_g"));
					BigDecimal d_protein_g = new BigDecimal(additionalData.getString("f_protein_g"));
					BigDecimal d_fat_g = new BigDecimal(additionalData.getString("f_fat_g"));
					BigDecimal d_sugar_g = new BigDecimal(additionalData.getString("f_sugar_g"));
					BigDecimal d_cholesterol_mg = new BigDecimal(additionalData.getString("f_cholesterol_mg"));
					BigDecimal d_sodium_mg = new BigDecimal(additionalData.getString("f_sodium_mg"));
					
					// 추가 데이터를 활용하여 새로운 BreakfastTO 객체 생성 후 DB에 저장
					DinnerTO additionalTO = new DinnerTO();
					additionalTO.setM_seq(Integer.parseInt(request.getParameter("seq")));
					additionalTO.setD_name(d_name);
					additionalTO.setD_kcal(d_kcal);
					additionalTO.setD_carbohydrate_g(d_carbohydrate_g);
					additionalTO.setD_protein_g(d_protein_g);
					additionalTO.setD_fat_g(d_fat_g);
					additionalTO.setD_sugar_g(d_sugar_g);
					additionalTO.setD_cholesterol_mg(d_cholesterol_mg);
					additionalTO.setD_sodium_mg(d_sodium_mg);
					
					int flag = ddao.insertDinnerData(additionalTO);
					response.put("flag", flag);
				}
				
				return response;
				
			} catch (JSONException e) {
				e.printStackTrace();
			}
		}
		return null;  
	}
	
	
	
	
	
	
	
}
