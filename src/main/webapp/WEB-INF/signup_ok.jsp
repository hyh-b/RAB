<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<<<<<<< HEAD
=======
<% String sId = (String)request.getAttribute("sId"); 
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
<input type="button" id="sbtn" value="가입">
</form>  
>>>>>>> bdce1e214328a1af6e41b6891d0d97ca087fe3e1

<%
	//int flag = 1;
	int flag = (Integer)request.getAttribute( "flag" );
	out.print("hello");
	out.println( "<script type='text/javascript'>" );
	if( flag == 0 ) {
		out.println( "alert('회원가입에 성공');" );
<<<<<<< HEAD
		out.println( "location.href='./signin.do';" );
=======
		out.println( "document.sfrm.submit();" );
>>>>>>> bdce1e214328a1af6e41b6891d0d97ca087fe3e1
	} else {
		out.println( "alert('회원가입에 실패');" );
		out.println( "location.href='/';" );
	}
	out.println( "</script>" );
%>
<<<<<<< HEAD














=======
</body>
</html>
>>>>>>> bdce1e214328a1af6e41b6891d0d97ca087fe3e1
