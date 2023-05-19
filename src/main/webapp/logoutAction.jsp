<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	session.invalidate(); // 기존 세션(속성,자료)을 지우고 갱신
	response.sendRedirect(request.getContextPath()+"/boardList.jsp");
%>