<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>피드백 페이지</title>
<link rel="icon" href="favicon.ico"><link href="style.css" rel="stylesheet">
	<!-- 구글 사이드 상단 Menu 글씨체-->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Lugrasimo&display=swap" rel="stylesheet">

<!-- 구글 사이드 글씨체-->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@100&display=swap" rel="stylesheet">

<!-- 이미지 아이콘 cdn -->
<script src="https://kit.fontawesome.com/efe58e199b.js" crossorigin="anonymous"></script>

<style type="text/css">
	.theme1 {margin-bottom:30px; border:0px; height:5px; background: linear-gradient(to left, transparent, rgba(255,255,255,.5), transparent);}
	
	/*============ 사이드 로고 메뉴 폰트 ==========*/
	h3.mb-4.ml-4.text-sm.font-medium.text-bodydark2 {
        font-size: 30px;
		cfont-family: 'Cuprum', sans-serif;
    }
	/*=====================================*/
    
	/*============ 사이드 (공지사항 , 게시판 , 식단 , 운동 , 내정보 , 로그아웃) ==========*/
    h1.side {
	    font-size: 25px;
	    font-family: 'Josefin Sans', sans-serif;
	}
	/*===================================================================*/
	
	/*========================================================== 로켓 이미지 바운스 조절====================================================*/	
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

<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://code.jquery.com/ui/1.13.0/jquery-ui.min.js"></script>
  
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">



<style>
 .feedback-table {
   color: grey;
 }
 .container {
   max-width: 1400px;
   overflow-y: scroll;
   height: 90vh; /* 페이지가 브라우저 창에 꽉 차도록 설정 */
 }
 </style>

<!--           

//////////////////////////////////////////////////////////////

 -->
  
<script>
		
		//함수
		var page = 0;  // 페이지 번호를 저장하는 전역 변수
		var isLoadingData = false;  // 데이터를 불러오는 중인지 여부를 나타내는 변수
		var isLoadingMoreData = false; // 데이터를 추가로 불러오는 중인지 여부를 나타내는 변수
		var loadedDataCount = 0; // 현재까지 로드된 데이터 개수를 저장하는 변수
		var isSearchResult = false;
		
		// 스크롤 이벤트를 사용하여 스크롤을 올릴 때 데이터를 추가로 로드하는 함수
		function loadMoreDataOnScrollUp() {
		  if ($(window).scrollTop() === 0) {
		    page = Math.max(0, page - 1); // 현재 페이지의 이전 페이지를 로드합니다.
		    feedbackList(page, 1); // 이전 페이지를 포함하여 1개의 데이터를 가져옵니다.
		  }
		}
		
		// 더 이상 데이터가 없는 경우 처리
		function handleNoMoreData() {
		  var tbody = $('#feedbackTableBody');
		  if (tbody.children().length >= 10) {
		    // 현재 표시된 데이터가 10개 이상인 경우
		    tbody.children().slice(0, -1).remove(); // 가장 오래된 데이터를 삭제합니다.
		  }
		}
		
		// 피드백 데이터를 표시하는 함수
		function displayFeedbackData(data) {
		  var tbody = $('#feedbackTableBody');
		  tbody.empty(); // 새로운 데이터를 추가하기 전에 테이블 본문을 비웁니다.
		
		  $.each(data, function (i, feedback) {
		    var row = $('<tr>');
		    row.append($('<td>').text(feedback.f_seq));
		    row.append($('<td>').text(feedback.f_id));
		    row.append($('<td>').text(feedback.f_name));
		    row.append($('<td>').text(feedback.f_mail));
		    row.append($('<td>').text(feedback.f_subject));
		    row.append($('<td>').text(feedback.f_content));
		    row.append($('<td>').text(feedback.m_seq));
		    row.append($('<td>').text(feedback.f_day));
		    tbody.append(row);
		    
		    var viewLink = $('<a>').text('보기').attr('href', 'feedback_view.do?f_seq=' + feedback.f_seq + '&m_seq=' + feedback.m_seq);
		    var viewTd = $('<td>').append(viewLink);

		    row.append(viewTd); // 링크를 행에 추가합니다.
		    tbody.append(row); // 데이터를 테이블의 맨 위에 추가합니다.
		  });
		
		  isLoadingData = false; // 데이터 로딩 완료
		}
		
		// 로딩 메시지를 추가하여 1개씩 데이터가 추가로 로드되는 메시지를 표시
		function displayLoadingMessageOnScroll() {
		  var tbody = $('#feedbackTableBody');
		  tbody.empty(); // 로딩 메시지를 추가하기 전에 테이블 본문을 비웁니다.
		
		  var row = $('<tr>');
		  row.append($('<td colspan="8">').text('데이터 불러오는 중...')); // 로딩 메시지 표시
		  tbody.append(row);
		}
		
		// 피드백 데이터를 표시하는 함수
		function displayFeedbackDataOnScroll(data) {
		  var tbody = $('#feedbackTableBody');
		
		  if (loadedDataCount >= 10) {
		    tbody.children().slice(0, -1).remove(); // 가장 오래된 데이터를 삭제합니다.
		  }
		
		  $.each(data, function (i, feedback) {
		    var row = $('<tr>');
		    row.append($('<td>').text(feedback.f_seq));
		    row.append($('<td>').text(feedback.f_id));
		    row.append($('<td>').text(feedback.f_name));
		    row.append($('<td>').text(feedback.f_mail));
		    row.append($('<td>').text(feedback.f_subject));
		    row.append($('<td>').text(feedback.f_content));
		    row.append($('<td>').text(feedback.m_seq));
		    row.append($('<td>').text(feedback.f_day));
		    
		    var viewLink = $('<a>').text('보기').attr('href', 'feedback_view.do?f_seq=' + feedback.f_seq + '&m_seq=' + feedback.m_seq);
		    var viewTd = $('<td>').append(viewLink);

		    row.append(viewTd); // 링크를 행에 추가합니다.
		    //tbody.prepend(row); // 데이터를 테이블의 맨 위에 추가합니다.
		    tbody.append(row); // 데이터를 테이블의 맨 위에 추가합니다.
		  });
		
		  isLoadingMoreData = false; // 추가 데이터 로딩 완료
		  loadedDataCount++; // 현재까지 로드된 데이터 개수를 증가시킵니다.
		}

		///
		function feedbackList() {
			 if (isLoadingData || isSearchResult) return;  // 이미 데이터를 불러오고 있는 중이면 중복 요청 방지
		
		    isLoadingData = true;  // 데이터를 불러오는 중으로 설정
		
		    $.ajax({
		        url: '/feedback_list',
		        type: 'GET',
		        data: { 
		            page: page 
		        },  // 페이지 번호를 요청과 함께 전달
		        dataType: 'json',
		        success: function(data) {
		            if (data.length == 0) {  // 받아온 데이터가 없으면 더 이상 데이터가 없다는 것을 의미
		                console.log("더 이상 데이터가 없습니다.");
		                isLoadingData = false;
		                return;
		            }
		
		
		            var tbody = $('#feedbackTableBody');
		            if (page === 0) {
		                tbody.empty();  // 처음 페이지를 불러올 때만 이전 데이터를 삭제합니다.
		            }
		
		            $.each(data, function(i, feedback) {
		                var row = $('<tr>');
		                row.append($('<td>').text(feedback.f_seq));
		                row.append($('<td>').text(feedback.f_id));
		                row.append($('<td>').text(feedback.f_name));
		                row.append($('<td>').text(feedback.f_mail));
		                row.append($('<td>').text(feedback.f_subject));
		                row.append($('<td>').text(feedback.f_content));
		                row.append($('<td>').text(feedback.m_seq));
		                row.append($('<td>').text(feedback.f_day));
		                
		    		    var viewLink = $('<a>').text('보기').attr('href', 'feedback_view.do?f_seq=' + feedback.f_seq + '&m_seq=' + feedback.m_seq);
		    		    var viewTd = $('<td>').append(viewLink);

		    		    row.append(viewTd); // 링크를 행에 추가합니다.
		    		    //tbody.prepend(row); // 데이터를 테이블의 맨 위에 추가합니다.
		                tbody.append(row);
		            });
		
		            
		           // displayFeedbackData(data); // 가져온 데이터를 표시합니다.
		           displayFeedbackDataOnScroll(data)
		            page++; // 다음 페이지 번호를 증가시킵니다.
		            isLoadingData = false; // 데이터 불러오기 완료
		        },
		        error: function(xhr, status, error) {
		            console.log('Error: ' + error);
		            isLoadingData = false;  // 데이터 불러오기 실패 시 중복 요청 방지를 위해 초기화
		        }
		    });
		}
		
		////
		
		$(document).ready(function(){
		    // 페이지가 처음에 로드될 때 초기 데이터를 불러옵니다.
		    feedbackList(); // 처음에 0번 페이지에서 10개의 데이터를 가져옵니다.
		    
		    var observer = new IntersectionObserver(function(entries) {
		        if (entries[0].isIntersecting === true) {
		            loadMoreData();
		        }
		    }, { threshold: [0.2] });
		
		    function loadMoreData() {
		        console.log("데이터 불러오는중..");
		        feedbackList();
		
		        // 데이터 로드 후 마지막 행을 관찰 대상으로 설정
		        var lastRow = $("table.feedback-table tr:last");
		        observer.observe(lastRow[0]);
		    }
		
		    // 초기에는 테이블의 마지막 행을 관찰 대상으로 설정
		    var initialLastRow = $("table.feedback-table tr:last");
		    observer.observe(initialLastRow[0]);
		
		    // 스크롤 이벤트를 사용하여 스크롤을 올릴 때도 데이터를 추가로 로드
		    $(window).on('scroll', function () {
		        if ($(window).scrollTop() === 0 && !isLoadingMoreData) {
		          // 스크롤이 맨 위에 도달하고 현재 데이터 로딩 중이 아닌 경우에만 실행
		          isLoadingMoreData = true; // 추가 데이터 로딩 중으로 설정
		          displayLoadingMessageOnScroll(); // 로딩 메시지 표시
		          loadMoreDataOnScrollUp(); // 이전 페이지 데이터를 로드
		        }
		      });
		   //
		   
		   $('#searchWord').on('change', function() {
			  if ($(this).val().trim() === '') {
			    isSearchResult = false;  // 검색 결과를 보여주고 있지 않음을 설정
			    feedbackList();  // 원래의 데이터를 다시 불러옴
			  }
			});
		  ///검색기능
	      $('#searchWord').on('keypress', function(e) {
				    if(e.which == 13) {  // Enter key pressed
				        var searchKey = $('#searchKey').val();
				        var searchWord = $('#searchWord').val().trim();
				        
				        console.log(' searchKey ', searchKey);
				        console.log(' searchWord ', searchWord);
				
				        if (!searchWord) {
				            alert('검색어를 입력하세요!');
				            return;
				        }
				
				        $.ajax({
				            url: 'feedback_search',
				            type: 'GET', 
				            data: {
				                searchKey: searchKey,
				                searchWord: searchWord
				            },
				            success: function(response) {
				            	var searching = JSON.parse(response);
				            	$('#feedbackTableBody').empty();
				            	
				            	console.log(' searching -> ', searching );
				                displayFeedbackData(searching);
				                isSearchResult = true;
				            },
				            error: function(jqXHR, textStatus, errorThrown) {
				                console.log(textStatus, errorThrown);
				            }
				        });
				
				        $('#searchWord').val('');
				    }
			});
		    
		    ///
		});

</script>
</head>
<body
  x-data="{ page: 'buttons', 'loaded': true, 'darkMode': true, 'stickyMenu': false, 'sidebarToggle': false, 'scrollTop': false }"
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
	<div onclick="location.href='/admin.do';">
	    <!-- <img src="src/images/logo/배경로고2.png" width="100%" height="100%" /> -->
	    <i class="fa-solid fa-rocket bounce fa-10x" style="padding-top: 20px;"></i>
	</div>

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
	      <h3 class="mb-4 ml-4 text-sm font-medium text-bodydark2" style="padding-left: 45px; padding-top: 0px;">Menu</h3>
		  <hr class="theme1">
	
	      <ul class="mb-6 flex flex-col gap-1.5">
	        <!-- Menu Item Dashboard -->
	     <li class="sideMenu" style="height: 50px; padding-top: 20px;">
	      <div 
		    onclick="location.href='feedback.do';" 
		    class="flex items-center gap-3.5 text-sm font-medium duration-300 ease-in-out hover:text-primary lg:text-base" 
		    style="padding-left: 30px;">
			<i class="fa-solid fa-circle-info"></i>
	        <path
	            d="M11 9.62499C8.42188 9.62499 6.35938 7.59687 6.35938 5.12187C6.35938 2.64687 8.42188 0.618744 11 0.618744C13.5781 0.618744 15.6406 2.64687 15.6406 5.12187C15.6406 7.59687 13.5781 9.62499 11 9.62499ZM11 2.16562C9.28125 2.16562 7.90625 3.50624 7.90625 5.12187C7.90625 6.73749 9.28125 8.07812 11 8.07812C12.7188 8.07812 14.0938 6.73749 14.0938 5.12187C14.0938 3.50624 12.7188 2.16562 11 2.16562Z"
	            fill=""
	        />
	        <path
	            d="M17.7719 21.4156H4.2281C3.5406 21.4156 2.9906 20.8656 2.9906 20.1781V17.0844C2.9906 13.7156 5.7406 10.9656 9.10935 10.9656H12.925C16.2937 10.9656 19.0437 13.7156 19.0437 17.0844V20.1781C19.0094 20.8312 18.4594 21.4156 17.7719 21.4156ZM4.53748 19.8687H17.4969V17.0844C17.4969 14.575 15.4344 12.5125 12.925 12.5125H9.07498C6.5656 12.5125 4.5031 14.575 4.5031 17.0844V19.8687H4.53748Z"
	            fill=""
	        />
		    <h1 class="side">피드백</h1>
		 </div>
	     </li>
	     
	     <li class="sideMenu" style="height: 50px; padding-top: 20px;">
	      	<div 
			    onclick="location.href='admin.do';" 
			    class="flex items-center gap-3.5 text-sm font-medium duration-300 ease-in-out hover:text-primary lg:text-base" 
			    style="padding-left: 30px;">
			    <i class="fa-solid fa-users"></i>
		        <path
		            d="M11 9.62499C8.42188 9.62499 6.35938 7.59687 6.35938 5.12187C6.35938 2.64687 8.42188 0.618744 11 0.618744C13.5781 0.618744 15.6406 2.64687 15.6406 5.12187C15.6406 7.59687 13.5781 9.62499 11 9.62499ZM11 2.16562C9.28125 2.16562 7.90625 3.50624 7.90625 5.12187C7.90625 6.73749 9.28125 8.07812 11 8.07812C12.7188 8.07812 14.0938 6.73749 14.0938 5.12187C14.0938 3.50624 12.7188 2.16562 11 2.16562Z"
		            fill=""
		        />
		        <path
		            d="M17.7719 21.4156H4.2281C3.5406 21.4156 2.9906 20.8656 2.9906 20.1781V17.0844C2.9906 13.7156 5.7406 10.9656 9.10935 10.9656H12.925C16.2937 10.9656 19.0437 13.7156 19.0437 17.0844V20.1781C19.0094 20.8312 18.4594 21.4156 17.7719 21.4156ZM4.53748 19.8687H17.4969V17.0844C17.4969 14.575 15.4344 12.5125 12.925 12.5125H9.07498C6.5656 12.5125 4.5031 14.575 4.5031 17.0844V19.8687H4.53748Z"
		            fill=""
		        />
			    <h1 class="side">회원관리</h1>
			 </div>
	      </li>

	      <li class="sideMenu" style="height: 50px; padding-top: 20px;">
	         <div 
			    onclick="location.href='admin_notice_board.do';" 
			    class="flex items-center gap-3.5 text-sm font-medium duration-300 ease-in-out hover:text-primary lg:text-base" 
			    style="padding-left: 30px;">
			    <i class="fa-solid fa-circle-info"></i>
		        <path
		            d="M11 9.62499C8.42188 9.62499 6.35938 7.59687 6.35938 5.12187C6.35938 2.64687 8.42188 0.618744 11 0.618744C13.5781 0.618744 15.6406 2.64687 15.6406 5.12187C15.6406 7.59687 13.5781 9.62499 11 9.62499ZM11 2.16562C9.28125 2.16562 7.90625 3.50624 7.90625 5.12187C7.90625 6.73749 9.28125 8.07812 11 8.07812C12.7188 8.07812 14.0938 6.73749 14.0938 5.12187C14.0938 3.50624 12.7188 2.16562 11 2.16562Z"
		            fill=""
		        />
		        <path
		            d="M17.7719 21.4156H4.2281C3.5406 21.4156 2.9906 20.8656 2.9906 20.1781V17.0844C2.9906 13.7156 5.7406 10.9656 9.10935 10.9656H12.925C16.2937 10.9656 19.0437 13.7156 19.0437 17.0844V20.1781C19.0094 20.8312 18.4594 21.4156 17.7719 21.4156ZM4.53748 19.8687H17.4969V17.0844C17.4969 14.575 15.4344 12.5125 12.925 12.5125H9.07498C6.5656 12.5125 4.5031 14.575 4.5031 17.0844V19.8687H4.53748Z"
		            fill=""
		        />
			    <h1 class="side">공지사항</h1>
			 </div>
	      </li>
			<br/><br/>
			<h3 class="mb-4 ml-4 text-sm font-medium text-bodydark2" style="padding-left: 45px; padding-top: 20px;">Others</h3>
          	<hr class="theme1">
	          <!-- Menu Item Settings -->
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
<!-- 	            <a href="/klogout.do"><h1>로그아웃</h1></a> -->
	            <div 
			    onclick="location.href='admin_notice_board.do';" 
			    ><h1 class="side">로그아웃</h1></div>
	          </button>
			</li>
          
          <!-- Menu Item Settings -->
        </ul>
      </div>

       
    <!-- Sidebar Menu -->

    <!-- Promo Box -->

    <!-- Promo Box -->
  </div>
</aside>

<div class="container mt-5">

    <div id="searchSection" style="margin-bottom: 20px;">
        <select id="searchKey">
            <option value="아이디">아이디</option>
            <option value="이름">이름</option>
            <option value="제목">제목</option>
        </select>
        
        <input type="text" id="searchWord" name="" value="" placeholder="검색" style="width: 300px;">
    </div>

    <table class="table table-striped feedback-table">
        <thead>
            <tr>
                <th scope="col">번호</th>
                <th scope="col">아이디</th>
                <th scope="col">이름</th>
                <th scope="col">이메일</th>
                <th scope="col">제목</th>
                <th scope="col">내용</th>
                <th scope="col">회원고유번호</th>
                <th scope="col">작성날짜</th>
            </tr>
        </thead>
        <tbody id="feedbackTableBody">
            
        </tbody>
    </table>
</div>
  
    </div>


<script defer src="bundle.js"></script>

</body>
</html>