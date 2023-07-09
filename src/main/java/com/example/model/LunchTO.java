package com.example.model;

import java.math.BigDecimal;
import java.util.Date;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class LunchTO {
	private int l_seq;
	private int m_seq;
	private String l_name;
	private BigDecimal l_kcal;
	private Date l_day;
	private BigDecimal l_carbohydrate_g;
	private BigDecimal l_protein_g;
	private BigDecimal l_fat_g;
	private BigDecimal l_sugar_g;
	private BigDecimal l_cholesterol_mg;
	private BigDecimal l_sodium_mg;
}
