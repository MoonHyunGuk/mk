package com.mkreader.scheduler.deadline;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.stereotype.Component;

import com.mkreader.scheduler.deadline.service.DeadLineService;

@Component
public class DeadLineApp {

	private static ApplicationContext applicationContext;
	
	@Autowired
	private DeadLineService deadLineService = null;

	public static void main(String[] args) {
		applicationContext = new ClassPathXmlApplicationContext(new String[] {"spring.xml", "spring/applicationContext-data.xml"});
		((DeadLineApp) applicationContext.getBean("deadLineApp")).job();
	}

	public void job() {
		deadLineService.deadLine();
	}
}