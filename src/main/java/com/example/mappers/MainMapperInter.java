package com.example.mappers;

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
	
   @Select("SELECT m.*, i.i_kcal, i.i_weight, i.i_day, i.i_used_kcal FROM Member m INNER JOIN IntakeData i ON m.m_seq = i.m_seq WHERE m.m_id = #{mId} and i.i_day= curdate();")
   public List<MainTO> DefaultDataForMain(String mId);
	
   	//달력값기준으로 4elements에 쿼리 전달
	@Select("SELECT m.*, i.i_kcal, i.i_weight, i.i_day, i.i_used_kcal FROM Member m INNER JOIN IntakeData i ON m.m_seq = i.m_seq WHERE m.m_seq = #{seq} and i.i_day= #{day};")
	public List<MainTO> DataFromDateForMain(@Param("seq") int seq, @Param("day") String day);

    //로그인과 동시에 참조레코드가 없다면 m_seq를 들어가서 참조 레코드를 만듬 중복없이.
    @Insert("INSERT INTO IntakeData (m_seq) SELECT m.m_seq FROM Member m LEFT JOIN IntakeData i ON m.m_seq = i.m_seq WHERE i.m_seq IS NULL AND m.m_id = #{mId} LIMIT 1;")
    public int InsertDataForMain(String mId);

    //Default음식 칼로리, 영양분 for charts
    @Select("SELECT * FROM Breakfast WHERE b_day = '2023-07-08' AND m_seq = 30 UNION ALL SELECT * FROM Lunch WHERE l_day = '2023-07-08' AND m_seq = 30 UNION ALL SELECT * FROM Dinner WHERE d_day = '2023-07-08' AND m_seq = 30;")
    public List<MainTO> FoodData();
    
    //pie Chart
    @Select("SELECT m.m_seq, m.m_id, i.*  FROM Member m INNER JOIN IntakeData i ON m.m_seq = i.m_seq WHERE m.m_seq = #{seq} and i.i_day= #{day};")
    public List<MainTO> PieChartData(@Param("seq") int seq, @Param("day") String day);
    
    //bar Chart Breakfast
    @Select("SELECT B.* FROM Breakfast AS B INNER JOIN Member AS M ON B.m_seq = M.m_seq WHERE B.b_day BETWEEN DATE_SUB(#{day}, INTERVAL 3 DAY) AND DATE_ADD(#{day}, INTERVAL 3 DAY) AND M.m_seq = #{seq};")
    public List<BreakfastTO> BarChartBreakfast(@Param("seq") int seq, @Param("day") String day);
    
//---update문---------------------------------
    
    //각 날짜마다 아점저 칼로리 합연산 이후 합쳐진 결과를 합산하는 거 하나 값이 요청될때마다 
    @Update("UPDATE IntakeData SET i_breakfast_kcal = (SELECT COALESCE(SUM(b_kcal), 0) FROM Breakfast WHERE Breakfast.b_day = #{day}), i_lunch_kcal = (SELECT COALESCE(SUM(l_kcal), 0) FROM Lunch WHERE Lunch.l_day = #{day}), i_dinner_kcal = (SELECT COALESCE(SUM(d_kcal), 0) FROM Dinner WHERE Dinner.d_day = #{day}) WHERE m_seq = #{seq} AND i_day = #{day};")
    public int UnionBLDperDay(@Param("seq") int seq, @Param("day") String day);
    
    //연산결과 3개를 합쳐서 i_kcal에 할당하는거 하나, main페이지에서  때마다 실행, 추가된 값이 없다면 update만 안되고 나머지는 정상 작동
    @Update("UPDATE IntakeData SET i_kcal = COALESCE(i_breakfast_kcal, 0) + COALESCE(i_lunch_kcal, 0) + COALESCE(i_dinner_kcal, 0) WHERE m_seq = #{seq} AND i_day = #{day};")
    public int UnionAllCalories(@Param("seq") int seq, @Param("day") String day);
}

