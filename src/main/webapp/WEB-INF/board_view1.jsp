<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList"%>
<%@ page import="com.example.model.BoardTO"%>
<%@ page import="com.example.model.BoardListTO"%>
<%@ page import="com.example.model.CommentTO"%>
<%@ page import="com.example.model.BoardDAO"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="name" value="${requestScope.name}" />
<%
	BoardTO to = (BoardTO)request.getAttribute("to");
	BoardListTO listTo = (BoardListTO)request.getAttribute("listTo");
	
	String seq = to.getU_seq();
	int cpage = listTo.getCpage();
	System.out.println("view.jsp cpage >>> " + cpage);
	
	String subject=to.getU_subject();
	String writer=to.getU_writer();
	String wdate=to.getU_wdate();
	
	System.out.println("board_view >>>> "+wdate);
	
	int hit=to.getU_hit();
	String content=to.getU_content();
	String filename = to.getU_filename();
	long filesize = to.getU_filesize();
	
	String file = "";
	
	String prevSeq = to.getPrevSeq();
	String prevSubject = to.getPrevSubject();
	String nextSeq = to.getNextSeq();
	String nextSubject = to.getNextSubject();
	
	// 답글 
	ArrayList<CommentTO> comments =  (ArrayList)request.getAttribute("comments");
	
	StringBuilder sbHTML = new StringBuilder();
	for (CommentTO Cto : comments ) {
		String Cwriter = Cto.getUc_writer();
		String Cwdate = Cto.getUc_wdate();
		String Ccontent = Cto.getUc_content();
		
		sbHTML.append("<td class=\"coment_re\" width=\"20%\">");
		sbHTML.append("<strong>"+ Cwriter +"</strong> ("+Cwdate+")");
		sbHTML.append("<div class=\"coment_re_txt\">");
		sbHTML.append(""+Ccontent+"");
		sbHTML.append("</div>");
		sbHTML.append("</td>");
	}
	
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="./css/board_view.css">
<script type="text/javascript">
window.onload = function () {
    document.getElementById('cbtn').onclick = function () {
		// 필수 입력값 검사
		if(document.cfrm.cwriter.value.trim() == '' ){
			alert('글쓴이를 입력 하셔야 합니다');
			return false;
		}
		if(document.cfrm.ccontent.value.trim() == '' ){
			alert('내용을 입력 하셔야 합니다');
			return false;
		}

		document.cfrm.submit();
    };
};

function confirmDelete() {
	var shouldDelete = confirm('정말로 이 글을 삭제하시겠습니까?');
	if (shouldDelete) {
		// "예"를 선택한 경우 글 삭제 URL로 리디렉션
		location.href = 'board_delete_ok1.do?seq=<%=seq %>&cpage=<%=cpage%>';
	} else {
		// "아니오"를 선택한 경우 아무 동작도 하지 않음
		return;
	}
}

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

	<div class="contents_sub">	
	<!--게시판-->
		<div class="board_view">
			<table>
			<tr>
				<th width="10%">제목</th>
				<td width="60%"><%=subject %></td>
				<th width="10%">등록일</th>
				<td width="20%"><%=wdate %></td>
			</tr>
			<tr>
				<th>글쓴이</th>
				<td><%=writer %></td>
				<th>조회</th>
				<td><%=hit %></td>
			</tr>
			<tr>
				<td colspan="4" height="200" valign="top" style="padding:20px; line-height:160%">
					<div id="bbs_file_wrap">
						<div>
							<img src="https://rabfile.s3.ap-northeast-2.amazonaws.com/<%=filename %>" width="900" onerror="" /><br />
						</div>
					</div>
					<%=content %>
				</td>
				
			<!--  답글 리스트 -->
			</tr>			
			</table>
			<%=sbHTML %>
			<table>
			<tr>
				
			</tr>
			</table>
			
			<!-- 답글 쓰기 -->
			<form action="board_comment_ok1.do" method="post" name="cfrm">
			<input type="hidden" name = "seq" value="<%=seq%>"  />
			<input type="hidden" name = "cpage" value="<%=cpage%>" />
			<table>
			<tr>
				<td width="94%" class="coment_re">
					글쓴이 <input type="text" name="cwriter" value="${name}" maxlength="5" class="coment_input" />&nbsp;&nbsp;
				</td>
				<td width="6%" class="bg01"></td>
			</tr>
			<tr>
				<td class="bg01">
					<textarea name="ccontent" cols="" rows="" class="coment_input_text"></textarea>
				</td>
				<td align="right" class="bg01">
					<input type="button" id="cbtn" value="댓글등록" class="btn_re btn_txt01" />
				</td>
			</tr>
			</table>
			</form>
			
			
		</div>
		<div class="btn_area">
			<div class="align_left">			
							<input type="button" value="목록" class="btn_list btn_txt02" style="cursor: pointer;" onclick="location.href='board_list1.do?cpage=<%=cpage %>'" />

			</div>
			<div class="align_right">
				<input type="button" value="수정" class="btn_list btn_txt02" style="cursor: pointer;" onclick="location.href='board_modify1.do?seq=<%=seq %>&&cpage=<%=cpage%>'" />
			<input type="button" value="삭제" class="btn_list btn_txt02" style="cursor: pointer;" onclick="confirmDelete()" />
				<input type="button" value="쓰기" class="btn_write btn_txt01" style="cursor: pointer;" onclick="location.href='board_write1.do'" />
			</div>
		</div>
		<!--//게시판-->
		
	</div>
<!-- 하단 디자인 -->
</div>

</body>
</html>
