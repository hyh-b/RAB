<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% 
	String sId = (String)request.getAttribute("sId"); 
	String sPw = (String)request.getAttribute("sPw"); 
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form action="signin.do" name="sfrm" method="post">
		<input type="hidden" name="sId" value="<%= sId %>">
		<input type="hidden" name="sPw" value="<%= sPw %>">
	</form>  

<%
	int flag = (Integer)request.getAttribute( "flag" );
	//회원가입에 성공한 유저는 로그인에 필요한 정보를 가지고 바로 로그인폼으로 
	out.println( "<script type='text/javascript'>" );
	if( flag == 0 ) {
		out.println( "alert('회원가입에 성공');" );
		out.println( "document.sfrm.submit();" );
	} else {
		out.println( "alert('회원가입에 실패');" );
		out.println( "location.href='/';" );
	}
	out.println( "</script>" );
%>
</body>
</html>