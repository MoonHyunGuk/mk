package com.mkreader.util;

public class PagingUtil {
	
	public static String CreatePaging(int startpage, int totpage, int conternp, int gotopage, String link) {
		String wholePaging = "";
		
		//이전글 10개    다음글 10개  를 클릭했을 경우의 체크
		if( totpage > conternp ){
			if( startpage == 1 ){
				wholePaging += " [ 이전 " + conternp + " 개 ] ";				//링크없는 이전글10개버튼			
			}else{
				wholePaging += link + "&page=" + (startpage - conternp) + "&startpage=" + (startpage - conternp) + "'>";
				wholePaging += " [ 이전 " + conternp + " 개</a> ] ";			//링크있는 이전글10개 버튼
			}
			
			for(int i=startpage;i<(startpage+conternp);i++){
				if( i > totpage ){
					break;
				}else{
					if( i == gotopage ){
						wholePaging += " <b>" + i + "</b> ";
					}else{
						wholePaging += link + "&page=" + i + "&startpage=" + startpage + "'>";
						wholePaging += " [<b>" + i + "</b>] </a> ";
					}
				}
			}
			if( (startpage/conternp) == (totpage/conternp) ){
				wholePaging += " [ 다음 " + conternp + " 개 ] ";
			}else{
				wholePaging += link + "&page=" + (startpage+conternp) + "&startpage=" + (startpage+conternp) + "'>";
				wholePaging += " [ 다음 " + conternp + " 개</a> ] ";
			}
	
		}else{																//페이지의 갯수가 10개가 안되는 경우
			wholePaging += " [ 이전 " + conternp + " 개 ] ";
			
			for(int i=startpage ; i<=totpage ; i++){
				if( i == gotopage ){
					wholePaging += " <b>" + i + "</b> ";
				}else{
					wholePaging += link + "&page=" + i + "'>[" + i + "]</a> ";
				}
			}
			
			wholePaging += " [ 다음 " + conternp + " 개 ] ";
		}
		
		return wholePaging;

		
	}
	
	
}
