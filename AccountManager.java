package org.example;

import java.sql.*;
import java.util.Scanner;

public class AccountManager {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/bank";
    private static final String DB_USER = "your_username";
    private static final String DB_PASSWORD = "your_password";

    public void createAccount() {
        Scanner scanner = new Scanner(System.in);

        System.out.println("Enter Account ID (acc_id): ");
        long accId = scanner.nextLong();

        System.out.println("Enter Customer ID (customer_id): ");
        long customerId = scanner.nextLong();

        System.out.println("Enter Account Field (1, 2, or 3): ");
        String field = scanner.next();

        System.out.println("Enter Password (max 20 characters): ");
        String password = scanner.next();

        // 현재 시간을 계좌 생성 시각으로 사용
        Timestamp createdAt = new Timestamp(System.currentTimeMillis());

        // INSERT 쿼리
        String insertQuery = "INSERT INTO account (acc_id, customer_id, Field, created_at, password, is_deleted) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement preparedStatement = connection.prepareStatement(insertQuery)) {

            // 파라미터 설정
            preparedStatement.setLong(1, accId);
            preparedStatement.setLong(2, customerId);
            preparedStatement.setString(3, field);
            preparedStatement.setTimestamp(4, createdAt);
            preparedStatement.setString(5, password);
            preparedStatement.setBoolean(6, false); // 기본값 false 설정

            // 실행
            int rowsAffected = preparedStatement.executeUpdate();

            if (rowsAffected > 0) {
                System.out.println("Account successfully created!");
            }

        } catch (SQLException e) {
            // 트리거에서 발생한 오류 처리
            if (e.getSQLState().equals("45000")) { // 45000: 트리거 오류
                System.err.println("Error: " + e.getMessage());
            } else if (e.getErrorCode() == 1062) { // 1062: MySQL Duplicate Entry (PK 충돌)
                System.err.println("Error: Account ID already exists. Please use a different Account ID.");
            } else {
                System.err.println("Database error: " + e.getMessage());
            }
        } finally {
            scanner.close();
        }
    }
}