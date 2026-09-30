package com.complaintportal.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.complaintportal.model.User;

public class UserDAO {

    public boolean registerStudent(User user) {

        String sql =
            "INSERT INTO students (name, email, password) VALUES (?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, PasswordUtil.hash(user.getPassword()));

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Student registration failed: " + e.getMessage());
            return false;
        }
    }

    public User authenticate(String email, String password, String role) {

        if (email == null || password == null || role == null) {
            return null;
        }

        if (!"student".equals(role)
                && !"faculty".equals(role)
                && !"admin".equals(role)) {
            return null;
        }

        String sql;

        if ("student".equals(role)) {

            sql =
                "SELECT student_id AS id, name, email, password " +
                "FROM students WHERE email = ?";

        } else if ("faculty".equals(role)) {

            sql =
                "SELECT faculty_id AS id, name, email, password, department " +
                "FROM faculty WHERE email = ?";

        } else {

            sql =
                "SELECT admin_id AS id, name, email, password " +
                "FROM administrators WHERE email = ?";
        }

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()
                        && PasswordUtil.matches(
                            password,
                            rs.getString("password"))) {

                    User user = new User();

                    user.setUserId(rs.getInt("id"));
                    user.setName(rs.getString("name"));
                    user.setEmail(rs.getString("email"));
                    user.setRole(role);

                    if ("faculty".equals(role)) {
                        user.setDepartment(rs.getString("department"));
                    }

                    return user;
                }
            }

        } catch (SQLException e) {
            System.err.println("Authentication failed: " + e.getMessage());
        }

        return null;
    }

    public List<User> getAllFaculty() {

        List<User> list = new ArrayList<>();

        String sql =
            "SELECT faculty_id, name, department " +
            "FROM faculty ORDER BY name";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                User user = new User();

                user.setUserId(rs.getInt("faculty_id"));
                user.setName(rs.getString("name"));
                user.setDepartment(rs.getString("department"));

                list.add(user);
            }

        } catch (SQLException e) {
            System.err.println("Unable to load faculty: " + e.getMessage());
        }

        return list;
    }

    public int countStudents() {
        return count("students");
    }

    public int countFaculty() {
        return count("faculty");
    }

    private int count(String table) {

        if (!"students".equals(table) && !"faculty".equals(table)) {
            return 0;
        }

        String sql = "SELECT COUNT(*) FROM " + table;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            System.err.println(
                "Unable to count " + table + ": " + e.getMessage()
            );
        }

        return 0;
    }
}