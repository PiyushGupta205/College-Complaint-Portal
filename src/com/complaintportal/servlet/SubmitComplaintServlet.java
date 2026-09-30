package com.complaintportal.servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.complaintportal.dao.ComplaintDAO;

@WebServlet("/SubmitComplaintServlet")
public class SubmitComplaintServlet extends HttpServlet {

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
                || !"student".equals(
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

        int studentId =
            (Integer) userIdObject;

        String title =
            trim(request.getParameter("title"));

        String location =
            trim(request.getParameter("location"));

        String description =
            trim(request.getParameter("description"));

        String categoryIdText =
            trim(request.getParameter("categoryId"));

        if (title == null
                || title.isEmpty()
                || description == null
                || description.isEmpty()
                || categoryIdText == null
                || categoryIdText.isEmpty()) {

            request.setAttribute(
                "error",
                "Title, category and description are required."
            );

            request.getRequestDispatcher(
                "submit-complaint.jsp"
            ).forward(request, response);

            return;
        }

        if (title.length() > 150) {

            request.setAttribute(
                "error",
                "Complaint title must be 150 characters or less."
            );

            request.getRequestDispatcher(
                "submit-complaint.jsp"
            ).forward(request, response);

            return;
        }

        if (location != null
                && location.length() > 150) {

            request.setAttribute(
                "error",
                "Location must be 150 characters or less."
            );

            request.getRequestDispatcher(
                "submit-complaint.jsp"
            ).forward(request, response);

            return;
        }

        int categoryId;

        try {

            categoryId =
                Integer.parseInt(categoryIdText);

            if (categoryId <= 0) {
                throw new NumberFormatException();
            }

        } catch (NumberFormatException e) {

            request.setAttribute(
                "error",
                "Please select a valid complaint category."
            );

            request.getRequestDispatcher(
                "submit-complaint.jsp"
            ).forward(request, response);

            return;
        }

        boolean saved =
            complaintDAO.submitComplaint(
                studentId,
                categoryId,
                title,
                location,
                description
            );

        if (saved) {

            response.sendRedirect(
                "MyComplaintsServlet"
            );

        } else {

            request.setAttribute(
                "error",
                "Unable to submit the complaint. Please try again."
            );

            request.getRequestDispatcher(
                "submit-complaint.jsp"
            ).forward(request, response);
        }
    }

    private String trim(String value) {

        return value == null ? null : value.trim();
    }
}