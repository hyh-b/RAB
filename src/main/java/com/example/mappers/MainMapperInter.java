package com.example.mappers;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.model.BreakfastTO;
import com.example.model.MainTO;


@Mapper
public interface MainMapperInter {
	
//---테스트용 디폴트 데이터들/ 마지막에 다 지우기-----------------------------------------------------------
   @Select("SELECT m.*, i.i_kcal, i.i_weight, i.i_day, i.i_used_kcal FROM Member m INNER JOIN IntakeData i ON m.m_seq = i.m_seq WHERE m.m_id = #{mId} and i.i_day= curdate();")
   public List<MainTO> DefaultDataForMain(String mId);
   
   //Default음식 칼로리, 영양분 for charts
   @Select("SELECT * FROM Breakfast WHERE b_day = '2023-07-08' AND m_seq = 30 UNION ALL SELECT * FROM Lunch WHERE l_day = '2023-07-08' AND m_seq = 30 UNION ALL SELECT * FROM Dinner WHERE d_day = '2023-07-08' AND m_seq = 30;")
   public List<MainTO> FoodData();
	
//-------달력값기준으로 4elements에 쿼리 전달
	@Select("SELECT m.*, i.i_kcal, i.i_weight, i.i_day, i.i_used_kcal FROM Member m INNER JOIN IntakeData i ON m.m_seq = i.m_seq WHERE m.m_seq = #{seq} and i.i_day= #{day};")
	public List<MainTO> DataFromDateForMain(@Param("seq") int seq, @Param("day") String day);

//---------로그인과 동시에 참조레코드가 없다면 m_seq를 들어가서  중복없는 참조 레코드를 만듬
    @Insert("INSERT INTO IntakeData (m_seq) SELECT m.m_seq FROM Member m LEFT JOIN IntakeData i ON m.m_seq = i.m_seq WHERE i.m_seq IS NULL AND m.m_id = #{mId} LIMIT 1;")
    public int InsertDataForMain(String mId);

    
//------------Charts-------------------------------------------------------------------------
    
    //pie Chart( 합연산 된 칼럼을 가져와서 뿌려줌 , 하루에 먹은 모든 음식의 탄단지가 파이로 그려짐)
    @Select("select * from IntakeData where m_seq= #{seq} and i_day =#{day};")
    public List<MainTO> PieChartData(@Param("seq") int seq, @Param("day") String day);

    //bar Chart (선택된 날짜 기준 +-3일씩 가져와서 일주일치 데이터를 가져옴)
    @Select("SELECT * FROM IntakeData WHERE m_seq = #{seq} AND i_day BETWEEN DATE_SUB(#{day}, INTERVAL 3 DAY) AND DATE_ADD(#{day}, INTERVAL 3 DAY);")
    public List<MainTO> BarChartData(@Param("seq") int seq, @Param("day") String day);
    
    //area Chart (저번 주 , 이번 주 한번에 가져오기)
    @Select("SELECT i_used_kcal, i_day, '이번주' as week FROM IntakeData WHERE m_seq=#{seq} AND YEARWEEK(i_day) = YEARWEEK(#{day}) UNION ALL SELECT i_used_kcal, i_day, '저번주' as week FROM IntakeData WHERE m_seq=#{seq} AND YEARWEEK(i_day) = YEARWEEK(DATE_SUB(#{day}, INTERVAL 1 WEEK)) ORDER BY i_day;")
    public List<MainTO> AreaChartData(@Param("seq") int seq, @Param("day") String day);

    //line Chart
    @Select("SELECT ROUND(AVG(i_weight), 2) as avg_weight, DATE_FORMAT(i_day, '%Y-%m') as month FROM IntakeData WHERE m_seq=#{seq} AND DATE_FORMAT(i_day, '%Y') = #{year} GROUP BY month ORDER BY month;")
    public List<MainTO> LineChartData(@Param("seq") int seq, @Param("year") String year);

//---update문  아 점 저 -> i_kcal 총 칼로리 ---------------------------------
    
    //각 날짜마다 아점저 칼로리 합연산 이후 합쳐진 결과를 합산하는 거 하나 날짜가 선택될때마다 합연산 자동으로 처리
    @Update("UPDATE IntakeData SET i_breakfast_kcal = (SELECT COALESCE(SUM(b_kcal), 0) FROM Breakfast WHERE Breakfast.b_day = #{day}), i_lunch_kcal = (SELECT COALESCE(SUM(l_kcal), 0) FROM Lunch WHERE Lunch.l_day = #{day}), i_dinner_kcal = (SELECT COALESCE(SUM(d_kcal), 0) FROM Dinner WHERE Dinner.d_day = #{day}) WHERE m_seq = #{seq} AND i_day = #{day};")
    public int UnionBLDperDay(@Param("seq") int seq, @Param("day") String day);
    
    //연산결과 3개를 합쳐서 i_kcal에 할당하는거 하나, main페이지에서  때마다 실행, 추가된 값이 없다면 update만 안되고 나머지는 정상 작동
    @Update("UPDATE IntakeData SET i_kcal = COALESCE(i_breakfast_kcal, 0) + COALESCE(i_lunch_kcal, 0) + COALESCE(i_dinner_kcal, 0) WHERE m_seq = #{seq} AND i_day = #{day};")
    public int UnionAllCalories(@Param("seq") int seq, @Param("day") String day);
    
    //---탄단지콜나당 통합---------------------------------
    @Update("UPDATE IntakeData SET i_carbohydrate_g = (SELECT COALESCE(SUM(b_carbohydrate_g), 0) FROM Breakfast WHERE Breakfast.b_day = #{day}) + (SELECT COALESCE(SUM(l_carbohydrate_g), 0) FROM Lunch WHERE Lunch.l_day = #{day}) + (SELECT COALESCE(SUM(d_carbohydrate_g), 0) FROM Dinner WHERE Dinner.d_day = #{day}), i_protein_g = (SELECT COALESCE(SUM(b_protein_g), 0) FROM Breakfast WHERE Breakfast.b_day = #{day}) + (SELECT COALESCE(SUM(l_protein_g), 0) FROM Lunch WHERE Lunch.l_day = #{day}) + (SELECT COALESCE(SUM(d_protein_g), 0) FROM Dinner WHERE Dinner.d_day = #{day}), i_fat_g = (SELECT COALESCE(SUM(b_fat_g), 0) FROM Breakfast WHERE Breakfast.b_day = #{day}) + (SELECT COALESCE(SUM(l_fat_g), 0) FROM Lunch WHERE Lunch.l_day = #{day}) + (SELECT COALESCE(SUM(d_fat_g), 0) FROM Dinner WHERE Dinner.d_day = #{day}), i_cholesterol_mgl = (SELECT COALESCE(SUM(b_cholesterol_mg), 0) FROM Breakfast WHERE Breakfast.b_day = #{day}) + ( SELECT COALESCE(SUM(l_cholesterol_mg), 0) FROM Lunch WHERE Lunch.l_day = #{day}) + (SELECT COALESCE(SUM(d_cholesterol_mg), 0) FROM Dinner WHERE Dinner.d_day = #{day}), i_sodium_mg = (SELECT COALESCE(SUM(b_sodium_mg), 0) FROM Breakfast WHERE Breakfast.b_day = #{day}) + (SELECT COALESCE(SUM(l_sodium_mg), 0) FROM Lunch WHERE Lunch.l_day = #{day}) + (SELECT COALESCE(SUM(d_sodium_mg), 0) FROM Dinner WHERE Dinner.d_day = #{day}), i_sugar_g = ( SELECT COALESCE(SUM(b_sugar_g), 0) FROM Breakfast WHERE Breakfast.b_day = #{day}) + (SELECT COALESCE(SUM(l_sugar_g), 0) FROM Lunch WHERE Lunch.l_day = #{day}) + (SELECT COALESCE(SUM(d_sugar_g), 0) FROM Dinner WHERE Dinner.d_day = #{day}) WHERE m_seq = #{seq} AND i_day = #{day};")
    public int UnionAllNutritions(@Param("seq") int seq, @Param("day") String day);
    
//---몸무게, 타겟 몸무게 등록 쿼리, 다이얼로그 ---------------------------------------------
    
    //날짜별 몸무게 업데이트
    @Update("UPDATE IntakeData SET i_weight = #{i_weight} WHERE m_seq = #{seq} AND i_day = #{dialogDate};")
    public int WeightUpdate(@Param("i_weight") BigDecimal i_weight, @Param("seq") int seq, @Param("dialogDate") String dialogDate);
    
    //목표 몸무게 업데이트
    @Update("Update Member set m_target_weight = #{target_weight} where m_seq = #{seq};")
    public int TargetWeightUpdate(@Param("target_weight") BigDecimal target_weight, @Param("seq") int seq);
    
}

