package com.mkreader.util;

import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;

import kr.reflexion.espresso.servlet.util.DefaultFileRenameHandler;
import kr.reflexion.espresso.servlet.util.FileRenameHandler;
import kr.reflexion.espresso.servlet.util.HttpServletParam;
import kr.reflexion.espresso.util.Param;

import org.apache.commons.lang.StringUtils;
import org.springframework.core.io.Resource;
import org.springframework.web.context.support.ServletContextResource;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

public class MultipartHttpServletParam extends HttpServletParam implements
		Param {

	private MultipartHttpServletRequest multipartRequest = null;

	private Resource resourcePath = null;

	private FileRenameHandler fileRenameHandler = new DefaultFileRenameHandler();

	public MultipartHttpServletParam(
			MultipartHttpServletRequest multipartRequest) {
		super(multipartRequest);
		this.multipartRequest = multipartRequest;
	}

	public MultipartHttpServletParam(HttpServletRequest request)
			throws ServletException {
		super(request);
		if (!(request instanceof MultipartHttpServletRequest)) {
			String message = "MultipartHttpServletRequest is required; "
					+ "please make sure that you post using multipart/form-data "
					+ "and you are using the approperiate MultipartResolver";
			throw new RuntimeException(message);
		}
		this.multipartRequest = (MultipartHttpServletRequest) request;
	}

	public void setResourcePath(Resource resourcePath) {
		this.resourcePath = resourcePath;
	}

	public void setResourcePath(String resourcePath) {
		// TODO not sure if this'll work
		this.resourcePath = new ServletContextResource(multipartRequest
				.getSession().getServletContext(), resourcePath);
	}

	public void setFileRenameHandler(FileRenameHandler fileRenameHandler) {
		this.fileRenameHandler = fileRenameHandler;
	}

	public MultipartFile getMultipartFile(String name) {
		return multipartRequest.getFile(name);
	}

	public String saveMultipartFile(String name) {
		if (resourcePath == null) {
			throw new RuntimeException("You must specify a resourcePath");
		}

		MultipartFile multipartFile = multipartRequest.getFile(name);
		if (multipartFile != null && multipartFile.getSize() > 0) {
			String originalFilename = multipartFile.getOriginalFilename();

			try {
				originalFilename = URLEncoder.encode(originalFilename, "UTF-8");
				originalFilename = StringUtils.replace(originalFilename, "%","");
				originalFilename = StringUtils.replace(originalFilename, "+","");

				String uploadDirectory = resourcePath.getFile().getPath();
				(new File(uploadDirectory)).mkdirs();

				File res = resourcePath.getFile();
				if (res.isDirectory() && res.canWrite()) {
					String serverFilename = uploadDirectory
							+ File.separatorChar + originalFilename;
					File f = new File(serverFilename);

					// apply file rename handler if available
					if (fileRenameHandler != null) {
						f = fileRenameHandler.rename(f);
					}

					multipartFile.transferTo(f);

					// returns the newly created filename
					return f.getName();
				}
			} catch (IOException e) {
				// TODO
				// shouldn't just print stack trace here...
				e.printStackTrace();
			}
		}

		// no file
		return null;
	}
}
