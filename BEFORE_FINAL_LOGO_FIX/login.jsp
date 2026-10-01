<%@ page contentType="text/html;charset=UTF-8" trimDirectiveWhitespaces="true" %>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Login | College Complaint Portal</title>

    <link rel="stylesheet" href="css/style.css">

</head>

<body>

<div class="auth-wrapper">

    <div class="auth-visual">

        <div class="auth-brand">

            <div class="logo-badge">
                CC
            </div>

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
                margin-bottom:15px;
            ">
                SECURE PORTAL ACCESS
            </div>

            <h2>
                Everything about your complaint,
                in one place.
            </h2>

            <p>
                Choose your role and sign in to access the
                appropriate complaint management workspace.
            </p>

            <div class="auth-points">

                <div class="auth-point">
                    <span>✓</span>
                    Student complaint tracking
                </div>

                <div class="auth-point">
                    <span>✓</span>
                    Faculty complaint handling
                </div>

                <div class="auth-point">
                    <span>✓</span>
                    Administration monitoring
                </div>

            </div>

        </div>

    </div>


    <div class="auth-form-area">

        <div class="auth-card">

            <div style="
                display:flex;
                align-items:center;
                gap:10px;
                margin-bottom:20px;
            ">

                <div style="
                    width:38px;
                    height:38px;
                    display:flex;
                    align-items:center;
                    justify-content:center;
                    border-radius:10px;
                    background:#eff6ff;
                    color:#2563eb;
                    font-weight:900;
                ">
                    CC
                </div>

                <div>

                    <strong style="
                        display:block;
                        color:#172033;
                        font-size:13px;
                    ">
                        Complaint Portal
                    </strong>

                    <span style="
                        color:#94a3b8;
                        font-size:10px;
                    ">
                        College Management System
                    </span>

                </div>

            </div>


            <h2>
                Welcome back
            </h2>

            <p class="subtitle">
                Sign in to continue to your dashboard.
            </p>


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
                        <input
                            type="radio"
                            name="role"
                            value="student"
                            checked
                        >
                        <span>Student</span>
                    </label>

                    <label>
                        <input
                            type="radio"
                            name="role"
                            value="faculty"
                        >
                        <span>Faculty</span>
                    </label>

                    <label>
                        <input
                            type="radio"
                            name="role"
                            value="admin"
                        >
                        <span>Admin</span>
                    </label>

                </div>


                <div style="
                    margin:12px 0 18px;
                    padding:10px 12px;
                    border-radius:9px;
                    background:#f8fafc;
                    border:1px solid #e2e8f0;
                    color:#64748b;
                    font-size:11px;
                    line-height:1.5;
                ">
                    Select the account type you are using before signing in.
                </div>


                <div class="field">

                    <label>
                        Email address
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
                        placeholder="Enter your password"
                        required
                    >

                </div>


                <button
                    type="submit"
                    class="btn btn-primary btn-block"
                >
                    Sign in to Portal →
                </button>

            </form>


            <div class="auth-footer">
                New student?
                <a href="register.jsp">
                    Create an account
                </a>
            </div>

        </div>

    </div>

</div>

</body>
</html>

