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
        
      
		modelAndView.addObject("flag", flag);
		modelAndView.addObject("lists", lists);
		
		modelAndView.setViewName("main");
		return modelAndView; 
	}
	
	//------jsonedDatas---------------------------------------

	@RequestMapping("charts_data")
	public ResponseEntity<String> JsonedDatas() {
		
	    ArrayList<MainTO> fdatas = dao.foodData();

	    JsonObject result = new JsonObject();
	    
	    JsonArray Foodarr = new JsonArray();

	    for (MainTO to : fdatas) {
	        JsonObject obj = new JsonObject();

	        // Breakfast
	        JsonObject meals = new JsonObject();
	        
	        meals.addProperty("m_seq", to.getM_seq());
	        
	        meals.addProperty("b_seq", to.getB_seq());
	        meals.addProperty("b_kcal", to.getB_kcal());
	        meals.addProperty("b_day", to.getB_day().toString());
	        meals.addProperty("b_name", to.getB_name().toString());
	        
	        meals.addProperty("b_carbohydrate_g", to.getB_carbohydrate_g());
	        meals.addProperty("b_protein_g", to.getB_protein_g());
	        meals.addProperty("b_fat_g", to.getB_fat_g());
	        meals.addProperty("b_sugar_g", to.getB_sugar_g());
	        meals.addProperty("b_cholesterol_mg", to.getB_cholesterol_mg());
	        meals.addProperty("b_sodium_mg", to.getB_sodium_mg());

	 
	        obj.add("meals", meals);

	        Foodarr.add(obj);
	    }

	    result.add("fdatas", Foodarr);
	    
	    //System.out.println("   result - >  " + result);
	   	
	   	return new ResponseEntity<String>(result.toString(), HttpStatus.OK);
	}
	
	
	//---------------datas for main elements------------------------//
	
	@RequestMapping("main_data")
	public ResponseEntity<String> MainElements(Authentication authentication, ModelMap map, HttpServletRequest request, String mId) {
		
		mId = authentication.getName(); // Retrieve the m_id of the authenticated user
        
		MemberTO member = m_dao.findByMId(mId); // Retrieve the user details based on the m_id
        
	    ArrayList<MainTO> lists = dao.main_data(mId);

	    JsonObject mainDatas = new JsonObject();

	    for (MainTO to : lists) {
	        
	        mainDatas.addProperty("m_seq", to.getM_seq());
	        mainDatas.addProperty("m_weight", to.getM_weight());
	        mainDatas.addProperty("m_target_weight", to.getM_target_weight());
	        
	        mainDatas.addProperty("i_day", to.getI_day().toString());
	        mainDatas.addProperty("i_kcal", to.getI_kcal());
	        mainDatas.addProperty("i_kcal", to.getI_used_kcal());

	    }	   	
	   	return new ResponseEntity<String>(mainDatas.toString(), HttpStatus.OK);
	}



}
