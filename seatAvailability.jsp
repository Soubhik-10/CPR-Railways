<%@ page import="java.sql.*" %> 
<%@ page contentType="text/html; charset=UTF-8" %> 
<!DOCTYPE html>
<html lang="en">
<head>
    <!-- Meta charset for Unicode support -->
    <meta charset="UTF-8">
    <!-- Title for the page, displayed on the browser tab -->
    <title>Seat Availability - CPR Railways</title>
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        /* Basic styling for body */
        body {
            font-family: Arial, sans-serif;
            background-image: url('./sa.jpg'); /* Background image */
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 20px;
            color: white; /* Text color */
        }

        /* Styling for page header */
        h2 {
            margin-bottom: 20px;
            text-align: center;
        }

        /* Container styling for the form */
        .form-container {
            background: rgba(255, 255, 255, 0.8); /* Semi-transparent background */
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
            width: 90%;
            max-width: 600px;
            text-align: center;
            color: black;
        }

        /* Styling for labels, inputs, select, and buttons */
        label, input, select, button {
            display: block;
            margin: 10px 0;
            width: 100%;
        }

        /* Styling for submit button */
        button {
            background-color: #3498db;
            color: white;
            border: none;
            padding: 10px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        
        /* Hover effect for the button */
        button:hover {
            background-color: #2980b9;
        }

        /* Container styling for availability cards */
        .container {
            display: flex;
            flex-direction: column;
            align-items: center;
            width: 100%;
            max-width: 1200px;
            gap: 20px;
        }

        /* Card styling for each availability record */
        .card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
            padding: 30px;
            width: 100%;
            max-width: 800px;
            text-align: center;
            transition: transform 0.3s, box-shadow 0.3s;
            overflow: hidden;
            position: relative;
            border: 1px solid #ddd;
        }

        /* Hover effect for cards */
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.2);
        }

        /* Styling for station name */
        .station-name {
            font-size: 1.8em;
            font-weight: bold;
            color: #2c3e50;
            margin: 10px 0;
        }

        /* Styling for location information */
        .location {
            color: #7f8c8d;
            font-style: italic;
            margin-bottom: 15px;
        }

        /* Styling for detail text */
        .details {
            display: flex;
            justify-content: space-between;
            margin-top: 15px;
        }

        /* Paragraph styling within details section */
        .details p {
            margin: 0;
            color: #555;
            width: 45%;
        }

        /* Responsive styling for smaller screens */
        @media (max-width: 768px) {
            .card {
                width: 90%;
            }
            .details {
                flex-direction: column;
                align-items: center;
            }
            .details p {
                width: auto;
                margin-bottom: 10px;
            }
        }
    </style>
</head>
<body>
    <!-- Page heading -->
    <h2>Check Seat Availability</h2>

    <!-- Form to accept train number, coach type, and journey date -->
    <div class="form-container">
        <form action="" method="post">
            <!-- Input for Train Number -->
            <label for="trainNo">Train Number:</label>
            <input type="number" id="trainNo" name="trainNo" required>

            <!-- Dropdown for Coach Type selection -->
            <label for="coachType">Coach Type:</label>
            <select id="coachType" name="coachType">
                <option value="All">All</option>
                <option value="Sleeper">Sleeper</option>
                <option value="AC">AC</option>
                <option value="Non-AC">Non-AC</option>
            </select>

            <!-- Input for Journey Date -->
            <label for="journeyDate">Journey Date:</label>
            <input type="date" id="journeyDate" name="journeyDate" required>

            <!-- Submit button -->
            <button type="submit">Check Availability</button>
        </form>
    </div>

    <!-- Container to display available seats for the specified train -->
    <div class="container">
        <%
            // Retrieving form inputs for train number, coach type, and journey date
            String trainNo = request.getParameter("trainNo");
            String coachType = request.getParameter("coachType");
            String journeyDate = request.getParameter("journeyDate");

            // If train number and journey date are provided, initiate the database query
            if (trainNo != null && !trainNo.isEmpty() && journeyDate != null && !journeyDate.isEmpty()) {
                Connection conn = null; // Connection object
                PreparedStatement pstmt = null; // PreparedStatement object
                ResultSet rs = null; // ResultSet object

                try {
                    // Loading Oracle JDBC Driver
                    Class.forName("oracle.jdbc.OracleDriver");
                    // Establishing connection to the Oracle database
                    conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:oracle", "sys as sysdba", "rimi2003");

                    // SQL query to retrieve seat availability details
                    String sql = "SELECT journey_date, type_of_coach, seats_available FROM SeatAvailability " +
                                 "WHERE train_no = ? AND journey_date = TO_DATE(?, 'YYYY-MM-DD')";

                    // Modifying SQL query if a specific coach type is selected
                    if (!"All".equals(coachType)) {
                        sql += " AND type_of_coach = ?";
                    }

                    // Preparing SQL statement
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setInt(1, Integer.parseInt(trainNo)); // Setting train number parameter
                    pstmt.setString(2, journeyDate); // Setting journey date parameter

                    // Setting coach type parameter if not "All"
                    if (!"All".equals(coachType)) {
                        pstmt.setString(3, coachType);
                    }

                    // Executing SQL query
                    rs = pstmt.executeQuery();

                    // Checking if the result set is empty
                    if (!rs.isBeforeFirst()) {
                        out.println("<p style='color: white;'>No available seats found for the specified train, coach type, and date.</p>");
                    }

                    // Iterating through the result set and displaying seat availability details
                    while (rs.next()) {
                        String dbJourneyDate = rs.getDate("journey_date").toString(); // Journey date from database
                        String typeOfCoach = rs.getString("type_of_coach"); // Coach type from database
                        int seatsAvailable = rs.getInt("seats_available"); // Seats available count
        %>
                        <!-- Card to display journey date, coach type, and available seats -->
                        <div class="card">
                            <div class="station-name">Journey Date: <%= dbJourneyDate %></div>
                            <div class="location">Coach Type: <%= typeOfCoach %></div>
                            <div class="details">
                                <p>Seats Available: <%= seatsAvailable %></p>
                            </div>
                        </div>
        <%
                    }
                } catch (Exception e) {
                    // Handling any exceptions and displaying error message
                    e.printStackTrace();
                    out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
                } finally {
                    // Closing resources to avoid memory leaks
                    if (rs != null) try { rs.close(); } catch (SQLException e) {}
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
                    if (conn != null) try { conn.close(); } catch (SQLException e) {}
                }
            }
        %>
    </div>
</body>
</html>