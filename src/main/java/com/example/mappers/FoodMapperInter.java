package com.example.mappers;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface FoodMapperInter {

	
	@Select("  select f_name , f_carbohydrate_g , f_protein_g , f_fat_g , f_cholesterol_mg , f_sodium_mg , f_sugar_g , f_kcal from FoodData where f_name =#{foodName}")
	public Map<String, Object> selectFood(String foodName);
	
	
	
}
