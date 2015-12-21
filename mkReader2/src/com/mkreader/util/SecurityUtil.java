package com.mkreader.util;

import java.security.MessageDigest;
import java.util.Locale;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

public class SecurityUtil implements ApplicationContextAware{
	
	private static ApplicationContext applicationContext;     

	public void setApplicationContext(ApplicationContext context) throws BeansException {
		applicationContext = context;
		KEY = applicationContext.getMessage("sms.security.key",null,Locale.getDefault());
		IV = applicationContext.getMessage("sms.security.iv",null,Locale.getDefault());
	}

	public static ApplicationContext getApplicationContext() {
	  return applicationContext;
	}
	
	public SecurityUtil(){}
	
	private static  String KEY = null;
	private static  String IV = null;
	private static final String transformation = "AES/CBC/PKCS5Padding";
	
	public static String encode(String str){
		try {
			SecretKeySpec keySpec = new SecretKeySpec(encodeMD5(KEY), "AES"); //AES-128
			IvParameterSpec ivSpec = new IvParameterSpec(encodeMD5(IV));
			Cipher cipher = Cipher.getInstance(transformation);
			cipher.init(Cipher.ENCRYPT_MODE, keySpec, ivSpec);
			byte[] decryptedValue = cipher.doFinal(str.getBytes());
			return new String(ByteUtils.toHexString(decryptedValue));
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	public static String decode(String encodedInput){
		try{
			byte[] encodedInputByte = ByteUtils.toBytesFromHexString(encodedInput);
			if (encodedInputByte == null || encodedInputByte.length <= 0)
				return "";
			SecretKeySpec keySpec = new SecretKeySpec(encodeMD5(KEY), "AES"); //AES-128
			IvParameterSpec ivSpec = new IvParameterSpec(encodeMD5(IV));
			Cipher cipher = Cipher.getInstance(transformation);
			cipher.init(Cipher.DECRYPT_MODE, keySpec, ivSpec);

			byte[] decryptedValue = cipher.doFinal(encodedInputByte);
			return new String(decryptedValue);
        }catch (Exception e){
        	e.printStackTrace();
        	return "";
        }
    }
	
	private static byte[] encodeMD5(String str){
		try {
			MessageDigest md = MessageDigest.getInstance("MD5");
			return md.digest(str.getBytes());
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	

	/**
	 *사용자가 입력한 비밀번호를 SHA1 알고리즘을 이용하여 암호화한 후 암호화된 문자열을 반환한다.
	 *Secure Hash Algorithm을 사용하므로 한번 암호화된 암호는 추후 복호화가 불가능 하다.
	 * @param passWord사용자 입력 비밀번호
	 * @return 암호화된 비밀번호 문자열
	 */
	public static String encryptPassword(String password) {
		try {
			byte[] txtByte = password.getBytes();
			MessageDigest md = MessageDigest.getInstance("SHA-1");
			md.update(txtByte);
			byte[] digest = md.digest();
			
			return ByteUtils.toHexString(digest);
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}


	
/*	private static byte[] hexToByte(String hex) {
	    if (hex == null || hex.length() == 0) { 
	        return null; 
	    } 

	    byte[] ba = new byte[hex.length() / 2]; 
	    for (int i = 0; i < ba.length; i++) { 
	        ba[i] = (byte) Integer.parseInt(hex.substring(2 * i, 2 * i + 2), 16); 
	    } 
	    return ba; 
	}*/

	// byte[] to hex 
/*	private static String byteToHex(byte[] ba) { 
	    if (ba == null || ba.length == 0) {
	        return null; 
	    } 

	    StringBuffer sb = new StringBuffer(ba.length * 2); 
	    String hexNumber; 
	    for (int x = 0; x < ba.length; x++) { 
	        hexNumber = "0" + Integer.toHexString(0xff & ba[x]); 

	        sb.append(hexNumber.substring(hexNumber.length() - 2)); 
	    }
	    return sb.toString(); 
	}*/
/*
	public static String bytesToHex(final byte[] bytes) {
		final StringBuffer s = new StringBuffer(bytes.length * 2);
		for (int i = 0; i < bytes.length; ++i) {
			s.append(Character.forDigit((bytes[i] >> 4) & 0xF, 16));
			s.append(Character.forDigit(bytes[i] & 0xF, 16));
		}
		return s.toString();
	}
*/
}
