package com.mkreader.web.management;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.mkreader.dao.GeneralDAO;
import com.mkreader.security.ICodeConstant;
import com.mkreader.security.ISiteConstant;

public class AddressController extends MultiActionController implements
	ISiteConstant, ICodeConstant {
	
	public static Logger logger = Logger.getRootLogger();
	private GeneralDAO generalDAO;

	public void setGeneralDAO(GeneralDAO generalDAO) {
			this.generalDAO = generalDAO;
	}
	
	
	

}
