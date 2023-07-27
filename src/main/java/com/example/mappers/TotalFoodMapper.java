package com.example.mappers;

import java.util.Date;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Update;

@Mapper
public interface TotalFoodMapper {

	
	@Update("UPDATE IntakeData SET i_breakfast_kcal = (SELECT COALESCE(SUM(b_kcal), 0) FROM Breakfast WHERE Breakfast.b_day = #{day} AND Breakfast.m_seq = #{seq}), i_lunch_kcal = (SELECT COALESCE(SUM(l_kcal), 0) FROM Lunch WHERE Lunch.l_day = #{day} AND Lunch.m_seq = #{seq}), i_dinner_kcal = (SELECT COALESCE(SUM(d_kcal), 0) FROM Dinner WHERE Dinner.d_day = #{day} AND Dinner.m_seq = #{seq}) WHERE m_seq = #{seq} AND i_day = #{day};")
    public int UnionBLDperDay(@Param("seq") int seq, @Param("day") Date day);
    
    //연산결과 3개를 합쳐서 i_kcal에 할당하는거 하나, main페이지에서  때마다 실행, 추가된 값이 없다면 update만 안되고 나머지는 정상 작동
    @Update("UPDATE IntakeData SET i_kcal = COALESCE(i_breakfast_kcal, 0) + COALESCE(i_lunch_kcal, 0) + COALESCE(i_dinner_kcal, 0) WHERE m_seq = #{seq} AND i_day = #{day};")
    public int UnionAllCalories(@Param("seq") int seq, @Param("day") Date day);
    
    //---탄단지콜나당 통합---------------------------------
    @Update("UPDATE IntakeData SET i_carbohydrate_g = (SELECT COALESCE(SUM(b_carbohydrate_g), 0) FROM Breakfast WHERE Breakfast.b_day = #{day} AND Breakfast.m_seq = #{seq}) + (SELECT COALESCE(SUM(l_carbohydrate_g), 0) FROM Lunch WHERE Lunch.l_day = #{day} AND Lunch.m_seq = #{seq}) + (SELECT COALESCE(SUM(d_carbohydrate_g), 0) FROM Dinner WHERE Dinner.d_day = #{day} AND Dinner.m_seq = #{seq}),i_protein_g = (SELECT COALESCE(SUM(b_protein_g), 0) FROM Breakfast WHERE Breakfast.b_day = #{day} AND Breakfast.m_seq = #{seq}) + (SELECT COALESCE(SUM(l_protein_g), 0) FROM Lunch WHERE Lunch.l_day = #{day} AND Lunch.m_seq = #{seq}) + (SELECT COALESCE(SUM(d_protein_g), 0) FROM Dinner WHERE Dinner.d_day = #{day} AND Dinner.m_seq = #{seq}),i_fat_g = (SELECT COALESCE(SUM(b_fat_g), 0) FROM Breakfast WHERE Breakfast.b_day = #{day} AND Breakfast.m_seq = #{seq}) + (SELECT COALESCE(SUM(l_fat_g), 0) FROM Lunch WHERE Lunch.l_day = #{day} AND Lunch.m_seq = #{seq}) + (SELECT COALESCE(SUM(d_fat_g), 0) FROM Dinner WHERE Dinner.d_day = #{day} AND Dinner.m_seq = #{seq}),i_cholesterol_mgl = (SELECT COALESCE(SUM(b_cholesterol_mg), 0) FROM Breakfast WHERE Breakfast.b_day = #{day} AND Breakfast.m_seq = #{seq}) + (SELECT COALESCE(SUM(l_cholesterol_mg), 0) FROM Lunch WHERE Lunch.l_day = #{day} AND Lunch.m_seq = #{seq}) + (SELECT COALESCE(SUM(d_cholesterol_mg), 0) FROM Dinner WHERE Dinner.d_day = #{day} AND Dinner.m_seq = #{seq}), i_sodium_mg = (SELECT COALESCE(SUM(b_sodium_mg), 0) FROM Breakfast WHERE Breakfast.b_day = #{day} AND Breakfast.m_seq = #{seq}) + (SELECT COALESCE(SUM(l_sodium_mg), 0) FROM Lunch WHERE Lunch.l_day = #{day} AND Lunch.m_seq = #{seq}) + (SELECT COALESCE(SUM(d_sodium_mg), 0) FROM Dinner WHERE Dinner.d_day = #{day} AND Dinner.m_seq = #{seq}),i_sugar_g = (SELECT COALESCE(SUM(b_sugar_g), 0) FROM Breakfast WHERE Breakfast.b_day = #{day} AND Breakfast.m_seq = #{seq}) + (SELECT COALESCE(SUM(l_sugar_g), 0) FROM Lunch WHERE Lunch.l_day = #{day} AND Lunch.m_seq = #{seq}) + (SELECT COALESCE(SUM(d_sugar_g), 0) FROM Dinner WHERE Dinner.d_day = #{day} AND Dinner.m_seq = #{seq}) WHERE m_seq = #{seq} AND i_day = #{day};")
    public int UnionAllNutritions(@Param("seq") int seq, @Param("day") Date day);
	
}
