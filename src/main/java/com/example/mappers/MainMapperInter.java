package com.example.mappers;

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
	
//	@Select("SELECT m.*, h_kcal, h_muscle FROM Member m CROSS JOIN Hdata h WHERE m.m_id = #{mId};")
//	public List<MainTO> HdataForMain(String mId);

	
	//select * from where m_id=#{mId} and #{calendarCt}=i_day;



	
}
