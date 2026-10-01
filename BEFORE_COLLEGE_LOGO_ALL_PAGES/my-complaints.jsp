<%@ page contentType="text/html;charset=UTF-8" trimDirectiveWhitespaces="true" %>
<%@ page import="java.util.List" %>
<%@ page import="com.complaintportal.model.Complaint" %>
<%
    if (session.getAttribute("userId") == null || !"student".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    String studentName = (String) session.getAttribute("name");
    List<Complaint> complaints = (List<Complaint>) request.getAttribute("complaints");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Complaints | College Complaint Portal</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="app-layout">
    <aside class="sidebar">
        <div class="sidebar-brand">
            <div class="sidebar-logo">CC</div>
            <div class="sidebar-brand-text"><strong>Complaint Portal</strong><span>Student Panel</span></div>
        </div>
        <div class="sidebar-section">Main Menu</div>
        <nav class="sidebar-nav">
            <a href="student-dashboard.jsp"><span class="nav-icon">&#8962;</span>Dashboard</a>
            <a href="submit-complaint.jsp"><span class="nav-icon">&#65291;</span>Submit Complaint</a>
            <a href="MyComplaintsServlet" class="active"><span class="nav-icon">&#9638;</span>My Complaints</a>
        </nav>
        <div class="sidebar-section">Account</div>
        <nav class="sidebar-nav">
            <a href="#" onclick="openLogoutModal(); return false;"><span class="nav-icon">&#8618;</span>Logout</a>
        </nav>
    </aside>

    <main class="main-content">
        <header class="topbar">
            <div class="topbar-title"><h1>My Complaints</h1><p>Track all complaints submitted by you</p></div>
            <div class="user-area">
                <div class="user-avatar"><%= studentName != null && !studentName.isEmpty() ? studentName.substring(0, 1).toUpperCase() : "S" %></div>
                <div class="user-info"><strong><%= studentName %></strong><span>Student</span></div>
            </div>
        </header>

        <section class="page-content">
            <div class="page-header">
                <div><h1>Complaint History</h1><p>View complaint details, status and faculty remarks.</p></div>
                <a href="submit-complaint.jsp" class="btn btn-primary">+ New Complaint</a>
            </div>

            <div class="card">
                <div class="card-header"><h2>Submitted Complaints</h2><p>Your latest complaints appear first.</p></div>
                <div class="table-wrapper">
                    <% if (complaints == null || complaints.isEmpty()) { %>
                        <div class="empty-state">
                            <div class="empty-icon">&#9638;</div>
                            <h3>No complaints found</h3>
                            <p>You have not submitted any complaints yet.</p>
                            <div style="margin-top:18px;"><a href="submit-complaint.jsp" class="btn btn-primary">Submit Your First Complaint</a></div>
                        </div>
                    <% } else { %>
                        <table class="data-table">
                            <thead><tr><th>ID</th><th>Complaint</th><th>Category</th><th>Location</th><th>Assigned Faculty</th><th>Status</th><th>Remarks</th><th>Date</th></tr></thead>
                            <tbody>
                            <% for (Complaint complaint : complaints) { %>
                                <tr>
                                    <td>#<%= complaint.getComplaintId() %></td>
                                    <td><strong><%= complaint.getTitle() %></strong><div style="color:#6b7280;font-size:12px;margin-top:3px;"><%= complaint.getDescription() %></div></td>
                                    <td><%= complaint.getCategoryName() %></td>
                                    <td><%= complaint.getLocation() == null || complaint.getLocation().isEmpty() ? "&mdash;" : complaint.getLocation() %></td>
                                    <td><%= complaint.getFacultyName() == null ? "Not Assigned" : complaint.getFacultyName() %></td>
                                    <td>
                                        <% if ("Pending".equals(complaint.getStatus())) { %>
                                            <span class="status-badge status-pending">Pending</span>
                                        <% } else if ("In Progress".equals(complaint.getStatus())) { %>
                                            <span class="status-badge status-progress">In Progress</span>
                                        <% } else if ("Resolved".equals(complaint.getStatus())) { %>
                                            <span class="status-badge status-resolved">Resolved</span>
                                        <% } else { %>
                                            <span class="status-badge status-pending"><%= complaint.getStatus() %></span>
                                        <% } %>
                                    </td>
                                    <td><%= complaint.getRemarks() == null || complaint.getRemarks().isEmpty() ? "No remarks yet" : complaint.getRemarks() %></td>
                                    <td><%= complaint.getCreatedAt() == null ? "&mdash;" : complaint.getCreatedAt() %></td>
                                </tr>
                            <% } %>
                            </tbody>
                        </table>
                    <% } %>
                </div>
            </div>
        </section>
    </main>
</div>
<div id="logoutModal" class="logout-modal-overlay" aria-hidden="true">
    <div class="logout-modal">
        <div class="logout-modal-icon">↪</div>
        <h2>Logout?</h2>
        <p>Are you sure you want to logout from your account?</p>

        <div class="logout-modal-actions">
            <button type="button" class="logout-btn-cancel" onclick="closeLogoutModal()">
                No, Stay
            </button>

            <a href="LogoutServlet" class="logout-btn-confirm">
                Yes, Logout
            </a>
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
    if (event.key === "Escape") {
        closeLogoutModal();
    }
});

document.getElementById("logoutModal")?.addEventListener("click", function(event) {
    if (event.target === this) {
        closeLogoutModal();
    }
});
</script>

</body>
</html>






