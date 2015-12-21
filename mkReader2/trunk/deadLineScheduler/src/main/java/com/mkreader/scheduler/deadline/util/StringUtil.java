package com.mkreader.scheduler.deadline.util;
import java.util.Map;
import java.util.StringTokenizer;


public class StringUtil
{
	public static final String NULL_STR = "null";
	public static final String ZERO_STR = "0";
	public static final String DUBZERO_STR = "0.00";
	public static final String EMPTY_STR = "";

	/**
	 * 객체가 null 또는 "null"이면 ""으로 만들어 준다.
	 * @param   obj not null로 만들 Object
	 * @return  "" 또는 객체의 toString()을 리턴
	 */
	public static final String notNull(Object obj)
	{
		if (null==obj || NULL_STR.equals(obj))
			return EMPTY_STR;
		else
			return obj.toString();
	}

	public static final String notNull(String str)
	{
		if (null==str || NULL_STR.equals(str))
			return EMPTY_STR;
		else
			return str;
	}

	/**
	 * 객체가 순수한(pure) null 이면 "" 으로 만들어준다
	 * @param   obj not null로 만들 Object
	 * @return  "" 또는 객체의 toString()을 리턴
	 */
	public static final String notPureNull(Object obj)
	{
		if (null == obj)
			return EMPTY_STR;
		else
			return obj.toString();
	}

	public static final String notPureNull(String str)
	{
		if (null == str)
			return EMPTY_STR;
		else
			return str;
	}

	/**
	 * 객체가 순수한(pure) null 이면 "" 으로 만들어준다. 아니면 윈래 객체를 되돌려 준다.
	 * @param   obj not null로 만들 Object
	 * @return  "" 또는 원래 Object 객체
	 */
	public static final Object notObjNull(Object obj)
	{
		if (null == obj)
			return EMPTY_STR;
		else
			return obj;
	}

	/**
	 * 객체가 null 또는 "null" 또는 "" 이면 true 리턴
	 * @param   obj null 인지 판단할 객체
	 * @return  null 또는 "" 또는 "null" 이면 true
	 */
	public static final boolean isNull(Object obj)
	{
		if (null==obj || EMPTY_STR.equals(obj) || NULL_STR.equals(obj))
			return true;
		else
			return false;
	}

	public static final boolean isNull(String str)
	{
		if(str !=null) str = str.trim();

		if (null==str || EMPTY_STR.equals(str) || NULL_STR.equals(str))
			return true;
		else
			return false;
	}

	public static final boolean isNullZero(String str)
	{
		if(str !=null) str = str.trim();

		if (null==str || EMPTY_STR.equals(str) || NULL_STR.equals(str) || ZERO_STR.equals(str)|| DUBZERO_STR.equals(str)  )
			return true;
		else
			return false;
	}

	/**
	 * 순수한(pure) null 인지만 체크, 순수 null이면 true를 리턴
	 * @param   obj null 인지 판단할 객체
	 * @return  객체가 (pure) null 이면 true
	 */
	public static final boolean isPureNull(Object obj)
	{
		if (obj == null)
			return true;
		else
			return false;
	}

	/**
	 * Object가 null 또는 "null" 이면 "0"으로 만들어 준다
	 * @param   obj notNull로 만들 String
	 * @return  "0" 또는 원래의 String
	 */
	public static final String nullToZero(Object obj)
	{
		if (null==obj || EMPTY_STR.equals(obj) || NULL_STR.equals(obj))
			return "0";
		else
			return obj.toString();
	}

	/**
	 * String이 null 또는 "null" 이면 "0"으로 만들어 준다
	 * @param   str notNull로 만들 String
	 * @return  "0" 또는 원래의 String
	 */
	public static final String nullToZero(String str)
	{
		if (null==str || EMPTY_STR.equals(str) || NULL_STR.equals(str))
			return "0";
		else
			return str;
	}

	/**
	 * xxxxxx 또는 xxx-xxx 형식의 우편번호를 xxx, xxx 로 나눈다.
	 * @param   str 두개로 짜를 우편번호(길이가 6 또는 7, 7일 경우 중간에 "-" 포함), 길이가 맞지 않으면 NumberFormatException 발생
	 * @return  나눈 스트링 두개를 스트링배열에 담아서 리턴
	 */
	public static final String[] splitZipCode(String str)
	{
		int len = str.length();

		if (len == 6)
		{
			String[] post = new String[2];
			post[0] = str.substring(0,3);
			post[1] = str.substring(3);
			return post;
		}
		else if (len == 7)  // 중간에 "-" 붙은 경우
		{
			String[] post = new String[2];
			post[0] = str.substring(0,3);
			post[1] = str.substring(4);
			return post;
		}
		else
		{
			throw new NumberFormatException("우편번호 문자열의 길이가 6 또는 7(- 포함)이어야 합니다.");
		}
	}

	/**
	 * Object를 받아서 "" 또는 null 또는 "null" 이면 &nbsp;로 바꿔주고, 아니면 객체의 toString()을 리턴
	 * @param   obj
	 * @return  "" 또는 null 이면 &nbsp; NULL이 아니면 객체의 toString()
	 */
	public static final String obj2nbsp(Object obj)
	{
		if (isNull(obj))
		{
			return "&nbsp;";
		}
		else
		{
			/*String str = obj.toString();
			str.trim();
			return str;*/
			return obj.toString();
		}
	}

	/**
	 * String을 받아서 ""또는 null 또는 "null" 이면 &nbsp;로 바꿔준다
	 * @param   str 바꿀 String
	 * @return  "" 또는 null 이면 &nbsp;
	 */
	public static final String obj2nbsp(String str)
	{
		if (isNull(str))
		{
			return "&nbsp;";
		}
		else
		{
			/*str.trim();*/
			return str;
		}
	}

	/**
	 * 원하는 스트링을 구분자로 짤라서 나눠진 길이만큼의 배열로 리턴해준다
	 * @param   spritData 나누고자 하는 스트링(NULL 체크 하지 않음)
	 * @param   delim 구분하기 위한 구분자
	 * @return  나눈 스트링을 배열에 담아서 리턴
	 */
	public static final String[] spritData(String spritData, String delim)
	{
		StringTokenizer st = new StringTokenizer(spritData, delim);
		int size = st.countTokens();
		String[] token = new String[size];
		int i = 0;
		while (st.hasMoreTokens())
		{
			token[i] = st.nextToken();
			i++;
		}

		return token;
	}

	/**
	 * 사업자등록번호를 000-00-00000 형식으로 보여지도록 가능하게 3개로 나눈다
	 * @param   no 사업자등록번호, null이 들어오면 안된다. null 체크 안함.
	 * @return  나눈 스트링을 배열에 담아서 리턴
	 */
	public static final String[] spritBusinessNo(String no)
	{
		String[] busino = new String[3];
		if (no.length() == 10)
		{
			busino[0] = no.substring(0, 3);   // 처음 세자리 짜르기
			busino[1] = no.substring(3, 5);   // 두번째 두자리 짜르기
			busino[2] = no.substring(5);      // 마지막 다섯자리 짜르기
			return busino;
		}
		else
		{
			throw new NumberFormatException("사업자등록번호의 길이가 10이 아닙니다.");
		}
	}

	/**
	 * List에 담긴 요소들을 구분자로 구분하여 String으로 리턴
	 * @param   list List 인터페이스를 구현한 요소들이 담긴 객체
	 * @param   delim 구분할 구분자 String
	 * @return  요소들을 구분자로 연결한 String
	 */
	public static final String insertSep(java.util.List list, String delim)
	{
		int size = list.size();
		if (size > 0)
		{
			StringBuffer buffer = new StringBuffer();
			buffer.append(list.get(0).toString());
			for (int i=1; i<size; i++)
			{
				buffer.append(delim);
				buffer.append(list.get(i).toString());
			}
			return buffer.toString();
		}
		else
		{
			throw new IllegalArgumentException("요소의 갯수가 0보다 크지 않습니다.");
		}
	}

	public static final String nl2br(String comment)
	{
		int length = comment.length();

		StringBuffer buffer = new StringBuffer();
		String comp;
		for (int i=0; i<length; ++i)
		{
			comp = comment.substring(i, i+1);
			if ("\r".compareTo(comp) == 0)
			{
				comp = comment.substring(++i, i+1);
				if ("\n".compareTo(comp) == 0)
					buffer.append("<BR>\r");
				else
					buffer.append("/r");
			}
			buffer.append(comp);
		}
		return buffer.toString();
	}

	/**
	 * String 배열에 각각 담겨져서 분리된 문자열을 구분자를 넣어서 하나의 문자열로 합치는 경우에 사용한다.
	 * @param   arr 배열에 담긴 분리된 문자들
	 * @param   div 구분자
	 * @return  구분자로 합쳐진 문자열
	 */
	public static final String combineStr(String[] arr, String div)
	{
		String comStr = "";
		int arrSize = 0;
		if (!EMPTY_STR.equals(arr[0]))
		{
			arrSize = arr.length;
			for (int i=0; i<arrSize; i++)
			{
				comStr = comStr + arr[i];
				if (i < arrSize-1)
				{
					comStr = comStr + div;
				}
			}
		}
		return comStr;
	}

	/**
	 * 정해진 길이에서 문자열의 앞에 원하는 문자 채우기
	 * @param total_length 총 길이
	 * @param fillChar 앞으로 채워넣을 문자열
	 * @param s 변환할 문자열
	 * @return fillChar로 모자른 길이만큼 채워진 변환된 문자열
	 */
	public static final String frontFillChar(int total_length, String fillChar, String s)
	{
		int len = total_length - s.length();
		StringBuffer sb = new StringBuffer();
		for (int i=0; i<len; i++)
			sb.append(fillChar);

		return sb.append(s).toString();
	}

	/**
	 * 원본문자열에 매칭되는 문자열을 모두 찾아서 바꿔준다. replaceFirst 메소드를 재귀호출한다. 쓰지 않도록 한다.
	 * @param   original 원본 문자열
	 * @param   toBeReplaced 바꿔져야할 문자
	 * @param   replacement 바꿀 문자
	 * @return  바뀌어진 문자열
	 */
	public static final String replace(String original, String toBeReplaced, String replacement)
	{
		/*System.out.println("original : " + original);
		System.out.println("toBeReplaced : " + toBeReplaced);
		System.out.println("replacement : " + replacement);*/

		String returnValue = new String(original);
		while (returnValue.indexOf(toBeReplaced) >= 0)
		{
			returnValue = replaceFirst(returnValue, toBeReplaced, replacement);
		}
		return returnValue;
	}

	/**
	 * 원본문자열에 매칭되는 맨처음에 나타나는 문자열을 찾아서 바꿔준다. 쓰지 않도록 한다.
	 * @param   original     원본 문자열
	 * @param   toBeReplaced  바꿔져야할 문자
	 * @param   replacement  바꿀 문자
	 * @return  바뀌어진 문자열
	 */
	public static final String replaceFirst(String original, String toBeReplaced, String replacement)
	{
		StringBuffer returnValue = new StringBuffer(original);
		int hit = original.indexOf(toBeReplaced);
		if (hit >= 0)
		{
			returnValue = new StringBuffer(original.substring(0, hit));
			returnValue.append(replacement);
			returnValue.append(original.substring(hit + toBeReplaced.length()));
		}
		return returnValue.toString();
	}

	/**
	 * 입력되는 전화번호 중 지역번호와 국번호의 '0'을 삭제하여 리턴한다.
	 * @param   tel 지역번호 또는 국번호
	 * @param   delim 입력된 데이타가 지역번호인지 국번호인지 구분하기 위한 구분자(1 : 지역번호, 2 : 국번호)
	 * @param   ln '0'을 제거한후 리턴되는 데이타의 길이(지역번호 : 3, 국번호 : 4 로 입력)
	 * @return  전화번호
	 */
	public static final String rmZeroData(String tel, String delim, int ln)
	{
		if (delim.equals("1"))
		{
			if (tel.substring(2).equals("02"))
				ln--;
		}
		else if (delim.equals("2"))
		{
			if (tel.substring(0,1).equals("0"))
				ln--;
		}
		return tel.substring(tel.length()-ln);
	}

	/**
	 * ',' 구분된 데이터가 넘어올 때 ,, 연속대이터를  , ,로 수정
	 * @param sRow
	 * @return
	 */
	public static final String[] divideField(String sRow, String delim)
    {
        String sTmpStr = "";
        if ((sRow.substring((sRow.length()-1), sRow.length())).equals(delim)) {
            sRow = sRow + " ";
        }

        for (int i = 0; i < sRow.length(); i++) {
            if (i < sRow.length()) {
                if (((sRow.substring(i, i+1)).equals(delim)) && ((sRow.substring(i+1, i+2)).equals(delim))) {
                    sTmpStr = sTmpStr + sRow.substring(i, i+1) + " ";
                }
                else {
                    sTmpStr = sTmpStr + sRow.substring(i, i+1);
                }
            }
        }
        sRow = sTmpStr;
        StringTokenizer stValue = new StringTokenizer(sRow, delim);
        String[] sRtnValue = new String[stValue.countTokens()];

        for (int i = 0; i < sRtnValue.length; i++) {
            sRtnValue[i] = stValue.nextToken().trim();
        }
        return sRtnValue;
    }

	public static final void replaceEnter(Map item, String key){
		String val = (String)item.get(key);
		if(val != null) {
			item.put(key, val.replaceAll("\r\n", "<br>"));
		}
	}


	public static final void divPhone(Map item, String key, String delim){
		String val = StringUtil.notNull((String)item.get(key));
		String[] result = new String[3];
	     result[0] = "";
	     result[1] = "";
	     result[2] = "";
	     if(!"".equals(val) || !"".equals(delim)){
	    	 StringTokenizer st = new StringTokenizer(val, delim);
	    	 int idx = 0;
	    	 while(st.hasMoreTokens()){
	    		 item.put(key+(idx++),  st.nextToken());
	    	 }
	     }
	}

	public static final void divHLdata(Map item, String key, String delim){
		String val = StringUtil.notNull((String)item.get(key));
		String[] result = new String[3];
	     result[0] = "";
	     result[1] = "";
	     result[2] = "";
	     if(!"".equals(val) || !"".equals(delim)){
	    	 StringTokenizer st = new StringTokenizer(val, delim);
	    	 int idx = 100;
	    	 while(st.hasMoreTokens()){
	    		 item.put(key+(idx++),  st.nextToken());
	    	 }
	     }
	}
	
	/**
	 * 오라클 lpad 기능의 유틸
	 * str 입력값 , size 자릿수 , fStr 입력값앞에 들어갈 문자 
	 * @param sRow
	 * @return
	 */
	public static String lPad(String str, int size, String fStr){
		 byte[] b = str.getBytes();
		 int len = b.length;
		 int tmp = size - len;
		 
		 for (int i=0; i < tmp ; i++){
		  str = fStr + str;
		 }
		 return str;
		}


}