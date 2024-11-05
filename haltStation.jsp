<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Train Halt Details - CPR Railways</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-image: url('./hs2.jpg'); /* Background image for the body */
            background-size: cover;
            background-position: center;
            color: white; /* Text color for the body */
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 20px;
        }
        h2 {
            margin-bottom: 20px; /* Margin below the heading */
            text-align: center; /* Center align the heading */
        }
        .form-container {
            background: rgba(255, 255, 255, 0.8); /* Semi-transparent background for the form */
            padding: 20px;
            border-radius: 8px; /* Rounded corners for the form */
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1); /* Shadow effect for the form */
            margin-bottom: 20px; /* Margin below the form */
            width: 90%; /* Responsive width */
            max-width: 600px; /* Maximum width for the form */
            text-align: center; /* Center align text in the form */
            color: black; /* Text color inside the form */
        }
        label, input, button {
            display: block; /* Block display for form elements */
            margin: 10px 0; /* Margin above and below form elements */
            width: 100%; /* Full width for form elements */
        }
        button {
            background-color: #3498db; /* Background color for the button */
            color: white; /* Text color for the button */
            border: none; /* No border for the button */
            padding: 10px; /* Padding inside the button */
            font-size: 16px; /* Font size for the button */
            cursor: pointer; /* Pointer cursor on hover */
        }
        button:hover {
            background-color: #2980b9; /* Darker background on button hover */
        }
        .card {
            background: white; /* White background for the card */
            border-radius: 15px; /* Rounded corners for the card */
            padding: 30px; /* Padding inside the card */
            width: 100%; /* Full width for the card */
            max-width: 800px; /* Maximum width for the card */
            text-align: center; /* Center align text in the card */
            color: black; /* Text color inside the card */
        }
    </style>
</head>
<body>
    <h2>Train Halt Details</h2>
    <div class="form-container">
        <form action="" method="post"> <!-- Form to get train halt details -->
            <label for="trainNo">Train Number:</label>
            <input type="number" id="trainNo" name="trainNo" required> <!-- Input for train number -->

            <label for="stationName">Station Name:</label>
            <input type="text" id="stationName" name="stationName" required> <!-- Input for station name -->

            <button type="submit">Get Halt Details</button> <!-- Submit button -->
        </form>
    </div>

    <div class="container">
        <%
            // Get train number and station name from the request parameters
            String trainNo = request.getParameter("trainNo");
            String stationName = request.getParameter("stationName");

            // Check if both train number and station name are provided
            if (trainNo != null && !trainNo.isEmpty() && stationName != null && !stationName.isEmpty()) {
                Connection conn = null; // Database connection
                PreparedStatement pstmt = null; // Prepared statement for SQL queries
                ResultSet rs = null; // Result set for query results

                try {
                    // Load Oracle JDBC driver
                    Class.forName("oracle.jdbc.OracleDriver");
                    // Establish database connection
                    conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:oracle", "sys as sysdba", "rimi2003");

                    // SQL query to select halt details based on train number and station name
                    String sql = "SELECT arrival_time, departure_time, station_no FROM HaltStation " +
                                 "WHERE train_no = ? AND station_name = ?";

                    // Prepare the SQL statement
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setInt(1, Integer.parseInt(trainNo)); // Set train number parameter
                    pstmt.setString(2, stationName); // Set station name parameter

                    // Execute the query
                    rs = pstmt.executeQuery();

                    // Check if no records were found
                    if (!rs.isBeforeFirst()) {
                        out.println("<p style='color: white;'>No halt details found for the specified train and station.</p>");
                    }

                    // Iterate through the results
                    while (rs.next()) {
                        String arrivalTime = rs.getTimestamp("arrival_time").toString(); // Get arrival time
                        String departureTime = rs.getTimestamp("departure_time").toString(); // Get departure time
                        int stationNo = rs.getInt("station_no"); // Get station number
        %>
                        <div class="card"> <!-- Card to display halt details -->
                            <div><strong>Station No:</strong> <%= stationNo %></div> <!-- Display station number -->
                            <br/>
                            <div><strong>Arrival Time:</strong> <%= arrivalTime %></div> <!-- Display arrival time -->
                            <br/>
                            <div><strong>Departure Time:</strong> <%= departureTime %></div> <!-- Display departure time -->
                        </div>
        <%
                    }
                } catch (Exception e) {
                    e.printStackTrace(); // Print stack trace for debugging
                    out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>"); // Display error message
                } finally {
                    // Close resources in reverse order of creation
                    if (rs != null) try { rs.close(); } catch (SQLException e) {}
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
                    if (conn != null) try { conn.close(); } catch (SQLException e) {}
                }
            }
        %>
    </div>
</body>
</html>
