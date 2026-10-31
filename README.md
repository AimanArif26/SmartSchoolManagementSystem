# Smart School Management System (SIRIUS)

A group project web application for managing a school, with separate portals for **admins**, **teachers** and **guardians**.

## Features
- Admin: register and validate teachers, manage students and classes, assign teachers to classes, manage attendance, student promotion, system settings
- Teacher: record and view attendance, enter and view examination results, manage class and profile
- Guardian: register, view their child's profile, attendance and examination results
- Forgot password with email OTP verification

## Tech stack
- Java Servlets and JSP (Jakarta EE), Eclipse Dynamic Web Project
- Oracle Database (`ojdbc11`), with an optional MySQL connection for XAMPP
- Jakarta Mail for sending OTP emails via Gmail SMTP

## Project structure
```
SmartSchool/                Eclipse project
  src/main/java/com/smartschool/
    controller/             Servlets
    dao/                    Database access (UserDAO)
    model/                  Entity classes
    util/                   DB connection and email helpers
  src/main/webapp/          JSP/HTML pages (admin, teacher, guardian), CSS, images
database/
  SIRIUS.sql                Oracle database export (tables and sample data)
```

## Setup
1. Import `SmartSchool` into Eclipse (File > Import > Existing Projects into Workspace) and run it on Apache Tomcat.
2. Import `database/SIRIUS.sql` into Oracle Database, then update the connection details in `util/OracleDBConnection.java` if needed.
3. To enable OTP emails, put your own Gmail address and [Gmail app password](https://myaccount.google.com/apppasswords) in `util/EmailUtil.java` (replace `YOUR_EMAIL@gmail.com` and `YOUR_GMAIL_APP_PASSWORD`).
