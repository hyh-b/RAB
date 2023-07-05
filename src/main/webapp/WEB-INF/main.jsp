<%@page import="java.math.BigDecimal"%>
<%@page import="com.example.model.MainTO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>
     with RAB - 당신의 몸을 상승시키세요
    </title>
  <link rel="icon" href="favicon.ico"><link href="style.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/apexcharts@3.28.3"></script>

  </head>

  
  <!-- jstl 로 lists 받아옴 -->
 <c:forEach var="item" items="${lists}">
   <c:set var="i_seq" value="${item.i_seq}" />
   <c:set var="i_kcal" value="${item.i_kcal}" />
   <c:set var="i_carbohydrate_g" value="${item.i_carbohydrate_g}" />
   <c:set var="i_protein_g" value="${item.i_protein_g}" />
   <c:set var="i_fat_g" value="${item.i_fat_g}" />
   <c:set var="i_sugar_g" value="${item.i_sugar_g}" />
   <c:set var="i_cholesterol_mgl" value="${item.i_cholesterol_mgl}" />
   <c:set var="i_sodium_mg" value="${item.i_sodium_mg}" />
   <c:set var="i_trans_fat_g" value="${item.i_trans_fat_g}" />
   <c:set var="i_day" value="${item.i_day}" />
   <c:set var="i_used_kcal" value="${item.i_used_kcal}" />
   <c:set var="m_weight" value="${item.m_weight}"/>
   <c:set var="m_target_weight" value="${item.m_target_weight}"/>
   <c:set var="totarget" value="${item.m_weight- item.m_target_weight}" />
   <c:set var="m_name" value="${item.m_name}" />
</c:forEach>

<!--  
<c:forEach var="data" items="${datas}">
	<c:set var="d_seq" value="${data.d_seq}" />
	<c:set var="e_seq" value="${data.e_seq}" />
	<c:set var="d_kcal" value="${data.d_kcal}" />
	<c:set var="d_day" value="${data.d_day}" />

	<c:set var="b_seq" value="${data.b_seq}" />
	<c:set var="b_kcal" value="${data.b_kcal}" />
	<c:set var="b_day" value="${data.b_day}" />

	<c:set var="l_seq" value="${data.l_seq}" />
	<c:set var="l_kcal" value="${data.l_kcal}" />
	<c:set var="l_day" value="${data.l_day}" />

</c:forEach>

-->

<!--  sign in 에서 데이터
<c:forEach var="user" items="${users}">
   <c:set var="m_name" value="${user.m_name}" />
</c:forEach>
-->

</head>

 
  <body
    x-data="{ page: 'analytics', 'loaded': true, 'darkMode': true, 'stickyMenu': false, 'sidebarToggle': false, 'scrollTop': false }"
    x-init="
         darkMode = JSON.parse(localStorage.getItem('darkMode'));
         $watch('darkMode', value => localStorage.setItem('darkMode', JSON.stringify(value)))"
    :class="{'dark text-bodydark bg-boxdark-2': darkMode === true}"
  >
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
    <a href="/">
   <!--  사이트 로고  -->


     <img src="src/images/logo/rocatNOb.png" width="50%" height="50%" />
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
              href="profile.do"
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
              href="tables.do"
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
         
         <!-- 
          <li>
            <a
              class="group relative flex items-center gap-2.5 rounded-sm py-2 px-4 font-medium text-bodydark1 duration-300 ease-in-out hover:bg-graydark dark:hover:bg-meta-4"
              href="/logout"

              @click="selected = (selected === 'Settings' ? '':'Settings')"
              :class="{ 'bg-graydark dark:bg-meta-4': (selected === 'Settings') && (page === 'settings') }"
              :class="page === 'settings' && 'bg-graydark'"
            >
              <svg
                class="fill-current"
                width="18"
                height="19"
                viewBox="0 0 18 19"
                fill="none"
                xmlns="http://www.w3.org/2000/svg"
              >
                <g clip-path="url(#clip0_130_9763)">

            	<a href="/logout">로그아웃</a>
            </a>
          </li>
=======
            	로그아웃
            </a>
          </li>
          
          <li>
           -->
           
        <li>
			<a
    			class="group relative flex items-center gap-2.5 rounded-sm py-2 px-4 font-medium text-bodydark1 duration-300 ease-in-out hover:bg-graydark dark:hover:bg-meta-4"
    			href="/logout"
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
      <div
        class="relative flex flex-1 flex-col overflow-y-auto overflow-x-hidden"
      >
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
      <a class="block flex-shrink-0 lg:hidden" href="index.jsp">
        <img src="src/images/logo/logo-icon.svg" alt="Logo" />
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

              >${m_name}</span
            >
            <span class="block text-xs font-medium">직업란 쓰시렵니까들?</span>
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
            
            <!--  연락처 
            <li>
              <a
                href="contact.do"

                class="flex items-center gap-3.5 text-sm font-medium duration-300 ease-in-out hover:text-primary lg:text-base"
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
                    d="M17.6687 1.44374C17.1187 0.893744 16.4312 0.618744 15.675 0.618744H7.42498C6.25623 0.618744 5.25935 1.58124 5.25935 2.78437V4.12499H4.29685C3.88435 4.12499 3.50623 4.46874 3.50623 4.91562C3.50623 5.36249 3.84998 5.70624 4.29685 5.70624H5.25935V10.2781H4.29685C3.88435 10.2781 3.50623 10.6219 3.50623 11.0687C3.50623 11.4812 3.84998 11.8594 4.29685 11.8594H5.25935V16.4312H4.29685C3.88435 16.4312 3.50623 16.775 3.50623 17.2219C3.50623 17.6687 3.84998 18.0125 4.29685 18.0125H5.25935V19.25C5.25935 20.4187 6.22185 21.4156 7.42498 21.4156H15.675C17.2218 21.4156 18.4937 20.1437 18.5281 18.5969V3.47187C18.4937 2.68124 18.2187 1.95937 17.6687 1.44374ZM16.9469 18.5625C16.9469 19.2844 16.3625 19.8344 15.6406 19.8344H7.3906C7.04685 19.8344 6.77185 19.5594 6.77185 19.2156V17.875H8.6281C9.0406 17.875 9.41873 17.5312 9.41873 17.0844C9.41873 16.6375 9.07498 16.2937 8.6281 16.2937H6.77185V11.7906H8.6281C9.0406 11.7906 9.41873 11.4469 9.41873 11C9.41873 10.5875 9.07498 10.2094 8.6281 10.2094H6.77185V5.63749H8.6281C9.0406 5.63749 9.41873 5.29374 9.41873 4.84687C9.41873 4.39999 9.07498 4.05624 8.6281 4.05624H6.77185V2.74999C6.77185 2.40624 7.04685 2.13124 7.3906 2.13124H15.6406C15.9844 2.13124 16.2937 2.26874 16.5687 2.50937C16.8094 2.74999 16.9469 3.09374 16.9469 3.43749V18.5625Z"
                    fill=""
                  />
                </svg>
                연락처
              </a>
            </li>

             -->
            <li>
              <a
                href="settings.do"
                class="flex items-center gap-3.5 text-sm font-medium duration-300 ease-in-out hover:text-primary lg:text-base"
              >
               <img
      			class="fill-current"
      			src="/src/images/user/rocatNOb.png"
      			alt="비고.png"
      			width="24"
      			height="24"
   			/>

                정보 수정
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
            <a href="/logout">로그아웃</a>
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
          <div class="mx-auto max-w-screen-2xl p-4 md:p-6 2xl:p-10">
            <div
              class="grid grid-cols-1 gap-4 md:grid-cols-2 md:gap-6 xl:grid-cols-4 2xl:gap-7.5"
            >
              <!-- Card Item Start -->
              <div
                class="rounded-sm border border-stroke bg-white py-6 px-7.5 shadow-default dark:border-strokedark dark:bg-boxdark"
              >
                <div
                  class="flex h-11.5 w-11.5 items-center justify-center rounded-full bg-meta-2 dark:bg-meta-4"
                >
                	<!-- 로고 -->
					<svg
					  class="fill-primary dark:fill-white"
					  width="22"
					  height="16"
					  viewBox="0 0 22 16"
					  fill="none"
					  xmlns="http://www.w3.org/2000/svg"
					>
					  <img src="src/images/logo/calendar.png" width="100%" height="100%" />
					</svg>

                    <path
                      d="M11 15.1156C4.19376 15.1156 0.825012 8.61876 0.687512 8.34376C0.584387 8.13751 0.584387 7.86251 0.687512 7.65626C0.825012 7.38126 4.19376 0.918762 11 0.918762C17.8063 0.918762 21.175 7.38126 21.3125 7.65626C21.4156 7.86251 21.4156 8.13751 21.3125 8.34376C21.175 8.61876 17.8063 15.1156 11 15.1156ZM2.26876 8.00001C3.02501 9.27189 5.98126 13.5688 11 13.5688C16.0188 13.5688 18.975 9.27189 19.7313 8.00001C18.975 6.72814 16.0188 2.43126 11 2.43126C5.98126 2.43126 3.02501 6.72814 2.26876 8.00001Z"
                      fill=""
                    />
                    <path
                      d="M11 10.9219C9.38438 10.9219 8.07812 9.61562 8.07812 8C8.07812 6.38438 9.38438 5.07812 11 5.07812C12.6156 5.07812 13.9219 6.38438 13.9219 8C13.9219 9.61562 12.6156 10.9219 11 10.9219ZM11 6.625C10.2437 6.625 9.625 7.24375 9.625 8C9.625 8.75625 10.2437 9.375 11 9.375C11.7563 9.375 12.375 8.75625 12.375 8C12.375 7.24375 11.7563 6.625 11 6.625Z"
                      fill=""
                    />
                  </svg>
                </div>

                <div class="mt-4 flex items-end justify-between">
                  <div>
                    <h4
                      class="text-title-md font-bold text-black dark:text-white"
                    >

                   ${i_day}
                    </h4>
                    <span class="text-sm font-medium"><a href="calendar.do"><u> 날짜를 선택하세요 </u></a></span>

                  </div>

                </div>
              </div>
              <!-- Card Item End -->

              <!-- Card Item Start -->
              <div
                class="rounded-sm border border-stroke bg-white py-6 px-7.5 shadow-default dark:border-strokedark dark:bg-boxdark"
              >
                <div
                  class="flex h-11.5 w-11.5 items-center justify-center rounded-full bg-meta-2 dark:bg-meta-4"
                >
                  <!-- 로고 -->
					<svg
					  class="fill-primary dark:fill-white"
					  width="22"
					  height="16"
					  viewBox="0 0 22 16"
					  fill="none"
					  xmlns="http://www.w3.org/2000/svg"
					>
					  <img src="src/images/logo/foodicon.png" width="100%" height="100%" />
					</svg>

                    <path
                      d="M11 15.1156C4.19376 15.1156 0.825012 8.61876 0.687512 8.34376C0.584387 8.13751 0.584387 7.86251 0.687512 7.65626C0.825012 7.38126 4.19376 0.918762 11 0.918762C17.8063 0.918762 21.175 7.38126 21.3125 7.65626C21.4156 7.86251 21.4156 8.13751 21.3125 8.34376C21.175 8.61876 17.8063 15.1156 11 15.1156ZM2.26876 8.00001C3.02501 9.27189 5.98126 13.5688 11 13.5688C16.0188 13.5688 18.975 9.27189 19.7313 8.00001C18.975 6.72814 16.0188 2.43126 11 2.43126C5.98126 2.43126 3.02501 6.72814 2.26876 8.00001Z"
                      fill=""
                    />
                    <path
                      d="M11 10.9219C9.38438 10.9219 8.07812 9.61562 8.07812 8C8.07812 6.38438 9.38438 5.07812 11 5.07812C12.6156 5.07812 13.9219 6.38438 13.9219 8C13.9219 9.61562 12.6156 10.9219 11 10.9219ZM11 6.625C10.2437 6.625 9.625 7.24375 9.625 8C9.625 8.75625 10.2437 9.375 11 9.375C11.7563 9.375 12.375 8.75625 12.375 8C12.375 7.24375 11.7563 6.625 11 6.625Z"
                      fill=""
                    />
                  </svg>
                </div>

                <div class="mt-4 flex items-end justify-between">
                  <div>
                    <h4
                      class="text-title-md font-bold text-black dark:text-white"
                    >

                     ${i_kcal} kcal
                    </h4>
                    <span class="text-sm font-medium">섭취 칼로리</span>

                  </div>

                </div>
              </div>
              <!-- Card Item End -->

              <!-- Card Item Start -->
              <div
                class="rounded-sm border border-stroke bg-white py-6 px-7.5 shadow-default dark:border-strokedark dark:bg-boxdark"
              >
                <div
                  class="flex h-11.5 w-11.5 items-center justify-center rounded-full bg-meta-2 dark:bg-meta-4"
                >
                 	<!-- 로고 -->
					<svg
					  class="fill-primary dark:fill-white"
					  width="22"
					  height="16"
					  viewBox="0 0 22 16"
					  fill="none"
					  xmlns="http://www.w3.org/2000/svg"
					>
					  <img src="src/images/logo/exercise.png" width="100%" height="100%" />
					</svg>

                    <path
                      d="M11 15.1156C4.19376 15.1156 0.825012 8.61876 0.687512 8.34376C0.584387 8.13751 0.584387 7.86251 0.687512 7.65626C0.825012 7.38126 4.19376 0.918762 11 0.918762C17.8063 0.918762 21.175 7.38126 21.3125 7.65626C21.4156 7.86251 21.4156 8.13751 21.3125 8.34376C21.175 8.61876 17.8063 15.1156 11 15.1156ZM2.26876 8.00001C3.02501 9.27189 5.98126 13.5688 11 13.5688C16.0188 13.5688 18.975 9.27189 19.7313 8.00001C18.975 6.72814 16.0188 2.43126 11 2.43126C5.98126 2.43126 3.02501 6.72814 2.26876 8.00001Z"
                      fill=""
                    />
                    <path
                      d="M11 10.9219C9.38438 10.9219 8.07812 9.61562 8.07812 8C8.07812 6.38438 9.38438 5.07812 11 5.07812C12.6156 5.07812 13.9219 6.38438 13.9219 8C13.9219 9.61562 12.6156 10.9219 11 10.9219ZM11 6.625C10.2437 6.625 9.625 7.24375 9.625 8C9.625 8.75625 10.2437 9.375 11 9.375C11.7563 9.375 12.375 8.75625 12.375 8C12.375 7.24375 11.7563 6.625 11 6.625Z"
                      fill=""
                    />
                  </svg>
                </div>

                <div class="mt-4 flex items-end justify-between">
                  <div>
                    <h4
                      class="text-title-md font-bold text-black dark:text-white"
                    >

                      ${i_used_kcal} kcal
                    </h4>
                    <span class="text-sm font-medium">소모 칼로리</span>

                  </div>

                </div>
              </div>
              <!-- Card Item End -->

              <!-- Card Item Start -->
              <div
                class="rounded-sm border border-stroke bg-white py-6 px-7.5 shadow-default dark:border-strokedark dark:bg-boxdark"
              >
                <div
                  class="flex h-11.5 w-11.5 items-center justify-center rounded-full bg-meta-2 dark:bg-meta-4"
                >
                  <!-- 로고 -->
					<svg
					  class="fill-primary dark:fill-white"
					  width="22"
					  height="16"
					  viewBox="0 0 22 16"
					  fill="none"
					  xmlns="http://www.w3.org/2000/svg"
					>
					  <img src="src/images/logo/scale.png" width="100%" height="100%" />
					</svg>
					
                    <path
                      d="M11 15.1156C4.19376 15.1156 0.825012 8.61876 0.687512 8.34376C0.584387 8.13751 0.584387 7.86251 0.687512 7.65626C0.825012 7.38126 4.19376 0.918762 11 0.918762C17.8063 0.918762 21.175 7.38126 21.3125 7.65626C21.4156 7.86251 21.4156 8.13751 21.3125 8.34376C21.175 8.61876 17.8063 15.1156 11 15.1156ZM2.26876 8.00001C3.02501 9.27189 5.98126 13.5688 11 13.5688C16.0188 13.5688 18.975 9.27189 19.7313 8.00001C18.975 6.72814 16.0188 2.43126 11 2.43126C5.98126 2.43126 3.02501 6.72814 2.26876 8.00001Z"
                      fill=""
                    />
                    <path
                      d="M11 10.9219C9.38438 10.9219 8.07812 9.61562 8.07812 8C8.07812 6.38438 9.38438 5.07812 11 5.07812C12.6156 5.07812 13.9219 6.38438 13.9219 8C13.9219 9.61562 12.6156 10.9219 11 10.9219ZM11 6.625C10.2437 6.625 9.625 7.24375 9.625 8C9.625 8.75625 10.2437 9.375 11 9.375C11.7563 9.375 12.375 8.75625 12.375 8C12.375 7.24375 11.7563 6.625 11 6.625Z"
                      fill=""
                    />
                  </svg>
                </div>

                <div class="mt-4 flex items-end justify-between">
                  <div>
                    <h4
                      class="text-title-md font-bold text-black dark:text-white"
                    >

                      ${m_weight} kg
                    </h4>
                    <span class="text-sm font-medium">목표까지 ${totarget} kg</span>

                  </div>

                </div>
              </div>
              <!-- Card Item End -->
            </div>

            <!-- ====== Chart One Start -->
            <div class="mt-4 grid grid-cols-12 gap-4 md:mt-6 md:gap-6 2xl:mt-7.5 2xl:gap-7.5">
            
			<!--  스택 그래프 -->
			<div class="col-span-12 rounded-sm border border-stroke bg-white px-4 pt-6 pb-4 shadow-default dark:border-strokedark dark:bg-boxdark sm:px-6 xl:col-span-8">
			    <div class="col-span-12 grid grid-cols-2 gap-4">
			        <div>
			            <h4 class="text-xl font-bold text-black dark:text-white">
			                이번주 섭취 칼로리
			            </h4>
			            <div id="chartstacked" class="mx-auto flex justify-center mt-2"></div>
			        </div>
			    </div>
			</div>
			
			<!-- ===== 파이 그래프 시작 ====== -->	
<div class="col-span-12 rounded-sm border border-stroke bg-white p-10 shadow-default dark:border-strokedark dark:bg-boxdark xl:col-span-4">
    <div class="mb-6 justify-center">
        <div style="width: 100%; height: 100%; padding-bottom: 20px;"> <!-- 여기서 padding-bottom을 추가하여 그래프를 아래로 이동 -->
            <h4 class="mb-10 text-xl font-bold text-black dark:text-white">
                일일 섭취 영양 성분
            </h4>
            <div id="chart" class="mx-auto flex justify-center mt-2"></div>
        </div>
    </div>
</div>





		   <!-- ===== 파이 그래프 끝 ====== -->		
</div>

              <!-- ====== Chart Two End -->

              <!-- ====== Chart Three Start -->
              <br/>
              <div class="col-span-12 rounded-sm border border-stroke bg-white px-5 pt-7.5 pb-5 shadow-default dark:border-strokedark dark:bg-boxdark sm:px-7.5 xl:col-span-5">
               <div class="mb-3 justify-between gap-4 sm:flex">
			    <div>
			      <h4 class="text-xl font-bold text-black dark:text-white">
			        저번주와 이번주 소모 칼로리 비교
			      </h4>
			    </div>
    
			  </div>
			  <div class="mb-2">
			    <div id="barchart" class="flex justify-center"></div>
			  </div>
			</div>

              <!-- ====== Chart Three End -->
			<br/>
              <!-- ====== Map One Start -->
              <div class="col-span-12 rounded-sm border border-stroke bg-white py-6 px-7.5 shadow-default dark:border-strokedark dark:bg-boxdark xl:col-span-7">
				  <h4 class="mb-2 text-xl font-bold text-black dark:text-white">
				    내 몸무게 변화
				  </h4>
<!-- 				    <div id="chartline" class="mx-auto flex justify-center"></div> -->
				    <div id="chartline" class="mx-auto flex justify-center"></div>
			</div>
              <!-- ====== Map One End -->

              <!-- ====== Table One Start -->

              <!-- ====== Chat Card End -->
            </div>
          </div>
        </main>
        <!-- ===== Main Content End ===== -->
      </div>
      <!-- ===== Content Area End ===== -->
    </div>
    <!-- ===== Page Wrapper End ===== -->
  <script defer src="bundle.js"></script>
  
  <!-- ===== 파이그래프 , 스택 데이터 ===== -->
  <script>
  var pieData = [44, 55, 13];

  //var barData = [41, 20, 15];

  var pieOptions = {
    series: pieData,
    chart: {
      type: 'pie',
      height: 350,
    },

    labels: ['탄수', '단백', '지방'],

    responsive: [{
      breakpoint: 480,
      options: {
        chart: {
          width: 200
        },
        legend: {
          position: 'bottom'
        }
      }
    }]
  };

  var pieChart = new ApexCharts(document.querySelector("#chart"), pieOptions);
  pieChart.render();

  var barOptions = {
    series: [
      

      { name: '아침', data: [10, 23, 20, 10, 22, 44, 12] },
      { name: '점심', data: [13, 23, 20, 10, 22, 44, 12] },
      { name: '저녁', data: [13, 23, 20, 10, 22, 44, 12] },
      { name: '간식', data: [13, 23, 20, 10, 22, 44, 12] },

      
    ],
    chart: {
      type: 'bar',
      height: 350,
      stacked: true,
      toolbar: {
        show: true
      },
      zoom: {
        enabled: true
      }
    },
    responsive: [{
      breakpoint: 480,
      options: {
        legend: {
          position: 'bottom',
          offsetX: -10,
          offsetY: 0
        }
      }
    }],
    plotOptions: {
      bar: {
        horizontal: false,
        borderRadius: 10,
        dataLabels: {
          total: {
            enabled: true,
            style: {
              fontSize: '13px',
              fontWeight: 900
            }
          }
        }
      },
    },
    xaxis: {
      type: 'text',
      categories: ['월', '화', '수', '목','금','토','일'],
    },
    legend: {
      position: 'top',
      horizontalAlign: 'center',
      offsetY: 10,
      markers: {
        radius: 12
      }
    },
    fill: {
      opacity: 1
    }
  };

  var barChart = new ApexCharts(document.querySelector("#chartstacked"), barOptions);
  barChart.render();
</script>
  <!-- ===== 파이그래프 , 스택 데이터 ===== -->
	
<script>
    var options = {
      series: [{

        name: '저번주',
        data: [31, 40, 28, 51, 42, 109, 100]
      }, {
        name: '이번주',

        data: [11, 32, 45, 32, 34, 52, 41]
      }],
      chart: {
        height: 350,
        type: 'area'
      },
      dataLabels: {
        enabled: false
      },
      stroke: {
        curve: 'smooth'
      },
      xaxis: {
        type: 'datetime',
        categories: ["2018-09-19T00:00:00.000Z", "2018-09-19T01:30:00.000Z", "2018-09-19T02:30:00.000Z", "2018-09-19T03:30:00.000Z", "2018-09-19T04:30:00.000Z", "2018-09-19T05:30:00.000Z", "2018-09-19T06:30:00.000Z"]
      },
      tooltip: {
        x: {
          format: 'dd/MM/yy HH:mm'
        },
      },
    };

    var chart = new ApexCharts(document.querySelector("#barchart"), options);
    chart.render();
  </script>	
	
<script>
  var options = {
    series: [{
      name: "Desktops",
      data: [10, 41, 35, 51, 49, 62, 69, 91, 148]
    }],
    chart: {
      height: 350,
      type: 'line',
      zoom: {
        enabled: false
      }
    },
    dataLabels: {
      enabled: false
    },
    stroke: {
      curve: 'straight'
    },
    title: {

      text: '단위 : 월',

      align: 'left'
    },
    grid: {
      row: {
        colors: ['#000000', 'transparent'], // takes an array which will be repeated on columns
        opacity: 0.5
      },
    },
    xaxis: {
      categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep'],
    }
  };

  var chart = new ApexCharts(document.querySelector("#chartline"), options);
  chart.render();
</script>
  </body>
  
  
  
</html>