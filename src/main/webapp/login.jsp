<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>login_page</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<style>
	.text-center{
		color: red;
	}
	h3{
		text-align: center;
	}
	.cateh3{
			margin-top: 50px;
			text-align: center;
		}
	.input-group{
		display: grid;
		place-items: center;
		margin-top: 30px;
	}	
	.loginPage{
		text-align: center;
	}
	button{
		margin-top: 30px;
	}
</style>
</head>
<body>
<div class="container">
<!-- 메인 메뉴(가로) -->
<div>
	<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
</div>

<!-- -----로그인 폼-------- -->
	<form action="<%=request.getContextPath()%>/loginAction.jsp" method="post">
		<h2 class="cateh3"><img alt="*" src="./img/login.png" style="width: 30px;">로그인</h2>
		<%
			if(request.getParameter("msg") != null){
		%>
				<p class="text-center"><%=request.getParameter("msg") %></p>
		<%		
			}
		%>
		<div class="loginPage">
			<table class="input-group">
							<tr>
								<td>아이디</td>
								<td>
									<input type="text" name="memberId" class="form-control">
								</td>
							</tr>
							<tr>
								<td>비밀번호</td>
								<td>
									<input type="password" name="memberPw" class="form-control" style="margin-top: 10px;">	
								</td>
							</tr>
						</table>
			<button type="submit" class="btn btn-dark btn-sm">로그인</button>
		</div>
	</form>
</div>
	
<!-- -------하단 카피라이트 ------- -->
<div class="container" style="margin-top: 80px; margin-bottom: 20px;">
	<!-- include 페이지 : Copyright &copy; 구디아카데미 -->
	<jsp:include page="/inc/copyright.jsp"></jsp:include>	
</div>
</body>
</html>