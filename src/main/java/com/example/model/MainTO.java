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

   private BigDecimal  i_weight ; 
   
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
   
   //Breakfast
   private int b_seq;
   private BigDecimal b_kcal;
   private Date b_day;
   
   private String b_name;
   private BigDecimal b_carbohydrate_g;
   private BigDecimal b_protein_g;
   private BigDecimal b_fat_g;
   private BigDecimal b_sugar_g;
   private BigDecimal b_cholesterol_mg;
   private BigDecimal b_sodium_mg;
   private BigDecimal b_trans_fat_g;
  
   //lunch
   private int l_seq;
   private BigDecimal l_kcal;
   private Date l_day;
   
   private String l_name;
   private BigDecimal l_carbohydrate_g;
   private BigDecimal l_protein_g;
   private BigDecimal l_fat_g;
   private BigDecimal l_sugar_g;
   private BigDecimal l_cholesterol_mg;
   private BigDecimal l_sodium_mg;
   private BigDecimal l_trans_fat_g;
   
   //Dinner
   private int d_seq;
   private BigDecimal d_kcal;
   private Date d_day;
   
   private String d_name;
   private BigDecimal d_carbohydrate_g;
   private BigDecimal d_protein_g;
   private BigDecimal d_fat_g;
   private BigDecimal d_sugar_g;
   private BigDecimal d_cholesterol_mg;
   private BigDecimal d_sodium_mg;
   private BigDecimal d_trans_fat_g;
   
   //합연산된 칼럼 아 점 저
   
   private BigDecimal i_breakfast_kcal;
   private BigDecimal i_lunch_kcal;
   private BigDecimal i_dinner_kcal;

   // 월 별 몸무게 평균값 구하는 칼럼
  // private BigDecimal avg_weight;
   private Double avg_weight;
   private String month;
   
   private String week;

}
