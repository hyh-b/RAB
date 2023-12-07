<%@page import="java.security.Principal"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>로그인</title>
<link rel="icon" href="favicon.ico"><link href="style.css" rel="stylesheet">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<script type="text/javascript">
	
	$(document).ready(function() {
		//아이디 찾기 
		$('#idBtn').click(function(event) {
			event.preventDefault();
			
			var email = $('#email').val();
			
			$.ajax({
				url: '/findId',
				method: 'POST',
				dataType: 'json',
				contentType: "application/json",
				data: JSON.stringify({ email: email }),
				success: function(data) {
					if(data.length > 0) {
						var idString = "등록된 아이디는 " + data.join(", ") + " 입니다.";
						$('#findId').text(idString);
					} else {
						$('#findId').text("해당 이메일로 가입된 아이디를 찾을 수 없습니다.");
					}
				},
				error: function(error) {
					console.log('Error:', error);
				}
			});
		});
		
		// 비밀번호 찾기
		$('#pwBtn').click(function(event) {
			event.preventDefault();
			
			var email = $('#email2').val();
			var id = $("#wId").val();
			
			swal({
		        title: "처리 중...",
		        text: "잠시만 기다려주세요",
		        icon: "info",
		        button: false,
		        closeOnClickOutside: false,
		        closeOnEsc: false
		    });
			
			$.ajax({
				url: '/findPw',  
			      type: 'post',
			      data: JSON.stringify({m_id: id, m_mail: email}),
			      contentType: "application/json; charset=utf-8",
			      dataType: "json",
			      success: function(flag) {
			          if (flag > 0) {
			            //alert("메일이 전송되었습니다.");
			            swal({
			                  title: "성공!",
			                  text: "메일이 전송되었습니다",
			                  icon: "success",
			                  button: "확인",
			             });

			            
			            document.querySelector('[x-data]').__x.$data.reset();
			          }
			          else {
			            //alert("아이디와 이메일과 일치하는 회원이 존재하지 않습니다");
			            swal({
				    		  title: "실패!",
				    		  text: "아이디와 이메일과 일치하는 회원이 존재하지 않습니다",
				    		  icon: "error",
				    		  button: "확인",
				    		  zIndex: 9999999999999
				    	});
			            
			          }
				},
				error: function(jqXHR, textStatus, errorThrown) {
			        alert("오류가 발생했습니다. 다시 시도해주세요.");
				}
			});
		});
		
	});
</script>
<style>
    .fixed {
        z-index: 9999;
    }
    
    [x-cloak] { display: none; }
    
</style>
</head>
<body
  x-data="{ page: 'signin', 'loaded': true, 'darkMode': true, 'stickyMenu': false, 'sidebarToggle': false, 'scrollTop': false }"
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

<!-- id,pw 불일치로 로그인 실패시 signin.do?error페이지로 전송 후 메세지 출력 -->
<% if (request.getParameter("error") != null) { %>
    <script>
    	
    	swal({
		  title: "실패!",
		  text: "아이디 혹은 비밀번호가 일치하지 않습니다",
		  icon: "error",
		  button: "확인",
		});
    </script>
<% }
	String kId = request.getParameter("kId");
	String kPw = request.getParameter("kPw");
	String sId = request.getParameter("sId");
	String sPw = request.getParameter("sPw");
	//회원가입을 마친 이용자들은 바로 로그인 됨
	if( kPw != null || sId != null) { %>
	<script type='text/javascript'>
        window.onload = function() {
        	document.getElementById('login').click();
        };
    </script>
    
<% } %>

  <div
    class="h-16 w-16 animate-spin rounded-full border-4 border-solid border-primary border-t-transparent"
  ></div>
</div>

  <!-- ===== Preloader End ===== -->

  <!-- ===== Page Wrapper Start ===== -->
  <div class="flex h-screen overflow-hidden">

    <!-- ===== Content Area Start ===== -->
    <div class="relative flex flex-1 flex-col overflow-y-auto overflow-x-hidden">
      <!-- ===== Header Start ===== -->
      <header
  class="sticky top-0 z-999 flex w-full bg-white drop-shadow-1 dark:bg-boxdark dark:drop-shadow-none"
>
  <div
    class="flex flex-grow items-center justify-between py-4 px-4 shadow-2 md:px-6 2xl:px-11"
  >
    <div class="flex items-center gap-2 sm:gap-4 lg:hidden">
      
    </div>
    <div class="hidden sm:block">
      
    </div>

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
                    d="M8.00008 15.3067C7.63341 15.3067 7.33342 15.0334 7.33342 14.6667V14.6134C7.33342 14.2467 7.63341 13.9467 8.00008 13.9467C8.36675 13.9467 8.66675 14.2467 8.66675 14.6134C8.66675 14.9801 8.36675 15.3067 8.00008 15.3067ZM12.7601 13.4267C12.5867 13.4267 12.4201 13.3601 12.2867 13.2334L12.2001 13.1467C11.9401 12.8867 11.9401 12.4667 12.2001 12.2067C12.4601 11.9467 12.8801 11.9467 13.1401 12.2067L13.2267 12.2934C13.4867 12.5534 13.4867 12.9734 13.2267 13.2334C13.1001 13.3601 12.9334 13.4267 12.7601 13.4267ZM3.24008 13.4267C3.06675 13.4267 2.90008 13.3601 2.76675 13.2334C2.50675 12.9734 2.50675 12.5534 2.76675 12.2934L2.85342 12.2067C3.11342 11.9467 3.53341 11.9467 3.79341 12.2067C4.05341 12.4667 4.05341 12.8867 3.79341 13.1467L3.70675 13.2334C3.58008 13.3601 3.40675 13.4267 3.24008 13.4267ZM14.6667 8.66675H14.6134C14.2467 8.66675 13.9467 8.36675 13.9467 8.00008C13.9467 7.63341 14.2467 7.33342 14.6134 7.33342C14.9801 7.33342 15.3067 7.63341 15.3067 8.00008C15.3067 8.36675 15.0334 8.66675 14.6667 8.66675ZM1.38675 8.66675H1.33341C0.966748 8.66675 0.666748 8.36675 0.666748 8.00008C0.666748 7.63341 0.966748 7.33342 1.33341 7.33342C1.70008 7.33342 2.02675 7.63341 2.02675 8.00008C2.02675 8.36675 1.75341 8.66675 1.38675 8.66675ZM12.6734 3.99341C12.5001 3.99341 12.3334 3.92675 12.2001 3.80008C11.9401 3.54008 11.9401 3.12008 12.2001 2.86008L12.2867 2.77341C12.5467 2.51341 12.9667 2.51341 13.2267 2.77341C13.4867 3.03341 13.4867 3.45341 13.2267 3.71341L13.1401 3.80008C13.0134 3.92675 12.8467 3.99341 12.6734 3.99341ZM3.32675 3.99341C3.15341 3.99341 2.98675 3.92675 2.85342 3.80008L2.76675 3.70675C2.50675 3.44675 2.50675 3.02675 2.76675 2.76675C3.02675 2.50675 3.44675 2.50675 3.70675 2.76675L3.79341 2.85342C4.05341 3.11342 4.05341 3.53341 3.79341 3.79341C3.66675 3.92675 3.49341 3.99341 3.32675 3.99341ZM8.00008 2.02675C7.63341 2.02675 7.33342 1.75341 7.33342 1.38675V1.33341C7.33342 0.966748 7.63341 0.666748 8.00008 0.666748C8.36675 0.666748 8.66675 0.966748 8.66675 1.33341C8.66675 1.70008 8.36675 2.02675 8.00008 2.02675Z"
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
          <!-- Dark Mode Toggler -->
        </li>

        <!-- Notification Menu Area -->
         <li
          class="relative"
          x-data="{ dropdownOpen: false, notifying: true }"
          @click.outside="dropdownOpen = false"
        >
        
          <!-- Dropdown End -->
        </li>
        <!-- Notification Menu Area -->

        <!-- Chat Notification Area -->
         <li
          class="relative"
          x-data="{ dropdownOpen: false, notifying: true }"
          @click.outside="dropdownOpen = false"
        >
        </li>
        <!-- Chat Notification Area -->
      </ul>

      <!-- User Area -->
      <div
        class="relative"
        x-data="{ dropdownOpen: false }"
        @click.outside="dropdownOpen = false"
      >
        <!-- Dropdown Start -->
        <div
          x-show="dropdownOpen"
          class="absolute right-0 mt-4 flex w-62.5 flex-col rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark"
        >
          
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
          <!-- Breadcrumb Start -->
          <div class="mb-6 flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
            <h2 class="text-title-md2 font-bold text-black dark:text-white">
              로그인
            </h2>
           
          </div>
          <!-- Breadcrumb End -->

          <!-- ====== Forms Section Start -->
          <div class="rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark">
            <div class="flex flex-wrap items-center">
              <div class="hidden w-full xl:block xl:w-1/2">
                <div class="py-17.5 px-26 text-center flex items-center"> <!-- added flex and items-center -->
				    <a href="/" style="flex: 1;">
				        <img src="src/images/logo/rocatNOb.png" />
				    </a>
				    <div style="flex: 2; display: flex; flex-direction: column; align-items: center; justify-content: center; font-weight: bold; color: black;">
				        <p class="mb-9 text-2xl font-bold text-black dark:text-white sm:text-title-xl2">WELCOME!</p><br>
				        <p class="mb-9 text-2xl font-bold text-black dark:text-white sm:text-title-xl2">로그인하여 더욱 많은<br>컨텐츠를 즐겨보세요</p>
				    </div>
				</div>
              </div>
              <div class="w-full border-stroke dark:border-strokedark xl:w-1/2 xl:border-l-2">
                <div class="w-full p-4 sm:p-12.5 xl:p-17.5">
                  <span class="mb-1.5 block font-medium">Start for free</span>
                  <h2 class="mb-9 text-2xl font-bold text-black dark:text-white sm:text-title-xl2">
                    Sign In to RockAtYourBody
                  </h2>
					<!-- 회원가입에 성공한 유저들은 id, pw 자동 입력 -->
                  <form action='<c:url value="/signin_ok"/>'method="post" name="sfrm" id="sfrm" >
       			  	<div class="mb-4">
                      <label class="mb-2.5 block font-medium text-black dark:text-white">아이디</label>
                      	<div class="relative">
                      		<%if( kId != null ) { %>
		                        <input type="text" placeholder="id" name="id" id="id" value=<%=kId %>
		                        class="w-full rounded-lg border border-stroke bg-transparent py-4 pl-6 pr-10 outline-none focus:border-primary focus-visible:shadow-none dark:border-form-strokedark dark:bg-form-input dark:focus:border-primary" /> 
		                    <%} else if(sId != null){%>
		                        <input type="text" placeholder="id" name="id" id="id" value=<%= sId %>
		                        class="w-full rounded-lg border border-stroke bg-transparent py-4 pl-6 pr-10 outline-none focus:border-primary focus-visible:shadow-none dark:border-form-strokedark dark:bg-form-input dark:focus:border-primary" />
							<%} else{ %>
								<input type="text" placeholder="id" name="id" id="id" value=''
		                        class="w-full rounded-lg border border-stroke bg-transparent py-4 pl-6 pr-10 outline-none focus:border-primary focus-visible:shadow-none dark:border-form-strokedark dark:bg-form-input dark:focus:border-primary" />
							<%} %>
	                        <span class="absolute right-4 top-4">
	                          <svg class="fill-current" width="22" height="22" viewBox="0 0 22 22" fill="none"
	                            xmlns="http://www.w3.org/2000/svg">
	                            <g opacity="0.5">
	                              <path
	                                d="M19.2516 3.30005H2.75156C1.58281 3.30005 0.585938 4.26255 0.585938 5.46567V16.6032C0.585938 17.7719 1.54844 18.7688 2.75156 18.7688H19.2516C20.4203 18.7688 21.4172 17.8063 21.4172 16.6032V5.4313C21.4172 4.26255 20.4203 3.30005 19.2516 3.30005ZM19.2516 4.84692C19.2859 4.84692 19.3203 4.84692 19.3547 4.84692L11.0016 10.2094L2.64844 4.84692C2.68281 4.84692 2.71719 4.84692 2.75156 4.84692H19.2516ZM19.2516 17.1532H2.75156C2.40781 17.1532 2.13281 16.8782 2.13281 16.5344V6.35942L10.1766 11.5157C10.4172 11.6875 10.6922 11.7563 10.9672 11.7563C11.2422 11.7563 11.5172 11.6875 11.7578 11.5157L19.8016 6.35942V16.5688C19.8703 16.9125 19.5953 17.1532 19.2516 17.1532Z"
	                                fill="" />
	                            </g>
	                          </svg>
	                        </span>
                      </div>
                    </div>

                    <div class="mb-6">
                      <label class="mb-2.5 block font-medium text-black dark:text-white">비밀번호</label>
                      <div class="relative">
	                  	<%if( kId != null ) { %>
	                      	<input type="password" placeholder="password" name="password" id="password" value=<%=kPw %>
	                        class="w-full rounded-lg border border-stroke bg-transparent py-4 pl-6 pr-10 outline-none focus:border-primary focus-visible:shadow-none dark:border-form-strokedark dark:bg-form-input dark:focus:border-primary" />
						<%} else if(sId != null){%>
							<input type="password" placeholder="password" name="password" id="password" value=<%=sPw %>
	                        class="w-full rounded-lg border border-stroke bg-transparent py-4 pl-6 pr-10 outline-none focus:border-primary focus-visible:shadow-none dark:border-form-strokedark dark:bg-form-input dark:focus:border-primary" />
						<%} else{%>
							<input type="password" placeholder="password" name="password" id="password" value=''
	                        class="w-full rounded-lg border border-stroke bg-transparent py-4 pl-6 pr-10 outline-none focus:border-primary focus-visible:shadow-none dark:border-form-strokedark dark:bg-form-input dark:focus:border-primary" />
						<%} %>
	                        <span class="absolute right-4 top-4">
	                          <svg class="fill-current" width="22" height="22" viewBox="0 0 22 22" fill="none"
	                            xmlns="http://www.w3.org/2000/svg">
	                            <g opacity="0.5">
	                              <path
	                                d="M16.1547 6.80626V5.91251C16.1547 3.16251 14.0922 0.825009 11.4797 0.618759C10.0359 0.481259 8.59219 0.996884 7.52656 1.95938C6.46094 2.92188 5.84219 4.29688 5.84219 5.70626V6.80626C3.84844 7.18438 2.33594 8.93751 2.33594 11.0688V17.2906C2.33594 19.5594 4.19219 21.3813 6.42656 21.3813H15.5016C17.7703 21.3813 19.6266 19.525 19.6266 17.2563V11C19.6609 8.93751 18.1484 7.21876 16.1547 6.80626ZM8.55781 3.09376C9.31406 2.40626 10.3109 2.06251 11.3422 2.16563C13.1641 2.33751 14.6078 3.98751 14.6078 5.91251V6.70313H7.38906V5.67188C7.38906 4.70938 7.80156 3.78126 8.55781 3.09376ZM18.1141 17.2906C18.1141 18.7 16.9453 19.8688 15.5359 19.8688H6.46094C5.05156 19.8688 3.91719 18.7344 3.91719 17.325V11.0688C3.91719 9.52189 5.15469 8.28438 6.70156 8.28438H15.2953C16.8422 8.28438 18.1141 9.52188 18.1141 11V17.2906Z"
	                                fill="" />
	                              <path
	                                d="M10.9977 11.8594C10.5852 11.8594 10.207 12.2031 10.207 12.65V16.2594C10.207 16.6719 10.5508 17.05 10.9977 17.05C11.4102 17.05 11.7883 16.7063 11.7883 16.2594V12.6156C11.7883 12.2031 11.4102 11.8594 10.9977 11.8594Z"
	                                fill="" />
	                            </g>
	                          </svg>
	                        </span>
	               <!---------------- 로그인 상태 유지 체크박스 ------------>
	                        <input type="checkbox" id="remember-me" name="remember-me">&nbsp;로그인 상태 유지
                      </div>
                    </div>
					
                    <div class="mb-5">
                      <input id="login" type="submit" value="로그인" 
                        class="w-full cursor-pointer rounded-lg border border-primary bg-primary p-4 font-medium text-white transition hover:bg-opacity-90" />
                    </div>
                  
                    <div class="mt-6 text-center">
                      <p class="font-medium">
                        회원이 아니신가요?
                        <a href="signup.do" class="text-primary">회원가입</a>
                      </p>
                     
                    </div>
                  </form>
                  
				<!-----------------아이디/비밀번호 찾기 ---------------> 
				<div class="flex flex-wrap justify-center gap-5">
					<div x-data="{modalOpen: false, reset() { this.modalOpen = false; document.getElementById('email').value = ''; document.getElementById('findId').innerHTML = ''; } }">
						<button @click="modalOpen = true" >
							아이디 찾기
						</button>
						<div x-show.transition="modalOpen" x-cloak class="fixed top-0 left-0 z-999999 flex h-full min-h-screen w-full items-center justify-center bg-black/90 px-4 py-5">
							<div @click.outside="reset" class="w-full max-w-142.5 rounded-lg bg-white py-12 px-8 text-center dark:bg-boxdark md:py-15 md:px-17.5">
							<h3 class="pb-2 text-xl font-bold text-black dark:text-white sm:text-2xl ">
							  아이디 찾기
							</h3>
							<span class="mx-auto mb-6 inline-block h-1 w-22.5 rounded bg-primary"></span>
					
							<form id="findIdForm">
								<div class="mb-3">
								  <div id="emailHelp" class="form-text" style="font-weight: bold; font-size:20px;">가입 시 등록했던 이메일 주소를 입력해주세요.
								  </div>
								  <input type="email" class="form-control w-full rounded-lg border-[1.5px] border-primary bg-transparent py-3 px-5 font-medium outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:bg-form-input" id="email" aria-describedby="emailHelp">
								</div>
							</form>
					  
							<div id="findId" style="font-weight: bold; font-size:20px;">
							</div><br>
							
							<div class="-mx-3 flex flex-wrap gap-y-4">
								<div class="w-full px-3 2xsm:w-1/2">
									<button id="idBtn" class="block w-full rounded border border-stroke bg-gray p-3 text-center font-medium text-black transition hover:border-meta-1 hover:bg-meta-1 hover:text-white dark:border-strokedark dark:bg-meta-4 dark:text-white dark:hover:border-meta-1 dark:hover:bg-meta-1">
										찾기
									</button>
								</div>
								<div class="w-full px-3 2xsm:w-1/2">
								    <button @click="modalOpen = false; reset()" class="block w-full rounded border border-primary bg-primary p-3 text-center font-medium text-white transition hover:bg-opacity-90">
								    	닫기
								    </button>
								</div>
							</div>
						</div>
					</div>
                </div>
                
          
                
				<div x-data="{modalOpen: false, reset() { this.modalOpen = false; clearFields(); } }">
					<button @click="modalOpen = true">
					    비밀번호 찾기
					</button>
				
					<div x-show.transition="modalOpen" x-cloak class="fixed top-0 left-0 z-999999 flex h-full min-h-screen w-full items-center justify-center bg-black/90 px-4 py-5">
					    <!-- 비밀번호 찾기 모달 내용 -->
					    <div @click.outside="reset" class="w-full max-w-142.5 rounded-lg bg-white py-12 px-8 text-center dark:bg-boxdark md:py-15 md:px-17.5">
							<h3 class="pb-2 text-xl font-bold text-black dark:text-white sm:text-2xl ">
							  비밀번호 찾기
							</h3>
							<span class="mx-auto mb-6 inline-block h-1 w-22.5 rounded bg-primary"></span>
					
							<form id="findPwForm">
							    <div class="mb-3">
									<div id="writeIdHelp" class="form-text" style="font-weight: bold; font-size:20px;">
									    아이디를 입력해주세요
									</div>
									<input type="text" class="form-control w-full rounded-lg border-[1.5px] border-primary bg-transparent py-3 px-5 font-medium outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:bg-form-input" id="wId" aria-describedby="emailHelp">
									<div><br></div>
									<div id="pwEmailHelp" class="form-text" style="font-weight: bold; font-size:20px;">
									    가입 시 등록했던 이메일 주소를 입력해주세요.
									</div>
									<input type="email" class="form-control w-full rounded-lg border-[1.5px] border-primary bg-transparent py-3 px-5 font-medium outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:bg-form-input" id="email2" aria-describedby="emailHelp">
									<div><br></div>
									<div class="form-text" style="font-weight: bold; font-size:15px;">
									    확인 버튼을 누르시면 잠시 후 메일이 전송됩니다
									</div>
							    </div>
							</form>
							
							<div class="-mx-3 flex flex-wrap gap-y-4">
								<div class="w-full px-3 2xsm:w-1/2">
								    <button id="pwBtn" class="block w-full rounded border border-stroke bg-gray p-3 text-center font-medium text-black transition hover:border-meta-1 hover:bg-meta-1 hover:text-white dark:border-strokedark dark:bg-meta-4 dark:text-white dark:hover:border-meta-1 dark:hover:bg-meta-1">
										확인
									</button>
								</div>
								<div class="w-full px-3 2xsm:w-1/2">
								    <button @click="reset" class="block w-full rounded border border-primary bg-primary p-3 text-center font-medium text-white transition hover:bg-opacity-90">
								    	닫기
								    </button>
								</div>
							</div>
					    </div>
					</div>
				</div>
            </div>
          </div>
          <!-- ====== Forms Section End -->
        </div>
      </main>
      <!-- ===== Main Content End ===== -->
    </div>
    <!-- ===== Content Area End ===== -->
  </div>
  <!-- ===== Page Wrapper End ===== -->
<script defer src="bundle.js"></script>
<script type="text/javascript">
function clearFields() {
    document.getElementById('wId').value = ''; 
    document.getElementById('email2').value = ''; 
    document.getElementById('findId').innerHTML = ''; 
}
</script>
</body>
</html>