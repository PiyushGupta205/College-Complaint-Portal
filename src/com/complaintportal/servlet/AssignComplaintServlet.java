package com.complaintportal.servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.complaintportal.dao.ComplaintDAO;

@WebServlet("/AssignComplaintServlet")
public class AssignComplaintServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final ComplaintDAO complaintDAO =
        new ComplaintDAO();

    @Override
    protected void doPost(
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

        int complaintId;
        int facultyId;

        try {

            complaintId =
                Integer.parseInt(
                    request.getParameter("complaintId")
                );

            facultyId =
                Integer.parseInt(
                    request.getParameter("facultyId")
                );

            if (complaintId <= 0 || facultyId <= 0) {
                throw new NumberFormatException();
            }

        } catch (Exception e) {

            response.sendRedirect(
                "AdminComplaintsServlet"
            );

            return;
        }

        complaintDAO.assignFaculty(
            complaintId,
            facultyId
        );

        response.sendRedirect(
            "AdminComplaintsServlet"
        );
    }
}