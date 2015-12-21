package com.mkreader.util;

import java.util.Date;
import java.util.Locale;
import java.util.Properties;
import java.util.regex.Pattern;

import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.mail.Address;
import javax.mail.Message;
import javax.mail.Multipart;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.mail.internet.MimeUtility;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;


public class MailUtil implements ApplicationContextAware{
	
	private static ApplicationContext applicationContext;     

	public void setApplicationContext(ApplicationContext context) throws BeansException {
	  applicationContext = context;
	}

	public static ApplicationContext getApplicationContext() {
	  return applicationContext;
	}

	public static boolean sendMail(String to, String title,String content,String fileName) {
		try {
			String from = applicationContext.getMessage("mail.username",null,Locale.getDefault());
			String password = applicationContext.getMessage("mail.password",null,Locale.getDefault());
			String host = applicationContext.getMessage("mail.host",null,Locale.getDefault());
			
			MimeMessage msg = null;
			
			Properties props = System.getProperties();
			props.put("mail.smtp.host",host);
			props.put("mail.smtps.auth", "true");
			Session mailSession = Session.getDefaultInstance(props, null);
			msg = new MimeMessage(mailSession);
			
			int pos = from.indexOf("<");
			String senderName = "";
			if (pos != -1) {
				senderName = from.substring(0, pos);
				from = from.substring(pos);
				from = from.replaceAll("<|>", "");
			}
			msg.setFrom(new InternetAddress(from,senderName));
			String toAddr[] = StringUtils.split(to,",");
			Address address[] = new Address[toAddr.length];
			int index =0;
			for(String t:toAddr){
				pos = t.indexOf("<");
				String tName = "";
				if (pos != -1) {
					tName = t.substring(0, pos);
					t = t.substring(pos);
					t = t.replaceAll("<|>", "");
				}
				address[index] = new InternetAddress(t,tName);
				index++;
			}
			msg.setRecipients(Message.RecipientType.TO,address);
			msg.setSubject(MimeUtility.encodeText(title, "UTF-8","B"));
			msg.setHeader("Content-Transfer-Encoding", "base64");
			msg.setHeader("X-Mailer", "localhost");
			if(fileName != null){
				MimeBodyPart mbp1 = new MimeBodyPart();
				mbp1.setContent(content,"text/html;charset=utf-8");
				
				// create the second message part
				MimeBodyPart mbp2 = new MimeBodyPart();
				
				// attach the file to the message
				FileDataSource fds = new FileDataSource(fileName);
				mbp2.setDataHandler(new DataHandler(fds));
				mbp2.setFileName(MimeUtility.encodeText(fds.getName(), "UTF-8","B"));
				
				// create the Multipart and its parts to it
				Multipart mp = new MimeMultipart();
				mp.addBodyPart(mbp1);
				mp.addBodyPart(mbp2);
				
				// add the Multipart to the message
				msg.setContent(mp);
			}else{
				msg.setContent(content,"text/html;charset=utf-8");   //한글처리
			}
			msg.setSentDate(new Date());

			Transport transport = mailSession.getTransport("smtp");
	        transport.connect(host, from, password);
	        transport.sendMessage(msg, msg.getAllRecipients());
	        transport.close();  
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
	
	public static boolean isEmail(String email) { 
        if (email==null) return false; 
        boolean b = Pattern.matches( 
            "[\\w\\~\\-\\.]+@[\\w\\~\\-]+(\\.[\\w\\~\\-]+)+",  
            email.trim()); 
        return b; 
    } 


}
