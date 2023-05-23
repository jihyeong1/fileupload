<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.net.*" %>    
<%@ page import="java.sql.*" %>   
<%@ page import="vo.*" %>  
<%
	//세션 유효성 검사
	if(session.getAttribute("loginMemberId") != null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	//요청값 검사
	String msg = "";
	if(request.getParameter("addMemberId") == null
		||request.getParameter("addMemberId").equals("")){
		msg = URLEncoder.encode("아이디를 다시 입력해주세요.","utf-8");
		response.sendRedirect(request.getContextPath()+"/member/addMember.jsp?msg="+msg);
		return;
	}
	if(request.getParameter("addMemberPw") == null
		||request.getParameter("addMemberPw").equals("")){
		msg = URLEncoder.encode("비밀번호를 다시 입력해주세요.","utf-8");
		response.sendRedirect(request.getContextPath()+"/member/addMember.jsp?msg="+msg);
		return;
	}
	//요청값 변수 저장
	String addMemberId = request.getParameter("addMemberId");
	String addMemberPw = request.getParameter("addMemberPw");
	
	System.out.println(addMemberId + "<--addMemberId");
	System.out.println(addMemberPw + "<--addMemberPw");
	
	//요청값 묶어서 저장하기
	Member addMember = new Member();
	addMember.setMemberId(addMemberId);
	addMember.setMemberPw(addMemberPw);
	
	//디비연결
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/fileupload";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	// 회원가입 쿼리 작성
	/* INSERT INTO member
	VALUES(?, PASSWORD(?), NOW(), NOW());  */
	String addMemberSql="INSERT INTO member VALUES(?, PASSWORD(?), NOW(), NOW())";
	PreparedStatement addMemberStmt = conn.prepareStatement(addMemberSql);
	addMemberStmt.setString(1, addMember.getMemberId());
	addMemberStmt.setString(2, addMember.getMemberPw());
	
	// 아이디가 중복일 경우 쿼리 작성
	String sql = "SELECT member_id memberId from member WHERE member_id=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, addMember.getMemberId());
	ResultSet rs = stmt.executeQuery();
	//중복된 아이디가 있는경우
	if(rs.next()){ 
		msg = URLEncoder.encode("중복된 ID입니다", "utf-8");
		response.sendRedirect(request.getContextPath()+"/member/addMember.jsp?msg="+msg);
		return;
	}
	
	// 결과 확인
	int row = addMemberStmt.executeUpdate();
	//디버깅
	System.out.println(row + "row값");
	
	if(row==1){
		System.out.println("회원가입 성공");
		response.sendRedirect(request.getContextPath() + "/boardList.jsp"); //정상작동하면 홈으로
	}else{
		System.out.println("회원가입 실패");
		response.sendRedirect(request.getContextPath() + "/member/addMember.jsp"); //실패시 가는 곳
	}
%>