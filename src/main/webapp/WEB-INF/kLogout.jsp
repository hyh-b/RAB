<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<script type="text/javascript">
	//alert('로그아웃 되었습니다.')
	swal({
           title: "성공!",
           text: "로그아웃 되었습니다",
           icon: "success",
           button: "확인",
      });

	location.href="/logout";
</script>
</head>
<body>

</body>
</html>