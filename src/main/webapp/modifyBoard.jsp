<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%
	// 넘어온 요청값 디버깅
	System.out.println(request.getParameter("boardNo"));
	System.out.println(request.getParameter("boardFileNo"));
	
	//변수 저장
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int boardFileNo = Integer.parseInt(request.getParameter("boardFileNo"));
	
	//디비연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/fileupload","root","java1234");
	
	//조회하는 쿼리문 작성
	String sql = "SELECT b.board_no boardNo, b.board_title boardTitle, f.board_file_no boardFileNo, f.origin_filename originFilename FROM board b INNER JOIN board_file f ON b.board_no = f.board_no WHERE b.board_no=? AND f.board_file_no=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);
	stmt.setInt(2, boardFileNo);
	ResultSet rs = stmt.executeQuery();
	HashMap<String, Object> map = null;
	if(rs.next()) {
		map = new HashMap<>();
		map.put("boardNo", rs.getInt("boardNo"));
		map.put("boardTitle", rs.getString("boardTitle"));
		map.put("boardFileNo", rs.getInt("boardFileNo"));
		map.put("originFilename", rs.getString("originFilename"));
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>board & boardFile 수정</title>
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

<!-- 수정 폼 -->
	<h2 class="cateh3"><img alt="*" src="./img/pdf.png" style="width: 40px; margin-bottom: 10px; margin-right: 20px;">파일 수정</h2>
	<form action="<%=request.getContextPath()%>/modifyBoardAction.jsp" 
			method="post" enctype="multipart/form-data">
		<input type="hidden" name="boardNo" value="<%=map.get("boardNo")%>">
		<input type="hidden" name="boardFileNo" value="<%=map.get("boardFileNo")%>">
		<table class="table table-bordered" style="width: 700px; margin: 0 auto">
			<tr>
				<th>게시글 제목</th>
				<td>
					<textarea rows="3" cols="50" name="boardTitle"
						required="required"><%=map.get("boardTitle")%></textarea>
				</td>
			</tr>
			<tr>
				<th>파일(수정전 파일 : <%=map.get("originFilename")%>)</th>
				<td>
					<input type="file" name="boardFile">
				</td>
			</tr>
		</table>
		<button type="submit" class="btn btn-outline-dark">수정</button>
	</form>
</div>	

<!-- ----하단 카피라이트------ -->
<div class="container" style="margin-top: 80px; margin-bottom: 20px;">
	<jsp:include page="/inc/copyright.jsp"></jsp:include>	
</div>	
</body>
</html>