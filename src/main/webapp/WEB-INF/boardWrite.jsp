<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>
    BoardWrite
  </title>
<link rel="icon" href="favicon.ico"><link href="style.css" rel="stylesheet"></head>

<body
  x-data="{ page: 'formLayout', 'loaded': true, 'darkMode': true, 'stickyMenu': false, 'sidebarToggle': false, 'scrollTop': false }"
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
   <!-- ====== Form Layout Section Start -->
    <!-- Contact Form -->
   <div class="rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark h-full">
  <div class="border-b border-stroke py-4 px-6.5 dark:border-strokedark">
    <h3 class="font-semibold text-black dark:text-white">
      글쓰기
    </h3>
  </div>
  <form action="boardWriteOK.do" method="post" name="boardWriteForm" enctype="multipart/form-data">
    <div class="p-6.5 flex flex-col h-full">
      <div class="mb-4.5 flex flex-col gap-6 xl:flex-row">
        <div class="w-full xl:w-1/2">
          <label class="mb-2.5 block text-black dark:text-white">
            닉네임
          </label>
          <input type="text" value="" readonly
            class="w-full rounded border-[1.5px] border-stroke bg-transparent py-3 px-5 font-medium outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:focus:border-primary" />
        </div>
        <div class="w-full xl:w-1/2">
          <label class="mb-2.5 block text-black dark:text-white">
            카테고리
          </label>
          <div class="relative z-20 bg-transparent dark:bg-form-input">
            <select id="category" name="category"
              class="relative z-20 w-full appearance-none rounded border border-stroke bg-transparent py-3 px-5 outline-none transition focus:border-primary active:border-primary dark:border-form-strokedark dark:bg-form-input dark:focus:border-primary">
              <option value="">운동</option>
              <option value="">식단</option>
              <option value="">건강</option>
              <option value="">수다</option>
            </select>
            <span class="absolute top-1/2 right-4 z-30 -translate-y-1/2">
              <svg class="fill-current" width="24" height="24" viewBox="0 0 24 24" fill="none"
                xmlns="http://www.w3.org/2000/svg">
                <g opacity="0.8">
                  <path fill-rule="evenodd" clip-rule="evenodd"
                    d="M5.29289 8.29289C5.68342 7.90237 6.31658 7.90237 6.70711 8.29289L12 13.5858L17.2929 8.29289C17.6834 7.90237 18.3166 7.90237 18.7071 8.29289C19.0976 8.68342 19.0976 9.31658 18.7071 9.70711L12.7071 15.7071C12.3166 16.0976 11.6834 16.0976 11.2929 15.7071L5.29289 9.70711C4.90237 9.31658 4.90237 8.68342 5.29289 8.29289Z"
                    fill=""></path>
                </g>
              </svg>
            </span>
          </div>
        </div>
      </div>

      <div class="mb-4.5">
        <label class="mb-2.5 block text-black dark:text-white">
          제목
        </label>
        <input type="text" placeholder="제목을 입력하세요" name="subject" id="subject"
          class="w-full rounded border-[1.5px] border-stroke bg-transparent py-3 px-5 font-medium outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:focus:border-primary" />
      </div>

      <div class="mb-6">
        <label class="mb-3 block font-medium text-sm text-black dark:text-white">
          파일 업로드
        </label>
        <input type="file" id="upload" name="upload" accept="image/jpeg, image/png, image/gif"
          class="w-full cursor-pointer rounded-lg border-[1.5px] border-stroke bg-transparent font-medium outline-none transition file:mr-5 file:border-collapse file:cursor-pointer file:border-0 file:border-r file:border-solid file:border-stroke file:bg-whiter dark:file:bg-white/30 dark:file:text-white file:py-3 file:px-5 file:hover:bg-primary file:hover:bg-opacity-10 focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:file:border-form-strokedark dark:focus:border-primary" />
      </div>

      <label class="mb-2.5 block text-black dark:text-white">
        내용
      </label>
      <textarea rows="6" placeholder="내용을 입력하세요" name="content" id="content"
        class="w-full rounded border-[1.5px] border-stroke bg-transparent py-3 px-5 font-medium outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:focus:border-primary"></textarea>
    </div>
  </form>

<div class="flex justify-center gap-4">
  <button id="writeButton"
    class="inline-flex items-center justify-center rounded-md bg-primary py-4 px-10 text-center font-medium text-white hover:bg-opacity-90 lg:px-8 xl:px-10">
    글쓰기
  </button>

  <button 
    class="inline-flex items-center justify-center rounded-md bg-primary py-4 px-10 text-center font-medium text-white hover:bg-opacity-90 lg:px-8 xl:px-10"
    onclick="location.href='board.do'">
    목록으로
  </button>
</div>
</div>

<script defer src="bundle.js"></script></body>
<script type="text/javascript">
window.onload = function () {
	document.getElementById('writeButton').onclick = function () {
		if( document.boardWriteForm.subject.value.trim() == '') {
			alert('제목을 입력하셔야 합니다'); 
			return false;
		}
		if( document.boardWriteForm.content.value.trim() == '') {
			alert('내용을 입력하셔야 합니다'); 
			return false;
		}
		if( document.boardWriteForm.content.value.trim() == '') {
			alert('내용을 입력하셔야 합니다'); 
			return false;
		}
		if(document.boardWriteForm.upload.value.trim() == '' ){
			alert('파일을 업로드 하셔야 합니다');
			return false;
		}
		document.boardWriteForm.submit();
	};
};
</script>

</html>