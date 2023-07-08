<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>


<!-- 예제 시작 -->

<!-- 이 예제에서는 필요한 js, css 를 링크걸어 사용 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/Swiper/4.5.1/css/swiper.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/Swiper/4.5.1/js/swiper.min.js"></script>

<style type="text/css">

.swiper-container {
	height:400px;
	border:5px solid silver;
	border-radius:7px;
	box-shadow:0 0 20px #ccc inset;
	position: relative;
}
.swiper-slide {
	
	text-align:center;
	display:flex; /* 내용을 중앙정렬 하기위해 flex 사용 */
	align-items:flex-start; /* 위아래 기준 중앙정렬 */
	justify-content:center; /* 좌우 기준 중앙정렬 */
	position: relative;
}
.swiper-slide img {
	box-shadow:0 0 5px #555;
	max-width:200px; /* 이미지 최대너비를 제한, 슬라이드에 이미지가 여러개가 보여질때 필요 */
	/* 이 예제에서 필요해서 설정했습니다. 상황에따라 다를 수 있습니다. */
	margin-bottom: auto; /* 추가: 아래쪽 여백을 auto로 설정하여 위로 붙임 */
}

.slideText {
  position: absolute;
  bottom: 30px;
  background: rgba(0, 0, 0, 0.5); /* Black background with 0.5 opacity */
  color: #f2f2f2;
  width: 100%;
  padding: 10px;
  text-align: center;
}

</style>
<br><br><br><Br>
<!-- 클래스명은 변경하면 안 됨 -->
<div class="swiper-container">
	<div class="swiper-wrapper">
		<div class="swiper-slide">
			<img src="/src/images/user/rocatNOb.png" >
			<div class="slideText">2012-06-14</div>
		</div>
		<div class="swiper-slide">
			<img src="/src/images/user/rocatNOb.png" >
			<div class="slideText">1번</div>
		</div>
		<div class="swiper-slide">
			<img src="/src/images/user/rocatNOb.png" >
			<div class="slideText">1번</div>
		</div>
		<div class="swiper-slide">
			<img src="/src/images/user/rocatNOb.png" >
			<div class="slideText">2번</div>
		</div>
		<div class="swiper-slide">
			<img src="/src/images/user/rocatNOb.png" >
			<div class="slideText">3번</div>
		</div>
		<div class="swiper-slide">
			<img src="/src/images/user/rocatNOb.png" >
			<div class="slideText">4번</div>
		</div>
		<div class="swiper-slide">
			<img src="/src/images/user/rocatNOb.png" >
			<div class="slideText">5번</div>
		</div>
		<div class="swiper-slide">
			<img src="/src/images/user/rocatNOb.png" >
			<div class="slideText">6번</div>
		</div>
		<div class="swiper-slide">
			<img src="/src/images/user/rocatNOb.png" >
			<div class="slideText">7번</div>
		</div>
		<div class="swiper-slide">
			<img src="/src/images/user/rocatNOb.png" >
			<div class="slideText">8번</div>
		</div>
		<div class="swiper-slide">
			<img src="/src/images/user/rocatNOb.png" >
			<div class="slideText">9번</div>
		</div>
		<div class="swiper-slide">
			<img src="/src/images/user/rocatNOb.png" >
			<div class="slideText">10번</div>
		</div>
		<div class="swiper-slide">
			<img src="/src/images/user/rocatNOb.png" >
			<div class="slideText">11번</div>
		</div>
		<div class="swiper-slide">
			<img src="/src/images/user/rocatNOb.png" >
			<div class="slideText">12번</div>
		</div>
		<div class="swiper-slide">
			<img src="/src/images/user/rocatNOb.png" >
			<div class="slideText">13번</div>
		</div>
		<div class="swiper-slide">
			<img src="/src/images/user/rocatNOb.png" >
			<div class="slideText">14번</div>
		</div>
	</div>

	<!-- 네비게이션 -->
	<div class="swiper-button-next"></div><!-- 다음 버튼 (오른쪽에 있는 버튼) -->
	<div class="swiper-button-prev"></div><!-- 이전 버튼 -->

	<!-- 페이징 -->
	<div class="swiper-pagination"></div>
</div>

<script>

new Swiper('.swiper-container', {

	slidesPerView : 5, // 동시에 보여줄 슬라이드 갯수
	spaceBetween : 30, // 슬라이드간 간격
	slidesPerGroup : 5, // 그룹으로 묶을 수, slidesPerView 와 같은 값을 지정하는게 좋음

	// 그룹수가 맞지 않을 경우 빈칸으로 메우기
	// 3개가 나와야 되는데 1개만 있다면 2개는 빈칸으로 채워서 3개를 만듬
	loopFillGroupWithBlank : true,

	loop : false, // 무한 반복

	pagination : { // 페이징
		el : '.swiper-pagination',
		clickable : true, // 페이징을 클릭하면 해당 영역으로 이동, 필요시 지정해 줘야 기능 작동
	},
	navigation : { // 네비게이션
		nextEl : '.swiper-button-next', // 다음 버튼 클래스명
		prevEl : '.swiper-button-prev', // 이번 버튼 클래스명
	},
});

</script>

<!-- 예제 종료 -->



</body>
</html>