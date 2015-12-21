package com.mkreader.scheduler.deadline.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.mkreader.scheduler.deadline.dao.DeadLineDAO;
import com.mkreader.scheduler.deadline.util.ConnectionUtil;
import com.mkreader.scheduler.deadline.util.DateUtil;
import com.mkreader.scheduler.deadline.util.FileUtil;

@Service
public class DeadLineServiceImpl implements DeadLineService {
	
	@Autowired
	private DeadLineDAO deadLineDAO = null;

	@Override
	@Transactional
	public void deadLine() {
		String yymm = DateUtil.getCurrentDate("yyyyMM");
		String curDate = DateUtil.getCurrentDate("yyyyMMdd");
		int hour = Integer.parseInt(DateUtil.getCurrentDate("HH"));
		if(!curDate.substring(6,8).equals("20"))return;
		if(hour < 22)return;
		try {
			HashMap<String,String> dbparam = new HashMap<String,String>();
			String text = "";
			String nLine = "\n";

			dbparam.put("curDate",curDate);
			dbparam.put("yymm",yymm);
			
			List<HashMap<String,Object>> monthCloseList = deadLineDAO.getMonthCloseList(dbparam);
			
			//월마감 완료
			if(monthCloseList.size() > 0)return;

			// 24개월전 결혼 미수처리 (2013.12.19 박윤철)
			// 수금 히스토리 입력
			deadLineDAO.update2YearMisuHist(dbparam);
			// 수금 업데이트
			deadLineDAO.update2YearsMisu(dbparam);

			String PATH_UPLOAD_DEADLINE_RESULT = "/home/tmax/mkreader/uploadedfile/deadLine";
			List<HashMap<String,Object>> agencyList = deadLineDAO.getAgencyList();
			String msg = null;
			for(HashMap<String,Object> map:agencyList){
				text = text + map.get("BOSEQ") + "=======================================================" + nLine;
				dbparam.put("boSeq", (String)map.get("BOSEQ"));


				// 미수 생성 본사 입금 이외
				msg = deadLineDAO.accountsReceivable(dbparam);
				text = text + msg + nLine;
				if (msg.indexOf("FAIL") > -1) {
					FileUtil.saveTxtFile(PATH_UPLOAD_DEADLINE_RESULT + "/" + yymm, "deadLineFail" + DateUtil.getCurrentDate("yyyyMMddHHmmss") + ".txt", msg, "UTF-8");
					throw new Exception(msg);
				}


				// 통계 등록
				msg = deadLineDAO.statisticsInsert(dbparam);
				text = text + msg + nLine;
				if (msg.indexOf("FAIL") > -1) {
					FileUtil.saveTxtFile(PATH_UPLOAD_DEADLINE_RESULT + "/" + yymm, "deadLineFail" + DateUtil.getCurrentDate("yyyyMMddHHmmss") + ".txt", msg, "UTF-8");
					throw new Exception(msg);
				}
				// 배달번호 정렬
				List<HashMap<String,Object>> gnoList = deadLineDAO.getGnoList(dbparam);
				for (int j = 0; j < gnoList.size(); j++) {
					@SuppressWarnings("rawtypes")
					Map list = (Map) gnoList.get(j);
					dbparam.put("gno", (String)list.get("GNO"));
					msg = deadLineDAO.deliverNumSort(dbparam);
					text = text + msg + nLine;
					if (msg.indexOf("FAIL") > -1) {
						FileUtil.saveTxtFile(PATH_UPLOAD_DEADLINE_RESULT + "/" + yymm, "deadLineFail" + DateUtil.getCurrentDate("yyyyMMddHHmmss") + ".txt", msg, "UTF-8");
						throw new Exception(msg);
					}
				}
				text = text + nLine;
			}
//			System.out.println(text);
			// 수금년월 인설트
			deadLineDAO.insertMonthClose(dbparam);
			// 수금 결과 파일 생성 upload/deadLine
			String currentDateTime = DateUtil.getCurrentDate("yyyyMMddHHmmss");
			FileUtil.saveTxtFile(PATH_UPLOAD_DEADLINE_RESULT + "/" + yymm,"deadLineResult" + currentDateTime + ".txt", text, "UTF-8");
			List<NameValuePair> params = new ArrayList<NameValuePair>();
			params.add(new BasicNameValuePair("tel","이경철,01071669049,월마감\b성공,0220002000"));
			ConnectionUtil.sendRequest("http://203.238.59.100/xroshot.php", params,"EUC-KR");
			params = new ArrayList<NameValuePair>();
			params.add(new BasicNameValuePair("tel","문현국,01031122695,월마감\b성공,0220002000"));
			ConnectionUtil.sendRequest("http://203.238.59.100/xroshot.php", params,"EUC-KR");
		} catch (Exception e) {
			e.printStackTrace();
			List<NameValuePair> params = new ArrayList<NameValuePair>();
			params.add(new BasicNameValuePair("tel","이경철,01071669049,월마감\b실패,0220002000"));
			ConnectionUtil.sendRequest("http://203.238.59.100/xroshot.php", params,"EUC-KR");
			params = new ArrayList<NameValuePair>();
			params.add(new BasicNameValuePair("tel","문현국,01031122695,월마감\b실패,0220002000"));
			ConnectionUtil.sendRequest("http://203.238.59.100/xroshot.php", params,"EUC-KR");
		}
	}
}
