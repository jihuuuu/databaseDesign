package org.example;

import java.util.Scanner;

public class main_interface {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        boolean running = true;

        while (running) {
            System.out .println("\n");
            System.out.println("모드를 선택하세요:");
            System.out.println("1. 관리자 모드");
            System.out.println("2. 고객 모드");
            System.out.println("3. 종료");
            System.out.print("-> ");
            int mode = scanner.nextInt();
            scanner.nextLine();

            switch (mode) {
                case 1:
                    adminMode(scanner);
                    break;
                case 2:
                    customerMode(scanner);
                    break;
                case 3:
                    System.out.println("프로그램을 종료합니다.");
                    running = false;
                    break;
            }
        }
        scanner.close();
    }

    private static void adminMode(Scanner scanner) {
        System.out.println("관리자 모드입니다.");
        System.out.println("1. 직원관리");
        System.out.println("2. 자산관리");
        System.out.print("-> ");
        int adminChoice = scanner.nextInt();
        scanner.nextLine();

        switch (adminChoice) {
            case 1:
                System.out.println("1. 직원 채용");
                System.out.println("2. 직원 해고");
                System.out.println("3. 직원 전체 조회");
                System.out.println("4. 직원(개인) 조회");
                System.out.print("-> ");
                int staffChoice = scanner.nextInt();
                scanner.nextLine();

                switch (staffChoice) {
                    case 1:
                        System.out.println("직원이 채용되었습니다!");
                        break;
                    case 2:
                        System.out.println("직원이 해고되었습니다!");
                        break;
                    case 3:
                        System.out.println("직원 전체를 조회합니다!");
                        break;
                    case 4:
                        System.out.println("직원(개인)을 조회합니다!");
                        break;
                }
                break;

            case 2:
                System.out.println("1. 자산 조회");
                System.out.println("2. 은행 전체 자산 조회");
                System.out.print("-> ");
                int assetChoice = scanner.nextInt();
                scanner.nextLine();

                switch (assetChoice) {
                    case 1:
                        System.out.println("자산을 조회합니다!");
                        break;
                    case 2:
                        System.out.println("은행 전체 자산을 조회합니다!");
                        break;
                }
                break;
        }
    }

    private static void customerMode(Scanner scanner) {
        System.out.println("고객 모드입니다.");
        System.out.println("1. 계좌 개설");
        System.out.println("2. 입금");
        System.out.println("3. 출금");
        System.out.println("4. 대출");
        System.out.println("5. 이체");
        System.out.print("-> ");
        int customerChoice = scanner.nextInt();
        scanner.nextLine();

        switch (customerChoice) {
            case 1:
                System.out.println("계좌가 개설되었습니다.");
                break;

            case 2:
                System.out.println("1. 은행에서 입금하기");
                System.out.println("2. ATM으로 입금하기");
                System.out.print("-> ");
                int depositChoice = scanner.nextInt();
                scanner.nextLine();

                if (depositChoice == 1) {
                    System.out.println("은행에서 입금하였습니다!");
                } else if (depositChoice == 2) {
                    System.out.println("ATM으로 입금하였습니다!");
                }
                break;

            case 3:
                System.out.println("1. 은행에서 출금하기");
                System.out.println("2. ATM으로 출금하기");
                System.out.print("-> ");
                int withdrawChoice = scanner.nextInt();
                scanner.nextLine();

                if (withdrawChoice == 1) {
                    System.out.println("은행에서 출금하였습니다!");
                } else if (withdrawChoice == 2) {
                    System.out.println("ATM으로 출금하였습니다!");
                }
                break;

            case 4:
                System.out.println("대출이 진행되었습니다!");
                break;

            case 5:
                System.out.println("이체가 완료되었습니다!");
                break;
        }
    }
}
