<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.example.model.BoardTO" %>
<%@ page import="com.example.model.BoardDAO" %>
<%@page import="com.example.model.BoardListTO"%>
<%
	BoardTO to = (BoardTO)request.getAttribute("to");
	BoardListTO listTo = (BoardListTO)request.getAttribute("listTo");
	
	String seq = to.getU_seq();
	int cpage = listTo.getCpage();
	
	int flag = (Integer)request.getAttribute("flag");
	
	// 에러 ( flag ) 를 중심으로 옮겨주는 행위
	out.println("<script type='text/javascript'>");
	if (flag == 0) {
	    out.println("alert('답글쓰기 성공');");
		out.println( "location.href='board_view1.do?seq=" + seq +"&&cpage="+ cpage +"'" );
	} else {
	    out.println("alert('답글쓰기 실패');");
	    out.println("history.back();");
	}
	out.println("</script>");

%>