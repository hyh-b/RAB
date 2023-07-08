package com.example.controller;

import java.awt.PageAttributes.MediaType;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
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
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

@RestController
public class MainController {
	
	@Autowired
	private MemberDAO m_dao;
	
	@Autowired
	private MainDAO dao;
	
	BCryptPasswordEncoder bcry = new BCryptPasswordEncoder();


	@RequestMapping("/test.do")
	public ModelAndView test(Authentication authentication, ModelMap map, HttpServletRequest request, String mId) {
		ModelAndView modelAndView = new ModelAndView();
		
		
		mId = authentication.getName(); // Retrieve the m_id of the authenticated user
        MemberTO member = m_dao.findByMId(mId); // Retrieve the user details based on the m_id
        
        //v_memberIntakeData 정보
        ArrayList<MainTO> lists = dao.main_data(mId);
        int flag = dao.InsertData(mId);
        
        System.out.println("     m_id: " + member.getM_id());
        System.out.println("     m_mail: " + member.getM_mail());
  
		modelAndView.addObject("lists", lists);
		modelAndView.addObject("flag", flag);
		
	
        modelAndView.setViewName("test");
        
        return modelAndView;
	}

	
	@RequestMapping("/main.do")
	public ModelAndView main(Authentication authentication, ModelMap map, HttpServletRequest request, String mId) {
		
		ModelAndView modelAndView = new ModelAndView();
		
		mId = authentication.getName(); // Retrieve the m_id of the authenticated user
        MemberTO member = m_dao.findByMId(mId); // Retrieve the user details based on the m_id
        
        //v_memberIntakeData 정보
        ArrayList<MainTO> lists = dao.main_data(mId);
        int flag = dao.InsertData(mId);
        
    
        System.out.println("     m_id: " + member.getM_id());
        System.out.println("     m_mail: " + member.getM_mail());
  
        map.addAttribute("user", member);
        
      
		modelAndView.addObject("flag", flag);
		modelAndView.addObject("lists", lists);
		
		modelAndView.setViewName("main");
		return modelAndView; 
	}
	
	//------jsonedData---------------------------------------

//	@RequestMapping("json_data")
//	public ResponseEntity<String> JsonedDatas() {
//	    
//	    ArrayList<MainTO> fdatas = dao.foodData();
//
//	    JsonObject result = new JsonObject();
//	    
//	    JsonArray Foodarr = new JsonArray();
//
//	    for (MainTO to : fdatas) {
//	        JsonObject obj = new JsonObject();
//
//	        // Breakfast
//	        JsonObject breakfast = new JsonObject();
//	        breakfast.addProperty("b_seq", to.getB_seq());
//	        breakfast.addProperty("b_kcal", to.getB_kcal());
//	        breakfast.addProperty("b_day", to.getB_day().toString());
//	        // 나머지 필드들도 동일하게 처리
//	        obj.add("breakfast", breakfast);
//
//	        // Lunch
//	        JsonObject lunch = new JsonObject();
//	        lunch.addProperty("l_seq", to.getL_seq());
//	        lunch.addProperty("l_kcal", to.getL_kcal());
//	        lunch.addProperty("l_day", to.getL_day().toString());
//	        // 나머지 필드들도 동일하게 처리
//	        obj.add("lunch", lunch);
//
//	        // Dinner
//	        JsonObject dinner = new JsonObject();
//	        dinner.addProperty("d_seq", to.getD_seq());
//	        dinner.addProperty("d_kcal", to.getD_kcal());
//	        dinner.addProperty("d_day", to.getD_day().toString());
//	        // 나머지 필드들도 동일하게 처리
//	        obj.add("dinner", dinner);
//
//	        Foodarr.add(obj);
//	    }
//
//	    result.add("fdatas", Foodarr);
//	    
//	    System.out.println("   result - >  " + result);
//	   	
//	   	return new ResponseEntity<String>(result.toString(), HttpStatus.OK);
//	}
	
	@RequestMapping("json_data")
	public ResponseEntity<String> JsonedDatas() {
	    
	    ArrayList<MainTO> fdatas = dao.foodData();

	    JsonObject result = new JsonObject();
	    
	    JsonArray Foodarr = new JsonArray();

	    for (MainTO to : fdatas) {
	        JsonObject obj = new JsonObject();

	        // Breakfast
	        JsonObject meals = new JsonObject();
	        meals.addProperty("b_seq", to.getB_seq());
	        meals.addProperty("b_kcal", to.getB_kcal());
	        meals.addProperty("b_day", to.getB_day().toString());
	        meals.addProperty("b_name", to.getB_name().toString());
	        meals.addProperty("b_carbohydrate_g", to.getB_carbohydrate_g());
	        meals.addProperty("b_carbohydrate_g", to.getB_carbohydrate_g());
	        meals.addProperty("b_carbohydrate_g", to.getB_carbohydrate_g());
	        meals.addProperty("b_carbohydrate_g", to.getB_carbohydrate_g());
	        meals.addProperty("b_carbohydrate_g", to.getB_carbohydrate_g());
	        meals.addProperty("b_carbohydrate_g", to.getB_carbohydrate_g());
	        
	        meals.addProperty("m_seq", to.getM_seq());
	        // 나머지 필드들도 동일하게 처리
	        obj.add("meals", meals);

	        Foodarr.add(obj);
	    }

	    result.add("fdatas", Foodarr);
	    
	    System.out.println("   result - >  " + result);
	   	
	   	return new ResponseEntity<String>(result.toString(), HttpStatus.OK);
	}



}
