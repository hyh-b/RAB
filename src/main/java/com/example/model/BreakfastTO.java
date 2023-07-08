package com.example.model;

import java.math.BigDecimal;
import java.util.Date;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class BreakfastTO {
	
	private int b_seq;
	private int m_seq;
	private String b_name;
	private BigDecimal b_kcal;
	private Date b_day;
	private BigDecimal b_carbohydrate_g;
	private BigDecimal b_protein_g;
	private BigDecimal b_fat_g;
	private BigDecimal b_sugar_g;
	private BigDecimal b_cholesterol_mg;
	private BigDecimal b_sodium_mg;
	
}
