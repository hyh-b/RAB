<%@page import="java.util.List"%>
<%@page import="com.example.model.MemberTO"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	ArrayList<MemberTO> mList = (ArrayList) request.getAttribute("mList");

	int totalRecord = mList.size();
	int cpage = 1;
	int recordPerPage = 10;
	int blockPerPage = 5;
	int totalPage = 1;
	totalPage = ((totalRecord-1)/recordPerPage)+1;
	
	// 페이지 번호 파라미터 가져오기
    if (request.getParameter("cpage") != null) {
        cpage = Integer.parseInt(request.getParameter("cpage"));
    }
    
    // 현재 페이지에 해당하는 회원 목록 가져오기
    int startIndex = (cpage - 1) * recordPerPage;
    int endIndex = Math.min(startIndex + recordPerPage, totalRecord);
    List<MemberTO> currentPageMembers = mList.subList(startIndex, endIndex);
	
	StringBuilder sbHtml = new StringBuilder();
	
	for( MemberTO to : currentPageMembers){
		String m_id = to.getM_id();
		String m_real_name = to.getM_real_name();
		String m_name = to.getM_name();
		String m_mail = to.getM_mail();
		
		sbHtml.append("<tr class='flex cursor-pointer items-center hover:bg-whiten dark:hover:bg-boxdark-2'>");
		sbHtml.append("<td class='w-[35%] py-6 pl-4 pr-4 lg:pr-10 xl:w-[20%]'>");
		sbHtml.append("<p class='text-left font-medium'>"+m_id+"</p>");
		sbHtml.append("</td>");
		sbHtml.append("<td class='w-[35%] py-6 pl-4 pr-4 lg:pr-10 xl:w-[20%]'>");
		sbHtml.append("<p class='text-left font-medium'>"+m_real_name+"</p>");
		sbHtml.append("</td>");
		sbHtml.append("<td class='w-[35%] py-6 pl-4 pr-4 lg:pr-10 xl:w-[20%]'>");
		sbHtml.append("<p class='text-left font-medium'>"+m_name+"</p>");
		sbHtml.append("</td>");
		sbHtml.append("<td class='w-[35%] py-6 pl-4 pr-4 lg:pr-10 xl:w-[20%]'>");
		sbHtml.append("<p class='text-left font-medium'>"+m_mail+"</p>");
		sbHtml.append("</tr>");
		
	}
%>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>관리자 페이지</title>
<link rel="icon" href="favicon.ico"><link href="style.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
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
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

<style type="text/css">
	.theme1 {margin-bottom:30px; border:0px; height:5px; background: linear-gradient(to left, transparent, rgba(255,255,255,.5), transparent);}
	
	/*============ 사이드 로고 메뉴 폰트 ==========*/
	h3.mb-4.ml-4.text-sm.font-medium.text-bodydark2 {
        font-size: 30px;
		cfont-family: 'Cuprum', sans-serif;
    }
	/*=====================================*/
    
	/*============ 사이드 (공지사항 , 게시판 , 식단 , 운동 , 내정보 , 로그아웃) ==========*/
    h1 {
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

<script>
	
	// 날짜 선택 시 해당 날짜 신규, 탈퇴 유저 출력
	function clickDate(date){
		$.ajax({
	        url: 'memberState',
	        type: 'POST',
	        data: { date: date },
	        success: function(response) {
	            /* console.log('신규 가입자 수: ' + response.newMember);
	            console.log('탈퇴한 회원 수: ' + response.deletedMember); */
	            let nMember = response.newMember;
	            let dMember = response.deletedMember;
	            let mHtml = "";
	            mHtml += "<p>신규 회원 수: "+nMember+"명 | 탈퇴 회원 수: "+dMember+"명</p>"
	            $('#memberState').html(mHtml);
	        },
	        error: function(jqXHR, textStatus, errorThrown) {
	            console.error('Fetch error:', errorThrown);
	        }
	    });
	} 

	$(document).ready(function () {
		
		// 달력 
        let today = new Date();
        let dd = String(today.getDate()).padStart(2, '0');
        let mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
        let yyyy = today.getFullYear();

        let currentDate = yyyy + '-' + mm + '-' + dd;
        
        $("#datepicker").datepicker({ 
            dateFormat: 'yy-mm-dd',
            onSelect: function(dateText) {
                clickDate(dateText);
            }
        }).datepicker("setDate", today); // 기본값으로 당일 날짜 출력

        clickDate(currentDate);
		
	  // 검색 버튼 클릭 이벤트 처리
	  $("#sbtn").click(function () {
	    var searchId = $("#searchId").val();
	    // AJAX 요청
	    $.ajax({
	      url: "searchId.do",
	      type: "POST",
	      data: { m_id: searchId },
	      dataType: "json",
	      success: function (data) {
	    	  let searchHtml = '';
	          data.forEach(function (item) {
	            searchHtml += 
	             "<tr class='flex cursor-pointer items-center hover:bg-whiten dark:hover:bg-boxdark-2'>"+
	    		 "<td class='w-[35%] py-6 pl-4 pr-4 lg:pr-10 xl:w-[20%]'>"+
	    		 "<p class='text-left font-medium'>"+item.m_id+"</p>"+
	    		 "</td>"+
	    		 "<td class='w-[35%] py-6 pl-4 pr-4 lg:pr-10 xl:w-[20%]'>" +
	    		 "<p class='text-left font-medium'>"+item.m_real_name+"</p>" +
	    		 "</td>" +
	    		 "<td class='w-[35%] py-6 pl-4 pr-4 lg:pr-10 xl:w-[20%]'>" +
	    		 "<p class='text-left font-medium'>"+item.m_name+"</p>" +
	    		 "</td>" +
	    		 "<td class='w-[35%] py-6 pl-4 pr-4 lg:pr-10 xl:w-[20%]'>" +
	    		 "<p class='text-left font-medium'>"+item.m_mail+"</p>" +
	    		 "</tr>" 
	          });
	          $('#mlist').html(searchHtml);
	        },
	        error: function (xhr, status, error) {
	          console.log(error);
	        }
	    }); 
	  }); 
		
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
  <div class="flex items-center justify-between gap-2 px-6 py-5.5 lg:py-6.5">
    <a href="/admin.do">
    
   <!--  사이트 로고  -->

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
	      <a
	         href="feedback.do"
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
	       <h1>피드백</h1>
	      </a>
	     </li>
	     
	     <li class="sideMenu" style="height: 50px; padding-top: 20px;">
	       <a
	          href="admin.do"
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
	          <h1>회원관리</h1>
	        </a>
	      </li>

	      <li class="sideMenu" style="height: 50px; padding-top: 20px;">
	        <a
	           href="admin_notice_board.do"
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
	            <a href="/klogout.do"><h1>로그아웃</h1></a>
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

    <!-- ===== Sidebar End ===== -->
    
    <!-- ===== Content Area Start ===== -->
    <div class="relative flex flex-1 flex-col overflow-y-auto overflow-x-hidden">
      
      <!-- ===== Header End ===== -->

      <!-- ===== Main Content Start ===== -->
      <main class="u-min-h-screen">
        <div class="mx-auto h-[calc(100vh-80px)] max-w-screen-2xl p-4 md:p-6 2xl:p-10">
          <!-- Breadcrumb Start -->
          <div class="mb-6 flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
            <h2 class="text-title-md2 font-bold text-black dark:text-white">
              회원관리
            </h2>

            
          </div>
          <!-- Breadcrumb End -->

          <div class="h-[calc(100vh-186px)] overflow-hidden sm:h-[calc(100vh-174px)]">
            <div x-data="{inboxSidebarToggle: false}" class="h-full rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark lg:flex">
              <div class="flex h-full flex-col border-l border-stroke dark:border-strokedark lg:w-4/5">
                <!-- ====== Inbox List Start -->
                <div
                  class="flex flex-col-reverse justify-between gap-6 py-4.5 pl-4 pr-4 sm:flex-row lg:pl-10 lg:pr-7.5">
                  <div class="flex items-center gap-4">
					총 회원 수 : <%= totalRecord %>명
                  </div>
				  <div>
				  	<input type="text" id="datepicker" placeholder="날짜 선택" class="rounded-sm border border-stroke bg-white shadow-default">
				  </div>
				  
				  <div id="memberState"></div>
				  
                  <div class="relative">
                    <input type="text" id="searchId" placeholder="Search id"
                      class="block w-full bg-transparent pl-7 pr-25 font-medium outline-none" />
                    <button id="sbtn" name="sbtn" class="absolute right-0 top-1/2 -translate-y-1/2">
                      검색
                    </button>
                  </div>
                </div>

                <div class="h-full">
                  <table class="h-full w-full table-auto">
                    <thead>
                      <tr class="flex border-y border-stroke dark:border-strokedark">
                        <th class="w-[35%] py-6 pl-4 pr-4 lg:pr-10 xl:w-[20%]">
                          <p class="text-left font-medium">아이디</p>
                        </th>
                        <th class="w-[35%] py-6 pl-4 pr-4 lg:pr-10 xl:w-[20%]">
                          <p class="text-left font-medium">이름</p>
                        </th>
                        <th class="w-[35%] py-6 pl-4 pr-4 lg:pr-10 xl:w-[20%]">
                          <p class="text-left font-medium">닉네임</p>
                        </th>
                        <th class="w-[35%] py-6 pl-4 pr-4 lg:pr-10 xl:w-[40%]">
                          <p class="text-left font-medium">이메일</p>
                        </th>
                      </tr>
                    </thead>
                    <tbody id="mlist" class="block h-full max-h-full overflow-auto py-4">
                    
                     <%= sbHtml %> 
                      
                      
                      
                    </tbody>
                  </table>
                </div>

                <div
                  class="flex items-center justify-between border-t border-stroke p-4 dark:border-strokedark sm:px-6">
                  <p class="text-base font-medium text-black dark:text-white md:text-lg">
                   		 <%
							int startBlock = cpage -(cpage-1)%blockPerPage;
							int endBlock = cpage -(cpage-1)%blockPerPage+blockPerPage-1;
							if(endBlock >= totalPage){
								endBlock = totalPage;
							}
							
							if(startBlock==1){
								out.println("<span><a>&lt;&lt;</a></span>");
							}else{
								out.println("<span><a href='admin.do?cpage="+(startBlock-blockPerPage)+"'>&lt;&lt;</a></span>");
							}
						
							out.println("&nbsp;");
							
							if(cpage==1){
								out.println("<span><a>&lt;</a></span>");
							}else{
								out.println("<span><a href='admin.do?cpage="+(cpage-1)+"'>&lt;</a></span>");
							}
							out.println("&nbsp;&nbsp;");
							for(int i=startBlock; i<=endBlock; i++){
								if(cpage==i){
									out.println("<span><a>"+"[ "+i+" ]"+"</a></span>");
								}else{
									out.println("<span><a href='admin.do?cpage="+i+"'>"+i+"</a></span>");
								}
							}
							
							if(cpage==totalPage){
								out.println("<span><a>&gt;</a></span>");
							}else{
								out.println("<span><a href='admin.do?cpage="+(cpage+1)+"'>&gt;</a></span>");
							}
							out.println("&nbsp;");
							if(endBlock==totalPage){
								out.println("<span><a>&gt;&gt;</a></span>");
							}else{
								out.println("<span><a href='admin.do?cpage="+(startBlock+blockPerPage)+"'>&gt;&gt;</a></span>");
							}
						%>
                  </p>
                  
                </div>
                <!-- ====== Inbox List End -->
              </div>
            </div>
          </div>
        </div>
      </main>
      <!-- ===== Main Content End ===== -->
    </div>
  </div>
  <!-- ===== Page Wrapper End ===== -->
<script defer src="bundle.js"></script>
</body>
</html>