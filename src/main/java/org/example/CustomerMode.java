package org.example;

public class CustomerMode {
    private static String url;
    private static String user;
    private static String password;
    //데이터베이스와 연결하기 위한 메소드
    public static void initDatabase(String dbUrl, String dbUser, String dbPassword) {
        url = dbUrl;
        user = dbUser;
        password = dbPassword;
    }
    public static void customerMenu() {
    }
}
