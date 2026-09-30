package com.complaintportal.servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.complaintportal.dao.ComplaintDAO;

@WebServlet("/UpdateComplaintServlet")
public class UpdateComplaintServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final ComplaintDAO complaintDAO =
        new ComplaintDAO();

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session =
            request.getSession(false);

        if (session == null
                || !"faculty".equals(
                    session.getAttribute("role"))) {

            response.sendRedirect("login.jsp");
            return;
        }

        Object userIdObject =
            session.getAttribute("userId");

        if (!(userIdObject instanceof Integer)) {

            session.invalidate();
            response.sendRedirect("login.jsp");
            return;
        }

        int facultyId =
            (Integer) userIdObject;

        int complaintId;

        try {

            complaintId =
                Integer.parseInt(
                    request.getParameter("complaintId")
                );

            if (complaintId <= 0) {
                throw new NumberFormatException();
            }

        } catch (Exception e) {

            response.sendRedirect(
                "FacultyComplaintsServlet"
            );

            return;
        }

        String newStatus =
            request.getParameter("status");

        if (newStatus != null) {
            newStatus = newStatus.trim();
        }

        String remarks =
            request.getParameter("remarks");

        if (remarks != null) {
            remarks = remarks.trim();
        }

        if (remarks != null && remarks.length() > 5000) {

            response.sendRedirect(
                "FacultyComplaintsServlet"
            );

            return;
        }

        if (!"Pending".equals(newStatus)
                && !"In Progress".equals(newStatus)
                && !"Resolved".equals(newStatus)) {

            response.sendRedirect(
                "FacultyComplaintsServlet"
            );

            return;
        }

        complaintDAO.updateStatusByFaculty(
            complaintId,
            facultyId,
            newStatus,
            remarks
        );

        response.sendRedirect(
            "FacultyComplaintsServlet"
        );
    }
}
