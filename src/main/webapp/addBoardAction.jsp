<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ page import="com.oreilly.servlet.*" %>
 <%@ page import="com.oreilly.servlet.multipart.*" %>    
 <%@ page import="vo.*" %>
 <%@ page import="java.io.*" %>
 <%@ page import = "java.sql.*" %>   
<!-- multipart 폼데이터를 처리하기 위해 기본API(request)대신 외부 API(cos.jar)를 사용하겠다  -->  
<!-- 기본API(request)사용시 코드가 너무 복잡해지기때문에 -->
<!-- 외부 API(cos.jar)는 실무에서는 잘 사용하지않는다. -->
<%
	//저장경로 설정
	String dir = request.getServletContext().getRealPath("/upload");
	int max = 10 * 1024 * 1024;
	//request객체를 MultipartRequest API를 사용할 수 있도록 랩핑
	/* new DefaultFileRenamePolicy() 같은 파일의 이름이 들어왔을 때 파일이름뒤에 숫자로 분리한다.
	다만 이 방법이 좋지 못한 이유가 중복되는 이름을 다 찾아야하기때문에 사용성이 좋지 못하다*/
	MultipartRequest mreq = new MultipartRequest(request, dir, max, "utf-8", new DefaultFileRenamePolicy());
	
	// 업로드 된 파일의 타입이 pdf가 아닐경우 반환
	if(!mreq.getContentType("boardFile").equals("application/pdf")){
		//이미 저장된 파일을 삭제
		System.out.println("PDF 파일이 아닙니다");
		String saveFileName = mreq.getFilesystemName("boardFile");
		File f = new File(dir+"/"+saveFileName); //저장되어있는 파일을 찾아서 삭제해야하기 때문에 위에서 위치 선정해준 dir과 같이 써야함
		if(f.exists()){
			f.delete();
			System.out.println(saveFileName + "<--파일삭제");
		}
		response.sendRedirect(request.getContextPath()+"/addBoard.jsp");
		//메세지 넣어주면 좋을거같음
		return;
	}
	
	// 1) input type="text" 값반환 API --> board 테이블에 저장하면됨
	String boardTitle = mreq.getParameter("boardTitle");
	String memberId = mreq.getParameter("memberId");
	
	System.out.println(boardTitle + "<--boardTitle");
	System.out.println(memberId + "<--memberId");
	
	Board board = new Board();
	board.setBoardTitle(boardTitle);
	board.setMemberId(memberId);
	
	// 2) input type="file" 값(파일 메타 정보)반환 API(원본파일이름, 저장된파일이름, 컨텐츠타입)
	// --> board_file 테이블에 저장하면됨		
	// 기본파일(바이너리) 는 이미 MultipartRequest객체 생성시 10라인에서 이미 저장되었다.
	String type = mreq.getContentType("boardFile");
	String originFilename = mreq.getOriginalFileName("boardFile");
	String saveFilename = mreq.getFilesystemName("boardFile");
	
	System.out.println(type + "<--type");
	System.out.println(originFilename + "<--originFilename");
	System.out.println(saveFilename + "<--saveFilename");
	
	BoardFile boardFile = new BoardFile();
	/* boardFile.setBoardNo(boardNo); */
	boardFile.setType(type);
	boardFile.setOriginFilename(originFilename);
	boardFile.setSaveFilename(saveFilename);
	
	/*
		INSERT INTO board(board_title, member_id, updatedate, createdate VALUES(?, ?, NOW(), NOW());
		
		INSERT INTO board_file(board_no, origin_filename, save_filename, path, type, createdate VALUES(?, ?, ?, ?, ?, NOW());
	*/
	
	//디비연결
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/fileupload";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	String boardSql = "INSERT INTO board(board_title, member_id, updatedate, createdate) VALUES(?, ?, NOW(), NOW())";
	//RETURN_GENERATED_KEYS은 방금 입력된 키값을 잠궈서 저장하고 있음
	PreparedStatement boardStmt = conn.prepareStatement(boardSql, PreparedStatement.RETURN_GENERATED_KEYS);
	//방금 저장된 키값을 반환해서 keyRs에 넣어주세요./ 다만 getGeneratedKeys 이 메소드로 호출해야지만 받을 수 있다.
	boardStmt.setString(1, boardTitle);
	boardStmt.setString(2, memberId);
	boardStmt.executeUpdate(); // board 입력 후 키값저장

	
	ResultSet keyRs = boardStmt.getGeneratedKeys();
	int boardNo = 0;
	if(keyRs.next()){
		boardNo = keyRs.getInt(1);
	}
	
	//board 타이틀에서 먼저 boardNo 와 boardTitle이 입력되야지 boardNo 를 받아서 파일을 업로드 할 수있기때문에 키값을 먼저 위에서 받은 후 file 을 insert 해야한다.
	String fileSql="INSERT INTO board_file(board_no, origin_filename, save_filename, type, path, createdate) VALUES(?, ?, ?, ?, 'upload', NOW())";
	PreparedStatement fileStmt = conn.prepareStatement(fileSql);
	fileStmt.setInt(1, boardNo);
	fileStmt.setString(2, originFilename);
	fileStmt.setString(3, saveFilename);
	fileStmt.setString(4, type);
    fileStmt.executeUpdate(); // board_file 입력
   
    response.sendRedirect(request.getContextPath()+"/boardList.jsp");
			
%>