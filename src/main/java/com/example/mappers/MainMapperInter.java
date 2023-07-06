package com.example.mappers;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import com.example.model.MainTO;
import com.example.model.MemberTO;


@Mapper
public interface MainMapperInter {
	
	
	// 이전 쿼리 = SELECT m.*, i.i_kcal, i.i_weight, i.i_day FROM Member m CROSS JOIN IntakeData i WHERE m.m_id = #{mId} limit 0,1;
	
	@Select("SELECT m.*, i.i_kcal, i.i_weight, i.i_day, i.i_used_kcal FROM Member m INNER JOIN IntakeData i ON m.m_seq = i.m_seq WHERE m.m_id = #{mId};")
    public List<MainTO> TotalDataForMain(String mId);
	
	
	@Select("SELECT m.*, h_kcal, h_muscle FROM Member m CROSS JOIN Hdata h WHERE m.m_id = #{mId};")
	public List<MainTO> HdataForMain(String mId);

	
	
	
	//#{mId}
	
//	//signin.do 에 id입력칸 parameter 이름 확인 =id 
//	@Select("SELECT * FROM Member WHERE m_id = #{mId}")
//	public MemberTO DataFromId(String mId);
	
	//IntakeData에 전부뿌려질 예정
//	@Select("SELECT * FROM v_eat where b_seq = 2;")
//	public List<MainTO> Meals();

	
}
