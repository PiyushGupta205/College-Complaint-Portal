<%@ page contentType="text/html;charset=UTF-8" trimDirectiveWhitespaces="true" %>
<%@ page import="java.util.List" %>
<%@ page import="com.complaintportal.model.User" %>
<%@ page import="com.complaintportal.util.HtmlUtil" %>
<%
    if (session.getAttribute("userId") == null
            || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    String adminName = (String) session.getAttribute("name");
    String directoryTitle = (String) request.getAttribute("directoryTitle");
    String directoryType = (String) request.getAttribute("directoryType");
    List<User> users = (List<User>) request.getAttribute("users");

    if (directoryTitle == null || directoryType == null || users == null) {
        response.sendRedirect("admin-dashboard.jsp");
        return;
    }

    String firstLetter = (adminName != null && !adminName.isEmpty())
        ? adminName.substring(0, 1).toUpperCase() : "A";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= HtmlUtil.escapeHtml(directoryTitle) %> | College Complaint Portal</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="app-layout">
    <aside class="sidebar">
        <div class="sidebar-brand">
            <div class="sidebar-logo"><img src="images/college-logo.svg" alt="College Complaint Portal"></div>
            <div class="sidebar-brand-text">
                <strong>Complaint Portal</strong>
                <span>Administrator Panel</span>
            </div>
        </div>

        <div class="sidebar-section">MANAGEMENT</div>
        <nav class="sidebar-nav">
            <a href="admin-dashboard.jsp">
                <span class="nav-icon">&#8962;</span>Dashboard
            </a>
            <a href="AdminComplaintsServlet">
                <span class="nav-icon">&#9638;</span>All Complaints
            </a>
            <a href="AdminDirectoryServlet?type=students" class="<%= "students".equals(directoryType) ? "active" : "" %>">
                <span class="nav-icon">&#9993;</span>Students
            </a>
            <a href="AdminDirectoryServlet?type=faculty" class="<%= "faculty".equals(directoryType) ? "active" : "" %>">
                <span class="nav-icon">&#9733;</span>Faculty
            </a>
        </nav>

        <div class="sidebar-section">ACCOUNT</div>
        <nav class="sidebar-nav">
            <a href="#" onclick="openLogoutModal(); return false;">
                <span class="nav-icon">&#8618;</span>Logout
            </a>
        </nav>
    </aside>

    <main class="main-content">
        <header class="topbar">
            <div class="topbar-title">
                <h1>Complaint Administration</h1>
                <p>College Complaint Portal</p>
            </div>
            <div class="user-area">
                <div class="user-avatar"><%= HtmlUtil.escapeHtml(firstLetter) %></div>
                <div class="user-info">
                    <strong><%= HtmlUtil.escapeHtml(adminName) %></strong>
                    <span>Administrator</span>
                </div>
            </div>
        </header>

        <section class="page-content role-dashboard">
            <div class="page-header">
                <div>
                    <h1><%= HtmlUtil.escapeHtml(directoryTitle) %></h1>
                    <p>Database records: <%= users.size() %></p>
                </div>
                <a href="admin-dashboard.jsp" class="btn btn-outline">Back to Dashboard</a>
            </div>

            <div class="role-info-card">
                <% if (users.isEmpty()) { %>
                    <p>No records found.</p>
                <% } else { %>
                    <div style="overflow-x:auto;">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <% if ("students".equals(directoryType)) { %>
                                        <th>Email</th>
                                    <% } else { %>
                                        <th>Department</th>
                                    <% } %>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (User user : users) { %>
                                    <tr>
                                        <td>#<%= user.getUserId() %></td>
                                        <td><strong><%= HtmlUtil.escapeHtml(user.getName()) %></strong></td>
                                        <% if ("students".equals(directoryType)) { %>
                                            <td><%= HtmlUtil.escapeHtml(user.getEmail()) %></td>
                                        <% } else { %>
                                            <td><%= user.getDepartment() == null || user.getDepartment().isEmpty()
                                                ? "&mdash;" : HtmlUtil.escapeHtml(user.getDepartment()) %></td>
                                        <% } %>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } %>
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