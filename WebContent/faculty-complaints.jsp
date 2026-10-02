<%@ page contentType="text/html;charset=UTF-8" trimDirectiveWhitespaces="true" %>
<%@ page import="com.complaintportal.util.HtmlUtil" %>
<%@ page import="java.util.List" %>
<%@ page import="com.complaintportal.model.Complaint" %>
<%
    if (session.getAttribute("userId") == null || !"faculty".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    String facultyName = (String) session.getAttribute("name");
    List<Complaint> complaints = (List<Complaint>) request.getAttribute("complaints");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assigned Complaints | College Complaint Portal</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="app-layout">
    <aside class="sidebar">
        <div class="sidebar-brand">
            <div class="sidebar-logo"><img src="images/college-logo.svg" alt="College Complaint Portal"></div>
            <div class="sidebar-brand-text"><strong>Complaint Portal</strong><span>Faculty Panel</span></div>
        </div>
        <div class="sidebar-section">Main Menu</div>
        <nav class="sidebar-nav">
            <a href="faculty-dashboard.jsp"><span class="nav-icon">&#8962;</span>Dashboard</a>
            <a href="FacultyComplaintsServlet" class="active"><span class="nav-icon">&#9638;</span>Assigned Complaints</a>
        </nav>
        <div class="sidebar-section">Account</div>
        <nav class="sidebar-nav">
            <a href="#" onclick="openLogoutModal(); return false;"><span class="nav-icon">&#8618;</span>Logout</a>
        </nav>
    </aside>

    <main class="main-content">
        <header class="topbar">
            <div class="topbar-title"><h1>Assigned Complaints</h1><p>Complaints currently assigned to you</p></div>
            <div class="user-area">
                <div class="user-avatar"><%= facultyName != null && !facultyName.isEmpty() ? facultyName.substring(0, 1).toUpperCase() : "F" %></div>
                <div class="user-info"><strong><%= facultyName %></strong><span>Faculty</span></div>
            </div>
        </header>

        <section class="page-content">
            <div class="page-header"><div><h1>Complaint Queue</h1><p>Review student information and update complaint status.</p></div></div>

            <div class="card">
                <div class="card-header"><h2>Assigned Complaints</h2><p>Select an action for each complaint.</p></div>
                <div class="table-wrapper">
                    <% if (complaints == null || complaints.isEmpty()) { %>
                        <div class="empty-state">
                            <div class="empty-icon">&#10003;</div>
                            <h3>No complaints assigned</h3>
                            <p>There are currently no complaints assigned to you.</p>
                        </div>
                    <% } else { %>
                        <table class="data-table">
                            <thead><tr><th>ID</th><th>Student</th><th>Complaint</th><th>Category</th><th>Location</th><th>Status</th><th>Date</th><th>Action</th></tr></thead>
                            <tbody>
                            <% for (Complaint complaint : complaints) { %>
                                <tr>
                                    <td>#<%= complaint.getComplaintId() %></td>
                                    <td><strong><%= HtmlUtil.escapeHtml(complaint.getStudentName()) %></strong><div style="color:#6b7280;font-size:11px;margin-top:2px;">Student ID: <%= HtmlUtil.escapeHtml(String.valueOf(complaint.getStudentId())) %></div></td>
                                    <td><strong><%= HtmlUtil.escapeHtml(complaint.getTitle()) %></strong><div style="color:#6b7280;font-size:12px;margin-top:3px;max-width:220px;"><%= HtmlUtil.escapeHtml(complaint.getDescription()) %></div></td>
                                    <td><%= HtmlUtil.escapeHtml(complaint.getCategoryName()) %></td>
                                    <td><%= complaint.getLocation() == null || complaint.getLocation().isEmpty() ? "&mdash;" : HtmlUtil.escapeHtml(complaint.getLocation()) %></td>
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
                                    <td><%= complaint.getCreatedAt() == null ? "&mdash;" : complaint.getCreatedAt() %></td>
                                    <td>
                                        <button type="button" class="btn btn-primary" onclick="openUpdateForm(<%= complaint.getComplaintId() %>, '<%= HtmlUtil.escapeJsString(complaint.getStatus()) %>', '<%= complaint.getRemarks() == null ? "" : HtmlUtil.escapeJsString(complaint.getRemarks()) %>')">Update</button>
                                    </td>
                                </tr>
                            <% } %>
                            </tbody>
                        </table>
                    <% } %>
                </div>
            </div>

            <div id="updatePanel" class="card" style="display:none; margin-top:22px;">
                <div class="card-header"><h2>Update Complaint</h2><p>Update the status and provide a response to the student.</p></div>
                <div class="card-body">
                    <form action="UpdateComplaintServlet" method="post">
                        <input type="hidden" id="complaintId" name="complaintId">
                        <div class="form-group">
                            <label for="status">Complaint Status</label>
                            <select id="status" name="status" required>
                                <option value="Pending">Pending</option>
                                <option value="In Progress">In Progress</option>
                                <option value="Resolved">Resolved</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="remarks">Faculty Remarks / Response</label>
                            <textarea id="remarks" name="remarks" placeholder="Enter your response or action taken..."></textarea>
                        </div>
                        <div style="display:flex; justify-content:flex-end; gap:10px; margin-top:16px;">
                            <button type="button" class="btn btn-outline" onclick="closeUpdateForm()">Cancel</button>
                            <button type="submit" class="btn btn-primary">Save Update</button>
                        </div>
                    </form>
                </div>
            </div>
        </section>
    </main>
</div>

<script>
function openUpdateForm(id, status, remarks) {
    document.getElementById("complaintId").value = id;
    document.getElementById("status").value = status;
    document.getElementById("remarks").value = remarks;
    document.getElementById("updatePanel").style.display = "block";
    document.getElementById("updatePanel").scrollIntoView({ behavior: "smooth", block: "start" });
}
function closeUpdateForm() {
    document.getElementById("updatePanel").style.display = "none";
}
</script>
<div id="logoutModal" class="logout-modal-overlay" aria-hidden="true">
    <div class="logout-modal">
        <div class="logout-modal-icon">â†ª</div>
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








