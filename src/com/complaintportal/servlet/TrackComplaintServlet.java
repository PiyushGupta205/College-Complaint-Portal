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
import com.complaintportal.model.Complaint;

@WebServlet("/TrackComplaintServlet")
public class TrackComplaintServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final ComplaintDAO complaintDAO = new ComplaintDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null
                || !"student".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        Object userIdObject = session.getAttribute("userId");

        if (!(userIdObject instanceof Integer)) {
            session.invalidate();
            response.sendRedirect("login.jsp");
            return;
        }

        int studentId = (Integer) userIdObject;

        List<Complaint> complaints =
                complaintDAO.getComplaintsByStudent(studentId);

        request.setAttribute("complaints", complaints);

        request.getRequestDispatcher("track-complaint.jsp")
               .forward(request, response);
    }
}
