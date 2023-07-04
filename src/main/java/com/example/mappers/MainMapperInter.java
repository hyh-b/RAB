package com.example.mappers;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import com.example.model.MainTO;


@Mapper
public interface MainMapperInter {
	
	
	//curdate()은 달력 파라미터 이름으로 바꿔서 정한 날짜에 맞춰서 그 데이터가 따라올 예정.
	@Select("SELECT * FROM v_MeberIntakeData;")
    public List<MainTO> TotalDataForMain();
	

	
}
