package com.example.mappers;

import java.sql.Date;
import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import com.example.model.MainTO;


@Mapper
public interface MainMapperInter {
	
	
	// 이전 쿼리 = SELECT m.*, i.i_kcal, i.i_weight, i.i_day FROM Member m CROSS JOIN IntakeData i WHERE m.m_id = #{mId} limit 0,1;
	
   @Select("SELECT m.*, i.i_kcal, i.i_weight, i.i_day, i.i_used_kcal FROM Member m INNER JOIN IntakeData i ON m.m_seq = i.m_seq WHERE m.m_id = #{mId};")
   public List<MainTO> TotalDataForMain(String mId);
	
    @Insert("INSERT INTO IntakeData (m_seq) SELECT m.m_seq FROM Member m LEFT JOIN IntakeData i ON m.m_seq = i.m_seq WHERE i.m_seq IS NULL AND m.m_id = #{mId} LIMIT 1;")
    public int InsertDataForMain(String mId);
    
//    @Select("SELECT d.*, b.*, l.* FROM Dinner d JOIN Breakfast b ON d.m_seq = b.m_seq JOIN Lunch l ON d.m_seq = l.m_seq where l_day='2023-07-07'")
//    public List<MainTO> FoodData();
    
     @Select("SELECT * FROM Breakfast WHERE b_day = '2023-07-08' AND m_seq = 30 UNION ALL SELECT * FROM Lunch WHERE l_day = '2023-07-08' AND m_seq = 30 UNION ALL SELECT * FROM Dinner WHERE d_day = '2023-07-08' AND m_seq = 30;")
      public List<MainTO> FoodData();
    
    
    // 인자값 각 데이들 어차피 아점저마다 날짜 입력칸 따로 없으니 그냥 #{i_day} 로 달력에서 받아서 뿌리도록 바꾸고 , #{m_seq}로 바꾸기

	
	//select * from where m_id=#{mId} and #{calendarCt}=i_day;




	
}
