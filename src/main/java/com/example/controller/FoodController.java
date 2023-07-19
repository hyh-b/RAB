package com.example.controller;

import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.example.kakaoicloud.KakaoApiService;
import com.example.model.BreakfastDAO;
import com.example.model.BreakfastTO;
import com.example.model.DinnerDAO;
import com.example.model.DinnerTO;
import com.example.model.FoodDAO;
import com.example.model.FoodTO;
import com.example.model.LunchDAO;
import com.example.model.LunchTO;
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
		System.out.println(seq);
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("food");
		modelAndView.addObject("seq", seq);
		return modelAndView;
	}
	
	// 음식 데이터 찾기 
	@RequestMapping("/foodData")
	public List<Map<String, Object>> foodData1(HttpServletRequest request) {
		String foodName = request.getParameter("data");
		System.out.println("foodName" + foodName);
		
		List<Map<String, Object>> responseList = new ArrayList<>();
		List<FoodTO> foodList = fdao.selectFood(foodName);
		    
		for (FoodTO to : foodList) {
			Map<String, Object> response = new HashMap<>();
			
			String f_name = to.getF_name();
			int f_kcal = to.getF_kcal();
			BigDecimal f_carbohydrate_g = to.getF_carbohydrate_g();
			BigDecimal f_protein_g = to.getF_protein_g();
			BigDecimal f_fat_g = to.getF_fat_g();
			BigDecimal f_sugar_g = to.getF_sugar_g();
			int f_cholesterol_mg = to.getF_cholesterol_mg();
			int f_sodium_mg = to.getF_sodium_mg();
			
			response.put("f_name", f_name);
			response.put("f_kcal", f_kcal);
			response.put("f_carbohydrate_g", f_carbohydrate_g);
			response.put("f_protein_g", f_protein_g);
			response.put("f_fat_g", f_fat_g);
			response.put("f_sugar_g", f_sugar_g);
			response.put("f_cholesterol_mg", f_cholesterol_mg);
			response.put("f_sodium_mg", f_sodium_mg);
			
			System.out.println("음식 이름 \t :" + f_name);
			System.out.println("탄수화물 \t :" + f_carbohydrate_g);
			System.out.println("단백지 \t :" + f_protein_g);
			System.out.println("지방 \t :" + f_fat_g);
			System.out.println("콜레스토롤 \t :" + f_cholesterol_mg);
			System.out.println("나트륨 \t :" + f_sodium_mg);
			System.out.println("당 \t :" + f_sugar_g);
			System.out.println("칼로리 \t :" + f_kcal);
			
			
			responseList.add(response);
		}
		return responseList;
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

	            SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
	            String b_dayStr = request.getParameter("formattedDate"); 
	            Date b_day = null;

	            if (b_dayStr != null) {
	                try {
	                    b_day = formatter.parse(b_dayStr);
	                } catch (ParseException e) {
	                    e.printStackTrace();
	                }
	            }
	            System.out.println("시작 디버깅");
	            for (int i = 0; i < additionalDataArray.length(); i++) {
	                JSONObject additionalData = additionalDataArray.getJSONObject(i);
	                String f_name = additionalData.getString("f_name");
	                BigDecimal f_kcal = new BigDecimal(additionalData.getString("f_kcal"));
	                System.out.println("칼로리\t"+f_kcal);
	                BigDecimal f_carbohydrate_g = new BigDecimal(additionalData.getString("f_carbohydrate_g"));
	                BigDecimal f_protein_g = new BigDecimal(additionalData.getString("f_protein_g"));
	                BigDecimal f_fat_g = new BigDecimal(additionalData.getString("f_fat_g"));
	                BigDecimal f_sugar_g = new BigDecimal(additionalData.getString("f_sugar_g"));
	                BigDecimal f_cholesterol_mg = new BigDecimal(additionalData.getString("f_cholesterol_mg"));
	                BigDecimal f_sodium_mg = new BigDecimal(additionalData.getString("f_sodium_mg"));
	                
	                // 추가 데이터를 활용하여 새로운 BreakfastTO 객체 생성 후 DB에 저장
	                BreakfastTO bto = new BreakfastTO();
	                bto.setM_seq(Integer.parseInt(request.getParameter("seq")));
	                bto.setB_name(f_name);
	                bto.setB_kcal(f_kcal);
	                bto.setB_carbohydrate_g(f_carbohydrate_g);
	                bto.setB_protein_g(f_protein_g);
	                bto.setB_fat_g(f_fat_g);
	                bto.setB_sugar_g(f_sugar_g);
	                bto.setB_cholesterol_mg(f_cholesterol_mg);
	                bto.setB_sodium_mg(f_sodium_mg);
	                bto.setB_day(b_day);  // set the parsed date
	                System.out.println("내가 선택한 날짜 : "+ bto.getB_day());
	                
	                int flag = bdao.insertBreakfast(bto);
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
				
				
				SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
	            String l_dayStr = request.getParameter("formattedDate"); 
	            Date l_day = null;

	            if (l_dayStr != null) {
	                try {
	                	l_day = formatter.parse(l_dayStr);
	                } catch (ParseException e) {
	                    e.printStackTrace();
	                }
	            }
				
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
					LunchTO lto = new LunchTO();
					lto.setM_seq(Integer.parseInt(request.getParameter("seq")));
					lto.setL_name(l_name);
					lto.setL_kcal(l_kcal);
					lto.setL_carbohydrate_g(l_carbohydrate_g);
					lto.setL_protein_g(l_protein_g);
					lto.setL_fat_g(l_fat_g);
					lto.setL_sugar_g(l_sugar_g);
					lto.setL_cholesterol_mg(l_cholesterol_mg);
					lto.setL_sodium_mg(l_sodium_mg);
					lto.setL_day(l_day);
					int flag = ldao.insertLunchData(lto);
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
				
				SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
	            String d_dayStr = request.getParameter("formattedDate"); 
	            Date d_day = null;

	            if (d_dayStr != null) {
	                try {
	                	d_day = formatter.parse(d_dayStr);
	                } catch (ParseException e) {
	                    e.printStackTrace();
	                }
	            }
				
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
					DinnerTO dto = new DinnerTO();
					dto.setM_seq(Integer.parseInt(request.getParameter("seq")));
					dto.setD_name(d_name);
					dto.setD_kcal(d_kcal);
					dto.setD_carbohydrate_g(d_carbohydrate_g);
					dto.setD_protein_g(d_protein_g);
					dto.setD_fat_g(d_fat_g);
					dto.setD_sugar_g(d_sugar_g);
					dto.setD_cholesterol_mg(d_cholesterol_mg);
					dto.setD_sodium_mg(d_sodium_mg);
					dto.setD_day(d_day);
					
					int flag = ddao.insertDinnerData(dto);
					response.put("flag", flag);
				}
				
				return response;
				
			} catch (JSONException e) {
				e.printStackTrace();
			}
		}
		return null;  
	}
	
	
	
	@Autowired
	private final KakaoApiService kakaoApiService;	
	
	public FoodController(KakaoApiService kakaoApiService) {
		this.kakaoApiService = kakaoApiService;
	}
	
	@RequestMapping("/api/upload")
	public List<Map<String, Object>> uploadFile(@RequestParam("image") MultipartFile file) {
	    try {
	        String originalFileName = file.getOriginalFilename();
	        // 임시 디렉토리에 저장
	        Path tempFile = Files.createTempFile(null, originalFileName);
	        Files.write(tempFile, file.getBytes());
	        System.out.println("파일 이름 : \t"+tempFile);
	        // kakao API 콜!
	        String result = kakaoApiService.callKakaoVisionApi(tempFile.toString());

	        // json으로 파싱
	        JSONObject jsonObject = new JSONObject(result);
	        JSONArray resultsArray = jsonObject.getJSONArray("result");

	        // 모든 결과 처리
	        List<Map<String, Object>> response = new ArrayList<>();
	        for (int i = 0; i < resultsArray.length(); i++) {
	            JSONObject res = resultsArray.getJSONObject(i);
	            JSONArray classInfo = res.getJSONArray("class_info");

	            // 모든 classInfo 처리
	            for (int j = 0; j < classInfo.length(); j++) {
	                JSONObject food = classInfo.getJSONObject(j);

	                String foodName = food.getString("food_name");
	                JSONObject foodNutrients = food.getJSONObject("food_nutrients");

	                JSONObject perServingNutrients = foodNutrients.getJSONObject("1회제공량당_영양성분");
	                String protein = perServingNutrients.getString("단백질(g)");
	                String carbohydrates = perServingNutrients.getJSONObject("탄수화물").getString("총량(g)").replaceAll("\\s+", "");
	                String fat = perServingNutrients.getJSONObject("지방").getString("총량(g)");
	                String cholesterol = perServingNutrients.getString("콜레스테롤(mg)");
	                String sodium = perServingNutrients.getString("나트륨(mg)");
	                String sugar = perServingNutrients.getJSONObject("탄수화물").getString("당류(g)");
	                String kcal = perServingNutrients.getString("열량(kcal)");
	                
	                System.out.println("음식 이름:\t" + foodName);
	                System.out.println("단백질:\t" + protein);
	                System.out.println("탄수화물:\t" + carbohydrates);
	                System.out.println("지방:\t" + fat);
	                System.out.println("콜레스테롤:\t" + cholesterol);
	                System.out.println("나트륨:\t" + sodium);
	                System.out.println("당:\t" + sugar);
	                System.out.println("칼로리:\t"+kcal);

	                Map<String, Object> foodInfo = new HashMap<>();
	                foodInfo.put("foodName", foodName);
	                foodInfo.put("protein", protein);
	                foodInfo.put("carbohydrates", carbohydrates);
	                foodInfo.put("fat", fat);
	                foodInfo.put("cholesterol", cholesterol);
	                foodInfo.put("sodium", sodium);
	                foodInfo.put("sugar", sugar);
	                foodInfo.put("kcal", kcal);

	                response.add(foodInfo);
	            }
	        }

	        // 로컬 임시 저장소에 저장된 이미지 삭제
	        Files.delete(tempFile);

	        return response;
	    } catch (Exception e) {
	        throw new RuntimeException("[에러]\t: " + e.getMessage());
	    }
	}
	
}
