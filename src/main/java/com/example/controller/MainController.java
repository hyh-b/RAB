package com.example.controller;

import java.awt.PageAttributes.MediaType;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

import org.apache.ibatis.annotations.Param;
import org.eclipse.jdt.internal.compiler.batch.Main;
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
        System.out.println(" test.do에서 파라미터로 넘기는 String seq -> " + seq);
        int flag = dao.CreateRecord(seq);
        
        //다른페이지 갔다가 메인 넘어올때 합연산 시키기 (쿼리 안겹치고 잘 실행되는데 
        // 날짜는 무조건 오늘치만 비동기로 들어가고, 날짜를 선택후 다시 메인으로 가서 그 날로 가면 안되고 새로고침을 하고 그날로 가야 그 날의 데이터가 보임
        // food.do에서 메인페이지 로고를 누르거나 뒤로가기를 누르면 reload가 되게 하면 쿼리도 필요없이 해결되겠지만 모든함수들이 전부 실행되는건 너무 손해
        // 최선책은 food.do에 있는 달력을 따로 파라미터로 받아서 그걸 받는 end point에 아래쿼리를 실행 시키면 될듯 (중간에 거치는 가상 경로가 필요).)
        int main_flag_a = dao.MainUnionPerDay(seq);
		int main_flag_b = dao.MainUnionAllCalories(seq);
		int main_flag_c = dao.MainUnionAllNutritions(seq);
        //-테스트 끝-

        
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
        
        //회원가입 하자마자 유저마다 앞뒤 한달씩 총 세달의 참조 레코드 생성
        String seq = member.getM_seq();
        System.out.println(" main.do에서 파라미터로 넘기는 seq -> " + seq);
        int flag = dao.CreateRecord(seq);

        //다른페이지 갔다가 메인 넘어올때 합연산 시키기 (쿼리 안겹치고 잘 실행되는데 
        // 날짜는 무조건 오늘치만 비동기로 들어가고, 날짜를 선택후 다시 메인으로 가서 그 날로 가면 안되고 새로고침을 하고 그날로 가야 그 날의 데이터가 보임
        // food.do에서 메인페이지 로고를 누르거나 뒤로가기를 누르면 reload가 되게 하면 쿼리도 필요없이 해결되겠지만 모든함수들이 전부 실행되는건 너무 손해
        // 최선책은 food.do에 있는 달력을 따로 파라미터로 받아서 그걸 받는 end point에 아래쿼리를 실행 시키면 될듯 (중간에 거치는 가상 경로가 필요).)
        int main_flag_a = dao.MainUnionPerDay(seq);
		int main_flag_b = dao.MainUnionAllCalories(seq);
		int main_flag_c = dao.MainUnionAllNutritions(seq);
        //-테스트 끝-
        
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
	    //System.out.println("  day pie Controller -> " + day);
	    //System.out.println("  seq pie Controller -> " + seq );
	    
	    
	    JsonArray pieDatas = new JsonArray(); 
	    
	
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
	    
	    System.out.println( "\n 콜나당이 왜이래 이거-> " + pieDatas + "\n");
	    
	    ///탄단지 콜나당 합연산 ------------------------------
	    
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
		
		//데이터 형식
		@RequestMapping("feedback_list")
		public ResponseEntity<String> FeedbackList(@RequestParam Integer page) {

		    JsonArray feedback_datas = new JsonArray(); 
		    
		    
		    System.out.println( " page 수 -> " + page);
		    int pageSize = 10;  // 한 페이지에 보여줄 데이터의 개수
	        int offset = page * pageSize;  // 가져올 데이터의 시작 위치
		    
		    ArrayList<MainTO> lists = dao.ListOfFeedback(pageSize, offset);
		    
			
		    for (MainTO to : lists) {
		    	
	    	 JsonObject feedback_data = new JsonObject();
		        
	    	//
	    	 feedback_data.addProperty("f_seq", to.getF_seq());
	    	 feedback_data.addProperty("f_id", to.getF_id());
	    	 feedback_data.addProperty("f_name", to.getF_name());
	    	 feedback_data.addProperty("f_mail", to.getF_mail() );
	    	 
	    	 String subject = to.getF_subject();
	    	 if (subject.length() > 10) {
	    		 	subject = subject.substring(0, 10) + "...";
	    		}
	    	 feedback_data.addProperty("f_subject", subject);
	    	
	    	 String content = to.getF_content();
	    	  if (content.length() > 15) {
	    		    content = content.substring(0, 15) + "...";
	    		}
	    	 feedback_data.addProperty("f_content",  content);
	    	  
	    	 
	    	  
	    	 SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	    	 feedback_data.addProperty("f_day", sdf.format(to.getF_day()));
	    	 
	    	 feedback_data.addProperty("m_seq", to.getM_seq());
		        
		        
	    	 feedback_datas.add(feedback_data); 
		    }	   	
		    
		    System.out.println( "\n 피드백 ajax 시작-> " + feedback_datas + "\n");

		    return new ResponseEntity<String>( feedback_datas.toString(), HttpStatus.OK);
		}
		
	  //--------피드백----------------------------
		
		
		@RequestMapping("/feedback.do")
		public ModelAndView feedback() {
			
			ModelAndView modelAndView = new ModelAndView();
		
			
			modelAndView.setViewName("feedback");
			return modelAndView;
		}
		

		@RequestMapping("/feedback_view.do")
		public ModelAndView feedback_test() {
			
			ModelAndView modelAndView = new ModelAndView();
		
			
			modelAndView.setViewName("feedback_view");
			return modelAndView;
		}
				
			 //--------feedback_board.do 끝----------------------------
				
			@ResponseBody
			@RequestMapping(value = "/feedback_ok", method = RequestMethod.POST)
			public int FeedBackOk(
			@RequestParam("seq") int seq, @RequestParam("f_id") String f_id, @RequestParam("f_name") String f_name,
			@RequestParam("f_mail") String f_mail, @RequestParam("f_subject") String f_subject, @RequestParam("f_content") String f_content) {
				
				int feedback_flag = dao.FeedbackReceived(seq, f_id, f_name, f_mail, f_subject, f_content);
				
				System.out.println( " feedback controller-> " + seq + " " +f_id + " " + f_name + " " + f_mail + " " + f_subject + " " + f_content);
				return feedback_flag;
			}
			
	 //---feedback.do 검색
			@RequestMapping("feedback_search")
			public ResponseEntity<String> FeedbackSerch(@RequestParam String searchKey, @RequestParam String searchWord) {

			    JsonArray feedback_datas = new JsonArray(); 
			    
			    ArrayList<MainTO> searchingMethod = dao.SearchingFeedback(searchKey, searchWord);
			    	
			    searchWord = "%" + searchWord + "%";
			    
			    System.out.println( " searchKey -> " + searchKey);
			    System.out.println( " searchWord -> " + searchWord);
	
			    for (MainTO to : searchingMethod) {
				    	
				    	 JsonObject feedback_data = new JsonObject();
					        
				    	//
				    	 feedback_data.addProperty("f_seq", to.getF_seq());
				    	 feedback_data.addProperty("f_id", to.getF_id());
				    	 feedback_data.addProperty("f_name", to.getF_name());
				    	 feedback_data.addProperty("f_mail", to.getF_mail() );
				    	 
				    	 String subject = to.getF_subject();
				    	 if (subject.length() > 10) {
				    		 	subject = subject.substring(0, 10) + "...";
				    		}
				    	 feedback_data.addProperty("f_subject", subject);
				    	
				    	 String content = to.getF_content();
				    	  if (content.length() > 15) {
				    		    content = content.substring(0, 15) + "...";
				    		}
				    	 feedback_data.addProperty("f_content",  content);
				    	  
				    	 
				    	  
				    	 SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				    	 feedback_data.addProperty("f_day", sdf.format(to.getF_day()));
				    	 
				    	 feedback_data.addProperty("m_seq", to.getM_seq());
					        
					        
				    	 feedback_datas.add(feedback_data); 
					    }	   	
				    
				    System.out.println( "\n 검색 시작-> " + feedback_datas + "\n");
					    
		

			    return new ResponseEntity<String>( feedback_datas.toString(), HttpStatus.OK);
			}
			
	//------
	
			
	 //--------피드백 끝 ----------------------------
	}
