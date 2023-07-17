<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="seq" value="${requestScope.seq}" />
<c:set var="myto" value="${requestScope.boardLists}" />
<c:set var="myto" value="${requestScope.listTo}" />
<c:set var="myto" value="${requestScope.to}" />

<c:set var="name" value="${myto.m_name}" />
<c:set var="role" value="${myto.m_role}" />
<c:set var="profilename" value="${myto.m_profilename}" />
<c:set var="backgroundfilename" value="${myto.m_backgroundfilename}" />
<c:set var="joinDate" value="${myto.m_join_date}" />
<c:set var="tel" value="${myto.m_tel}" />
<c:set var="height" value="${myto.m_height}" />
<c:set var="weight" value="${myto.m_weight}" />
<c:set var="targetCalorie" value="${myto.m_target_calorie}" />
<c:set var="targetWeight" value="${myto.m_target_weight}" />
<c:set var="birthday" value="${myto.m_birthday}" />
<c:set var="id" value="${myto.m_id}" />
<c:set var="mail" value="${myto.m_mail}" />
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Board</title>
<link rel="icon" href="favicon.ico"><link href="style.css" rel="stylesheet"></head>

<body
  x-data="{ page: 'card', 'loaded': true, 'darkMode': true, 'stickyMenu': false, 'sidebarToggle': false, 'scrollTop': false }"
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
    <!-- ===== Sidebar Start ===== -->
   
    <!-- ===== Sidebar End ===== -->

    <!-- ===== Content Area Start ===== -->
-
      <!-- ===== Header Start ===== -->
    

      <!-- User Area -->
s
      <!-- ===== Header End ===== -->

      <!-- ===== Main Content Start ===== -->
      <main>
        <div class="mx-auto max-w-screen-2xl p-4 md:p-6 2xl:p-10">
          <!-- Breadcrumb Start -->
          <div class="mb-6 flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
            <h2 class="text-title-md2 font-bold text-black dark:text-white">
              Board
            </h2>

            <nav>
              <ol class="flex items-center gap-2">
                <li><a class="font-medium" href="main.do">main /</a></li>
                <li class="font-medium text-primary">board</li>
              </ol>
            </nav>
          </div>
          <div class="mb-6 flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between" >
                <a href="#"
                  class="inline-flex items-center justify-center rounded-md bg-primary py-4 px-10 text-center font-medium text-white hover:bg-opacity-90 lg:px-8 xl:px-10">
                  글쓰기
                </a>
		   </div>
          <!-- Breadcrumb End -->

          <div class="grid grid-cols-1 gap-7.5 sm:grid-cols-2 xl:grid-cols-3">
            <div class="rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark">
              <div class="flex items-center gap-3 py-5 px-6">
                <div class="h-10 w-10 rounded-full">
                  <img src="src/images/user/user-11.png" alt="User" />
                </div>
                <div>
                  <h4 class="font-medium text-black dark:text-white">
                    사용자이름
                  </h4>
                </div>
              </div>

              <a href="#" class="block px-4">
                <img src="src/images/cards/cards-01.png" alt="Cards" />
              </a>

              <div class="p-6">
                <h4 class="mb-3 text-xl font-semibold text-black dark:text-white">
                  <a href="#">Card Title here</a>
                </h4>
                <p class="font-medium">
                  Lorem ipsum dolor sit amet, vehiculaum ero felis loreum
                  fitiona fringilla goes scelerisque Interdum et.
                </p>
              </div>
            </div>

            <div class="rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark">
              <div class="flex items-center gap-3 py-5 px-6">
                <div class="h-10 w-10 rounded-full">
                  <img src="src/images/user/user-12.png" alt="User" />
                </div>
                <div>
                  <h4 class="font-medium text-black dark:text-white">
                    Musharof Chy
                  </h4>
                  <p class="font-medium text-xs">Web Developer</p>
                </div>
              </div>

              <a href="#" class="block px-4">
                <img src="src/images/cards/cards-02.png" alt="Cards" />
              </a>

              <div class="p-6">
                <h4 class="mb-3 text-xl font-semibold text-black dark:text-white">
                  <a href="#">Card Title here</a>
                </h4>
                <p class="font-medium">
                  Lorem ipsum dolor sit amet, vehiculaum ero felis loreum
                  fitiona fringilla goes scelerisque Interdum et.
                </p>
              </div>
            </div>

            <div class="rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark">
              <div class="flex items-center gap-3 py-5 px-6">
                <div class="h-10 w-10 rounded-full">
                  <img src="src/images/user/user-13.png" alt="User" />
                </div>
                <div>
                  <h4 class="font-medium text-black dark:text-white">
                    Shafiq Hammad
                  </h4>
                  <p class="font-medium text-xs">Front-end Developer</p>
                </div>
              </div>

              <a href="#" class="block px-4">
                <img src="src/images/cards/cards-03.png" alt="Cards" />
              </a>

              <div class="p-6">
                <h4 class="mb-3 text-xl font-semibold text-black dark:text-white">
                  <a href="#">Card Title here</a>
                </h4>
                <p class="font-medium">
                  Lorem ipsum dolor sit amet, vehiculaum ero felis loreum
                  fitiona fringilla goes scelerisque Interdum et.
                </p>
              </div>
            </div>
          </div>

         
      <!-- ===== Main Content End ===== -->
    </div>
    <!-- ===== Content Area End ===== -->
  </div>
  <!-- ===== Page Wrapper End ===== -->
<script defer src="bundle.js"></script></body>

</html>