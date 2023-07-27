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
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
</head>
<body>

<%	
	out.println( "<script type='text/javascript'>" );
	if( ok != null ) {
		//out.println( "alert('비밀번호 변경에 성공');" );
		//out.println( "location.href='/signin.do';" );
		out.println( "swal({title: '성공!',text: '비밀번호 변경에 성공',icon: 'success',button: '확인',})" );
		out.println( ".then((value) => {location.href='/signin.do';});" );
	} else {
		//out.println( "alert('비밀번호 변경에 실패');" );
		//out.println( "history.back()" );
		out.println( "swal({title: '실패!',text: '비밀번호 변경에 실패',icon: 'error',button: '확인',})" );
		out.println( ".then((value) => {history.back();});" );
	} 
	out.println( "</script>" );
%>

</body>
</html>