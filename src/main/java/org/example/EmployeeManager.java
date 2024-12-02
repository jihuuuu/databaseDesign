package org.example;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Scanner;

public class EmployeeManager {
    private static String url;
    private static String user;
    private static String password;
    //데이터베이스와 연결하기 위한 메소드
    public static void initDatabase(String dbUrl, String dbUser, String dbPassword) {
        url = dbUrl;
        user = dbUser;
        password = dbPassword;
    }
    //옵션 선택
    public static void adminMenu() {
        Scanner sc = new Scanner(System.in);

        while (true) {
            System.out.println("===== 관리자 모드 =====");
            System.out.println("1. 직원 추가");
            System.out.println("2. 직원 조회");
            System.out.println("3. 직원 정보 수정");
            System.out.println("4. 직원 삭제");
            System.out.print("선택: ");
            int choice = sc.nextInt();
            sc.nextLine(); // 개행 문자 제거

            switch (choice) {
                case 1:
                    hireEmployee();
                    break;
                case 2:
                    viewEmployees();
                    break;
                case 3:
                    updateEmployee();
                    break;
                case 4:
                    deleteEmployee();
                    break;
                default:
                    System.out.println("잘못된 선택입니다. 다시 시도하세요.");
            }
            return; //메인 메뉴로 돌아가기
        }
    }

    // 직원 추가
    public static void hireEmployee() {
        Scanner sc = new Scanner(System.in);

        try (Connection connection = DriverManager.getConnection(url, user, password)) {
            System.out.println("직원 세부정보를 입력하세요.");
            System.out.print("이름: ");
            String name = sc.nextLine();
            System.out.print("주민번호: ");
            String social_num = sc.nextLine();
            System.out.print("연락처: ");
            String phone_num = sc.nextLine();
            System.out.print("주소: ");
            String address = sc.nextLine();
            System.out.print("입사일 (예: yyyy-MM-dd HH:mm:ss): ");
            String hire_date_inString = sc.nextLine();
            Timestamp hire_date = convertStringToTimestamp(hire_date_inString, "yyyy-MM-dd HH:mm:ss");
            System.out.print("월급: ");
            long salary = sc.nextLong();

            //manager_id 차례로 할당받도록 함
            String getMaxIdQuery = "SELECT MAX(employee_id) AS max_id FROM manager";
            int nextManagerId = 1; // 기본값 설정 (테이블에 데이터가 없는 경우 1로 시작)

            try (Statement stmt = connection.createStatement();
                 ResultSet rs = stmt.executeQuery(getMaxIdQuery)) {
                if (rs.next()) {
                    int maxId = rs.getInt("max_id");
                    nextManagerId = maxId + 1; // 현재 최대 ID에 1을 더함
                }
            }

            String insertManagerQuery = "INSERT INTO manager (employee_id) VALUES (?)";
            try (PreparedStatement pstmt = connection.prepareStatement(insertManagerQuery)) {
                pstmt.setInt(1, nextManagerId);
                pstmt.executeUpdate();
            }

            String sql = "INSERT INTO manager_details (manager_details_id, name, social_num, phone_num, address, hire_date, salary) VALUES (?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
                pstmt.setInt(1, nextManagerId);
                pstmt.setString(2, name);
                pstmt.setString(3, social_num);
                pstmt.setString(4, phone_num);
                pstmt.setString(5, address);
                pstmt.setTimestamp(6, hire_date);
                pstmt.setLong(7, salary);

                int rowsInserted = pstmt.executeUpdate();
                if (rowsInserted > 0) {
                    System.out.println("직원 정보가 성공적으로 추가되었습니다.");
                } else {
                    System.out.println("직원 정보를 추가하지 못했습니다.");
                }
            }
        } catch (Exception e) {
            System.err.println("오류 발생: " + e.getMessage());
        }
    }

    // 직원 조회
    public static void viewEmployees() {
        try (Connection connection = DriverManager.getConnection(url, user, password)) {
            String sql = "SELECT * FROM manager_details";
            try (Statement stmt = connection.createStatement();
                 ResultSet rs = stmt.executeQuery(sql)) {
                System.out.println("===== 직원 목록 =====");
                while (rs.next()) {
                    System.out.println("ID: " + rs.getLong("manager_details_id"));
                    System.out.println("이름: " + rs.getString("name"));
                    System.out.println("주민번호: " + rs.getString("social_num"));
                    System.out.println("연락처: " + rs.getString("phone_num"));
                    System.out.println("주소: " + rs.getString("address"));
                    System.out.println("입사일: " + rs.getTimestamp("hire_date"));
                    System.out.println("월급: " + rs.getLong("salary"));
                    System.out.println("----------------------");
                }
            }
        } catch (Exception e) {
            System.err.println("오류 발생: " + e.getMessage());
        }
    }

    // 직원 정보 수정
    public static void updateEmployee() {
        Scanner sc = new Scanner(System.in);

        try (Connection connection = DriverManager.getConnection(url, user, password)) {
            System.out.print("수정할 직원의 ID를 입력하세요: ");
            long id = sc.nextLong();
            sc.nextLine(); // 개행 문자 제거

            System.out.print("새 이름 (현재 값을 유지하려면 Enter): ");
            String name = sc.nextLine();
            System.out.print("새 연락처 (현재 값을 유지하려면 Enter): ");
            String phone_num = sc.nextLine();
            System.out.print("새 주소 (현재 값을 유지하려면 Enter): ");
            String address = sc.nextLine();
            System.out.print("새 월급 (현재 값을 유지하려면 Enter): ");
            String salaryInput = sc.nextLine();

            String sql = "UPDATE manager_details SET "
                    + "name = COALESCE(NULLIF(?, ''), name), "
                    + "phone_num = COALESCE(NULLIF(?, ''), phone_num), "
                    + "address = COALESCE(NULLIF(?, ''), address), "
                    + "salary = COALESCE(NULLIF(?, ''), salary) "
                    + "WHERE manager_details_id = ?";
            try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
                pstmt.setString(1, name);
                pstmt.setString(2, phone_num);
                pstmt.setString(3, address);
                pstmt.setString(4, salaryInput.isEmpty() ? null : salaryInput);
                pstmt.setLong(5, id);

                int rowsUpdated = pstmt.executeUpdate();
                if (rowsUpdated > 0) {
                    System.out.println("직원 정보가 성공적으로 수정되었습니다.");
                } else {
                    System.out.println("해당 ID의 직원을 찾을 수 없습니다.");
                }
            }
        } catch (Exception e) {
            System.err.println("오류 발생: " + e.getMessage());
        }
    }

    // 직원 삭제
    public static void deleteEmployee() {
        Scanner sc = new Scanner(System.in);

        try (Connection connection = DriverManager.getConnection(url, user, password)) {
            System.out.print("삭제할 직원의 ID를 입력하세요: ");
            long id = sc.nextLong();
            connection.setAutoCommit(false);
            try{

                // 첫 번째 SQL 실행
                String sqlUpdate = "UPDATE manager SET is_deleted = 1 WHERE employee_id = ?";
                try (PreparedStatement pstmtUpdate = connection.prepareStatement(sqlUpdate)) {
                    pstmtUpdate.setLong(1, id);
                    pstmtUpdate.executeUpdate();
                }

                // 두 번째 SQL 실행
                String sqlDelete = "DELETE FROM manager_details WHERE manager_details_id = ?";
                try (PreparedStatement pstmtDelete = connection.prepareStatement(sqlDelete)) {
                    pstmtDelete.setLong(1, id);
                    int rowsDeleted = pstmtDelete.executeUpdate();
                    if (rowsDeleted > 0) {
                        System.out.println("직원 정보가 성공적으로 삭제되었습니다.");
                    } else {
                        System.out.println("해당 ID의 직원을 찾을 수 없습니다.");
                    }
                }
                //transaction
                connection.commit();
            }catch (SQLException e) {
                // 오류 발생 시 롤백
                connection.rollback();
                System.err.println("오류 발생으로 트랜잭션 롤백: " + e.getMessage());
            }
        } catch (Exception e) {
            System.err.println("오류 발생: " + e.getMessage());
        }
    }

    // 날짜 문자열을 Timestamp로 변환
    public static Timestamp convertStringToTimestamp(String dateTime, String format) {
        if (dateTime == null) return null;

        try {
            Date date = new SimpleDateFormat(format).parse(dateTime);
            return new Timestamp(date.getTime());
        } catch (Exception e) {
            return null;
        }
    }


}
