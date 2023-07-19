<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="seq" value="${requestScope.seq}" />
<c:set var="sbHtml" value="${requestScope.sbHtml}" />
<c:set var="listTo" value="${requestScope.listTo}" />
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
                <a href="boardWrite.do"
                  class="inline-flex items-center justify-center rounded-md bg-primary py-4 px-10 text-center font-medium text-white hover:bg-opacity-90 lg:px-8 xl:px-10">
                  글쓰기
                </a>
         </div>
          <!-- Breadcrumb End -->

          ${sbHtml}
         
      <!-- ===== Main Content End ===== -->
    </div>
    <!-- ===== Content Area End ===== -->
  </div>
  <!-- ===== Page Wrapper End ===== -->
<script defer src="bundle.js"></script></body>

</html>