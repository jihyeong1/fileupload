<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>  
<%@ page import = "java.util.*" %>
<%
	//디비연결
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/fileupload";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	/*
		SELECT b.board_title boardTitle, f.origin_filename originFilename , f.save_filename saveFilename, path
		FROM board b INNER JOIN board_file f
		ON b.board_no = f.board_no
		ORDER BY b.createdate DESC
	*/
	
	String sql="SELECT b.board_title boardTitle, f.origin_filename originFilename , f.save_filename saveFilename, path, f.createdate FROM board b INNER JOIN board_file f ON b.board_no = f.board_no ORDER BY b.createdate DESC";
	PreparedStatement stmt = conn.prepareStatement(sql);
	ResultSet rs = stmt.executeQuery();
	ArrayList<HashMap<String, Object>> list = new ArrayList<>();
	while(rs.next()){
		HashMap<String, Object> m = new HashMap<>();
		m.put("boardTitle", rs.getString("boardTitle"));
		m.put("originFilename", rs.getString("originFilename"));
		m.put("saveFilename", rs.getString("saveFilename"));
		m.put("path", rs.getString("path"));
		m.put("createdate", rs.getString("createdate"));
		list.add(m);
	}
%>    
    
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>boardList</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<style>
	.cateh3{
			margin-top: 50px;
			text-align: center;
		}
</style>
</head>
<body>
<div class="container">
<!-- 메인 메뉴(가로) -->
<div>
	<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
</div>
	<h2 class="cateh3"><img alt="*" src="./img/pdf.png" style="width: 40px; margin-bottom: 10px; margin-right: 20px;">PDF 자료 목록</h2>
		<a class="btn btn-outline-dark" style="float: right; margin-top: 30px; margin-bottom: 20px;" href="<%=request.getContextPath()%>/addBoard.jsp">자료 업로드</a>
		<table class="table table-hover" style="margin-top: 20px; text-align: center;">
			<!-- 자료 업로드 제목글 -->
			<tr>
				<th>게시글 제목</th>
				<th>원본 파일이름</th>	
				<th>업로드날짜</th>	
				<th>다운로드</th>	
				<th>삭제</th>	
			</tr>
			<%
				for(HashMap<String, Object> m : list){
			%>
					<tr>
						<td><%=(String)m.get("boardTitle") %></td>
						<td><%=(String)m.get("originFilename")%></td>
						<td><%=(String)m.get("createdate") %></td>
			<%		
					if(session.getAttribute("loginMemberId") != null){
			%>
						<td>
							<a href="<%=request.getContextPath()%>/<%=(String)m.get("path")%>/<%=(String)m.get("saveFilename")%>" download="<%=(String)m.get("originFilename")%>">
								<img alt="*" src="./img/download.png" style="width: 30px; ">
							</a>
						</td>
						<td>
							<a href="<%=request.getContextPath()%>/removeBoardAction.jsp?boardTitle=<%=m.get("boardTitle")%>">
								<img alt="*" src="./img/remove.png" style="width: 30px; ">
							</a>
						</td>
			<%			
					}else{
			%>	
						<td></td>
						<td></td>		
			<%			
					}
			%>
				</tr>
			<%
				}					
			%>
		</table>
</div>

<!-- ----하단 카피라이트------ -->
<div class="container" style="margin-top: 80px; margin-bottom: 20px;">
	<jsp:include page="/inc/copyright.jsp"></jsp:include>	
</div>			
</body>
</html>