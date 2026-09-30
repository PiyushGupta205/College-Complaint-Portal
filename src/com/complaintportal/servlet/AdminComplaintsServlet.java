package com.complaintportal.servlet;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.complaintportal.dao.ComplaintDAO;
import com.complaintportal.dao.UserDAO;
import com.complaintportal.model.Complaint;
import com.complaintportal.model.User;

@WebServlet("/AdminComplaintsServlet")
public class AdminComplaintsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final ComplaintDAO complaintDAO =
        new ComplaintDAO();

    private final UserDAO userDAO =
        new UserDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
            request.getSession(false);

        if (session == null
                || !"admin".equals(
                    session.getAttribute("role"))) {

            response.sendRedirect("login.jsp");
            return;
        }

        String complaintId =
            trim(request.getParameter("complaintId"));

        String status =
            trim(request.getParameter("status"));

        String category =
            trim(request.getParameter("category"));

        if (complaintId != null
                && !complaintId.isEmpty()) {

            try {

                int id =
                    Integer.parseInt(complaintId);

                if (id <= 0) {
                    complaintId = "";
                }

            } catch (NumberFormatException e) {

                complaintId = "";
            }
        }

        if (status != null
                && !status.isEmpty()
                && !"Pending".equals(status)
                && !"In Progress".equals(status)
                && !"Resolved".equals(status)) {

            status = "";
        }

        List<Complaint> complaints =
            complaintDAO.getAllComplaints(
                complaintId,
                status,
                category
            );

        List<User> facultyList =
            userDAO.getAllFaculty();

        request.setAttribute(
            "complaints",
            complaints
        );

        request.setAttribute(
            "facultyList",
            facultyList
        );

        request.setAttribute(
            "complaintIdFilter",
            complaintId
        );

        request.setAttribute(
            "statusFilter",
            status
        );

        request.setAttribute(
            "categoryFilter",
            category
        );

        request.getRequestDispatcher(
            "admin-complaints.jsp"
        ).forward(request, response);
    }

    private String trim(String value) {

        return value == null ? null : value.trim();
    }
}