<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="icon" href="favicon.ico"><link href="style.css" rel="stylesheet">
<style type="text/css">
        .error-message {
            font-size: 2em;
            text-align: center;
            margin-top: 20%;
        }
        .button-group {
            display: flex;
            justify-content: center;
            gap: 10px;
        }
        .button-group button {
            padding: 10px 20px;
            font-size: 1em;
        }
    </style>
<!-- 에러 페이지 -->
<script type="text/javascript">
	function goBack() {
	    window.history.back();
	}
	function redirectToHome() {
	    location.href = "/logout";
	}
</script>
</head>
<body>
	<div class="error-message">페이지를 표시할 수 없습니다</div><br><br>
    <div class="button-group">
        <button class="inline-flex items-center justify-center rounded-md border border-black py-4 px-10 text-center font-medium text-black hover:bg-opacity-90 lg:px-8 xl:px-10"
         onclick="goBack()">뒤로 가기</button>
        <button class="inline-flex items-center justify-center rounded-md border border-black py-4 px-10 text-center font-medium text-black hover:bg-opacity-90 lg:px-8 xl:px-10"
         onclick="redirectToHome()">홈으로 이동(로그아웃)</button>
    </div>
</body>
</html>