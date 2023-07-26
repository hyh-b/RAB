<%@page import="com.example.model.NoticeBoardTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="n_seq" value="${requestScope.n_seq}" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>공지사항</title>
<link rel="icon" href="favicon.ico"><link href="style.css" rel="stylesheet">
<script src="https://kit.fontawesome.com/efe58e199b.js" crossorigin="anonymous"></script>

<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
<link rel="stylesheet" href="https://code.jquery.com/ui/1.13.0/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/ui/1.13.0/jquery-ui.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
<style>
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
<script>
$(document).ready(function() {
	  $('#ubtn').click(function(e) {
	    e.preventDefault(); // 폼의 기본 제출 동작을 방지합니다.
	    
	    if ($('#n_subject').val().trim() == '') {
	    	swal({
	    		  title: "제목을 입력하세요",
	    		  text: "제목을 입력하세요!",
	    		  icon: "error",
	    		  button: "확인",
	    		});
	      return false;
	    }
	    
	    let formData = new FormData($('form[name="ufrm"]')[0]);	   

	    $.ajax({
	      url: 'notice_board_modify_ok.do?n_seq=${n_seq}',
	      data: formData,
	      dataType: 'json',
	      type: 'post',
	      contentType: false,
	      processData: false,
	      success: function(json) {
	        if (json.flagAB == '1' && json.flag == '1') {
	        	swal({
	                title: "성공!",
	                text: "수정에 성공했습니다.",
	                icon: "success",
	                button: "확인",
	              }).then(function() { window.location.href='admin_notice_board.do'; });
	   
	        } else {
	        	 swal({
	                 title: "실패",
	                 text: "수정에 실패했습니다.",
	                 icon: "error",
	                 button: "확인",
	               }).then(function() { history.back(); });
	        }

	      },
	      error: function(e) {
	        alert('[에러]' + e.status);
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


      <!-- ===== Header End ===== -->

      <!-- ===== Main Content Start ===== -->
      <main>
  			<!-- ============  write 여기부터 시작	=================================== -->

	<form action="notice_board_modify_ok.do?n_seq=${n_seq}" method="post" name="ufrm" enctype="multipart/form-data">
  <div class="button-container">
    <div class="upload-container">
      <div class="rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark">
        <div class="board_write">
          <div class="border-b border-stroke py-4 px-6.5 dark:border-strokedark">
            <table>
              <tr>
                <th>제목</th>
                <td colspan="3"><input type="text" name="n_subject" value="" id="n_subject" class="board_view_input" /></td>
              </tr>
              <tr>
                <th>내용</th>
                <td colspan="3">
                  <textarea name="n_content" id="n_content" class="board_editor_area"></textarea>
                </td>
              </tr>
             <tr>
				    <th>사진 등록</th>
					    <td colspan="3">
					        <div class="flex">
					            <input type="file" name="upload" multiple class="w-full cursor-pointer rounded-lg border-[1.5px] border-stroke bg-transparent font-medium outline-none transition file:mr-5 file:border-collapse file:cursor-pointer file:border-0 file:border-r file:border-solid file:border-stroke file:bg-whiter dark:file:bg-white/30 dark:file:text-white file:py-3 file:px-5 file:hover:bg-primary file:hover:bg-opacity-10 focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:file:border-form-strokedark dark:focus:border-primary" />
					        </div>
					   </td>
				</tr>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div class="btn_area">
    <div class="align_left">
	    <input type="button" value="목록" class="inline-flex items-center justify-center rounded-full bg-primary py-2 px-5 text-center font-medium text-white hover:bg-opacity-90 lg:px-8 xl:px-10" style="cursor: pointer; float: right;" onclick="location.href='admin_notice_board.do?cpage=${noticeListTO.cpage}'" />
	</div>
    <div class="align_right">
	    <input type="submit" id="ubtn" value="등록" class="inline-flex items-center justify-center rounded-full bg-primary py-2 px-5 text-center font-medium text-white hover:bg-opacity-90 lg:px-8 xl:px-10" style="cursor: pointer; float: right;" />
	</div>
  </div>
</form>


	    <!-- ============  Write 여기서 끝=================================== -->
		
				
      <!-- ===== Main Content End ===== -->
    </div>
    <!-- ===== Content Area End ===== -->
  </div>
  <!-- ===== Page Wrapper End ===== -->

<script defer src="bundle.js"></script>
</body>

</html>