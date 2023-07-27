<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.example.model.BoardTO" %>
<%@page import="com.example.model.BoardListTO"%>
<%@ page import="com.example.model.BoardDAO" %>
<%	
		int flag = (Integer)request.getAttribute("flag");
		BoardListTO listTo = (BoardListTO)request.getAttribute("listTo");
		
		int cpage = listTo.getCpage();
		
		out.println("<script type='text/javascript'>");
		if (flag == 0) {
		    out.println("location.href='board_list1.do?cpage="+ cpage +"';");
		} else {
		    out.println("alert('글삭제 실패');");
		    out.println("history.back();");
		}
		out.println("</script>");
%>