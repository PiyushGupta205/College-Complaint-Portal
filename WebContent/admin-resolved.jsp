<%@ page contentType="text/html;charset=UTF-8" trimDirectiveWhitespaces="true" %>
<%@ page import="com.complaintportal.util.HtmlUtil" %>
<%@ page import="java.util.List" %>
<%@ page import="com.complaintportal.model.Complaint" %>
<%
    if (session.getAttribute("userId") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    String adminName = (String) session.getAttribute("name");
    List<Complaint> complaints = (List<Complaint>) request.getAttribute("complaints");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Resolved Complaints | College Complaint Portal</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="app-layout">
    <aside class="sidebar">
        <div class="sidebar-brand">
            <div class="sidebar-logo"><img src="images/college-logo.svg" alt="College Complaint Portal"></div>
            <div class="sidebar-brand-text"><strong>Complaint Portal</strong><span>Administrator Panel</span></div>
        </div>
        <div class="sidebar-section">Management</div>
        <nav class="sidebar-nav">
            <a href="admin-dashboard.jsp"><span class="nav-icon">&#8962;</span>Dashboard</a>
            <a href="AdminComplaintsServlet"><span class="nav-icon">&#9638;</span>All Complaints</a>
            <a href="AdminDirectoryServlet?type=students"><span class="nav-icon">&#9993;</span>Students</a>
            <a href="AdminDirectoryServlet?type=faculty"><span class="nav-icon">&#9733;</span>Faculty</a>
            <a href="AdminComplaintsServlet?view=resolved" class="active"><span class="nav-icon">&#10003;</span>Resolved Complaints</a>
        </nav>
        <div class="sidebar-section">Account</div>
        <nav class="sidebar-nav">
            <a href="#" onclick="openLogoutModal(); return false;"><span class="nav-icon">&#8618;</span>Logout</a>
        </nav>
    </aside>

    <main class="main-content">
        <header class="topbar">
            <div class="topbar-title"><h1>Resolved Complaints</h1><p>Review complaints that have been resolved</p></div>
            <div class="user-area">
                <div class="user-avatar">A</div>
                <div class="user-info"><strong><%= HtmlUtil.escapeHtml(adminName == null ? "Administrator" : adminName) %></strong><span>Administrator</span></div>
            </div>
        </header>

        <section class="page-content">
            <div class="page-header">
                <div><h1>Resolved Complaints</h1><p>View the student and faculty details for resolved complaints.</p></div>
            </div>

            <div class="card">
                <div class="card-header"><h2>Resolved Records</h2><p>Only complaints with Resolved status are shown here.</p></div>
                <div class="table-wrapper">
                <%
                    boolean hasResolved = false;
                    if (complaints != null) {
                        for (Complaint complaint : complaints) {
                            if ("Resolved".equals(complaint.getStatus())) {
                                hasResolved = true;
                                break;
                            }
                        }
                    }
                %>
                <% if (!hasResolved) { %>
                        <div class="empty-state">
                            <div class="empty-icon">&#10003;</div>
                            <h3>No resolved complaints found</h3>
                            <p>Resolved complaints will appear here once their status is updated.</p>
                        </div>
                    <% } else { %>
                        <table class="data-table">
                            <thead><tr><th>Student ID</th><th>Faculty Name</th><th>Status</th></tr></thead>
                            <tbody>
                            <% for (Complaint complaint : complaints) {
                                    if (!"Resolved".equals(complaint.getStatus())) continue;
                            %>
                                <tr>
                                    <td><%= complaint.getStudentId() %></td>
                                    <td><%= complaint.getFacultyName() == null ? "Not available" : HtmlUtil.escapeHtml(complaint.getFacultyName()) %></td>
                                    <td><span class="status-badge status-resolved">Resolved</span></td>
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
    <div class="logout-modal" role="dialog" aria-modal="true" aria-labelledby="logoutTitle">
        <div class="logout-modal-icon">&#8618;</div>
        <h3 id="logoutTitle">Are you sure you want to logout?</h3>
        <p>You will need to login again to access your account.</p>
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
