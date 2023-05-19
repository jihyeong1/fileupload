<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %> 
<%@ page import = "java.net.*" %>   
<%@ page import = "vo.*" %>
<%
	//혹시나 잘못된경로로 접근할 수 있는걸 예방하기 위한 로그인 유효성 검사
	if(session.getAttribute("loginMemberId") != null){
		response.sendRedirect(request.getContextPath()+"/boardList.jsp");
		return;
	}

	//memberId, memberPw 입력값 불러오기
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	
	//입력값 디버깅
	System.out.println(memberId + "<--loginAction parm memberId");
	System.out.println(memberPw + "<--loginAction parm memberPw");
	
	//유효성 검사
	String msg = "";
	if(memberId == null
		|| memberId.equals("")){
		msg = URLEncoder.encode("아이디를 다시 입력해주세요.","utf-8");
		response.sendRedirect(request.getContextPath()+"/login.jsp?msg="+msg);
		return;
	}
	if(memberPw == null
		|| memberPw.equals("")){
		msg = URLEncoder.encode("비밀번호를 다시 입력해주세요.","utf-8");
		response.sendRedirect(request.getContextPath()+"/login.jsp?msg="+msg);
		return;
	}
	
	//변수 저장, memberId 와 memberPw를 묶어서 저장한다.
	Member bindMember = new Member();
	bindMember.setMemberId(memberId);
	bindMember.setMemberPw(memberPw);
	
	//디비연결
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/fileupload";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	//아이디,비밀번호를 조회해서 일치하는지 확인하는 쿼리문 작성
	/* SELECT member_id memberId FROM member WHERE member_id=? AND member_pw= PASSWORD(?) */
	String memberSql="SELECT member_id memberId FROM member WHERE member_id=? AND member_pw= PASSWORD(?)";
	PreparedStatement memberStmt = conn.prepareStatement(memberSql);
	memberStmt.setString(1, bindMember.getMemberId());
	memberStmt.setString(2, bindMember.getMemberPw());
	
	//디버깅
	System.out.println(memberStmt + "<--loginAction memberStmt");
	
	ResultSet memberRs = memberStmt.executeQuery();
	if(memberRs.next()){
		//만약 일치하면 세션에 로그인id를 저장해준다. 이 외에 파일들에서도 꺼내서 쓰기위해
		session.setAttribute("loginMemberId", memberRs.getString("memberId"));
		System.out.println("로그인 성공");
		response.sendRedirect(request.getContextPath()+"/boardList.jsp");
	}else{
		System.out.println("로그인 실패");
		msg = URLEncoder.encode("존재하지않는 정보입니다.","utf-8");
		response.sendRedirect(request.getContextPath()+"/login.jsp?msg="+msg);
		return;
	}
	
	//일치하지않으면
%>       
