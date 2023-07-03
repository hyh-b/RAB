<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% String userId = (String)request.getAttribute("userId"); 
 String userEmail = (String)request.getAttribute("userEmail"); 
 System.out.println("유저인포"+userId);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<form action="kSignup_ok.do" name="kfrm" method="post">
<input type="hidden" name="userId" value="<%= userId %>">
<input type="hidden" name="userEmail" value="<%= userEmail %>">
<!-- 이메일<input type="text" name="email" > -->
<input type="button" id="kbtn" value="가입">
</form>
<script type="text/javascript">
	window.onload = function() {
		
		
			
			document.kfrm.submit(); 
		
		
	};
</script>
</body>
</html>