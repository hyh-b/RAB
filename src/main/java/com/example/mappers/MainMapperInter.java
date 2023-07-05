package com.example.mappers;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import com.example.model.MainTO;
import com.example.model.MemberTO;


@Mapper
public interface MainMapperInter {
	

	@Select("SELECT * FROM v_memberIntakeData where i_day = curdate();")
    public List<MainTO> TotalDataForMain();
	
	//signin.do 에 id입력칸 parameter 이름 확인 =id
	@Select("SELECT * FROM Member WHERE m_id = #{id}")
	public MemberTO DataFromId(String id);
	
	//eat에 들어온 데이터들 그래프에 뿌리기
	@Select("SELECT * FROM v_eat where b_seq = 2;")
	public List<MainTO> Meals();

	
}
