<%@ page contentType="text/html;charset=UTF-8" trimDirectiveWhitespaces="true" %>
<%@ page import="java.util.List" %>
<%@ page import="com.complaintportal.model.Complaint" %>
<%
    if (session.getAttribute("userId") == null
            || !"student".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    String studentName = (String) session.getAttribute("name");
    List<Complaint> complaints =
            (List<Complaint>) request.getAttribute("complaints");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Track Complaint Status | College Complaint Portal</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="app-layout">
    <aside class="sidebar">
        <div class="sidebar-brand">
            <div class="sidebar-logo"><img src="images/college-logo.svg" alt="College Complaint Portal"></div>
            <div class="sidebar-brand-text"><strong>Complaint Portal</strong><span>Student Panel</span></div>
        </div>
        <div class="sidebar-section">Main Menu</div>
        <nav class="sidebar-nav">
            <a href="student-dashboard.jsp"><span class="nav-icon">&#8962;</span>Dashboard</a>
            <a href="submit-complaint.jsp"><span class="nav-icon">&#65291;</span>Submit Complaint</a>
            <a href="MyComplaintsServlet"><span class="nav-icon">&#9638;</span>My Complaints</a>
            <a href="TrackComplaintServlet" class="active"><span class="nav-icon">&#10003;</span>Track Status</a>
        </nav>
        <div class="sidebar-section">Account</div>
        <nav class="sidebar-nav">
            <a href="#" onclick="openLogoutModal(); return false;"><span class="nav-icon">&#8618;</span>Logout</a>
        </nav>
    </aside>

    <main class="main-content">
        <header class="topbar">
            <div class="topbar-title">
                <h1>Track Complaint Status</h1>
                <p>Follow the progress of your complaints</p>
            </div>
            <div class="user-area">
                <div class="user-avatar"><%= studentName != null && !studentName.isEmpty() ? studentName.substring(0, 1).toUpperCase() : "S" %></div>
                <div class="user-info"><strong><%= studentName == null ? "Student" : studentName %></strong><span>Student</span></div>
            </div>
        </header>

        <section class="page-content">
            <div class="page-header">
                <div>
                    <h1>Complaint Progress</h1>
                    <p>Check the latest status of each submitted complaint.</p>
                </div>
                <a href="MyComplaintsServlet" class="btn btn-primary">My Complaints</a>
            </div>

            <% if (complaints == null || complaints.isEmpty()) { %>
                <div class="card">
                    <div class="empty-state">
                        <div class="empty-icon">&#10003;</div>
                        <h3>No complaints to track</h3>
                        <p>You have not submitted any complaints yet.</p>
                        <div style="margin-top:18px;"><a href="submit-complaint.jsp" class="btn btn-primary">Submit a Complaint</a></div>
                    </div>
                </div>
            <% } else { %>
                <div style="display:grid;gap:18px;">
                    <% for (Complaint complaint : complaints) {
                        String status = complaint.getStatus() == null ? "Pending" : complaint.getStatus();
                        int progress = "Resolved".equals(status) ? 3 : "In Progress".equals(status) ? 2 : 1;
                    %>
                        <div class="card" style="padding:22px;">
                            <div style="display:flex;justify-content:space-between;align-items:flex-start;gap:16px;flex-wrap:wrap;">
                                <div>
                                    <p style="color:#6b7280;font-size:13px;margin:0 0 6px;">Complaint #<%= complaint.getComplaintId() %></p>
                                    <h2 style="margin:0 0 8px;"><%= com.complaintportal.util.HtmlUtil.escapeHtml(complaint.getTitle()) %></h2>
                                    <p style="color:#6b7280;margin:0;">Category: <%= com.complaintportal.util.HtmlUtil.escapeHtml(complaint.getCategoryName()) %></p>
                                </div>
                                <% if ("Resolved".equals(status)) { %>
                                    <span class="status-badge status-resolved">Resolved</span>
                                <% } else if ("In Progress".equals(status)) { %>
                                    <span class="status-badge status-progress">In Progress</span>
                                <% } else { %>
                                    <span class="status-badge status-pending"><%= com.complaintportal.util.HtmlUtil.escapeHtml(status) %></span>
                                <% } %>
                            </div>

                            <div style="display:flex;align-items:center;gap:8px;margin-top:24px;flex-wrap:wrap;">
                                <span class="status-badge <%= progress >= 1 ? "status-progress" : "status-pending" %>">1. Pending</span>
                                <span style="color:#9ca3af;">&#8594;</span>
                                <span class="status-badge <%= progress >= 2 ? "status-progress" : "status-pending" %>">2. In Progress</span>
                                <span style="color:#9ca3af;">&#8594;</span>
                                <span class="status-badge <%= progress >= 3 ? "status-resolved" : "status-pending" %>">3. Resolved</span>
                            </div>

                            <div style="margin-top:18px;padding-top:14px;border-top:1px solid #e5e7eb;">
                                <p style="margin:0 0 6px;"><strong>Assigned Faculty:</strong>
                                    <%= complaint.getFacultyName() == null ? "Not Assigned" : com.complaintportal.util.HtmlUtil.escapeHtml(complaint.getFacultyName()) %>
                                </p>
                                <p style="margin:0;color:#6b7280;"><strong>Latest Remarks:</strong>
                                    <%= complaint.getRemarks() == null || complaint.getRemarks().isEmpty() ? "No remarks yet" : com.complaintportal.util.HtmlUtil.escapeHtml(complaint.getRemarks()) %>
                                </p>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } %>
        </section>
    </main>
</div>

<div id="logoutModal" class="logout-modal-overlay" aria-hidden="true">
    <div class="logout-modal">
        <div class="logout-modal-icon">↪</div>
        <h2>Logout?</h2>
        <p>Are you sure you want to logout from your account?</p>
        <div class="logout-modal-actions">
            <button type="button" class="logout-btn-cancel" onclick="closeLogoutModal()">No, Stay</button>
            <a href="LogoutServlet" class="logout-btn-confirm">Yes, Logout</a>
        </div>
    </div>
</div>

<script>
function openLogoutModal() {
    var modal = document.getElementById("logoutModal");
    if (modal) {
        modal.classList.add("show");
        modal.setAttribute("aria-hidden", "false");
    }
}
function closeLogoutModal() {
    var modal = document.getElementById("logoutModal");
    if (modal) {
        modal.classList.remove("show");
        modal.setAttribute("aria-hidden", "true");
    }
}
document.addEventListener("keydown", function(event) {
    if (event.key === "Escape") closeLogoutModal();
});
document.getElementById("logoutModal")?.addEventListener("click", function(event) {
    if (event.target === this) closeLogoutModal();
});
</script>
</body>
</html>
