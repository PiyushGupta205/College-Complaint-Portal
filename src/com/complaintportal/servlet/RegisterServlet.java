package com.complaintportal.servlet;

import java.io.IOException;
import java.util.regex.Pattern;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.complaintportal.dao.UserDAO;
import com.complaintportal.model.User;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final UserDAO userDAO = new UserDAO();

    private static final Pattern EMAIL_PATTERN =
        Pattern.compile(
            "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$"
        );

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String name = trim(request.getParameter("name"));
        String email = trim(request.getParameter("email"));
        String password = request.getParameter("password");

        if (name == null
                || email == null
                || password == null
                || name.isEmpty()
                || email.isEmpty()
                || password.isEmpty()) {

            showError(
                request,
                response,
                "All fields are required."
            );

            return;
        }

        if (name.length() > 100) {

            showError(
                request,
                response,
                "Name must be 100 characters or less."
            );

            return;
        }

        if (!EMAIL_PATTERN.matcher(email).matches()
                || email.length() > 100) {

            showError(
                request,
                response,
                "Please enter a valid email address."
            );

            return;
        }

        if (password.length() < 6) {

            showError(
                request,
                response,
                "Password must contain at least 6 characters."
            );

            return;
        }

        if (password.length() > 100) {

            showError(
                request,
                response,
                "Password is too long."
            );

            return;
        }

        User user = new User();

        user.setName(name);
        user.setEmail(email);
        user.setPassword(password);

        if (userDAO.registerStudent(user)) {

            request.setAttribute(
                "message",
                "Registration successful. Please login."
            );

            request.getRequestDispatcher("login.jsp")
                   .forward(request, response);

        } else {

            showError(
                request,
                response,
                "Registration failed. Email may already be in use."
            );
        }
    }

    private void showError(
            HttpServletRequest request,
            HttpServletResponse response,
            String message)
            throws ServletException, IOException {

        request.setAttribute("error", message);

        request.getRequestDispatcher("register.jsp")
               .forward(request, response);
    }

    private String trim(String value) {

        return value == null ? null : value.trim();
    }
}