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

    <!-- HEADER -->
    <nav class="home-nav">

        <div class="home-brand">
            <div class="home-logo">
                <img src="images/college-logo.svg"
                     alt="College Complaint Portal">
            </div>

            <span>College Complaint Portal</span>
        </div>

        <div class="home-links">
            <a href="login.jsp" class="home-login">
                Login
            </a>

            <a href="register.jsp" class="home-register">
                Register
            </a>
        </div>

    </nav>


    <!-- MAIN HERO -->
    <main class="professional-home">

        <section class="professional-copy">

            <div class="professional-eyebrow">
                COLLEGE COMPLAINT MANAGEMENT SYSTEM
            </div>

            <h1>
                Report the issue.
                <span>Follow the resolution.</span>
            </h1>

            <p class="professional-intro">
                A centralized portal for recording college-related
                complaints, assigning them to the appropriate faculty,
                and tracking their progress until resolution.
            </p>


            <div class="professional-actions">

                <a href="register.jsp"
                   class="professional-primary">
                    Create Student Account
                    <span>→</span>
                </a>

                <a href="login.jsp"
                   class="professional-secondary">
                    Login to Portal
                </a>

            </div>


            <div class="professional-note">
                <span class="note-dot"></span>
                One organized record from submission to resolution
            </div>

        </section>


        <!-- WORKFLOW PANEL -->
        <section class="workflow-panel">

            <div class="workflow-heading">

                <div>
                    <span class="workflow-label">
                        COMPLAINT WORKFLOW
                    </span>

                    <h2>
                        From submission<br>
                        to resolution.
                    </h2>
                </div>

                <div class="workflow-badge">
                    04 STEPS
                </div>

            </div>


            <div class="workflow-list">

                <div class="workflow-item">

                    <div class="workflow-number">
                        01
                    </div>

                    <div class="workflow-content">
                        <h3>Submit</h3>

                        <p>
                            Student records the issue with
                            category, location and description.
                        </p>
                    </div>

                </div>


                <div class="workflow-item">

                    <div class="workflow-number">
                        02
                    </div>

                    <div class="workflow-content">
                        <h3>Assign</h3>

                        <p>
                            Administrator reviews the complaint
                            and assigns it to faculty.
                        </p>
                    </div>

                </div>


                <div class="workflow-item">

                    <div class="workflow-number">
                        03
                    </div>

                    <div class="workflow-content">
                        <h3>Update</h3>

                        <p>
                            Faculty reviews the issue, updates
                            progress and adds remarks.
                        </p>
                    </div>

                </div>


                <div class="workflow-item">

                    <div class="workflow-number">
                        04
                    </div>

                    <div class="workflow-content">
                        <h3>Track</h3>

                        <p>
                            Student checks the complaint history
                            and sees the latest status.
                        </p>
                    </div>

                </div>

            </div>


            <div class="workflow-footer">

                <div class="workflow-status-label">
                    CURRENT STATUS FLOW
                </div>

                <div class="workflow-status">
                    <span>Pending</span>
                    <b>→</b>
                    <span>In Progress</span>
                    <b>→</b>
                    <span>Resolved</span>
                </div>

            </div>

        </section>

    </main>

</div>

</body>
</html>
