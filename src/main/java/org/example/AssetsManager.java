package org.example;

import java.sql.*;
import java.util.Scanner;


public class AssetsManager {
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
    public static void assetsMenu(){
        Scanner sc = new Scanner(System.in);

        System.out.println("===== 자산 관리 =====");
        System.out.println("1. 자산 조회");
        System.out.println("2. 은행 전체 자산 조회");
        System.out.print("선택: ");
        int choice = sc.nextInt();
        sc.nextLine(); // 개행 문자 제거

        switch (choice) {
            case 1:
                viewAssets();
                return;
            case 2:
                viewAllAssets();
                return;
            default:
                System.out.println("잘못된 선택입니다. 다시 시도하세요.");
        }
        sc.close();
    }



    private static void viewAssets() {
        Scanner sc = new Scanner(System.in);
        System.out.println("조회할 은행의 이름을 입력하십시오.");
        String branch_name = sc.nextLine();
        try (Connection connection = DriverManager.getConnection(url, user, password)) {
            String sql = "SELECT branch_id, branch_name, Assets FROM branch WHERE branch_name = ?";

            try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
                pstmt.setString(1, branch_name); // ? 자리에 branch_name 입력값 설정

                try (ResultSet rs = pstmt.executeQuery()) {
                    System.out.println("===== 자산 조회 결과 =====");
                    boolean hasResults = false; // 결과가 있는지 확인
                    while (rs.next()) {
                        hasResults = true;
                        System.out.println("Branch ID: " + rs.getInt("branch_id"));
                        System.out.println("Branch Name: " + rs.getString("branch_name"));
                        System.out.println("Assets: " + rs.getString("Assets"));
                    }
                    if (!hasResults) {
                        System.out.println("해당 이름의 은행 지점이 없습니다.");
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("데이터베이스 오류 발생: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("오류 발생: " + e.getMessage());
        }
    }


    private static void viewAllAssets() {
        try (Connection connection = DriverManager.getConnection(url, user, password)) {
            String sql = "SELECT SUM(Assets) AS total_assets FROM branch";

            try (PreparedStatement pstmt = connection.prepareStatement(sql);
                 ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    long totalAssets = rs.getLong("total_assets");
                    System.out.println("===== 전체 자산 합계 =====");
                    System.out.println("총 자산: " + totalAssets);
                } else {
                    System.out.println("테이블에 데이터가 없습니다.");
                }
            }
        } catch (SQLException e) {
            System.err.println("데이터베이스 오류 발생: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("오류 발생: " + e.getMessage());
        }
    }


}