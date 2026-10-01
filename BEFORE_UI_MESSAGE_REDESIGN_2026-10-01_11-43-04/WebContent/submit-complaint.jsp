<%@ page contentType="text/html;charset=UTF-8" trimDirectiveWhitespaces="true" %>
<%
    if (session.getAttribute("userId") == null || !"student".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    String studentName = (String) session.getAttribute("name");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Submit Complaint | College Complaint Portal</title>
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

        <div class="sidebar-section">Main Menu</div>

        <nav class="sidebar-nav">

            <a href="student-dashboard.jsp">
                <span class="nav-icon">&#8962;</span>
                Dashboard
            </a>

            <a href="submit-complaint.jsp" class="active">
                <span class="nav-icon">&#65291;</span>
                Submit Complaint
            </a>

            <a href="MyComplaintsServlet">
                <span class="nav-icon">&#9638;</span>
                My Complaints
            </a>

        </nav>

        <div class="sidebar-section">Account</div>

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
                <h1>Submit Complaint</h1>
                <p>Tell us about the issue you are facing</p>
            </div>

            <div class="user-area">

                <div class="user-avatar">
                    <%= studentName != null && !studentName.isEmpty()
                        ? studentName.substring(0, 1).toUpperCase()
                        : "S" %>
                </div>

                <div class="user-info">
                    <strong><%= studentName %></strong>
                    <span>Student</span>
                </div>

            </div>

        </header>


        <section class="page-content">

            <div class="submit-page">

                <div class="submit-intro">
                    <h1>Report an Issue</h1>
                    <p>
                        Provide accurate information so the complaint can be handled efficiently.
                    </p>
                </div>


                <% if (request.getAttribute("error") != null) { %>

                    <div class="alert alert-error submit-error">
                        <%= request.getAttribute("error") %>
                    </div>

                <% } %>


                <div class="complaint-form-card">

                    <div class="complaint-form-header">

                        <h2>Complaint Details</h2>

                        <p>
                            All fields marked * are required.
                        </p>

                    </div>


                    <div class="complaint-form-body">

                        <form action="SubmitComplaintServlet" method="post">

                            <div class="complaint-form-grid">

                                <!-- TITLE -->
                                <div class="complaint-field">

                                    <label for="title">
                                        Complaint Title *
                                    </label>

                                    <input
                                        type="text"
                                        id="title"
                                        name="title"
                                        placeholder="Enter a short complaint title"
                                        maxlength="150"
                                        required
                                    >

                                </div>


                                <!-- CATEGORY -->
                                <div class="complaint-field">

                                    <label for="categoryId">
                                        Category *
                                    </label>

                                    <select
                                        id="categoryId"
                                        name="categoryId"
                                        required
                                    >
                                        <option value="">
                                            Select complaint category
                                        </option>

                                        <option value="1">Hostel</option>
                                        <option value="2">Academic</option>
                                        <option value="3">Infrastructure</option>
                                        <option value="4">Canteen</option>
                                        <option value="5">IT/Network</option>
                                        <option value="6">Other</option>

                                    </select>

                                </div>


                                <!-- LOCATION - FULL WIDTH -->
                                <div class="complaint-field full-width">

                                    <label for="location">
                                        Location
                                    </label>

                                    <input
                                        type="text"
                                        id="location"
                                        name="location"
                                        placeholder="Example: Hostel Block A"
                                        maxlength="150"
                                    >

                                </div>


                                <!-- DESCRIPTION - FULL WIDTH -->
                                <div class="complaint-field full-width">

                                    <label for="description">
                                        Description *
                                    </label>

                                    <textarea
                                        id="description"
                                        name="description"
                                        placeholder="Describe the issue clearly..."
                                        required
                                    ></textarea>

                                </div>

                            </div>


                            <div class="complaint-form-actions">

                                <a
                                    href="student-dashboard.jsp"
                                    class="btn btn-outline"
                                >
                                    Cancel
                                </a>

                                <button
                                    type="submit"
                                    class="btn btn-primary"
                                >
                                    Submit Complaint
                                </button>

                            </div>

                        </form>

                    </div>

                </div>

            </div>

        </section>

    </main>

</div>

<div id="logoutModal" class="logout-modal-overlay" aria-hidden="true">
    <div class="logout-modal">
        <div class="logout-modal-icon">↪</div>
        <h2>Logout?</h2>
        <p>Are you sure you want to logout from your account?</p>

        <div class="logout-modal-actions">
            <button type="button" class="logout-btn-cancel" onclick="closeLogoutModal()">
                No, Stay
            </button>

            <a href="LogoutServlet" class="logout-btn-confirm">
                Yes, Logout
            </a>
        </div>
    </div>
</div>

<script>
function openLogoutModal() {
    var modal = document.getElementById("logoutModal");
    if (modal) {
        modal.classList.add("show");
        modal.setAttribute("aria-hidden", "false");
    }
}

function closeLogoutModal() {
    var modal = document.getElementById("logoutModal");
    if (modal) {
        modal.classList.remove("show");
        modal.setAttribute("aria-hidden", "true");
    }
}

document.addEventListener("keydown", function(event) {
    if (event.key === "Escape") {
        closeLogoutModal();
    }
});

document.getElementById("logoutModal")?.addEventListener("click", function(event) {
    if (event.target === this) {
        closeLogoutModal();
    }
});
</script>

</body>
</html>







