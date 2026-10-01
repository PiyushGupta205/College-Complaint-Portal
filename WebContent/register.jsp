<%@ page contentType="text/html;charset=UTF-8" trimDirectiveWhitespaces="true" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Create Account | College Complaint Portal</title>

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
                STUDENT REGISTRATION
            </div>

            <h1>
                Create your account.<br>
                <span>Start reporting clearly.</span>
            </h1>

            <p class="auth-intro">
                Create your student account to report college-related
                issues, keep a record of your complaints, and follow
                their progress from your dashboard.
            </p>


            <div class="auth-role-info">

                <div class="auth-role-item">
                    <span>01</span>

                    <div>
                        <strong>Create</strong>
                        <small>
                            Enter your basic details and create your account.
                        </small>
                    </div>
                </div>


                <div class="auth-role-item">
                    <span>02</span>

                    <div>
                        <strong>Report</strong>
                        <small>
                            Submit academic, hostel, infrastructure and other issues.
                        </small>
                    </div>
                </div>


                <div class="auth-role-item">
                    <span>03</span>

                    <div>
                        <strong>Track</strong>
                        <small>
                            Follow every complaint through its current status.
                        </small>
                    </div>
                </div>

            </div>

        </div>


        <div class="auth-showcase-footer">
            One account. One record. Clear complaint tracking.
        </div>

    </section>


    <!-- RIGHT FORM -->
    <section class="auth-form-area">

        <div class="auth-card">

            <div class="auth-card-top">

                <div>
                    <span class="auth-card-label">
                        STUDENT ACCOUNT
                    </span>

                    <h2>Create account</h2>

                    <p>
                        Register to access the student complaint portal.
                    </p>
                </div>

            </div>


            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-error">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>


            <form action="RegisterServlet" method="post">

                <div class="field">

                    <label>Full name</label>

                    <input
                        type="text"
                        name="name"
                        placeholder="Enter your full name"
                        required>

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
                        placeholder="Create a password"
                        required>

                </div>


                <button
                    type="submit"
                    class="auth-submit">

                    Create account
                    <span>→</span>

                </button>

            </form>


            <div class="auth-footer">
                Already have an account?
                <a href="login.jsp">Sign in</a>
            </div>

        </div>

    </section>

</div>

</body>
</html>
