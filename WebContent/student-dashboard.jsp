<%@ page contentType="text/html;charset=UTF-8" trimDirectiveWhitespaces="true" %>
<%
    if (session.getAttribute("userId") == null || !"student".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    String studentName = (String) session.getAttribute("name");
    String firstLetter = (studentName != null && !studentName.isEmpty())
            ? studentName.substring(0, 1).toUpperCase()
            : "S";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard | College Complaint Portal</title>
    <link rel="stylesheet" href="css/style.css">
</head>

<body>

<div class="app-layout">

    <aside class="sidebar">

        <div class="sidebar-brand">
            <div class="sidebar-logo"><img src="images/college-logo.svg" alt="College Complaint Portal"></div>
            <div class="sidebar-brand-text">
                <strong>Complaint Portal</strong>
                <span>Student Panel</span>
            </div>
        </div>

        <div class="sidebar-section">MAIN MENU</div>

        <nav class="sidebar-nav">
            <a href="student-dashboard.jsp" class="active">
                <span class="nav-icon">&#8962;</span>
                Dashboard
            </a>

            <a href="submit-complaint.jsp">
                <span class="nav-icon">&#43;</span>
                Submit Complaint
            </a>

            <a href="MyComplaintsServlet">
                <span class="nav-icon">&#9638;</span>
                My Complaints
            </a>
            <a href="TrackComplaintServlet">
                <span class="nav-icon">&#10003;</span>
                Track Status
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
                <h1>Student Dashboard</h1>
                <p>College Complaint Portal</p>
            </div>

            <div class="user-area">
                <div class="user-avatar"><%= firstLetter %></div>

                <div class="user-info">
                    <strong><%= studentName %></strong>
                    <span>Student</span>
                </div>
            </div>

        </header>


        <section class="page-content student-dashboard">

            <div class="page-header student-welcome">

                <div>
                    <h1>Welcome, <%= studentName %></h1>
                    <p>
                        Submit a complaint or track the status of an existing complaint.
                    </p>
                </div>

                <a href="submit-complaint.jsp" class="btn btn-primary">
                    + Report an Issue
                </a>

            </div>


            <div class="student-action-grid">

                <a href="submit-complaint.jsp" class="student-action-card">

                    <div class="student-action-icon">&#10003;</div>

                    <div>
                        <h2>Report an Issue</h2>
                        <p>
                            Report an issue related to academics, hostel,
                            infrastructure, canteen or IT.
                        </p>
                    </div>

                    <span class="student-action-arrow">&#8594;</span>

                </a>


                <a href="MyComplaintsServlet" class="student-action-card">

                    <div class="student-action-icon">&#10003;</div>

                    <div>
                        <h2>My Complaint History</h2>
                        <p>
                            View your submitted complaints, current status
                            and faculty remarks.
                        </p>
                    </div>

                    <span class="student-action-arrow">&#8594;</span>

                </a>


                <a href="TrackComplaintServlet" class="student-action-card student-status-card">

                    <div class="student-action-icon">&#10003;</div>

                    <div>
                        <h2>Track Complaint Status</h2>
                        <p>
                            Complaints move through three stages:
                        </p>

                        <div class="status-flow">
                            <span>Pending</span>
                            <b>&#8594;</b>
                            <span>In Progress</span>
                            <b>&#8594;</b>
                            <span>Resolved</span>
                        </div>
                    </div>

                    <span class="student-action-arrow">&#8594;</span>

                </a>

            </div>


            <div class="student-info-card">

                <div class="student-info-header">
                    <div>
                        <h2>How the Portal Works</h2>
                        <p>Simple steps for submitting and tracking a complaint.</p>
                    </div>
                </div>

                <div class="student-steps">

                    <div class="student-step">
                        <span>01</span>
                        <div>
                            <strong>Submit</strong>
                            <p>Enter the complaint title, category, location and description.</p>
                        </div>
                    </div>

                    <div class="student-step">
                        <span>02</span>
                        <div>
                            <strong>Review</strong>
                            <p>The administrator reviews the complaint and assigns it to faculty.</p>
                        </div>
                    </div>

                    <div class="student-step">
                        <span>03</span>
                        <div>
                            <strong>Update</strong>
                            <p>The assigned faculty member works on the issue and updates its status.</p>
                        </div>
                    </div>

                    <div class="student-step">
                        <span>04</span>
                        <div>
                            <strong>Resolve</strong>
                            <p>Once handled, the complaint is marked as resolved.</p>
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
