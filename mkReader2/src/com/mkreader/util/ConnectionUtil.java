package com.mkreader.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLConnection;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;

public class ConnectionUtil {

	public static String sendRequest(String url,List<NameValuePair> params,String encoding){
		String result = "";
		HttpClient httpClient = new DefaultHttpClient();
		HttpPost httpPost = new HttpPost(url);
		// 파라미터 속성 설정
		
		try {
		    httpPost.setEntity(new UrlEncodedFormEntity(params,encoding));
		} catch (UnsupportedEncodingException e) {
		    e.printStackTrace();
		}
		 
		try {
		    HttpResponse response = httpClient.execute(httpPost);
		    HttpEntity respEntity = response.getEntity();
		 
		    if (respEntity != null) {
		        // 결과값 스트링으로 변환
		    	result =  EntityUtils.toString(respEntity,encoding);
		    }
		} catch (ClientProtocolException e) {
		    e.printStackTrace();
		} catch (IOException e) {
		    e.printStackTrace();
		}
		return StringUtils.trim(result);
	}
	
	public static String sendRequest(String url,String param,String encoding){
		return sendRequest(url,param,null,encoding);
	}
	
	public static String sendRequest(String url,String param,String contentType,String encoding){
		String result = "";
		HttpClient httpClient = new DefaultHttpClient();
		HttpPost httpPost = new HttpPost(url);
		if(contentType == null)contentType = "text/html";
		httpPost.setHeader("Content-Type",contentType);
		// 파라미터 속성 설정
		
		httpPost.setEntity(new StringEntity(param,encoding));
		 
		try {
			HttpResponse response = httpClient.execute(httpPost);
			HttpEntity respEntity = response.getEntity();
			
			if (respEntity != null) {
				result =  EntityUtils.toString(respEntity,encoding);
			}
		} catch (ClientProtocolException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return StringUtils.trim(result);
	}
	
	public static String shortener(String url,String param) {
		StringBuffer buffer = new StringBuffer();
		URLConnection conn = null;
		OutputStreamWriter wr = null;
		BufferedReader rd = null;
		try {
			conn = new URL(url).openConnection();
			conn.setDoOutput(true);
			conn.setRequestProperty("Content-Type", "application/json");
			wr = new OutputStreamWriter(conn.getOutputStream());
			if(param != null){
				wr.write(param);
				wr.flush();
			}

			rd = new BufferedReader(new InputStreamReader(conn.getInputStream(),"UTF-8"));
			String line = null;
			while ((line = rd.readLine()) != null) {
				buffer.append(line);
			}
			wr.close();
			rd.close();
		}catch (Exception e) {
			e.printStackTrace();
		}finally{
			try {
				wr.close();
				rd.close();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
			
		}
		return buffer.toString();
	}
}
