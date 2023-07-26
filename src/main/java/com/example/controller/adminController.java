package com.example.controller;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.example.model.MemberDAO;
import com.example.model.MemberTO;

@RestController
public class adminController {
	
	@Autowired
	private MemberDAO mDao;
	
	@RequestMapping("/admin.do")
	public ModelAndView admin() {
		ArrayList<MemberTO> mList = mDao.memberList();
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.addObject("mList",mList);
		modelAndView.setViewName("admin");
		
		return modelAndView;
	}
	
	@PostMapping("/searchId.do")
	public ArrayList<MemberTO> searchMember(@RequestParam("m_id") String m_id) {
	    System.out.println("검색"+m_id);
	    ArrayList<MemberTO> sList = mDao.searchMemberList(m_id);
	    System.out.println(sList.get(0).getM_id());
	    return sList; 
	}
}
