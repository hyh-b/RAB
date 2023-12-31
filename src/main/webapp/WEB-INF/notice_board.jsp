<%@page import="com.example.model.NoticeBoardTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="listTO" value="${requestScope.listTO}"/>
<c:set var="cpage" value="${requestScope.cpage}"/>
<c:set var="data" value="${requestScope.data}"/>
<c:set var="filename" value="${requestScope.filename}"/>

<c:set var="groupSize" value="5" />
<c:set var="groupCounter" value="0" />
<c:set var="totalRecord" value="${listTO.totalRecord}"/>
<c:set var="recordPerPage" value="${listTO.recordPerPage }"/>
<c:set var="totalPage" value="${listTO.totalPage }"/>
<c:set var="blockPerPage" value="${listTO.blockPerPage }"/>
<c:set var="endBlock" value="${cpage - ((cpage-1) mod blockPerPage) + blockPerPage -1 }"/>		

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>공지사항</title>
<link rel="icon" href="favicon.ico"><link href="style.css" rel="stylesheet">
<script src="https://kit.fontawesome.com/efe58e199b.js" crossorigin="anonymous"></script>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
<link rel="stylesheet" href="https://code.jquery.com/ui/1.13.0/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/ui/1.13.0/jquery-ui.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">

<style>
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
    /* 추가한 CSS 스타일 */
    table {
        border-collapse: collapse;
    }
    table, th, td {
        border: 2px solid black;
    }
    
    @keyframes bounce {
	    0%, 20%, 50%, 80%, 100% {
	        transform: translateY(0);
	    }
	    40% {
	        transform: translateY(-20px);
	    }
	    60% {
	        transform: translateY(-10px);
	    }
	}
	
	.bounce:hover {
	    animation: bounce 1s infinite;
	}
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
  <div class="flex items-center justify-between gap-2 px-6 py-5.5 lg:py-6.5" style="padding-left: 59px; padding-bottom: 0px;padding-top: 40px;">
    <a href="/main.do">
<!--       <img src="src/images/logo/배경로고2.png" width="100%" height="100%" /> -->
		<i class="fa-solid fa-rocket bounce fa-10x" style="padding-top: 20px;"></i>
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
	      <h3 class="mb-4 ml-4 text-sm font-medium text-bodydark2" style="padding-left: 45px; padding-top: 0px;">Menu</h3>
		  <hr class="theme1">
	
	      <ul class="mb-6 flex flex-col gap-1.5">
	        <!-- Menu Item Dashboard -->
	     <li class="sideMenu" style="height: 50px; padding-top: 20px;">
	      <a
	         href="notice_board.do"
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
	          href="board_list1.do"
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
      <header class="sticky top-0 z-999 flex w-full bg-white drop-shadow-1 dark:bg-boxdark dark:drop-shadow-none">
  		<div class="flex flex-grow items-center justify-between py-4 px-4 shadow-2 md:px-6 2xl:px-11">
    <div class="flex items-center gap-2 sm:gap-4 lg:hidden">
      <!-- Hamburger Toggle BTN 로고메뉴-->
      <button
        class="z-99999 block rounded-sm border border-stroke bg-white p-1.5 shadow-sm dark:border-strokedark dark:bg-boxdark lg:hidden"
        @click.stop="sidebarToggle = !sidebarToggle"
      >
      	<!-- 아이콘을 여기에 추가 -->
    	<i class="fa-solid fa-rocket bounce fa-xl"></i>
      </button>
      <!-- Hamburger Toggle BTN 히든-->
      <a class="block flex-shrink-0 lg:hidden" href="index.html">
<!--         <img src="src/images/logo/logo-icon.svg" alt="Logo" /> -->
<!-- 		<i class="fa-solid fa-rocket bounce fa-xl"></i> -->
      </a>
    </div>
    
    <div class="hidden sm:block">
    </div>

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
                    d="M8.00008 15.3067C7.63341 15.3067 7.33342 15.0334 7.33342 14.6667V14.6134C7.33342 14.2467 7.63341 13.9467 8.00008 13.9467C8.36675 13.9467 8.66675 14.2467 8.66675 14.6134C8.66675 14.9801 8.36675 15.3067 8.00008 15.3067ZM12.7601 13.4267C12.5867 13.4267 12.4201 13.3601 12.2867 13.2334L12.2001 13.1467C11.9401 12.8867 11.9401 12.4667 12.2001 12.2067C12.4601 11.9467 12.8801 11.9467 13.1401 12.2067L13.2267 12.2934C13.4867 12.5534 13.4867 12.9734 13.2267 13.2334C13.1001 13.3601 12.9334 13.4267 12.7601 13.4267ZM3.24008 13.4267C3.06675 13.4267 2.90008 13.3601 2.76675 13.2334C2.50675 12.9734 2.50675 12.5534 2.76675 12.2934L2.85342 12.2067C3.11342 11.9467 3.53341 11.9467 3.79341 12.2067C4.05341 12.4667 4.05341 12.8867 3.79341 13.1467L3.70675 13.2334C3.58008 13.3601 3.40675 13.4267 3.24008 13.4267ZM14.6667 8.66675H14.6134C14.2467 8.66675 13.9467 8.36675 13.9467 8.00008C13.9467 7.63341 14.2467 7.33342 14.6134 7.33342C14.9801 7.33342 15.3067 7.63341 15.3067 8.00008C15.3067 8.36675 15.0334 8.66675 14.6667 8.66675ZM1.38675 8.66675H1.33341C0.966748 8.66675 0.666748 8.36675 0.666748 8.00008C0.666748 7.63341 0.966748 7.33342 1.33341 7.33342C1.70008 7.33342 2.02675 7.63341 2.02675 8.00008C2.02675 8.36675 1.75341 8.66675 1.38675 8.66675ZM12.6734 3.99341C12.5001 3.99341 12.3334 3.92675 12.2001 3.80008C11.9401 3.54008 11.9401 3.12008 12.2001 2.86008L12.2867 2.77341C12.5467 2.51341 12.9667 2.51341 13.2267 2.77341C13.4867 3.03341 13.4867 3.45341 13.2267 3.71341L13.1401 3.80008C13.0134 3.92675 12.8467 3.99341 12.6734 3.99341ZM3.32675 3.99341C3.15341 3.99341 2.98675 3.92675 2.85342 3.80008L2.76675 3.70675C2.50675 3.44675 2.50675 3.02675 2.76675 2.76675C3.02675 2.50675 3.44675 2.50675 3.70675 2.76675L3.79341 2.85342C4.05341 3.11342 4.05341 3.53341 3.79341 3.79341C3.66675 3.92675 3.49341 3.99341 3.32675 3.99341ZM8.00008 2.02675C7.63341 2.02675 7.33342 1.75341 7.33342 1.38675V1.33341C7.33342 0.966748 7.63341 0.666748 8.00008 0.666748C8.36675 0.666748 8.66675 0.966748 8.66675 1.33341C8.66675 1.70008 8.36675 2.02675 8.00008 2.02675Z"
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
          <!-- Dark Mode Toggler -->
        </li>

        <!-- Notification Menu Area -->
        
        <!-- Notification Menu Area -->

        <!-- Chat Notification Area -->
        
        <!-- Chat Notification Area -->
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

              >${zzinnickname}</span
            >
            <!-- 
            <span class="block text-xs font-medium"></span>
			 -->	          
          </span>

          <span class="h-12 w-12 rounded-full">
          <!--  프로필 사진 업로드 파일 경로 설정 => C:/java/RAB-workspace/RABver/RABver/src/main/webapp/src/images/user -->
            <img src="https://rabfile.s3.ap-northeast-2.amazonaws.com/${profilename}" alt="User" />

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
   <!-- ============  게시판 여기부터 시작	=================================== -->
  <table >
       <h2 class="mt-10 mb-7.5 text-title-md2 font-bold text-black dark:text-white">
            공지사항
          </h2>     
		<div class="grid grid-cols-1 gap-7.5 sm:grid-cols-1 xl:grid-cols-1">
		    <div class="rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark">
		        <table style="width: 100%;" class="rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark">
		            <thead>
		                <tr>
		                    <th class="text-xl font-semibold text-black dark:text-white" style="width: 10%;">번호</th>
		                    <th class="text-xl font-semibold text-black dark:text-white" style="width: 60%;">제목</th>
		                    <th class="text-xl font-semibold text-black dark:text-white" style="width: 15%;">작성일</th>
		                    <th class="text-xl font-semibold text-black dark:text-white" style="width: 15%;">조회수</th>
		                </tr>
		            </thead>
		            <tbody>
		                <c:forEach var="noticeBoard" items="${noticeBoardList}">
		                    <tr>
		                        <td style="text-align: center;">${noticeBoard.n_seq}</td>
		                       <td><a href="/notice_board_view.do?cpage=${cpage}&n_seq=${noticeBoard.n_seq}">${noticeBoard.n_subject}</a></td>
		                        <td style="text-align: center;">${noticeBoard.n_wdate}</td>
		                        <td style="text-align: center;">${noticeBoard.n_hit}</td>
		                    </tr>
		                </c:forEach>
		            </tbody>		            
  			</table>		
			
		
        <!--=======  페이징 시작 =========================================-->
		<div style="display: flex; justify-content: center;">
				<div class="paginate_regular">
					<div class="board_pagetab">				
					<c:set var="startBlock" value="${cpage - ((cpage-1) mod blockPerPage)}" />
					<c:if test="${endBlock >= totalPage}">
					  <c:set var="endBlock" value="${totalPage}" />
					</c:if>
					
					<c:choose>
					  <c:when test="${startBlock == 1}">
					    <span><a>&lt;&lt;</a></span>
					  </c:when>
					  <c:otherwise>
					    <span><a href="/notice_board.do?cpage=${startBlock - blockPerPage}">&lt;&lt;</a></span>
					  </c:otherwise>
					</c:choose>
					&nbsp;
					<c:choose>
					  <c:when test="${cpage == 1}">
					    <span><a>&lt;</a></span>
					  </c:when>
					  <c:otherwise>
					    <span><a href="/notice_board.do?cpage=${cpage - 1}">&lt;</a></span>
					  </c:otherwise>
					</c:choose>
					&nbsp;
					<c:forEach begin="${startBlock}" end="${endBlock}" var="i">
					  <c:choose>
					    <c:when test="${i eq cpage}">
					      <span><a>[${i}]</a></span>
					    </c:when>
					    <c:otherwise>
					      <span><a href="/notice_board.do?cpage=${i}">${i}</a></span>
					    </c:otherwise>
					  </c:choose>
					</c:forEach>
					&nbsp;
					<c:choose>
					  <c:when test="${cpage == totalPage}">
					    <span><a>&gt;</a></span>
					  </c:when>
					  <c:otherwise>
					    <span><a href="/notice_board.do?cpage=${cpage + 1}">&gt;</a></span>
					  </c:otherwise>
					</c:choose>	
					&nbsp;
					
					<c:choose>
					  <c:when test="${endBlock == totalPage}">
					    <span><a>&gt;&gt;</a></span>
					  </c:when>
					  <c:otherwise>
					    <span><a href="/notice_board.do?cpage=${startBlock + blockPerPage}">&gt;&gt;</a></span>
					  </c:otherwise>
					</c:choose>		
					</div>
				</div>
			</div>
				</div>
			</div>
		</table>
	</main>

	   <!--=======  페이징 끝 =========================================-->
	    <!-- ============  게시판 여기서 끝=================================== -->
		
				
      <!-- ===== Main Content End ===== -->
    </div>
    <!-- ===== Content Area End ===== -->
  </div>
  <!-- ===== Page Wrapper End ===== -->

<script defer src="bundle.js"></script>
</body>

</html>