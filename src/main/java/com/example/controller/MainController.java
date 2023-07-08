package com.example.controller;

import java.awt.PageAttributes.MediaType;
import java.util.ArrayList;
import java.util.Arrays;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.example.model.MainDAO;
import com.example.model.MainTO;
import com.example.model.MemberDAO;
import com.example.model.MemberTO;
import com.example.model.MypageDAO;
import com.example.security.CustomUserDetails;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

@RestController
public class MainController {
	
	@Autowired
	private MemberDAO m_dao;
	
	@Autowired
	private MainDAO dao;
	
	BCryptPasswordEncoder bcry = new BCryptPasswordEncoder();
	
	JsonArray arr = new JsonArray();
	JsonObject obj = new JsonObject();
	
	@RequestMapping("/test.do")
	public ModelAndView testForMain(Authentication authentication, ModelMap map, HttpServletRequest request, String mId) {
		ModelAndView modelAndView = new ModelAndView();
		
		
		mId = authentication.getName(); // Retrieve the m_id of the authenticated user
        MemberTO member = m_dao.findByMId(mId); // Retrieve the user details based on the m_id
        
        //v_memberIntakeData 정보
        ArrayList<MainTO> lists = dao.main_data(mId);
        int flag = dao.InsertData(mId);
        
        System.out.println("     m_id: " + member.getM_id());
        System.out.println("     m_mail: " + member.getM_mail());
  
        map.addAttribute("user", member);
        
        
		modelAndView.addObject("lists", lists);
		modelAndView.addObject("flag", flag);
	
        modelAndView.setViewName("test");
		return modelAndView; 
	}

	
	@RequestMapping("/main.do")
	public ModelAndView main(Authentication authentication, ModelMap map, HttpServletRequest request, String mId) {
		
		ModelAndView modelAndView = new ModelAndView();
		
		//원하는 유저 정보 가져오기 - security패키지의 CustomUserDetails 설정
		//로그인한(인증된) 사용자의 정보를 authentication에 담음
		authentication = SecurityContextHolder.getContext().getAuthentication();
		//authentication에서 사용자 정보를 가져와 오브젝트에 담음
		Object principal = authentication.getPrincipal();
		// principal 객체를 CustomUserDetails 타입으로 캐스팅
		CustomUserDetails customUserDetails = (CustomUserDetails) principal;
		System.out.println("seq가져와 "+customUserDetails.getM_seq());
		
		mId = authentication.getName(); // Retrieve the m_id of the authenticated user
        MemberTO member = m_dao.findByMId(mId); // Retrieve the user details based on the m_id
        
        // 신규유저 권한 확인 후 정보입력 페이지로 넘김
        if("SIGNUP".equals(member.getM_role())) {
        	modelAndView.setViewName("redirect:/signup2.do");
        	return modelAndView;
        }
        
        //v_memberIntakeData 정보
        ArrayList<MainTO> lists = dao.main_data(mId);
        int flag = dao.InsertData(mId);
        
    
        System.out.println("     m_id: " + member.getM_id());
        System.out.println("     m_mail: " + member.getM_mail());
  
        map.addAttribute("user", member);
        
        
		modelAndView.addObject("lists", lists);
		modelAndView.addObject("flag", flag);
		
		modelAndView.setViewName("main");
		return modelAndView; 
	}
	
	//------jsonedData---------------------------------------
	

//	@RequestMapping(value = "/json_data.do", method = RequestMethod.GET, produces = "application/json")
//	public ResponseEntity<JsonObject> jsonData(Authentication authentication, ModelMap map, HttpServletRequest request, String mId) {
//			
//			ModelAndView modelAndView = new ModelAndView();
//			
//			mId = authentication.getName(); // Retrieve the m_id of the authenticated user
//	        MemberTO member = m_dao.findByMId(mId); // Retrieve the user details based on the m_id
//	    
//	        System.out.println("     m_id: " + member.getM_id());
//	        System.out.println("     m_mail: " + member.getM_mail());
//	  
//	        map.addAttribute("user", member);
//	        ArrayList<MainTO> fdatas = dao.foodData();
//	        
//	        JsonArray Foodarr = new JsonArray();
//	    	
//	
//	    	System.out.println("     fdatas ->" + fdatas.size() );
//	    	
//	    	for(MainTO to : fdatas){
//
//	               // Breakfast
//	               JsonObject breakfast = new JsonObject();
//	               breakfast.addProperty("b_seq", to.getB_seq());
//	               breakfast.addProperty("b_kcal", to.getB_kcal());
//	               breakfast.addProperty("b_day", to.getB_day().toString());
//	               // 나머지 필드들도 동일하게 처리
//	               obj.add("breakfast", breakfast);
//
//	               // Lunch
//	               JsonObject lunch = new JsonObject();
//	               lunch.addProperty("l_seq", to.getL_seq());
//	               lunch.addProperty("l_kcal", to.getL_kcal());
//	               lunch.addProperty("l_day", to.getL_day().toString());
//	               // 나머지 필드들도 동일하게 처리
//	               obj.add("lunch", lunch);
//
//	               // Dinner
//	               JsonObject dinner = new JsonObject();
//	               dinner.addProperty("d_seq", to.getD_seq());
//	               dinner.addProperty("d_kcal", to.getD_kcal());
//	               dinner.addProperty("d_day", to.getD_day().toString());
//	               // 나머지 필드들도 동일하게 처리
//	               obj.add("dinner", dinner);
//
//	               Foodarr.add(obj);
//	    	
//	    	}    	
//	    	
//	    	//JsonObject responseObject = new JsonObject();
//	    	//System.out.println( "\n      responseObject -> " + responseObject);
//	    	
//	        //responseObject.add("fdatas", arr);
//	        
//	    	System.out.println( "     arrr -> " + Foodarr);
//	 
//	       
//			modelAndView.setViewName("json_data");
//			//modelAndView.addObject("fdatas", fdatas);
//			modelAndView.addObject("Foodarr", Foodarr);
//			
//			return new ResponseEntity<>(Arrays.toString(Foodarr), HttpStatus.OK);
//
//		}
	
	@ResponseBody
	@RequestMapping(value = "/json_data.do", method = RequestMethod.POST)
	public ResponseEntity<JsonObject> jsonData(Authentication authentication, ModelMap map, HttpServletRequest request, String mId) {
		
	    mId = authentication.getName(); // Retrieve the m_id of the authenticated user
	    MemberTO member = m_dao.findByMId(mId); // Retrieve the user details based on the m_id

	    map.addAttribute("user", member);
	    ArrayList<MainTO> fdatas = dao.foodData();

	    JsonObject result = new JsonObject();
	    
	    JsonArray Foodarr = new JsonArray();

	    for (MainTO to : fdatas) {
	        JsonObject obj = new JsonObject();

	        // Breakfast
	        JsonObject breakfast = new JsonObject();
	        breakfast.addProperty("b_seq", to.getB_seq());
	        breakfast.addProperty("b_kcal", to.getB_kcal());
	        breakfast.addProperty("b_day", to.getB_day().toString());
	        // 나머지 필드들도 동일하게 처리
	        obj.add("breakfast", breakfast);

	        // Lunch
	        JsonObject lunch = new JsonObject();
	        lunch.addProperty("l_seq", to.getL_seq());
	        lunch.addProperty("l_kcal", to.getL_kcal());
	        lunch.addProperty("l_day", to.getL_day().toString());
	        // 나머지 필드들도 동일하게 처리
	        obj.add("lunch", lunch);

	        // Dinner
	        JsonObject dinner = new JsonObject();
	        dinner.addProperty("d_seq", to.getD_seq());
	        dinner.addProperty("d_kcal", to.getD_kcal());
	        dinner.addProperty("d_day", to.getD_day().toString());
	        // 나머지 필드들도 동일하게 처리
	        obj.add("dinner", dinner);

	        Foodarr.add(obj);
	    }

	    result.add("fdatas", Foodarr);
	    
	    System.out.println("   result - >  " + result);

	    return new ResponseEntity<>(result, HttpStatus.OK);
	}




}
