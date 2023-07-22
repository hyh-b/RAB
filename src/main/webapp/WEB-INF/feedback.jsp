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
<link rel="icon" href="favicon.ico"><link href="style.css" rel="stylesheet"></head>
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


<script defer src="bundle.js"></script></body>

</html>