package com.mkreader.dao;





import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;
import org.springframework.orm.ibatis.SqlMapClientOperations;
import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;

import com.ibatis.common.util.PaginatedList;
import com.ibatis.sqlmap.client.event.RowHandler;
	
public class GeneralDAO extends SqlMapClientDaoSupport 
		implements SqlMapClientOperations {

		public int delete(String arg0) throws DataAccessException {
			return this.getSqlMapClientTemplate().delete(arg0);
		}
		
		public int delete(String arg0, Object arg1) throws DataAccessException {
			return this.getSqlMapClientTemplate().delete(arg0, arg1);
		}
		
		public void delete(String arg0, Object arg1, int arg2) throws DataAccessException {
			this.getSqlMapClientTemplate().delete(arg0, arg1, arg2);
		}

		public Object insert(String arg0) throws DataAccessException {
			return this.getSqlMapClientTemplate().insert(arg0);
		}
		
		public Object insert(String arg0, Object arg1) throws DataAccessException {
			return this.getSqlMapClientTemplate().insert(arg0, arg1);
		}
		
		public List queryForList(String arg0) throws DataAccessException {
			return this.getSqlMapClientTemplate().queryForList(arg0, null);
		}
		
		public List queryForList(String arg0, Object arg1) throws DataAccessException {
			return this.getSqlMapClientTemplate().queryForList(arg0, arg1);
		}
		
		public List queryForList(String arg0, int arg1, int arg2) throws DataAccessException {
			return this.getSqlMapClientTemplate().queryForList(arg0, arg1, arg2);
		}
		
		public List queryForList(String arg0, Object arg1, int arg2, int arg3) throws DataAccessException {
			return this.getSqlMapClientTemplate().queryForList(arg0, arg1, arg2, arg3);
		}
		
		public Map queryForMap(String arg0, Object arg1, String arg2) throws DataAccessException {
			return this.getSqlMapClientTemplate().queryForMap(arg0, arg1, arg2);
		}
		
		public Map queryForMap(String arg0, Object arg1, String arg2, String arg3) throws DataAccessException {
			return this.getSqlMapClientTemplate().queryForMap(arg0, arg1, arg2,	arg3);
		}
		
		public Object queryForObject(String arg0) throws DataAccessException {
			return this.getSqlMapClientTemplate().queryForObject(arg0);
		}
		
		public Object queryForObject(String arg0, Object arg1) throws DataAccessException {
			return this.getSqlMapClientTemplate().queryForObject(arg0, arg1);
		}
		
		public Object queryForObject(String arg0, Object arg1, Object arg2) throws DataAccessException {
			return this.getSqlMapClientTemplate().queryForObject(arg0, arg1, arg2);
		}
		
		public PaginatedList queryForPaginatedList(String arg0, int arg1) throws DataAccessException {
			return this.getSqlMapClientTemplate().queryForPaginatedList(arg0, arg1);
		}
		
		public PaginatedList queryForPaginatedList(String arg0, Object arg1, int arg2) throws DataAccessException {
			return this.getSqlMapClientTemplate().queryForPaginatedList(arg0, arg1, arg2);
		}
		
		public void queryWithRowHandler(String arg0, RowHandler arg1) throws DataAccessException {
			this.getSqlMapClientTemplate().queryWithRowHandler(arg0, arg1);
		}
		
		public void queryWithRowHandler(String arg0, Object arg1, RowHandler arg2) throws DataAccessException {
			this.getSqlMapClientTemplate().queryWithRowHandler(arg0, arg1, arg2);
		}
		
		public void update(String arg0, Object arg1, int arg2) throws DataAccessException {
			this.getSqlMapClientTemplate().update(arg0, arg1, arg2);
		}
		
		public int update(String arg0) throws DataAccessException {
			return this.getSqlMapClientTemplate().update(arg0);
		}

		public int update(String arg0, Object arg1) throws DataAccessException {
			return this.getSqlMapClientTemplate().update(arg0, arg1);
		}
		
		public int count(String arg0, Object arg1) throws DataAccessException {
			return ((Integer) this.getSqlMapClientTemplate().queryForObject(arg0, arg1)).intValue();
		}
	}
