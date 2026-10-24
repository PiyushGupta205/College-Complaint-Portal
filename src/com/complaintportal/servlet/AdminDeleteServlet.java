package com.complaintportal.servlet;

import java.io.IOException;

import com.complaintportal.dao.ComplaintDAO;
import com.complaintportal.dao.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AdminDeleteServlet")
public class AdminDeleteServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final ComplaintDAO complaintDAO = new ComplaintDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null
                || !"admin".equals(session.getAttribute("role"))
                || session.getAttribute("userId") == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        request.setCharacterEncoding("UTF-8");

        String type = request.getParameter("type");
        String rawId = request.getParameter("id");
        int id;

        try {
            id = Integer.parseInt(rawId);
            if (id <= 0) throw new NumberFormatException();
        } catch (NumberFormatException | NullPointerException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid record ID.");
            return;
        }

        boolean deleted;
        String redirect;

        if ("students".equals(type)) {
            deleted = userDAO.deleteStudent(id);
            redirect = "AdminDirectoryServlet?type=students";
        } else if ("faculty".equals(type)) {
            deleted = userDAO.deleteFaculty(id);
            redirect = "AdminDirectoryServlet?type=faculty";
        } else if ("complaints".equals(type)) {
            deleted = complaintDAO.deleteComplaint(id);
            redirect = "resolved".equals(request.getParameter("returnTo")) ? "AdminComplaintsServlet?view=resolved" : "AdminComplaintsServlet";
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid record type.");
            return;
        }

        if (!deleted) {
            response.sendError(HttpServletResponse.SC_CONFLICT,
                    "The record could not be deleted. It may no longer exist or the database rejected the operation.");
            return;
        }

        response.sendRedirect(redirect);
    }
}
