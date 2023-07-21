<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String ok = (String)request.getAttribute("ok");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<%	
	out.println( "<script type='text/javascript'>" );
	if( ok != null ) {
		out.println( "alert('비밀번호 변경에 성공');" );
		out.println( "location.href='/signin.do';" );
	} else {
		out.println( "alert('비밀번호 변경에 실패');" );
		out.println( "history.back()" );
	} 
	out.println( "</script>" );
%>

</body>
</html>