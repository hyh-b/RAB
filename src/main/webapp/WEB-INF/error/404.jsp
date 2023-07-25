<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<!-- 존재하지 않는 페이지 접속시 -->
</head>
<body>
<script type="text/javascript">
	//alert("존재하지 않는 페이지입니다.");
	swal({
        title: "주의!",
        text: "존재하지 않는 페이지입니다.",
        icon: "warning",
        button: "확인",
	}).then((value) => {
	    history.back();
	});
</script>

</body>
</html>