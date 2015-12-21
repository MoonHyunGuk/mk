/*------------------------------------------------------------------------------
 * NAME : GenerateBnoController 
 * DESC : 중지부활독자 구역/배달번호 자동 설정(ABC용)
 * Author : jyyoo
 *----------------------------------------------------------------------------*/
package com.mkreader.web.etc;

import java.io.File;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import jxl.Cell;
import jxl.Sheet;
import jxl.Workbook;

import kr.reflexion.espresso.servlet.util.HttpServletParam;
import kr.reflexion.espresso.servlet.util.MultipartHttpServletParam;
import kr.reflexion.espresso.util.Param;

import org.apache.commons.lang.StringUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;
import org.springframework.web.servlet.view.RedirectView;

import com.mkreader.dao.GeneralDAO;
import com.mkreader.security.ICodeConstant;
import com.mkreader.security.ISiteConstant;
import com.mkreader.util.DateUtil;
import com.mkreader.util.FileUtil;
import com.mkreader.util.Paging;
import com.mkreader.util.StringUtil;
import com.mkreader.web.output.BillOutputController;

public class GenerateBnoController extends MultiActionController implements
ISiteConstant, ICodeConstant {

	private GeneralDAO generalDAO;
	
	public void setGeneralDAO(GeneralDAO generalDAO) {
	
			this.generalDAO = generalDAO;
	}
	
	/**
	 * 배달번호 생성 초기화면
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView retrieveBnoView(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		try{

			List agencyList = generalDAO.queryForList("etc.generateBno.getAgencyList");
			
			mav.addObject("agencyList" , agencyList);
			mav.addObject("now_menu", MENU_CODE_ETC);
			mav.setViewName("etc/generateBno");
			return mav;
		}catch(Exception e){
			e.printStackTrace();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}
		
	}
	
	
	

	/**
	 * 배달번호 생성 실행
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView generateBno(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		generalDAO.getSqlMapClient().startTransaction();
		generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
		
		try{

			
			HashMap dbparam = new HashMap();
			
			dbparam.put("yymm", param.getString("yymm"));
			
			String boSeq[] = new String[param.getInt("boSeqSize",0)];
			
			for(int i=0 ; i < boSeq.length ; i++){			
				boSeq[i] = param.getString("boSeq"+i);
				
				if(boSeq[i] !=null && !"".equals(boSeq[i])){	
					String boseq = boSeq[i];
					dbparam.put("gu", "구 ");  // 구
					dbparam.put("apt", "아파트");  // 아파트
					dbparam.put("boseq", boseq);
					// 대상 조회
					List getAddrList = generalDAO.getSqlMapClient().queryForList("etc.generateBno.getAddrList" , dbparam);
					for(int j=0 ; j < getAddrList.size() ; j++){

						Map list = (Map)getAddrList.get(j);
						System.out.println("지국:"+boseq);
						dbparam.put("boseq", boseq);
						dbparam.put("gu", "구 ");  
						dbparam.put("apt", "아파트"); 
						dbparam.put("readno", list.get("READNO"));
						dbparam.put("newscd", list.get("NEWSCD"));
						dbparam.put("seq", list.get("SEQ"));

						// 전체주소 조회
						dbparam.put("addr", list.get("ADDR"));
						List getBno = generalDAO.getSqlMapClient().queryForList("etc.generateBno.retrieveGnoBno" , dbparam);
						System.out.println("ADDR:"+list.get("ADDR"));
						System.out.println("getBno.size():"+getBno.size());
						if(getBno.size()>0 && null != list.get("ADDR") && !"".equals(list.get("ADDR"))){
							Map bnoData = (Map)getBno.get(0);
							dbparam.put("gno", bnoData.get("GNO"));
							dbparam.put("bno", bnoData.get("BNO"));
							generalDAO.getSqlMapClient().update("etc.generateBno.updateBno", dbparam);
							System.out.println("GNO:"+bnoData.get("GNO"));
							System.out.println("BNO:"+bnoData.get("BNO"));
						}else{
							// 주소1 조회
							dbparam.put("addr", list.get("ADDR1"));
							getBno = generalDAO.getSqlMapClient().queryForList("etc.generateBno.retrieveGnoBno" , dbparam);
							System.out.println("ADDR1:"+list.get("ADDR1"));
							System.out.println("getBno.size():"+getBno.size());
							if(getBno.size()>0 && null != list.get("ADDR1") && !"".equals(list.get("ADDR1"))){
								Map bnoData = (Map)getBno.get(0);
								dbparam.put("gno", bnoData.get("GNO"));
								dbparam.put("bno", bnoData.get("BNO"));
								generalDAO.getSqlMapClient().update("etc.generateBno.updateBno", dbparam);
								System.out.println("GNO:"+bnoData.get("GNO"));
								System.out.println("BNO:"+bnoData.get("BNO"));
							}else{
								// 주소2 조회
								dbparam.put("addr", list.get("ADDR2"));
								getBno = generalDAO.getSqlMapClient().queryForList("etc.generateBno.retrieveGnoBno" , dbparam);
								System.out.println("ADDR2:"+list.get("ADDR2"));
								System.out.println("getBno.size():"+getBno.size());
								if(getBno.size()>0 && null != list.get("ADDR2") && !"".equals(list.get("ADDR2"))){
									Map bnoData = (Map)getBno.get(0);
									dbparam.put("gno", bnoData.get("GNO"));
									dbparam.put("bno", bnoData.get("BNO"));
									generalDAO.getSqlMapClient().update("etc.generateBno.updateBno", dbparam);
									System.out.println("GNO:"+bnoData.get("GNO"));
									System.out.println("BNO:"+bnoData.get("BNO"));
								}else{
									// 주소3 조회
									dbparam.put("addr", list.get("ADDR3"));
									getBno = generalDAO.getSqlMapClient().queryForList("etc.generateBno.retrieveGnoBno" , dbparam);
									System.out.println("ADDR3:"+list.get("ADDR3"));
									System.out.println("getBno.size():"+getBno.size());
									if(getBno.size()>0 && null != list.get("ADDR3") && !"".equals(list.get("ADDR3"))){
										Map bnoData = (Map)getBno.get(0);
										dbparam.put("gno", bnoData.get("GNO"));
										dbparam.put("bno", bnoData.get("BNO"));
										generalDAO.getSqlMapClient().update("etc.generateBno.updateBno", dbparam);
										System.out.println("GNO:"+bnoData.get("GNO"));
										System.out.println("BNO:"+bnoData.get("BNO"));
									}else{
										// 주소4 조회
										dbparam.put("addr", list.get("ADDR4"));
										dbparam.put("prevGno",  list.get("GNO"));    // 주소4의경우 기존구역만 조회
										getBno = generalDAO.getSqlMapClient().queryForList("etc.generateBno.retrieveGnoBno" , dbparam);
										System.out.println("ADDR4:"+list.get("ADDR4"));
										System.out.println("getBno.size():"+getBno.size());
										if(getBno.size()>0 && null != list.get("ADDR4") && !"".equals(list.get("ADDR4"))){
											Map bnoData = (Map)getBno.get(0);
											dbparam.put("gno", bnoData.get("GNO"));
											dbparam.put("bno", bnoData.get("BNO"));
											generalDAO.getSqlMapClient().update("etc.generateBno.updateBno", dbparam);
											System.out.println("GNO:"+bnoData.get("GNO"));
											System.out.println("BNO:"+bnoData.get("BNO"));
										}
									}									
								}
							}
						}
						
						dbparam = new HashMap(); 

					}
				}
			}
			generalDAO.getSqlMapClient().getCurrentConnection().commit();
			mav.addObject("message", "완료되었습니다.");
			mav.addObject("returnURL", "/etc/generateBno/retrieveBnoView.do");
			mav.setViewName("common/message");
			return mav;
	
		}catch(Exception e){
			e.printStackTrace();
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}finally{
			generalDAO.getSqlMapClient().endTransaction();
		}
		
	}
	
}