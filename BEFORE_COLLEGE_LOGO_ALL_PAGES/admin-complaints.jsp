<%@ page contentType="text/html;charset=UTF-8" trimDirectiveWhitespaces="true" %>
<%@ page import="java.util.List" %>
<%@ page import="com.complaintportal.model.Complaint" %>
<%@ page import="com.complaintportal.model.User" %>
<%
    if (session.getAttribute("userId") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    String adminName = (String) session.getAttribute("name");
    List<Complaint> complaints = (List<Complaint>) request.getAttribute("complaints");
    List<User> facultyList = (List<User>) request.getAttribute("facultyList");
    String complaintIdFilter = (String) request.getAttribute("complaintIdFilter");
    String statusFilter = (String) request.getAttribute("statusFilter");
    String categoryFilter = (String) request.getAttribute("categoryFilter");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Complaints | College Complaint Portal</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="app-layout">
    <aside class="sidebar">
        <div class="sidebar-brand">
            <div class="sidebar-logo">CC</div>
            <div class="sidebar-brand-text"><strong>Complaint Portal</strong><span>Administrator Panel</span></div>
        </div>
        <div class="sidebar-section">Management</div>
        <nav class="sidebar-nav">
            <a href="admin-dashboard.jsp"><span class="nav-icon">&#8962;</span>Dashboard</a>
            <a href="AdminComplaintsServlet" class="active"><span class="nav-icon">&#9638;</span>All Complaints</a>
        </nav>
        <div class="sidebar-section">Account</div>
        <nav class="sidebar-nav">
            <a href="#" onclick="openLogoutModal(); return false;"><span class="nav-icon">&#8618;</span>Logout</a>
        </nav>
    </aside>

    <main class="main-content">
        <header class="topbar">
            <div class="topbar-title"><h1>All Complaints</h1><p>Review, filter and assign student complaints</p></div>
            <div class="user-area">
                <div class="user-avatar">A</div>
                <div class="user-info"><strong><%= adminName %></strong><span>Administrator</span></div>
            </div>
        </header>

        <section class="page-content">
            <div class="page-header"><div><h1>Complaint Management</h1><p>Assign complaints to faculty and monitor their progress.</p></div></div>

            <form action="AdminComplaintsServlet" method="get" class="filters">
                <div class="filter-group">
                    <label for="complaintId">Complaint ID</label>
                    <input type="number" id="complaintId" name="complaintId" placeholder="e.g. 1042" min="1" value="<%= complaintIdFilter == null ? "" : complaintIdFilter %>">
                </div>
                <div class="filter-group">
                    <label for="status">Status</label>
                    <select id="status" name="status">
                        <option value="">All Statuses</option>
                        <option value="Pending" <%= "Pending".equals(statusFilter) ? "selected" : "" %>>Pending</option>
                        <option value="In Progress" <%= "In Progress".equals(statusFilter) ? "selected" : "" %>>In Progress</option>
                        <option value="Resolved" <%= "Resolved".equals(statusFilter) ? "selected" : "" %>>Resolved</option>
                    </select>
                </div>
                <div class="filter-group">
                    <label for="category">Category</label>
                    <select id="category" name="category">
                        <option value="">All Categories</option>
                        <option value="Hostel" <%= "Hostel".equals(categoryFilter) ? "selected" : "" %>>Hostel</option>
                        <option value="Academic" <%= "Academic".equals(categoryFilter) ? "selected" : "" %>>Academic</option>
                        <option value="Infrastructure" <%= "Infrastructure".equals(categoryFilter) ? "selected" : "" %>>Infrastructure</option>
                        <option value="Canteen" <%= "Canteen".equals(categoryFilter) ? "selected" : "" %>>Canteen</option>
                        <option value="IT/Network" <%= "IT/Network".equals(categoryFilter) ? "selected" : "" %>>IT/Network</option>
                        <option value="Other" <%= "Other".equals(categoryFilter) ? "selected" : "" %>>Other</option>
                    </select>
                </div>
                <button type="submit" class="btn btn-primary">Apply Filters</button>
                <a href="AdminComplaintsServlet" class="btn btn-outline">Clear</a>
            </form>

            <div class="card">
                <div class="card-header"><h2>Complaint Records</h2><p>Assign each complaint to an appropriate faculty member.</p></div>
                <div class="table-wrapper">
                    <% if (complaints == null || complaints.isEmpty()) { %>
                        <div class="empty-state">
                            <div class="empty-icon">&#10003;</div>
                            <h3>No complaints found</h3>
                            <p>No complaints match the selected filters.</p>
                        </div>
                    <% } else { %>
                        <table class="data-table">
                            <thead><tr><th>ID</th><th>Student</th><th>Complaint</th><th>Category</th><th>Location</th><th>Assigned Faculty</th><th>Status</th><th>Action</th></tr></thead>
                            <tbody>
                            <% for (Complaint complaint : complaints) { %>
                                <tr>
                                    <td>#<%= complaint.getComplaintId() %></td>
                                    <td><strong><%= complaint.getStudentName() %></strong><div style="color:#6b7280;font-size:11px;margin-top:2px;">Student ID: <%= complaint.getStudentId() %></div></td>
                                    <td><strong><%= complaint.getTitle() %></strong><div style="color:#6b7280;font-size:12px;max-width:220px;margin-top:3px;"><%= complaint.getDescription() %></div></td>
                                    <td><%= complaint.getCategoryName() %></td>
                                    <td><%= complaint.getLocation() == null || complaint.getLocation().isEmpty() ? "&mdash;" : complaint.getLocation() %></td>
                                    <td>
                                        <% if (complaint.getFacultyName() == null) { %>
                                            <span style="color:#c2410c;font-size:12px;font-weight:700;">Not Assigned</span>
                                        <% } else { %>
                                            <strong><%= complaint.getFacultyName() %></strong>
                                        <% } %>
                                    </td>
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
                                    <td>
                                        <button type="button" class="btn btn-primary" onclick="openAssignForm(<%= complaint.getComplaintId() %>, <%= complaint.getFacultyId() == null ? 0 : complaint.getFacultyId() %>)">Assign</button>
                                    </td>
                                </tr>
                            <% } %>
                            </tbody>
                        </table>
                    <% } %>
                </div>
            </div>

            <div id="assignPanel" class="card" style="display:none; margin-top:22px;">
                <div class="card-header"><h2>Assign Complaint</h2><p>Select the faculty member responsible for this complaint.</p></div>
                <div class="card-body">
                    <form action="AssignComplaintServlet" method="post">
                        <input type="hidden" id="assignComplaintId" name="complaintId">
                        <div class="form-group">
                            <label for="facultyId">Faculty Member</label>
                            <select id="facultyId" name="facultyId" required>
                                <option value="">Select Faculty</option>
                                <% if (facultyList != null) { for (User faculty : facultyList) { %>
                                    <option value="<%= faculty.getUserId() %>"><%= faculty.getName() %> - <%= faculty.getDepartment() %></option>
                                <% } } %>
                            </select>
                        </div>
                        <div style="display:flex; justify-content:flex-end; gap:10px; margin-top:16px;">
                            <button type="button" class="btn btn-outline" onclick="closeAssignForm()">Cancel</button>
                            <button type="submit" class="btn btn-primary">Assign Complaint</button>
                        </div>
                    </form>
                </div>
            </div>
        </section>
    </main>
</div>

<script>
function openAssignForm(id, facultyId) {
    document.getElementById("assignComplaintId").value = id;
    document.getElementById("facultyId").value = (facultyId && facultyId !== 0) ? facultyId : "";
    document.getElementById("assignPanel").style.display = "block";
    document.getElementById("assignPanel").scrollIntoView({ behavior: "smooth", block: "start" });
}
function closeAssignForm() {
    document.getElementById("assignPanel").style.display = "none";
}
</script>
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








