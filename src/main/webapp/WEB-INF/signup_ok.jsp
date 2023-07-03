<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	//int flag = 1;
	int flag = (Integer)request.getAttribute( "flag" );
	out.print("hello");
	out.println( "<script type='text/javascript'>" );
	if( flag == 0 ) {
		out.println( "alert('회원가입에 성공');" );
		out.println( "location.href='./signin.do';" );
	} else {
		out.println( "alert('회원가입에 실패');" );
		out.println( "location.href='/';" );
	}
	out.println( "</script>" );
%>














