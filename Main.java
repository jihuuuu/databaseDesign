package org.example;

public  class Main {
    public static void main(String[] args) {
        // 계좌 생성
        //AccountManager accountManager = new AccountManager();
        //accountManager.createAccount();

        TransactionManager transactionManager = new TransactionManager();
        // 기능 선택

        // 입금 테스트
        transactionManager.deposit();
        // 출금 테스트
        //transactionManager.withdraw();
        //이체 테스트
        //transactionManager.transfer();
    }
}