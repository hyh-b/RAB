<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% 
	String sId = (String)request.getAttribute("sId"); 
	String sPw = (String)request.getAttribute("sPw"); 
	
	int flag = (Integer)request.getAttribute("flag");
	out.println( "<script type='text/javascript'>" );
	if( flag == 0 ) {
		out.println( "alert('정보입력에 성공');" );
		out.println( "location.href='/main.do';" );
	} else {
		out.println( "alert('정보입력에 실패');" );
		out.println( "location.href='/signup2.do';" );
	}
	out.println( "</script>" );
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

</body>
</html>