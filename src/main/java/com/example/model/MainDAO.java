package com.example.model;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.mappers.MainMapperInter;
import com.example.mappers.MemberMapperInter;

@Repository
@MapperScan("com.example.mappers")
public class MainDAO {
		
	@Autowired
	private MainMapperInter mapper;
	
	public ArrayList<MainTO> main_data(String mId) {

		List<MainTO> tlist = (List<MainTO>)mapper.TotalDataForMain(mId);
		
	    ArrayList<MainTO> lists = new ArrayList<>(tlist);
	    
	    return lists;
	}
	
//-------------------------------------------------------------------------
	
	public int InsertData(String mId) {
		
		int flag = 1;
		
		int result = mapper.InsertDataForMain(mId);
		
		if(result == 1 ) {
			flag = 0;
		}else if(result == 0) {
			flag = 1;
		}
	
		return flag;
				
	}
	
//-------------------------------------------------------------------------
		public ArrayList<MainTO> foodData() {

			List<MainTO> datas = (List<MainTO>)this.mapper.FoodData();
		
			ArrayList<MainTO> fdatas = new ArrayList<>(datas);
	    
	    	return fdatas;
		}

	
	
	
//----------------------------------------------------------------------------
	
	//member아이디 가진 정보가 다 들어오는 지 확인 test용, Member로 바귀어야함 지우고 다시만들기 mapper에서도, parameter연결관계 설정 확인
	
	//파라미터 값인 mId 가 왜 안되는지 String인거 controller랑 dao에서 확인했는데 왜 type mismatch가 뜨는지
//	public MainTO data_member(HttpServletRequest request, String mId) {
//		
//		mId = request.getParameter("mId");
//		
//		//MainTO to = mapper.DataFromId(mId);
//		
//		return to; 
//	}
	
//아 점 저---------------------------------------------------------
//	public ArrayList<MainTO> data_meals(){
//		
//		List<MainTO> elist = (List<MainTO>)mapper.TotalDataForMain();
//		
//	    ArrayList<MainTO> datas = new ArrayList<>(elist);
//	    
//	    return datas;
//	    
//	}

}

