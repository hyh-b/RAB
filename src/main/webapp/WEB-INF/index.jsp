<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
    <%
    	request.setCharacterEncoding("utf-8");
    %>
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
<!-- 				<p>당신의 몸을 &nbsp;&bull;&nbsp;상승시키세요&nbsp;&bull;&nbsp; With RAB</p> -->
				<p>클라우드 기반 &nbsp;&bull;&nbsp;<span style="font-size: xx-large;">AI</span>&nbsp;&bull;&nbsp; 건강 데이터 차트</p>
				<nav>
					<ul>
						<li class="login">
						    <a href="https://kauth.kakao.com/oauth/authorize?response_type=code&client_id=7b7314f847f2460b0290bb8096940714&redirect_uri=http://localhost:8080/kakao.do">
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
			</footer>
			
		</div>
	</div>
</body>
</html>