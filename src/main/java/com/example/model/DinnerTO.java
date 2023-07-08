package com.example.model;

import java.math.BigDecimal;
import java.util.Date;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class DinnerTO {
	private int d_seq;
	private int m_seq;
	private String d_name;
	private BigDecimal d_kcal;
	private Date d_day;
	private BigDecimal d_carbohydrate_g;
	private BigDecimal d_protein_g;
	private BigDecimal d_fat_g;
	private BigDecimal d_sugar_g;
	private BigDecimal d_cholesterol_mg;
	private BigDecimal d_sodium_mg;
}
