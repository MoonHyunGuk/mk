<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page contentType="application;" %>
<%@ page import="java.util.*,java.io.*,java.sql.*,java.text.*"%>
<%
request.setCharacterEncoding("EUC-KR");
String DOMAINPATH = request.getParameter("file_path");

ServletContext context = getServletContext(); // 서블릿 컨텍스트 얻기
DOMAINPATH = context.getRealPath(DOMAINPATH); // 상대경로(저장할 폴더)
String fname = request.getParameter("file_name");
String freal_name = request.getParameter("file_name");
String ext = "";

fname = DOMAINPATH + fname;



File file = new File(fname); 	// 절대경로

if(!fname.equals("")){
	ext = fname.substring(fname.lastIndexOf(".")+1);
}

if(!file.equals("")){
	int fSize = (int)file.length();
	String strClient=request.getHeader("User-Agent");
	response.setHeader("Content-Type", "application/unknown");
	response.setHeader("Content-Disposition", "attachment;filename="+freal_name+";");
	response.setContentType(ext);
	response.setHeader("Content-Transfer-Encoding", "binary;");
	response.setHeader("Pragma", "no-cache;");
	response.setHeader("Expires", "-1;");

	if (fSize > 0 && file.isFile()){
		byte b[] = new byte[fSize];
		BufferedInputStream  fin  = new BufferedInputStream(new FileInputStream(file));
		BufferedOutputStream outs = new BufferedOutputStream(response.getOutputStream());
		int read = 0;
		try {
			while ((read = fin.read(b)) != -1){
				outs.write(b,0,read);
			}
			outs.close();
			fin.close();
		} catch (Exception e) {
			throw new Exception(e.toString());
		} finally {
			if(outs!=null) outs.close();
			if(fin!=null) fin.close();
		}
	}
} else {
	
	out.print("<script>alert('서버에 파일이 존재하지 않습니다.'); history.back();</script>");
}
 
%>


