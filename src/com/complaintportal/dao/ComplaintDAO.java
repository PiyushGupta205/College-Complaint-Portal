package com.complaintportal.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.complaintportal.model.Complaint;

public class ComplaintDAO {

    private Complaint mapComplaint(ResultSet rs) throws SQLException {
        Complaint c = new Complaint();
        c.setComplaintId(rs.getInt("complaint_id"));
        c.setStudentId(rs.getInt("student_id"));
        c.setStudentName(rs.getString("student_name"));
        c.setCategoryId(rs.getInt("category_id"));
        c.setCategoryName(rs.getString("category_name"));

        int facultyId = rs.getInt("assigned_faculty_id");
        c.setFacultyId(rs.wasNull() ? null : facultyId);

        c.setFacultyName(rs.getString("faculty_name"));
        c.setTitle(rs.getString("title"));
        c.setLocation(rs.getString("location"));
        c.setDescription(rs.getString("description"));
        c.setRemarks(rs.getString("remarks"));
        c.setStatus(rs.getString("status"));
        c.setCreatedAt(rs.getTimestamp("created_at"));
        c.setUpdatedAt(rs.getTimestamp("updated_at"));
        return c;
    }

    private String complaintSelect() {
        return "SELECT c.complaint_id, c.student_id, " +
               "COALESCE(s.name, c.student_name_snapshot, 'Deleted Student') AS student_name, " +
               "COALESCE(s.email, c.student_email_snapshot) AS student_email, " +
               "c.category_id, cc.category_name, c.assigned_faculty_id, " +
               "f.name AS faculty_name, c.title, c.location, c.description, " +
               "c.remarks, c.status, c.created_at, c.updated_at " +
               "FROM complaints c " +
               "LEFT JOIN students s ON c.student_id = s.student_id " +
               "JOIN complaint_category cc ON c.category_id = cc.category_id " +
               "LEFT JOIN faculty f ON c.assigned_faculty_id = f.faculty_id ";
    }

    public List<Complaint> getComplaintsByStudent(int studentId) {
        List<Complaint> list = new ArrayList<>();
        String sql = complaintSelect() +
                     "WHERE c.student_id = ? ORDER BY c.created_at DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapComplaint(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Unable to load student complaints: " + e.getMessage());
        }
        return list;
    }

    public List<Complaint> getComplaintsByFaculty(int facultyId) {
        List<Complaint> list = new ArrayList<>();
        String sql = complaintSelect() +
                     "WHERE c.assigned_faculty_id = ? ORDER BY c.created_at DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, facultyId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapComplaint(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Unable to load faculty complaints: " + e.getMessage());
        }
        return list;
    }

    public List<Complaint> getAllComplaints(
            String complaintId, String status, String category) {

        List<Complaint> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(complaintSelect());
        sql.append("WHERE 1=1 ");

        boolean filterId = complaintId != null && !complaintId.trim().isEmpty();
        boolean filterStatus = status != null && !status.trim().isEmpty();
        boolean filterCategory = category != null && !category.trim().isEmpty();

        if (filterId) {
            sql.append("AND c.complaint_id = ? ");
        }
        if (filterStatus) {
            sql.append("AND c.status = ? ");
        }
        if (filterCategory) {
            sql.append("AND cc.category_name = ? ");
        }
        sql.append("ORDER BY c.created_at DESC");

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int index = 1;
            if (filterId) {
                try {
                    ps.setInt(index++, Integer.parseInt(complaintId.trim()));
                } catch (NumberFormatException e) {
                    return list;
                }
            }
            if (filterStatus) {
                ps.setString(index++, status.trim());
            }
            if (filterCategory) {
                ps.setString(index++, category.trim());
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapComplaint(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Unable to load all complaints: " + e.getMessage());
        }
        return list;
    }

    public boolean submitComplaint(
            int studentId, int categoryId, String title,
            String location, String description) {

        String sql = "INSERT INTO complaints " +
                     "(student_id, category_id, title, location, description, student_name_snapshot, student_email_snapshot) " +
                     "SELECT ?, ?, ?, ?, ?, name, email FROM students WHERE student_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, categoryId);
            ps.setString(3, title);
            ps.setString(4, location);
            ps.setString(5, description);
            ps.setInt(6, studentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Unable to submit complaint: " + e.getMessage());
            return false;
        }
    }

    public boolean assignFaculty(int complaintId, int facultyId) {
        String sql = "UPDATE complaints SET assigned_faculty_id = ? " +
                     "WHERE complaint_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, facultyId);
            ps.setInt(2, complaintId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Unable to assign faculty: " + e.getMessage());
            return false;
        }
    }

    public boolean updateStatusByFaculty(
            int complaintId, int facultyId, String newStatus, String remarks) {

        String sql = "UPDATE complaints SET status = ?, remarks = ? " +
                     "WHERE complaint_id = ? AND assigned_faculty_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setString(2, remarks);
            ps.setInt(3, complaintId);
            ps.setInt(4, facultyId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Unable to update complaint status: " + e.getMessage());
            return false;
        }
    }

    public int[] getStats() {
        int[] stats = new int[4];

        String sql = "SELECT COUNT(*) AS total, " +
                     "COALESCE(SUM(CASE WHEN status = 'Pending' THEN 1 ELSE 0 END), 0) AS pending, " +
                     "COALESCE(SUM(CASE WHEN status = 'In Progress' THEN 1 ELSE 0 END), 0) AS in_progress, " +
                     "COALESCE(SUM(CASE WHEN status = 'Resolved' THEN 1 ELSE 0 END), 0) AS resolved " +
                     "FROM complaints";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                stats[0] = rs.getInt("total");
                stats[1] = rs.getInt("pending");
                stats[2] = rs.getInt("in_progress");
                stats[3] = rs.getInt("resolved");
            }
        } catch (SQLException e) {
            System.err.println("Unable to load complaint statistics: " + e.getMessage());
        }

        return stats;
    }

    public boolean deleteComplaint(int complaintId) {
        if (complaintId <= 0) return false;

        String sql = "DELETE FROM complaints WHERE complaint_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, complaintId);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            System.err.println("Unable to delete complaint: " + e.getMessage());
            return false;
        }
    }
}
