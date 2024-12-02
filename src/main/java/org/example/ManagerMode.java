package org.example;

import java.util.Scanner;

import static org.example.AssetsManager.assetsMenu;
import static org.example.EmployeeManager.adminMenu;

public class ManagerMode {

    public static void ManagerMenu(){
        Scanner sc = new Scanner(System.in);

        System.out.println("===== 관리자 모드 =====");
        System.out.println("1. 직원 관리");
        System.out.println("2. 자산 관리");
        System.out.print("선택: ");
        int choice = sc.nextInt();
        sc.nextLine(); // 개행 문자 제거

        switch (choice) {
            case 1:
                adminMenu();
                return;
            case 2:
                assetsMenu();
                return;
            default:
                System.out.println("잘못된 선택입니다. 다시 시도하세요.");
        }
        sc.close();
    }
}
