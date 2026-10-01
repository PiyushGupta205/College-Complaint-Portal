<%@ page contentType="text/html;charset=UTF-8" trimDirectiveWhitespaces="true" %>
<%@ page import="com.complaintportal.dao.ComplaintDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="com.complaintportal.model.Complaint" %>
<%
    if (session.getAttribute("userId") == null || !"faculty".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    int facultyId = (int) session.getAttribute("userId");
    String facultyName = (String) session.getAttribute("name");

    List<Complaint> facultyComplaints =
        new ComplaintDAO().getComplaintsByFaculty(facultyId);

    int totalAssigned = facultyComplaints.size();
    int pendingCount = 0;
    int progressCount = 0;
    int resolvedCount = 0;

    for (Complaint complaint : facultyComplaints) {
        if ("Pending".equals(complaint.getStatus())) {
            pendingCount++;
        } else if ("In Progress".equals(complaint.getStatus())) {
            progressCount++;
        } else if ("Resolved".equals(complaint.getStatus())) {
            resolvedCount++;
        }
    }

    String firstLetter =
        (facultyName != null && !facultyName.isEmpty())
        ? facultyName.substring(0, 1).toUpperCase()
        : "F";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Faculty Dashboard | College Complaint Portal</title>
    <link rel="stylesheet" href="css/style.css">
</head>

<body>

<div class="app-layout">

    <aside class="sidebar">

        <div class="sidebar-brand">
            <div class="sidebar-logo"><img src="images/college-logo.svg" alt="College Complaint Portal"></div>

            <div class="sidebar-brand-text">
                <strong>Complaint Portal</strong>
                <span>Faculty Panel</span>
            </div>
        </div>

        <div class="sidebar-section">MAIN MENU</div>

        <nav class="sidebar-nav">

            <a href="faculty-dashboard.jsp" class="active">
                <span class="nav-icon">&#8962;</span>
                Dashboard
            </a>

            <a href="FacultyComplaintsServlet">
                <span class="nav-icon">&#9638;</span>
                Assigned Complaints
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
                <h1>Faculty Dashboard</h1>
                <p>College Complaint Portal</p>
            </div>

            <div class="user-area">

                <div class="user-avatar">
                    <%= firstLetter %>
                </div>

                <div class="user-info">
                    <strong><%= facultyName %></strong>
                    <span>Faculty</span>
                </div>

            </div>

        </header>


        <section class="page-content role-dashboard">

            <div class="page-header">

                <div>
                    <h1>Welcome, <%= facultyName %></h1>
                    <p>
                        Review complaints assigned to you and update their progress.
                    </p>
                </div>

                <a href="FacultyComplaintsServlet" class="btn btn-primary">
                    View Assigned Complaints
                </a>

            </div>


            <div class="role-action-grid">

                <div class="role-stat-card">

                    <div class="role-stat-icon">C</div>

                    <div>
                        <span>Assigned Complaints</span>
                        <strong><%= totalAssigned %></strong>
                        <small>Complaints assigned to you</small>
                    </div>

                </div>


                <div class="role-stat-card">

                    <div class="role-stat-icon warning">!</div>

                    <div>
                        <span>Pending</span>
                        <strong><%= pendingCount %></strong>
                        <small>Complaints awaiting action</small>
                    </div>

                </div>


                <div class="role-stat-card">

                    <div class="role-stat-icon progress">></div>

                    <div>
                        <span>In Progress</span>
                        <strong><%= progressCount %></strong>
                        <small>Complaints being handled</small>
                    </div>

                </div>


                <div class="role-stat-card">

                    <div class="role-stat-icon success">&#10003;</div>

                    <div>
                        <span>Resolved</span>
                        <strong><%= resolvedCount %></strong>
                        <small>Completed complaints</small>
                    </div>

                </div>

            </div>


            <div class="role-info-card">

                <div class="role-info-header">

                    <div>
                        <h2>Faculty Workflow</h2>
                        <p>Handle complaints assigned by the administrator.</p>
                    </div>

                    <a href="FacultyComplaintsServlet" class="btn btn-outline">
                        Open Complaints
                    </a>

                </div>


                <div class="role-steps">

                    <div class="role-step">
                        <span>01</span>
                        <div>
                            <strong>Review</strong>
                            <p>Open the complaints assigned to you.</p>
                        </div>
                    </div>

                    <div class="role-step">
                        <span>02</span>
                        <div>
                            <strong>Work</strong>
                            <p>Investigate the issue and take the required action.</p>
                        </div>
                    </div>

                    <div class="role-step">
                        <span>03</span>
                        <div>
                            <strong>Update</strong>
                            <p>Set the status and add a useful remark.</p>
                        </div>
                    </div>

                    <div class="role-step">
                        <span>04</span>
                        <div>
                            <strong>Resolve</strong>
                            <p>Mark the complaint resolved after the issue is handled.</p>
                        </div>
                    </div>

                </div>

            </div>

        </section>

    </main>

</div>

    <div id="logoutModal" class="logout-modal-overlay">
        <div class="logout-modal">
            <div class="logout-modal-icon">!</div>
            <h3>Logout</h3>
            <p>Are you sure you want to logout?</p>

            <div class="logout-modal-actions">
                <button type="button" class="logout-btn-cancel" onclick="closeLogoutModal()">
                    No
                </button>

                <a href="LogoutServlet" class="logout-btn-confirm">
                    Yes, Logout
                </a>
            </div>
        </div>
    </div>

    <script>
        function openLogoutModal() {
            document.getElementById("logoutModal").style.display = "flex";
        }

        function closeLogoutModal() {
            document.getElementById("logoutModal").style.display = "none";
        }

        document.getElementById("logoutModal").addEventListener("click", function(event) {
            if (event.target === this) {
                closeLogoutModal();
            }
        });
    </script>
</body>
</html>

