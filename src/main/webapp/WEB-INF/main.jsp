<%@page import="java.util.Date"%>
<%@page import="org.springframework.security.core.Authentication"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="com.example.model.MainTO"%>
<%@page import="java.util.ArrayList"%>
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
     main RAB
   </title>
   
   <link rel="stylesheet" href="style.css" >
   
   <link rel="stylesheet" href="/css/main.css" >
   
<!--  tailwindcss로 그린 아이콘, apexChart -->
  <link rel="icon" href="favicon.ico">
  <script src="https://cdn.jsdelivr.net/npm/apexcharts@3.28.3"></script> 

<!-- jQuery, jQuery Dialog, jQuery Calendar, fontAwesome --> 
  <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
  <script src="https://code.jquery.com/ui/1.13.0/jquery-ui.min.js"></script>
  <link rel="stylesheet" href="https://code.jquery.com/ui/1.13.0/themes/base/jquery-ui.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css" />
  
  <script src="https://cdn.ckeditor.com/ckeditor5/34.0.0/classic/ckeditor.js"></script>
  
  
  <!--  js파일 외부화 -->
  <script src="/js/feedback.js"></script>
  <script src="/js/default_document.js"></script>
  <script src="/js/functions_for_main.js"></script>
<script>

//---------------------------- 페이지 요소가 전부 불려오고 난 후 적용될 스크립트----------------------------

 window.onload = function() {
		
	    document.getElementById('pieChartSelect').addEventListener('change', function(e) {
	        if (this.value === 'tandanji') {
	            MacroPieChart();
	        } else if (this.value === 'colnadang') {
	            SugarPieChart();
	        }
	    });
		
//--달력 라벨 밸류 디폴트는 현재로컬타임 기준으로 세팅됨----------------------------------------------

		var currentDate = new Date();

		var day = ("0" + currentDate.getDate()).slice(-2);
		var month = ("0" + (currentDate.getMonth() + 1)).slice(-2);
		var year = currentDate.getFullYear();

		var formattedDate = year + "-" + month + "-" + day;

		var calendarhtml = '<li> <label for="start"></label> <input type="date" id="calendarCtInput" name="trip-start" value="' + formattedDate + '" min="2023-01-01" max="2050-12-31"></li>';
    
		$('#calendarCt').html(calendarhtml);
	
		console.log( " formattedDate -> " , formattedDate );

		var selectedDate = formattedDate;
		/////////////////////////////

//---  몸무게 업데이트 다이얼로그----------------------
	
	// 몸무게 다이얼로그 안 달력
	$(function() {
  		$("#dateInput").datepicker({
	    dateFormat: "yy-mm-dd",
	    minDate: new Date(2023, 0, 1),
	    maxDate: new Date(2050, 11, 31),
	    defaultDate: new Date(),
	    onSelect: function(dateText, inst) {
	      $(this).val(dateText);
	    }
	  });
	});
		
    // 오늘의 몸무게 다이얼로그 팝업
	$('#weightTodayDropdown').click(function(e) {
  		e.preventDefault();
  	$('#weightForToday').dialog('open');
	});

	// 목표 몸무게 재설정 다이얼로그 팝업
	$('#targetWeightUpdateDropdown').click(function(e) {
  		e.preventDefault();
  	$('#targetWeightUpdate').dialog('open');
	});

	//  몸무게 다이얼로그 설정
	$('#weightForToday').dialog({
	  autoOpen: false,
	  modal: true,
	  buttons: {
	    '계속입력': function() {
	        var weight = $(this).find('#weightInput').val();
		      var date = $(this).find('#dateInput').val();
	    	  var zzinseq = $("#zzinseq").val();
	    	  
	    	  //console.log( " 몸무게 업데이트/날짜 -> ", zzinseq);
	    	  //console.log( " 몸무게 업데이트/몸무게 -> ", weight); 
	    	  //console.log( " 몸무게 업데이트/날짜 -> ", date);
	    	  
		      
		      if(weight === '' || isNaN(weight)) { 
		        alert('숫자를 입력해주세요');
		      } else if (!/^(\d*\.?\d{0,2})$/.test(weight)) {
	              alert('특수문자 대신에 숫자를 입력해주세요 (소수점은 두자리 까지만!)');
	          } else if ( date === ''){
	              alert('날짜를 선택해주세요');
	          }
		      else {
		    	  $.ajax({
		              url: "/weight_update",
		              method: "POST",
		              data: {
	            	  	seq: zzinseq, 
		                i_weight: weight,
		                dialogDate : date
		              },
		              success: function() {
		                alert(' ' + weight + ' kg ' + date + ' 에 등록되었습니다.');
		                loadDataFromDate();
		              },
		              error: function(jqXHR, textStatus, errorThrown) {
	            	    //console.log('HTTP Status: ' + jqXHR.status); // 서버로부터 반환된 HTTP 상태 코드
	            	    //console.log('Throw Error: ' + errorThrown); // 예외 정보
	            	    //console.log('jqXHR Object: ' + jqXHR.responseText); // 서버로부터 반환된 HTTP 응답 본문
		                
	            	    alert('업데이트에 실패했습니다');
		              }
		            });

		            //$(this).dialog('close');
		          }
	    	
	     },
	    '입력': function() {
	      var weight = $(this).find('#weightInput').val();
	      var date = $(this).find('#dateInput').val();
    	  var zzinseq = $("#zzinseq").val();
    	  
    	  //console.log( " 몸무게 업데이트/날짜 -> ", zzinseq);
    	  //console.log( " 몸무게 업데이트/몸무게 -> ", weight); 
    	  //console.log( " 몸무게 업데이트/날짜 -> ", date);
    	  
	      
	      if(weight === '' || isNaN(weight)) { 
	        alert('숫자를 입력해주세요');
	      } else if (!/^(\d*\.?\d{0,2})$/.test(weight)) {
              alert('특수문자 대신에 숫자를 입력해주세요 (소수점은 두자리 까지만!)');
          } else if ( date === ''){
              alert('날짜를 선택해주세요');
          }
	      else {
	    	  $.ajax({
	              url: "/weight_update",
	              method: "POST",
	              data: {
            	  	seq: zzinseq, 
	                i_weight: weight,
	                dialogDate : date
	              },
	              success: function() {
	                alert(' ' + weight + ' kg ' + date + ' 에 등록되었습니다.');
	                loadDataFromDate();
	                LineChartForMonth()
	              },
	              error: function(jqXHR, textStatus, errorThrown) {
            	    //console.log('HTTP Status: ' + jqXHR.status); // 서버로부터 반환된 HTTP 상태 코드
            	    //console.log('Throw Error: ' + errorThrown); // 예외 정보
            	    //console.log('jqXHR Object: ' + jqXHR.responseText); // 서버로부터 반환된 HTTP 응답 본문
	                
            	    alert('업데이트에 실패했습니다');
	              }
	            });

	            $(this).dialog('close');
	          }
	        },
	    '취소': function() {
	      $(this).dialog('close');
	    }
	  },
	  close: function() {
	    $(this).find('#weightInput').val('');
	  }
	});

	// 목표 몸무게 다이얼로그 설정
	$('#targetWeightUpdate').dialog({
	  autoOpen: false,
	  modal: true,
	  buttons: {
	    '업데이트': function() {
	      var tweight = $(this).find('#TweightInput').val();
	      var zzinseq = $("#zzinseq").val();

	 	  //console.log( " 목표 몸무게 업데이트/날짜 -> ", zzinseq);
    	  //console.log( " 목표 몸무게 업데이트/몸무게 -> ", tweight); 
	      
	      if(tweight === '' || isNaN(tweight)) { 
	          alert('숫자를 입력해주세요');
	      } else if (!/^(\d*\.?\d{0,2})$/.test(tweight)) {
              alert('특수문자 대신에 숫자를 입력해주세요 (소수점은 두자리 까지만!)');
	      } else {
	    	  $.ajax({
	              url: "/weight_update",
	              method: "POST",
	              data: {
            	  	seq: zzinseq, 
            	  	target_weight : tweight
	              },
	              success: function() {
	                alert('목표 몸무게가' + tweight + ' kg로 설정되었습니다!');
	                loadDataFromDate();
	              },
	              error: function(jqXHR, textStatus, errorThrown) {
            	    console.log('HTTP Status: ' + jqXHR.status); // 서버로부터 반환된 HTTP 상태 코드
            	    console.log('Throw Error: ' + errorThrown); // 예외 정보
            	    console.log('jqXHR Object: ' + jqXHR.responseText); // 서버로부터 반환된 HTTP 응답 본문
	                
            	    alert('업데이트에 실패했습니다');
	              }
	            });

	            $(this).dialog('close');
	      	 }
	     },
	    '취소': function() {
	      $(this).dialog('close');
	    }
	  },
	  close: function() {
	    $(this).find('#TweightInput').val('');
	  }
	});
		
	//---함수등록 칸  ------------------ 바뀌는 날짜에 대해서 모든 데이터가 비동기적으로 처리됨-----------------------------------------
    $("#calendarCtInput").on("change", function() {
        	
        	selectedDate = $(this).val();
        	
        	//console.log("달력 value 확인 ->", selectedDate);
        	
            loadDataFromDate();
         
          	//PieDataForDate();
          	
          	MacroPieChart();
          	
            AreaChartForWeek();

            	
        });
	
	//년도별로 월평균 보여주기.
    $("#yearSelectForLineChart").on("change", function() {
    	
    	event.preventDefault();
    	  
    	console.log(" select 년도 확인 ->",  $(this).val());
    	
      	LineChartForMonth();
        	
    });

	
	loadDataFromDate();
	MacroPieChart();
	BarChartForDate();
	AreaChartForWeek();
	LineChartForMonth();

//////
  	};//window.onload끝 
//////

	
</script>



</head>

  <body
    x-data="{ page: 'analytics', 'loaded': true, 'darkMode': true, 'stickyMenu': false, 'sidebarToggle': false, 'scrollTop': false }"
    x-init="
         darkMode = JSON.parse(localStorage.getItem('darkMode'));
         $watch('darkMode', value => localStorage.setItem('darkMode', JSON.stringify(value)))"
    :class="{'dark text-bodydark bg-boxdark-2': darkMode === true}"
  >
  
  <input type="hidden" id="zzinid" value="${zzinid}" />
  <input type="hidden" id="zzinseq" value="${zzinseq}" />
  <input type="hidden" id="zzinname" value="${zzinname}" />
  <input type="hidden" id="zzinmail" value="${zzinmail}" />
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
<!--       <img src="src/images/logo/배경로고2.png" width="100%" height="100%" /> 
		<i class="fa-solid fa-rocket fa-bounce fa-10x"></i>
    </a>
    
    -->

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
        <h3 class="mb-4 ml-4 text-sm font-medium text-bodydark2">메뉴</h3>


        <ul class="mb-6 flex flex-col gap-1.5">
          <!-- Menu Item Dashboard -->

          <!-- Menu Item Calendar -->
          <li>
            <a
              class="group relative flex items-center gap-2.5 rounded-sm py-2 px-4 font-medium text-bodydark1 duration-300 ease-in-out hover:bg-graydark dark:hover:bg-meta-4"
              href="/notice_board.do"
              @click="selected = (selected === 'Calendar' ? '':'Calendar')"
              :class="{ 'bg-graydark dark:bg-meta-4': (selected === 'Calendar') && (page === 'calendar') }"
            >
           	공지사항
            </a>
          </li>
          <!-- Menu Item Calendar -->

          <!-- Menu Item Profile -->
          <li>
            <a
              class="group relative flex items-center gap-2.5 rounded-sm py-2 px-4 font-medium text-bodydark1 duration-300 ease-in-out hover:bg-graydark dark:hover:bg-meta-4"

              href="board.do"
              @click="selected = (selected === 'Profile' ? '':'Profile')"
              :class="{ 'bg-graydark dark:bg-meta-4': (selected === 'Profile') && (page === 'profile') }"
              :class="page === 'profile' && 'bg-graydark'"
            >
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
              운동
            </a>
            
     
          </li>
          
          <!--  마이페이지 li -->
             
           <li>
            <a
              class="group relative flex items-center gap-2.5 rounded-sm py-2 px-4 font-medium text-bodydark1 duration-300 ease-in-out hover:bg-graydark dark:hover:bg-meta-4"

              href="profile.do"
              @click="selected = (selected === 'Profile' ? '':'Profile')"
              :class="{ 'bg-graydark dark:bg-meta-4': (selected === 'Profile') && (page === 'profile') }"
              :class="page === 'profile' && 'bg-graydark'"
            >
             마이페이지
            </a>
          </li>

          
          <!--  -->
          
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
    			로그아웃
  			</a>
		</li>
          
          <!-- Menu Item Settings -->
        </ul>
      </div>
      </nav>
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
      <a class="block flex-shrink-0 lg:hidden" href="/">
        <img src="src/images/logo/" alt="홈 로고 추가해야되요" />
      </a>
    </div>
    
    <!--  검색 창 -->
    <div class="hidden sm:block">
    
    </div>
    <!--  검색 창  끝-->
    
 <!-- 오늘의 몸무게 업데이트 다이얼로그 -->
<div id="weightForToday" title="몸무게 입력">
  <form>
    <label for="weightInput">몸무게 입력:</label>
    <input type="text" id="weightInput" class="text ui-widget-content">
    <br>
    <label for="dateInput"><u>날짜 선택</u></label>
    <input type="text" id="dateInput" readonly>
    <br>
  </form>
</div>
    <!-- 오늘의 몸무게 업데이트 끝 -->

 <!-- 목표 몸무게 업데이트 다이얼로그 -->
 <div id="targetWeightUpdate" title="목표 몸무게 재설정">
  <form>
    <label for="TeightInput">목표 몸무게 설정:</label>
    <input type="text" id="TweightInput" class="text ui-widget-content">
    <br>
  </form>
</div>
    <!-- 목표 몸무게 업데이트 끝 -->
    


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
             <div id="weightTodayDropdown">
              <a
                href=""
                class="flex items-center gap-3.5 text-sm font-medium duration-300 ease-in-out hover:text-primary lg:text-base"
              >
               <img
      			class="fill-current"
      			src="/src/images/user/rocatNOb.png"
      			alt="비고.png"
      			width="24"
      			height="24"
   			/>
                몸무게 입력
              </a>
              </div>
            </li>
            
             <li>
             <div id="targetWeightUpdateDropdown">
              <a
                href=""
                class="flex items-center gap-3.5 text-sm font-medium duration-300 ease-in-out hover:text-primary lg:text-base"
              >
               <img
      			class="fill-current"
      			src="/src/images/user/rocatNOb.png"
      			alt="비고.png"
      			width="24"
      			height="24"
   			/>
                목표 몸무게 재설정
              </a>
              </div>
            </li>
            
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
                  <div id="firstElement">
          		        
               
                   
     		    
                  </div>
                </div>
                
               <!--  달력날짜 컨트롤러  -->
                  <div id="calendarCt">
               
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
                
                  <div id="secondElement">
            

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
                
                  <div id="thirdElement">
            
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

                
<div class="mt-4 flex flex-col">
    <div id="fourthElement">
        <!-- fourthElement에 대한 기존 HTML 코드 -->
    </div>
    <br>
    <div id="targetWeight">
        <!-- 동적으로 처리되는 HTML이 삽입될 위치 -->
    </div>
</div>

             
                   
                </div>
              </div>
              <!-- Card Item End -->
            </div>

            <!-- ====== Chart Ones Start -->
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
			        <div style="width: 100%; height: 100%; padding-bottom: 5px;"> <!-- 여기서 padding-bottom을 추가하여 그래프를 아래로 이동 -->
			            <h4 class="mb-10 text-xl font-bold text-black dark:text-white">
			                일일 섭취 영양 성분
			            </h4>
			         	<select id="pieChartSelect" class="form-control">
    						<option value="tandanji" id="tandanji">탄단지</option>
						    <option value="colnadang" id="colnadang">콜나당</option>
						</select>
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
	
              <!-- ====== Map One Start -->
              <div class="col-span-12 rounded-sm border border-stroke bg-white py-6 px-7.5 shadow-default dark:border-strokedark dark:bg-boxdark xl:col-span-7">
				  <h4 class="mb-2 text-xl font-bold text-black dark:text-white">
				    내 몸무게 변화
				  </h4>
				  <select id="yearSelectForLineChart" class="rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark">

				  </select>
				  
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
 
     
<div class="chatbot-icon">
    <i class="fas fa-question"></i>
</div>

<div class="chatbot-dialog">
    <div id="c_dialog">
        <div class="dialog-header">
            <span class="dialog-title">피드백 작성</span>
            <button class="dialog-close">&times;</button>
        </div>
        <div class="dialog-body">
            <form>
                <div class="form-row">
                    <label for="name">이름</label>
                    <input type="text" id="f_name" readonly>
                </div>
                <div class="form-row">
                    <label for="id">아이디</label>
                    <input type="text" id="f_id" readonly>
                </div>
                <div class="form-row">
                    <label for="mail">이메일</label>
                    <input type="email" id="f_mail" readonly>
                </div>
                <div class="form-row">
                    <label for="subject">제목</label>
                    <input type="text" id="f_subject">
                </div>
                <div class="form-row">
                    <label for="content">내용</label>
                    
                    <!-- 
                    <div contenteditable="true" id="f_content" placeholder="캡쳐본을 붙혀넣으실 수 있습니다!         (Window + Shift + s로 캡쳐 후 Ctrl + V)"></div>
                     -->
   
                    <textarea id="f_content"></textarea>
   
                </div>
            </form>
        </div>
        <div class="dialog-footer">
            <button id="submit-btn">전송</button>
        </div>
    </div>
</div>

</body>
    
</html>