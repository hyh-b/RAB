package com.example.model;

import java.util.ArrayList;
import java.util.List;

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
	
	public ArrayList<MainTO> main_data() {
		
	    List<MainTO> tlist = (List<MainTO>)mapper.TotalDataForMain();
	    
	    ArrayList<MainTO> lists = new ArrayList<>(tlist);
	    
	    return lists;
	}
	

}
