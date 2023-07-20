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
import com.example.security.CustomUserDetailsService;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

@RestController
public class MainController {
	

	@Autowired
	private MemberDAO m_dao;
	
	@Autowired
	private MainDAO dao;

	@Autowired
    private CustomUserDetailsService customUserDetailsService;
	
	
	BCryptPasswordEncoder bcry = new BCryptPasswordEncoder();


	@RequestMapping("/test.do")
	public ModelAndView test(Authentication authentication, ModelMap map, HttpServletRequest request, String mId) {
		ModelAndView modelAndView = new ModelAndView();
		
		MypageTO mypageTO = new MypageTO();
		
		customUserDetailsService.updateUserDetails();
		
		authentication = SecurityContextHolder.getContext().getAuthentication();
		Object principal = authentication.getPrincipal();
		CustomUserDetails customUserDetails = (CustomUserDetails) principal;
		
		String m_profilename =  customUserDetails.getM_profilename();
		
		mId = authentication.getName(); // Retrieve the m_id of the authenticated user
        MemberTO member = m_dao.findByMId(mId); // Retrieve the user details based on the m_id
        
        //유저마다 총 세달의 참조 레코드 생성
        String seq = member.getM_seq();
        System.out.println(" test.do에서 파라미터로 넘기는 seq -> " + seq);
        int flag = dao.CreateRecord(seq);
        
        
        System.out.println("     dao.InsertData(mId); " + flag);
        
        System.out.println("     m_id: " + member.getM_id());
        System.out.println("     m_mail: " + member.getM_mail());

  
		modelAndView.addObject("flag", flag);
		
		modelAndView.addObject("zzinseq", member.getM_seq());
		modelAndView.addObject("zzinid", member.getM_id());		
		modelAndView.addObject("zzinnickname", member.getM_name());
		modelAndView.addObject("zzinname", member.getM_real_name());
		modelAndView.addObject("zzinmail", member.getM_mail());
		modelAndView.addObject("zzingender", member.getM_gender());
		
		modelAndView.addObject("profilename", m_profilename);
		
		//ystem.out.println(" profilename -> controller에서 " +  m_profilename);

        modelAndView.setViewName("test");
        
        System.out.println(" test.do m_id " + member.getM_id());
        
	    System.out.println(" test.do mId => " + mId);
        
        return modelAndView;
	}

	
	@RequestMapping("/main.do")
	public ModelAndView main(Authentication authentication, ModelMap map, HttpServletRequest request, String mId) {
		
		ModelAndView modelAndView = new ModelAndView();

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
        
        //유저마다 총 세달의 참조 레코드 생성
        String seq = member.getM_seq();
        System.out.println(" test.do에서 파라미터로 넘기는 seq -> " + seq);
        int flag = dao.CreateRecord(seq);
        
        System.out.println("     dao.InsertData(mId); " + flag);
        
    
        System.out.println("     m_id: " + member.getM_id());
        System.out.println("     m_mail: " + member.getM_mail());
  
        map.addAttribute("user", member);
        

		modelAndView.addObject("flag", flag);
		
		//profile사진
		customUserDetailsService.updateUserDetails();
		String m_profilename =  customUserDetails.getM_profilename();
		modelAndView.addObject("profilename", m_profilename);
		//
		
		modelAndView.addObject("zzinseq", member.getM_seq());
		modelAndView.addObject("zzinid", member.getM_id());		
		modelAndView.addObject("zzinnickname", member.getM_name());
		modelAndView.addObject("zzinname", member.getM_real_name());
		modelAndView.addObject("zzinmail", member.getM_mail());
		modelAndView.addObject("zzingender", member.getM_gender());
		
		
		
		System.out.println(" test.do m_id " + member.getM_id());
		
		modelAndView.setViewName("main");
		return modelAndView; 
	}
	
	//------jsonedDatas---------------------------------------

	@RequestMapping("selected_data")
	public ResponseEntity<String> MainForSelectedDate(
	 @RequestParam("seq") int seq, @RequestParam("day") String day ) {

	    ArrayList<MainTO> ddatas = dao.DateData(seq, day);
	    
	    System.out.println(" selected_data i_day Controller -> " + day);
	    System.out.println(" selected_data seq Controller -> " + seq );

	    JsonObject mainDatas = new JsonObject();

	    for (MainTO to : ddatas) {
	        
	        mainDatas.addProperty("m_seq", to.getM_seq());
	        mainDatas.addProperty("m_weight", to.getM_weight());
	        mainDatas.addProperty("m_target_weight", to.getM_target_weight());

	        
	        mainDatas.addProperty("i_day", to.getI_day().toString());
	        mainDatas.addProperty("i_kcal", to.getI_kcal());
	        mainDatas.addProperty("i_weight", to.getI_weight());
	        mainDatas.addProperty("i_used_kcal", to.getI_used_kcal());
	        
	        //mainDatas.addProperty("m_id", member.getM_id());

	    }	   	

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
	    
	    //System.out.println("  day pie Controller -> " + day);
	    //System.out.println("  seq pie Controller -> " + seq );
	    
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
	    
	    ///탄단지 콜나당 ------------------------------
	    
	    int flag_uan = dao.UnionAllNutritions(seq, day);

	   	return new ResponseEntity<String>(pieDatas.toString(), HttpStatus.OK);
	  
	}
	
	
//---BarData---------------------------------------------------
	
		@RequestMapping("bar_chart_data")
		public ResponseEntity<String> BarChartData(
		@RequestParam("seq") int seq, @RequestParam("day") String day ) {

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
		    
		    //System.out.println("  BarDatas jsoned -> " +  BarDatas);
		    
		    ///update 달력이 선택될때마다 실행------------------------------
		    
		    int flag_upd = dao.UnionPerDay(seq, day);
		    int flag_uac = dao.UnionAllCalories(seq, day);

		    //--------------------------------------------------

		   	return new ResponseEntity<String>( BarDatas.toString(), HttpStatus.OK);
		  
		}
//---AreaData----------------------------------------------------------

		@RequestMapping("area_chart_data")
		public ResponseEntity<String> AreaChartData(
		@RequestParam("seq") int seq, @RequestParam("day") String day) {


			ArrayList<MainTO> areas = dao.AreaChartData(seq, day);
		    
		    JsonArray lastWeekData = new JsonArray();
		    JsonArray thisWeekData = new JsonArray();

		    for (MainTO to : areas) {
		        JsonObject areaData = new JsonObject();

		        areaData.addProperty("i_used_kcal", to.getI_used_kcal());
		        areaData.addProperty("i_day", to.getI_day().toString());

		        if("저번주".equals(to.getWeek())) {
		            lastWeekData.add(areaData);
		        } else {
		            thisWeekData.add(areaData);
		        }
		    }
		    
		    //System.out.println(" lastweekData -> " + lastWeekData);
		    //System.out.println(" thisweekData -> " + thisWeekData);

		    JsonObject responseData = new JsonObject();
		    responseData.add("lastWeekData", lastWeekData);
		    responseData.add("thisWeekData", thisWeekData);
		    
		    //System.out.println("AreaDatas 데이터들 Controller에서-> " + responseData);

		    return new ResponseEntity<String>( responseData.toString(), HttpStatus.OK);
		}
//---lineData----------------------------------------------------------
		
		@RequestMapping("line_chart_data")
		public ResponseEntity<String> LineChartData(
		    @RequestParam("seq") int seq, @RequestParam("year") String year) {

		    ArrayList<MainTO> lines = dao.LineChartData(seq, year);
		    JsonArray LineDatas = new JsonArray(); 
		    double[] monthlyWeights = new double[12];
		    Arrays.fill(monthlyWeights, 0.0);

		    for (MainTO to : lines) {
		        int monthIndex = Integer.parseInt(to.getMonth().split("-")[1]) - 1;
		        //System.out.println("\n 한 달 총합 무게 (0/undefined 제외) -> " + (monthIndex + 1) + " : " + to.getTotal_weight());
		        //System.out.println(" (0/undefined 제외)제외하고 데이터가 입력된 날의 수 -> " + (monthIndex + 1) + " : " + to.getDayCount());

		        if (to.getDayCount() > 0) {  // 이 부분을 추가했습니다.
		            monthlyWeights[monthIndex] = to.getTotal_weight() / to.getDayCount();
		        } else {
		            monthlyWeights[monthIndex] = 0.0;
		        }
		        
		        //System.out.println( " 한달 평균 무게 -> " + monthIndex + " : " + monthlyWeights[monthIndex] + "\n");
		    }

		    for(int i = 0; i < 12; i++) {
		        JsonObject LineData = new JsonObject();
		        LineData.addProperty("avg_weight", monthlyWeights[i]);
		        LineData.addProperty("month", String.format("%02d", i + 1));
		        LineDatas.add(LineData);
		    }

		    System.out.println( " LineDatas -> " + LineDatas);
		    return new ResponseEntity<String>( LineDatas.toString(), HttpStatus.OK);
		}
		//----몸무게들-----------------------------------
		
		//두개의 다른 다이얼로그에서 하나의 endpoing를 공유함으로써, 물리적으로 동작은 무조건 따로 하므로, 에러 발생은 차단하고 속도는 높이고
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
				//System.out.println(" 몸무게 업데이트 성공 "+ result_for_both);
				return result_for_both;
			} else if(result_for_both == 1) {
				//System.out.println(" 몸무게들 업데이트 실패 1이면 하나 실패 2이면 둘 다 실패 "+ result_for_both);
				return result_for_both;
			}else{
			   //2일순 없음, 입력단이 나눠져있어서 1씩 두번이 들어올순 있어도
				//System.out.println(" 디폴트 "+ result_for_both);
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
		
//------피드백------------------------
		
//		@RequestMapping("/feedback.do")
//		public ModelAndView feedback() {
//			ModelAndView modelAndView = new ModelAndView();
//			modelAndView.setViewName("feedback");
//			return modelAndView;
//		}
		
		  //피드백----------
			@ResponseBody
			@RequestMapping(value = "/feedback_ok", method = RequestMethod.POST)
			public int FeedBackOk(
			@RequestParam("seq") int seq, @RequestParam("f_id") String f_id, @RequestParam("f_name") String f_name,
			@RequestParam("f_mail") String f_mail, @RequestParam("f_subject") String f_subject, @RequestParam("f_content") String f_content) {
				
				int feedback_flag = dao.FeedbackReceived(seq, f_id, f_name, f_mail, f_subject, f_content);
				
				System.out.println( " feedback controller-> " + seq + " " +f_id + " " + f_name + " " + f_mail + " " + f_subject + " " + f_content);
				return feedback_flag;
			}

	}
