package com.example.mappers;

import java.util.Date;
import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.model.MainTO;


@Mapper
public interface MainMapperInter {
	
   @Select("SELECT m.*, i.i_kcal, i.i_weight, i.i_day, i.i_used_kcal FROM Member m INNER JOIN IntakeData i ON m.m_seq = i.m_seq WHERE m.m_id = #{mId} and i.i_day= curdate();")
   public List<MainTO> DefaultDataForMain(String mId);
	
	@Select("SELECT m.*, i.i_kcal, i.i_weight, i.i_day, i.i_used_kcal FROM Member m INNER JOIN IntakeData i ON m.m_seq = i.m_seq WHERE m.m_id = #{id} and i.i_day= #{i_day};")
	public List<MainTO> DataFromDateForMain(@Param("id") String id, @Param("i_day") String i_day);

    //로그인과 동시에 참조레코드가 없다면 m_seq를 들어가서 참조 레코드를 만듬 중복없이.
    @Insert("INSERT INTO IntakeData (m_seq) SELECT m.m_seq FROM Member m LEFT JOIN IntakeData i ON m.m_seq = i.m_seq WHERE i.m_seq IS NULL AND m.m_id = #{mId} LIMIT 1;")
    public int InsertDataForMain(String mId);
    
    //음식 칼로리, 영양분 for charts
    @Select("SELECT * FROM Breakfast WHERE b_day = '2023-07-08' AND m_seq = 30 UNION ALL SELECT * FROM Lunch WHERE l_day = '2023-07-08' AND m_seq = 30 UNION ALL SELECT * FROM Dinner WHERE d_day = '2023-07-08' AND m_seq = 30;")
    public List<MainTO> FoodData();

}

