<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<!-- 중복 로그인시 기존 로그인 유저에게 보일 창 -->
<script type="text/javascript">
	alert("이미 로그인되어있는 아이디입니다")
	location.href = "/signin.do";
</script>
</body>
</html>