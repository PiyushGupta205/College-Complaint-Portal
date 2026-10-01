<%@ page contentType="text/html;charset=UTF-8" trimDirectiveWhitespaces="true" %>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Create Student Account | College Complaint Portal</title>

    <link rel="stylesheet" href="css/style.css">

</head>

<body>

<div class="auth-wrapper">

    <div class="auth-visual">

        <div class="auth-brand">

            <div class="logo-badge"><img src="images/college-logo.svg" alt="College Complaint Portal"></div>

            <h1>
                College Complaint Portal
            </h1>

        </div>


        <div class="auth-visual-content">

            <div style="
                display:inline-flex;
                padding:7px 10px;
                border-radius:999px;
                background:rgba(59,130,246,.15);
                color:#93c5fd;
                font-size:10px;
                font-weight:800;
                margin-bottom:18px;
            ">
                STUDENT REGISTRATION
            </div>

            <h2 style="
                font-size:42px;
                line-height:1.18;
                margin-bottom:20px;
            ">
                Create your student account.
            </h2>

            <p style="
                font-size:17px;
                line-height:1.8;
                max-width:560px;
                margin-bottom:28px;
            ">
                Register on the College Complaint Portal to get your
                own account for reporting and tracking college-related
                issues. Once registered, you can submit complaints,
                provide the required details, and monitor their progress
                from your student dashboard.
            </p>

            <div class="auth-points">

                <div class="auth-point">
                    <span>1</span>
                    <div>
                        <strong>Create your account</strong>
                        <small>Enter your basic details and create your student login.</small>
                    </div>
                </div>

                <div class="auth-point">
                    <span>2</span>
                    <div>
                        <strong>Submit a complaint</strong>
                        <small>Report academic, hostel, infrastructure, canteen, IT/network or other college-related issues.</small>
                    </div>
                </div>

                <div class="auth-point">
                    <span>3</span>
                    <div>
                        <strong>Track the progress</strong>
                        <small>Follow your complaint from Pending to In Progress and finally Resolved.</small>
                    </div>
                </div>

            </div>

        </div>
    </div>

    <div class="auth-form-area">

        <div class="auth-card">

            <h2>
                Create account
            </h2>

            <p class="subtitle">
                Register as a student to use the portal.
            </p>


            <% if (request.getAttribute("error") != null) { %>

                <div class="alert alert-error">
                    <%= request.getAttribute("error") %>
                </div>

            <% } %>


            <form action="RegisterServlet" method="post">

                <div class="field">

                    <label>
                        Full name
                    </label>

                    <input
                        type="text"
                        name="name"
                        placeholder="Enter your full name"
                        required
                    >

                </div>


                <div class="field">

                    <label>
                        Institutional email
                    </label>

                    <input
                        type="email"
                        name="email"
                        placeholder="you@college.edu"
                        required
                    >

                </div>


                <div class="field">

                    <label>
                        Password
                    </label>

                    <input
                        type="password"
                        name="password"
                        placeholder="Create a password"
                        required
                    >

                </div>


                <button
                    type="submit"
                    class="btn btn-primary btn-block"
                >
                    Create Your Student Account →
                </button>

            </form>


            <div class="auth-footer">

                Already have an account?

                <a href="login.jsp">
                    Sign in
                </a>

            </div>

        </div>

    </div>

</div>

</body>
</html>



