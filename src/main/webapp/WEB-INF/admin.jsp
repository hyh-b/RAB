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
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
<script src="https://code.jquery.com/ui/1.13.0/jquery-ui.min.js"></script>
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script>
	
	// 날짜 선택 시 해당 날짜 신규, 탈퇴 유저 출력
	function clickDate(date){
		$.ajax({
	        url: 'memberState',
	        type: 'POST',
	        data: { date: date },
	        success: function(response) {
	            console.log('신규 가입자 수: ' + response.newMember);
	            console.log('탈퇴한 회원 수: ' + response.deletedMember);
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
              href="adminAnnouncement.do"

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

              공지사함
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