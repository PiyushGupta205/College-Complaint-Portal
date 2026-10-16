<%@ page contentType="text/html;charset=UTF-8" trimDirectiveWhitespaces="true" %>
<%@ page import="com.complaintportal.dao.ComplaintDAO" %>
<%@ page import="com.complaintportal.dao.UserDAO" %>

<%
    if (session.getAttribute("userId") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    String adminName = (String) session.getAttribute("name");

    ComplaintDAO complaintDAO = new ComplaintDAO();
    UserDAO userDAO = new UserDAO();

    int[] stats = complaintDAO.getStats();

    int totalComplaints = stats[0];
    int pendingComplaints = stats[1];
    int progressComplaints = stats[2];
    int resolvedComplaints = stats[3];

    int totalStudents = userDAO.countStudents();
    int totalFaculty = userDAO.countFaculty();

    String firstLetter =
        (adminName != null && !adminName.isEmpty())
        ? adminName.substring(0, 1).toUpperCase()
        : "A";
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Complaint Administration | College Complaint Portal</title>

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

            <a href="admin-dashboard.jsp" class="active">
                <span class="nav-icon">&#8962;</span>
                Dashboard
            </a>

            <a href="AdminComplaintsServlet">
                <span class="nav-icon">&#9638;</span>
                All Complaints
            </a>

            <a href="AdminDirectoryServlet?type=students">
                <span class="nav-icon">&#9993;</span>
                Students
            </a>

            <a href="AdminDirectoryServlet?type=faculty">
                <span class="nav-icon">&#9733;</span>
                Faculty
            </a>

        </nav>


        <div class="sidebar-section">ACCOUNT</div>

        <nav class="sidebar-nav">

            <a href="#" onclick="openLogoutModal(); return false;">
                <span class="nav-icon">&#8618;</span>
                Logout
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

                <div class="user-avatar">
                    <%= firstLetter %>
                </div>

                <div class="user-info">
                    <strong><%= adminName %></strong>
                    <span>Administrator</span>
                </div>

            </div>

        </header>


        <section class="page-content role-dashboard">


            <div class="page-header">

                <div>
                    <h1>System Overview</h1>

                    <p>
                        Monitor users, complaints and overall resolution progress.
                    </p>
                </div>

                <a href="AdminComplaintsServlet" class="btn btn-primary">
                    Review & Assign Complaints
                </a>

            </div>


            <div class="role-action-grid">


                <div class="role-stat-card" role="link" tabindex="0" onclick="window.location.href='AdminComplaintsServlet'" onkeydown="if(event.key==='Enter'||event.key===' ')window.location.href='AdminComplaintsServlet'">

                    <div class="role-stat-icon">&#9638;</div>

                    <div>
                        <span>Total Complaints</span>
                        <strong><%= totalComplaints %></strong>
                        <small>All complaints in the system</small>
                    </div>

                </div>


                <div class="role-stat-card" role="link" tabindex="0" onclick="window.location.href='AdminDirectoryServlet?type=students'" onkeydown="if(event.key==='Enter'||event.key===' ')window.location.href='AdminDirectoryServlet?type=students'">

                    <div class="role-stat-icon">&#9993;</div>

                    <div>
                        <span>Registered Students</span>
                        <strong><%= totalStudents %></strong>
                        <small>Registered students</small>
                    </div>

                </div>


                <div class="role-stat-card" role="link" tabindex="0" onclick="window.location.href='AdminDirectoryServlet?type=faculty'" onkeydown="if(event.key==='Enter'||event.key===' ')window.location.href='AdminDirectoryServlet?type=faculty'">

                    <div class="role-stat-icon progress">&#8618;</div>

                    <div>
                        <span>Available Faculty</span>
                        <strong><%= totalFaculty %></strong>
                        <small>Faculty members</small>
                    </div>

                </div>


                <div class="role-stat-card">

                    <div class="role-stat-icon success">&#10003;</div>

                    <div>
                        <span>Resolved</span>
                        <strong><%= resolvedComplaints %></strong>
                        <small>Completed complaints</small>
                    </div>

                </div>


            </div>


            <div class="role-status-row">

                <div class="mini-status-card">

                    <span>Pending</span>
                    <strong><%= pendingComplaints %></strong>

                </div>

                <div class="mini-status-card">

                    <span>In Progress</span>
                    <strong><%= progressComplaints %></strong>

                </div>

                <div class="mini-status-card">

                    <span>Resolved</span>
                    <strong><%= resolvedComplaints %></strong>

                </div>

            </div>


            <div class="role-info-card">

                <div class="role-info-header">

                    <div>
                        <h2>Administrator Workflow</h2>

                        <p>
                            Review complaints, assign faculty and monitor their progress.
                        </p>
                    </div>

                    <a href="AdminComplaintsServlet" class="btn btn-outline">
                        Open Complaints
                    </a>

                </div>


                <div class="role-steps">


                    <div class="role-step">

                        <span>01</span>

                        <div>
                            <strong>Review</strong>
                            <p>View complaints submitted by students.</p>
                        </div>

                    </div>


                    <div class="role-step">

                        <span>02</span>

                        <div>
                            <strong>Assign</strong>
                            <p>Assign each complaint to the concerned faculty member.</p>
                        </div>

                    </div>


                    <div class="role-step">

                        <span>03</span>

                        <div>
                            <strong>Monitor</strong>
                            <p>Track pending, in-progress and resolved complaints.</p>
                        </div>

                    </div>


                    <div class="role-step">

                        <span>04</span>

                        <div>
                            <strong>Manage</strong>
                            <p>Keep the complaint workflow organized and centralized.</p>
                        </div>

                    </div>


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
