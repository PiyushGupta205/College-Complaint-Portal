COLLEGE COMPLAINT PORTAL
========================

Technology:
Java + Jakarta Servlet + JSP + MySQL + Apache Tomcat 10.1

ROLES
-----
Student
- Register/Login
- Submit complaint
- View complaints
- Track status
- Read faculty remarks

Faculty
- Login
- View assigned complaints
- View complaint/student details
- Update status
- Add remarks

Admin
- Login
- Dashboard statistics
- View all complaints
- Assign complaints to faculty
- Monitor complaint status

DATABASE
--------
Database: complaint_portal

Tables:
students
faculty
administrators
complaint_category
complaints

DEFAULT LOGIN
-------------
Admin:
Email: admin@college.edu
Password: admin123

Faculty:
Email: sharma@college.edu
Password: faculty123

Faculty:
Email: verma@college.edu
Password: faculty123

IMPORTANT
---------
The MYSQL_PASSWORD environment variable is the MySQL root
database password. It is different from the website login passwords.

RUNNING
-------
1. Start MySQL.
2. Set MYSQL_PASSWORD in the VS Code terminal.
3. Start Apache Tomcat 10.1.
4. Open the deployed College Complaint Portal.
5. Test Student -> Admin -> Faculty -> Student workflow.

MAIN WORKFLOW
-------------
Student submits complaint
        |
        v
Complaint stored as Pending
        |
        v
Admin assigns Faculty
        |
        v
Faculty updates status/remarks
        |
        v
Student sees updated status and remarks
