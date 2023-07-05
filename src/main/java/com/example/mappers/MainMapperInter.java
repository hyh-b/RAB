package com.example.mappers;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import com.example.model.MainTO;
import com.example.model.MemberTO;


@Mapper
public interface MainMapperInter {
	
	
	//curdate()은 달력 파라미터 이름으로 바꿔서 정한 날짜에 맞춰서 그 데이터가 따라올 예정.
	@Select("SELECT * FROM v_MeberIntakeData where i_day = curdate();")
    public List<MainTO> TotalDataForMain();
	
	//signin.do 에 id입력칸 parameter 이름 확인 =id
	@Select("SELECT * FROM member WHERE m_id = #{id}")
	public MemberTO DataFromId(String id);
	
	//eat에 들어온 데이터들 그래프에 뿌리기
	@Select("SELECT * FROM v_eat where b_seq = 2;")
	public List<MainTO> Meals();

	
}
