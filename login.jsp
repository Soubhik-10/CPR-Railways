<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login - CPR Railways</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-image: url('./log.jpg'); /* Background image for the login page */
            background-size: cover;
            background-position: center;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            padding: 20px;
            position: relative;
            animation: fadeIn 1.5s ease-in; /* Fade-in animation for the body */
        }
        /* Add backdrop overlay */
        body::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.6); /* Semi-transparent overlay */
            z-index: 1; /* Ensure it stays behind other content */
        }
        .container {
            position: relative;
            width: 100%;
            max-width: 450px; /* Maximum width for the login form */
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3); /* Shadow effect */
            background: rgba(255, 255, 255, 0.15); /* Glassmorphism effect */
            backdrop-filter: blur(12px); /* Blur effect for background */
            border: 1px solid rgba(255, 255, 255, 0.2); /* Border for the container */
            animation: slideIn 1s ease-out; /* Slide-in animation for the form */
            z-index: 2; /* Ensure it appears above the backdrop */
        }
        h2 {
            color: #ffffff; /* Heading color */
            text-align: center;
            margin-bottom: 20px; /* Space below the heading */
        }
        label {
            display: block;
            margin-top: 15px; /* Space above each label */
            color: #ffffff; /* Label color */
            font-weight: bold; /* Bold labels */
        }
        input[type="text"], input[type="password"] {
            width: calc(100% - 20px); /* Full width minus padding */
            padding: 12px 10px; /* Padding for inputs */
            margin-top: 5px; /* Space above inputs */
            border: none; /* Remove default border */
            border-radius: 8px; /* Rounded corners */
            background: rgba(255, 255, 255, 0.3); /* Background color */
            color: #ffffff; /* Text color */
            font-size: 16px; /* Font size for inputs */
            transition: background-color 0.3s ease, border-color 0.3s ease; /* Smooth transition for focus */
            outline: none; /* Remove outline */
        }
        input[type="text"]:focus, input[type="password"]:focus {
            background: rgba(255, 255, 255, 0.5); /* Lighter background on focus */
            outline: 2px solid #ffffff; /* Outline on focus */
        }
        .btn {
            display: block;
            width: calc(100% - 20px); /* Full width minus padding */
            padding: 12px; /* Padding for button */
            margin-top: 20px; /* Space above button */
            border: none; /* Remove default border */
            background: #4a90e2; /* Button background color */
            color: white; /* Text color for button */
            font-weight: bold; /* Bold button text */
            border-radius: 8px; /* Rounded corners */
            cursor: pointer; /* Pointer cursor on hover */
            transition: background-color 0.3s ease; /* Smooth background transition */
            outline: none; /* Remove outline */
        }
        .btn:hover {
            background: linear-gradient(135deg, #0870e7, #4a90e2); /* Gradient background on hover */
        }
        .login-link {
            text-align: center; /* Centered text for login link */
            margin-top: 15px; /* Space above login link */
            color: #ffffff; /* Color for login link */
            font-weight: bold; /* Bold text */
        }

        .login-link a {
            color: #4a90e2; /* Color for the link */
            text-decoration: none; /* Remove underline */
        }

        .login-link a:hover {
            text-decoration: underline; /* Underline on hover */
        }

        @keyframes fadeIn {
            from { opacity: 0; } /* Fade-in animation keyframe */
            to { opacity: 1; }
        }
        @keyframes slideIn {
            from { transform: translateY(-20px); } /* Slide-in animation keyframe */
            to { transform: translateY(0); }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Passenger Login</h2>

        <!-- Login form -->
        <form action="login.jsp" method="post">
            <label for="consumer_no">Passenger Number</label>
            <input type="text" id="consumer_no" name="consumer_no" required> <!-- Input for passenger number -->

            <label for="name">Name</label>
            <input type="text" id="name" name="name" required> <!-- Input for name -->

            <label for="password">Password</label>
            <input type="password" id="password" name="password" required> <!-- Input for password -->

            <input type="submit" value="Login" class="btn"> <!-- Submit button -->
        </form>
        <div class="login-link">
           Not A Passenger? <a href="register.jsp">Go to Register</a> <!-- Link to registration page -->
        </div>
    </div>

    <%
        // Check if the request method is POST
        if (request.getMethod().equalsIgnoreCase("post")) {
            String consumerNo = request.getParameter("consumer_no"); // Get passenger number
            String name = request.getParameter("name"); // Get name
            String password = request.getParameter("password"); // Get password

            Connection conn = null; // Database connection
            PreparedStatement pstmt = null; // Prepared statement
            ResultSet rs = null; // Result set

            try {
                // JDBC connection setup
                Class.forName("oracle.jdbc.OracleDriver"); // Load Oracle JDBC driver
                conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:oracle", "sys as sysdba", "rimi2003");

                // Query to check if the consumer number, name, and password match
                String sql = "SELECT * FROM Login_passenger WHERE pno = ? AND name = ? AND password = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, Integer.parseInt(consumerNo)); // Set passenger number
                pstmt.setString(2, name); // Set name
                pstmt.setString(3, password); // Set password

                rs = pstmt.executeQuery(); // Execute query

                if (rs.next()) {
                    // On successful login
                    session.setAttribute("username", name); // Set session attribute for username
    %>
                    <script>
                        alert("Login successful! Welcome, <%= name %>."); // Alert for successful login
                        window.location.href = "home.jsp"; // Redirect to home page
                    </script>
    <%
                } else {
    %>
                    <script>alert("Invalid login details. Please try again.");</script> <!-- Alert for invalid details -->
    <%
                }
            } catch (Exception e) {
                e.printStackTrace(); // Print stack trace for debugging
    %>
                <script>alert("Error: <%= e.getMessage() %>");</script> <!-- Alert for error -->
    <%
            } finally {
                // Close resources
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            }
        }
    %>
</body>
</html>
