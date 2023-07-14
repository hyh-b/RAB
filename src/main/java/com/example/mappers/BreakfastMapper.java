package com.example.mappers;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;

import com.example.model.BreakfastTO;

@Mapper
public interface BreakfastMapper {

	@Insert(" insert into Breakfast values( 0,#{m_seq},#{b_kcal} , #{b_day}, #{b_carbohydrate_g} , #{b_protein_g} , #{b_fat_g} , #{b_sugar_g} , #{b_cholesterol_mg} , #{b_sodium_mg},#{b_name} )  ")
	public int insertBreakfast(BreakfastTO to);
	
}
