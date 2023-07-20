package com.example.model;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Repository;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.mappers.MainMapperInter;
import com.example.mappers.MemberMapperInter;

@Repository
@MapperScan("com.example.mappers")
public class MainDAO {
		
	@Autowired
	private MainMapperInter mapper;
	
	
//-------------------------------------------------------------------------
	
	public ArrayList<MainTO> DateData(int seq, String day ) {

		List<MainTO> datas = (List<MainTO>)mapper.DataFromDateForMain(seq, day);
		
		//System.out.println(" i_day DAO -> " + day);
		//System.out.println("  m_id DAO -> " + seq );

		
	    ArrayList<MainTO> ddatas = new ArrayList<>(datas);
	    
	    return ddatas;
	}
		
	
//----------------------Charts below------------------------------------------------------
		
		
//-----------pie---------------
		public ArrayList<MainTO> PieChartData(int seq, String day) {

			List<MainTO> pie = (List<MainTO>)mapper.PieChartData(seq, day);
		
			ArrayList<MainTO> pies = new ArrayList<>(pie);
	    
	    	return pies;
		}
		
//-----------bar---------------
		
		public ArrayList<MainTO> BarChartData(int seq, String day) {

			List<MainTO> bar = (List<MainTO>)mapper.BarChartData(seq, day);
		
			ArrayList<MainTO> bars = new ArrayList<>(bar);
	    
	    	return bars;
		}
//-----------Area---------------

		public ArrayList<MainTO> AreaChartData(int seq, String day) {

			List<MainTO> area = (List<MainTO>)mapper.AreaChartData(seq, day);
		
			ArrayList<MainTO> areas = new ArrayList<>(area);
			
			//System.out.println(" dao 에서 가져온 년도마다의 데이터 -> " + lines);
	    
	    	return areas;
		}
		
//-----------line---------------
		
		public ArrayList<MainTO> LineChartData(int seq, String year) {

			List<MainTO> line = (List<MainTO>)mapper.LineChartData(seq, year);
		
			ArrayList<MainTO> lines = new ArrayList<>(line);
			
			//System.out.println(" dao 에서 가져온 년도마다의 데이터 -> " + lines);
	    
	    	return lines;
		}
		
//----------besides select --------------------------
		
	//---아이디당 1개의 레코드 중복없이 생성-------------------------------------------------------------------------
		
		public int CreateRecord(String seq) {
			
			int flag = 1;
			
			int result = mapper.CreateThreeMonthRecord(seq);
			
			if(result == 1 ) {
				flag = 0;
			}else if(result == 0) {
				flag = 1;
			}
		
			return flag;
					
		}
	
		//---아 점 저 합연산--------------------------
		
		public int UnionPerDay(int seq, String day) {
			
			int flag_upd = 1;
			
			int result = mapper.UnionBLDperDay(seq, day);
			
			System.out.println("  union dao 에서 seq -> " + seq );
			
			if(result == 1 ) {
				
				flag_upd = 0;
				
			}else if(result == 0) {
				
				flag_upd = 1;
			}
		
			System.out.println( " flag_upd ->" + flag_upd);
			
			return flag_upd;
					
		}
		
		//---아 점 저 합연산 3개를 1개의 i_kcal로 총합연산--------------------------
		
		public int UnionAllCalories(int seq, String day) {
			
			int flag_uac = 1;
			
			int result = mapper.UnionAllCalories(seq, day);
			
			System.out.println("  union dao2 에서 seq -> " + seq );
			
			if(result == 1 ) {
				flag_uac = 0;
			}else if(result == 0) {
				flag_uac = 1;
			}
			
			System.out.println( " flag_uac ->" + flag_uac);
		
			return flag_uac;
					
		}
		
		//---탄단지 콜나당 하루치 총합--------------------------
		
		public int 	UnionAllNutritions(int seq, String day) {
			
			int flag_uan = 1;
			
			int result = mapper.UnionAllNutritions(seq, day);
			
			if(result == 1 ) {
				flag_uan = 0;
			}else if(result == 0) {
				flag_uan= 1;
			}
			
			System.out.println( " 탄단지 콜나당 flag isZero = " + flag_uan);
		
			return flag_uan;
					
		}
		
		//---몸무게들 업데이트--------------------------
		
		public int WeightUpdate(BigDecimal i_weight, int seq, String dialogDate) {
			
			int WeightUpdateFlag = 1;
			
			int result = mapper.WeightUpdate(i_weight, seq, dialogDate);
			
			if(result == 1 ) {
				WeightUpdateFlag = 0;
				System.out.println( " 그 날짜의 몸무게 업데이트 완료 , " + WeightUpdateFlag);
			}else if(result == 0) {
				WeightUpdateFlag = 1;
				System.out.println( " 몸무게 날짜 업데이트 실패 , " + WeightUpdateFlag);
			}

			return WeightUpdateFlag;
		}
		
		//--목표 몸무게------------------
		public int TargetWeightUpdate(BigDecimal target_weight, int seq) {
			
			int TargetWeightUpdateFlag = 1;
			
			int result = mapper.TargetWeightUpdate(target_weight, seq);
			
			if(result == 1 ) {
				TargetWeightUpdateFlag = 0;
				System.out.println( " 목표 몸무게 업데이트 완료 , " + TargetWeightUpdateFlag);
			}else if(result == 0) {
				TargetWeightUpdateFlag = 1;
				System.out.println( " 목표 몸무게 날짜 업데이트 실패 , " + TargetWeightUpdateFlag);
			}

			return TargetWeightUpdateFlag;
		}
		
		//---피드백---------------------
		
		//피드백 입력
		public int FeedbackReceived(int seq, String f_id, String f_name, String f_mail, String f_subject, String f_content) {
			int feedbackFlag = 1;
			
			int result = mapper.FeedbackReceived(seq, f_id, f_name, f_mail, f_subject, f_content);
			
			if(result == 1 ) {
				feedbackFlag = 0;
				System.out.println( " feedbackFlag 완료 , " + feedbackFlag);
			}else if(result == 0) {
				feedbackFlag = 1;
				System.out.println( " feedbackFlag 실패 , " + feedbackFlag);
			}
			
			return feedbackFlag;
		}
		
		
}

