<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.example.model.BoardTO"%>
<%@ page import="com.example.model.BoardListTO"%>
<%@ page import="com.example.model.BoardDAO"%>
<%
	BoardTO to = (BoardTO)request.getAttribute("to");
	BoardListTO listTo = (BoardListTO)request.getAttribute("listTo");
	
	String seq = to.getU_seq();
	System.out.println("Modify seq >>>>> "+seq);
	int cpage = listTo.getCpage();
	System.out.println("Modify cpage >>>>> "+cpage);
	
	String subject=to.getU_subject();
	String writer=to.getU_writer();
	
	String content=to.getU_content();
	System.out.println("Modify content >>>>> "+content);
	String filename = to.getU_filename();
	System.out.println("Modify filename >>>>> "+filename);
	
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="./css/board_write.css">
<script type="text/javascript">
window.onload = function () {
	// 필수 입력값 검사
		document.getElementById('mbtn').onclick = function () {
			if( document.mfrm.subject.value.trim() == '') {
				alert('제목을 입력하셔야 합니다'); 
				return false;
			}
			document.mfrm.submit();
	};
};

</script>
</head>

<body>
<!-- 상단 디자인 -->
<div class="contents1"> 
	<div class="con_title"> 
		<p style="margin: 0px; text-align: right">
			<img style="vertical-align: middle" alt="" src="./images/home_icon.gif" /> &gt; 커뮤니티 &gt; <strong>여행지리뷰</strong>
		</p>
	</div> 

	<form action="board_modify_ok1.do" method="post" name="mfrm" enctype="multipart/form-data">
		<input type="hidden" name = "seq" value="<%=seq%>"  />
		<input type="hidden" name = "cpage" value="<%=cpage%>" />
		<div class="contents_sub">
		<!--게시판-->
			<div class="board_write">
				<table>
				<tr>
					<th class="top">글쓴이</th>
					<td class="top" colspan="3"><input type="text" name="writer" value="<%=writer %>" class="board_view_input_mail" maxlength="5"  readonly /></td>
				</tr>
				<tr>
					<th>제목</th>
					<td colspan="3"><input type="text" name="subject" value="<%=subject %>" class="board_view_input" /></td>
				</tr>
				<tr>
					<th>내용</th>
					<td colspan="3">
						<textarea name="content" class="board_editor_area"><%=content %></textarea>
					</td>
				</tr>
				<tr>
					<th>이미지</th>
					<td colspan="3">
						기존 이미지 : <%=filename %><br /><br />
						<input type="file" name="upload" value="" class="board_view_input" /><br /><br />
					</td>
				</tr>
				</table>
			</div>

			<div class="btn_area">
				<div class="align_left">			
					<input type="button" value="목록" class="btn_list btn_txt02" style="cursor: pointer;" onclick="location.href='board_list1.do?seq=<%=seq %>&&cpage=<%=cpage %>'" />
					<input type="button" value="보기" class="btn_list btn_txt02" style="cursor: pointer;" onclick="location.href='board_view1.do?seq=<%=seq %>&&cpage=<%=cpage %>'" />
				</div>
				<div class="align_right">			
					<input type="button" id="mbtn" value="수정" class="btn_write btn_txt01" style="cursor: pointer;" />
				</div>	
			</div>	
			<!--//게시판-->
		</div>
	</form>
</div>
<!-- 하단 디자인 -->

</body>
</html>
