<%@page import="com.example.model.MypageTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	//int flag = 1;
	int flag = (Integer)request.getAttribute( "flag" );
	MypageTO myto = (MypageTO)request.getAttribute("myto");
	
	out.println( "<script type='text/javascript'>" );
	if( flag == 0 ) {
// 		out.println( "alert('정보 수정 완료');" );
		out.println( "location.href='./profile.do';" );
	} else {
		out.println( "alert('수정 실패');" );
		out.println("history.back();");
	}
	out.println( "</script>" );
%>














