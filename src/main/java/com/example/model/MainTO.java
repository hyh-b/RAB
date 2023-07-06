package com.example.model;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Time;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MainTO {
	

	//IntakeData, Member

	
   private int i_seq  ;           
   
   private int m_seq;
   
   private BigDecimal  i_kcal ;   
   
   private BigDecimal i_carbohydrate_g;
   
   private BigDecimal i_protein_g;
   
   private BigDecimal i_fat_g ;
   
   private BigDecimal i_sugar_g  ;
   
   private BigDecimal  i_cholesterol_mgl;
   
   private BigDecimal i_sodium_mg;
   
   private BigDecimal i_trans_fat_g ;
   
   private Date i_day;
   
   private BigDecimal i_used_kcal;
   
   
   // Member ----------------------------
   
   //private int m_seq;
   
   private String m_id;
   
   private String m_pw;
   
   private String m_name;
   
   private String m_gender;
   
   private BigDecimal m_weight;
   
   private BigDecimal m_height;
   
   private String m_mail;
   
   private boolean m_iskakao;
   
   private String m_role;
   
   private String m_tel;
   
   private String m_filename;
   
   private int m_filesize;
   
   private Date m_join_date;
   
   private int m_target_calorie;
   
   private BigDecimal m_target_weight;
   
   // 아점저 Meals ----------------------------
   
   private int d_seq;
   private int e_seq;
   
   private BigDecimal d_kcal;
   private Date d_day;
   
   private int b_seq;
   private BigDecimal b_kcal;
   private Date b_day;
   
   private int l_seq;
   private BigDecimal l_kcal;
   private Date l_day;
   
   // hdata 필요없음

   private int h_seq;
   private Date h_wdate;
   private BigDecimal h_body_fat; 
   private BigDecimal h_muscle;
   private Time h_exerciseDuration;
   private int h_kcal;
   private int h_heart_rate;      
   private Time h_sleep_duration;  
   private int h_step_count;

}
