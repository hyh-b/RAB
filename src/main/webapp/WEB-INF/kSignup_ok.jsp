<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String kId = (String)request.getAttribute("kId");
	String kPw = (String)request.getAttribute("kPw");
%>
<!DOCTYPE html>s
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<form action="signin.do" name="kfrm" method="post">
<input type="hidden" name="kId" value="<%= kId %>">
<input type="hidden" name="kPw" value="<%= kPw %>">
</form>  
<%	
	int flag = (Integer)request.getAttribute( "flag" );
	//회원가입 성공시 바로 로그인되게 필요정보 가지고 로그인페이지로 가는 폼 제출
	out.println( "<script type='text/javascript'>" );
	if( flag == 0 ) {
		out.println( "alert('회원가입에 성공');" );
		out.println( "document.kfrm.submit();" );
	} else {
		out.println( "alert('회원가입에 실패');" );
		out.println( "location.href='/';" );
	} 
	out.println( "</script>" );
%>
</body>
</html>
