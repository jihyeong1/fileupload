<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.oreilly.servlet.*" %>
<%@ page import="com.oreilly.servlet.multipart.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.io.*" %>
<%@ page import = "java.sql.*" %>   
<%
	// 로그인 유효성 검사(로그인 유무)
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath()+"/login.jsp");
		return;		
	}
	// 요청값 변수 저장
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String saveFilename = request.getParameter("saveFilename");
	String path = request.getParameter("path");
	
	//파일위치 설정
	String dir = request.getServletContext().getRealPath("/" + path) + "/" + saveFilename;
	System.out.println(dir + "<--저장위치");
	
	//저장된 파일 삭제
	File f = new File(dir);
	if(f.exists()){
		f.delete();
		//디버깅
		System.out.println(saveFilename + " <-- 파일삭제");
	}
	
	//DB연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/fileupload", "root", "java1234");
	
	//db에서 board삭제하는 쿼리
	//cascade가 되어있어서 board를 삭제하면 board_file도 같이 삭제됨. 
	String sql = "delete from board where board_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);
	
	//쿼리 실행
	int row = stmt.executeUpdate();
	
	if(row == 1){
		System.out.println("삭제성공");
	}else{
		System.out.println("삭제실패");
	}
	
	response.sendRedirect(request.getContextPath() + "/boardList.jsp");
%>
