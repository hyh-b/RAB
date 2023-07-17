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
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
<script src="https://code.jquery.com/ui/1.13.0/jquery-ui.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Swiper/4.5.1/js/swiper.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
<style type="text/css">
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

/*--------------- 다이어로그 창 시작----------------------------  */
  
  
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
        
    /*--------------- 다이어로그 창 끝----------------------------  */
    
    /*---------------  운동 시작----------------------------  */
    
    .exercise-list {
	    display: flex;
	    flex-wrap: wrap;
	    gap: 10px;
	}
	
	.exercise-info {
	    display: flex;
	    align-items: center;
	    gap: 10px;
	}
	
	.exercise-info .ex_name {
	    width: 200px;
	}
	
	.exercise-info .ex_time {
	    width: 100px;
	}
	
	.exercise-info .ex_used_kal {
	    width: 150px;
	}
	
	.ex_time_input {
	    width: 100px;
	    padding: 5px;
	     border: 2px solid black;
	    border-radius: 4px;
	    /* 추가적인 스타일링을 적용할 수 있습니다 */
	}
	
	.customExercise-info {
	    display: flex;
	    align-items: center;
	    gap: 10px;
	}
	
	.customExercise-info .ex_name {
	    width: 200px;
	}
	
	.customExercise-info .ex_time {
	    width: 100px;
	}
	
	.customExercise-info .ex_used_kal {
	    width: 150px;
	}
	
	/*---------------  운동 끝----------------------------  */
	
	/*---------------  당일 합계 시작----------------------------  */
	
	.total {
	    display: flex;
	    align-items: center;
	    gap: 10px;
	    margin-left: 700px;
	}
	
	.total .exTime {
	    width: 200px;
	}
	
	.total .exUsedKcal {
	    width: 100px;
	}
	
	/*---------------  당일 합계 시작----------------------------  */
</style>

<script type="text/javascript">

	window.onload = function(){
		 document.getElementById('ubtn').onclick = function(){
			
			if(document.ufrm.upload.value.trim()==''){
				alert('이미지를 첨부하셔야 합니다');
				return false;
			}
			document.ufrm.submit();
		} 
	}
</script>

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
  <div class="flex items-center justify-between gap-2 px-6 py-5.5 lg:py-6.5">
    <a href="/main.do">
    
   <!--  사이트 로고  -->

     <img src="src/images/logo/logo2.jpg" width="100%" height="100%" />
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

  <div
    class="no-scrollbar flex flex-col overflow-y-auto duration-300 ease-linear"
  >
    <!-- Sidebar Menu -->
    <nav
      class="mt-5 py-4 px-4 lg:mt-9 lg:px-6"
      x-data="{selected: 'Dashboard'}"
      x-init="
        selected = JSON.parse(localStorage.getItem('selected'));
        $watch('selected', value => localStorage.setItem('selected', JSON.stringify(value)))"
    >
    </nav>
      <!-- Menu Group -->
      <div>
        <h3 class="mb-4 ml-4 text-sm font-medium text-bodydark2">메뉴</h3>
        

        <ul class="mb-6 flex flex-col gap-1.5">
          <!-- Menu Item Dashboard -->

          <!-- Menu Item Calendar -->
          <li>
            <a
              class="group relative flex items-center gap-2.5 rounded-sm py-2 px-4 font-medium text-bodydark1 duration-300 ease-in-out hover:bg-graydark dark:hover:bg-meta-4"
              href="calendar.do"
              @click="selected = (selected === 'Calendar' ? '':'Calendar')"
              :class="{ 'bg-graydark dark:bg-meta-4': (selected === 'Calendar') && (page === 'calendar') }"
            >

            <img
      			class="fill-current"
      			src="/src/images/user/rocatNOb.png"
      			alt="비고.png"
      			width="24"
      			height="24"
   			/>

              공지사항
            </a>
          </li>
          <!-- Menu Item Calendar -->

          <!-- Menu Item Profile -->
          <li>
            <a
              class="group relative flex items-center gap-2.5 rounded-sm py-2 px-4 font-medium text-bodydark1 duration-300 ease-in-out hover:bg-graydark dark:hover:bg-meta-4"

              href="board_list.do"
              @click="selected = (selected === 'Profile' ? '':'Profile')"
              :class="{ 'bg-graydark dark:bg-meta-4': (selected === 'Profile') && (page === 'profile') }"
              :class="page === 'profile' && 'bg-graydark'"
            >
             <img
      			class="fill-current"
      			src="/src/images/user/rocatNOb.png"
      			alt="게시판.png"
      			width="24"
      			height="24"
   			/>
             	게시판
            </a>
          </li>
          <!-- Menu Item Profile -->

              <!-- Menu Item Profile2 -->
          <li>
            <a
              class="group relative flex items-center gap-2.5 rounded-sm py-2 px-4 font-medium text-bodydark1 duration-300 ease-in-out hover:bg-graydark dark:hover:bg-meta-4"
              href="food.do"
              @click="selected = (selected === 'Profile' ? '':'Profile')"
              :class="{ 'bg-graydark dark:bg-meta-4': (selected === 'Profile') && (page === 'profile') }"
              :class="page === 'profile' && 'bg-graydark'"
            >

               <img
      			class="fill-current"
      			src="/src/images/user/rocatNOb.png"
      			alt="식단.png"
      			width="24"
      			height="24"
   			/>
             	식단
            </a>
          </li>
          <!-- Menu Item Profile2 -->

          <!-- Menu Item Forms -->

          <!-- Menu Item Tables -->
          <li>
            <a
              class="group relative flex items-center gap-2.5 rounded-sm py-2 px-4 font-medium text-bodydark1 duration-300 ease-in-out hover:bg-graydark dark:hover:bg-meta-4"
              href="exercise.do"

              @click="selected = (selected === 'Tables' ? '':'Tables')"
              :class="{ 'bg-graydark dark:bg-meta-4': (selected === 'Tables') && (page === 'Tables') }"
            >
            <img
      			class="fill-current"
      			src="/src/images/user/rocatNOb.png"
      			alt="운동.png"
      			width="24"
      			height="24"
   			/>

              운동
            </a>
            
     
          </li>
          
          <!-- Menu Item Tables -->
		  <br/><br/>
          <!-- Menu Item Settings -->
 
           
        <li>
			<a
    			class="group relative flex items-center gap-2.5 rounded-sm py-2 px-4 font-medium text-bodydark1 duration-300 ease-in-out hover:bg-graydark dark:hover:bg-meta-4"
    			href="/klogout.do"
    			@click="selected = (selected === 'Settings' ? '':'Settings')"
    			:class="{ 'bg-graydark dark:bg-meta-4': (selected === 'Settings') && (page === 'settings') }"
    			:class="page === 'settings' && 'bg-graydark'"
 			>
   			<img
      			class="fill-current"
      			src="/src/images/user/rocatNOb.png"
      			alt="로그아웃"
      			width="24"
      			height="24"
   			/>
    			로그아웃
  			</a>
		</li>
          
          <!-- Menu Item Settings -->
        </ul>
      </div>

      <!-- Support Group -->
 
          <!-- Menu Item Messages -->
        
          <!-- Menu Item Chart -->
         
      
          <!-- Menu Item Chart -->

          <!-- Menu Item Ui Elements -->
        
          <!-- Menu Item Ui Elements -->

          <!-- Menu Item Auth Pages -->
          
            <!-- Dropdown Menu End -->
   
          <!-- Menu Item Auth Pages -->
       
    <!-- Sidebar Menu -->

    <!-- Promo Box -->

    <!-- Promo Box -->
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
        <img src="src/images/logo/" alt="홈 로고 추가해야되요" />
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

              ><%= m_name %></span
            >
            <span class="block text-xs font-medium"><%= m_gender %></span>
          </span>

          <span class="h-12 w-12 rounded-full">
          <!--  프로필 사진 업로드 파일 경로 설정 => C:/java/RAB-workspace/RABver/RABver/src/main/webapp/src/images/user -->
            <img src="src/images/user/gh.png" alt="User" />

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
              >
               <img
      			class="fill-current"
      			src="/src/images/user/rocatNOb.png"
      			alt="비고.png"
      			width="24"
      			height="24"
   			/>
                내 정보
              </a>
            </li>
          </ul>
          
          <button
            class="flex items-center gap-3.5 py-4 px-6 text-sm font-medium duration-300 ease-in-out hover:text-primary lg:text-base"
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
				<div class="flex items-center">
			    	<label class="font-medium text-black dark:text-white mr-4" style="padding-left: 50px; width: 650px;">
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
		            <form action="#" method="post" name="ffrm">
						<div id="total1"></div>
					</form>
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
		            <div class="flex items-center">
		                <div style="padding-left: 50px; width: 650px;" class="exercise-name-header">운동명</div>
		                <div class="exercise-time-header">운동 시간</div>&nbsp;&nbsp;
		                <button id="applyAll">모두 적용</button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		                <div class="calories-burned-header">소모 칼로리</div>
		            </div>
		        </div>
		        <div class="flex flex-col gap-5.5 p-6.5">
		            <div>
		                <form action="#" method="post" name="ffrm">
		                    <div id="resultExercise1" class="exercise-list"></div>
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
							    <p class="validateTips">모든 항목을 채워주세요.</p>
							    <form>
							        <fieldset>
							            <div>
							                <label for="name">운동명</label>
							                <input type="text" name="name" id="name" class="text ui-widget-content ui-corner-all">
							            </div>
							            <div>
							                <label for="time">운동 시간</label>
							                <input type="number" name="time" id="time" class="text ui-widget-content ui-corner-all">
							            </div>
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
						<div class="flex items-center">
					    	<div style="padding-left: 50px; width: 650px;" class="exercise-name-header">운동명</div>
				                <div class="exercise-time-header">운동 시간</div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				                <div class="calories-burned-header">소모 칼로리</div>
						</div>
					</div>
		            <div class="flex flex-col gap-5.5 p-6.5">
		            	<div>
				            <form action="#" method="post" name="ffrm">
								<div id="resultExercise2"></div>
							</form>
			        	</div>
		        	</div>
		        </div>
		        
		</div>
        
	<!-- =============================== 사용자설정 운동 끝 =========================== -->   
	     
	<!------------------ 이미지 업로드 시작---------------------------------------------------->
		  <form action="exerciseAlbum_ok.do" method="post" name="ufrm" enctype="multipart/form-data">
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
			            <input type="button" id="ubtn" value="upload"
			              	class="inline-flex items-center justify-center rounded-md border border-black py-4 px-10 text-center font-medium text-black hover:bg-opacity-90 lg:px-8 xl:px-10" style="cursor: pointer;"/>
			      	</div>
			  	</div>
			</div>
            </div>
			</form>
	<!------------------- 이미지 업로드 끝 ---------------------------------------------------->
			
	<!-------------------- 사진 전체보기 버튼 시작 ------------------------------------------------------>
			<a href="#" id="viewBtn"
                  class="button-view-all inline-flex items-center justify-center rounded-md border border-black py-4 px-10 text-center font-medium text-black hover:bg-opacity-90 lg:px-8 xl:px-10">
                  사진전체보기
                </a>
            </div>
   <!------------------------ 사진 전체보기 버튼 끝 ----------------------------------------->
		   
	<!---------------- 이미지 슬라이드 시작 ----------------------------------------->
			  <div class="swiper-container">
				<div class="swiper-wrapper">
				${sbHtml}
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

	// 이미지 슬라이드 설정
	new Swiper('.swiper-container', {
	
		slidesPerView : 3, // 동시에 보여줄 슬라이드 갯수
		spaceBetween : 30, // 슬라이드간 간격
		slidesPerGroup : 3, // 그룹으로 묶을 수, slidesPerView 와 같은 값을 지정하는게 좋음
	
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
	
	
	//   사진 전체보기 다이어로그 창 설정
	document.getElementById('viewBtn').addEventListener('click', function() {
		document.getElementById('photoDialog').style.display = 'block';
	});

	document.getElementById('closeDialogBtn').addEventListener('click', function() {
		document.getElementById('photoDialog').style.display = 'none';
	});
		
	let images = [
		<%= abHtml%>
	];

	let currentPage = 1;
	let imagesPerPage = 9;
	let numOfPages = Math.ceil(images.length / imagesPerPage);
	let selectedImage = null;
	let selectedImageValue = null;
	
	// 이미지 보이기
	function displayImages() {
		let start = (currentPage - 1) * imagesPerPage;
	    let end = start + imagesPerPage;
	    let imagesToDisplay = images.slice(start, end);

	    let html = '';
	    
	    for(let i = 0; i < imagesToDisplay.length; i++) {
	    	if (i % 3 === 0) {
	        	html += '<div style="display:flex">';
	        }
	        html += '<img src="' + imagesToDisplay[i].src + '" value="' + imagesToDisplay[i].aSeq + '" onclick="selectImage(this)" style="width: 100%; height: 100%; margin-bottom: 20px;">';
	        if ((i+1) % 3 === 0 || i+1 === imagesToDisplay.length) {
	        	html += '</div>';
	        }
	    }
	    document.getElementById('photoContainer').innerHTML = html;
	}
	
	// 이미지 선택 기능
	function selectImage(imageElement) {
		if (selectedImage) {
	    	selectedImage.style.border = 'none'; // Remove border from previously selected image
	    }
	        imageElement.style.border = '2px solid red'; // Add border to the selected image
	        selectedImage = imageElement;
	        selectedImageValue = imageElement.getAttribute('value');
	    }
		
	// 이미지 삭제
    function deleteImage() {
        if (!selectedImageValue) {
            alert('Please select an image to delete.');
            
	        return;
	    }
	        
	    $.ajax({
	    	url: '/album_delete.do',
	        method: 'POST',
	        data: {
	            aSeq: selectedImageValue
	        }
	    }).done(function(response) {
	        alert('이미지가 삭제되었습니다');
	        location.reload(); // 삭제데이터 반영을 위해 새로고침
	    }).fail(function() {
	        
	        alert('삭제에 실패했습니다');
	    }).always(function() {
	        // 실행 후 이미지 선택 해제
	        selectedImage.style.border = 'none';
	        selectedImage = null;
	        selectedImageValue = null;
	    });
	}
		
	document.getElementById('deleteBtn').addEventListener('click', deleteImage);
	    
	// 다음 페이지
	function handleNextPage() {
		if (currentPage < numOfPages) {
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

	document.getElementById('previousPageBtn').addEventListener('click', handlePreviousPage);
	document.getElementById('nextPageBtn').addEventListener('click', handleNextPage);

	displayImages(); 
	
	/*---------------운동 다이어로그 시작--------- */
	    
	$( function() {
		$( "#dialogContainer1" ).dialog({
			autoOpen: false,
			buttons: {
				"추가": function() {
					let exercises = [];
					let selectedDate = $('#datepicker').val();
					// 체크박스에 체크된 데이터들 서버로 넘김
					$("input[type='checkbox']:checked").each(function() {
						let exerciseName = $(this).val();
						exercises.push(exerciseName);
					});
					$.ajax({
						url: '/exerciseAdd',  
						type: 'POST',
						data: JSON.stringify({ exercise: exercises, date: selectedDate }),
						contentType: "application/json",
						success: function(data) {
							alert("운동등록에 성공했습니다.")
							// db의 당일 운동 데이터 출력
							// 데이터가 서버로 넘어간 뒤 db에 들어가기 까지 시간이 걸리기에 1초 뒤에 db데이터 보여줌
							setTimeout(function() {
								$.ajax({
								    url: '/viewExercise',
								    type: 'GET',
								    success: function(data) {
								        let exerciseHtml = '<div class="exercise-item">';
								        data.forEach(function(exercise, index) {
								            exerciseHtml += 
								            	// 각 행마다 인덱스 설정하여 구분
								            	'<div class="exercise-info" data-index="'+index+'">' +
									                '<div class="ex_name">'+exercise.ex_name+'</div>'+
									                '<input class="ex_time" value='+exercise.ex_time+' type="number" placeholder="Enter time">'+
									                '<div class="ex_used_kcal">'+exercise.ex_used_kcal+'</div>'+
									            '</div>';
								        });
								        exerciseHtml += '</div>';
								        $('#resultExercise1').html(exerciseHtml);
								    },
								    error: function(jqXHR, textStatus, errorThrown) {
								        console.error('Fetch error:', errorThrown);
								        console.error('Server response:', jqXHR.responseText);
								    }
								}); 
			                }, 1000);
							
						},
						error: function(jqXHR, textStatus, errorThrown) {
							// 오류 처리
							console.log("에러다 에러")
							alert('운동등록에 실패했습니다'+ jqXHR.responseText)
							console.error('Server response:', jqXHR.responseText);
						}
        			});
					
					$( this ).dialog( "close" );
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

	                $.ajax({
	                    url: '/addCustomExercise',  
	                    type: 'POST',
	                    data: JSON.stringify({
	                        'ex_name': name,
	                        'ex_time': time,
	                        'ex_used_kcal': calorie,
	                    }),
	                    contentType: "application/json; charset=utf-8", 
	                    dataType: "json", 
	                    success: function(response) {
	                    	alert('운동등록에 성공했습니다');
	                    	setTimeout(function() {
		                    	// db의 당일 사용자설정 운동 데이터 출력
		                		$.ajax({
		                		    url: '/viewCustomExercise',
		                		    type: 'GET',
		                		    success: function(data) {
		                		        let customExerciseHtml = '<div class="customExercise-item">';
		                		        data.forEach(function(exercise, index) {
		                		            customExerciseHtml += 
		                		            	// 각 행마다 인덱스 설정하여 구분
		                		            	'<div class="customExercise-info" data-index="'+index+'">' +
		                			                '<div class="ex_name">'+exercise.ex_name+'</div>'+
		                			                '<input class="ex_time" type="number" readonly value="' + exercise.ex_time + '">'+
		                			                '<div class="ex_used_kcal">'+exercise.ex_used_kcal+'</div>'+
		                			            '</div>';
		                		        });
		                		        customExerciseHtml += '</div>';
		                		        $('#resultExercise2').html(customExerciseHtml);
		                		     	// 사용자설정 운동 데이터 출력완료시 총 운동시간, 소모칼로리 업데이트
		                		        calculateTotalTimeAndCalories();
		                		    },
		                		    error: function(jqXHR, textStatus, errorThrown) {
		                		        console.error('Fetch error:', errorThrown);
		                		        console.error('Server response:', jqXHR.responseText);
		                		    }
		                		}); 
			                }, 1000);
	                    },
	                    error: function(jqXHR, textStatus, errorThrown) {
	                        alert('운동 추가 실패: ' + errorThrown);
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
	        dialog.dialog( "open" );
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
            	'<div class="total">' +
	                '<div class="totalExtime">'+totalExTime+'</div>'+
	                '<div class="totalExUsedKcal">'+totalExUsedKcal+'</div>'+
	            '</div>';
        $('#total1').html(totalHtml);

	    // 여기서 totalExTime과 totalExUsedKcal을 원하는 곳에 표시하면 됩니다.
	    console.log("총 운동시간: " + totalExTime + " 분");
	    console.log("총 소모 칼로리: " + totalExUsedKcal + " Kcal");
	}
	
	
	$(document).ready(function() {
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
                $.ajax({
                    url: '/viewExercise',
                    type: 'GET',
                    data: { selectedDate: dateText },
                    success: function(data) {
                        let exerciseHtml = '<div class="exercise-item">';
                        data.forEach(function(exercise, index) {
                        	if (exercise.ex_name) {
	                            exerciseHtml += 
	                            '<div class="exercise-info" data-index="'+index+'">' +
	                                '<div class="ex_name">'+exercise.ex_name+'</div>'+
	                                '<input class="ex_time" value='+exercise.ex_time+' type="number" placeholder="Enter time">'+
	                                '<div class="ex_used_kcal">'+exercise.ex_used_kcal+'</div>'+
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
        		            	'<div class="customExercise-info" data-index="'+index+'">' +
        			                '<div class="ex_name">'+exercise.ex_name2+'</div>'+
        			                '<input class="ex_time" type="number" readonly value="' + exercise.ex_time2 + '">'+
        			                '<div class="ex_used_kcal">'+exercise.ex_used_kcal2+'</div>'+
        			            '</div>';
        		        	}
        		        });
        		        customExerciseHtml += '</div>';
        		        $('#resultExercise2').html(customExerciseHtml);
                    },
                    error: function(jqXHR, textStatus, errorThrown) {
                        console.error('Fetch error:', errorThrown);
                        console.error('Server response:', jqXHR.responseText);
                    }
                });
            }
        });
	    // 달력의 기본 값을 오늘 날짜로 설정
	    $("#datepicker").datepicker("setDate", today);
		
		// 운동 다이어로그 내 검색 버튼
		$('#searchButton1').click(function() {
			let searchEx = $("#exerciseName1").val();
			// 검색한 단어 서버로 보내고 검색결과 데이터 받아옴
		    $.ajax({
		    	url: '/searchExercise',  
		    	type: 'POST',
		    	data: { mat_name: searchEx },
		    	success: function(data) {
		    		let searchResultsHtml = '';
		    		data.forEach(function(matTO) {
		    			// 각 검색 결과를 HTML 문자열로 변환합니다.
		    			searchResultsHtml += '<div><input type="checkbox" value="' + matTO.mat_name + '"> ' + matTO.mat_name + '</div>';
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
		// db의 당일 운동 데이터 출력
		$.ajax({
		    url: '/viewExercise',
		    type: 'GET',
		    success: function(data) {
		        let exerciseHtml = '<div class="exercise-item">';
		        data.forEach(function(exercise, index) {
		            exerciseHtml += 
		            	// 각 행마다 인덱스 설정하여 구분
		            	'<div class="exercise-info" data-index="'+index+'">' +
			                '<div class="ex_name">'+exercise.ex_name+'</div>'+
			                '<input class="ex_time" value='+exercise.ex_time+' type="number" placeholder="Enter time">'+
			                '<div class="ex_used_kcal">'+exercise.ex_used_kcal+'</div>'+
			            '</div>';
		        });
		        exerciseHtml += '</div>';
		        $('#resultExercise1').html(exerciseHtml);
		    },
		    error: function(jqXHR, textStatus, errorThrown) {
		        console.error('Fetch error:', errorThrown);
		        console.error('Server response:', jqXHR.responseText);
		    }
		}); 
		
		// db의 당일 사용자설정 운동 데이터 출력
		$.ajax({
		    url: '/viewCustomExercise',
		    type: 'GET',
		    success: function(data) {
		        let customExerciseHtml = '<div class="customExercise-item">';
		        data.forEach(function(exercise, index) {
		            customExerciseHtml += 
		            	// 각 행마다 인덱스 설정하여 구분
		            	'<div class="customExercise-info" data-index="'+index+'">' +
			                '<div class="ex_name">'+exercise.ex_name+'</div>'+
			                '<input class="ex_time" type="number" readonly value="' + exercise.ex_time + '">'+
			                '<div class="ex_used_kcal">'+exercise.ex_used_kcal+'</div>'+
			            '</div>';
		        });
		        customExerciseHtml += '</div>';
		        $('#resultExercise2').html(customExerciseHtml);
		        // 운동 데이터 출력완료시 총 운동시간, 소모칼로리 출력
		        calculateTotalTimeAndCalories();
		    },
		    error: function(jqXHR, textStatus, errorThrown) {
		        console.error('Fetch error:', errorThrown);
		        console.error('Server response:', jqXHR.responseText);
		    }
		}); 
		
		// 전체적용버튼-운동 시간대비 소모칼로리 계산하여 db저장후 출력
		$('#applyAll').click(function() {
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
		        data: JSON.stringify(exerciseItems),
		        success: function(data) {
		            
		            $('.exercise-item .exercise-info').each(function(i) {
		                const exerciseInfo = $(this);
		                $('.ex_used_kcal', exerciseInfo).text(data[i].ex_used_kcal);
		            });
		            // 계산된 소모 칼로리 적용 후 총 운동시간, 소모 칼로리 업데이트
		            calculateTotalTimeAndCalories();
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