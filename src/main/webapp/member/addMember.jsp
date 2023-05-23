<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%
	//세션 유효성 검사
	if(session.getAttribute("loginMemberId") != null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<style>
	h2{
		text-align: center;
		margin-top: 20px;
		margin-bottom: 30px;
	}
	table {
		text-align: center;	
	}
	.button {
		margin-top: 20px;
		margin-bottom: 100px;
		margin-left: 50%;
	}
	p{
		color: red;
	}
</style>
</head>
<body>
<div class="container">
<div>
	<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
</div>
<h2><img alt="*" src="<%=request.getContextPath()%>/img/member.png" style="width: 40px; margin-bottom: 10px; margin-right: 5px;">회원가입</h2>
<%
	if(request.getParameter("msg") != null){
%>
		<p class="text-center"><%=request.getParameter("msg")%></p>
<%		
	}
%>
<form action="<%=request.getContextPath()%>/member/addMemberAction.jsp">
	<table class="table table-bordered" style="width: 400px; margin: 0 auto">
		<tr>
			<td>아이디</td>
			<td>
				<input type="text" name="addMemberId">
			</td>
		</tr>
		<tr>
			<td>비밀번호</td>
			<td>
				<input type="password" name="addMemberPw">
			</td>
		</tr>
	</table>
	<div class="button">
	<button type="submit" class="btn btn-outline-dark">회원가입</button>
	</div>
</form>
<div>
	<jsp:include page="/inc/copyright.jsp"></jsp:include>
</div>
</div>
</body>
</html>