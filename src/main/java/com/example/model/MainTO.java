package com.example.model;

import java.math.BigDecimal;
import java.sql.Date;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MainTO {
	
	//IntakeData, Member
	
   private int i_seq  ;           
   
   private int m_seq;
   
   private String  i_kcal ;   
   
   private String i_carbohydrate_g;
   
   private String i_protein_g;
   
   private String i_fat_g ;
   
   private String i_sugar_g  ;
   
   private String  i_cholesterol_mgl;
   
   private String i_sodium_mg;
   
   private String i_trans_fat_g ;
   
   private Date i_day;
   
   private int mSeq;
   
   private String mId;
   
   private String mPw;
   
   private String mName;
   
   private String mGender;
   
   private BigDecimal mWeight;
   
   private BigDecimal mHeight;
   
   private String mMail;
   
   private boolean mIsKakao;
   
   private String mRole;
   
   private String mTel;
   
   private String mFilename;
   
   private int mFilesize;
   
   private Date mJoinDate;
   
   private int mTargetCalorie;
   
   private BigDecimal mTargetWeight;



}
