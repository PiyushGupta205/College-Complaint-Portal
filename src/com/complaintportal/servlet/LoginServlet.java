package com.complaintportal.servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.complaintportal.dao.UserDAO;
import com.complaintportal.model.User;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = trim(request.getParameter("email"));
        String password = request.getParameter("password");
        String role = trim(request.getParameter("role"));

        if (email == null
                || password == null
                || role == null
                || email.isEmpty()
                || password.isEmpty()
                || role.isEmpty()) {

            request.setAttribute(
                "error",
                "Email, password and role are required."
            );

            request.getRequestDispatcher("login.jsp")
                   .forward(request, response);

            return;
        }

        if (!isValidRole(role)) {

            request.setAttribute(
                "error",
                "Invalid login role."
            );

            request.getRequestDispatcher("login.jsp")
                   .forward(request, response);

            return;
        }

        User user =
            userDAO.authenticate(
                email,
                password,
                role
            );

        if (user != null) {

            HttpSession oldSession =
                request.getSession(false);

            if (oldSession != null) {
                oldSession.invalidate();
            }

            HttpSession session =
                request.getSession(true);

            session.setAttribute(
                "userId",
                user.getUserId()
            );

            session.setAttribute(
                "name",
                user.getName()
            );

            session.setAttribute(
                "role",
                user.getRole()
            );

            if ("faculty".equals(role)) {

                session.setAttribute(
                    "department",
                    user.getDepartment()
                );
            }

            if ("student".equals(role)) {

                response.sendRedirect(
                    "student-dashboard.jsp"
                );

            } else if ("faculty".equals(role)) {

                response.sendRedirect(
                    "faculty-dashboard.jsp"
                );

            } else {

                response.sendRedirect(
                    "admin-dashboard.jsp"
                );
            }

            return;
        }

        request.setAttribute(
            "error",
            "Invalid email or password."
        );

        request.getRequestDispatcher("login.jsp")
               .forward(request, response);
    }

    private boolean isValidRole(String role) {

        return "student".equals(role)
            || "faculty".equals(role)
            || "admin".equals(role);
    }

    private String trim(String value) {

        return value == null ? null : value.trim();
    }
}