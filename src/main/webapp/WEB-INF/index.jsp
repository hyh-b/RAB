<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
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
<script type="text/javascript">
	/* 카카오 로그인을 눌렀을 때 로그인이 되어 있다면 alreadyLogin.do로 보냄 */
    $(document).ready(function () {
        var isLogin = '${login}'; 
        if (isLogin === 'login') {
            $('#loginLink').attr('href', 'alreadyLogin.do');
        } else {
            $('#loginLink').attr('href', 'https://kauth.kakao.com/oauth/authorize?response_type=code&client_id=7b7314f847f2460b0290bb8096940714&redirect_uri=http://localhost:8080/kakao.do');
        }
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
		<!--[if lte IE 8]><script src="css/ie/html5shiv.js"></script><![endif]-->
		<script src="js/skel.min.js"></script>
		<script src="js/init.js"></script>
		<noscript>
			<link rel="stylesheet" href="css/skel.css" />
			<link rel="stylesheet" href="css/style.css" />
			<link rel="stylesheet" href="css/style-wide.css" />
			<link rel="stylesheet" href="css/style-noscript.css" />
		</noscript>
		<!--[if lte IE 9]><link rel="stylesheet" href="css/ie/v9.css" /><![endif]-->
		<!--[if lte IE 8]><link rel="stylesheet" href="css/ie/v8.css" /><![endif]
				<i class="fa-sharp fa-regular fa-right-to-bracket"></i>
				<i class="fa-solid fa-arrow-right-to-bracket"></i>
				<i class="fa-sharp fa-light fa-arrow-right-to-bracket"></i>
				<i class="fa-solid fa-arrow-right-to-arc"></i>
		-->
	
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
						<nav>
							<ul>

								<li class="login"><a id="loginLink" href=#>

    								<img src="src/images/logo/kloginpng.png"> 
									</a>
								</li>
									<!-- <a href="main.do" class=src/images/logo/logo-icon.svg"icon fa-solid fa-comment"><span class="label">kakaotalk</span></a> -->
								<li class="login"><a href="signin.do" class="icon fa-envelope-o"><span class="label">Email</span></a></li>

							</ul> 	
						</nav>
					</header>

				<!-- Footer -->
					<footer id="footer">
						<span class="copyright"> BY YIKCH | Contact us through <a href="http://html5up.net">gmail@gmail.com</a>
						</span>
					</footer>
				
			</div>
		</div>

	</body>
</html>