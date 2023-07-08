<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>정보 입력</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<style>
   body, html {
        height: 100%;
        margin: 0;
    }

    .container {
        display: flex;
        align-items: center;
        justify-content: center;
        height: 100%;
    }

    form {
        font-size: 1.5em;
    }

    .input-field {
        display: flex;
        justify-content: flex-start;
        margin: 15px 0;
        margin-left: -180px; 
    }

    .input-field label {
        margin-right: 15px;
        width: 200px; /* Adjust this value to align input fields */
        text-align: right; /* Align text to the right within the label */
    }

    input, select {
        padding: 10px;
        font-size: 1em;
    }

    h2 {
        font-size: 2em;
        margin-bottom: 20px;
        text-align: center;
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
	
	.input-wrapper input {
	     width: calc(100% + 10px);
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
		
		document.getElementById('sbtn').onclick = function(){
			var inputs = document.getElementsByTagName("input");
	        for (var i = 0; i < inputs.length; i++) {
	            if (inputs[i].value === "") {
	                inputs[i].value = null;
	            }
	        }
	        var weightInput = document.getElementById('weight');
            var heightInput = document.getElementById('height');
            if (weightInput.value === "") {
                weightInput.value = null; 
            }
            if (heightInput.value === "") {
                heightInput.value = null; 
            }
            //닉네임을 입력안하거나 중복이 아닌경우에만 제출
            if (window.getComputedStyle(nameOk).display == 'inline-block' || document.getElementById("name").value == '') {
				document.sfrm.submit();
	        }
		}
	}
</script>
</head>
<body>

    <div class="container">
        <form action="signup2_ok.do" method="post" id="sfrm" name="sfrm">

            <h2>정보 입력</h2>

            <div class="input-field">
                <label for="m_name">닉네임:</label>
                <div class="input-wrapper">
                	<input type="text" id="name" name="name" class="wide-input" required oninput = "checkName()" value="">
                </div>
            </div>
            
            <p id="nameOk" style="color:green; display:none;">사용가능한 닉네임입니다</p>
            <p id="nameNo" style="color:red; display:none;">중복되는 닉네임입니다</p>

            <div class="input-field">
                <label for="m_gender">성별:</label>
                <select id="gender" name="gender">
                    <option value="male">남성</option>
                    <option value="female">여성</option>
                </select>
            </div>
            
           <div class="input-field">
                <label for="m_birthday">생년월일:</label>
                <select id="birthday_year" name="birthday_year">
                	<option value="" selected>연도</option>
                    <% 
				    int currentYear = java.util.Calendar.getInstance().get(java.util.Calendar.YEAR);
				    for (int year = currentYear; year >= 1900; year--) {
				    %>
				        <option value="<%= year %>"><%= year %>년</option>
				    <% } %>
                </select>
                <span>&nbsp;&nbsp;</span>
                <select id="birthday_month" name="birthday_month">
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
                	<option value="" selected>일</option>
                    <% 
                    for (int day = 1; day <= 31; day++) {
                        String dayStr = String.format("%02d", day);
                    %>
                        <option value="<%= dayStr %>"><%= day %>일</option>
                    <% } %>
                </select>
            </div>

            <div class="input-field">
                <label for="m_weight">체중 (kg):</label>
                <div class="input-wrapper">
                	<input type="number" id="weight" name="weight" step="any" class="wide-input" value="">
                </div>
            </div>

            <div class="input-field">
                <label for="m_height">키 (cm):</label>
                <div class="input-wrapper">
                	<input type="number" id="height" name="height" step="any" class="wide-input" value="">
                </div>
            </div>

            <div class="input-field">
                <label for="m_tel">전화번호:</label>
                <div class="input-wrapper">
                	<input type="text" id="tel" name="tel" class="wide-input" value="">
                </div>
            </div>

            <div class="input-field">
                <label for="m_target_calorie">하루&nbsp;목표&nbsp;칼로리:</label>
                <div class="input-wrapper">
                	<input type="text" id="target_calorie" name="target_calorie" class="wide-input" value="">
                </div>
            </div>

            <div class="input-field">
                <label for="m_target_weight">목표 체중:</label>
                <div class="input-wrapper">
                	<input type="text" id="target_weight" name="target_weight" class="wide-input" value="">
                </div>
            </div>

            <div class="submit-button">
                <input id ="sbtn" name ="sbtn" type="button" class="wide-input" value="등록">
            </div>

        </form>
    </div>
</body>
</html>