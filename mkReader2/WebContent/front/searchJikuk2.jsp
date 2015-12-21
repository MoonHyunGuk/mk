<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="com.mkreader.dao.GeneralDAO"%>
<%@ page import="kr.reflexion.espresso.servlet.util.*" %>
<%@ page import="kr.reflexion.espresso.util.*" %>
<%@ page import="org.springframework.web.context.*"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="org.springframework.web.context.support.*"%>

<%
	ServletContext ctx = pageContext.getServletContext();
	WebApplicationContext wac = WebApplicationContextUtils.getRequiredWebApplicationContext(ctx);

	GeneralDAO generalDAO = (GeneralDAO) wac.getBean("generalDAO");
	
	//parameter
	Param param = new HttpServletParam(request);
	String type = param.getString("type");
	String searchkey1 = param.getString("searchkey1");
	String searchkey2 = param.getString("searchkey2");
	
	//dbparam
	HashMap dbparam = new HashMap();
	dbparam.put("TYPE", type);
	dbparam.put("SEARCHKEY1",searchkey1);
	dbparam.put("SEARCHKEY2",searchkey2);
	
	List resultList = null;
	if( StringUtils.isNotEmpty(type) ){
		resultList = generalDAO.queryForList("admin.getJikukList",dbparam);
	}
	
%>




<style> 
<!--
td{font-size: 9pt ; text-align: justify ;line-height: 4.5mm}
input { border-style:groove ; font-size:9pt }
-->
</style>

<script type="text/javascript">
	function search(type){

		var frm = document.getElementById("frm");
		
		if( frm.searchkey1.value == "" && frm.searchkey2.value == ""){
			alert("검색어를 입력해 주세요.");
			frm.searchkey1.focus();
			return;
		}
		frm.type.value = type;
		frm.action = "searchJikuk2.jsp";
		frm.submit();
	}
</script>
<table align="center" cellpadding="0" cellspacing="0" width="630">
    <tr>
        <td width="630" valign="top">
            <table width="630" cellpadding="0" cellspacing="0" height="29">
                <tr>
                    <td width="620">
                        <p style="margin-left:20px;"><b>지국찾기 -  </b>동(읍,면)으로 검색</p>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td width="630" valign="top">
			<p align="center">&nbsp;</p>
        </td>
    </tr>
    <tr>
        <td width="630" valign="top">
            <table cellpadding="5" cellspacing="1" width="630" bgcolor="#CFCECB">
                <tr>
                    <td width="620" bgcolor="#E5E3DD">
                    	<form id="frm" name="frm" method="post">
                    	<input type="hidden" id="type" name="type" value="" />
	                        <table cellpadding="0" cellspacing="0" width="100%" height="30" bgcolor="white">
	                            <tr>
	                                <td width="65">
										<p align="center">
											<b>
												<img src="images/i.gif" width="9" height="9" border="0"> 지국명
											</b>
										</p>
	                                </td>
	                                <td width="247">
	                                	<p>
	                                		<input type="text" id="searchkey1" name="searchkey1" size="26" value="<%if("1".equals(type)){ %><%=searchkey1 %><%} %>" style="font-size:9pt; border-style:groove; background:none;" onkeydown="javascript: if (event.keyCode == 13) {search('1');return false;}">
	                                		<input type="image" src="./images/search.gif" align="absmiddle" width="46" height="18" border="0" style="border-style:none;" onclick="search('1');return false;">
	                                	</p>
	                                </td>
	                                <td width="65">                        
	                                	<p align="center">
	                                		<b>
	                                			<img src="images/i.gif" width="9" height="9" border="0"> 지역명
	                                		</b>
	                                	</p>
	                                </td>
	                                <td width="241">
	                                	<p>
	                                		<input type="text" id="searchkey2" name="searchkey2" size="26" value="<%if("2".equals(type)){ %><%=searchkey2 %><%} %>" style="font-size:9pt; border-style:groove" onkeydown="javascript: if (event.keyCode == 13) {search('2');return false;}">
	                                		<input type="image" src="./images/search.gif" align="absmiddle" width="46" height="18" border="0" style="border-style:none;" onclick="search('2');return false;">
	                                	</p>
	                                </td>
	                            </tr>
	                        </table>
                        </form>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td width="630" valign="top">
            <p>&nbsp;</p>
        </td>
    </tr>
	<tr>
        <td width="630" valign="top">
        	
        	<!-- 조회결과 시작 -->
        	<table cellpadding="0" cellspacing="1" width="630" bgcolor="#E1E1E1">
                <tr>
                    <td width="82" height="25" bgcolor="#F1F0EE">
                        <p align="center"><b>지국명</b></p>
                    </td>
                    <td width="153" height="25" bgcolor="#F1F0EE">
                        <p align="center"><b>연락처</b></p>
                    </td>
                    <td width="69" height="25" bgcolor="#F1F0EE">
                        <p align="center"><b>우편번호</b></p>
                    </td>
                    <td width="296" height="25" bgcolor="#F1F0EE">
                        <p align="center"><b>주 &nbsp;소</b></p>
                    </td>
                </tr>
                
				<%
				// 조회결과가 없는 경우
				if( resultList == null || resultList.size() == 0 ){
				%>
					<tr>
	                    <td colspan="4" height="80" bgcolor="white">
							<div align=center>찾으시는 지국이 없습니다.</div>
	                    </td>
	                </tr>
				<%
				// 조회결과 출력시작
				}else{
					Map result = null;
					
					String serial = "";
					String name = "";
					String jikuk_tel = "";
					String jikuk_handy = "";
					String zip = "";
					String txt = "";
					String bunkukNm = "";

					// rowspan 처리를위한 변수
					String beforeSerial = "";
					String beforeJikuk_tel = "";
					String partCnt = "";
					String partCnt2 = "";
					int checkRows = 0;
					int checkRows2 = 0;
					
					for( int i=0; i < resultList.size(); i++ ){
						result = (Map)resultList.get(i);
						serial = (String)result.get("SERIAL");
						name = (String)result.get("NAME");
						jikuk_tel = (String)result.get("JIKUK_TEL");
						jikuk_handy = (String)result.get("JIKUK_HANDY");
						zip = (String)result.get("ZIP");
						txt = (String)result.get("TXT");
						bunkukNm = (String)result.get("SUBNAME");

						partCnt = result.get("PARTCNT").toString();
						partCnt2 = result.get("PARTCNT2").toString();
						
						// 이전 지국과 같은 경우 row+1
						if(serial.equals(beforeSerial)){
							checkRows += 1;
						}else{
							checkRows = 0;
						}
						
						// 이전 연락처와 같은 경우 row+1
						if(jikuk_tel.equals(beforeJikuk_tel)){
							checkRows2 += 1;
						}else{
							checkRows2 = 0;
						}
				%>
				<tr bgcolor="FFFFFF">
				<%		// 지국명 td 생성
						if(checkRows == 0){
				%>
					<td rowspan="<%=partCnt%>" valign="top">
					<p align="center">
						<%=name%><br>(<%=serial%>)
					</p>
					</td>
				<%		}
						// 연락처 td 생성
						if(checkRows2 == 0){
				%>
	                <td rowspan="<%=partCnt2%>" valign="top"><p align="center">
						<!-- 분국인 경우 분국 표시 -->
		                <%	if(bunkukNm != null && !"".equals(bunkukNm)) {%>
		                	<%=name %>분국-<%=bunkukNm %><br>
		                <%	} %>
                		<%=jikuk_tel %><br>(<%=jikuk_handy%>)
                    </p>				
	                </td>
				<%		}%>
					<td><p align="center">
						<%=zip %>
						</p>
					</td>
					<td><p align="left">
						<%=txt %>
						</p>
					</td>
				</tr>
				<%		// rowspan 처리를 위한 이전row 변수 입력
						beforeSerial = serial;
						beforeJikuk_tel = jikuk_tel;
					}
				}
				%>
            </table>
        </td>
    </tr>
	<tr>
        <td width="630" valign="top">
            <p>&nbsp;</p>
        </td>
    </tr>
</table>
