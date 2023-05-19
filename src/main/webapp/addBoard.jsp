<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//로그인 되지않은 사용자가 넘어왔을 때 로그인 페이지로 이동
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath()+"/login.jsp");
		return;
	}
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>add board + file</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<style>
	.container{
		text-align: center;
	}
	input, textarea {
		float: left;
		margin-left: 20px;
	}
	.cateh3{
		margin-top: 50px;
		margin-bottom: 20px;
	}
	button{
		margin-top: 40px;
	}
</style>
</head>
<body>
<div class="container">
<!-- 메인 메뉴(가로) -->
<div>
	<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
</div>

<!-- ------업로드 폼------ -->
	<h2 class="cateh3"><img alt="*" src="./img/pdf.png" style="width: 40px; margin-bottom: 10px; margin-right: 20px;">자료 업로드</h2>
	<!-- multipart/form-data는 꼭 post로 넘겨야한다 -->
	<form action="<%=request.getContextPath()%>/addBoardAction.jsp" enctype="multipart/form-data" method="post">
		<table class="table table-bordered" style="width: 700px; margin: 0 auto">
			<!-- 자료 업로드 제목글 -->
			<tr>
				<th>board_title</th>
				<td>
					<!-- required="required는 빈파일을 넘기면 빨간색 경고창이 뜨는 코드, 자바스크립트를 배우게되면 사용하지않는다 -->
					<textarea rows="3" cols="50" name="boardTitle" required="required"></textarea>
				</td>
			</tr>
			
			<!-- 로그인 사용자 아이디-->
			<%
				/* String memberId = (String)session.getAttribute("loginMemberId"); 나중에 이거 로그인할때 작성하면됨*/
				String memberId = "test";
			%>
			<tr>
				<th>member_id</th>
				<td>
					<input type="text" name="memberId" value="<%=/*세션에 저장된 아이디가 들어가면*/memberId%>" readonly="readonly">
				</td>
			</tr>
			
			<tr>
				<th>board_file</th>
				<td>
					<input type="file" name="boardFile" required="required">
				</td>
			</tr>
		</table>
		<button type="submit" class="btn btn-outline-dark">자료업로드</button>
	</form>
</div>	

<!-- ----하단 카피라이트------ -->
<div class="container" style="margin-top: 80px; margin-bottom: 20px;">
	<jsp:include page="/inc/copyright.jsp"></jsp:include>	
</div>	
</body>
</html>