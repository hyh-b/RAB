<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
</head>
<body>
<% 
	String sId = (String)request.getAttribute("sId"); 
	String sPw = (String)request.getAttribute("sPw"); 
	int flag = (Integer)request.getAttribute("flag");
	out.println( "<script type='text/javascript'>" );
	out.println( "window.onload = function() {" );
	if( flag == 0 ) {
		out.println( "swal({title: '성공!',text: '정보입력에 성공',icon: 'success',button: '확인',})" );
		out.println( ".then((value) => {location.href='/signup3.do';});" );
	} else {
		out.println( "swal({title: '실패!',text: '정보입력에 실패',icon: 'error',button: '확인',})" );
		out.println( ".then((value) => {location.href='/signup2.do';});" );
	}
	out.println( "};" );
	out.println( "</script>" );
%>

</body>
</html>