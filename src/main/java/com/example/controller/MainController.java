package com.example.controller;

import java.awt.PageAttributes.MediaType;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
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
		modelAndView.addObject("zzinid", member.getM_id());

        modelAndView.setViewName("test");
        
        System.out.println(" test.do m_id " + member.getM_id());
        
	    System.out.println(" test.do mId => " + mId);
        
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
        
       
        ArrayList<MainTO> lists = dao.main_data(mId);
        int flag = dao.InsertData(mId);
        
    
        System.out.println("     m_id: " + member.getM_id());
        System.out.println("     m_mail: " + member.getM_mail());
  
        map.addAttribute("user", member);
        

		modelAndView.addObject("flag", flag);
		modelAndView.addObject("lists", lists);
		modelAndView.addObject("zzinid", member.getM_id());
		
		System.out.println(" test.do m_id " + member.getM_id());
		
		modelAndView.setViewName("main");
		return modelAndView; 
	}
	
	//------jsonedDatas---------------------------------------

	@RequestMapping("charts_data")
	public ResponseEntity<String> JsonedDatas(Authentication authentication, String mId) {
		
		//@RequestParam int m_seq
		
	    ArrayList<MainTO> fdatas = dao.foodData();

	    JsonObject result = new JsonObject();
	    
	    JsonArray Foodarr = new JsonArray();
	    
		mId = authentication.getName(); // Retrieve the m_id of the authenticated user
        MemberTO member = m_dao.findByMId(mId); // Retrieve the user details based on the m_id

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
	        //meals.addProperty("m_id", member.toString());

	 
	        obj.add("meals", meals);

	        Foodarr.add(obj);
	    }

	    result.add("fdatas", Foodarr);
	    
	    System.out.println(" charts. mId => " + mId);
	    //System.out.println(" charts. mSeq => " + m_seq);
	    
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
	
	@RequestMapping("selected_data")
	public ResponseEntity<String> MainForSelectedDate(
	Authentication authentication, ModelMap map, HttpServletRequest request, String mId, 
	 @RequestParam("id") String id, @RequestParam("i_day") String i_day ) {
		
		mId = authentication.getName(); // Retrieve the m_id of the authenticated user
        
		MemberTO member = m_dao.findByMId(mId); // Retrieve the user details based on the m_id
        
	    ArrayList<MainTO> ddatas = dao.DateData(i_day, id);
	    
	    System.out.println("  i_day Controller -> " + i_day);
	    System.out.println("  m_id Controller -> " + id );

	    JsonObject mainDatas = new JsonObject();

	    for (MainTO to : ddatas) {
	        
	        mainDatas.addProperty("m_seq", to.getM_seq());
	        mainDatas.addProperty("m_weight", to.getM_weight());
	        mainDatas.addProperty("m_target_weight", to.getM_target_weight());
	        //mainDatas.addProperty("m_id", to.getM_id());
	        
	        mainDatas.addProperty("i_day", to.getI_day().toString());
	        mainDatas.addProperty("i_kcal", to.getI_kcal());
	        mainDatas.addProperty("i_weight", to.getI_weight());
	        mainDatas.addProperty("i_used_kcal", to.getI_used_kcal());
	        
	        mainDatas.addProperty("m_id", member.getM_id());
	        //mainDatas.addProperty("seq", member.getM_seq());


	    }	   	
	    
	    System.out.println(" mId Controller => " + mId);
	    
	   	return new ResponseEntity<String>(mainDatas.toString(), HttpStatus.OK);
	}
	
	
	
	//---- Charts Below-----------------------------
	
	@RequestMapping("pie_chart_data")
	public ResponseEntity<String> PieChartData(
	Authentication authentication, ModelMap map, HttpServletRequest request, String mId, 
	 @RequestParam("id") String id, @RequestParam("i_day") String i_day ) {
		
		mId = authentication.getName(); // Retrieve the m_id of the authenticated user
        
		MemberTO member = m_dao.findByMId(mId); // Retrieve the user details based on the m_id
        
	    ArrayList<MainTO> pieChart = dao.PieChartData(id, i_day);
	    
	    System.out.println("  i_day pie Controller -> " + i_day);
	    System.out.println("  m_id pie Controller -> " + id );

	    JsonObject pieDatas = new JsonObject();

	    for (MainTO to : pieChart) {
	        
	    	//기본 유저정보
	        pieDatas.addProperty("m_seq", to.getM_seq());
	        pieDatas.addProperty("m_id", to.getM_id());
	        
	        //단탄지
	        pieDatas.addProperty("i_protein_g", to.getI_protein_g());
	        pieDatas.addProperty("i_carbohydrate_g", to.getI_carbohydrate_g());
	        pieDatas.addProperty("i_fat_g", to.getI_fat_g());
	        
	        //콜나당
	        pieDatas.addProperty("i_cholesterol_mgl", to.getI_cholesterol_mgl());
	        pieDatas.addProperty("i_sodium_mg", to.getI_sodium_mg());
	        pieDatas.addProperty("i_sugar_g", to.getI_sugar_g());
 
	    }	   	
	    
	    System.out.println(" pieData jsoned -> " + pieDatas);
	    
	    //ModelAndView modelAndView = new ModelAndView();
	    //modelAndView.setViewName("pie_chart_data");
	    
	   	return new ResponseEntity<String>(pieDatas.toString(), HttpStatus.OK);
	  
	}
	
}
