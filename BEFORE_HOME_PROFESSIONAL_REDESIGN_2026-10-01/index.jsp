<%@ page contentType="text/html;charset=UTF-8" trimDirectiveWhitespaces="true" %>
<%
    String role = (String) session.getAttribute("role");

    if ("student".equals(role)) {
        response.sendRedirect("student-dashboard.jsp");
        return;
    }

    if ("faculty".equals(role)) {
        response.sendRedirect("faculty-dashboard.jsp");
        return;
    }

    if ("admin".equals(role)) {
        response.sendRedirect("admin-dashboard.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>College Complaint Portal</title>
    <link rel="stylesheet" href="css/style.css">
</head>

<body>

<div class="home-page">

    <nav class="home-nav">

        <div class="home-brand">
            <div class="home-logo">
                <img src="images/college-logo.svg" alt="College Complaint Portal">
            </div>
            <span>College Complaint Portal</span>
        </div>

        <div class="home-links">
            <a href="login.jsp" class="home-login">Login</a>
            <a href="register.jsp" class="home-register">Register</a>
        </div>

    </nav>


    <main class="home-hero">

        <div class="home-hero-content">

            <div class="home-badge">
                College Complaint Management System
            </div>

            <h1>
                Raise an issue.<br>
                <span>Track its progress.</span>
            </h1>

            <p>
                A simple and organized platform for students to report
                college-related issues, follow their complaint status,
                and stay informed until the matter is resolved.
            </p>

            <div class="home-actions">
                <a href="register.jsp" class="home-primary">
                    Create Student Account
                </a>

                <a href="login.jsp" class="home-secondary">
                    Login to Portal
                </a>
            </div>

        </div>


        <div class="portal-glance">

            <div class="portal-glance-label">
                HOW THE PORTAL WORKS
            </div>

            <h2>
                A structured way to handle complaints.
            </h2>

            <p class="portal-glance-intro">
                Every complaint follows a clear process so that the
                issue can be recorded, assigned and tracked properly.
            </p>


            <div class="portal-glance-grid">

                <div class="portal-glance-item">
                    <span>01</span>
                    <div>
                        <strong>Submit</strong>
                        <p>
                            Students provide the complaint title,
                            category, location and description.
                        </p>
                    </div>
                </div>


                <div class="portal-glance-item">
                    <span>02</span>
                    <div>
                        <strong>Assign</strong>
                        <p>
                            The administrator reviews the complaint
                            and assigns it to the appropriate faculty.
                        </p>
                    </div>
                </div>


                <div class="portal-glance-item">
                    <span>03</span>
                    <div>
                        <strong>Update</strong>
                        <p>
                            Faculty members review assigned complaints,
                            update progress and add remarks.
                        </p>
                    </div>
                </div>


                <div class="portal-glance-item">
                    <span>04</span>
                    <div>
                        <strong>Track</strong>
                        <p>
                            Students can check their complaint history
                            and see the latest status.
                        </p>
                    </div>
                </div>

            </div>


            <div class="portal-status">
                <span>Status Flow</span>
                <strong>Pending → In Progress → Resolved</strong>
            </div>

        </div>

    </main>

</div>

</body>
</html>
