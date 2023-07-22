<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.example.model.BoardTO" %>
<%@ page import="com.example.model.BoardDAO" %>
<%
	int flag = (Integer)request.getAttribute("flag");
	
	// 에러 ( flag ) 를 중심으로 옮겨주는 행위
	out.println("<script type='text/javascript'>");
	if (flag == 0) {
	    out.println("alert('글쓰기 성공');");
	    out.println("location.href='board_list1.do';");
	} else {
	    out.println("alert('글쓰기 실패');");
	    out.println("history.back();");
	}
	out.println("</script>");

%>