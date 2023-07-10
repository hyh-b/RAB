package com.example.mappers;

import java.sql.Date;
import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.model.MainTO;


@Mapper
public interface MainMapperInter {
	
   @Select("SELECT m.*, i.i_kcal, i.i_weight, i.i_day, i.i_used_kcal FROM Member m INNER JOIN IntakeData i ON m.m_seq = i.m_seq WHERE m.m_id = #{mId} and i.i_day= curdate()-4;")
   public List<MainTO> DataForMain(String mId);
	
	@Select("SELECT m.*, i.i_kcal, i.i_weight, i.i_day, i.i_used_kcal FROM Member m INNER JOIN IntakeData i ON m.m_seq = i.m_seq WHERE m.m_id = #{mId} and i.i_day=#{i_day};")
	public List<MainTO> DataFromDateForMain(String mId, Date i_day);
	
    //로그인과 동시에 참조레코드가 없다면 m_seq를 들어가서 참조 레코드를 만듬 중복없이.
    @Insert("INSERT INTO IntakeData (m_seq) SELECT m.m_seq FROM Member m LEFT JOIN IntakeData i ON m.m_seq = i.m_seq WHERE i.m_seq IS NULL AND m.m_id = #{mId} LIMIT 1;")
    public int InsertDataForMain(String mId);
    
    //음식 칼로리, 영양분 for charts
    @Select("SELECT * FROM Breakfast WHERE b_day = '2023-07-08' AND m_seq = 30 UNION ALL SELECT * FROM Lunch WHERE l_day = '2023-07-08' AND m_seq = 30 UNION ALL SELECT * FROM Dinner WHERE d_day = '2023-07-08' AND m_seq = 30;")
    public List<MainTO> FoodData();
    
    //음식 칼로리, 영양분 for charts
//    @Select("SELECT * FROM Breakfast WHERE b_day = '2023-07-08' AND m_seq = #{m_seq} UNION ALL SELECT * FROM Lunch WHERE l_day = '2023-07-08' AND m_seq = #{m_seq}  UNION ALL SELECT * FROM Dinner WHERE d_day = '2023-07-08' AND m_seq = #{m_seq} ;")
//    public List<MainTO> FoodData(@RequestParam int m_seq);
    
    
    //
    
    // 인자값 각 데이들 어차피 아점저마다 날짜 입력칸 따로 없으니 그냥 #{i_day} 로 달력에서 받아서 뿌리도록 바꾸고 , #{m_seq}로 바꾸기

	
	//select * from where m_id=#{mId} and #{calendarCt}=i_day;




	
}
