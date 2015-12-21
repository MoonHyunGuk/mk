package com.mkreader.jidaemailing;

import java.io.File;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.concurrent.CopyOnWriteArrayList;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

import sun.misc.BASE64Encoder;

import com.mkreader.dao.GeneralDAO;
import com.mkreader.security.ICodeConstant;
import com.mkreader.security.ISiteConstant;
import com.mkreader.util.ConnectionUtil;
import com.mkreader.util.DateUtil;
import com.mkreader.util.MailUtil;
import com.mkreader.util.StringUtil;

public class JidaeMailingBatch extends Thread implements ISiteConstant, ICodeConstant,ApplicationContextAware{

	
	public static boolean isRun = false;
	private static CopyOnWriteArrayList<Map<String, String>> jidaeMailingList = new CopyOnWriteArrayList<Map<String, String>>();
	private static ApplicationContext applicationContext;

	@Override
	public void setApplicationContext(ApplicationContext context) throws BeansException {
	  applicationContext = context;
	}

	public static ApplicationContext getApplicationContext() {
	  return applicationContext;
	}
	
	public static void setJidaeMailingList(List<HashMap<String,String>> list){
		jidaeMailingList.addAllAbsent(list);
	}
	
	public static CopyOnWriteArrayList<Map<String, String>> getJidaeMailingList(){
		return jidaeMailingList;
	}

	@Override
	public void run() {
		GeneralDAO generalDAO = (GeneralDAO)applicationContext.getBean("generalDAO");
		try {
			Map<String,String> map = null;
			while(jidaeMailingList.size() > 0){
				isRun = true;
				map = jidaeMailingList.get(0);
				if(sendMail(map,generalDAO))jidaeMailingList.remove(map);
				if(jidaeMailingList.size() > 0)Thread.sleep(20000);
			}
			isRun = false;
		} catch (Exception e) {
			e.printStackTrace();
			isRun = false;
		}
	}
	
	private boolean sendMail(Map<String,String> map,GeneralDAO generalDAO) throws Exception{
		try {
			String fileName = PATH_PHYSICAL_HOME + "/common/jidae_template.html";
			if(map.get("BOSEQCODE").startsWith("5")) fileName = PATH_PHYSICAL_HOME + "/common/jidae_template_direct.html";
			if(map.get("BOSEQCODE").startsWith("52")) fileName = PATH_PHYSICAL_HOME + "/common/jidae_template_gapan.html";
			
			String template = FileUtils.readFileToString(new File(fileName), "UTF-8");
			String content = null;

			String title = map.get("BOSEQNM") + "지국["+map.get("BOSEQCODE")+"] 지대 납부금 통지서(" + map.get("YEAR") + "년 " + map.get("MONTH") + "월분)";
			//String tempFile = PATH_PHYSICAL_HOME + "/temp/" + title + ".html";
			String tempFile = title + ".html";
			
			//String defaultTitle = "[매일경제]\f%s지국\b" + map.get("YEAR") + "년\b" + map.get("MONTH") + "월\b지대통보서를\b%s로\b발송했습니다";
			//String messageTitle = null;
			
			HashMap<String,String> dbparam = new HashMap<String,String>();
			
			if(!MailUtil.isEmail(map.get("JIKUK_EMAIL")))return false;
			if(map.get("TMP1") != null && !map.get("TMP1").equals("")) map.put("TMP1NM","소외계층,NIE");
			if(map.get("TMP2") != null && !map.get("TMP2").equals("")) map.put("TMP2NM","우편요금");
			if(map.get("TMP3") != null && !map.get("TMP3").equals("")) map.put("TMP3NM","사원구독");
			if(map.get("TMP4") != null && !map.get("TMP4").equals("")) map.put("TMP4NM","기타");
			if(map.get("TMP5") != null && !map.get("TMP5").equals("")) map.put("TMP5NM","");
			if(map.get("TMP6") != null && !map.get("TMP6").equals("")) map.put("TMP6NM","판매수수료(VAT)");
			if(map.get("TMP7") != null && !map.get("TMP7").equals("")) map.put("TMP7NM","보증금대체");
			
			if(map.get("JIDAE_BANK1") != null && !map.get("JIDAE_BANK1").equals("")) map.put("JIDAE_BANK1NM","농협");
			if(map.get("JIDAE_BANK2") != null && !map.get("JIDAE_BANK2").equals("")) map.put("JIDAE_BANK2NM","우리은행");
			if(map.get("JIDAE_BANK3") != null && !map.get("JIDAE_BANK3").equals("")) map.put("JIDAE_BANK3NM","국민은행");
			if(map.get("JIDAE_BANK4") != null && !map.get("JIDAE_BANK4").equals("")) map.put("JIDAE_BANK4NM","우체국");
			
			
			content = replaceField(template,"${boseqnm}",map.get("BOSEQNM"));
			
			/*
			 *content.부산지사에서는 기타항목 표시없음 향후 수정될 부분임.2015.1.05 이경철 
			 */
			if(map.get("BOSEQCODE").startsWith("76")){
				content = replaceField(content,"${tmp4nm}","");
				content = replaceField(content,"${tmp4}","");
				
				if(!StringUtil.notNull(map.get("TMP4")).equals("")){
					map.put("SUBTOTAL", String.valueOf(Integer.parseInt(map.get("SUBTOTAL")) - Integer.parseInt(map.get("TMP4"))));
					map.put("J_REALAMT", String.valueOf(Integer.parseInt(map.get("J_REALAMT")) + Integer.parseInt(map.get("TMP4"))));
					map.put("J_OVERDATE", String.valueOf(Integer.parseInt(map.get("J_OVERDATE")) + Integer.parseInt(map.get("TMP4"))));
					map.put("J_DUEDATE", String.valueOf(Integer.parseInt(map.get("J_DUEDATE")) + Integer.parseInt(map.get("TMP4"))));
					map.put("J_PAYAMT", String.valueOf(Integer.parseInt(map.get("J_PAYAMT")) + Integer.parseInt(map.get("TMP4"))));
				}
			}
			
			
			content = replaceField(content,"${boseqcode}",map.get("BOSEQCODE"));
			content = replaceField(content,"${year}",(map.get("YYMM")).substring(0,4));
			content = replaceField(content,"${month}",(map.get("YYMM")).substring(4,6));
			content = replaceField(content,"${type}",map.get("TYPE"));
			content = replaceField(content,"${agencynm}",map.get("AGENCYNM"));
			content = replaceField(content,"${misu}",numberFormat(map.get("MISU")));
			content = replaceField(content,"${custom}",numberFormat(map.get("CUSTOM")));
			content = replaceField(content,"${busugrant}",numberFormat(map.get("BUSUGRANT")));
			content = replaceField(content,"${tmp1nm}",map.get("TMP1NM"));
			content = replaceField(content,"${tmp1}",numberFormat(map.get("TMP1")));
			content = replaceField(content,"${stugrant}",numberFormat(map.get("STUGRANT")));
			content = replaceField(content,"${tmp2nm}",map.get("TMP2NM"));
			content = replaceField(content,"${tmp2}",numberFormat(map.get("TMP2")));
			content = replaceField(content,"${etcgrant}",numberFormat(map.get("ETCGRANT")));
			content = replaceField(content,"${tmp3nm}",map.get("TMP3NM"));
			content = replaceField(content,"${tmp3}",numberFormat(map.get("TMP3")));
			content = replaceField(content,"${card}",numberFormat(map.get("CARD")));
			content = replaceField(content,"${tmp4nm}",map.get("TMP4NM"));
			content = replaceField(content,"${tmp4}",numberFormat(map.get("TMP4")));
			
			content = replaceField(content,"${edu}",numberFormat(map.get("EDU")));
			content = replaceField(content,"${tmp5nm}",map.get("TMP5NM"));
			content = replaceField(content,"${tmp5}",numberFormat(map.get("TMP5")));
			content = replaceField(content,"${autobill}",numberFormat(map.get("AUTOBILL")));
			content = replaceField(content,"${tmp6nm}",map.get("TMP6NM"));
			content = replaceField(content,"${tmp6}",numberFormat(map.get("TMP6")));
			content = replaceField(content,"${stu}",numberFormat(map.get("STU")));
			content = replaceField(content,"${subtotal}",numberFormat(map.get("SUBTOTAL")));
			content = replaceField(content,"${j_realamt}",numberFormat(map.get("J_REALAMT")));
			content = replaceField(content,"${j_overdate}",numberFormat(map.get("J_OVERDATE")));
			content = replaceField(content,"${j_okgrant1}",numberFormat(map.get("J_OKGRANT1")));
			content = replaceField(content,"${j_okgrant2}",numberFormat(map.get("J_OKGRANT2")));
			content = replaceField(content,"${j_duedate}",numberFormat(map.get("J_DUEDATE")));
			content = replaceField(content,"${j_payamt}",numberFormat(map.get("J_PAYAMT")));
			content = replaceField(content,"${d_misu}",numberFormat(map.get("D_MISU")));
			content = replaceField(content,"${d_happen}",numberFormat(map.get("D_HAPPEN")));
			content = replaceField(content,"${d_minus}",numberFormat(map.get("D_MINUS")));
			content = replaceField(content,"${d_balance}",numberFormat(map.get("D_BALANCE")));
			content = replaceField(content,"${jidae_bank1nm}",map.get("JIDAE_BANK1NM"));
			content = replaceField(content,"${jidae_bank1}",map.get("JIDAE_BANK1"));
			content = replaceField(content,"${jidae_bank2nm}",map.get("JIDAE_BANK2NM"));
			content = replaceField(content,"${jidae_bank2}",map.get("JIDAE_BANK2"));
			content = replaceField(content,"${jidae_bank3nm}",map.get("JIDAE_BANK3NM"));
			content = replaceField(content,"${jidae_bank3}",map.get("JIDAE_BANK3"));
			content = replaceField(content,"${jidae_bank4nm}",map.get("JIDAE_BANK4NM"));
			content = replaceField(content,"${jidae_bank4}",map.get("JIDAE_BANK4"));
			
			content = replaceField(content,"${bank}",numberFormat(map.get("BANK")));
			content = replaceField(content,"${giro}",numberFormat(map.get("GIRO")));
			content = replaceField(content,"${economy}",numberFormat(map.get("ECONOMY")));
			content = replaceField(content,"${city}",numberFormat(map.get("CITY")));
			content = replaceField(content,"${total}",numberFormat(map.get("TOTAL")));
			
			content = replaceField(content,"${tmp7nm}",map.get("TMP7NM"));
			content = replaceField(content,"${tmp7}",numberFormat(map.get("TMP7")));
			
			String display = "";
			if(StringUtil.notNull(map.get("TMP7")).equals("")){
				display = "display:none;";
			}
			content = replaceField(content,"${display}",display);
			
			String month = map.get("MONTH");
			String preMonth = "";
			Calendar cal = Calendar.getInstance();
			cal.set(Calendar.MONTH,Integer.parseInt(month)-2);
			preMonth = DateUtil.getDateFormat(cal.getTime(),"MM");
			
			content = replaceField(content,"${preMonth}",preMonth);
			
			//FileUtils.writeStringToFile(new File(tempFile), content,"utf-8");
//			if(MailUtil.sendMail(map.get("JIKUK_EMAIL"), title, content, tempFile)){
			if(remoteMailSend(map.get("JIKUK_EMAIL"), title, content, tempFile,map.get("YYMM"))){
				dbparam.put("content",content);
				dbparam.put("boseq",map.get("BOSEQCODE"));
				dbparam.put("yymm",map.get("YYMM"));
				dbparam.put("send_addr", map.get("JIKUK_EMAIL"));
				dbparam.put("sender",map.get("USERID"));
				dbparam.put("send_type","M");
				generalDAO.insert("management.jidae.insertJidaeMailData", dbparam);
				//messageTitle = String.format(defaultTitle, map.get("BOSEQNM"),map.get("JIKUK_EMAIL"));
				
				//List<NameValuePair> params = new ArrayList<NameValuePair>();
				//params.add(new BasicNameValuePair("tel",map.get("NAME2") + "," + map.get("JIKUK_HANDY") + "," + messageTitle + ",0220002000"));
				//ConnectionUtil.sendRequest(getApplicationContext().getMessage("sms.send.url",null,Locale.getDefault()),params,"EUC-KR");
//				FileUtils.forceDeleteOnExit(new File(tempFile));
				return true;
			}
			return false;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
	
	private String replaceField(String content,String str1,String str2){
		if(str2 == null){
			return StringUtils.replace(content, str1,"");
		}else{
			return StringUtils.replace(content, str1,str2);
		}
	}
	
	private String numberFormat(String num){
		if(num == null || num.equals(""))return "";
		int i = Integer.parseInt(num);
		NumberFormat formatter = NumberFormat.getNumberInstance();
		return formatter.format(i);
	}

	
	private boolean remoteMailSend(String to,String title,String content,String fileName,String yymm){
		try {
			List<NameValuePair> params = new ArrayList<NameValuePair>();
			params.add(new BasicNameValuePair("to",to));
			params.add(new BasicNameValuePair("title",title));
			params.add(new BasicNameValuePair("content",content));
			params.add(new BasicNameValuePair("fileName", fileName));
			params.add(new BasicNameValuePair("yymm", yymm));
			String message = ConnectionUtil.sendRequest("http://218.144.58.97/mailSend/sendMail",params,"UTF-8");
			if(message.equals("SUCCESS"))return true;
			return false;
		} catch (Exception e) {
			return false;
		}
	}
}
