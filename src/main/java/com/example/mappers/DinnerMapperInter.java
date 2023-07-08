package com.example.mappers;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;

import com.example.model.DinnerTO;

@Mapper
public interface DinnerMapperInter {

	@Insert(" insert into Dinner values( 0,#{m_seq},#{d_kcal}, curdate(), #{d_carbohydrate_g} , #{d_protein_g} , #{d_fat_g} , #{d_sugar_g} , #{d_cholesterol_mg} , #{d_sodium_mg} ,#{d_name} ) ")
	public int insertDinnerData(DinnerTO to);
	
}
