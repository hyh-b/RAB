<%@page import="java.util.List"%>
<%@page import="com.example.model.MemberTO"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>정보 입력</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<link rel="icon" href="favicon.ico"><link href="style.css" rel="stylesheet">
<style>
   body, html {
        height: 100%;
        margin: 0;
        
    }
    
    .container-wrapper {
        overflow: auto; /* 스크롤바 추가 */
        height: calc(100vh - 80px); /* 화면 크기에 맞게 조정 */
    }

    .container {
        display: flex;
        align-items: center;
        justify-content: center;
        height: 100%;
        width: 120%; 
        
    }

    form {
        font-size: 1.5em;
    }

    .input-field {
        display: flex;
        justify-content: flex-start;
        margin: 15px 0;
        gap: 6px;
        
    }

    .input-field label {
        margin-right: 15px;
        width: 200px; 
        text-align: right; 
        display: flex;
        align-items: center;
        justify-content: flex-end;
    }

    input, select {
        font-size: 1em;
    }

    

    .submit-button {
        display: flex;
        justify-content: center;
        margin: 20px 0;
    }
    
    .input-wrapper {
	    display: flex;
	    flex-grow: 1;
	}
	
	
	
	.tel-input-wrapper {
        display: flex;
    }
	
	.tel-input-part {
	    flex: none;
	    width: 84px;
	}
	
	.tel-input {
	    display: flex;
	    justify-content: space-between;
	}
</style>
<script type="text/javascript">
	//닉네임 중복 검사
	function checkName(){
		var name = document.getElementById("name").value;
	
		$.ajax({
			url: "/nameCheck.do",
		    type: "POST",
		    data: {name: name},
		    success: function (flag) {
		        
		        if (flag > 0 && name.length >0) {
		            // 닉네임이 중복됨
		            document.getElementById("nameNo").style.display = "inline-block";
		            document.getElementById("nameOk").style.display = "none";
		        } else if(flag == 0 && name.length >0){
		            // 사용 가능한 닉네임
		            document.getElementById("nameOk").style.display = "inline-block";
		            document.getElementById("nameNo").style.display = "none";
		        }else{
		        	//아무것도 입력하지 않을 경우
		        	document.getElementById("nameOk").style.display = "none";
		        	document.getElementById("nameNo").style.display = "none";
		        }
		    },
		    error: function (error) {
		        console.log(error);
		    }
		})
	}
	
	window.onload = function(){
		var inputs = document.querySelectorAll('#sfrm input[type=text], #sfrm input[type=number], #sfrm select');
		
		document.getElementById('sbtn').onclick = function(){
			var allFilled = Array.from(inputs).every(input => input.value.trim() !== '');
	        // 모든 정보를 입력해야 제출가능
			if (!allFilled) {
                //alert("모든 정보를 입력하셔야 합니다.");
               swal({
                  title: "주의!",
                  text: "모든 정보를 입력하셔야 합니다",
                  icon: "warning",
                  button: "확인",
               });
                return false;
            }
	        
            //닉네임이 중복 아닌경우에만 제출
            if (window.getComputedStyle(nameNo).display == 'none'){
            	document.sfrm.submit();
            }else{
	        	//alert("닉네임이 중복됩니다")
	        	swal({
                  title: "주의!",
                  text: "닉네임이 중복됩니다",
                  icon: "warning",
                  button: "확인",
               });
	        	return false;
	        }
          
		}
	} 
	
</script>
</head>

<body>


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
              정보 입력
            </h2>

            
          </div>
          <!-- Breadcrumb End -->

          <div class="container-wrapper h-[calc(100vh-186px)] overflow-hidden sm:h-[calc(100vh-174px)]">
            <div class=" h-full w-full rounded-sm border border-stroke bg-white shadow-default ">
              <div class=" flex h-full flex-col border-l border-stroke dark:border-strokedark lg:w-4/5">
                <!-- ====== Inbox List Start -->
                

                <div class="container">
        <form action="signup2_ok.do" method="post" id="sfrm" name="sfrm">

            <div class="input-field w-full">
                <label for="m_real_name">이름:</label>
                <div class="input-wrapper ">
                	<input type="text" id="realName" name="realName" class="wide-input w-100 h-12.5 rounded-lg border-[1.5px] border-primary bg-transparent py-3 px-5 font-medium outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter" value="">
                </div>
            
                <label for="m_name">닉네임:</label>
                <div class="input-wrapper">
                	<input type="text" id="name" name="name" class="wide-input w-100 h-12.5 rounded-lg border-[1.5px] border-primary bg-transparent py-3 px-5 font-medium outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter" required oninput = "checkName()" value="">
                </div>
            </div>
            

            <div class="input-field">
                <label for="m_birthday">생년월일:</label>
                <select id="birthday_year" name="birthday_year" >
                	<option value="" selected>연도</option>
                    <% 
				    int currentYear = java.util.Calendar.getInstance().get(java.util.Calendar.YEAR);
				    for (int year = currentYear; year >= 1900; year--) {
				    %>
				        <option value="<%= year %>"><%= year %>년</option>
				    <% } %>
                </select>
                <span>&nbsp;&nbsp;</span>
                <select id="birthday_month" name="birthday_month" class="relative z-20 w-20.5 appearance-none rounded border border-stroke bg-transparent py-3 px-5 outline-none transition focus:border-primary active:border-primary dark:border-form-strokedark dark:bg-form-input dark:focus:border-primary">
               		<option value="" selected>월</option>
                    <% 
                    for (int month = 1; month <= 12; month++) {
                        String monthStr = String.format("%02d", month);
                    %>
                        <option value="<%= monthStr %>"><%= month %>월</option>
                    <% } %>
                </select>
                <span>&nbsp;&nbsp;</span>
                <select id="birthday_day" name="birthday_day">
                	<option value="" selected >일</option>
                    <% 
                    for (int day = 1; day <= 31; day++) {
                        String dayStr = String.format("%02d", day);
                    %>
                        <option value="<%= dayStr %>"><%= day %>일</option>
                    <% } %>
                </select>
            <p id="nameOk" style="color:green; margin-left:100px; display:none;">사용가능한 닉네임입니다</p>
            <p id="nameNo" style="color:red; margin-left:100px; display:none;">중복되는 닉네임입니다</p>
            </div>
            
           <div class="input-field ">
                <label for="m_gender">성별:</label>
                <select id="gender" name="gender" class="relative z-20 w-30 h-12.5 appearance-none rounded border border-stroke bg-transparent py-3 px-5 outline-none transition focus:border-primary active:border-primary dark:border-form-strokedark dark:bg-form-input dark:focus:border-primary">
                    <option value="">선택</option>
                    <option value="남성">남성</option>
                    <option value="여성">여성</option>
                </select>
                
                <label for="m_weight" style="margin-left:220px">체중 (kg):</label>
                <div class="input-wrapper">
                	<input type="number" id="weight" name="weight" step="any" class="wide-input w-100 h-12.5 rounded-lg border-[1.5px] border-primary bg-transparent py-3 px-5 font-medium outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter" value="">
                </div>
            </div>

            <div class="input-field">
                <label for="m_height">키 (cm):</label>
                <div class="input-wrapper">
                	<input type="number" id="height" name="height" step="any" class="wide-input w-100 h-12.5 rounded-lg border-[1.5px] border-primary bg-transparent py-3 px-5 font-medium outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter" value="">
                </div>
            
                <label for="m_tel">전화번호:</label>
                <div class="tel-input-wrapper">
                	<div class="tel-input">
				        <input type="text" id="tel1" name="tel1" class="tel-input-part w-3.5 h-12.5 rounded-lg border-[1.5px] border-primary bg-transparent py-3 px-5 font-medium outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter" maxlength="3"> &nbsp;-&nbsp;
				        <input type="text" id="tel2" name="tel2" class="tel-input-part w-3.5 h-12.5 rounded-lg border-[1.5px] border-primary bg-transparent py-3 px-5 font-medium outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter" maxlength="4"> &nbsp;-&nbsp;
				        <input type="text" id="tel3" name="tel3" class="tel-input-part w-3.5 h-12.5 rounded-lg border-[1.5px] border-primary bg-transparent py-3 px-5 font-medium outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter" maxlength="4">
				    </div>
                </div>
                
            </div>

            <div class="input-field">
                <label for="m_target_calorie">하루&nbsp;목표&nbsp;칼로리:</label>
                <div class="input-wrapper">
                	<input type="text" id="target_calorie" name="target_calorie" class="wide-input w-100 h-12.5 rounded-lg border-[1.5px] border-primary bg-transparent py-3 px-5 font-medium outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter" value="">
                </div>
            
                <label for="m_target_weight">목표 체중:</label>
                <div class="input-wrapper">
                	<input type="text" id="target_weight" name="target_weight" class="wide-input w-100 h-12.5 rounded-lg border-[1.5px] border-primary bg-transparent py-3 px-5 font-medium outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter" value="">
                </div>
            </div>

            <div class="submit-button ">
                <input id ="sbtn" name ="sbtn" type="button" class="wide-input flex w-full justify-center rounded bg-primary p-3 font-medium text-gray" value="등록">
            </div>

        </form>
    </div>

                
                <!-- ====== Inbox List End -->
              </div>
            </div>
          </div>
        </div>
      </main>
      <!-- ===== Main Content End ===== -->
    </div>
  <!-- ===== Page Wrapper End ===== -->
<script defer src="bundle.js"></script>
</body>
</html>