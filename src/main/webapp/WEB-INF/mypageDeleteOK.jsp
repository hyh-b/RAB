<%@page import="com.example.model.MypageTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	int flag = (Integer)request.getAttribute( "flag" );
	MypageTO myto = (MypageTO)request.getAttribute("myto");
	
	out.println( "<script type='text/javascript'>" );
	if( flag == 0 ) {
// 		out.println( "location.href='/klogout.do';" );
		out.println( "location.href='/logout';" );
// 		out.println( "location.href='/';" );
	} /* else {
		out.println( "alert('탈퇴에 실패했습니다 관리자에게 문의 주세요');" );
		out.println("history.back();");
	} */
	out.println( "</script>" );
%>














