<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%

	int flag = (Integer)request.getAttribute("flag");
	
	out.println( "<script type='text/javascript'>" );
	if( flag == 0  ) {
		out.println( "alert('삭제에 성공');" );
		out.println( "location.href='notice_board.do';" );
	}  else {
		out.println( "alert('삭제에 실패');" );
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