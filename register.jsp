<%@ page import="java.sql.*, java.util.Random" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Passenger Registration - CPR Railways</title>
    <style>
        /* Styles for the body and animation */
        body {
            font-family: Arial, sans-serif;
            background-image: url('./reg.png'); /* Background image for registration page */
            height: 100vh;
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            animation: fadeIn 1.5s ease; /* Fade in animation */
        }
    
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
    
        /* Style for text link */
        .t {
            color: blue;
            margin: 4px;
            padding: 2px;
        }
    
        /* Container styling for the registration form */
        .container {
            background: rgba(255, 255, 255, 0.9); /* Semi-transparent background */
            border-radius: 10px;
            box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1); /* Shadow effect */
            padding: 40px;
            width: 350px;
            text-align: center;
            animation: slideIn 1s ease; /* Slide in animation */
        }
    
        @keyframes slideIn {
            from { transform: translateY(-50px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
    
        /* Styling for heading */
        h2 {
            color: #333;
            margin-bottom: 20px;
        }
    
        /* Label styling */
        label {
            display: block;
            margin: 10px 0 5px;
            color: #555;
        }
    
        /* Input and select box styling */
        input[type="text"],
        input[type="number"],
        input[type="email"],
        select {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ddd; /* Light gray border */
            border-radius: 5px;
            transition: border-color 0.3s;
            box-sizing: border-box; /* Ensure consistent width */
        }
    
        /* Focus effect for input fields */
        input[type="text"]:focus,
        input[type="number"]:focus,
        input[type="email"]:focus,
        select:focus {
            border-color: #4a90e2; /* Change border color on focus */
            outline: none;
        }
    
        /* Button styling */
        .btn {
            background: #4a90e2; /* Button background color */
            color: white;
            border: none;
            padding: 10px;
            border-radius: 5px;
            cursor: pointer;
            transition: background 0.3s; /* Smooth transition on hover */
            width: 100%;
        }
    
        /* Button hover effect */
        .btn:hover {
            background: #357ab8; /* Darker blue on hover */
        }
    
        /* Select box styling */
        select {
            appearance: none;
            background-color: #fff; /* White background */
            color: #555;
            cursor: pointer;
            outline: none;
        }
    
        /* Style for select options */
        select option {
            color: #333;
        }
    
        /* Responsive styling for smaller screens */
        @media (max-width: 500px) {
            .container {
                width: 90%; /* Make container width responsive */
            }
        }
    
    </style>
</head>
<body>
    <div class="container">
        <h2>Passenger Registration</h2>
        <!-- Registration form -->
        <form action="register.jsp" method="post">
            <label for="name">Full Name</label>
            <input type="text" id="name" name="name" required>
            <label for="age">Age</label>
            <input type="number" id="age" name="age" required>
            <label for="sex">Gender</label>
            <select id="sex" name="sex" required>
                <option value="" disabled selected>Select Gender</option>
                <option value="Male">Male</option>
                <option value="Female">Female</option>
                <option value="Others">Others</option>
            </select>
            <label for="address">Address</label>
            <input type="text" id="address" name="address" required>
            <label for="phno">Phone Number</label>
            <input type="number" id="phno" name="phno" required>
            <label for="email">Email</label>
            <input type="email" id="email" name="email" required>
            <input type="submit" value="Register" class="btn">
            <a class="t" href="login.jsp">Already Registered? Go to Login </a>
        </form>
    </div>

    <%
        // Check if the form was submitted
        if (request.getMethod().equalsIgnoreCase("post")) {
            // Retrieve form data
            String name = request.getParameter("name");
            String ageStr = request.getParameter("age");
            String sex = request.getParameter("sex");
            String address = request.getParameter("address");
            String phnoStr = request.getParameter("phno");
            String email = request.getParameter("email");

            // Parse age and phone number
            int age = Integer.parseInt(ageStr);
            long phno = Long.parseLong(phnoStr);

            Connection conn = null;
            PreparedStatement pstmt1 = null;
            CallableStatement pstmt2 = null;

            try {
                // Generate a random password
                String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
                Random random = new Random();
                StringBuilder password = new StringBuilder();
                for (int i = 0; i < 8; i++) {
                    password.append(chars.charAt(random.nextInt(chars.length()))); // Create random password
                }
                String generatedPassword = password.toString();

                // Establish JDBC connection
                Class.forName("oracle.jdbc.OracleDriver");
                conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:oracle", "sys as sysdba", "rimi2003");

                // Insert passenger details into Passenger_info table
                String sql1 = "INSERT INTO Passenger_info (name, age, sex, address, phno, email) VALUES (?, ?, ?, ?, ?, ?)";
                pstmt1 = conn.prepareStatement(sql1);
                pstmt1.setString(1, name);
                pstmt1.setInt(2, age);
                pstmt1.setString(3, sex);
                pstmt1.setString(4, address);
                pstmt1.setLong(5, phno);
                pstmt1.setString(6, email);

                int rows1 = pstmt1.executeUpdate(); // Execute the insert statement

                // Insert login details into Login_passenger table using a stored procedure
                String sql2 = "{ CALL INSERT INTO Login_passenger (pno, name, password) VALUES (Login_passenger_seq.NEXTVAL, ?, ?) RETURNING pno INTO ? }";
                pstmt2 = conn.prepareCall(sql2);
                pstmt2.setString(1, name);
                pstmt2.setString(2, generatedPassword);
                pstmt2.registerOutParameter(3, java.sql.Types.INTEGER); // To retrieve the sequence number

                int rows2 = pstmt2.executeUpdate(); // Execute the insert statement
                int sequenceNumber = pstmt2.getInt(3);  // Retrieve the sequence number

                // Check if both inserts were successful
                if (rows1 > 0 && rows2 > 0) {
    %>
                    <script>
                        // Alert the user with their generated password and passenger number
                        alert("Passenger registered successfully! Your password is: <%= generatedPassword %> and Passenger Number: <%= sequenceNumber %>");
                    </script>
    <%
                } else {
    %>
                    <script>alert("Failed to register passenger. Please try again.");</script>
    <%
                }
            } catch (Exception e) {
                e.printStackTrace(); // Print stack trace for debugging
    %>
                <script>alert("Error: <%= e.getMessage() %>");</script>
    <%
            } finally {
                // Close resources in the finally block
                if (pstmt1 != null) pstmt1.close();
                if (pstmt2 != null) pstmt2.close();
                if (conn != null) conn.close();
            }
        }
    %>
</body>
</html>
