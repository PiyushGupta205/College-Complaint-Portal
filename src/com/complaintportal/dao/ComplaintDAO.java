package com.complaintportal.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.complaintportal.model.Complaint;

public class ComplaintDAO {

    private static final String BASE_SELECT =
        "SELECT c.complaint_id, c.student_id, c.category_id, " +
        "c.title, c.location, c.description, c.remarks, c.status, " +
        "c.created_at, c.updated_at, " +
        "cc.category_name, " +
        "s.name AS student_name, " +
        "f.faculty_id, f.name AS faculty_name " +
        "FROM complaints c " +
        "JOIN complaint_category cc " +
        "ON c.category_id = cc.category_id " +
        "JOIN students s " +
        "ON c.student_id = s.student_id " +
        "LEFT JOIN faculty f " +
        "ON c.assigned_faculty_id = f.faculty_id ";

    public boolean submitComplaint(
            int studentId,
            int categoryId,
            String title,
            String location,
            String description) {

        String sql =
            "INSERT INTO complaints " +
            "(student_id, category_id, title, location, description, status) " +
            "VALUES (?, ?, ?, ?, ?, 'Pending')";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            ps.setInt(2, categoryId);
            ps.setString(3, title);
            ps.setString(4, location);
            ps.setString(5, description);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println(
                "Complaint submission failed: " + e.getMessage()
            );
            return false;
        }
    }

    public List<Complaint> getComplaintsByStudent(int studentId) {

        List<Complaint> list = new ArrayList<>();

        String sql =
            BASE_SELECT +
            "WHERE c.student_id = ? " +
            "ORDER BY c.created_at DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, studentId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }

        } catch (Exception e) {
            System.err.println(
                "Unable to load student complaints: " + e.getMessage()
            );
        }

        return list;
    }

    public List<Complaint> getComplaintsByFaculty(int facultyId) {

        List<Complaint> list = new ArrayList<>();

        String sql =
            BASE_SELECT +
            "WHERE c.assigned_faculty_id = ? " +
            "ORDER BY c.created_at DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, facultyId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }

        } catch (Exception e) {
            System.err.println(
                "Unable to load faculty complaints: " + e.getMessage()
            );
        }

        return list;
    }

    public List<Complaint> getAllComplaints(
            String complaintIdFilter,
            String statusFilter,
            String categoryFilter) {

        List<Complaint> list = new ArrayList<>();

        StringBuilder sql =
            new StringBuilder(BASE_SELECT).append("WHERE 1=1 ");

        boolean hasComplaintId =
            complaintIdFilter != null
            && !complaintIdFilter.isBlank();

        boolean hasStatus =
            statusFilter != null
            && !statusFilter.isBlank();

        boolean hasCategory =
            categoryFilter != null
            && !categoryFilter.isBlank();

        if (hasComplaintId) {
            sql.append("AND c.complaint_id = ? ");
        }

        if (hasStatus) {
            sql.append("AND c.status = ? ");
        }

        if (hasCategory) {
            sql.append("AND cc.category_name = ? ");
        }

        sql.append("ORDER BY c.created_at DESC");

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int index = 1;

            if (hasComplaintId) {
                ps.setInt(index++, Integer.parseInt(complaintIdFilter));
            }

            if (hasStatus) {
                ps.setString(index++, statusFilter);
            }

            if (hasCategory) {
                ps.setString(index++, categoryFilter);
            }

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }

        } catch (Exception e) {
            System.err.println(
                "Unable to load all complaints: " + e.getMessage()
            );
        }

        return list;
    }

    /*
     * Faculty can update only a complaint assigned to that faculty.
     *
     * Allowed lifecycle:
     * Pending -> In Progress
     * In Progress -> Resolved
     *
     * Same status is also allowed.
     */
    public boolean updateStatusByFaculty(
            int complaintId,
            int facultyId,
            String newStatus,
            String remarks) {

        if (!isValidStatus(newStatus)) {
            return false;
        }

        String sql =
            "UPDATE complaints " +
            "SET status = ?, remarks = ? " +
            "WHERE complaint_id = ? " +
            "AND assigned_faculty_id = ? " +
            "AND (" +
                "status = ? OR " +
                "(status = 'Pending' AND ? = 'In Progress') OR " +
                "(status = 'In Progress' AND ? = 'Resolved')" +
            ")";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, newStatus);
            ps.setString(2, remarks);
            ps.setInt(3, complaintId);
            ps.setInt(4, facultyId);
            ps.setString(5, newStatus);
            ps.setString(6, newStatus);
            ps.setString(7, newStatus);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println(
                "Faculty complaint update failed: " + e.getMessage()
            );
            return false;
        }
    }


    public boolean assignFaculty(
            int complaintId,
            int facultyId) {

        String sql =
            "UPDATE complaints " +
            "SET assigned_faculty_id = ?, " +
            "status = 'In Progress' " +
            "WHERE complaint_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, facultyId);
            ps.setInt(2, complaintId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println(
                "Faculty assignment failed: " + e.getMessage()
            );
            return false;
        }
    }

    public int[] getStats() {

        int[] stats = new int[4];

        String sql =
            "SELECT status, COUNT(*) AS cnt " +
            "FROM complaints GROUP BY status";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                int count = rs.getInt("cnt");

                stats[0] += count;

                String status = rs.getString("status");

                if ("Pending".equals(status)) {
                    stats[1] = count;
                } else if ("In Progress".equals(status)) {
                    stats[2] = count;
                } else if ("Resolved".equals(status)) {
                    stats[3] = count;
                }
            }

        } catch (SQLException e) {
            System.err.println(
                "Unable to load complaint statistics: "
                + e.getMessage()
            );
        }

        return stats;
    }

    private boolean isValidStatus(String status) {

        return "Pending".equals(status)
            || "In Progress".equals(status)
            || "Resolved".equals(status);
    }

    private Complaint mapRow(ResultSet rs) throws SQLException {

        Complaint complaint = new Complaint();

        complaint.setComplaintId(
            rs.getInt("complaint_id")
        );

        complaint.setStudentId(
            rs.getInt("student_id")
        );

        complaint.setCategoryId(
            rs.getInt("category_id")
        );

        complaint.setStudentName(
            rs.getString("student_name")
        );

        complaint.setTitle(
            rs.getString("title")
        );

        complaint.setLocation(
            rs.getString("location")
        );

        complaint.setDescription(
            rs.getString("description")
        );

        complaint.setRemarks(
            rs.getString("remarks")
        );

        complaint.setStatus(
            rs.getString("status")
        );

        complaint.setCreatedAt(
            rs.getTimestamp("created_at")
        );

        complaint.setUpdatedAt(
            rs.getTimestamp("updated_at")
        );

        complaint.setCategoryName(
            rs.getString("category_name")
        );

        int facultyId = rs.getInt("faculty_id");

        if (!rs.wasNull()) {

            complaint.setFacultyId(facultyId);

            complaint.setFacultyName(
                rs.getString("faculty_name")
            );
        }

        return complaint;
    }
}
