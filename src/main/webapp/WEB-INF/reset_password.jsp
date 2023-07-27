<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="icon" href="favicon.ico"><link href="style.css" rel="stylesheet">
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<style>
    body {
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
      margin: 0;
      background-color: #f2f2f2;
    }

    .login-form {
      width: 700px;
      height: 500px;
      border: 1px solid #ccc;
      background-color: #fff;
      padding: 20px;
      border-radius: 5px;
    }
    
    .login-form h3 {
      font-weight: 600;
      margin: 0;
      padding-bottom: 10px;
      border-bottom: 1px solid #ccc;
    }

    .login-form label {
      display: block;
      margin-bottom: 5px;
      font-weight: 500;
    }

    .login-form input[type="email"],
    .login-form input[type="password"] {
      width: 100%;
      padding: 8px;
      border: 1px solid #ccc;
      border-radius: 5px;
      margin-bottom: 10px;
    }

</style>
<script type="text/javascript">

	//input칸에 스페이스바 입력막음
	function removeSpaces(element) {
	    element.value = element.value.replace(/\s/g, '');
	}

	function submitForm() {
		// 비밀번호 패턴 유효성 검사
		var passwordPattern = /^(?=.*[A-Za-z])(?=.*\d)(?![^]*[\\'\\\"\\=]).{6,20}$/;

		if (document.pwfrm.password.value.trim() == '') {
			//alert('비밀번호를 입력하셔야 합니다');
			swal({
                title: "주의!",
                text: "비밀번호를 입력하셔야 합니다",
                icon: "warning",
                button: "확인",
           });
			return false;
		}
		if (document.pwfrm.r_password.value.trim() == '') {
			//alert('비밀번호 확인을 입력하셔야 합니다');
			swal({
                title: "주의!",
                text: "비밀번호 확인을 입력하셔야 합니다",
                icon: "warning",
                button: "확인",
           });
			return false;
		}
		if (document.pwfrm.r_password.value.trim() !== document.pwfrm.password.value.trim()) {
			//alert('비밀번호 확인이 일치하지 않습니다');
			swal({
                title: "주의!",
                text: "비밀번호 확인이 일치하지 않습니다",
                icon: "warning",
                button: "확인",
           });
			return false;
		}

		if (!passwordPattern.test(document.pwfrm.password.value.trim())) {
			//alert("비밀번호는 최소 6자 이상 20자 이하로, 문자와 숫자가 필수로 포함되어야 합니다.(=, ' , \"는 사용불가)");
			swal({
                title: "주의!",
                text: "비밀번호는 최소 6자이상 20자 이하로, 문자와 숫자가 필수로 포함되어야 합니다.(=, ' , \" 는 사용불가)",
                icon: "warning",
                button: "확인",
           });
			return false;
		}

		document.getElementById('pwfrm').submit();
	};
</script>
</head>
<body>

	<div class="login-form">
		<div class="rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark">
			<div class="border-b border-stroke py-4 px-6.5 dark:border-strokedark">
				<h3 class="font-semibold text-black dark:text-white">
			    	비밀번호 재설정
			    </h3>
			</div>
			<form action="reset_password_ok" id="pwfrm" name="pwfrm" method="post">
				<input type="hidden" name="token" value="${param.token}">
				<div class="p-6.5" style=height:400px;>
					<div class="mb-4.5">
						<label class="mb-2.5 block text-black dark:text-white">
						  비밀번호
						</label>
				        <input type="password" id="password" name="password" placeholder="문자와 숫자 포함 6~20자" oninput="removeSpaces(this);"  class="w-full rounded border-[1.5px] border-stroke bg-transparent py-3 px-5 font-medium outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:focus:border-primary" />
					</div>
			
					<div>
						<label class="mb-2.5 block text-black dark:text-white">
						  비밀번호 확인
						</label>
				        <input type="password" id="r_password" name="r_password" placeholder="비밀번호 확인" oninput="removeSpaces(this);"  class="w-full rounded border-[1.5px] border-stroke bg-transparent py-3 px-5 font-medium outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:focus:border-primary" />
				    </div> <br>
				       
					<input id="pwBtn" type="button" class="flex w-full justify-center rounded bg-primary p-3 font-medium text-gray" value="확인" onclick="submitForm()" />
				</div>
			</form>
		</div>
	</div>
</body>
</html>