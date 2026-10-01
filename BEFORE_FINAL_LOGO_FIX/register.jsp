<%@ page contentType="text/html;charset=UTF-8" trimDirectiveWhitespaces="true" %>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Create Account | College Complaint Portal</title>

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
                STUDENT REGISTRATION
            </div>

            <h2>
                Create your student account.
            </h2>

            <p>
                Register once and get a dedicated space to
                submit and track your college complaints.
            </p>

            <div class="auth-points">

                <div class="auth-point">
                    <span>1</span>
                    Create your account
                </div>

                <div class="auth-point">
                    <span>2</span>
                    Submit your complaint
                </div>

                <div class="auth-point">
                    <span>3</span>
                    Track its progress
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
                    Create Student Account →
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

