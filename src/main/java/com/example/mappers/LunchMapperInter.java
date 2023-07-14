package com.example.mappers;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;

import com.example.model.LunchTO;

@Mapper
public interface LunchMapperInter {
	
	@Insert(" insert into Lunch values( 0,#{m_seq},#{l_kcal}, #{l_day}, #{l_carbohydrate_g} , #{l_protein_g} , #{l_fat_g} , #{l_sugar_g} , #{l_cholesterol_mg} , #{l_sodium_mg} ,#{l_name} ) ")
	public int insertLunchData(LunchTO to);
	
}
