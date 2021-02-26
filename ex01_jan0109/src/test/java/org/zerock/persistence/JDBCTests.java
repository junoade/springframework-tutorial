package org.zerock.persistence;

//0110 ch3 Oracle DB와의 JDBC 연결 테스트 예제
import static org.junit.Assert.fail;

import java.sql.Connection;
import java.sql.DriverManager;

import org.junit.Test;

import lombok.extern.log4j.Log4j;

@Log4j
public class JDBCTests {
	static {
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			System.out.println("가동");
		}catch(Exception e) {
			e.printStackTrace();
		}
		
	}
	@Test
	public void testConnection() {
		/*try(Connection con = DriverManager.getConnection("jdbc:oracle:thin:@Practice_Jan:1521:XE", "book_ex", "7572")){*/
		try(Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE",
				"JUNHO",
				"7572")){
		
			log.info(con);
		}catch(Exception e) {
			System.out.println("실패");
			fail(e.getMessage());
			
		}
		
	}
}
