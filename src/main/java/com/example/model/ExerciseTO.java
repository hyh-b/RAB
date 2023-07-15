package com.example.model;

import java.math.BigDecimal;

import lombok.Getter;
import lombok.Setter;
@Getter
@Setter
public class ExerciseTO {
	private String ex_seq;
	private String m_seq;
	private String ex_name;
	private int ex_time;
	private BigDecimal ex_used_kcal;
	private String ex_day;
	private Boolean ex_custom;
}
