package org.example;

import java.util.Scanner;

import static org.example.CustomerMode.*;
import static org.example.ManagerMode.*;

public class Main {
    private static String url;
    private static String user;
    private static String password;

    public static void main(String[] args) {
        //DatabaseAuthInformation 인스턴스 생성 후 연결정보 파싱
        DatabaseAuthInformation authInfo = new DatabaseAuthInformation();
        boolean success = authInfo.parse_auth_info("src/main/resources/mysql.auth");
        if (!success) {
            System.out.println("Failed to parse authentication information.");
            return;
        }

        //파싱한 정보로 데이터베이스 연결 설정
        url = "jdbc:mysql://" + authInfo.getHost() + ":" + authInfo.getPort() + "/" + authInfo.getDatabase_name();
        user = authInfo.getUsername();
        password = authInfo.getPassword();

        //EmployeeManager & CustomerManager로 db 연결정보 전달
        EmployeeManager.initDatabase(url, user, password);
        CustomerMode.initDatabase(url, user, password);

        while (true) {
            printMenu();
        }

    }


    public static void printMenu() {
        Scanner sc = new Scanner(System.in);

        System.out.println("===== 메인 메뉴 =====");
        System.out.println("1. 관리자 모드");
        System.out.println("2. 고객 모드");
        System.out.println("3. 종료");
        System.out.print("선택: ");
        int choice = sc.nextInt();
        sc.nextLine(); // 개행 문자 제거

        switch (choice) {
            case 1:
                ManagerMenu();
                return;
            case 2:
                customerMenu();
                return;
            case 3:
                System.out.println("서비스를 종료합니다.");
                System.exit(0); // 프로그램 종료
                break;
            default:
                System.out.println("잘못된 선택입니다. 다시 시도하세요.");
        }
        sc.close();
    }
}