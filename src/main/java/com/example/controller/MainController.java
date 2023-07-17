package com.example.controller;

import java.awt.PageAttributes.MediaType;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

import org.apache.ibatis.annotations.Param;
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

import com.example.model.BreakfastTO;
import com.example.model.MainDAO;
import com.example.model.MainTO;
import com.example.model.MemberDAO;
import com.example.model.MemberTO;
import com.example.model.MypageDAO;
import com.example.model.MypageTO;
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
		
		MypageTO mypageTO = new MypageTO();

		
		mId = authentication.getName(); // Retrieve the m_id of the authenticated user
        MemberTO member = m_dao.findByMId(mId); // Retrieve the user details based on the m_id
        
        //v_memberIntakeData 정보
        ArrayList<MainTO> lists = dao.main_data(mId);
        
        
        
        //유저마다 한개의 참조 레코드 생성
        int flag = dao.InsertData(mId);
        
        System.out.println("     m_id: " + member.getM_id());
        System.out.println("     m_mail: " + member.getM_mail());
        
        System.out.println("     m_mail: " + member.getM_mail());
  
		modelAndView.addObject("lists", lists);
		modelAndView.addObject("flag", flag);
		modelAndView.addObject("zzinid", member.getM_id());
		modelAndView.addObject("zzinseq", member.getM_seq());
		modelAndView.addObject("profilename", mypageTO.getM_profilename());

        modelAndView.setViewName("test");
        
        System.out.println(" test.do m_id " + member.getM_id());
        
	    System.out.println(" test.do mId => " + mId);
        
        return modelAndView;
	}

	
	@RequestMapping("/main.do")
	public ModelAndView main(Authentication authentication, ModelMap map, HttpServletRequest request, String mId) {
		
		ModelAndView modelAndView = new ModelAndView();
		
		MypageTO mypageTO = new MypageTO();
		//원하는 유저 정보 가져오기 - security패키지의 CustomUserDetails 설정
		//로그인한(인증된) 사용자의 정보를 authentication에 담음
		
		authentication = SecurityContextHolder.getContext().getAuthentication();
		//authentication에서 사용자 정보를 가져와 오브젝트에 담음
		Object principal = authentication.getPrincipal();
		
		// principal 객체를 CustomUserDetails 타입으로 캐스팅
		CustomUserDetails customUserDetails = (CustomUserDetails) principal;
		System.out.println("seq가져와 "+ customUserDetails.getM_seq());
		
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
		modelAndView.addObject("zzinseq", member.getM_seq());
		modelAndView.addObject("profilename", mypageTO.getM_profilename());
		
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
	 @RequestParam("seq") int seq, @RequestParam("day") String day ) {
		
		mId = authentication.getName(); // Retrieve the m_id of the authenticated user
        
		MemberTO member = m_dao.findByMId(mId); // Retrieve the user details based on the m_id
        
	    ArrayList<MainTO> ddatas = dao.DateData(seq, day);
	    
	    System.out.println(" selected_data i_day Controller -> " + day);
	    System.out.println(" selected_data seq Controller -> " + seq );

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
	    
	    //System.out.println(" mId Controller => " + mId);
	    
	   	return new ResponseEntity<String>(mainDatas.toString(), HttpStatus.OK);
	}
	
	
	
	//---- Charts Below-----------------------------
	
//---pieData---------------------------------------------------
	@RequestMapping("pie_chart_data")
	public ResponseEntity<String> PieChartData(
	Authentication authentication, ModelMap map, HttpServletRequest request, String mId, 
	 @RequestParam("seq") int seq, @RequestParam("day") String day ) {
		
		mId = authentication.getName(); // Retrieve the m_id of the authenticated user
        
		MemberTO member = m_dao.findByMId(mId); // Retrieve the user details based on the m_id
        
	    ArrayList<MainTO> pieChart = dao.PieChartData(seq, day);
	    
	    JsonArray pieDatas = new JsonArray(); 
	    
	    System.out.println("  day pie Controller -> " + day);
	    System.out.println("  seq pie Controller -> " + seq );
	    
	    for (MainTO to : pieChart) {
	    	
	    	 JsonObject pieData = new JsonObject();
	        
	    	//기본 유저정보,날짜
	        pieData.addProperty("m_seq", to.getM_seq());
	        pieData.addProperty("i_day", to.getI_day().toString());
	        
	        //단탄지
	        pieData.addProperty("i_protein_g", to.getI_protein_g());
	        pieData.addProperty("i_carbohydrate_g", to.getI_carbohydrate_g());
	        pieData.addProperty("i_fat_g", to.getI_fat_g());
	        
	        //콜나당
	        pieData.addProperty("i_cholesterol_mgl", to.getI_cholesterol_mgl());
	        pieData.addProperty("i_sodium_mg", to.getI_sodium_mg());
	        pieData.addProperty("i_sugar_g", to.getI_sugar_g());
	        
	        
	        pieDatas.add(pieData); 
	    }	   	
	    
	    System.out.println(" pieData jsoned -> " + pieDatas);
	    
	    ///탄단지 콜나당 ------------------------------
	    
	    int flag_uan = dao.UnionAllNutritions(seq, day);

	   	return new ResponseEntity<String>(pieDatas.toString(), HttpStatus.OK);
	  
	}
	
	
//---BarData---------------------------------------------------
		@RequestMapping("bar_chart_data")
		public ResponseEntity<String> BarChartData(
		Authentication authentication, ModelMap map, HttpServletRequest request, String mId,
		@RequestParam("seq") int seq, @RequestParam("day") String day ) {
			
			mId = authentication.getName(); // Retrieve the m_id of the authenticated user
	        
			MemberTO member = m_dao.findByMId(mId); // Retrieve the user details based on the m_id
	        			
			///
		    ArrayList<MainTO> bars = dao.BarChartData(seq , day);
		    
		    JsonArray BarDatas = new JsonArray(); 
	
		    for (MainTO to : bars) {
		    	 JsonObject barsData = new JsonObject();
		    	//아침
		    	
		    	 barsData.addProperty("i_breakfast_kcal", to.getI_breakfast_kcal());
		    	 barsData.addProperty("i_lunch_kcal", to.getI_lunch_kcal());
		    	 barsData.addProperty("i_dinner_kcal", to.getI_dinner_kcal());
		    	
		    	//Date값 한글화, 요일 형식으로 리턴
		    	if (to.getI_day() != null) {
		    	    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy년 MM월 dd일 (E)", Locale.KOREA);
		    	    String formattedDate = dateFormat.format(to.getI_day());
		    	    
		    	    barsData.addProperty("i_day", formattedDate);
		    	  }

		        BarDatas.add(barsData); 
		    }	   	
		    
		    System.out.println("  BarDatas jsoned -> " +  BarDatas);
		    
		    ///update 달력이 선택될때마다 실행------------------------------
		    
		    int flag_upd = dao.UnionPerDay(seq, day);
		    int flag_uac = dao.UnionAllCalories(seq, day);

		    //--------------------------------------------------

		   	return new ResponseEntity<String>( BarDatas.toString(), HttpStatus.OK);
		  
		}
//---lineData----------------------------------------------------------
		
		@RequestMapping("line_chart_data")
		public ResponseEntity<String> LineChartData(
		Authentication authentication, ModelMap map, HttpServletRequest request, String mId,
		@RequestParam("seq") int seq, @RequestParam("year") String year) {
			
			mId = authentication.getName(); // Retrieve the m_id of the authenticated user
	        
			MemberTO member = m_dao.findByMId(mId); // Retrieve the user details based on the m_id

			//////////////////
		    ArrayList<MainTO> lines = dao.LineChartData(seq, year);
		    
		    System.out.println(" controller에서 year 받냐? " + year);
		    
		    JsonArray LineDatas = new JsonArray(); 
		    
		    // Set up an array to represent each month's average weight
	        double[] monthlyWeights = new double[12];
	        Arrays.fill(monthlyWeights, 0.0);

	        // Populate the array with actual data from the database
	        for (MainTO to : lines) {
	            int monthIndex = Integer.parseInt(to.getMonth().split("-")[1]) - 1;
	            monthlyWeights[monthIndex] = to.getAvg_weight();
	        }

	        // Now create JSON objects for each month, even if some months have no data
	        for(int i = 0; i < 12; i++) {
	            JsonObject LineData = new JsonObject();
	            LineData.addProperty("avg_weight", monthlyWeights[i]);
	            LineData.addProperty("month", String.format("%02d", i + 1));

	            LineDatas.add(LineData);
	        }
		    
		    System.out.println("  LineDatas 데이터들 Controller에서-> " +  LineDatas);
	
		   	return new ResponseEntity<String>( LineDatas.toString(), HttpStatus.OK);
		  
		}
		//----몸무게들-----------------------------------
		
		@ResponseBody
		@RequestMapping(value = "/weight_update", method = RequestMethod.POST)
		public int WeightUpdates(@Param("i_weight") BigDecimal i_weight,@Param("target_weight") BigDecimal target_weight,@Param("seq") int seq, @Param("dialogDate") String dialogDate) {
			int result_for_both = 0;
		    if(i_weight != null && dialogDate != null){
		        int weight_update = dao.WeightUpdate(i_weight, seq, dialogDate);
		        result_for_both += weight_update;
		    }
		    if(target_weight != null){
		        int targetw_update = dao.TargetWeightUpdate(target_weight, seq);
		        result_for_both += targetw_update;
		    }

			//System.out.println(" 컨트롤러에서 목몸 " + target_weight);
			//System.out.println(" 컨트롤러에서 목몸 seq " +  seq);
			if(result_for_both == 0) {
				System.out.println(" 몸무게 업데이트 성공 "+ result_for_both);
				return result_for_both;
			} else if(result_for_both == 1) {
				System.out.println(" 몸무게들 업데이트 실패 1이면 하나 실패 2이면 둘 다 실패 "+ result_for_both);
				return result_for_both;
			}else{
			   //2일순 없음, 입력단이 나눠져있어서 1씩 두번이 들어올순 있어도
				System.out.println(" 디폴트 "+ result_for_both);
				return result_for_both;
			}
			//극단적으로 짧은 버전
			//int weight_update = dao.WeightUpdate(i_weight, seq, dialogDate);
			//int targetw_update = dao.TargetWeightUpdate(target_weight, seq);
		    //result_for_both = weight_update + targetw_update;
		    //return result_for_both;
		}
		
//	  //해당 날짜 몸무게 업데이트----------
//		@ResponseBody
//		@RequestMapping(value = "/weight_update", method = RequestMethod.POST)
//		public int WeightUpdates(	
//		@Param("i_weight") BigDecimal i_weight,
//		@Param("seq") int seq, @Param("dialogDate") String dialogDate) {
//			int weight_update = dao.WeightUpdate(i_weight, seq, dialogDate);
//			//System.out.println(" 컨트롤러에서 목몸 seq " +  seq);
//			return weight_update;
//		}
//	  //목표 몸무게 업데이트----------
//		@ResponseBody
//		@RequestMapping(value = "/target_weight_update", method = RequestMethod.POST)
//		public int WeightUpdates(
//		@Param("target_weight") BigDecimal target_weight,
//		@Param("seq") int seq) {
//			int target_weight_flag = dao.TargetWeightUpdate(target_weight, seq);
//			return target_weight_flag;
//		}

	}
