package com.mkreader.util;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.util.HashMap;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.springframework.web.context.support.ServletContextResource;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;


public class FileUtil extends MultiActionController {
	
	private ServletContext servletContext;
	
	public FileUtil(ServletContext servletContext) {
		this.servletContext = servletContext; 
	}

	/**
	 * 실제 폴더에 이미지를 저장 시키는 함수
	 * 
	 * @param multipartFile
	 * @param uploadPath
	 * @return
	 * @throws IOException
	 */
	public String saveFile(MultipartFile multipartFile, String uploadPath)
			throws IOException {

		if (multipartFile != null && multipartFile.getSize() > 0) {
			ServletContextResource resource = new ServletContextResource(
					this.servletContext, uploadPath);

			String filename = multipartFile.getOriginalFilename();
			int dotIndex = filename.lastIndexOf('.');
			String filenamePrefix = null;
			String filenameExt = null;

			if (dotIndex >= 0) {
				filenamePrefix = filename.substring(0, dotIndex);
				filenameExt = filename.substring(dotIndex);
			} else {
				filenamePrefix = filename;
				filenameExt = "";
			}

			filename = !StringUtils.isAsciiPrintable(filename) ? System
					.currentTimeMillis()
					+ filenameExt : filename;
			String serverFilename = resource.getFile().toString()
					+ File.separatorChar + filename;

			File file = new File(serverFilename);
			if (file.exists()) { 
				String newFilename = null;
				int numIndex = 1;
				do {
					newFilename = filenamePrefix + "_" + (numIndex++)
							+ filenameExt;
					serverFilename = resource.getFile().toString()
							+ File.separatorChar + newFilename;
					file = new File(serverFilename);
				} while (file.exists());

				multipartFile.transferTo(file);
				logger.debug("Uploading file to: " + file);
				return newFilename;
			} else {
				multipartFile.transferTo(file);
				logger.debug("Uploading file to: " + file);
				return filename;
			}
		} else {
			return null;
		}
	}
	
	
	/**
	 * 실제 폴더에 이미지를 저장 시키는 함수
	 * 
	 * @param multipartFile
	 * @param uploadPath
	 * @return
	 * @throws IOException
	 */
	public String saveFile2(MultipartFile multipartFile, String uploadPath)
			throws IOException {

		if (multipartFile != null && multipartFile.getSize() > 0) {
			ServletContextResource resource = new ServletContextResource(
					this.servletContext, uploadPath);

			String filename = multipartFile.getOriginalFilename();
			int dotIndex = filename.lastIndexOf('.');
			String filenamePrefix = null;
			String filenameExt = null;

			if (dotIndex >= 0) {
				filenamePrefix = filename.substring(0, dotIndex);
				filenameExt = filename.substring(dotIndex);
			} else {
				filenamePrefix = filename;
				filenameExt = "";
			}

			String systemTime = System.currentTimeMillis() + "";
			filename = systemTime + filenameExt;
			String serverFilename = resource.getFile().toString() + File.separatorChar + filename;

			File file = new File(serverFilename);
			if (file.exists()) {
				String newFilename = null;
				int numIndex = 1;
				do {
					newFilename = systemTime + "_" + (numIndex++)
							+ filenameExt;
					serverFilename = resource.getFile().toString()
							+ File.separatorChar + newFilename;
					file = new File(serverFilename);
				} while (file.exists());

				multipartFile.transferTo(file);
				logger.debug("Uploading new File to: " + file);
				return newFilename;
			} else {
				multipartFile.transferTo(file);
				logger.debug("Uploading File to: " + file);
				return filename;
			}
		} else {
			return null;
		}
	}
	
	public String saveOriginalFile(MultipartFile multipartFile, String uploadPath)
	throws IOException {

	if (multipartFile != null && multipartFile.getSize() > 0) {
		ServletContextResource resource = new ServletContextResource(
				this.servletContext, uploadPath);
	
		String filename = multipartFile.getOriginalFilename();
		
		int dotIndex = filename.lastIndexOf('.');
		String filenamePrefix = null;
		String filenameExt = null;
	
		if (dotIndex >= 0) {
			filenamePrefix = filename.substring(0, dotIndex);
			filenameExt = filename.substring(dotIndex);
		} else {
			filenamePrefix = filename;
			filenameExt = "";
		}
	
//		filename = !StringUtils.isAsciiPrintable(filename) ? System
//				.currentTimeMillis()
//				+ filenameExt : filename;
		
		
		String serverFilename = resource.getFile().toString()
				+ File.separatorChar + filename;

		File file = new File(serverFilename);
		if (file.exists()) {
			String newFilename = null;
			int numIndex = 1;
			do {
				newFilename = filenamePrefix + "_" + (numIndex++)
						+ filenameExt;
				serverFilename = resource.getFile().toString()
						+ File.separatorChar + newFilename;
				file = new File(new String(serverFilename.getBytes("8859_1"),"utf-8"));
			} while (file.exists());
	
			multipartFile.transferTo(file);
			logger.debug("Uploading file to: " + file);
			return newFilename;
		} else {
			multipartFile.transferTo(file);
			logger.debug("Uploading file to: " + file);
			return filename;
		}
	} else {
		return null;
	}
}

	/**
	 * 파일 업로드 유틸<br>
	 * HttpServletRequest 와 업로드 경로, 저장할 파일명(request 의 파라미터 이름)
	 * 
	 * @param request
	 *            데이터 스트림이 포함된 request
	 * @param uploadPath
	 *            실제 파일이 업로드될 Application 내의 경로
	 * @param fileName
	 *            request 로 넘어온 스트림에서 추출할 parameter 이름
	 * @return HashMap
	 *         <ul>
	 *         <li>fullPath - Application 내에서 완전한 경로</li>
	 *         <li>uploadPath - Application 내의 업로드 경로</li>
	 *         <li>fileName - request 의 파일 이름</li>
	 *         <li>fileSize - filesize Long 형</li>
	 *         <li>storageFileName - 실제 저장된 파일이름</li>
	 *         </ul>
	 * @throws ServletException
	 */
	public HashMap uploadFile(HttpServletRequest request, String uploadPath,
			String fileName) throws ServletException {

		// request 를 MultipartHttpServletParam으로 받아 Stream 을 추출할 수 있게 바꾼다.
		MultipartHttpServletParam param = new MultipartHttpServletParam(request);
		// 스트림의 데이터가 파일로 기록될 경로를 지정해준다.
		param.setResourcePath(uploadPath);

		// request 로 부터 파일을 추출한다.
		MultipartFile addFile = param.getMultipartFile(fileName);
		// 파일을 저장하고 스토리지에 기록된 실제 파일명을 리턴받는다.
		String storageFileName = param.saveMultipartFile(fileName);

		HashMap result = new HashMap();
		String fullPath = uploadPath + "/" + storageFileName;

		// 업로드한 파일이 있으면
		if (addFile != null && addFile.getSize() > 0) {
			result.put("fullPath", fullPath);
			result.put("uploadPath", uploadPath);
			result.put("fileName", addFile.getOriginalFilename());
			result.put("fileSize", new Long(addFile.getSize()));
			result.put("storageFileName", storageFileName);

			return result;
		} else {
			return null;
		}
	}
	
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
	
	
	/**
	 * 실제 폴더에 파일을 저장 시키는 함수
	 * 
	 * @param multipartFile
	 * @param uploadAbsolutePath
	 * @return
	 * @throws IOException
	 */
	public String saveUploadFile(MultipartFile multipartFile, String physicalHomePath, String uploadAbsolutePath)
			throws IOException {

		if (multipartFile != null && multipartFile.getSize() > 0) {
			
			// uploadPath 디렉토리가 없다면 생성한다.
			File dir = new File(physicalHomePath + uploadAbsolutePath);
			if ( !dir.isDirectory()) {
				dir.mkdirs();
			}
			
			ServletContextResource resource = new ServletContextResource(
					this.servletContext, uploadAbsolutePath);

			String filename = multipartFile.getOriginalFilename();
			int dotIndex = filename.lastIndexOf('.');
			String filenamePrefix = null;
			String filenameExt = null;

			if (dotIndex >= 0) {
				filenamePrefix = filename.substring(0, dotIndex);
				filenameExt = filename.substring(dotIndex);
			} else {
				filenamePrefix = filename;
				filenameExt = "";
			}

			//String systemTime = System.currentTimeMillis() + "";
			//filename = systemTime + filenameExt;
			filename = filenamePrefix + filenameExt;
			String serverFilename = resource.getFile().toString() + File.separatorChar + filename;

			File file = new File(serverFilename);
			
			// 파일이 중복되면 기존화일 삭제후 다시 업로드
			if (file.exists()) {
				file.delete();
			}

			multipartFile.transferTo(file);
			logger.debug("Uploading File to: " + file);
			return filename;
		}
		
		return null;
	}
}

