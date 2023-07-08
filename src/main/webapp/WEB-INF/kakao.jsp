<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% 
	String userId = (String)request.getAttribute("userId"); 
	String userEmail = (String)request.getAttribute("userEmail"); 
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form action="kSignup_ok.do" name="kfrm" method="post">
		<input type="hidden" name="kId" value="<%= userEmail %>">
		<input type="hidden" name="kPw" value="<%= userId %>">
	</form>  

	<form action="signin.do" name="sfrm" method="post">
		<input type="hidden" name="kId" value="<%= userEmail %>">
		<input type="hidden" name="kPw" value="<%= userId %>">
	</form> 
<%   
<<<<<<< HEAD
	//신규회원과 구별을 위한 로그인 오브젝트를 가져온 기존 회원은 로그인, 그렇지 않은 신규회원은 회원가입페이지로 이동
	String login = (String)request.getAttribute("login");

	out.println( "<script type='text/javascript'>" );
	out.println("window.onload = function() {");
	if(login !=null){
 		out.println( "document.sfrm.submit();" );
	}else{
 		out.println("document.kfrm.submit();" );
	}
	out.println( "};" );
	out.println( "</script>" );
=======
   String login = (String)request.getAttribute("login");
   
    out.println( "<script type='text/javascript'>" );
    out.println("window.onload = function() {");
    if(login !=null){
    
    out.println( "document.sfrm.submit();" );
    }else{
       out.println("document.kfrm.submit();" );
    }
    out.println( "};" );
    out.println( "</script>" );
>>>>>>> 34e732b6d1ca5ec27102a27151a13cecd64e696a
    
 %>

</body>
</html>