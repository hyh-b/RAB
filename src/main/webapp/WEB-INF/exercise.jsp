<%@page import="com.example.model.ExerciseAlbumTO"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String m_name = (String)request.getAttribute("m_name");
	String m_gender = (String)request.getAttribute("m_gender");
	String abHtml = (String)request.getAttribute("abHtml");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>운동</title>
<link rel="icon" href="favicon.ico"><link href="style.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/Swiper/4.5.1/css/swiper.min.css">
<link rel="stylesheet" href="https://code.jquery.com/ui/1.13.0/themes/base/jquery-ui.css">
<!-- 구글 사이드 상단 Menu 글씨체-->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Lugrasimo&display=swap" rel="stylesheet">

<!-- 구글 사이드 글씨체-->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Josefin+Sans&family=Lugrasimo&display=swap" rel="stylesheet">

<!-- 이미지 아이콘 cdn -->
<script src="https://kit.fontawesome.com/efe58e199b.js" crossorigin="anonymous"></script>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
<script src="https://code.jquery.com/ui/1.13.0/jquery-ui.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Swiper/4.5.1/js/swiper.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<style type="text/css">

	.theme1 {margin-bottom:30px; border:0px; height:5px; background: linear-gradient(to left, transparent, rgba(255,255,255,.5), transparent);}
   
	/*============ 사이드 로고 메뉴 폰트 ==========*/
	h3.mb-4.ml-4.text-sm.font-medium.text-bodydark2 {
	     font-size: 30px;
	   font-family: 'Cuprum', sans-serif;
	    }
	/*=====================================*/
	 
	/*============ 사이드 (공지사항 , 게시판 , 식단 , 운동 , 내정보 , 로그아웃) ==========*/
	    h1 {
	       font-size: 25px;
	        font-family: 'Josefin Sans', sans-serif;
	}
	

	.radio-buttons {
    	display: flex; /* 가로 배치를 위해 flexbox 사용 */
  	}
  	.btn {
    	margin-right: 10px; /* 버튼 사이의 간격 조정 */
  	}
  	
  	.nutrient-table {
	  	border-collapse: collapse;
	}
	
	.nutrient-table td {
	  	padding: 5px;
	}
	
	.spacer-row td {
	  	height: 10px;
	  	padding: 0;
	  	border: none;
	}
	
	
    .accordion {
	    margin-bottom: 10px;
	}
	.accordion-title {
	    cursor: pointer;
	    padding: 5px;
	}
	.accordion-content {
	    display: none;
	    margin-top: 10px;
	}
	
	/* --------------------------이미지 슬라이드------------------------------ */
	
	.swiper-container {
		
		/* width:100px; */
		width: 100%;
	    height: auto;
	    max-width: 1500px;
	    min-height: 450px; /* 이 값을 조정해 슬라이더의 최소 높이를 설정하세요. */
		border:5px solid silver;
		border-radius:7px;
		box-shadow:0 0 20px #ccc inset;
		position: relative;
		/* margin-top: 130px; */
		margin-bottom: 50px; 
	}
	
	.swiper-slide {
		min-height: 100px;
		text-align:center;
		display:flex; /* 내용을 중앙정렬 하기위해 flex 사용 */
		/*align-items:flex-start;  위아래 기준 중앙정렬 */
		align-items:stretch; 
		justify-content:center; /* 좌우 기준 중앙정렬 */
		/* 반응형웹에 필요한 css */
		display: -webkit-box;
	    display: -ms-flexbox;
	    display: -webkit-flex;
	    display: flex;
	    -webkit-box-pack: center;
	    -ms-flex-pack: center;
	    -webkit-justify-content: center;
	    justify-content: center;
	    -webkit-box-align: center;
	    -ms-flex-align: center;
	    -webkit-align-items: center;
		/* ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ */
		position: relative;
	}
	
	.swiper-slide img {
		box-shadow:0 0 5px #555;
		max-width:100%; /* 이미지 최대너비를 제한, 슬라이드에 이미지가 여러개가 보여질때 필요 */
		max-height:420px;
		min-height:300px;
		/* 이 예제에서 필요해서 설정했습니다. 상황에따라 다를 수 있습니다. */
		margin-bottom: auto; /* 추가: 아래쪽 여백을 auto로 설정하여 위로 붙임 */
		/* 반응형 웹 */
		width: 100%;
		max-width: 100%;
   		height: auto;
	}
	
	.slideText {
	  position: absolute;
	  bottom: 0px;
	  background: rgba(0, 0, 0, 0.5); 
	  color: #f2f2f2;
	  width: 100%;
	  padding: 10px;
	  text-align: center;
	}
	
	@media only screen and (max-width: 600px) {
	    .slideText {
	        font-size: 16px;
	    }
	}
	
	/*  --------------------------이미지 슬라이드 끝------------------------------  */
    
    /* --------------------------  파일업로드, 사진전체보기 버튼 ---------------------------------------- */
   .button-container {
	  display: flex;
	  justify-content: space-between; 
	  flex-wrap: wrap; 
	  align-items: flex-end;
	  margin: auto;
	  max-width:1500px;
	  
	}
	
	.upload-container {
	  padding: 10px;
	  margin-right: 290px;
	}

 /* --------------------------  파일업로드, 사진전체보기 버튼 끝---------------------------------------- */

/*--------------- 사진전체보기 창 시작----------------------------  */
  
  
  #closeDialogBtn {
      position: absolute;
      right: 10px;
      bottom: 10px;
      font-size: 2em;
    }
    #photoDialog {
      display: none;
      width:1200px; 
      height:1120px;
      position: relative;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      z-index: 1000;
      background: white;
      padding: 20px;
      border: 1px solid black;
      max-height: 90vh; /* 뷰포트 높이의 90%로 최대 높이 설정 */
	  max-width: 90vw; /* 뷰포트 너비의 90%로 최대 너비 설정 */
	  overflow-y: auto; /* 내용이 창 크기를 넘어갈 경우 스크롤 표시 */
    }
    #photoContainer {
      display: flex;
      flex-wrap: wrap;
      justify-content: space-between;
      column-count: 3; /* 3개의 열을 만듦 */
  	  column-gap: 10px
    }
    #photoContainer img {
      width: 100%;
      margin-bottom: 20px;
    }
    
    .photoContainer div {
    	break-inside: avoid; /* 한 div가 두 열 사이에 걸쳐 있지 않도록 함 */
  	    padding-bottom: 10px;
        margin-bottom: 25px;
    }
        
     .photoContainer div img {
     	width: 100%;
  		height: auto;		
        max-width: 380px;
        max-height: 340px;
        min-width: 220px;
        min-height: 220px;
        margin-right: 20px;
        margin-bottom: 20px;
     }
        
	@media (max-width: 1600px) {
	  .photoContainer div img {
	    max-width: 280px;
	    max-height: 160px;
	    min-width: 150px;
	    min-height: 150px;
	    
	  }
	   #photoDialog {
	      width:900px; 
	      height:1000px;
      	  left: 60%;
      } 
      #photoContainer div {
            margin-bottom: 10px;
        }
	}
	
	@media (max-width: 480px) {
	  .photoContainer div img {
	    max-width: 140px;
	    max-height: 140px;
	    min-width: 80px;
	    min-height: 80px;
	  }
	  
	  #photoDialog {
	      width:450px; 
	      height:500px;
      	  left: 60%;
      } 
	}
        #previousPageBtn, #nextPageBtn {
            position: absolute;
            left: 20px;
            bottom: 10px;
            font-size:20px;
            color: green;
            font-weight: bold;
        }
        #nextPageBtn {
            left: 90px;
        }
        
    /*--------------- 사진전체보기 창 끝----------------------------  */
    
    /*---------------  운동 시작----------------------------  */
    
	.exercise-info {
	    display: flex;
	    align-items: center;
	    gap: 10px;
	}
	
	.exercise-info .dbtn {
	    
	    margin-left:12px;
	    margin-right:10px;
	}
	
	.ex_time_input {
	    padding: 5px;
	     border: 2px solid black;
	    border-radius: 4px;
	}
	
	.customExercise-info {
	    display: flex;
	    align-items: center;
	    gap: 10px;
	}
	
	.customExercise-info .dbtn {
	    
	    margin-left:12px;
	    margin-right:10px;
	}
	
	
	
	/*---------------  운동 끝----------------------------  */
	
	/*---------------  당일 합계 시작----------------------------  */
	
	.total {
	    display: flex;
	    justify-content: space-between;;
	    align-items: center;
	    width: 100%;
	}
	
	.totalExUsedKcal {
	  margin-right: 60px;
	} 
	
	/*---------------  당일 합계 끝----------------------------  */
</style>

</head>
<body
  x-data="{ page: 'profile', 'loaded': true, 'darkMode': true, 'stickyMenu': false, 'sidebarToggle': false, 'scrollTop': false }"
  x-init="
          darkMode = JSON.parse(localStorage.getItem('darkMode'));
          $watch('darkMode', value => localStorage.setItem('darkMode', JSON.stringify(value)))"
  :class="{'dark text-bodydark bg-boxdark-2': darkMode === true}">
  <!-- ===== Preloader Start ===== -->
  <div
  x-show="loaded"
  x-init="window.addEventListener('DOMContentLoaded', () => {setTimeout(() => loaded = false, 500)})"
  class="fixed left-0 top-0 z-999999 flex h-screen w-screen items-center justify-center bg-white"
>
  <div
    class="h-16 w-16 animate-spin rounded-full border-4 border-solid border-primary border-t-transparent"
  ></div>
</div>

  <!-- ===== Preloader End ===== -->

  <!-- ===== Page Wrapper Start ===== -->
  <div class="flex h-screen overflow-hidden">
    <!-- ===== Sidebar Start ===== -->
    <aside
  :class="sidebarToggle ? 'translate-x-0' : '-translate-x-full'"
  class="absolute left-0 top-0 z-9999 flex h-screen w-72.5 flex-col overflow-y-hidden bg-black duration-300 ease-linear dark:bg-boxdark lg:static lg:translate-x-0"
  @click.outside="sidebarToggle = false"
>
  <!-- SIDEBAR HEADER -->
  <div class="flex items-center justify-between gap-2 px-6 py-5.5 lg:py-6.5" style="padding-left: 59px;">
    <a href="/main.do">
<!--       <img src="src/images/logo/배경로고2.png" width="100%" height="100%" /> -->
		<i class="fa-solid fa-rocket bounce fa-10x"></i>
    </a>

    <button
      class="block lg:hidden"
      @click.stop="sidebarToggle = !sidebarToggle"
    >
      <svg
        class="fill-current"
        width="20"
        height="18"
        viewBox="0 0 20 18"
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
      >
        <path
          d="M19 8.175H2.98748L9.36248 1.6875C9.69998 1.35 9.69998 0.825 9.36248 0.4875C9.02498 0.15 8.49998 0.15 8.16248 0.4875L0.399976 8.3625C0.0624756 8.7 0.0624756 9.225 0.399976 9.5625L8.16248 17.4375C8.31248 17.5875 8.53748 17.7 8.76248 17.7C8.98748 17.7 9.17498 17.625 9.36248 17.475C9.69998 17.1375 9.69998 16.6125 9.36248 16.275L3.02498 9.8625H19C19.45 9.8625 19.825 9.4875 19.825 9.0375C19.825 8.55 19.45 8.175 19 8.175Z"
          fill=""
        />
      </svg>
    </button>
  </div>
  <!-- SIDEBAR HEADER -->

  <div class="no-scrollbar flex flex-col overflow-y-auto duration-300 ease-linear">
    <!-- Sidebar Menu -->
    <nav
      class="mt-5 py-4 px-4 lg:mt-9 lg:px-6"
      x-data="{selected: 'Dashboard'}"
      x-init="
        selected = JSON.parse(localStorage.getItem('selected'));
        $watch('selected', value => localStorage.setItem('selected', JSON.stringify(value)))"
    >
      <!-- Menu Group -->
      <div>
	      <h3 class="mb-4 ml-4 text-sm font-medium text-bodydark2" style="padding-left: 45px; padding-top: 20px;">Menu</h3>
		  <hr class="theme1">
	
	      <ul class="mb-6 flex flex-col gap-1.5">
	        <!-- Menu Item Dashboard -->
	     <li class="sideMenu" style="height: 50px; padding-top: 20px;">
	      <a
	         href="board.do"
	         class="flex items-center gap-3.5 text-sm font-medium duration-300 ease-in-out hover:text-primary lg:text-base"
	         style="padding-left: 30px;"
	       >
	       <i class="fa-solid fa-circle-info"></i>
	       <path
	         d="M11 9.62499C8.42188 9.62499 6.35938 7.59687 6.35938 5.12187C6.35938 2.64687 8.42188 0.618744 11 0.618744C13.5781 0.618744 15.6406 2.64687 15.6406 5.12187C15.6406 7.59687 13.5781 9.62499 11 9.62499ZM11 2.16562C9.28125 2.16562 7.90625 3.50624 7.90625 5.12187C7.90625 6.73749 9.28125 8.07812 11 8.07812C12.7188 8.07812 14.0938 6.73749 14.0938 5.12187C14.0938 3.50624 12.7188 2.16562 11 2.16562Z"
	         fill=""
	       />
	       <path
	         d="M17.7719 21.4156H4.2281C3.5406 21.4156 2.9906 20.8656 2.9906 20.1781V17.0844C2.9906 13.7156 5.7406 10.9656 9.10935 10.9656H12.925C16.2937 10.9656 19.0437 13.7156 19.0437 17.0844V20.1781C19.0094 20.8312 18.4594 21.4156 17.7719 21.4156ZM4.53748 19.8687H17.4969V17.0844C17.4969 14.575 15.4344 12.5125 12.925 12.5125H9.07498C6.5656 12.5125 4.5031 14.575 4.5031 17.0844V19.8687H4.53748Z"
	         fill=""
	       />
	       </svg>
	       <h1>공지사항</h1>
	      </a>
	     </li>
	     
	     <li class="sideMenu" style="height: 50px; padding-top: 20px;">
	       <a
	          href="board.do"
	          class="flex items-center gap-3.5 text-sm font-medium duration-300 ease-in-out hover:text-primary lg:text-base"
	          style="padding-left: 30px;"
	        >
	          <i class="fa-solid fa-users"></i>
	          <path
	            d="M11 9.62499C8.42188 9.62499 6.35938 7.59687 6.35938 5.12187C6.35938 2.64687 8.42188 0.618744 11 0.618744C13.5781 0.618744 15.6406 2.64687 15.6406 5.12187C15.6406 7.59687 13.5781 9.62499 11 9.62499ZM11 2.16562C9.28125 2.16562 7.90625 3.50624 7.90625 5.12187C7.90625 6.73749 9.28125 8.07812 11 8.07812C12.7188 8.07812 14.0938 6.73749 14.0938 5.12187C14.0938 3.50624 12.7188 2.16562 11 2.16562Z"
	            fill=""
	          />
	          <path
	            d="M17.7719 21.4156H4.2281C3.5406 21.4156 2.9906 20.8656 2.9906 20.1781V17.0844C2.9906 13.7156 5.7406 10.9656 9.10935 10.9656H12.925C16.2937 10.9656 19.0437 13.7156 19.0437 17.0844V20.1781C19.0094 20.8312 18.4594 21.4156 17.7719 21.4156ZM4.53748 19.8687H17.4969V17.0844C17.4969 14.575 15.4344 12.5125 12.925 12.5125H9.07498C6.5656 12.5125 4.5031 14.575 4.5031 17.0844V19.8687H4.53748Z"
	            fill=""
	          />
	          </svg>
	          <h1>게시판</h1>
	        </a>
	      </li>

	      <li class="sideMenu" style="height: 50px; padding-top: 20px;">
	        <a
	           href="food.do"
	           class="flex items-center gap-3.5 text-sm font-medium duration-300 ease-in-out hover:text-primary lg:text-base"
	           style="padding-left: 30px;"
	         >
	           <i class="fa-solid fa-bowl-food"></i>
	           <path
	             d="M11 9.62499C8.42188 9.62499 6.35938 7.59687 6.35938 5.12187C6.35938 2.64687 8.42188 0.618744 11 0.618744C13.5781 0.618744 15.6406 2.64687 15.6406 5.12187C15.6406 7.59687 13.5781 9.62499 11 9.62499ZM11 2.16562C9.28125 2.16562 7.90625 3.50624 7.90625 5.12187C7.90625 6.73749 9.28125 8.07812 11 8.07812C12.7188 8.07812 14.0938 6.73749 14.0938 5.12187C14.0938 3.50624 12.7188 2.16562 11 2.16562Z"
	             fill=""
	           />
	           <path
	             d="M17.7719 21.4156H4.2281C3.5406 21.4156 2.9906 20.8656 2.9906 20.1781V17.0844C2.9906 13.7156 5.7406 10.9656 9.10935 10.9656H12.925C16.2937 10.9656 19.0437 13.7156 19.0437 17.0844V20.1781C19.0094 20.8312 18.4594 21.4156 17.7719 21.4156ZM4.53748 19.8687H17.4969V17.0844C17.4969 14.575 15.4344 12.5125 12.925 12.5125H9.07498C6.5656 12.5125 4.5031 14.575 4.5031 17.0844V19.8687H4.53748Z"
	             fill=""
	           />
	           </svg>
	           <h1>음식</h1>
	         </a>
	      </li>
	      
	      <li class="sideMenu" style="height: 50px; padding-top: 20px;">
	         <a
	            href="exercise.do"
	            class="flex items-center gap-3.5 text-sm font-medium duration-300 ease-in-out hover:text-primary lg:text-base"
	            style="padding-left: 30px;"
	          >
	            <i class="fa-solid fa-dumbbell"></i>
	            <path
	              d="M11 9.62499C8.42188 9.62499 6.35938 7.59687 6.35938 5.12187C6.35938 2.64687 8.42188 0.618744 11 0.618744C13.5781 0.618744 15.6406 2.64687 15.6406 5.12187C15.6406 7.59687 13.5781 9.62499 11 9.62499ZM11 2.16562C9.28125 2.16562 7.90625 3.50624 7.90625 5.12187C7.90625 6.73749 9.28125 8.07812 11 8.07812C12.7188 8.07812 14.0938 6.73749 14.0938 5.12187C14.0938 3.50624 12.7188 2.16562 11 2.16562Z"
	              fill=""
	            />
	            <path
	              d="M17.7719 21.4156H4.2281C3.5406 21.4156 2.9906 20.8656 2.9906 20.1781V17.0844C2.9906 13.7156 5.7406 10.9656 9.10935 10.9656H12.925C16.2937 10.9656 19.0437 13.7156 19.0437 17.0844V20.1781C19.0094 20.8312 18.4594 21.4156 17.7719 21.4156ZM4.53748 19.8687H17.4969V17.0844C17.4969 14.575 15.4344 12.5125 12.925 12.5125H9.07498C6.5656 12.5125 4.5031 14.575 4.5031 17.0844V19.8687H4.53748Z"
	              fill=""
	            />
	            </svg>
	            <h1>운동</h1>
	          </a>
	       </li>
			<br/><br/>
			<h3 class="mb-4 ml-4 text-sm font-medium text-bodydark2" style="padding-left: 45px; padding-top: 20px;">Others</h3>
          	<hr class="theme1">
	          <!-- Menu Item Settings -->
	        <li class="sideMenu" style="height: 50px; padding-top: 20px;">
	          <a
	              href="profile.do"
	              class="flex items-center gap-3.5 text-sm font-medium duration-300 ease-in-out hover:text-primary lg:text-base"
	              style="padding-left: 30px;"
	            >
	              <svg
	                class="fill-current"
	                width="22"
	                height="22"
	                viewBox="0 0 22 22"
	                fill="none"
	                xmlns="http://www.w3.org/2000/svg"
	              >
	                <path
	                  d="M11 9.62499C8.42188 9.62499 6.35938 7.59687 6.35938 5.12187C6.35938 2.64687 8.42188 0.618744 11 0.618744C13.5781 0.618744 15.6406 2.64687 15.6406 5.12187C15.6406 7.59687 13.5781 9.62499 11 9.62499ZM11 2.16562C9.28125 2.16562 7.90625 3.50624 7.90625 5.12187C7.90625 6.73749 9.28125 8.07812 11 8.07812C12.7188 8.07812 14.0938 6.73749 14.0938 5.12187C14.0938 3.50624 12.7188 2.16562 11 2.16562Z"
	                  fill=""
	                />
	                <path
	                  d="M17.7719 21.4156H4.2281C3.5406 21.4156 2.9906 20.8656 2.9906 20.1781V17.0844C2.9906 13.7156 5.7406 10.9656 9.10935 10.9656H12.925C16.2937 10.9656 19.0437 13.7156 19.0437 17.0844V20.1781C19.0094 20.8312 18.4594 21.4156 17.7719 21.4156ZM4.53748 19.8687H17.4969V17.0844C17.4969 14.575 15.4344 12.5125 12.925 12.5125H9.07498C6.5656 12.5125 4.5031 14.575 4.5031 17.0844V19.8687H4.53748Z"
	                  fill=""
	                />
	              </svg>
	              <h1>프로필</h1>
	            </a>
	        </li>
	        <li>
				<button class="flex items-center gap-3.5 py-4 px-6 text-sm font-medium duration-300 ease-in-out hover:text-primary lg:text-base">
	            <svg
	              class="fill-current"
	              width="22"
	              height="22"
	              viewBox="0 0 22 22"
	              fill="none"
	              xmlns="http://www.w3.org/2000/svg"
	            >
	              <path
	                d="M15.5375 0.618744H11.6531C10.7594 0.618744 10.0031 1.37499 10.0031 2.26874V4.64062C10.0031 5.05312 10.3469 5.39687 10.7594 5.39687C11.1719 5.39687 11.55 5.05312 11.55 4.64062V2.23437C11.55 2.16562 11.5844 2.13124 11.6531 2.13124H15.5375C16.3625 2.13124 17.0156 2.78437 17.0156 3.60937V18.3562C17.0156 19.1812 16.3625 19.8344 15.5375 19.8344H11.6531C11.5844 19.8344 11.55 19.8 11.55 19.7312V17.3594C11.55 16.9469 11.2062 16.6031 10.7594 16.6031C10.3125 16.6031 10.0031 16.9469 10.0031 17.3594V19.7312C10.0031 20.625 10.7594 21.3812 11.6531 21.3812H15.5375C17.2219 21.3812 18.5625 20.0062 18.5625 18.3562V3.64374C18.5625 1.95937 17.1875 0.618744 15.5375 0.618744Z"
	                fill=""
	              />
	              <path
	                d="M6.05001 11.7563H12.2031C12.6156 11.7563 12.9594 11.4125 12.9594 11C12.9594 10.5875 12.6156 10.2438 12.2031 10.2438H6.08439L8.21564 8.07813C8.52501 7.76875 8.52501 7.2875 8.21564 6.97812C7.90626 6.66875 7.42501 6.66875 7.11564 6.97812L3.67814 10.4844C3.36876 10.7938 3.36876 11.275 3.67814 11.5844L7.11564 15.0906C7.25314 15.2281 7.45939 15.3312 7.66564 15.3312C7.87189 15.3312 8.04376 15.2625 8.21564 15.125C8.52501 14.8156 8.52501 14.3344 8.21564 14.025L6.05001 11.7563Z"
	                fill=""
	              />
	            </svg>
	            <a href="/klogout.do"><h1>로그아웃</h1></a>
	          </button>
			</li>
          
          <!-- Menu Item Settings -->
        </ul>
      </div>
      </nav>
  </div>
</aside>


    <!-- ===== Sidebar End ===== -->

    <!-- ===== Content Area Start ===== -->
    <div class="relative flex flex-1 flex-col overflow-y-auto overflow-x-hidden">
      <!-- ===== Header Start ===== -->
      <header
  class="sticky top-0 z-999 flex w-full bg-white drop-shadow-1 dark:bg-boxdark dark:drop-shadow-none"
>
  <div
    class="flex flex-grow items-center justify-between py-4 px-4 shadow-2 md:px-6 2xl:px-11"
  >
    <div class="flex items-center gap-2 sm:gap-4 lg:hidden">
      <!-- Hamburger Toggle BTN -->
      <button
        class="z-99999 block rounded-sm border border-stroke bg-white p-1.5 shadow-sm dark:border-strokedark dark:bg-boxdark lg:hidden"
        @click.stop="sidebarToggle = !sidebarToggle"
      >
        <span class="relative block h-5.5 w-5.5 cursor-pointer">
          <span class="du-block absolute right-0 h-full w-full">
            <span
              class="relative top-0 left-0 my-1 block h-0.5 w-0 rounded-sm bg-black delay-[0] duration-200 ease-in-out dark:bg-white"
              :class="{ '!w-full delay-300': !sidebarToggle }"
            ></span>
            <span
              class="relative top-0 left-0 my-1 block h-0.5 w-0 rounded-sm bg-black delay-150 duration-200 ease-in-out dark:bg-white"
              :class="{ '!w-full delay-400': !sidebarToggle }"
            ></span>
            <span
              class="relative top-0 left-0 my-1 block h-0.5 w-0 rounded-sm bg-black delay-200 duration-200 ease-in-out dark:bg-white"
              :class="{ '!w-full delay-500': !sidebarToggle }"
            ></span>
          </span>
          <span class="du-block absolute right-0 h-full w-full rotate-45">
            <span
              class="absolute left-2.5 top-0 block h-full w-0.5 rounded-sm bg-black delay-300 duration-200 ease-in-out dark:bg-white"
              :class="{ 'h-0 delay-[0]': !sidebarToggle }"
            ></span>
            <span
              class="delay-400 absolute left-0 top-2.5 block h-0.5 w-full rounded-sm bg-black duration-200 ease-in-out dark:bg-white"
              :class="{ 'h-0 dealy-200': !sidebarToggle }"
            ></span>
          </span>
        </span>
      </button>
        <!-- Hamburger Toggle BTN -->
      <a class="block flex-shrink-0 lg:hidden" href="/">
        <img src="src/images/logo/" alt="" />
      </a>
    </div>
    
    <!--  검색 창 -->
    <div class="hidden sm:block">
    
    </div>
    <!--  검색 창  끝-->

    <div class="flex items-center gap-3 2xsm:gap-7">
      <ul class="flex items-center gap-2 2xsm:gap-4">
        <li>
          <!-- Dark Mode Toggler -->
          <label
            :class="darkMode ? 'bg-primary' : 'bg-stroke'"
            class="relative m-0 block h-7.5 w-14 rounded-full"
          >
            <input
              id="darkModeCheckbox"
              onchange="checkDarkMode()"
              type="checkbox"
              :value="darkMode"
              @change="darkMode = !darkMode"
              class="absolute top-0 z-50 m-0 h-full w-full cursor-pointer opacity-0"
            />
            <span
              :class="darkMode && '!right-[3px] !translate-x-full'"
              class="absolute top-1/2 left-[3px] flex h-6 w-6 -translate-y-1/2 translate-x-0 items-center justify-center rounded-full bg-white shadow-switcher duration-75 ease-linear"
            >
              <span class="dark:hidden">
                <svg
                  width="16"
                  height="16"
                  viewBox="0 0 16 16"
                  fill="none"
                  xmlns="http://www.w3.org/2000/svg"
                >
                  <path
                    d="M7.99992 12.6666C10.5772 12.6666 12.6666 10.5772 12.6666 7.99992C12.6666 5.42259 10.5772 3.33325 7.99992 3.33325C5.42259 3.33325 3.33325 5.42259 3.33325 7.99992C3.33325 10.5772 5.42259 12.6666 7.99992 12.6666Z"
                    fill="#969AA1"
                  />
                  <path
                    fill="#969AA1"
                  />
                </svg>
              </span>
              <span class="hidden dark:inline-block">
                <svg
                  width="16"
                  height="16"
                  viewBox="0 0 16 16"
                  fill="none"
                  xmlns="http://www.w3.org/2000/svg"
                >
                  <path
                    d="M14.3533 10.62C14.2466 10.44 13.9466 10.16 13.1999 10.2933C12.7866 10.3667 12.3666 10.4 11.9466 10.38C10.3933 10.3133 8.98659 9.6 8.00659 8.5C7.13993 7.53333 6.60659 6.27333 6.59993 4.91333C6.59993 4.15333 6.74659 3.42 7.04659 2.72666C7.33993 2.05333 7.13326 1.7 6.98659 1.55333C6.83326 1.4 6.47326 1.18666 5.76659 1.48C3.03993 2.62666 1.35326 5.36 1.55326 8.28666C1.75326 11.04 3.68659 13.3933 6.24659 14.28C6.85993 14.4933 7.50659 14.62 8.17326 14.6467C8.27993 14.6533 8.38659 14.66 8.49326 14.66C10.7266 14.66 12.8199 13.6067 14.1399 11.8133C14.5866 11.1933 14.4666 10.8 14.3533 10.62Z"
                    fill="#969AA1"
                  />
                </svg>
              </span>
            </span>
          </label>
        </li>
      </ul>

      <!-- User Area -->
      <div
        class="relative"
        x-data="{ dropdownOpen: false }"
        @click.outside="dropdownOpen = false"
      >
        <a
          class="flex items-center gap-4"
          href="#"
          @click.prevent="dropdownOpen = ! dropdownOpen"
        >
          <span class="hidden text-right lg:block">
            <span class="block text-sm font-medium text-black dark:text-white"

              >${m_name}</span
            >
            <!-- 
            <span class="block text-xs font-medium"></span>
			 -->	          
          </span>

          <span class="h-12 w-12 rounded-full">
          <!--  프로필 사진 업로드 파일 경로 설정 => C:/java/RAB-workspace/RABver/RABver/src/main/webapp/src/images/user -->
            <img src="https://rabfile.s3.ap-northeast-2.amazonaws.com/${m_profile}" alt="User" />

          </span>

          <svg
            :class="dropdownOpen && 'rotate-180'"
            class="hidden fill-current sm:block"
            width="12"
            height="8"
            viewBox="0 0 12 8"
            fill="none"
            xmlns="http://www.w3.org/2000/svg"
          >
            <path
              fill-rule="evenodd"
              clip-rule="evenodd"
              d="M0.410765 0.910734C0.736202 0.585297 1.26384 0.585297 1.58928 0.910734L6.00002 5.32148L10.4108 0.910734C10.7362 0.585297 11.2638 0.585297 11.5893 0.910734C11.9147 1.23617 11.9147 1.76381 11.5893 2.08924L6.58928 7.08924C6.26384 7.41468 5.7362 7.41468 5.41077 7.08924L0.410765 2.08924C0.0853277 1.76381 0.0853277 1.23617 0.410765 0.910734Z"
              fill=""
            />
          </svg>
        </a>

        <!-- Dropdown Start -->
        <div
          x-show="dropdownOpen"
          class="absolute right-0 mt-4 flex w-62.5 flex-col rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark"
        >
          <ul
            class="flex flex-col gap-5 border-b border-stroke px-6 py-7.5 dark:border-strokedark"
          >
            <li>
              <a
                href="profile.do"
                class="flex items-center gap-3.5 text-sm font-medium duration-300 ease-in-out hover:text-primary lg:text-base"
                style="padding-left: 5px;"
              >
                <svg
                  class="fill-current"
                  width="22"
                  height="22"
                  viewBox="0 0 22 22"
                  fill="none"
                  xmlns="http://www.w3.org/2000/svg"
                >
                  <path
                    d="M11 9.62499C8.42188 9.62499 6.35938 7.59687 6.35938 5.12187C6.35938 2.64687 8.42188 0.618744 11 0.618744C13.5781 0.618744 15.6406 2.64687 15.6406 5.12187C15.6406 7.59687 13.5781 9.62499 11 9.62499ZM11 2.16562C9.28125 2.16562 7.90625 3.50624 7.90625 5.12187C7.90625 6.73749 9.28125 8.07812 11 8.07812C12.7188 8.07812 14.0938 6.73749 14.0938 5.12187C14.0938 3.50624 12.7188 2.16562 11 2.16562Z"
                    fill=""
                  />
                  <path
                    d="M17.7719 21.4156H4.2281C3.5406 21.4156 2.9906 20.8656 2.9906 20.1781V17.0844C2.9906 13.7156 5.7406 10.9656 9.10935 10.9656H12.925C16.2937 10.9656 19.0437 13.7156 19.0437 17.0844V20.1781C19.0094 20.8312 18.4594 21.4156 17.7719 21.4156ZM4.53748 19.8687H17.4969V17.0844C17.4969 14.575 15.4344 12.5125 12.925 12.5125H9.07498C6.5656 12.5125 4.5031 14.575 4.5031 17.0844V19.8687H4.53748Z"
                    fill=""
                  />
                </svg>
                프로필
              </a>
            </li>
          </ul>
          
          
          
          
          <button class="flex items-center gap-3.5 py-4 px-6 text-sm font-medium duration-300 ease-in-out hover:text-primary lg:text-base">
            <svg
              class="fill-current"
              width="22"
              height="22"
              viewBox="0 0 22 22"
              fill="none"
              xmlns="http://www.w3.org/2000/svg"
            >
              <path
                d="M15.5375 0.618744H11.6531C10.7594 0.618744 10.0031 1.37499 10.0031 2.26874V4.64062C10.0031 5.05312 10.3469 5.39687 10.7594 5.39687C11.1719 5.39687 11.55 5.05312 11.55 4.64062V2.23437C11.55 2.16562 11.5844 2.13124 11.6531 2.13124H15.5375C16.3625 2.13124 17.0156 2.78437 17.0156 3.60937V18.3562C17.0156 19.1812 16.3625 19.8344 15.5375 19.8344H11.6531C11.5844 19.8344 11.55 19.8 11.55 19.7312V17.3594C11.55 16.9469 11.2062 16.6031 10.7594 16.6031C10.3125 16.6031 10.0031 16.9469 10.0031 17.3594V19.7312C10.0031 20.625 10.7594 21.3812 11.6531 21.3812H15.5375C17.2219 21.3812 18.5625 20.0062 18.5625 18.3562V3.64374C18.5625 1.95937 17.1875 0.618744 15.5375 0.618744Z"
                fill=""
              />
              <path
                d="M6.05001 11.7563H12.2031C12.6156 11.7563 12.9594 11.4125 12.9594 11C12.9594 10.5875 12.6156 10.2438 12.2031 10.2438H6.08439L8.21564 8.07813C8.52501 7.76875 8.52501 7.2875 8.21564 6.97812C7.90626 6.66875 7.42501 6.66875 7.11564 6.97812L3.67814 10.4844C3.36876 10.7938 3.36876 11.275 3.67814 11.5844L7.11564 15.0906C7.25314 15.2281 7.45939 15.3312 7.66564 15.3312C7.87189 15.3312 8.04376 15.2625 8.21564 15.125C8.52501 14.8156 8.52501 14.3344 8.21564 14.025L6.05001 11.7563Z"
                fill=""
              />
            </svg>
            <a href="/klogout.do">로그아웃</a>
          </button>
        </div>
        <!-- Dropdown End -->
      </div>
      <!-- User Area -->
    </div>
  </div>
</header>

      <!-- ===== Header End ===== -->
	
      <!-- ===== Main Content Start ===== -->
      <main>
        <!-- =============================== div 시작 ========================= -->
		<div class="mx-auto max-w-screen-2xl p-4 md:p-6 2xl:p-10">

        <!-- =============================== 타이틀 시작========================= -->

		<div class="mb-6 flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-center">
			<h4 class="text-title-md2 font-bold text-black dark:text-white" style="padding-left: 30px">
			    운동 기록
			</h4>
		</div>
        <!-- =============================== 타이틀 끝 ========================= -->

        <hr style="padding-bottom: 30px"/>

        <!-- =============================== 당일 합계 ========================= -->
        
        <div class="rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark" >
			<div class="border-b border-stroke py-4 px-6.5 dark:border-strokedark">
				<div class="flex items-center justify-between">
			    	<label class="font-medium text-black dark:text-white mr-4" style="padding-left: 50px; width: 150px;">
			    		당일 합계
			    	</label>
			    	<div>
						<!-- 날짜를 선택할 수 있는 입력 요소를 추가합니다. -->
						<input type="text" id="datepicker" placeholder="날짜 선택" class="rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark">
					</div>
			    	<label class="font-medium text-black dark:text-white mr-4" style="padding-right: 50px;">
			    		총 운동시간
			    	</label>
			    	<label class="font-medium text-black dark:text-white mr-4">
			    		총 소모 칼로리
			    	</label>
				</div>
			</div>
            <div class="flex flex-col gap-5.5 p-6.5">
            	<div>
					<div id="total1" >
						
					</div>
	        	</div>
        	</div>
        </div>
        </div> 
        <!-- =============================== 당일 합계 끝 =========================== -->
        
        <!-- =============================== 운동 시작 =========================== -->
        
        <div class="mx-auto max-w-screen-2xl p-4 md:p-6 2xl:p-10">
		    <div class="rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark">
		        <div class="border-b border-stroke py-4 px-6.5 dark:border-strokedark">
		            <div class="flex items-center">
		                <h4 class="font-medium text-black dark:text-white mr-4">
		                    운동
		                </h4>
		                <button id="btn1">
		                    <img src="https://m.ftscrt.com/static/images/foodadd/FA_add.png" width="17px" height="17px">
		                </button>
		               
		       <!-- =============================== 운동 다이어로그 시작 =========================== -->
		                <div id="dialogContainer1" title="검색">
		                    <input type="text" id="exerciseName1" placeholder="운동종목을 입력하세요">
		                    <button id="searchButton1">검색</button>
		                    <div id="exerciseDiv1"></div>
		                </div>
		    <!-- =============================== 운동 다이어로그 끝 =========================== -->
		            </div>
		        </div>
		        <div class="border-b border-stroke py-4 px-6.5 dark:border-strokedark">
		            <div style="display: flex;">
		            	<div style="flex: 0.3;">삭제</div>
		                <div style="flex: 1.9;" class="exercise-name-header">운동명</div>
		                <div style="flex: 0.4;" class="exercise-time-header">운동 시간(분)</div>&nbsp;&nbsp;
		                <button style="flex: 0.5;" id="applyAll"><img id="kcalImg" class="kcalImg"  src="/src/images/logo/kcal2.png" width=140px > </button>&emsp;&emsp;&emsp;
		                <div style="flex: 0.3;" class="calories-burned-header">소모 칼로리</div>
		            </div>
		        </div>
		        <div class="flex flex-col gap-5.5 p-6.5">
		            <div>
		                <form action="#" method="post" name="ffrm">
		                    <div id="resultExercise1" class="exercise-list">
		                    
		                    </div>
		                </form>
		            </div>
		        </div>
		    </div>
		</div>
        
        <!-- =============================== 운동 끝 =========================== -->

        <!-- =============================== 사용자설정 운동 시작 =========================== -->
        
        <div class="mx-auto max-w-screen-2xl p-4 md:p-6 2xl:p-10">
		
		        <div class="rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark" >
		        	<div class="border-b border-stroke py-4 px-6.5 dark:border-strokedark">
						<div class="flex items-center">
					   		<h4 class="font-medium text-black dark:text-white mr-4">
					    		사용자 설정 운동
					    	</h4>
					    	<button id="btn2">
		                    	<img src="https://m.ftscrt.com/static/images/foodadd/FA_add.png" width="17px" height="17px">
		                	</button>
					    	
		
		     <!-------------------- 사용자 설정 운동 다이어로그 시작 ------------------->
		                    <div id="dialog-form" title="운동 입력">
							    <p class="validateTips">운동정보를 입력해 주세요</p><br>
							    <form>
							        <fieldset>
							            <div>
							                <label for="name">운동명</label>
							                <input type="text" name="name" id="name" class="text ui-widget-content ui-corner-all">
							            </div><br>
							            <div>
							                <label for="time">운동 시간(분)</label>
							                <input type="number" name="time" id="time" class="text ui-widget-content ui-corner-all">
							            </div><br>
							            <div>
							                <label for="calorie">소모 칼로리</label>
							                <input type="number" name="calorie" id="calorie" class="text ui-widget-content ui-corner-all">
							            </div>
							        </fieldset>
							    </form>
							</div>
		<!-------------------- 사용자 설정 운동 다이어로그 끝 ------------------->
					    	<div id="dialogContainer2" title="검색">
								
								<div id="exerciseDiv2"></div>
							</div>
						</div>
					</div>
					<div class="border-b border-stroke py-4 px-6.5 dark:border-strokedark">
						<div style="display: flex;">
							<div style="flex: 0.3;">삭제</div>
					    	<div style="flex: 1.9;" class="exercise-name-header">운동명</div>
				            <div style="flex: 1.1;" class="exercise-time-header">운동 시간(분)</div>
				            <div style="flex: 0.3;" class="calories-burned-header">소모 칼로리</div>
						</div>
					</div>
		            <div class="flex flex-col gap-5.5 p-6.5">
		            	<div>
								<div id="resultExercise2">
								
								</div>
			        	</div>
		        	</div>
		        </div>
		        
		</div>
        
	<!-- =============================== 사용자설정 운동 끝 =========================== -->   
	     
	<!------------------ 이미지 업로드 시작---------------------------------------------------->
		  <form id="ufrm" method="post" name="ufrm" enctype="multipart/form-data">
		  <div class="button-container">
		  <div class="upload-container">
		  	<div class="rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark">
			  	<div class="border-b border-stroke py-4 px-6.5 dark:border-strokedark">
			    	<label class="mb-3 block font-medium text-sm text-black dark:text-white">
			            사진 등록
			        </label>
			        <div class="flex">
			        	<input type="file" name="upload"
			            	class="w-full cursor-pointer rounded-lg border-[1.5px] border-stroke bg-transparent font-medium outline-none transition file:mr-5 file:border-collapse file:cursor-pointer file:border-0 file:border-r file:border-solid file:border-stroke file:bg-whiter dark:file:bg-white/30 dark:file:text-white file:py-3 file:px-5 file:hover:bg-primary file:hover:bg-opacity-10 focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:file:border-form-strokedark dark:focus:border-primary" />
			            <button id="ubtn" type="button"
			              	class="inline-flex items-center justify-center rounded-md border border-black py-4 px-10 text-center font-medium text-black hover:bg-opacity-90 lg:px-8 xl:px-10 dark:bg-white/30 dark:text-white" style="cursor: pointer;">upload
			            </button>
			      	</div>
			  	</div>
			</div>
            </div>
			</form>
	<!------------------- 이미지 업로드 끝 ---------------------------------------------------->
			
	<!-------------------- 사진 전체보기 버튼 시작 ------------------------------------------------------>
			<a href="#" id="viewBtn"
                  class="button-view-all inline-flex items-center justify-center rounded-md border border-black py-4 px-10 text-center font-medium text-black hover:bg-opacity-90 lg:px-8 xl:px-10 dark:bg-white/30 dark:text-white">
                  사진전체보기
                </a>
            </div>
   <!------------------------ 사진 전체보기 버튼 끝 ----------------------------------------->
		   
	<!---------------- 이미지 슬라이드 시작 ----------------------------------------->
			  <div class="swiper-container">
				<div class="swiper-wrapper" id="imgSlide">
				
				</div>
			
				<!-- 네비게이션 -->
				<div class="swiper-button-next"></div><!-- 다음 버튼 (오른쪽에 있는 버튼) -->
				<div class="swiper-button-prev"></div><!-- 이전 버튼 -->
			
				<!-- 페이징 -->
				<div class="swiper-pagination"></div>
			</div>
	<!---------------- 이미지 슬라이드 끝 ----------------------------------------->
	
	<!---------------- 사진 전체보기 다이어로그 시작 ----------------------------------------->
			<div id="photoDialog" style="display:none; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); z-index: 1000; background: white; padding: 20px; border: 1px solid black;">
		        <button id="closeDialogBtn" style="font-size: 25px; position: absolute; right: 20px; bottom: 10px; font-weight: bold;">닫기</button>
		        <button id="deleteBtn" style="font-size: 25px; position: absolute; right: 100px; bottom: 10px; font-weight: bold;">삭제</button>
			    <button id="previousPageBtn">이전</button>
			    <button id="nextPageBtn">다음</button>
		        <div id="photoContainer" class="photoContainer">
		            
		        </div>
		    </div>
	<!---------------- 사진 전체보기 다이어로그 끝 ----------------------------------------->
  	</div>
		</main> 
    </div>
  </div>
<script defer src="bundle.js"></script>
<script>
	
	// 이미지 슬라이드 출력
	function imgSlide(){
		console.log("이미지시작")
		$.ajax({
			url: '/imgSlide', 
			type: 'GET',
			success: function(response) {
				console.log("이미지시작22")
				let slideHtml = "";
				let bucketUrl = "https://rabfile.s3.ap-northeast-2.amazonaws.com/";
				for (var i = 0; i < response.length; i++) {
					var fileName = response[i].album_name;
					var albumDay = response[i].album_day;
					slideHtml +=
						'<div class="swiper-slide">'+
						'<img src="'+bucketUrl+fileName+'">'+
						'<div class="slideText">'+albumDay+'</div>'+
						'</div>'
				}
				$('#imgSlide').html(slideHtml);
					new Swiper('.swiper-container', {
						
						slidesPerView : 3, // 동시에 보여줄 슬라이드 갯수
						spaceBetween : 30, // 슬라이드간 간격
						slidesPerGroup : 3, // 그룹으로 묶을 수, slidesPerView 와 같은 값을 지정하는게 좋음
					
						// 그룹수가 맞지 않을 경우 빈칸으로 메우기
						// 3개가 나와야 되는데 1개만 있다면 2개는 빈칸으로 채워서 3개를 만듬
						loopFillGroupWithBlank : true,
					
						loop : false, // 무한 반복 x
					
						pagination : { // 페이징
							el : '.swiper-pagination',
							clickable : true, // 페이징을 클릭하면 해당 영역으로 이동, 필요시 지정해 줘야 기능 작동
						},
						navigation : { // 네비게이션
							nextEl : '.swiper-button-next', // 다음 버튼 클래스명
							prevEl : '.swiper-button-prev', // 이번 버튼 클래스명
						},
					});
			},
			  error: function(xhr, status, error) {
			    // 요청이 실패한 경우에 대한 처리 작성
			    console.error('요청 실패. 상태 코드:', xhr.status);
			}
		});
	} 
	
	//   사진 전체보기 다이어로그 창 설정
	$('#viewBtn').click(function() {
    	$('#photoDialog').css('display', 'block');
	});
	
	$('#closeDialogBtn').click(function() {
	    $('#photoDialog').css('display', 'none');
	});
		
	let currentPage = 1;
	let imagesPerPage = 9;
	let selectedImage = null;
	let selectedImageValue = null;
	
	// 사진 전체보기 이미지 출력
	function displayImages(){
		$.ajax({
			url: '/imgSlide', 
			type: 'GET',
			success: function(response) {
				images = response;
	            let html = '';
	            let bucketUrl = 'https://rabfile.s3.ap-northeast-2.amazonaws.com/';

	            let start = (currentPage - 1) * imagesPerPage;
	            let end = start + imagesPerPage;
	            let imagesToDisplay = images.slice(start, end);

	            for (let i = 0; i < imagesToDisplay.length; i++) {
	                if (i % 3 === 0) {
	                    html += '<div style="display:flex">';
	                }
	                html += '<img src="' + bucketUrl + imagesToDisplay[i].album_name + '" value="' + imagesToDisplay[i].a_seq + '" onclick="selectImage(this)" style="width: 100%; height: 100%; margin-bottom: 20px;">';
	                if ((i + 1) % 3 === 0 || i + 1 === imagesToDisplay.length) {
	                    html += '</div>';
	                }
	            }
				$('#photoContainer').html(html);
			},
			  error: function(xhr, status, error) {
			    console.error('요청 실패. 상태 코드:', xhr.status);
			}
		});
	} 

	// 이미지 선택 기능
	function selectImage(imageElement) {
		if (selectedImage) {
	    	selectedImage.style.border = 'none'; 
	    }
	        imageElement.style.border = '2px solid red'; 
	        selectedImage = imageElement;
	        selectedImageValue = imageElement.getAttribute('value');
	    }
		
	// 이미지 삭제
    function deleteImage() {
        if (!selectedImageValue) {
            //alert('삭제할 이미지를 선택해 주세요');
            swal({
                title: "주의!",
                text: "삭제할 이미지를 선택해 주세요",
                icon: "warning",
                button: "확인",
           });
	        return;
	    }
	        console.log(selectedImageValue)
	    $.ajax({
	    	url: '/exDelete',
	        method: 'POST',
	        data: {
	            aSeq: selectedImageValue
	        },
		    success: function(response) {
		    	
		    	if(response == "삭제 성공"){
		            //alert('이미지가 삭제되었습니다');
		            swal({
		                  title: "성공!",
		                  text: "이미지가 삭제되었습니다",
		                  icon: "success",
		                  button: "확인",
		             });

		            imgSlide();
		            displayImages();
		    	}
	        },
	        error: function(xhr, status, error) {
	            //alert('삭제에 실패했습니다');
	        	swal({
	                  title: "실패!",
	                  text: "삭제에 실패했습니다",
	                  icon: "error",
	                  button: "확인",
	             });

	        },
	        complete: function() {
	            // 실행 후 이미지 선택 해제
	            selectedImage.style.border = 'none';
	            selectedImage = null;
	            selectedImageValue = null;
	        }
	    });
	}
		
    $('#deleteBtn').click(deleteImage);
    
    // 다음 페이지
    function handleNextPage() {
        let totalImages = images.length;
        let totalPages = Math.ceil(totalImages / imagesPerPage);

        if (currentPage < totalPages) {
            currentPage++;
            displayImages();
        }
    }
	    
	// 이전 페이지
	function handlePreviousPage() {
		if (currentPage > 1) {
	        currentPage--;
	        displayImages();
		}
	}

	$('#previousPageBtn').click(handlePreviousPage);
	$('#nextPageBtn').click(handleNextPage);

	/*---------------운동 다이어로그 시작--------- */
	
	function adjustBrightness() {
    var img = document.getElementById('kcalImg');
    if (darkMode) {
      img.style.filter = 'brightness(50%)';
    } else {
      img.style.filter = 'brightness(100%)';
    }
  }
	
	// 운동칸에 추가한 운동 정보 출력하는 함수
	function fetchExercises(date) {
		$.ajax({
	        url: '/viewExercise',
	        type: 'GET',
	        data: { selectedDate: date },
	        success: function(data) {
	            let exerciseHtml = '<div class="exercise-item">';
	            data.forEach(function(exercise, index) {
	            	if (exercise.ex_name) {
	                    exerciseHtml += 
	                    // 각 행마다 인덱스 설정하여 구분
	                    '<div class="exercise-info" style="display: flex;" data-index="'+index+'">' +
	                    	'<button class="dbtn" style="flex: 0.1;"><img src="src/images/logo/deleteBtn.png" width=10px height=10px /></button>'+
	                    	'<div style="flex: 0.15;"></div>'+
	                        '<div class="ex_name" style="flex: 2.6;">'+exercise.ex_name+'</div>'+
	                        '<input class="ex_time dark:bg-form-input" style="flex: 0.3;" value='+exercise.ex_time+' type="number" placeholder="Enter time">'+
	                        '<div style="flex: 0.7;"></div>'+
	                        '<div class="ex_used_kcal" style="flex: 0.3;">'+exercise.ex_used_kcal+'</div>'+
	                    '</div>';
	            	}
	            });
	            exerciseHtml += '</div>';
	            $('#resultExercise1').html(exerciseHtml);
	            
	            let customExerciseHtml = '<div class="customExercise-item">';
		        data.forEach(function(exercise, index) {
		        	if (exercise.ex_name2) {
			            customExerciseHtml += 
		            	// 각 행마다 인덱스 설정하여 구분
		            	'<div class="customExercise-info" style="display: flex;" data-index="'+index+'">' +
		            		'<button class="dbtn" style="flex: 0.1;"><img src="src/images/logo/deleteBtn.png" width=10px height=10px /></button>'+
		            		'<div style="flex: 0.15;"></div>'+
			                '<div style="flex: 2.15;" class="ex_name">'+exercise.ex_name2+'</div>'+
			                '<input "flex: 0.3;" class="ex_time dark:bg-boxdark" type="number" readonly value="' + exercise.ex_time2 + '">'+
			                '<div style="flex: 0.6;"></div>'+
			                '<div "flex: 0.3;" class="ex_used_kcal">'+exercise.ex_used_kcal2+'</div>'+
			                '<div style="flex: 0.15;"></div>'+
			            '</div>';
		        	}
		        });
		        customExerciseHtml += '</div>';
		        $('#resultExercise2').html(customExerciseHtml);
		        calculateTotalTimeAndCalories();
	        },
	        error: function(jqXHR, textStatus, errorThrown) {
	            console.error('Fetch error:', errorThrown);
	            console.error('Server response:', jqXHR.responseText);
	        }
	    });
	}
	
	// 다이어로그 내 추가, 취소 버튼 클릭시
	$( function() {
		$( "#dialogContainer1" ).dialog({
			autoOpen: false,
			buttons: {
				"추가": function() {
					if ($('.select-checkbox:checked').length == 0) {
		                //alert('추가할 운동을 선택해주세요');
		                 swal({
			                  title: "주의!",
			                  text: "추가할 운동을 선택해주세요",
			                  icon: "warning",
			                  button: "확인",
			             });

		                return false;
		            }
					let exercises = [];
					let selectedDate = $('#datepicker').val();
					// 체크박스에 체크된 데이터들 서버로 넘김
					$("input.select-checkbox[type='checkbox']:checked").each(function() {
						let exerciseName = $(this).val();
						
						exercises.push(exerciseName);
					});
					$.ajax({
						url: '/exerciseAdd',  
						type: 'POST',
						data: JSON.stringify({ exercise: exercises, date: selectedDate }),
						contentType: "application/json",
						success: function(data) {
							//alert("운동등록에 성공했습니다. 운동 시간을 입력 한 뒤 칼로리 계산버튼을 눌러주세요.")
							swal({
				                  title: "성공!",
				                  text: "운동등록에 성공했습니다. 운동 시간을 입력 한 뒤 칼로리 계산버튼을 눌러주세요.",
				                  icon: "success",
				                  button: "확인",
				             });

							// db의 당일 운동 데이터 출력
							fetchExercises(selectedDate);
							
						},
						error: function(jqXHR, textStatus, errorThrown) {
							// 오류 처리
							//alert('운동등록에 실패했습니다'+ jqXHR.responseText)
							swal({
				                  title: "실패!",
				                  text: "운동등록에 실패했습니다",
				                  icon: "error",
				                  button: "확인",
				             });

							console.error('Server response:', jqXHR.responseText);
						}
        			});
					
					$( this ).dialog( "close" );
					$('#exerciseName1').val('');
		            $('#exerciseDiv1').empty()
				},
				"취소": function() {
					$( this ).dialog( "close" );
				}
			}
		});

		$( "#btn1" ).on( "click", function() {
			$( "#dialogContainer1" ).dialog( "open" );
		});
	});
	

	/* ㅡㅡㅡㅡ사용자 설정 운동 다이어로그 시작 ㅡㅡㅡㅡㅡ*/
	
	$( function() {
	    var dialog, form,
	 
	    dialog = $( "#dialog-form" ).dialog({
	        autoOpen: false,
	        height: 400,
	        width: 350,
	        modal: true,
	        buttons: {
	        	"추가": function() {
	                var name = $('#name').val();
	                var time = $('#time').val();
	                var calorie = $('#calorie').val();
	                if (name === '' ||time === '' ||calorie === '') {
	    		        //alert('추가할 운동 정보를 모두 입력해주세요');
	    		        swal({
	    	                  title: "주의!",
	    	                  text: "추가할 운동 정보를 모두 입력해주세요",
	    	                  icon: "warning",
	    	                  button: "확인",
	    	             });
	    		        return;
	    		    }
	                let selectedDate = $('#datepicker').val();
	                $.ajax({
	                    url: '/addCustomExercise',  
	                    type: 'POST',
	                    data: JSON.stringify({
	                        'ex_name': name,
	                        'ex_time': time,
	                        'ex_used_kcal': calorie,
	                        'selectedDate' : selectedDate
	                    }),
	                    contentType: "application/json; charset=utf-8", 
	                    dataType: "json", 
	                    success: function(response) {
	                    	//alert('운동등록에 성공했습니다');
	                    	 swal({
	                             title: "성공!",
	                             text: "운동등록에 성공했습니다",
	                             icon: "success",
	                             button: "확인",
	                        });

		                	fetchExercises(selectedDate)
	                    },
	                    error: function(jqXHR, textStatus, errorThrown) {
	                        //alert('운동 추가 실패: ' + errorThrown);
	                        swal({
	                            title: "실패!",
	                            text: "운동 추가 실패",
	                            icon: "error",
	                            button: "확인",
	                       });

	                        console.error('Server response:', jqXHR.responseText);
	                    }
	                });
	                dialog.dialog( "close" );
	            },
	            취소: function() {
	                dialog.dialog( "close" );
	            }
	        },
	        close: function() {
	            form[ 0 ].reset();
	        }
	    });
	
	    form = dialog.find( "form" ).on( "submit", function( event ) {
	        event.preventDefault();
	        dialog.dialog( "close" );
	    });
	
	    $( "#btn2" ).button().on( "click", function() {
	    	$( "#dialog-form" ).dialog( "open" );
	    });
	});
	
	
	// 당일 총 운동시간, 소모칼로리 구하기
	function calculateTotalTimeAndCalories() {
	    var totalExTime = 0;
	    var totalExUsedKcal = 0;
		//모든 운동시간 요소를 확인하여 값을 더함
	    $(".ex_time").each(function(){
	    	var val = $(this).val();
	        totalExTime += !isNaN(val) && val != '' ? parseInt(val, 10) : 0;
	    });
		// 모든 소모 칼로리 요소를 확인하여 값을 더함
	    $(".ex_used_kcal").each(function(){
	        totalExUsedKcal += parseInt($(this).text(), 10);
	    });
		
	    let totalHtml = '';
            totalHtml += 
            	'<div class="total ">' +
            	'<div style="width: 10px;"></div>'+
            	'<div style="width: 10px;"></div>'+
                '<div class="totalExtime">'+"&emsp;&emsp;"+totalExTime+'</div>'+
                '<div class="totalExUsedKcal">'+totalExUsedKcal+'</div>'+
	            '</div>';
        $('#total1').html(totalHtml);
		
	    // 여기서 totalExTime과 totalExUsedKcal을 원하는 곳에 표시하면 됩니다.
	    console.log("총 운동시간: " + totalExTime + " 분");
	    console.log("총 소모 칼로리: " + totalExUsedKcal + " Kcal");
	}
	
	// 다크모드 시 칼로리계산 이미지 밝기 낮추기 
	function checkDarkMode() {
		var darkModeCheckbox = document.getElementById('darkModeCheckbox');
	    var kcalImg = document.getElementById('kcalImg');
	    
	    if (darkModeCheckbox.checked) {
	        kcalImg.style.filter = 'brightness(50%)'; // 다크모드 ON시 이미지 밝기를 50%로 줄입니다.
	    } else {
	        kcalImg.style.filter = 'brightness(100%)'; // 다크모드 OFF시 이미지 밝기를 원래대로 복구합니다.
	    }
	}
	
	$(document).ready(function() {
		
		checkDarkMode();
		 
		imgSlide(); 
		displayImages();
		// 사진업로드
		$('#ufrm').submit(function(event) {
   			event.preventDefault(); // 기본 제출 동작 방지
   			const form = $(this);
   			const fileInput = form.find('input[type="file"]');
   			const formData = new FormData(form[0]);
   			console.log("제출시작")
   			if (!fileInput.val()) {
		        //alert("파일을 선택해주세요");
		        swal({
	                  title: "주의!",
	                  text: "파일을 선택해주세요",
	                  icon: "warning",
	                  button: "확인",
	             });
		        return;
		    }
			$.ajax({
			    url: '/exUpload', // 서버 URL을 실제 서버 주소로 변경해야 합니다.
			    type: 'POST',
			    data: formData,
			    processData: false,
			    contentType: false,
			    success: function(flag) {
			    	if(flag == 1 ){
			    		//alert("이미지 업로드에 성공했습니다")
			    		swal({
			                  title: "성공!",
			                  text: "이미지 업로드에 성공했습니다",
			                  icon: "success",
			                  button: "확인",
			             });

			    		form[0].reset();
			    	}else{
			    		//alert("이미지 업로드에 실패했습니다")
			    		swal({
			                  title: "실패!",
			                  text: "이미지 업로드에 실패했습니다",
			                  icon: "error",
			                  button: "확인",
			             });

			    	}
			    	imgSlide();
			    	displayImages();
			    },
			    error: function(xhr, status, error) {
			      console.error('요청 실패. 상태 코드:', xhr.status);
			    }
			  });
			});
		
		$('#ubtn').click(function(event) {
			event.preventDefault(); // 기본 제출 동작 방지
			$('#ufrm').submit(); // 폼 제출
		});
		
		//운동삭제
		$(document).on('click', '.exercise-info .dbtn', function(e) {
			e.preventDefault();
		    let parentDiv = $(this).parent();
		    let exerciseName = parentDiv.find('.ex_name').text();
		    let selectedDate = $('#datepicker').val();
		    $.ajax({
		        url: '/deleteExercise',
		        type: 'POST',
		        contentType: 'application/json',
		        data: JSON.stringify({ ex_name: exerciseName, ex_day: selectedDate }),
		        success: function(response) {
		            // 성공하면 리스트를 다시 불러옵니다.
		            fetchExercises(selectedDate);
		        },
		        error: function(error) {
		            console.error('Delete exercise error:', error);
		        }
		    });
		});
		
		//사용자 운동삭제
		$(document).on('click', '.customExercise-info .dbtn', function(e) {
			e.preventDefault();
		    let parentDiv = $(this).parent();
		    let exerciseName = parentDiv.find('.ex_name').text();
		    let selectedDate = $('#datepicker').val();
		    $.ajax({
		        url: '/deleteExercise',
		        type: 'POST',
		        contentType: 'application/json',
		        data: JSON.stringify({ ex_name: exerciseName, ex_day: selectedDate }),
		        success: function(response) {
		            // 성공하면 리스트를 다시 불러옵니다.
		            fetchExercises(selectedDate);
		        },
		        error: function(error) {
		            console.error('Delete customExercise error:', error);
		        }
		    });
		});
		
		// 달력
		var date = new Date();
	
	    // 'yyyy-mm-dd' 형태의 문자열로 변환
	    var day = ("0" + date.getDate()).slice(-2);
	    var month = ("0" + (date.getMonth() + 1)).slice(-2);
	    var today = date.getFullYear() + "-" + month + "-" + day;
	    var selectedDate = $('#datepicker').val();
	    
        $("#datepicker").datepicker({ 
            dateFormat: 'yy-mm-dd',
            onSelect: function(dateText) {
            	fetchExercises(dateText)
            }
        });
	    // 달력의 기본 값을 오늘 날짜로 설정
	    $("#datepicker").datepicker("setDate", today);
	    fetchExercises(today);
	    
	    
		// 운동 다이어로그 내 검색 버튼
		$('#searchButton1').click(function() {
			let searchEx = $("#exerciseName1").val();
			if (searchEx === '') {
		        //alert('운동종목을 입력해주세요');
		        swal({
	                  title: "주의!",
	                  text: "운동종목을 입력해주세요",
	                  icon: "warning",
	                  button: "확인",
	             });
		        return;
		    }
			// 검색한 단어 서버로 보내고 검색결과 데이터 받아옴
		    $.ajax({
		    	url: '/searchExercise',  
		    	type: 'POST',
		    	data: { mat_name: searchEx },
		    	success: function(data) {
		    		let searchResultsHtml = '';
		    		data.forEach(function(matTO) {
		    			// 각 검색 결과를 HTML 문자열로 변환합니다.
		    			searchResultsHtml += '<div><input type="checkbox" class="select-checkbox" value="' + matTO.mat_name + '"> ' + matTO.mat_name + '</div>';
		    		});
		    		// 검색 결과를 화면에 표시합니다.
		    		$('#exerciseDiv1').html(searchResultsHtml);
		    	},
		    	error: function(jqXHR, textStatus, errorThrown) {
		    		// 오류 처리
		    		console.error('Search error:', errorThrown);
		    	}
		    });
		    
		});
		
		$('#exerciseName1').on('keydown', function(e) {
		    if (e.which == 13) {  // 'Enter' 키의 키코드는 13입니다.
		        $('#searchButton1').click();  // 'Enter' 키를 누르면 '검색' 버튼을 클릭한 것처럼 동작합니다.
		    }
		});
		
		// 전체적용버튼-운동 시간대비 소모칼로리 계산하여 db저장후 출력
		$('#applyAll').click(function() {
			let selectedDate = $('#datepicker').val();
		    const exerciseItems = [];
		    $('.exercise-item .exercise-info').each(function() {
		        const exerciseInfo = $(this);
		        const ex_name = $('.ex_name', exerciseInfo).text();
		        const ex_time = $('.ex_time', exerciseInfo).val();
		        exerciseItems.push({ ex_name, ex_time });
		    });
		    $.ajax({
		        url: '/calculateCalories',
		        type: 'POST',
		        contentType: 'application/json',
		        data: JSON.stringify({ exerciseItems: exerciseItems, selectedDate: selectedDate }),
		        success: function(data) {
		            
		            $('.exercise-item .exercise-info').each(function(i) {
		                const exerciseInfo = $(this);
		                $('.ex_used_kcal', exerciseInfo).text(data[i].ex_used_kcal);
		            });
		            // 계산된 소모 칼로리 적용 후 총 운동시간, 소모 칼로리 업데이트
		            calculateTotalTimeAndCalories();
		            //alert("운동 시간 대비 소모 칼로리가 계산되었습니다")
		            swal({
		                  title: "성공!",
		                  text: "운동 시간 대비 소모 칼로리가 계산되었습니다",
		                  icon: "success",
		                  button: "확인",
		             });

		        },
		        error: function(jqXHR, textStatus, errorThrown) {
		            console.error('Calculation failed:', errorThrown);
		            console.error('Server response:', jqXHR.responseText);
		        }
		    });
		});
		
		
	});
	
</script>
</body>
</html>