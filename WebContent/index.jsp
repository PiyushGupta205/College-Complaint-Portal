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
<html>
<head>
    <meta charset="UTF-8">
    <title>College Complaint Portal</title>
    <link rel="stylesheet" href="css/style.css">
</head>

<body>

<div class="home-page">

    <nav class="home-nav">
        <div class="home-brand">
            <div class="home-logo">CC</div>
            <span>College Complaint Portal</span>
        </div>

        <div class="home-links">
            <a href="#features">Features</a>
            <a href="login.jsp" class="home-login">Login</a>
            <a href="register.jsp" class="home-register">Register</a>
        </div>
    </nav>

    <section class="home-hero">

        <div class="home-hero-content">

            <div class="home-badge">
                College Complaint Management System
            </div>

            <h1>
                Your complaint<br>
                <span>deserves a record.</span>
            </h1>

            <p>
                A simple and organized way for students to report
                college-related problems, track their progress and
                stay informed until the complaint is resolved.
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

        <div class="portal-glance portal-glance-wrap">

            <div class="portal-glance-header">
                <span class="portal-glance-label">WHAT THIS PORTAL DOES</span>
                <h2>One place for every complaint.</h2>
                <p>
                    The portal keeps complaint records organized and
                    makes the resolution process easier to follow.
                </p>
            </div>

            <div class="portal-glance-items">

                <div class="portal-glance-item">
                    <div class="portal-glance-icon">01</div>
                    <div>
                        <strong>Students</strong>
                        <p>Submit complaints with complete details.</p>
                    </div>
                </div>

                <div class="portal-glance-item">
                    <div class="portal-glance-icon">02</div>
                    <div>
                        <strong>Faculty</strong>
                        <p>Handle assigned complaints and update progress.</p>
                    </div>
                </div>

                <div class="portal-glance-item">
                    <div class="portal-glance-icon">03</div>
                    <div>
                        <strong>Administrator</strong>
                        <p>Review complaints and assign them for handling.</p>
                    </div>
                </div>

                <div class="portal-glance-item">
                    <div class="portal-glance-icon">04</div>
                    <div>
                        <strong>Clear Status</strong>
                        <p>Pending → In Progress → Resolved.</p>
                    </div>
                </div>

            </div>

        </div>

    </section>

    <section id="features" class="home-features">

        <div class="home-section-heading">
            <span>WHY THIS PORTAL?</span>
            <h2>From reporting a problem to tracking its resolution.</h2>
        </div>

        <div class="home-feature-grid">

            <div class="home-feature-card">
                <h3>Submit</h3>
                <p>
                    Students can report issues by providing the
                    complaint title, category, location and description.
                </p>
            </div>

            <div class="home-feature-card">
                <h3>Track</h3>
                <p>
                    Every complaint receives a unique complaint ID
                    and can be checked through the student's complaint history.
                </p>
            </div>

            <div class="home-feature-card">
                <h3>Resolve</h3>
                <p>
                    Complaints move through a clear workflow from
                    Pending to In Progress and finally Resolved.
                </p>
            </div>

        </div>

    </section>

</div>

</body>
</html>
