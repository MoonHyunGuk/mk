package com.mkreader.util;

/*
*
* @(#)DateUtil.java
*
* Copyright 2001 Digital Network Soultions Co., Ltd. All Rights Reserved.
*
*/

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Map;
import java.util.StringTokenizer;

public class DateUtil
{

	/** 원하는 날짜형식의 원하는 포맷 스트링을 넘기면 그 포맷으로 현재날짜의 String을 리턴
	 * @param   form 원하는 날짜 포맷 (ex] yyyyMMdd, yyyyMMddHHmmss, HHmm 등)
	 * @return  원하는 형식으로 포맷된 현재날짜(시간) 스트링
	 * @since JDK1.1<br><p>
	 */
	public static final String getCurrentDate(final String form)
 	{
 		SimpleDateFormat formatter = new SimpleDateFormat(form);
 		java.util.Date currentDate = new java.util.Date();
 		return formatter.format(currentDate);
 	}

	/** 숫자형식의 날짜 Object 를 구분자 delim 으로 구분해서 원하는 날짜 형식의 스트링을 얻는다
	 * @param   obj 8자리이상의 숫자형식의 날짜 Object <!-- (8자리보다 작으면 에러발생 ex]20010521) -->
	 * @param   delim 날짜형식사이에 넣을 원하는 구분자 (ex] /, - 등)
	 * @return  구분자가 들어간 날짜형식의 스트링
	 */
	public static final String obj2date(Object obj, String delim)
	{
		if (StringUtil.isNull(obj))
			return "";

		String str = obj.toString();
		if (str.length() >= 8)
			return str.substring(0,4) + delim + str.substring(4,6) + delim + str.substring(6,8);
		else
			// throw new NumberFormatException("스트링의 길이가 8자보다 작습니다");
			return obj.toString();
	}

	/** 숫자형식의 날짜 String 을 구분자 delim 으로 구분해서 원하는 날짜 형식의 데이타를 얻는다
	 * @param   str 8자리이상의 날짜 String <!-- (8자리보다 작으면 에러발생 ex]20010521) -->
	 * @param   delim 날짜형식사이에 넣을 원하는 구분자 (ex] /, - 등)
	 * @return  구분자가 들어간 날짜형식의 스트링
	 */
	public static final String obj2date(String str, String delim)
	{
		if (StringUtil.isNull(str))
			return "";

		if (str.length() >= 8)
			return str.substring(0,4) + delim + str.substring(4,6) + delim + str.substring(6,8);
		else
			// throw new NumberFormatException("스트링의 길이가 8자보다 작습니다");
			return str;
	}

	/** 날짜형식의 Object를 구분자인 delim을 빼고 숫자형식의 날짜 String을 리턴
	 * @param   obj 구분자가 있는 날짜형식의 Object(ex] yyyy-MM-dd, yyyy/MM/dd)
	 * @param   delim 제거해야할 구분자(ex] /, - 등)
	 * @return  구분자가 제거된 순수한 숫자형식의 날짜 스트링
	 */
	public static final String obj2str(Object obj, String delim)
	{
		if (StringUtil.isNull(obj))
			return "";

		String date = obj.toString();
		StringTokenizer st = new StringTokenizer(date, delim);
		if (st.hasMoreTokens())
		{
			int token_count = st.countTokens();
			if (token_count==1)
			{
				return date;
			}
			else if (token_count==3)
			{
				String year = st.nextToken();
				String month = st.nextToken();
				if (month.length() < 2)
				{
					month = "0"+month;
				}
				String day = st.nextToken();
				if (day.length() < 2)
				{
					day = "0"+day;
				}
				return year+month+day;
			}
			else
			{
				return date;
			}
			/*else if (token_count==2)
			{
				String first = st.nextToken();
				String last = st.nextToken();
				if (last.length() < 2)
				{
					last = "0"+last;
				}
			}*/
		}
		else // hasMoreTokens가 false  (String이 ""일 경우)
		{
			return date;
			// throw new NumberFormatException("스트링이 날짜형식이 아닙니다");
		}
	}

	/** 스트링인 날짜형식의 데이타를 구분자인 delim을 빼고 숫자형식의 날짜로 바꾼다
	 * @param   str 날짜형식의 스트링
	 * @param   delim 제거해야할 구분자(ex] /, - 등)
	 * @return  구분자가 제거된 순수한 숫자형식의 날짜 스트링
	 */
	/*public static String date2str(String str, String delim)
	{
		if (StringUtil.isNull(str))
		{
			return "";
		}
		StringTokenizer st = new StringTokenizer(str, delim);
		if (st.hasMoreTokens())
		{
			String year = st.nextToken();
			String month = st.nextToken();
			if (month.length() < 2)
			{
				month = "0"+month;
			}
			String day = st.nextToken();
			if (day.length() < 2)
			{
				day = "0"+day;
			}
			return year+month+day;
		}
		else
		{
			throw new NumberFormatException("스트링이 날짜형식이 아닙니다");
		}
	}*/

	/** 숫자형식의 날짜 Object를 년, 월, 일로 짤라서 스트링배열을 리턴한다
	 * @param   dateObj 순수한 숫자형식의 날짜 Object(8자리가 아니면 에러발생)
	 * @return  년, 월, 일로 짤라서 담은 String 배열
	 */
	public static final String[] dateDivide(Object dateObj)
	{
		return dateDivide(dateObj.toString());
		/*String[] date = new String[3];
		String str = dateObj.toString();
		if (str.length() == 8)
		{
			String year = str.substring(0,4);
			String month = str.substring(4,6);
			String day = str.substring(6);
			date[0] = year;
			date[1] = month;
			date[2] = day;
		}
		else
		{
			throw new NumberFormatException("스트링의 길이가 8이 아닙니다.");
		}
		return date;*/
	}

	/** 숫자형식의 날짜 String을 년, 월, 일로 짤라서 스트링배열을 리턴한다
	 * @param   dateStr 순수한 숫자형식의 날짜 String(8자리가 아니면 에러발생)
	 * @return  년, 월, 일로 짤라서 담은 String 배열
	 */
	public static final String[] dateDivide(String dateStr)
	{
		if (dateStr.length() == 8)
		{
			String[] date = new String[3];
			String year = dateStr.substring(0,4);
			String month = dateStr.substring(4,6);
			String day = dateStr.substring(6);
			date[0] = year;
			date[1] = month;
			date[2] = day;
			return date;
		}
		else
		{
			throw new NumberFormatException("스트링의 길이가 8이 아닙니다.");
		}
	}

	/** 파라메타로 넘긴 Calendar 객체의 날짜와 시간을 구한다
	 * @param   calendar 날짜와 시간을 구한 Calendar 객체
	 * @return  yyyy/MM/dd HH:mm 형식의 날짜와 시간
	 * @since JDK1.2<br><p>
	 */
	public static final String getCalendarDate(Calendar calendar)
	{
		String year = String.valueOf(calendar.get(Calendar.YEAR));

		String month = String.valueOf(calendar.get(Calendar.MONTH)+1);
		if (month.length() < 2)
			month = "0" + month;

		String date = String.valueOf(calendar.get(Calendar.DATE));
		if (date.length() < 2)
			date = "0" + date;

		String hours = String.valueOf(calendar.get(Calendar.HOUR_OF_DAY));
		if (hours.length() < 2)
			hours = "0" + hours;

		/*String hours = String.valueOf(calendar.get(Calendar.HOUR));
		if (calendar.get(Calendar.AM_PM ) == 1)
			hours = String.valueOf(Integer.parseInt(hours) + 12);
		if (hours.length() < 2)
			hours = "0" + hours;*/

		String minutes = String.valueOf(calendar.get(Calendar.MINUTE));
		if (minutes.length() < 2)
			minutes = "0" + minutes;

		/*String second = String.valueOf(calendar.get(Calendar.SECOND));
		if (second.length() < 2)
			second = "0" + second;*/

		return year + "/" + month + "/" + date + " " + hours + ":"  + minutes;
	}

	/** deprecated된 Date를 쓰지않고 Calendar 객체를 구해서 현재 날짜를 가져온다
	 * @return  yyyyMMdd 형식의 날짜
	 * @since JDK1.2<br><p>
	 */
	public static final String getNowDay()
	{
		Calendar rightNow = Calendar.getInstance();

		String year = String.valueOf(rightNow.get(Calendar.YEAR));

		String month = String.valueOf(rightNow.get(Calendar.MONTH)+1);
		if (month.length() < 2)
			month = "0" + month;

		String date = String.valueOf(rightNow.get(Calendar.DATE));
		if (date.length() < 2)
			date = "0" + date;

		return year + month + date;
	}

	/** 현재날짜, 시간의 풀타임을 스트링배열로 구한다.
	 * @param   filling 남는 자릿수를 0으로 채울것인지 여부. 월(2자리), 일(2자리), 분(2자리), 초(2자리), ms(3자리).
	 * @return  year, month, day, minute, second, ms를 스트링배열에 담아서 보낸다
	 * @since JDK1.2<br><p>
	 */
	public static final String[] getFullNow(final boolean filling)
	{
		Calendar rightNow = Calendar.getInstance();

		String year = String.valueOf(rightNow.get(Calendar.YEAR));

		String month = String.valueOf(rightNow.get(Calendar.MONTH)+1);
		if (filling == true && month.length() < 2)
			month = "0" + month;

		String date = String.valueOf(rightNow.get(Calendar.DATE));
		if (filling == true && date.length() < 2)
			date = "0" + date;

		String hours = String.valueOf(rightNow.get(Calendar.HOUR_OF_DAY));
		if (filling == true && hours.length() < 2)
			hours = "0" + hours;

		String minutes = String.valueOf(rightNow.get(Calendar.MINUTE));
		if (filling == true && minutes.length() < 2)
			minutes = "0" + minutes;

		String second = String.valueOf(rightNow.get(Calendar.SECOND));
		if (filling == true && second.length() < 2)
			second = "0" + second;

		String millisecond = String.valueOf(rightNow.get(Calendar.MILLISECOND));
		if (filling == true && millisecond.length() < 2)
			millisecond = "0" + millisecond;

		return new String[]{year, month, date, hours, minutes, second, millisecond};
	}

	/** 현재날짜, 시간의 풀타임을 스트링배열로 구한다. 먼저 생성한 Calendar 객체를 재사용할 경우 사용한다.
	 * @param   rightNow 생성한 Calendar 객체
	 * @param   filling 남는 자릿수를 0으로 채울것인지 여부. 월(2자리), 일(2자리), 분(2자리), 초(2자리), ms(3자리).
	 * @return  year, month, day, minute, second, ms를 스트링배열에 담아서 보낸다
	 * @since JDK1.2<br><p>
	 */
	public static final String[] getFullNow(final Calendar rightNow, final boolean filling)
	{
		String year = String.valueOf(rightNow.get(Calendar.YEAR));

		String month = String.valueOf(rightNow.get(Calendar.MONTH)+1);
		if (filling == true && month.length() < 2)
			month = "0" + month;

		String date = String.valueOf(rightNow.get(Calendar.DATE));
		if (filling == true && date.length() < 2)
			date = "0" + date;

		String hours = String.valueOf(rightNow.get(Calendar.HOUR_OF_DAY));
		if (filling == true && hours.length() < 2)
			hours = "0" + hours;

		String minutes = String.valueOf(rightNow.get(Calendar.MINUTE));
		if (filling == true && minutes.length() < 2)
			minutes = "0" + minutes;

		String second = String.valueOf(rightNow.get(Calendar.SECOND));
		if (filling == true && second.length() < 2)
			second = "0" + second;

		String millisecond = String.valueOf(rightNow.get(Calendar.MILLISECOND));
		if (filling == true && millisecond.length() < 2)
			millisecond = "0" + millisecond;

		return new String[]{year, month, date, hours, minutes, second, millisecond};
	}

	/** Calendar 객체를 구해서 현재 날짜를 가져온다
	 * @return  yyMMdd 형식의 날짜
	 * @since JDK1.2<br><p>
	 */
	public static final String getShortNow()
	{
		Calendar rightNow = Calendar.getInstance();

		String month = String.valueOf(rightNow.get(Calendar.MONTH)+1);
		if (month.length() < 2)
			month = "0" + month;

		String date = String.valueOf(rightNow.get(Calendar.DATE));
		if (date.length() < 2)
			date = "0" + date;

		return String.valueOf(rightNow.get(Calendar.YEAR)).substring(2) + month + date;
	}

	/** deprecated된 Date를 쓰지않고 Calendar 객체를 구해서 현재 시간을 가져온다
	 * @return  HHmm 24시간 형식의 시간
	 * @since JDK1.2<br><p>
	 */
	public static final String getNowTime()
	{
		Calendar nowTime = Calendar.getInstance();

		String hours = String.valueOf(nowTime.get(Calendar.HOUR_OF_DAY));
		if (hours.length() < 2)
			hours = "0" + hours;

		/*String hours = String.valueOf(nowTime.get(Calendar.HOUR));
		if (nowTime.get(Calendar.AM_PM ) == 1)
			hours = String.valueOf(Integer.parseInt(hours) + 12);
		if (hours.length() < 2)
			hours = "0" + hours;*/

		String minutes = String.valueOf(nowTime.get(Calendar.MINUTE));
		if (minutes.length() < 2)
			minutes = "0" + minutes;

		return hours + minutes;
	}

	/** deprecated된 Date를 쓰지않고 Calendar 객체를 구해서 현재 년, 월, 일을 각각 저장
	 * @param   fill 월, 일을 0으로 채울것인지 셋팅, true 이면 월, 일을 항상 두자리로 채운다
	 * @return  년, 월, 일이 각각 잘려서 저장된 스트링 배열
	 * @since JDK1.2<br><p>
	 */
	public static final String[] getSpritDate(final boolean fill)
	{
		String[] spritDate = new String[3];
		Calendar rightNow = Calendar.getInstance();

		if (fill)
		{
			spritDate[0] = String.valueOf(rightNow.get(Calendar.YEAR));

			String month = String.valueOf(rightNow.get(Calendar.MONTH)+1);
			if (month.length() < 2){
				spritDate[1] = "0" + month;
			}else{
				spritDate[1] =  month;
			}

			String date = String.valueOf(rightNow.get(Calendar.DATE));
			if (date.length() < 2){
				spritDate[2] = "0" + date;
			}else{
				spritDate[2] =  date;
			}
		}
		else
		{
			spritDate[0] = String.valueOf(rightNow.get(Calendar.YEAR));
			spritDate[1] = String.valueOf(rightNow.get(Calendar.MONTH)+1);
			spritDate[2] = String.valueOf(rightNow.get(Calendar.DATE));
		}

		return spritDate;
	}

	/** deprecated된 Date를 쓰지않고 Calendar 객체를 구해서 현재 날자와 시간을 가져온다
	 * @return  yyyyMMddHHmm 형식의 현재 날짜와 시간
	 * @since JDK1.2<br><p>
	 */
	public static final String getNowDayTime()
	{
		Calendar rightNow = Calendar.getInstance();
		String year = String.valueOf(rightNow.get(Calendar.YEAR));

		String month = String.valueOf(rightNow.get(Calendar.MONTH)+1);
		if (month.length() < 2)
			month = "0" + month;

		String date = String.valueOf(rightNow.get(Calendar.DATE));
		if (date.length() < 2)
			date = "0" + date;

		String hours = String.valueOf(rightNow.get(Calendar.HOUR_OF_DAY));
		if (hours.length() < 2)
			hours = "0" + hours;

		/*String hours = String.valueOf(rightNow.get(Calendar.HOUR));
		if (rightNow.get(Calendar.AM_PM ) == 1)
			hours = String.valueOf(Integer.parseInt(hours) + 12);
		if (hours.length() < 2)
			hours = "0" + hours;*/

		String minutes = String.valueOf(rightNow.get(Calendar.MINUTE));
		if (minutes.length() < 2)
			minutes = "0" + minutes;

		return year + month + date + hours + minutes;
	}

	/** 현재 날의 Calendar 객체를 구해서 지정한 만큼의 이전 날짜 또는 이후 날짜 구하기
	 * @param   field 년(1), 월(2), 일(5), 시간(10), 분(12) 등 자기가 바꾸고 싶은 필드의 값
	 * @param   amount 이후 및 이전(-) 으로 구하고자 값
	 * @return  바뀌어진 날짜 배열
	 * @since JDK1.2<br><p>
	 */
	public static final String[] getAddDay(int field, int amount)
	{
		String[] addDay = new String[3];
		Calendar rightNow = Calendar.getInstance();
		rightNow.add(field, amount);
		addDay[0] = String.valueOf(rightNow.get(Calendar.YEAR));
		addDay[1] = String.valueOf(rightNow.get(Calendar.MONTH)+1);
		addDay[2] = String.valueOf(rightNow.get(Calendar.DATE));
		//addDay[3] = rightNow.get(field);
		return addDay;
	}

	/** 현재 날의 Calendar 객체를 구해서 지정한 만큼의 이전 날짜 또는 이후 날짜 구하기
	 * @param   field 년(1), 월(2), 일(5), 시간(10), 분(12) 등 자기가 바꾸고 싶은 필드의 값
	 * @param   amount 이후 및 이전(-) 으로 구하고자 값
	 * @return  바뀌어진 날짜 배열, 0을 붙여서 보낸다
	 * @since JDK1.2<br><p>
	 */
	public static final String[] getLongAddDay(int field, int amount)
	{
		String[] addDay = new String[5];
		Calendar rightNow = Calendar.getInstance();
		rightNow.add(field, amount);
		addDay[0] = String.valueOf(rightNow.get(Calendar.YEAR));
		addDay[1] = String.valueOf(rightNow.get(Calendar.MONTH)+1);
		if (addDay[1].length() < 2)
				addDay[1] = "0" + addDay[1];
		addDay[2] = String.valueOf(rightNow.get(Calendar.DATE));
		if (addDay[2].length() < 2)
				addDay[2] = "0" + addDay[2];
		addDay[3] = String.valueOf(rightNow.get(Calendar.HOUR));
		if (addDay[3].length() < 2)
				addDay[3] = "0" + addDay[3];
		addDay[4] = String.valueOf(rightNow.get(Calendar.HOUR_OF_DAY));
		if (addDay[4].length() < 2)
				addDay[4] = "0" + addDay[4];
		//addDay[3] = rightNow.get(field);
		return addDay;
	}

	/** 정해진 날짜를 받아서 그 날짜에서 이전 날짜 또는 이후 날짜 구하기
	 * @param   wantDay 바꾸고자하는 날짜 형식 스트링(yyyyMMdd)
	 * @param   field 년(YEAR=1), 월(MONTH=2), 일(DATE=5) 자기가 바꾸고자 하는 필드의 값
	 * @param   amount 이후 및 이전(-) 으로 구하고자 값
	 * @return  바뀌어진 날짜 배열
	 * @since JDK1.2<br><p>
	 */
	public static final String[] getWantAddDay(String wantDay, int field, int amount)
	{
		String[] wantAddDay = new String[3];

		if (wantDay.length() == 8)
		{
			int year = Integer.parseInt(wantDay.substring(0,4));
			int month = Integer.parseInt(wantDay.substring(4,6));
			int day = Integer.parseInt(wantDay.substring(6));

			Calendar rightNow = Calendar.getInstance();
			rightNow.set(year, month-1, day);
			rightNow.add(field, amount);
			wantAddDay[0] = String.valueOf(rightNow.get(Calendar.YEAR));

			wantAddDay[1] = String.valueOf(rightNow.get(Calendar.MONTH)+1);
			if (wantAddDay[1].length() < 2)
				wantAddDay[1] = "0" + wantAddDay[1];

			wantAddDay[2] = String.valueOf(rightNow.get(Calendar.DATE));
			if (wantAddDay[2].length() < 2)
				wantAddDay[2] = "0" + wantAddDay[2];
		}
		else
		{
			throw new NumberFormatException("날짜 스트링의 길이가 8이 아닙니다.");
		}

		return wantAddDay;
	}

	/** 정해진 날짜를 받아서 그 날짜에서 이전 날짜 또는 이후 날짜 구하기
	 * @param   wantDay 바꾸고자하는 날짜 형식 스트링(yyyyMMdd)
	 * @param   field 년(YEAR=1), 월(MONTH=2), 일(DATE=5) 자기가 바꾸고자 하는 필드의 값
	 * @param   amount 이후 및 이전(-) 으로 구하고자 값
	 * @return  구하고자 하는 날짜
	 * @since JDK1.2<br><p>
	 */
	public static final String getWantDay(String wantDay, int field, int amount)
	{
		if (wantDay.length() == 8)
		{
			int year = Integer.parseInt(wantDay.substring(0,4));
			int month = Integer.parseInt(wantDay.substring(4,6));
			int day = Integer.parseInt(wantDay.substring(6));

			Calendar rightNow = Calendar.getInstance();
			rightNow.set(year, month-1, day);
			rightNow.add(field, amount);
			String tmp_m = String.valueOf(rightNow.get(Calendar.MONTH)+1);
			if (tmp_m.length() < 2)
				tmp_m = "0" + tmp_m;
			String tmp_d = String.valueOf(rightNow.get(Calendar.DATE));
			if (tmp_d.length() < 2)
				tmp_d = "0" + tmp_d;
			return String.valueOf(rightNow.get(Calendar.YEAR)) + tmp_m + tmp_d;
		}
		else
		{
			throw new NumberFormatException("날짜 스트링의 길이가 8이 아닙니다.");
		}
	}

	/** sep 으로 구분된 String 형태의 날짜 데이터를 sep이 없이 붙인다. */
	public static final String toNullDateFormat(String str, String sep)
	{
		String total = "";

		if (str.length() > 10)
		{
			StringTokenizer strT = new StringTokenizer(str, sep);
			if (strT.hasMoreTokens() && (strT.countTokens() == 3))
			{
				//첫번째 토큰은 년을 나타낸다.
				String year = strT.nextToken();

				//두번째 토큰은 달을 나타낸다.
				String month = strT.nextToken();

				if (month.length() != 2)
				{
					month = "0"+month;
				}

				//세번째 토큰은 일을 나타낸다.
				String date  = strT.nextToken();

				if (date.length() != 2)
				{
					date = "0"+date;
				}

				total = year + month + date;
			}
			else
			{
				return null;
			}
		}
		else
		{
			throw new NumberFormatException("스트링의 길이가 10자를 넘어섭니다.");
		}

		return total;
	}

	/** 날짜 스트링 2개를 받아서 날짜 사이의 기간(일)을 구한다
	 * @param   from 이전날짜
	 * @param   to 이후날짜
	 * @param   form
	 * @return  날짜 사이의 기간
	 * @since JDK1.1<br><p>
	 */
	public static final int daysBetween(String from, String to, String form)
	{
		java.text.SimpleDateFormat formatter =	new java.text.SimpleDateFormat (form, java.util.Locale.KOREA);
		java.util.Date d1 = null;
		java.util.Date d2 = null;
		try
		{
			d1 = formatter.parse(from);
			d2 = formatter.parse(to);
		}
		catch(java.text.ParseException e)
		{
			return -999;
		}
		if (!formatter.format(d1).equals(from))
			return -999;
		if (!formatter.format(d2).equals(to))
			return -999;

		long duration = d2.getTime() - d1.getTime();

		if ( duration < 0 )
			return -999;

		return (int) (duration/(1000*60*60*24));
		// seconds in 1 day
	}

	/** Date 객체와 원하는 날짜형식의 포맷을 넘기면 그 포맷으로 현재날짜의 스트링을 구한다
	 * @param   date 포맷된 날짜로 바꿀 Date 객체
	 * @param   pattern 원하는 날짜 포맷 (ex] yyyyMMdd, yyyyMMddHHmmss, HHmm 등)
	 * @return  원하는 형식으로 포맷된 날짜 스트링
	 * @since JDK1.1<br><p>
	 */
	public static final String getDateFormat(java.util.Date date, String pattern)
	{
		SimpleDateFormat formatter = new SimpleDateFormat(pattern);
 		return formatter.format(date);
	}

	/** 주민번호 앞자리로 넘겨준 나이보다 많은지 적은지 평가
	 * @param   jumin_no 주민등록번호 앞6자리 또는, 년도 2자리
	 * @param   old 평가할 나이
	 * @return  int 평가 결과 값, 1:많다 0:같다 -1:적다
	 */
	public static final int oldCheck(String jumin_no, int old)
	{
		int year = 0;
		if (jumin_no.length()==6)
		{
			year = Integer.parseInt(jumin_no.substring(0, 2));
		}
		else if (jumin_no.length()==2)
		{
			year = Integer.parseInt(jumin_no);
		}
		else
		{
			throw new NumberFormatException("년도 입력 형식이 맞지 않습니다");
		}
		if (year < 10)
			year = 2000 + year;
		else
			year = 1900 + year;

		Calendar rightNow = Calendar.getInstance();
		int result = rightNow.get(Calendar.YEAR) - year;
		if (result > old)
		{
			return 1;
		}
		else if (result == old)
		{
			return 0;
		}
		else
		{
			return -1;
		}

	}
	public static final int ageCheck(Map item, String birth)
	{
		int year = 0;
			year = Integer.parseInt(birth.substring(0, 4));

			Calendar rightNow = Calendar.getInstance();
		int result = rightNow.get(Calendar.YEAR) - year;
			return result;
	}
	 /**
	  * 특정 날짜 요일구하기
	  * @param dat (yyyy-MM-dd or yyyyMMdd)
	  * @return sun, mon, tue, wed, thu, fri, sat
	  */
	 public static String getDayOfWeek(String dat){
	  dat = dat.replaceAll("-", "");

	  int yy = Integer.valueOf(dat.substring(0, 4)).intValue();
	  int mm = Integer.valueOf(dat.substring(4, 6)).intValue();
	  int dd = Integer.valueOf(dat.substring(6)).intValue();

	  String[] dayOfWeek={"sun","mon","tue","wed","thu","fri","sat"};
	        Calendar c= Calendar.getInstance();
	  c.set(yy  , mm -1 , dd );
	        return dayOfWeek[c.get(Calendar.DAY_OF_WEEK)-1];

	 }
	 public static long diffOfMinutes(String begin, String end) throws Exception
	  {
	    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	    
	    Date beginDate = formatter.parse(begin);
	    Date endDate = formatter.parse(end);

	    return (endDate.getTime() - beginDate.getTime()) / (60 * 1000);
	  }

	 	/** 해당월의 마지막날 구하기
		 * @return  해당월 마지막 날
		 * @since JDK1.2<br><p>
		 */
		public static final String getLastDay()
		{

			Calendar rightNow = Calendar.getInstance();
			
			return Integer.toString(rightNow.getMaximum(Calendar.DAY_OF_MONTH));
		}

}