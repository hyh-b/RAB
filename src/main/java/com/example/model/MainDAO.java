package com.example.model;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Repository;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.mappers.MainMapperInter;
import com.example.mappers.MemberMapperInter;

@Repository
@MapperScan("com.example.mappers")
public class MainDAO {
		
	@Autowired
	private MainMapperInter mapper;
	
	public ArrayList<MainTO> main_data(String mId) {

		List<MainTO> tlist = (List<MainTO>)mapper.DefaultDataForMain(mId);
		
	    ArrayList<MainTO> lists = new ArrayList<>(tlist);
	    
	    return lists;
	}
	
//-------------------------------------------------------------------------
	
	public ArrayList<MainTO> DateData(String id, String i_day ) {

		List<MainTO> datas = (List<MainTO>)mapper.DataFromDateForMain(i_day, id);
		
		System.out.println(" i_day DAO -> " + i_day);
		System.out.println("  m_id DAO -> " + id );

		
	    ArrayList<MainTO> ddatas = new ArrayList<>(datas);
	    
	    return ddatas;
	}
	
//----------------------------------------------------------------------------
	
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
	
//		public ArrayList<MainTO> foodData(@RequestParam int m_seq) {
//
//			List<MainTO> datas = (List<MainTO>)this.mapper.FoodData(m_seq);
//		
//			ArrayList<MainTO> fdatas = new ArrayList<>(datas);
//	    
//	    	return fdatas;
//		}
//		

}

