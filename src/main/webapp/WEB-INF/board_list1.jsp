<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="m_seq" value="${requestScope.seq}" />
<c:set var="sbHTML" value="${requestScope.sbHTML}" />
<%@ page import="com.example.model.BoardTO"%>
<%@ page import="com.example.model.BoardListTO"%>
<%@ page import="com.example.model.CommentTO"%>
<%@ page import="java.util.ArrayList"%>
<%
	BoardListTO listTo = (BoardListTO)request.getAttribute("listTo");

	int cpage = listTo.getCpage();
	System.out.println("list.jsp cpage >>> " + cpage);
	
	//페이지에 보일량
	int recordPerPage = listTo.getRecordPerPage();
	int totalRecord = listTo.getTotalRecord();
	int totalpage = listTo.getTotalPage();
	int blockperPage = listTo.getEndBlock();
		
	int startBlock = listTo.getStartBlock();
	int endBlock = listTo.getEndBlock();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="./css/board_list.css">
<style type="text/css">
<!--
	.board_pagetab { text-align: center; }
	.board_pagetab a { text-decoration: none; font: 12px verdana; color: #000; padding: 0 3px 0 3px; }
	.board_pagetab a:hover { text-decoration: underline; background-color:#f2f2f2; }
	.on a { font-weight: bold; }
-->
</style>
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
		<div class="board_top">
			<div class="bold">
				<p>총 <span class="txt_orange"><%=totalRecord %></span>건</p>
			</div>
		</div>	
		
		<!--게시판-->
		<table class="board_list">
		<tr>
				${sbHTML}
		</tr>
		</table>
	
		<div class="btn_area">
			<div class="align_right">		
				<input type="button" value="쓰기" class="btn_write btn_txt01" style="cursor: pointer;" onclick="location.href='board_write1.do?cpage=<%=cpage%>'" />
			</div>
<div class="board_pagetab">
<%
	if( endBlock >= totalpage ) {
		endBlock = totalpage;
	}
	// << 만들기
	if(startBlock == 1) {
		out.println("<span><a>&lt;&lt;</a></span>");
	} else {
		out.println("<span><a href='board_list1.do?cpage=" + (startBlock - blockperPage ) + "'>&lt;&lt;</a></span>");
	}
	out.println("&nbsp;");
	
	// < 만들기
	if( cpage == 1 ) {
		out.println("<span><a>&lt;</a></span>");
	} else {
		out.println("<span><a href='board_list1.do?cpage=" + (cpage -1 ) + "'>&lt;</a></span>");
	}
	out.println("&nbsp;&nbsp;");

	// 현재 페이지
		for (int i = startBlock; i <= endBlock; i++) {
		    if (i == cpage) {
		        out.println("<span><a>[<b>" + i + "</b>]</a></span>");
		    } else if (totalpage == 1) {
		        out.println("<span><a>[<b>" + i + "</b>]</a></span>");
		    } else {
		        out.println("<span><a href='board_list1.do?cpage=" + i + "'>" + i + "</a></span>");
		    }
		}
	out.println("&nbsp;&nbsp;");
	
	// > 만들기
	if( cpage == totalpage ) {
		out.println("<span><a>&gt;</a></span>");
	} else {
		out.println("<span><a href='board_list1.do?cpage=" + (cpage +1 ) + "'>&gt;</a></span>");
	}
	out.println("&nbsp;&nbsp;");
	
	// >> 만들기
	if(startBlock == totalpage) {
		out.println("<span><a>&gt;&gt;</a></span>");
	} else {
		out.println("<span><a href='board_list1.do?cpage=" + (startBlock + blockperPage ) + "'>&gt;&gt;</a></span>");
	}
	out.println("&nbsp;");
	
	
%>		
			<!-- //페이지 처리 위치 -->
			</div>
		</div>

		<!--//게시판-->	
		</div>
</div>

<!--//하단 디자인 -->
</body>
</html>
