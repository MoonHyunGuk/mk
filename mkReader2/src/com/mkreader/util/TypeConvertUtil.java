package com.mkreader.util;

public class TypeConvertUtil {
	
	private static Boolean defaultBoolean = Boolean.FALSE;
	private static Byte defaultByte = new Byte((byte) 0);
	private static Character defaultCharacter = new Character(' ');
	private static Double defaultDouble = new Double((double) 0.0);
	private static Float defaultFloat = new Float((float) 0.0);
	private static Integer defaultInteger = new Integer(0);
	private static Long defaultLong = new Long((long) 0);
	private static Short defaultShort = new Short((short) 0);

	/**
	 * <p>value 객체�? String?��?���? �??��?�� 반환?��?��.</p>
	 * <p>만약 value �? null?�� 경우?�� null?�� 반환?��?��.</p>
	 * 
	 * @param value �??��?�� ?��?��?�� 객체
	 * @return �??��?�� String 객체
	 */
	public static String convert(Object value) {
		if (value == null) {
			return null;
		} else {
			return value.toString();
		}
	}

	/**
	 * String?��?�� 값을 Class ????��?���? �??��?�� 반환?��?��<p>
	 * �??��?��?�� ????��??? Integer, Boolean, Double, Short, Float, Long, Character, Byte?���?, <p>
	 * ?��?��?���? ?��?�� ????��?�� 경우?��?�� String ?���? �??��?��?��.
	 * 
	 * @param value �??��?�� �?
	 * @param type �??��?��?�� ????��
	 * @return �??��?�� ????��?�� 객체
	 */
	public static Object convert(String value, Class type) {
		if (type == java.lang.String.class) {
			return value;
		} else if(type == java.lang.Integer.class || type == int.class) {
			return convertInteger(value, null);
		} else if(type == java.lang.Boolean.class || type == boolean.class) {
			return convertBoolean(value, null);
		} else if(type == java.lang.Double.class || type == double.class) {
			return convertDouble(value, null);
		} else if(type == java.lang.Short.class || type == short.class) {
			return convertShort(value, null);
		} else if(type == java.lang.Float.class || type == float.class) {
			return convertFloat(value, null);
		} else if(type == java.lang.Long.class || type == long.class) {
			return convertLong(value, null);
		} else if(type == java.lang.Character.class || type == char.class) {
			return convertCharacter(value, null);
		} else if(type == java.lang.Byte.class || type == byte.class) {						
			return convertByte(value, null);
		} else {
			if(value == null) {
				return null;
			} else {
				return value.toString();
			}
		}
	}
	
    /**
     * @param value
     * @param type
     * @param defaultValue
     * @return
     */
    public static Object convert(String value, Class type, Object defaultValue) {
		if (type == java.lang.String.class) {
			return value;
		} else if(type == java.lang.Integer.class || type == int.class) {
			return (defaultValue == null) ? convertInteger(value, null) : convertInteger(value, (Integer)defaultValue);
		} else if(type == java.lang.Boolean.class || type == boolean.class) {
		    return (defaultValue == null) ? convertBoolean(value, null) : convertBoolean(value, (Boolean)defaultValue);
		} else if(type == java.lang.Double.class || type == double.class) {
		    return (defaultValue == null) ? convertDouble(value, null) : convertDouble(value, (Double)defaultValue);
		} else if(type == java.lang.Short.class || type == short.class) {
		    return (defaultValue == null) ? convertShort(value, null) : convertShort(value, (Short)defaultValue);
		} else if(type == java.lang.Float.class || type == float.class) {
			return (defaultValue == null) ? convertFloat(value, null) : convertFloat(value, (Float)defaultValue);
		} else if(type == java.lang.Long.class || type == long.class) {
			return (defaultValue == null) ? convertLong(value, null) : convertLong(value, (Long)defaultValue);
		} else if(type == java.lang.Character.class || type == char.class) {
		    return (defaultValue == null) ?  convertCharacter(value, null) : convertCharacter(value, (Character)defaultValue);
		} else if(type == java.lang.Byte.class || type == byte.class) {						
		    return (defaultValue == null) ?  convertByte(value, null) : convertByte(value, (Byte)defaultValue);
		} else {
			if(value == null) {
				return defaultValue;
			} else {
				return value.toString();
			}
		}
    }	

	public static Object convert(String values[], Class clazz) {
		Class type = clazz.getComponentType();
		if(type == java.lang.String.class) {
			if(values == null) {
				return null;
			} else {
				return values;
			}
		}
	
		int length = values.length;
		if(type == java.lang.Integer.class) {
			int[] array = new int[length];
			for(int i = 0; i < length; i++) {
				array[i] = convertInteger(values[i], defaultInteger).intValue();
			}
			return array;
		} else if(type == java.lang.Boolean.class) {
			boolean[] array = new boolean[length];
			for(int i = 0; i < length; i++) {
				array[i] = convertBoolean(values[i], defaultBoolean).booleanValue();
			}
			return array;
		} else if(type == java.lang.Double.class) {
			double[] array = new double[length];
			for(int i = 0; i < length; i++) {
				array[i] = convertDouble(values[i], defaultDouble).doubleValue();
			}
			return array;
		} else if(type == java.lang.Short.class) {
			short[] array = new short[length];
			for(int i = 0; i < length; i++) {
				array[i] = convertShort(values[i], defaultShort).shortValue();
			}
			return array;
		} else if(type == java.lang.Float.class) {
			float[] array = new float[length];
			for(int i = 0; i < length; i++) {
				array[i] = convertFloat(values[i], defaultFloat).floatValue();
			}
			return array;
		} else if(type == java.lang.Long.class) {
			long[] array = new long[length];
			for(int i = 0; i < length; i++) {
				array[i] = convertLong(values[i], defaultLong).longValue();
			}
			return array;
		} else if(type == java.lang.Character.class) {
			char[] array = new char[length];
			for(int i = 0; i < length; i++) {
				array[i] = convertCharacter(values[i], defaultCharacter).charValue();
			}
			return array;
		} else if(type == java.lang.Byte.class) {						
			byte[] array = new byte[length];
			for(int i = 0; i < length; i++) {
				array[i] = convertByte(values[i], defaultByte).byteValue();
			}
			return array;
		} else {
			if(values == null) {
				return null;
			} else {
				String[] array = new String[length];
				for(int i = 0; i < length; i++) {
					array[i] = values[i].toString();
				}
				return array;
			}
		}		
	}

	//

	public static String convertString(Boolean value) {
		return convertString(value.booleanValue());
	}

	public static String convertString(boolean value) {
		return convertString(value, "Y", "N");
	}

	/**
	 *  boolean?��?�� 값을 String?��?���? �??��?��?��
	 * 
	 * @param value boolean?��?�� �?
	 * @param trueValue true?��?�� �??��?�� String �?
	 * @param falseValue false?��??? �??��?�� String �?
	 * @return ?��?��?��?�� boolean?��?�� String값을 반환?��?��?�� 
	 */
	public static String convertString(boolean value, String trueValue, String falseValue) {
		if (value) {
			return trueValue;
		} 
		return falseValue;
	}






	//

	/**
	 * String 값을 boolean?��?���? �??��?�� 반환?��?��.
	 */
	public static boolean convertBoolean(String value, boolean defaultValue) {
		return convertBoolean(value, new Boolean(defaultValue)).booleanValue();
	}

	/**
	 * String 값을 boolean?��?���? �??��?�� 반환?��?��.
	 */
	public static boolean convertBoolean(String value, boolean defaultValue, String trueString) {
		return convertBoolean(value, new Boolean(defaultValue), trueString).booleanValue();
	}
	
	/**
	 * String 값을 Boolean?��?���? �??��?�� 반환?��?��.<p>
	 * 만약 String 값이 yes, true, on, y?��?��?�� true값으�?,<p>
	 * no, false, off, n?��?��?�� false값으�? �??��?��?��.<p>
	 * ?�� �?�? ?�� ?��?��?���? ?��???경우?�� 기본값으�? �??��?��?��.
	 * 
	 * @param value ?���? �?
	 * @param defaultValue 기본�?
	 * @return Boolean �?
	 */
	public static Boolean convertBoolean(String value, Boolean defaultValue) {
		if (value == null) 	{
			return defaultValue;
		} else if (value.equalsIgnoreCase("yes") ||
						value.equalsIgnoreCase("true") ||
						value.equalsIgnoreCase("on") ||
						value.equalsIgnoreCase("y") ) {
			return Boolean.TRUE;
		} else if(value.equalsIgnoreCase("no") ||
						value.equalsIgnoreCase("false") ||
						value.equalsIgnoreCase("off") ||
						value.equalsIgnoreCase("n") ) {
			return Boolean.FALSE;
		} else {
			return defaultValue;
		}
	}
	
	/**
	 * ?��?��링을 boolean 값으�? �??��?��?��
	 * @param value
	 * @param defaultValue
	 * @param trueString
	 * @return
	 */
	public static Boolean convertBoolean(String value, Boolean defaultValue, String trueString) {
		if (value == null) 	{
			return defaultValue;
		} else if (value.equalsIgnoreCase(trueString)) {
			return Boolean.TRUE;
		} else {
			return defaultValue;
		}
	}
	/**
	 * ?��?��링을 byte�? �??��?��?��.
	 * @param value
	 * @param defaultValue
	 * @return
	 */
	public static byte convertByte(String value, byte defaultValue) {
		return convertByte(value, new Byte(defaultValue)).byteValue();
	}

	public static Byte convertByte(String value, Byte defaultValue) {
		try {
			return new Byte(value);
		} catch (NumberFormatException e) {
			return defaultValue;
		}
	}

	public static char convertChar(String value, char defaultValue) {
		return convertCharacter(value, new Character(defaultValue)).charValue();		
	}

	public static char convertCharacter(String value, char defaultValue) {
		return convertChar(value, defaultValue);
	}

	public static Character convertCharacter(String value, Character defaultValue) {
		if(value == null || value.length() == 0) {
			return defaultValue;
		} else {
			return new Character(value.charAt(0));
		}
	}

	public static int convertInt(String value, int defaultValue) {
		return convertInteger(value, new Integer(defaultValue)).intValue();
	}
	
	public static int convertInt(Object value, int defaultValue) {
	    int result = defaultValue;
	    if (value != null) {
		    if (value instanceof Integer) {
		        result = ((Integer)value).intValue();
		    } else {
		        result = convertInteger(value.toString(), new Integer(defaultValue)).intValue();
		    }	        
	    }
		return result;
	}
	
	public static int[] convertInt(String[] valueArray, int defaultValue) {
	    int[] result = null;
	    if (valueArray != null) {
	        result = new int[valueArray.length];
	        for (int i = 0; i < valueArray.length; i++) {
	            result[i] = convertInteger(valueArray[i], new Integer(defaultValue)).intValue();
	        }
	    }
		return result;
	}

	public static int convertInteger(String value, int defaultValue) {
		return convertInt(value, defaultValue);
	}

	public static Integer convertInteger(String value, Integer defaultValue) {
        if (value == null) {
            return defaultValue;
        }
		try {
			return new Integer(value);
		} catch (NumberFormatException e) {
			return defaultValue;
		}
	}

	public static double convertDouble(String value, double defaultValue) {
		return convertDouble(value, new Double(defaultValue)).doubleValue();
	}

	public static Double convertDouble(String value, Double defaultValue) {
        if (value == null) {
            return defaultValue;
        }
		try {
			return new Double(value);
		} catch (NumberFormatException e) {
			return defaultValue;
		}
	}

	public static float convertFloat(String value, float defaultValue) {
		return convertFloat(value, new Float(defaultValue)).floatValue();
	}
	public static Float convertFloat(String value, Float defaultValue) {
        if (value == null) {
            return defaultValue;
        }
		try {
			return new Float(value);
		} catch (NumberFormatException e) {
			return defaultValue;
		}
	}

	public static long convertLong(String value, long defaultValue) {
		return convertLong(value, new Long(defaultValue)).longValue();
	}
	public static Long convertLong(String value, Long defaultValue) {
        if (value == null) {
            return defaultValue;
        }
		try {
			return new Long(value);
		} catch (NumberFormatException e) {
			return defaultValue;
		}
	}	

	public static short convertShort(String value, short defaultValue) {
		return convertShort(value, new Short(defaultValue)).shortValue();
	}

	public static Short convertShort(String value, Short defaultValue) {
        if (value == null) {
            return defaultValue;
        }
		try {
			return new Short(value);
		} catch (NumberFormatException e) {
			return defaultValue;
		}
	}



}
