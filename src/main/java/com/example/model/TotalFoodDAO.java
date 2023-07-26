package com.example.model;

import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.mappers.TotalFoodMapper;

@Repository
public class TotalFoodDAO {

	
	@Autowired
	TotalFoodMapper mapper;
	
	
	//---아 점 저 합연산--------------------------
	
			public int UnionPerDay(int seq, Date day) {
				
				int flag_upd = 1;
				
				int result = mapper.UnionBLDperDay(seq, day);
				
				//System.out.println("  union dao 에서 seq -> " + seq );
				
				if(result == 1 ) {
					
					flag_upd = 0;
					
				}else if(result == 0) {
					
					flag_upd = 1;
				}
			
				//System.out.println( " flag_upd ->" + flag_upd);
				
				return flag_upd;
						
			}
			
			//---아 점 저 합연산 3개를 1개의 i_kcal로 총합연산--------------------------
			
			public int UnionAllCalories(int seq, Date day) {
				
				int flag_uac = 1;
				
				int result = mapper.UnionAllCalories(seq, day);
				
				//System.out.println("  union dao2 에서 seq -> " + seq );
				
				if(result == 1 ) {
					flag_uac = 0;
				}else if(result == 0) {
					flag_uac = 1;
				}
				
				//System.out.println( " flag_uac ->" + flag_uac);
			
				return flag_uac;
						
			}
			
			//---탄단지 콜나당 하루치 총합--------------------------
			
			public int 	UnionAllNutritions(int seq, Date day) {
				
				int flag_uan = 1;
				
				int result = mapper.UnionAllNutritions(seq, day);
				
				if(result == 1 ) {
					flag_uan = 0;
				}else if(result == 0) {
					flag_uan= 1;
				}
				
				//System.out.println( " 탄단지 콜나당 flag isZero = " + flag_uan);
			
				return flag_uan;
						
			}
}
