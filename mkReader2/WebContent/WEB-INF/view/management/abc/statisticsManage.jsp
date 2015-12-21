<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ page import="com.mkreader.security.ISiteConstant" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<style type="text/css">
.tb_search {margin:0 auto; text-align:center; border-collapse:collapse; font:normal 12px Gulim, "굴림", Verdana, Geneva; }
.tb_search th, .tb_search td {padding:1px 1px; }
.tb_search th {text-align:center; border:1px solid #e5e5e5; background-color: #f9f9f9; font-weight: bold/*#e48764*//*#e16536 */;}
.tb_search td {text-align:left; border:1px solid #e5e5e5; background-color: #fff; padding-left: 10px;}
</style>
<script>
	var yymmList = new Array();
	<c:forEach var="yymm" items="${yymmList}">
	yymmList[yymmList.length] = '${yymm}';
	</c:forEach>
	jQuery(function($){
		var index = 0;
		insertStatistics = function(yymm,flag){
			if($.trim($("#boseq").val()) == ""){
				alert("지국코드를 입력하세요.");
				$("#boseq").focus();
				return;
			}
			var url = "insertStatistics.do";
			var param = {"boseq":$("#boseq").val(),"yymm":yymm};
			$("#prcssDiv").show();
			$("#" + yymm).html("");
			$.getJSON(url,param,function(data){
				if(data.result){
					$("#" + yymm).html("<font color=\"blue\">성공</font>");
				}else{
					$("#" + yymm).html("<font color=\"red\">실패</font>");
				}
				if(flag){
					index++;
					if(index == yymmList.length - 1){
						flag = false;
					}
					var nextYymm = yymmList[index];
					insertStatistics(nextYymm,flag);
				}else{
					$("#prcssDiv").hide();
				}
			});
		}
		
		$("#totalInsertBtn").click(function(){
			index = 0;
			insertStatistics(yymmList[0],true);
		});
	});
</script>
<!-- title -->
<div><span class="subTitle">통계 관리</span></div>
<!-- //title -->
		<form name="listForm" id="listForm" method="post">
		<div style=" width: 500px;">
			<table class="tb_search" style="width: 500px;">
				<col width="100px">
				<col width="200px">
				<col width="100px">
				<tr>
					<th>지국코드</th>
					<td colspan="2"><input type="text" style="width: 150px" name="boseq" id="boseq" value="${boseq}"/></td>
				</tr>
				<c:forEach var="yymm" items="${yymmList}">
				<tr>
					<th>수금월</th>
					<td><input type="text" name="yymm" id="yymm" value="${yymm}" readOnly="readOnly"></td>
					<td>
						<div style="float: left;">
							<span class="btnCss2"><a class="lk2" href="#" onclick="insertStatistics('${yymm}',false);return false;">생성</a></span>&nbsp;
							<span id="${yymm}"></span>
						</div>
					</td>
				</tr>
				</c:forEach>
			</table>
		</div>
		</form>
		<div id="prcssDiv"  class="loingProcessDiv" style="display:none;"><div><img src="/images/process4.gif"/></div></div>
		<div style=" width: 500px;padding-top:20px;text-align: right;"><span class="btnCss2"><a class="lk2" href="#" id="totalInsertBtn">전체생성</a></span></div>
