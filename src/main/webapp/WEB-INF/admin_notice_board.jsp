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
	 main {
	    width: 100%;
	    height: 100vh;
	    overflow: auto;
	}
</style>





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
              href="boardManagement.do"
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

              게시물관리
            </a>
          </li>
          <!-- Menu Item Calendar -->

          <!-- Menu Item Profile -->
          <li>
            <a
              class="group relative flex items-center gap-2.5 rounded-sm py-2 px-4 font-medium text-bodydark1 duration-300 ease-in-out hover:bg-graydark dark:hover:bg-meta-4"

              href="feedback.do"
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
             	피드백
            </a>
          </li>
          <!-- Menu Item Profile -->

              <!-- Menu Item Profile2 -->
          <li>
            <a
              class="group relative flex items-center gap-2.5 rounded-sm py-2 px-4 font-medium text-bodydark1 duration-300 ease-in-out hover:bg-graydark dark:hover:bg-meta-4"
              href="admin.do"
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
             	회원관리
            </a>
          </li>
          <!-- Menu Item Profile2 -->
       

          <!-- Menu Item Forms -->

          <!-- Menu Item Tables -->
          <li>
            <a
              class="group relative flex items-center gap-2.5 rounded-sm py-2 px-4 font-medium text-bodydark1 duration-300 ease-in-out hover:bg-graydark dark:hover:bg-meta-4"
              href="admin_notice_board.do"

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

              공지사항
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

       
    <!-- Sidebar Menu -->

    <!-- Promo Box -->

    <!-- Promo Box -->
  </div>
</aside>

      <!-- ===== Header End ===== -->

      <!-- ===== Main Content Start ===== -->
      <main>
   <!-- ============  게시판 여기부터 시작	=================================== -->
  <table>
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
		                       <td><a href="/admin_notice_board_view.do?cpage=${cpage}&n_seq=${noticeBoard.n_seq}">${noticeBoard.n_subject}</a></td>
		                        <td style="text-align: center;">${noticeBoard.n_wdate}</td>
		                        <td style="text-align: center;">${noticeBoard.n_hit}</td>
		                    </tr>
		                </c:forEach>
		            </tbody>		            
  			</table>		
			<a href="notice_board_write.do?cpage=${cpage}"
			   class="inline-flex items-center justify-center rounded-full bg-primary py-2 px-5 text-center font-medium text-white hover:bg-opacity-90 lg:px-8 xl:px-10" 
			   style="float: right;">
			   쓰기
			</a>

		
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
					    <span><a href="/admin_notice_board.do?cpage=${startBlock - blockPerPage}">&lt;&lt;</a></span>
					  </c:otherwise>
					</c:choose>
					&nbsp;
					<c:choose>
					  <c:when test="${cpage == 1}">
					    <span><a>&lt;</a></span>
					  </c:when>
					  <c:otherwise>
					    <span><a href="/admin_notice_board.do?cpage=${cpage - 1}">&lt;</a></span>
					  </c:otherwise>
					</c:choose>
					&nbsp;
					<c:forEach begin="${startBlock}" end="${endBlock}" var="i">
					  <c:choose>
					    <c:when test="${i eq cpage}">
					      <span><a>[${i}]</a></span>
					    </c:when>
					    <c:otherwise>
					      <span><a href="/admin_notice_board.do?cpage=${i}">${i}</a></span>
					    </c:otherwise>
					  </c:choose>
					</c:forEach>
					&nbsp;
					<c:choose>
					  <c:when test="${cpage == totalPage}">
					    <span><a>&gt;</a></span>
					  </c:when>
					  <c:otherwise>
					    <span><a href="/admin_notice_board.do?cpage=${cpage + 1}">&gt;</a></span>
					  </c:otherwise>
					</c:choose>	
					&nbsp;
					
					<c:choose>
					  <c:when test="${endBlock == totalPage}">
					    <span><a>&gt;&gt;</a></span>
					  </c:when>
					  <c:otherwise>
					    <span><a href="/admin_notice_board.do?cpage=${startBlock + blockPerPage}">&gt;&gt;</a></span>
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