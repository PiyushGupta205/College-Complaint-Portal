<%@ page contentType="text/html;charset=UTF-8" trimDirectiveWhitespaces="true" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Sign In | College Complaint Portal</title>

    <link rel="stylesheet" href="css/style.css">
</head>

<body>

<div class="auth-page">

    <!-- LEFT SHOWCASE -->
    <section class="auth-showcase">

        <div class="auth-showcase-brand">

            <div class="auth-logo">
                <img src="images/college-logo.svg"
                     alt="College Complaint Portal">
            </div>

            <span>College Complaint Portal</span>

        </div>


        <div class="auth-showcase-content">

            <div class="auth-eyebrow">
                COLLEGE COMPLAINT MANAGEMENT SYSTEM
            </div>

            <h1>
                Sign in to manage.<br>
                <span>Track what matters.</span>
            </h1>

            <p class="auth-intro">
                Access the workspace designed for your role.
                Students can submit and track complaints, faculty
                can handle assigned issues, and administrators can
                review and assign complaints.
            </p>


            <div class="auth-role-info">

                <div class="auth-role-item">
                    <span>01</span>

                    <div>
                        <strong>Student</strong>
                        <small>
                            Submit complaints and track their progress.
                        </small>
                    </div>
                </div>


                <div class="auth-role-item">
                    <span>02</span>

                    <div>
                        <strong>Faculty</strong>
                        <small>
                            Review assigned complaints and update progress.
                        </small>
                    </div>
                </div>


                <div class="auth-role-item">
                    <span>03</span>

                    <div>
                        <strong>Admin</strong>
                        <small>
                            Review complaints and assign them to faculty.
                        </small>
                    </div>
                </div>

            </div>

        </div>


        <div class="auth-showcase-footer">
            Pending → In Progress → Resolved
        </div>

    </section>


    <!-- RIGHT FORM -->
    <section class="auth-form-area">

        <div class="auth-card">

            <div class="auth-card-top">

                <div>
                    <span class="auth-card-label">
                        PORTAL ACCESS
                    </span>

                    <h2>Sign in</h2>

                    <p>
                        Select your role and enter your account details.
                    </p>
                </div>

            </div>


            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-error">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>


            <% if (request.getAttribute("message") != null) { %>
                <div class="alert alert-success">
                    <%= request.getAttribute("message") %>
                </div>
            <% } %>


            <form action="LoginServlet" method="post">

                <div class="role-toggle">

                    <label>
                        <input type="radio"
                               name="role"
                               value="student"
                               checked>

                        <span>Student</span>
                    </label>


                    <label>
                        <input type="radio"
                               name="role"
                               value="faculty">

                        <span>Faculty</span>
                    </label>


                    <label>
                        <input type="radio"
                               name="role"
                               value="admin">

                        <span>Admin</span>
                    </label>

                </div>


                <div class="field">

                    <label>Email address</label>

                    <input
                        type="email"
                        name="email"
                        placeholder="you@college.edu"
                        required>

                </div>


                <div class="field">

                    <label>Password</label>

                    <input
                        type="password"
                        name="password"
                        placeholder="Enter your password"
                        required>

                </div>


                <button
                    type="submit"
                    class="auth-submit">

                    Sign in
                    <span>→</span>

                </button>

            </form>


            <div class="auth-footer">
                New student?
                <a href="register.jsp">Create an account</a>
            </div>

        </div>

    </section>

</div>

</body>
</html>
