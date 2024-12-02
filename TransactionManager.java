package org.example;

import java.sql.*;
import java.util.Scanner;

public class TransactionManager {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/bank_db"; // 데이터베이스 URL
    private static final String DB_USER = "root"; // DB 사용자 이름
    private static final String DB_PASSWORD = "0000"; // DB 비밀번호

    // 비밀번호 확인 메서드
    private boolean verifyPassword(Connection connection, long accId, String password) throws SQLException {
        String query = "SELECT password FROM account WHERE acc_id = ? AND is_deleted = false";
        try (PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setLong(1, accId);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                String storedPassword = resultSet.getString("password");
                return storedPassword.equals(password);
            }
        }
        return false;
    }

    // 입금 메서드
    public void deposit() {
        Scanner scanner = new Scanner(System.in);

        System.out.println("Enter Account ID (acc_id): ");
        long accId = scanner.nextLong();

        System.out.println("Enter Password: ");
        String password = scanner.next();

        System.out.println("Enter Deposit Amount: ");
        double amount = scanner.nextDouble();

        String updateQuery = "UPDATE account SET balance = balance + ? WHERE acc_id = ? AND is_deleted = false";
        String transactionQuery = "INSERT INTO transaction (acc_id, date, type) VALUES (?, NOW(), 'DEPOSIT')";
        String depositQuery = "INSERT INTO deposit (transaction_id, amount) VALUES (?, ?)";

        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement updateStatement = connection.prepareStatement(updateQuery);
             PreparedStatement transactionStatement = connection.prepareStatement(transactionQuery, Statement.RETURN_GENERATED_KEYS);
             PreparedStatement depositStatement = connection.prepareStatement(depositQuery)) {

            if (!verifyPassword(connection, accId, password)) {
                System.out.println("Deposit failed: Incorrect password.");
                return;
            }

            // 계좌 잔액 갱신
            updateStatement.setDouble(1, amount);
            updateStatement.setLong(2, accId);
            int rowsUpdated = updateStatement.executeUpdate();

            if (rowsUpdated > 0) {
                // 트랜잭션 기록
                transactionStatement.setLong(1, accId);
                transactionStatement.executeUpdate();

                ResultSet transactionKeys = transactionStatement.getGeneratedKeys();
                if (transactionKeys.next()) {
                    long transactionId = transactionKeys.getLong(1);

                    // 입금 기록
                    depositStatement.setLong(1, transactionId);
                    depositStatement.setDouble(2, amount);
                    depositStatement.executeUpdate();

                    System.out.println("Deposit successful! Transaction ID: " + transactionId);
                }
            } else {
                System.out.println("Deposit failed: Account not found or is deleted.");
            }

        } catch (SQLException e) {
            System.err.println("Database error: " + e.getMessage());
        }
    }

    // 출금 메서드
    public void withdraw() {
        Scanner scanner = new Scanner(System.in);

        System.out.println("Enter Account ID (acc_id): ");
        long accId = scanner.nextLong();

        System.out.println("Enter Password: ");
        String password = scanner.next();

        System.out.println("Enter Withdrawal Amount: ");
        double amount = scanner.nextDouble();

        String selectQuery = "SELECT balance FROM account WHERE acc_id = ? AND is_deleted = false";
        String updateQuery = "UPDATE account SET balance = balance - ? WHERE acc_id = ?";
        String transactionQuery = "INSERT INTO transaction (acc_id, date, type) VALUES (?, NOW(), 'WITHDRAW')";
        String withdrawQuery = "INSERT INTO withdraw (transaction_id, acc_id, amount) VALUES (?, ?, ?)";

        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement selectStatement = connection.prepareStatement(selectQuery);
             PreparedStatement updateStatement = connection.prepareStatement(updateQuery);
             PreparedStatement transactionStatement = connection.prepareStatement(transactionQuery, Statement.RETURN_GENERATED_KEYS);
             PreparedStatement withdrawStatement = connection.prepareStatement(withdrawQuery)) {

            if (!verifyPassword(connection, accId, password)) {
                System.out.println("Withdrawal failed: Incorrect password.");
                return;
            }

            // 잔액 확인
            selectStatement.setLong(1, accId);
            ResultSet resultSet = selectStatement.executeQuery();

            if (resultSet.next()) {
                double currentBalance = resultSet.getDouble("balance");

                if (currentBalance >= amount) {
                    // 잔액 갱신
                    updateStatement.setDouble(1, amount);
                    updateStatement.setLong(2, accId);
                    int rowsUpdated = updateStatement.executeUpdate();

                    if (rowsUpdated > 0) {
                        // 트랜잭션 기록
                        transactionStatement.setLong(1, accId);
                        transactionStatement.executeUpdate();

                        ResultSet transactionKeys = transactionStatement.getGeneratedKeys();
                        if (transactionKeys.next()) {
                            long transactionId = transactionKeys.getLong(1);

                            // 출금 기록
                            withdrawStatement.setLong(1, transactionId);
                            withdrawStatement.setLong(2, accId);
                            withdrawStatement.setDouble(3, amount);
                            withdrawStatement.executeUpdate();

                            System.out.println("Withdrawal successful! Transaction ID: " + transactionId);
                        }
                    }
                } else {
                    System.out.println("Withdrawal failed: Insufficient balance.");
                }
            } else {
                System.out.println("Withdrawal failed: Account not found or is deleted.");
            }

        } catch (SQLException e) {
            System.err.println("Database error: " + e.getMessage());
        }
    }

    // 이체 메서드
    public void transfer() {
        Scanner scanner = new Scanner(System.in);

        System.out.println("Enter Sender Account ID (acc_id): ");
        long senderAccId = scanner.nextLong();

        System.out.println("Enter Sender Password: ");
        String password = scanner.next();

        System.out.println("Enter Receiver Account ID (acc_id): ");
        long receiverAccId = scanner.nextLong();

        System.out.println("Enter Transfer Amount: ");
        double amount = scanner.nextDouble();

        String selectBalanceQuery = "SELECT balance FROM account WHERE acc_id = ? AND is_deleted = false";
        String updateSenderBalanceQuery = "UPDATE account SET balance = balance - ? WHERE acc_id = ?";
        String updateReceiverBalanceQuery = "UPDATE account SET balance = balance + ? WHERE acc_id = ?";
        String transactionQuery = "INSERT INTO transaction (acc_id, date, type) VALUES (?, NOW(), 'TRANSFER')";
        String transferQuery = "INSERT INTO transfer (transaction_id, sender_acc_id, receiver_acc_id, amount) VALUES (?, ?, ?, ?)";

        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement selectBalanceStatement = connection.prepareStatement(selectBalanceQuery);
             PreparedStatement updateSenderBalanceStatement = connection.prepareStatement(updateSenderBalanceQuery);
             PreparedStatement updateReceiverBalanceStatement = connection.prepareStatement(updateReceiverBalanceQuery);
             PreparedStatement transactionStatement = connection.prepareStatement(transactionQuery, Statement.RETURN_GENERATED_KEYS);
             PreparedStatement transferStatement = connection.prepareStatement(transferQuery)) {

            if (!verifyPassword(connection, senderAccId, password)) {
                System.out.println("Transfer failed: Incorrect password.");
                return;
            }

            selectBalanceStatement.setLong(1, senderAccId);
            ResultSet senderResultSet = selectBalanceStatement.executeQuery();

            if (senderResultSet.next()) {
                double senderBalance = senderResultSet.getDouble("balance");

                if (senderBalance >= amount) {
                    // 송금 계좌 잔액 갱신
                    updateSenderBalanceStatement.setDouble(1, amount);
                    updateSenderBalanceStatement.setLong(2, senderAccId);
                    int senderRowsUpdated = updateSenderBalanceStatement.executeUpdate();

                    if (senderRowsUpdated > 0) {
                        // 수취 계좌 잔액 갱신
                        updateReceiverBalanceStatement.setDouble(1, amount);
                        updateReceiverBalanceStatement.setLong(2, receiverAccId);
                        int receiverRowsUpdated = updateReceiverBalanceStatement.executeUpdate();

                        if (receiverRowsUpdated > 0) {
                            // 트랜잭션 기록
                            transactionStatement.setLong(1, senderAccId);
                            transactionStatement.executeUpdate();

                            ResultSet transactionKeys = transactionStatement.getGeneratedKeys();
                            if (transactionKeys.next()) {
                                long transactionId = transactionKeys.getLong(1);

                                // 이체 기록
                                transferStatement.setLong(1, transactionId);
                                transferStatement.setLong(2, senderAccId);
                                transferStatement.setLong(3, receiverAccId);
                                transferStatement.setDouble(4, amount);
                                transferStatement.executeUpdate();

                                System.out.println("Transfer successful! Transaction ID: " + transactionId);
                            }
                        } else {
                            System.out.println("Transfer failed: Receiver account not found.");
                        }
                    } else {
                        System.out.println("Transfer failed: Sender account update failed.");
                    }
                } else {
                    System.out.println("Transfer failed: Insufficient balance.");
                }
            } else {
                System.out.println("Transfer failed: Sender account not found or is deleted.");
            }

        } catch (SQLException e) {
            System.err.println("Database error: " + e.getMessage());
        }
    }
}
