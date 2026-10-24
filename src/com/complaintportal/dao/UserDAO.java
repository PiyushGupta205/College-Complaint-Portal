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
            "FROM faculty ORDER BY faculty_id ASC";

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

    public List<User> getAllStudents() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT student_id, name, email FROM students ORDER BY student_id ASC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("student_id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setRole("student");
                list.add(user);
            }
        } catch (SQLException e) {
            System.err.println("Unable to load students: " + e.getMessage());
        }
        return list;
    }

    public List<User> getAllAdministrators() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT admin_id, name, email FROM administrators ORDER BY name";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("admin_id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setRole("admin");
                list.add(user);
            }
        } catch (SQLException e) {
            System.err.println("Unable to load administrators: " + e.getMessage());
        }
        return list;
    }

    public int countAdministrators() {
        String sql = "SELECT COUNT(*) FROM administrators";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Unable to count administrators: " + e.getMessage());
        }
        return 0;
    }
    public boolean deleteStudent(int studentId) {
        if (studentId <= 0) return false;

        String snapshotSql =
            "UPDATE complaints c JOIN students s ON c.student_id = s.student_id " +
            "SET c.student_name_snapshot = COALESCE(c.student_name_snapshot, s.name), " +
            "c.student_email_snapshot = COALESCE(c.student_email_snapshot, s.email) " +
            "WHERE c.student_id = ?";
        String deleteSql = "DELETE FROM students WHERE student_id = ?";

        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                try (PreparedStatement ps = con.prepareStatement(snapshotSql)) {
                    ps.setInt(1, studentId);
                    ps.executeUpdate();
                }

                int deleted;
                try (PreparedStatement ps = con.prepareStatement(deleteSql)) {
                    ps.setInt(1, studentId);
                    deleted = ps.executeUpdate();
                }

                if (deleted != 1) {
                    con.rollback();
                    return false;
                }

                con.commit();
                return true;
            } catch (SQLException e) {
                con.rollback();
                throw e;
            } finally {
                con.setAutoCommit(true);
            }
        } catch (SQLException e) {
            System.err.println("Unable to delete student: " + e.getMessage());
            return false;
        }
    }

    public boolean deleteFaculty(int facultyId) {
        if (facultyId <= 0) return false;

        String unassignSql =
            "UPDATE complaints SET assigned_faculty_id = NULL WHERE assigned_faculty_id = ?";
        String deleteSql = "DELETE FROM faculty WHERE faculty_id = ?";

        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                try (PreparedStatement ps = con.prepareStatement(unassignSql)) {
                    ps.setInt(1, facultyId);
                    ps.executeUpdate();
                }

                int deleted;
                try (PreparedStatement ps = con.prepareStatement(deleteSql)) {
                    ps.setInt(1, facultyId);
                    deleted = ps.executeUpdate();
                }

                if (deleted != 1) {
                    con.rollback();
                    return false;
                }

                con.commit();
                return true;
            } catch (SQLException e) {
                con.rollback();
                throw e;
            } finally {
                con.setAutoCommit(true);
            }
        } catch (SQLException e) {
            System.err.println("Unable to delete faculty: " + e.getMessage());
            return false;
        }
    }
}
