package com.example.mappers;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import com.example.model.FoodTO;

@Mapper
public interface FoodMapperInter {

	
	@Select("select f_name, f_carbohydrate_g, f_protein_g, f_fat_g, f_cholesterol_mg, f_sodium_mg, f_sugar_g, f_kcal from FoodData where f_name like concat(#{foodName}, '%')")
	public List<FoodTO> selectFood(String foodName);
	
}
