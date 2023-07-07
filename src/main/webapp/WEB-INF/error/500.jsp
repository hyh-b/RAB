<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- 인증이 없는 유저가 페이지 접근할 때 에러 페이지 -->
<script type="text/javascript">
	alert("로그인이 필요합니다");
	location.href='/';
</script>
</head>
<body>

</body>
</html>