package com.complaintportal.servlet;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.complaintportal.dao.UserDAO;
import com.complaintportal.model.User;

@WebServlet("/AdminDirectoryServlet")
public class AdminDirectoryServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null
                || !"admin".equals(session.getAttribute("role"))
                || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String type = request.getParameter("type");

        if ("students".equals(type)) {
            List<User> users = userDAO.getAllStudents();
            request.setAttribute("users", users);
            request.setAttribute("directoryTitle", "Registered Students");
            request.setAttribute("directoryType", "students");
        } else if ("faculty".equals(type)) {
            List<User> users = userDAO.getAllFaculty();
            request.setAttribute("users", users);
            request.setAttribute("directoryTitle", "Faculty Directory");
            request.setAttribute("directoryType", "faculty");
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid directory type.");
            return;
        }

        request.getRequestDispatcher("admin-directory.jsp")
               .forward(request, response);
    }
}