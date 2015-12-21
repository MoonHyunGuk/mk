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
	 * ��ü�� null �Ǵ� "null"�̸� ""���� ����� �ش�.
	 * @param   obj not null�� ���� Object
	 * @return  "" �Ǵ� ��ü�� toString()�� ����
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
	 * ��ü�� ������(pure) null �̸� "" ���� ������ش�
	 * @param   obj not null�� ���� Object
	 * @return  "" �Ǵ� ��ü�� toString()�� ����
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
	 * ��ü�� ������(pure) null �̸� "" ���� ������ش�. �ƴϸ� ���� ��ü�� �ǵ��� �ش�.
	 * @param   obj not null�� ���� Object
	 * @return  "" �Ǵ� ���� Object ��ü
	 */
	public static final Object notObjNull(Object obj)
	{
		if (null == obj)
			return EMPTY_STR;
		else
			return obj;
	}

	/**
	 * ��ü�� null �Ǵ� "null" �Ǵ� "" �̸� true ����
	 * @param   obj null ���� �Ǵ��� ��ü
	 * @return  null �Ǵ� "" �Ǵ� "null" �̸� true
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
	 * ������(pure) null ������ üũ, ���� null�̸� true�� ����
	 * @param   obj null ���� �Ǵ��� ��ü
	 * @return  ��ü�� (pure) null �̸� true
	 */
	public static final boolean isPureNull(Object obj)
	{
		if (obj == null)
			return true;
		else
			return false;
	}

	/**
	 * Object�� null �Ǵ� "null" �̸� "0"���� ����� �ش�
	 * @param   obj notNull�� ���� String
	 * @return  "0" �Ǵ� ������ String
	 */
	public static final String nullToZero(Object obj)
	{
		if (null==obj || EMPTY_STR.equals(obj) || NULL_STR.equals(obj))
			return "0";
		else
			return obj.toString();
	}

	/**
	 * String�� null �Ǵ� "null" �̸� "0"���� ����� �ش�
	 * @param   str notNull�� ���� String
	 * @return  "0" �Ǵ� ������ String
	 */
	public static final String nullToZero(String str)
	{
		if (null==str || EMPTY_STR.equals(str) || NULL_STR.equals(str))
			return "0";
		else
			return str;
	}

	/**
	 * xxxxxx �Ǵ� xxx-xxx ������ �����ȣ�� xxx, xxx �� ������.
	 * @param   str �ΰ��� ¥�� �����ȣ(���̰� 6 �Ǵ� 7, 7�� ��� �߰��� "-" ����), ���̰� ���� ������ NumberFormatException �߻�
	 * @return  ���� ��Ʈ�� �ΰ��� ��Ʈ���迭�� ��Ƽ� ����
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
		else if (len == 7)  // �߰��� "-" ���� ���
		{
			String[] post = new String[2];
			post[0] = str.substring(0,3);
			post[1] = str.substring(4);
			return post;
		}
		else
		{
			throw new NumberFormatException("�����ȣ ���ڿ��� ���̰� 6 �Ǵ� 7(- ����)�̾�� �մϴ�.");
		}
	}

	/**
	 * Object�� �޾Ƽ� "" �Ǵ� null �Ǵ� "null" �̸� &nbsp;�� �ٲ��ְ�, �ƴϸ� ��ü�� toString()�� ����
	 * @param   obj
	 * @return  "" �Ǵ� null �̸� &nbsp; NULL�� �ƴϸ� ��ü�� toString()
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
	 * String�� �޾Ƽ� ""�Ǵ� null �Ǵ� "null" �̸� &nbsp;�� �ٲ��ش�
	 * @param   str �ٲ� String
	 * @return  "" �Ǵ� null �̸� &nbsp;
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
	 * ���ϴ� ��Ʈ���� �����ڷ� ©�� ������ ���̸�ŭ�� �迭�� �������ش�
	 * @param   spritData �������� �ϴ� ��Ʈ��(NULL üũ ���� ����)
	 * @param   delim �����ϱ� ���� ������
	 * @return  ���� ��Ʈ���� �迭�� ��Ƽ� ����
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
	 * ����ڵ�Ϲ�ȣ�� 000-00-00000 �������� ���������� �����ϰ� 3���� ������
	 * @param   no ����ڵ�Ϲ�ȣ, null�� ������ �ȵȴ�. null üũ ����.
	 * @return  ���� ��Ʈ���� �迭�� ��Ƽ� ����
	 */
	public static final String[] spritBusinessNo(String no)
	{
		String[] busino = new String[3];
		if (no.length() == 10)
		{
			busino[0] = no.substring(0, 3);   // ó�� ���ڸ� ¥����
			busino[1] = no.substring(3, 5);   // �ι�° ���ڸ� ¥����
			busino[2] = no.substring(5);      // ������ �ټ��ڸ� ¥����
			return busino;
		}
		else
		{
			throw new NumberFormatException("����ڵ�Ϲ�ȣ�� ���̰� 10�� �ƴմϴ�.");
		}
	}

	/**
	 * List�� ��� ��ҵ��� �����ڷ� �����Ͽ� String���� ����
	 * @param   list List �������̽��� ������ ��ҵ��� ��� ��ü
	 * @param   delim ������ ������ String
	 * @return  ��ҵ��� �����ڷ� ������ String
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
			throw new IllegalArgumentException("����� ������ 0���� ũ�� �ʽ��ϴ�.");
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
	 * String �迭�� ���� ������� �и��� ���ڿ��� �����ڸ� �־ �ϳ��� ���ڿ��� ��ġ�� ��쿡 ����Ѵ�.
	 * @param   arr �迭�� ��� �и��� ���ڵ�
	 * @param   div ������
	 * @return  �����ڷ� ������ ���ڿ�
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
	 * ������ ���̿��� ���ڿ��� �տ� ���ϴ� ���� ä���
	 * @param total_length �� ����
	 * @param fillChar ������ ä������ ���ڿ�
	 * @param s ��ȯ�� ���ڿ�
	 * @return fillChar�� ���ڸ� ���̸�ŭ ä���� ��ȯ�� ���ڿ�
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
	 * �������ڿ��� ��Ī�Ǵ� ���ڿ��� ��� ã�Ƽ� �ٲ��ش�. replaceFirst �޼ҵ带 ���ȣ���Ѵ�. ���� �ʵ��� �Ѵ�.
	 * @param   original ���� ���ڿ�
	 * @param   toBeReplaced �ٲ������� ����
	 * @param   replacement �ٲ� ����
	 * @return  �ٲ���� ���ڿ�
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
	 * �������ڿ��� ��Ī�Ǵ� ��ó���� ��Ÿ���� ���ڿ��� ã�Ƽ� �ٲ��ش�. ���� �ʵ��� �Ѵ�.
	 * @param   original     ���� ���ڿ�
	 * @param   toBeReplaced  �ٲ������� ����
	 * @param   replacement  �ٲ� ����
	 * @return  �ٲ���� ���ڿ�
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
	 * �ԷµǴ� ��ȭ��ȣ �� ������ȣ�� ����ȣ�� '0'�� �����Ͽ� �����Ѵ�.
	 * @param   tel ������ȣ �Ǵ� ����ȣ
	 * @param   delim �Էµ� ����Ÿ�� ������ȣ���� ����ȣ���� �����ϱ� ���� ������(1 : ������ȣ, 2 : ����ȣ)
	 * @param   ln '0'�� �������� ���ϵǴ� ����Ÿ�� ����(������ȣ : 3, ����ȣ : 4 �� �Է�)
	 * @return  ��ȭ��ȣ
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
	 * ',' ���е� �����Ͱ� �Ѿ�� �� ,, ���Ӵ����͸�  , ,�� ����
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
	 * ����Ŭ lpad ����� ��ƿ
	 * str �Է°� , size �ڸ��� , fStr �Է°��տ� �� ���� 
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