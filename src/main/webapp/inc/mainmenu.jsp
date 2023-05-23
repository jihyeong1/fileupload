<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<nav class="navbar navbar-expand-sm bg-dark navbar-dark justify-content-end">
	<ul class="navbar-nav">
		<li class="nav-item">
			<a href="<%=request.getContextPath()%>/boardList.jsp" class="nav-link">PDF자료목록</a>
		</li>
		<!-- 로그인전 : 회원가입
		로그인후 : 회원정보 / 로그아웃(로그인정보는 세션 loginMemberId -->
		<%
			if(session.getAttribute("loginMemberId") == null ){
				//로그인전
		%>	
				<li class="nav-item">
					<a class="nav-link" href="<%=request.getContextPath()%>/member/addMember.jsp">회원가입</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="<%=request.getContextPath()%>/login.jsp">로그인</a>
				</li>
		<%		
			}else{
		%>
				<li class="nav-item">
					<a class="nav-link" href="<%=request.getContextPath()%>/logoutAction.jsp">로그아웃</a>
				</li>
		<%		
			}
		%>
	
	</ul>
</nav>
