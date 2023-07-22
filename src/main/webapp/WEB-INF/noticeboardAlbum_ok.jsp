<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	int flagAB = (Integer)request.getAttribute("flagAB");
	int flag = (Integer)request.getAttribute("flag");
	
	out.println( "<script type='text/javascript'>" );
	if( flag == 1 && flagAB == 1 ) {
		out.println( "alert('업로드에 성공');" );
		out.println( "location.href='notice_board.do';" );
	}  else {
		out.println( "alert('업로드에 실패');" );
		out.println( "history.back();" );
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