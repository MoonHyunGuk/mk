package com.mkreader.scheduler.deadline.mapper;

import java.util.HashMap;
import java.util.List;

public interface DeadLineMapper {
	
	public List<HashMap<String,Object>> getAgencyList();
	public List<HashMap<String,Object>> getMonthCloseList(HashMap<String,String> map);
	public int update2YearMisuHist(HashMap<String,String> map);
	public int update2YearsMisu(HashMap<String,String> map);
	
	public String accountsReceivable(HashMap<String,String> map);
	public String statisticsInsert(HashMap<String,String> map);
	
	public List<HashMap<String,Object>> getGnoList(HashMap<String,String> map);
	
	public String deliverNumSort(HashMap<String,String> map);
	public int insertMonthClose(HashMap<String,String> map);
}