<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>회원가입</title>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<link rel="icon" href="favicon.ico"><link href="style.css" rel="stylesheet"></head>

<body
  x-data="{ page: 'signup', 'loaded': true, 'darkMode': true, 'stickyMenu': false, 'sidebarToggle': false, 'scrollTop': false }"
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
      <a class="block flex-shrink-0 lg:hidden" href="index.html">
        <img src="src/images/logo/logo-icon.svg" alt="Logo" />
      </a>
    </div>
    <div class="hidden sm:block">
      <!-- 기존 검색창 부분 -->
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
		<!-- 기존 알림 메뉴자리 -->
        <!-- Chat Notification Area -->
        <li
          class="relative"
          x-data="{ dropdownOpen: false, notifying: true }"
          @click.outside="dropdownOpen = false"
        >
          <!-- 기존 채팅 메뉴자리 -->
          <!-- Dropdown End -->
        </li>
        <!-- Chat Notification Area -->
      </ul>

      <!-- User Area -->
      <div
        class="relative"
        x-data="{ dropdownOpen: false }"
        @click.outside="dropdownOpen = false"
      >
        <!-- 기존 회원정보 메뉴 자리 -->
        
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
              회원가입
            </h2>

            <nav>
             
            </nav>
          </div>
          <!-- Breadcrumb End -->

          <!-- ====== Forms Section Start -->
          <div class="rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark">
            <div class="flex flex-wrap items-center">
              <div class="hidden w-full xl:block xl:w-1/2">
                <div class="py-17.5 px-26 text-center">
                  <p style = "font-size: 20px; font-weight: bold; color: black;s">
                    Rock At Your Body와 함께<br> 건강한 하루를 보내봐요!
                  </p>
                  <span class="mt-15 inline-block">
				       <a href="/"><img src="src/images/logo/rocatNOb.png" width="90%" height="90%" ></a>
                  </span>
                </div>
              </div>
              <div class="w-full border-stroke dark:border-strokedark xl:w-1/2 xl:border-l-2">
                <div class="w-full p-4 sm:p-12.5 xl:p-17.5">
                  <span class="mb-1.5 block font-medium">Start for free</span>
                  <h2 class="mb-9 text-2xl font-bold text-black dark:text-white sm:text-title-xl2">
                    Sign Up to RockAtYourBody
                  </h2>

                  <form action="signup_ok.do" method="post" id ="sfrm" name="sfrm" onsubmit="return validateForm()">
                  	<div class="mb-4">
                      <label class="mb-2.5 block font-medium text-black dark:text-white">아이디</label>
                      <div class="relative flex">
					        <input type="text" placeholder="20자 이내" id="id" name="id" required maxlength="20" required oninput = "checkId()"
					            class="w-auto flex-grow rounded-lg border border-stroke bg-transparent py-4 pl-6 pr-10 outline-none focus:border-primary focus-visible:shadow-none dark:border-form-strokedark dark:bg-form-input"
					            oninput="removeSpaces(this);" />
					        
					    </div>
                    </div>
                    <!-- 아이디 중복값에 따라 표시되는 텍스트 -->
					<span id="idOk" style="color:green; font-weight: bold; display:none;">사용 가능한 아이디입니다</span>
					<span id="idNo" style="color:red; font-weight: bold; display:none;">사용 불가능한 아이디입니다</span>
                    <div class="mb-4">
                      <label class="mb-2.5 block font-medium text-black dark:text-white">이메일</label>
                      <div class="relative">
                        <input type="email" placeholder="50자 이내" id ="mail" name="mail" value="" required maxlength="50"
                          class="w-full rounded-lg border border-stroke bg-transparent py-4 pl-6 pr-10 outline-none focus:border-primary focus-visible:shadow-none dark:border-form-strokedark dark:bg-form-input dark:focus:border-primary" 
                          oninput="removeSpaces(this);"/>

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

                    <div class="mb-4">
                      <label class="mb-2.5 block font-medium text-black dark:text-white">비밀번호</label>
                      <div class="relative">
                        <input type="password" placeholder="20자 이내" id ="password" name="password" value="" required maxlength="20"
                          class="w-full rounded-lg border border-stroke bg-transparent py-4 pl-6 pr-10 outline-none focus:border-primary focus-visible:shadow-none dark:border-form-strokedark dark:bg-form-input dark:focus:border-primary" 
                          oninput="removeSpaces(this);"/>

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
                      </div>
                    </div>

                    <div class="mb-6">
                      <label class="mb-2.5 block font-medium text-black dark:text-white">비밀번호 확인</label>
                      <div class="relative">
                        <input type="password" placeholder="20자 이내" name="r_password" value="" required maxlength="20"
                          class="w-full rounded-lg border border-stroke bg-transparent py-4 pl-6 pr-10 outline-none focus:border-primary focus-visible:shadow-none dark:border-form-strokedark dark:bg-form-input dark:focus:border-primary" 
                          oninput="removeSpaces(this);"/>

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
                      </div>
                    </div>

                    <div class="mb-5">
                    <!-- <button class="w-full cursor-pointer rounded-lg border border-primary bg-primary p-4 font-medium text-white transition hover:bg-opacity-90" >회원가입</button> -->
                       <button id="sbtn" 
                        class="w-full cursor-pointer rounded-lg border border-primary bg-primary p-4 font-medium text-white transition hover:bg-opacity-90" > 
                        회원가입</button>
                    </div>

                    

                    <div class="mt-6 text-center">
                      <p class="font-medium">
                        이미 계정이 있으신가요?
                        <a href="signin.do" class="text-primary">로그인</a>
                      </p>
                    </div>
                  </form>
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

	//input칸에 스페이스바 입력막음
	function removeSpaces(element) {
	    element.value = element.value.replace(/\s/g, '');
	}
	
	//아이디 중복검사
	function checkId(){
		var id = document.getElementById("id").value;
		
	$.ajax({
		url: "/idCheck.do",
        type: "POST",
        data: {id: id},
        success: function (flag) {
            
            if (flag > 0 && id.length >0) {
                // 아이디가 중복됨
                document.getElementById("idNo").style.display = "inline-block";
                document.getElementById("idOk").style.display = "none";
            } else if(flag == 0 && id.length >0){
                // 사용 가능한 아이디
                document.getElementById("idOk").style.display = "inline-block";
                document.getElementById("idNo").style.display = "none";
            }else{
            	//아무것도 입력하지 않을 경우
            	document.getElementById("idOk").style.display = "none";
            	document.getElementById("idNo").style.display = "none";
            }
        },
        error: function (error) {
            console.log(error);
        }
	})
	}

	window.onload = function() {
	
		document.getElementById( 'sbtn' ).onclick = function() {
			// 유효성검사 - email은 이메일형식 / 비밀번호는 문자와 숫자가 필수로 포함된 6~20자리(='"사용불가)
			var emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
            var passwordPattern = /^(?=.*[A-Za-z])(?=.*\d)(?![^]*[\\'\\\"\\=]).{6,20}$/;
			
			if( document.sfrm.id.value.trim() == '' ) {
				alert( 'id를 입력하셔야 합니다' );
				return false;
			}
			if (window.getComputedStyle(idOk).display !== 'inline-block') {
	            alert('아이디가 중복됩니다.');
	            event.preventDefault(); 
	            return false;
	        }
			if( document.sfrm.mail.value.trim() == '' ) {
				alert( '메일을 입력하셔야 합니다' );
				return false;
			}
			if( document.sfrm.password.value.trim() == '' ) {
				alert( '비밀번호를 입력하셔야 합니다' );
				return false;
			}
			if( document.sfrm.r_password.value.trim() == '' ) {
				alert( '비밀번호 확인을 입력하셔야 합니다' );
				return false;
			}
			if( document.sfrm.r_password.value.trim() !== document.sfrm.password.value.trim() ) {
				alert( '비밀번호 확인이 일치하지 않습니다' );
				return false;
			}
			if (!emailPattern.test(document.sfrm.mail.value.trim())) {
                alert("유효한 이메일 주소를 입력해주세요.");
                event.preventDefault();
                return false;
            }

            if (!passwordPattern.test(document.sfrm.password.value.trim())) {
                alert("비밀번호는 최소 6자이상 20자 이하로, 문자와 숫자가 필수로 포함되어야 합니다.(=, ' , \" 는 사용불가)");
                event.preventDefault();
                return false;
            }
            
			document.sfrm.submit(); 
		};
	};
</script>
</body>
</html>