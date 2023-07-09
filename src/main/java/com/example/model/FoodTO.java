package com.example.model;

import java.math.BigDecimal;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class FoodTO {
	private int f_seq;
	private String f_name;
	private int f_weight;
	private int f_kal;
	private BigDecimal f_carbohydrate_g;
	private BigDecimal f_sugar_g;
	private BigDecimal f_fat_g;
	private BigDecimal f_protein_g;
	private int f_calcium_g;
	private int f_phosphorus_mg;
	private int f_sodium_mg;
	private int f_potassium_mg;
	private int f_magnesium_mg;
	private BigDecimal f_iron_mg;
	private BigDecimal f_zinc_mg;
	private int f_cholesterol_mg;
	private BigDecimal f_trans_fat_g;
}
