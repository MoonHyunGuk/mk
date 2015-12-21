package com.mkreader.scheduler.deadline.dao;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.mkreader.scheduler.deadline.mapper.DeadLineMapper;

@Repository
public class DeadLineDAOImpl implements DeadLineDAO {
	
	@Autowired
	private SqlSession sqlSession = null;

	@Override
	public List<HashMap<String, Object>> getAgencyList() {
		DeadLineMapper mapper = sqlSession.getMapper(DeadLineMapper.class);
		return mapper.getAgencyList();
	}

	@Override
	public List<HashMap<String, Object>> getMonthCloseList(HashMap<String, String> map) {
		DeadLineMapper mapper = sqlSession.getMapper(DeadLineMapper.class);
		return mapper.getMonthCloseList(map);
	}

	@Override
	public int update2YearMisuHist(HashMap<String, String> map) {
		DeadLineMapper mapper = sqlSession.getMapper(DeadLineMapper.class);
		return mapper.update2YearMisuHist(map);
	}

	@Override
	public int update2YearsMisu(HashMap<String, String> map) {
		DeadLineMapper mapper = sqlSession.getMapper(DeadLineMapper.class);
		return mapper.update2YearsMisu(map);
	}

	@Override
	public String accountsReceivable(HashMap<String, String> map) {
		DeadLineMapper mapper = sqlSession.getMapper(DeadLineMapper.class);
		return mapper.accountsReceivable(map);
	}

	@Override
	public String statisticsInsert(HashMap<String, String> map) {
		DeadLineMapper mapper = sqlSession.getMapper(DeadLineMapper.class);
		return mapper.statisticsInsert(map);
	}

	@Override
	public List<HashMap<String, Object>> getGnoList(HashMap<String, String> map) {
		DeadLineMapper mapper = sqlSession.getMapper(DeadLineMapper.class);
		return mapper.getGnoList(map);
	}

	@Override
	public String deliverNumSort(HashMap<String, String> map) {
		DeadLineMapper mapper = sqlSession.getMapper(DeadLineMapper.class);
		return mapper.deliverNumSort(map);
	}

	@Override
	public int insertMonthClose(HashMap<String, String> map) {
		DeadLineMapper mapper = sqlSession.getMapper(DeadLineMapper.class);
		return mapper.insertMonthClose(map);
	}
	
}
