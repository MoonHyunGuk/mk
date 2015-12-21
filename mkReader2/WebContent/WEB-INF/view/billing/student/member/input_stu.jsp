<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!-- H E A D E R  ::  START -->
<html>
<head>
<title>MK Reader - student</title>

</head>


<body>
<script type="text/javascript">
function goPost() {                                    
    window.open("/services/cust_findpost01.do", "postHome", "width=460,height=250,scrollable=yes,resizable=no");
}
function go() {
	if (document.frmParent.username.value.length<1)
	{
		alert("성명은 필수 기재 사항입니다.");
		document.frmParent.username.focus();
		return false;
	}

	if (document.frmParent.handy_1.value.length<1)
	{
		alert("전화번호 연락처는 필수 기재 사항입니다.");
		document.frmParent.handy_1.focus();
		return false;
	}

	if (document.frmParent.zip2.value.length<1)
	{
		alert("우편번호및 주소를 우편번호 찾기를 이용하여 입력해주세요.");
		goPost();
		return false;
	}
	if (document.frmParent.addr2.value.length<1)
	{
		alert("상세주소는 필수 기재 사항입니다.");
		document.frmParent.addr2.focus();
		return false;
	}

	if (document.frmParent.bank_username.value.length<1)
	{
		alert("예금주명은 필수 기재 사항입니다.");
		document.frmParent.bank_username.focus();
		return false;
	}
	if (document.frmParent.bank.selectedIndex==0)
	{
		alert("이체은행을 선택해주세요");
		document.frmParent.bank.focus();
		return false;
	}
	if (document.frmParent.bank_num.value.length<7)
	{
		alert("계좌번호는 필수 기재 사항입니다.");
		document.frmParent.bank_num.focus();
		return false;
	}
	if (document.frmParent.bank_own.value.length<1)
	{
		alert("예금주의 주민등록번호 혹은 사업자 등록번호를 기재해 주세요.");
		document.frmParent.bank_own.focus();
		return false;
	}
	return true;
}

	function price() {
		idx1 = 7500;
		idx2 = document.frmParent.busu.value;
		
		document.frmParent.bank_money.value = eval( idx1 * idx2 );
	}
	function chjikuk() {
		document.frmParent.user_number1.value = document.frmParent.jikuk_a.value;
	}
</script>
	<form name="frmParent" method="post" action="input_db_stu.do" onSubmit="return go();">
		<table align="center" cellpadding="0" cellspacing="0" width="605">
		    <tr>
		        <td width="605" valign="top">
		                <p><img src="/services/images/t2_stu.gif" width="605" height="29" border="0"></p>
		        </td>
		    </tr>
		    <tr>
		        <td width="605" valign="top">
		            <p>&nbsp;</p>
		        </td>
		    </tr>
		    <tr>
		        <td width="605" valign="top">
		                        <p><b><font color="#CC0000"><img src="images/i.gif" width="9" height="9" border="0"> 필수 기재란 입니다.</font></b></p>
		        </td>
		    </tr>
		    <tr>
		        <td width="605" valign="top">
		            <table align="center" cellpadding="0" cellspacing="1" width="605">
		                <tr>
		                    <td width="603" height="5" bgcolor="#AEA78B" colspan="2">
		                    </td>
		                </tr>
		                <tr>
		                    <td width="166" height="30" bgcolor="#DEDBCE">
		                        <p style="margin-left:20px;">
									<font color="#CC0000"><b><img src="images/i.gif" width="9" height="9" border="0"></b></font><b> 대학명</b>
		                        </p>
		                    </td>
		                    <td width="436" height="30" bgcolor="#F4F1E7">
		                        <p style="margin-left:10px;"><input type="text" name="stu_sch" tabindex=1 maxlength=30></p>
		                    </td>
		                </tr>
		                <tr>
		                    <td width="166" height="30" bgcolor="#DEDBCE">
		                        <p style="margin-left:20px;">
									<font color="#CC0000"><b><img src="images/i.gif" width="9" height="9" border="0"></b></font><b> 학과</b>
		                        </p>
		                    </td>
		                    <td width="436" height="30" bgcolor="#F4F1E7">
		                        <p style="margin-left:10px;"><input type="text" name="stu_part" tabindex=1 maxlength=30></p>
		                    </td>
		                </tr>
		                <tr>
		                    <td width="166" height="30" bgcolor="#DEDBCE">
		                        <p style="margin-left:20px;">
									<font color="#CC0000"><b><img src="images/i.gif" width="9" height="9" border="0"></b></font><b> 학년</b>
		                        </p>
		                    </td>
		                    <td width="436" height="30" bgcolor="#F4F1E7">
		                        <p style="margin-left:10px;"><input type="text" name="stu_class" tabindex=1 maxlength=2></p>
		                    </td>
		                </tr>
		
		                <tr>
		                    <td width="166" height="30" bgcolor="#DEDBCE">
		                        <p style="margin-left:20px;"><font color="#CC0000"><b><img src="images/i.gif" width="9" height="9" border="0"></b></font><b> 성명</b></p>
		                    </td>
		                    <td width="436" height="30" bgcolor="#F4F1E7">
		                        <p style="margin-left:10px;"><input type="text" name="username" tabindex=1 maxlength=30></p>
		                    </td>
		                </tr>                
		                <tr>
		                    <td width="166" height="30" bgcolor="#DEDBCE">
		                        <p style="margin-left:20px;"><b><font color="#CC0000"><img src="images/i.gif" width="9" height="9" border="0"> 
		                        </font> 휴대폰<br></b></p>
		                    </td>
		                    <td width="436" height="30" bgcolor="#F4F1E7">
		                        <p style="margin-top:4px; margin-left:10px;">
		                        	<select name="handy_1" style="border-style:none;" tabindex=10>
										<option value="" selected>----</option>
										<option value="010">010</option>
										<option value="011">011</option>
										<option value="016">016</option>
										<option value="017">017</option>
										<option value="018">018</option>
										<option value="019">019</option>
										<option value="0130">0130</option>
									</select>- 
									<input type="text" name="handy_2" maxlength="4" size="4" tabindex=11 ONKEYPRESS="if((event.keyCode<48)||(event.keyCode>57)) event.returnValue=false;" > 
		                        	- <input type="text" name="handy_3" maxlength="4" size="4" tabindex=12 ONKEYPRESS="if((event.keyCode<48)||(event.keyCode>57)) event.returnValue=false;" >                    
							</td>
		                </tr>
		                <tr>
		                    <td width="166" height="30" bgcolor="#DEDBCE">
		                        <p style="margin-left:20px;"><font color="#CC0000">&nbsp;&nbsp;&nbsp;</font><b> 전화번호</b></p>
		                    </td>
		                    <td width="436" height="30" bgcolor="#F4F1E7">
		                        <p style="margin-top:4px; margin-left:10px;">
		                        	<select name="tel_1" style="border-style:none;" tabindex=2>
										<option value="" selected>----</option>
										<option value="02">02</option>
										<option value="031">031</option>
										<option value="032">032</option>
										<option value="033">033</option>
										<option value="041">041</option>
										<option value="042">042</option>
										<option value="043">043</option>
										<option value="051">051</option>
										<option value="052">052</option>
										<option value="053">053</option>
										<option value="054">054</option>
										<option value="055">055</option>
										<option value="061">061</option>
										<option value="062">062</option>
										<option value="063">063</option>
										<option value="064">064</option>
										<option value="0502">0502</option>
										<option value="070">070</option>
									</select> - 
									<input type="text" name="tel_2" maxlength="4" size="4" tabindex=3 ONKEYPRESS="if((event.keyCode<48)||(event.keyCode>57)) event.returnValue=false;" > 
		                        	- <input type="text" name="tel_3" maxlength="4" size="4" tabindex=4 ONKEYPRESS="if((event.keyCode<48)||(event.keyCode>57)) event.returnValue=false;" >                    
							</td>
		                </tr>
		                <tr>
		                    <td width="166" height="30" bgcolor="#DEDBCE">
		                        <p style="margin-left:20px;">
		                        	<font color="#CC0000">
		                        		<b>
		                        			<img src="images/i.gif" width="9" height="9" border="0">
		                        		</b>
		                        	<b> 우편번호</b>
		                        </p>
		                    </td>
		                    <td width="436" height="30" bgcolor="#F4F1E7">
		                        <table cellpadding="0" cellspacing="0" width="90%" style="margin-left:10px;">
		                            <tr>
		                                <td width="486">                        
		                                	<p>
		                                		<input type="text" name="zip1" maxlength="3" size="3" style="cursor:hand;" onClick='goPost();' readonly /> 
		                                    	- <input type="text" name="zip2" maxlength="3" size="3" style="cursor:hand;" onClick='goPost();' readonly />&nbsp;
		                                    	<img src="/services/images/zip_chk.gif" align="absmiddle"  border="0" hspace="5" style="cursor:hand;" onClick='goPost();' />
		                                    </p>
		                                </td>
		                            </tr>
		                        </table>
		                    </td>
		                </tr>
		                <tr>
		                    <td width="166" height="30" bgcolor="#DEDBCE">
		                        <p style="margin-left:20px;">
		                        	<font color="#CC0000">
		                        		<b>
		                        			<img src="images/i.gif" width="9" height="9" border="0" />
		                        		</b>
		                        	</font>
		                        	<b> 상세주소</b>
		                        </p>
		                    </td>
		                    <td width="436" height="30" bgcolor="#F4F1E7">
		                        <table cellpadding="0" cellspacing="0" width="90%" style="margin-left:10px;">
		                            <tr>
		                                <td width="486">                        
		                                	<p>
		                                		<input type="text" name="addr1" size="41" readonly style="cursor:hand;" onClick='goPost();' />
		                                	</p>
		                                </td>
		                            </tr>
		                            <tr>
		                                <td width="486">                        
		                                	<p>
		                                		<input type="text" name="addr2" size="54" tabindex=5 maxlength=100 />
		                                	</p>
		                                </td>
		                            </tr>
		                        </table>
		                    </td>
		                </tr>           
		                <tr>
		                    <td width="166" height="30" bgcolor="#DEDBCE">
		                        <p style="margin-left:20px;"><font color="#CC0000">
		                        	<b>
		                        		<img src="images/i.gif" width="9" height="9" border="0" />
		                        	</b>
		                        </font>
		                        <b> 구독부수</b></p>
		                    </td>
		                    <td width="436" height="30" bgcolor="#F4F1E7">
		                        <p style="margin-left:10px;">
			                        <select name="busu" onchange="price();">
			                        <% for(int i=1;i<100;i++){ %>
										<option value='<%=i%>'><%=i%></option>
									<%} %>
									</select>
								</p>
		                    </td>
		                </tr>
		                <tr>
		                    <td width="166" height="30" bgcolor="#DEDBCE">
		                        <p style="margin-left:20px;"> 
		                        <b>&nbsp;&nbsp;&nbsp;이메일</b></p>
		                    </td>
		                    <td width="436" height="30" bgcolor="#F4F1E7">
		                      
		                        <p style="margin-left:10px;"><input type="text" name="email" size="41" tabindex=14 maxlength=130></p>
		                    </td>
		                </tr>
		                <tr>
		                    <td width="166" height="30" bgcolor="#DEDBCE">
		                        <p style="margin-left:20px;">
									<font color="#CC0000"><b><img src="images/i.gif" width="9" height="9" border="0"></b></font><b> 추천교수</b>
		                        </p>
		                    </td>
		                    <td width="436" height="30" bgcolor="#F4F1E7">
		                        <p style="margin-left:10px;"><input type="text" name="stu_prof" tabindex=1 maxlength=30></p>
		                    </td>
		                </tr>
						<tr>
		                    <td width="166" height="49" bgcolor="#DEDBCE">
		                        <p style="margin-left:20px;"> <b>&nbsp;&nbsp;배달지국<br></b></p>
		                    </td>
		                    <td width="436" height="49" bgcolor="#F4F1E7">
								<p style="margin-left:10px;">
								<select name="jikuk_a" onchange="chjikuk();">
									<option value="">--선택해주세요--</option>
		<%
			//siklop start::
			//sql = "SELECT serial, name FROM tbl_jikuk WHERE serial IS NOT NULL order by name"
			//Set rsin= conn.execute(sql)
			//While Not rsin.eof 
			//		response.write("<option value='"&rsin(0)&"'>"&rsin(1)&"</option>")
			//	rsin.movenext
			//Wend
			//Set rsin = Nothing
		%>
								</select>
								</p>
		                    </td>
		                </tr>
		
						<tr>
		                    <td width="166" height="49" bgcolor="#DEDBCE">
		                        <p style="margin-left:20px;"> <b>&nbsp;&nbsp;납부자번호<br></b></p>
		                    </td>
		                    <td width="436" height="49" bgcolor="#F4F1E7">
		                        <p style="margin-left:10px;">
		                        	<input type="text" name="user_number1" tabindex=99 value="" maxlength="6" size="6" readonly style="border:none;" dir="rtl" />
									<input type="text" name="user_number2" tabindex=5 value="" maxlength=5 size="6" />
								<br>&quot; 
		                        
		                        매일경제신문사 기재란 입니다 &quot;</p>
		                    </td>
		                </tr>              
		                <tr>
		                    <td width="166" height="30" bgcolor="#DEDBCE">
		                        <p style="margin-left:20px;">
									<font color="#CC0000">
										<b>
											<img src="images/i.gif" width="9" height="9" border="0" />
										</b>
									</font>
									<b> 권유자</b>
		                        </p>
		                    </td>
		                    <td width="436" height="30" bgcolor="#F4F1E7">
		                        <p style="margin-left:10px;">
		                        	<input type="text" name="stu_adm" tabindex=1 maxlength=30 />
		                        </p>
		                    </td>
		                </tr>
		                <tr>
		                    <td width="166" height="30" bgcolor="#DEDBCE">
		                        <p style="margin-left:20px;">
									<font color="#CC0000">
										<b>
											<img src="images/i.gif" width="9" height="9" border="0" />
										</b>
									</font>
									<b> 통화자</b>
		                        </p>
		                    </td>
		                    <td width="436" height="30" bgcolor="#F4F1E7">
		                        <p style="margin-left:10px;">
		                        	<input type="text" name="stu_caller" tabindex=1 maxlength=30 />
		                        </p>
		                    </td>
		                </tr>
		            </table>
		        </td>                           
			</tr> 
		    <tr>
		        <td width="605" valign="top">
		            <p>&nbsp;</p>
		        </td>
		        <td width="603" height="5" bgcolor="#aea78b" colspan="2">
		        	<input type="hidden" name="intype" value="기존" />
		        </td>         
		    </tr>
		
		    <tr>
		        <td width="605" valign="top">
					<p>
						<img src="images/t2.gif" width="605" height="29" border="0" />
					</p>
		        </td>
		    </tr>
		    <tr>
		        <td width="605" valign="top">
		            <p>&nbsp;</p>
		        </td>
		    </tr>
		    <tr>
		        <td width="605" valign="top" height="382">
		            <table align="center" cellpadding="0" cellspacing="1" width="605">
		                <tr>
		                    <td width="603" height="5" colspan="2" bgcolor="#AEA78B">
		                    </td>
		                </tr>
		                <tr>
		                    <td width="166" height="30" bgcolor="#DEDBCE">
		                        <p style="margin-left:20px;">
		                        	<b>
		                        		<font color="#CC0000"><img src="images/i.gif" width="9" height="9" border="0"></font> 이체 금액 </b>
		                        	</p>
		                    </td>
		                    <td width="436" height="30" bgcolor="#F4F1E7">
		                        <p style="margin-left:10px;">
		                        	<input type="text" name="bank_money" tabindex=6 maxlength=10 value="7500" readonly size="10"> 부수에 따라 자동 계산됩니다.</p>
		                    </td>
		                </tr>
						<tr>
		                    <td width="166" height="30" bgcolor="#DEDBCE">
		                        <p style="margin-left:20px;">
		                        	<b>
		                        		<font color="#CC0000">
		                        			<img src="images/i.gif" width="9" height="9" border="0"> 
		                        		</font>예금주명
		                        	</b>
		                        </p>
		                    </td>
		                    <td width="436" height="30" bgcolor="#F4F1E7">
		                        <p style="margin-left:10px;">
		                        	<input type="text" name="bank_username" tabindex=6 maxlength=30 />
		                        </p>
		                    </td>
		                </tr>
		                <tr>
		                    <td width="166" height="30" bgcolor="#DEDBCE">
		                        <p style="margin-left:20px;">
		                        	<b>
		                        		<font color="#CC0000"><img src="images/i.gif" width="9" height="9" border="0"> 
		                        		</font>이체 은행</b>
		                        </p>
		                    </td>
		                    <td width="436" height="30" bgcolor="#F4F1E7">
		                        <p style="margin-top:4px; margin-left:10px;"><select name="bank" size="1" tabindex=7>
		<option value="" selected>----</option>
		<%
			
				//sql = "SELECT banknum, bankname FROM tbl_bank order by banknum"
				//Set rs = conn.execute(sql)
		
				//While Not rs.eof
		%>
								<option value="rs(0)0000">rs(1)</option>
		<%
				//	rs.movenext
				//Wend
				//Set rs = Nothing
				//conn.close
				//Set conn = nothing
		%>
		                      </select>                    </td>
		                </tr>
		                <tr>
		                    <td width="166" height="30" bgcolor="#DEDBCE">
		                        <p style="margin-left:20px;">
			                        <b>
				                        <font color="#CC0000">
				                        	<img src="images/i.gif" width="9" height="9" border="0" /> 
				                        </font>계좌 번호
				                    </b>
			                    </p>
		                    </td>
		                    <td width="436" height="30" bgcolor="#F4F1E7">
		                        <p style="margin-left:10px;">
		                        	<input type="text" name="bank_num" size="41" ONKEYPRESS="if((event.keyCode<48)||(event.keyCode>57)) event.returnValue=false;" tabindex=8 maxlength=16 />
		                        </p>
		                    </td>
		                </tr>
		                <tr>
		                    <td width="166" height="50" bgcolor="#DEDBCE">
		                        <p style="margin-left:20px;"><b><font color="#CC0000">
		                        	<img src="images/i.gif" width="9" height="9" border="0" /> 
		                        	</font>주민등록번호</b>
		                        </p>
		                    </td>
		                    <td width="436" height="50" bgcolor="#F4F1E7">
		                        <p style="margin-left:10px;">
		                        	<input type="text" name="bank_own" size="41" ONKEYPRESS="if((event.keyCode<48)||(event.keyCode>57)) event.returnValue=false;" tabindex=9 maxlength="13" />
		                        	<br>&quot; 
		                        계좌번호 발급시 기재된 주민번호 
		                        또는 사업자번호&nbsp;&quot;</p>
		                    </td>
		                </tr>
		                <tr>
		                    <td width="166" height="30" bgcolor="#DEDBCE">
		                        <p style="margin-left:20px;"><b>&nbsp;&nbsp;이체시작월<br></b></p>
		                    </td>
		                    <td width="436" height="30" bgcolor="#F4F1E7">
		                        <p style="margin-left:10px;">
								<input type="text" name="sdate" size="10" value="${chdate}">                        
								&quot;익월 5일 출금 &quot;
							</td>
		                </tr>
		                <tr>
		                    <td width="166" height="140" bgcolor="#DEDBCE">
		                        <p style="margin-left:20px;"> 
		                        <b>&nbsp;&nbsp;비고/통신란<br> &nbsp;&nbsp;</b>&quot; 200자 내외 작성 &quot;</p>
		                    </td>
		                    <td width="436" height="140" bgcolor="#F4F1E7">
		                        <p style="margin-left:10px;"><textarea name="memo" rows="8" cols="57" tabindex=15></textarea>                    </td>
		                </tr>
		            </table>
		        </td>
		    </tr>
		    <tr>
		        <td width="605" valign="top">
		            <p>&nbsp;</p>
		        </td>
		    </tr>
		    <tr>
		        <td width="605" valign="top">
		            <p align="center"><input type="image" src="/services/images/bt2.gif" width="71" height="23" border="0" style="border:none;" tabindex=16></p>
		        </td>
		    </tr>
		</table>
	</form>
</body>
</html>



