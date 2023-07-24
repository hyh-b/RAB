<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
    int flagAB = (Integer)request.getAttribute("flagAB");
    int flag = (Integer)request.getAttribute("flag");
%>   
    <script src='https://unpkg.com/sweetalert/dist/sweetalert.min.js'></script>
    <script type='text/javascript'>
    <% if( flag == 1 && flagAB == 1 ) { %>
        swal('이미지 업로드 성공!', '이미지가 업로드되었습니다.', 'success').then(function() { window.location.href='notice_board.do'; });
    <% }  else if(flag==0 && flagAB==1){ %>
        swal('텍스트 업로드 성공!', '텍스트가 업로드되었습니다.', 'success').then(function() { window.location.href='notice_board.do'; });
    <% }else{ %>
        swal('업로드 실패!', '아이디와 비밀번호를 확인해 주세요', 'warning');
    <% } %>
        console.log('글쓰기 시도함');
    </script>
</body>
</html>
