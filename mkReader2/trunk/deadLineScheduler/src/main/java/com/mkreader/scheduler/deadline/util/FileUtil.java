package com.mkreader.scheduler.deadline.util;

import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.io.Writer;

import org.apache.commons.lang.StringUtils;



public class FileUtil {
	

	
	public static String saveTxtFile(String uploadPath, String fileName, String data, String encodingType) throws Exception {
		
		if ( StringUtils.isEmpty(data) ) {
			return null;
		}
		
		if ( StringUtils.isNotEmpty(fileName)) {
			
			// uploadPath 디렉토리가 없다면 생성한다.
			File dir = new File(uploadPath);
			if ( !dir.isDirectory()) {
				dir.mkdirs();
			}
	
			// 파일 객체
			//File f = new File(uploadPath + "/" + fileName);
			//FileWriter fw = null;
			Writer writer = null;
			
			try {
				writer = new OutputStreamWriter(new FileOutputStream(uploadPath + "/" + fileName), encodingType);
				//fw = new FileWriter(f);
				writer.write(new String(data.getBytes(), encodingType));		// 파일에 저장
				//fw.write(new String(data.getBytes()));
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				if ( writer != null ) {
					try {
						writer.close();
					}
					catch ( Exception e) {
						e.printStackTrace();
					}
				}
			}
		}
		
		return fileName;
	}
	
	
}

