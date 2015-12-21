import java.io.*;
import java.util.ArrayList;
import java.util.List;


public class Test {
	
	public static List<String> listReadLine = new ArrayList<String>();

	/**
	 * @param args
	 */
	public static void main(String[] args){
		// TODO Auto-generated method stub
		
		BufferedReader br = new BufferedReader(new InputStreamReader(System.in) );	
		String strInputText;
		//String arryTmp[10] = new ArrayList();
		
		
		try {
			//데이터 가져오기
			salesData();
			
			for(int i=0;i<listReadLine.size();i++) {
				System.out.println(listReadLine.get(i));
				
			}
			
			System.out.println("입력(o[order]:주문 , q[quit]:종료: ");
			while(true) {
				strInputText = br.readLine();
				
				if("q".equals(strInputText) || "Q".equals(strInputText)) {
					System.out.println("종료합니다.");
					break;
				} else if ("o".equals(strInputText) || "O".equals(strInputText)) {
					System.out.println("상품번호 : ");
				}	else {
					System.out.println("주문번호를 입력하십시오1 : ");
				}
			}
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println("Error========================");
		}
	}
	
	public  static void salesData() throws IOException {
		String strReadLine = "";
		
		BufferedReader br = null;
		
		try {
			InputStreamReader isr = new InputStreamReader(new FileInputStream("C:/database.txt"));
			br = new BufferedReader(isr);
			
			while((strReadLine = br.readLine()) != null) {
				listReadLine.add(strReadLine);
			}
			br.close();
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println("Error========================"+e);
		} finally {
			if(br != null) {
				br.close();
			}
		}
	}

}
