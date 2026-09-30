package com.complaintportal.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String DB_URL =
        "jdbc:mysql://localhost:3306/complaint_portal?useSSL=false&serverTimezone=UTC";

    private static final String DB_USER = "root";

    private DBConnection() {
    }

    public static Connection getConnection() throws SQLException {

        String dbPassword = System.getenv("MYSQL_PASSWORD");

        if (dbPassword == null || dbPassword.isBlank()) {
            throw new SQLException(
                "MYSQL_PASSWORD environment variable is not set."
            );
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException(
                "MySQL JDBC Driver not found. Check WEB-INF/lib.",
                e
            );
        }

        return DriverManager.getConnection(
            DB_URL,
            DB_USER,
            dbPassword
        );
    }
}