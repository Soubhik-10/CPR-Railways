<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Confirm Booking - CPR Railways</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-image: url('./confirm1.jpg');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 20px;
            position: relative; /* Required for the overlay */
        }
        .container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            width: 90%;
            max-width: 800px; /* Wider card */
            text-align: center;
            position: relative; /* To position it above the overlay */
            z-index: 2; /* Above the overlay */
        }
        h2 {
            margin-bottom: 20px;
            color: #333; /* Dark color for heading */
        }
        .confirm-message {
            margin: 20px 0;
            color: #555; /* Slightly lighter color for text */
        }
        a {
            display: inline-block;
            margin-top: 20px;
            color: #4a90e2; /* Link color */
            text-decoration: none;
            border: 1px solid #4a90e2;
            padding: 10px 15px;
            border-radius: 5px;
            transition: background 0.3s, color 0.3s;
        }
        a:hover {
            background: #4a90e2;
            color: white;
        }
    </style>
</head>
<body>
    <div class="overlay"></div> <!-- Added overlay -->
    <div class="container">
        <h2>Booking Confirmation</h2>
        <div class="confirm-message">
            <%
                // Retrieve parameters and session attributes for booking details
                String trainNo = request.getParameter("train_no");
                String trainName = request.getParameter("train_name");
                String username = (String) session.getAttribute("username"); // Username is assumed to be stored in session
                int numTickets = Integer.parseInt(request.getParameter("num_tickets"));

                // Initialize database connection variables
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;

                try {
                    // Step 1: Connect to the database
                    Class.forName("oracle.jdbc.OracleDriver");
                    conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:oracle", "sys as sysdba", "rimi2003");

                    // Step 2: Retrieve the passenger details from Passenger_info using the username
                    String selectSql = "SELECT * FROM Passenger_info WHERE name = ?";
                    pstmt = conn.prepareStatement(selectSql);
                    pstmt.setString(1, username);
                    rs = pstmt.executeQuery();

                    // Initialize passenger details
                    String name = null;
                    int age = 0;
                    String sex = null;

                    // Fetch passenger details from the result set
                    if (rs.next()) {
                        name = rs.getString("name");
                        age = rs.getInt("age");
                        sex = rs.getString("sex");
                    }

                    // Step 3: Insert booking into Passenger_ticket if passenger details are found
                    if (name != null) { // Check if passenger details are available
                        String insertSql = "INSERT INTO Passenger_ticket (name, age, sex, train_no, seat_no, type_of_coach, journey_date) VALUES (?, ?, ?, ?, ?, ?, ?)";

                        pstmt = conn.prepareStatement(insertSql);
                        pstmt.setString(1, name);
                        pstmt.setInt(2, age);
                        pstmt.setString(3, sex);
                        pstmt.setString(4, trainNo);
                        pstmt.setInt(5, -1); // Set seat_no to -1 for now, or modify as needed
                        pstmt.setString(6, "AC Sleeper"); // Static value for type of coach
                        pstmt.setDate(7, new java.sql.Date(System.currentTimeMillis())); // Current date as journey date

                        int rowsAffected = pstmt.executeUpdate(); // Execute the insertion
                        
                        // Display confirmation message if booking is successful
                        if (rowsAffected > 0) {
                            out.println("<p>Your booking for <strong>" + trainName + "</strong> (Train No: " + trainNo + ") has been confirmed!</p>");
                        } else {
                            out.println("<p>Sorry, there was an error processing your booking.</p>");
                        }
                    } else {
                        out.println("<p>Passenger not found. Please ensure you're logged in.</p>"); // Error if no passenger details
                    }

                } catch (Exception e) {
                    e.printStackTrace();
                    out.println("<p>Error: " + e.getMessage() + "</p>"); // Display error message if an exception occurs
                } finally {
                    // Close ResultSet, PreparedStatement, and Connection objects to free resources
                    if (rs != null) try { rs.close(); } catch (SQLException e) {}
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
                    if (conn != null) try { conn.close(); } catch (SQLException e) {}
                }
            %>
        </div>
        <!-- Link to go back to the search page -->
        <a href="searchTrains.jsp">Go back to Search</a>
    </div>
</body>
</html>
