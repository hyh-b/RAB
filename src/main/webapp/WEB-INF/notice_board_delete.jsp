<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="to" value="${requestScope.to}"></c:set>
<c:set var="cpage" value="${requestScope.cpage}"></c:set>
<c:set var="seq" value="${to.seq }"></c:set>
<c:set var="subject" value="${to.subject }"></c:set>
<c:set var="writer" value="${to.writer }"></c:set>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="./css/board_write.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		$('#dbtn').on('click',function(){
			if($('#password').val().trim() == ''){
				alert('비밀번호를 입력하세요!');
				return false;
			}
			
			// ajax
			$.ajax({
			    url: 'board_delete1_ok.do',
			    data: {
			        seq: $('#seq').val(),
			        cpage: $('#cpage').val(),
			        password: $('#password').val()
			    },
			    dataType: 'json',
			    type: 'post',
			    success: function(json) {
			        if (json.flag == '0') {
			            alert('삭제 성공');
			            location.href = '/';
			        } else {
			            alert('삭제 실패');
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

<body>
<!-- 상단 디자인 -->
<div class="contents1"> 
	<div class="con_title"> 
		
	</div> 
	<form action="#" method="post" name="dfrm">
		<input type="hidden" name="seq" id="seq" value="${seq}"/>
		<input type="hidden" name="cpage" id="cpage" value="${cpage}"/>
		<div class="contents_sub">
		<!--게시판-->
			<div class="board_write">
				<table>				
				<tr>
					<th>제목</th>
					<td colspan="3"><input type="text" name="subject" value="${subject }" class="board_view_input" /></td>
				</tr>
				
				</table>
			</div>

			<div class="btn_area">
				<div class="align_left">			
					<input type="button" value="목록" class="btn_list btn_txt02" style="cursor: pointer;" onclick="location.href='/?seq=${seq }&&cpage=${cpage }'" />
					<input type="button" value="보기" class="btn_list btn_txt02" style="cursor: pointer;" onclick="location.href='board_view1.do?seq=${seq }&&cpage=${cpage }'" />
				</div>
				<div class="align_right">			
					<input type="button" id="dbtn" value="삭제" class="btn_write btn_txt01" style="cursor: pointer;" />					
				</div>	
			</div>	
			<!--//게시판-->
		</div>
	</form>
</div>
<!-- 하단 디자인 -->

</body>
</html>
