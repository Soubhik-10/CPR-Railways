<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Passenger Home - CPR Railways</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-image: url('./ud.jpg'); /* Background image for the page */
            background-size: cover; /* Make the background cover the entire page */
            background-position: center; /* Center the background image */
            margin: 0; /* Remove default margin */
            padding: 20px; /* Add padding around the content */
        }
        h1 {
            text-align: center; /* Center the main heading */
            color: #ffffff; /* Set heading color to white */
            margin-bottom: 20px; /* Space below the heading */
        }
        h2 {
            color: #ffffff; /* Set subheading color to white */
        }
        table {
            width: 100%; /* Full width of the container */
            border-collapse: collapse; /* Remove space between table cells */
            margin: 20px 0; /* Space above and below the table */
            background-color: rgba(255, 255, 255, 0.8); /* Semi-transparent white background */
            border-radius: 10px; /* Rounded corners for the table */
            overflow: hidden; /* Hide overflow content */
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3); /* Shadow effect for depth */
        }
        th, td {
            padding: 12px; /* Padding for table cells */
            text-align: left; /* Align text to the left */
            border: 1px solid #ddd; /* Light grey border for cells */
        }
        th {
            background-color: #005a9c; /* Dark blue background for table headers */
            color: white; /* White text color for headers */
        }
        tr:nth-child(even) {
            background-color: #f2f2f2; /* Light grey background for even rows */
        }
        tr:hover {
            background-color: #ddd; /* Change background on row hover */
        }
    </style>
</head>
<body>
<%
    // Initialize database connection variables
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    // Retrieve the username from the session
    String username = (String) session.getAttribute("username"); // Check if the user is logged in
    if (username == null) { // If not logged in
%>
        <script>
            alert("User not logged in. Please login."); // Alert user
            window.location.href = 'login.jsp'; // Redirect to login page
        </script>
<%
    } else { // If logged in
%>
        <div class="container">
            <h1>Welcome, <%= username %>!</h1> <!-- Display welcome message with username -->
            
            <h2>Passenger Details</h2>
            <table>
                <tr>
                    <th>Pno</th>
                    <th>Name</th>
                    <th>Age</th>
                    <th>Sex</th>
                    <th>Address</th>
                    <th>Phone No</th>
                    <th>Email</th>
                </tr>
<%
        try {
            // Load Oracle JDBC driver
            Class.forName("oracle.jdbc.OracleDriver");
            // Establish database connection
            conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:oracle", "sys as sysdba", "rimi2003");

            // Prepare SQL statement to fetch passenger details based on username
            String passengerSql = "SELECT * FROM Passenger_info WHERE name = ?";
            pstmt = conn.prepareStatement(passengerSql);
            pstmt.setString(1, username); // Set the username parameter
            rs = pstmt.executeQuery(); // Execute the query
            
            if (rs.next()) { // Check if any result is returned
%>
                <tr>
                    <td><%= rs.getInt("pno") %></td>
                    <td><%= rs.getString("name") %></td>
                    <td><%= rs.getInt("age") %></td>
                    <td><%= rs.getString("sex") %></td>
                    <td><%= rs.getString("address") %></td>
                    <td><%= rs.getString("phno") %></td>
                    <td><%= rs.getString("email") %></td>
                </tr>
<%
            } else { // If no passenger details found
%>
                <tr>
                    <td colspan="7">Passenger details not found.</td> <!-- Show message if no details -->
                </tr>
<%
            }
%>
            </table>

            <h2>Ticket Details</h2>
            <table>
                <tr>
                    <th>Pno</th>
                    <th>Name</th>
                    <th>Age</th>
                    <th>Sex</th>
                    <th>Train No</th>
                    <th>Seat No</th>
                    <th>Type of Coach</th>
                    <th>Journey Date</th>
                </tr>
<%
            // Prepare SQL statement to fetch ticket details for the passenger
            String ticketSql = "SELECT * FROM Passenger_ticket WHERE name = ?";
            pstmt = conn.prepareStatement(ticketSql);
            pstmt.setString(1, username); // Set the username parameter
            rs = pstmt.executeQuery(); // Execute the query
            
            while (rs.next()) { // Loop through each ticket detail
%>
                <tr>
                    <td><%= rs.getInt("pno") %></td>
                    <td><%= rs.getString("name") %></td>
                    <td><%= rs.getInt("age") %></td>
                    <td><%= rs.getString("sex") %></td>
                    <td><%= rs.getInt("train_no") %></td>
                    <td><%= rs.getInt("seat_no") %></td>
                    <td><%= rs.getString("type_of_coach") %></td>
                    <td><%= rs.getDate("journey_date") %></td>
                </tr>
<%
            }
%>
            </table>
        </div>
<%
        } catch (Exception e) { // Handle any exceptions
            e.printStackTrace(); // Print stack trace for debugging
%>
            <script>alert("Error: <%= e.getMessage() %>");</script> <!-- Alert user with error message -->
<%
        } finally { // Ensure resources are closed to avoid memory leaks
            if (rs != null) rs.close(); // Close ResultSet
            if (pstmt != null) pstmt.close(); // Close PreparedStatement
            if (conn != null) conn.close(); // Close Connection
        }

        // Handle logout process if the form is submitted
        if (request.getMethod().equalsIgnoreCase("post") && request.getParameter("logout") != null) {
            session.invalidate(); // Kill the session
            response.sendRedirect("login.jsp"); // Redirect to login.jsp
        }
    }
%>
</body>
</html>
