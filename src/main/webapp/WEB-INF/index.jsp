<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
    <%
    	request.setCharacterEncoding("utf-8");
    %>
<style>
    .login img {
        width: 60px;
        height: 60px;
    }
</style>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<script type="text/javascript">
    $(document).ready(function () {
        var isLogin = '${login}'; 
        $('#loginLink').click(function(e) {
            if (isLogin === 'login') {
                e.preventDefault(); // 기본 클릭 동작을 막습니다
                swal({
                    title: "정보",
                    text: "이미 로그인 되어있습니다",
                    icon: "info",
                    button: "확인",
                }).then((value) => {
                    window.location.href = "main.do";
                });
            } else {
                // 로그인이 되어있지 않다면, 카카오 로그인 URL로 이동합니다
                $(this).attr('href', 'https://kauth.kakao.com/oauth/authorize?response_type=code&client_id=7b7314f847f2460b0290bb8096940714&redirect_uri=http://localhost:8080/kakao.do');
                //$(this).attr('href', 'https://kauth.kakao.com/oauth/authorize?response_type=code&client_id=7b7314f847f2460b0290bb8096940714&redirect_uri=http://43.201.35.6:8080/kakao.do');
            }
        });
    });
</script>
<!DOCTYPE HTML>
<!--
	Aerial by HTML5 UP
	html5up.net | @n33co
	Free for personal and commercial use under the CCA 3.0 license (html5up.net/license)
-->
<html lang="en">

<head>
<title>RAB</title>
<meta charset="UTF-8" />
  	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta name="description" content="" />
<meta name="keywords" content="" />
<style>
    .login img {
        width: 60px;
        height: 60px;
    }
</style>
<link rel="stylesheet" href="css/skel.css" />
<link rel="stylesheet" href="css/style.css" />
<link rel="stylesheet" href="css/style-wide.css" />
<link rel="stylesheet" href="css/style-noscript.css" />
<script src="https://kit.fontawesome.com/efe58e199b.js" crossorigin="anonymous"></script>
<script src="js/skel.min.js"></script>
<script src="js/init.js"></script>

</head>
<body class="loading">
	<div id="wrapper">
		<div id="bg"></div>
		<div id="overlay"></div>
		<div id="main">
			<!-- Header -->
			<header id="header">
				<h1>RockAt yourBody</h1>
				<p>당신의 몸을 &nbsp;&bull;&nbsp;상승시키세요&nbsp;&bull;&nbsp; With RAB</p>
				<sec:authorize access="isAuthenticated()">
					<p>Welcome, <sec:authentication property="name" />!</p>
				</sec:authorize>
				<nav>
					<ul>
						<li class="login" >
						<a id="loginLink" href=#>
						        <i class="fa-brands fa-kickstarter-k fa-beat fa-2xl"></i>
						    </a>
						</li>
							<!-- <a href="main.do" class=src/images/logo/logo-icon.svg"icon fa-solid fa-comment"><span class="label">kakaotalk</span></a> -->
<!-- 						<li class="login"><a href="signin.do" class="icon fa-envelope-o"><span class="label">Email</span></a></li> -->
						<li class="login"><a href="signin.do"><i class="fa-solid fa-house fa-bounce fa-2xl"></i></a></li>
					</ul> 	
				</nav>
			</header>

		<!-- Footer -->
			<footer id="footer">
				<p>클라우드 기반 &nbsp;&bull;&nbsp;<span style="font-size: xx-large;">AI</span>&nbsp;&bull;&nbsp; 건강 데이터 차트</p>
			</footer>
			
		</div>
	</div>
</body>
</html>