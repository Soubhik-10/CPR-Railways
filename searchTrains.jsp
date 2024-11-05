<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Train Search - CPR Railways</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        /* Styles for body and container */
        body {
            font-family: Arial, sans-serif;
            background-image: url('./st1.png'); /* Background image */
            background-size: cover; /* Cover the entire viewport */
            background-position: center; /* Center the image */
            background-repeat: no-repeat; /* No repeating */
            display: flex;
            flex-direction: column; /* Column layout */
            align-items: center; /* Center align items */
            padding: 20px; /* Padding around the body */
            position: relative; /* Required for overlay positioning */
            overflow: hidden; /* Prevents overflow issues */
        }
        .container {
            background: white; /* White background for the container */
            border-radius: 10px; /* Rounded corners */
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1); /* Subtle shadow */
            padding: 20px; /* Padding inside the container */
            width: 90%; /* Full width */
            max-width: 600px; /* Maximum width */
            text-align: center; /* Centered text */
            position: relative; /* Relative position */
            z-index: 2; /* Position above overlay */
        }
        h2 {
            margin-bottom: 20px; /* Bottom margin for heading */
            color: #333; /* Dark color for heading */
        }
        /* Styles for form groups */
        .form-group {
            display: flex;
            flex-direction: column; /* Stack elements vertically */
            align-items: center; /* Center align */
            margin-bottom: 15px; /* Bottom margin */
            width: 100%; /* Full width */
        }
        /* Styles for input groups */
        .input-group {
            display: flex; /* Flex layout */
            align-items: center; /* Center align */
            width: 90%; /* Width of input groups */
            margin-bottom: 15px; /* Bottom margin */
        }
        .input-group i {
            margin-right: 10px; /* Space between icon and input */
            color: #4a90e2; /* Icon color */
        }
        label {
            display: flex; /* Flex layout for labels */
            align-items: center; /* Center align */
            margin-right: 10px; /* Space to the right */
            flex: 1; /* Flex property for label */
        }
        /* Styles for input fields */
        input[type="text"] {
            flex: 2; /* Take up twice the space of the label */
            padding: 10px; /* Padding inside input */
            border: 1px solid #ddd; /* Light gray border */
            border-radius: 5px; /* Rounded corners */
        }
        /* Styles for submit button */
        input[type="submit"] {
            background: #4a90e2; /* Blue background */
            color: white; /* White text */
            border: none; /* No border */
            padding: 10px; /* Padding */
            border-radius: 5px; /* Rounded corners */
            cursor: pointer; /* Pointer cursor */
            transition: background 0.3s; /* Transition for hover effect */
            width: 100%; /* Full width */
        }
        input[type="submit"]:hover {
            background: #357ab8; /* Darker blue on hover */
        }
        /* Styles for cards displaying train info */
        .cards {
            display: flex;
            flex-direction: column; /* Stack cards vertically */
            gap: 15px; /* Space between cards */
            margin-top: 20px; /* Top margin */
        }
        .card {
            background: #e9ecef; /* Light gray background for cards */
            padding: 15px; /* Padding inside cards */
            border-radius: 8px; /* Rounded corners */
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1); /* Subtle shadow */
            text-align: left; /* Left aligned text */
        }
        .icon {
            margin-right: 5px; /* Space between icon and text */
            color: #4a90e2; /* Icon color */
        }
        /* Styles for booking button */
        .book-button {
            background: #28a745; /* Green background */
            color: white; /* White text */
            border: none; /* No border */
            padding: 10px; /* Padding */
            border-radius: 5px; /* Rounded corners */
            cursor: pointer; /* Pointer cursor */
            width: 100%; /* Full width */
            text-align: center; /* Center text */
            text-decoration: none; /* No underline */
            display: inline-block; /* Inline block */
        }
        .book-button:hover {
            background: #218838; /* Darker green on hover */
        }
    </style>
</head>
<body>
    <div class="overlay"></div> <!-- Overlay for additional design effects -->
    <div class="container">
        <h2>Search for Trains</h2>
        <form action="searchTrains.jsp" method="post">
            <div class="form-group">
                <!-- Input group for source station -->
                <div class="input-group">
                    <i class="fas fa-map-marker-alt"></i> <!-- Icon for source -->
                    <label for="source">Source Station</label>
                    <input type="text" name="source" id="source" required>
                </div>
                <!-- Input group for destination station -->
                <div class="input-group">
                    <i class="fas fa-map-marker-alt"></i> <!-- Icon for destination -->
                    <label for="destination">Destination Station</label>
                    <input type="text" name="destination" id="destination" required>
                </div>
            </div>
            <input type="submit" value="Search Trains"> <!-- Submit button -->
        </form>

        <div class="cards">
            <%
                // Check if the request method is POST
                if (request.getMethod().equalsIgnoreCase("post")) {
                    // Retrieve source and destination parameters from the request
                    String source = request.getParameter("source");
                    String destination = request.getParameter("destination");

                    Connection conn = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;

                    try {
                        // Load Oracle JDBC driver
                        Class.forName("oracle.jdbc.OracleDriver");
                        // Establish database connection
                        conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:oracle", "sys as sysdba", "rimi2003");
                        // Prepare SQL query to find trains based on source or destination
                        String sql = "SELECT train_name, train_no, source, destination, intermediate_station, arrival_time, departure_time, halt_stations, num_coaches, type_of_coaches FROM Train WHERE source = ? OR destination = ?";
                        pstmt = conn.prepareStatement(sql);
                        pstmt.setString(1, source); // Set source parameter
                        pstmt.setString(2, destination); // Set destination parameter

                        // Execute query
                        rs = pstmt.executeQuery();
                        boolean trainsFound = false; // Flag to check if trains were found

                        // Process the result set
                        while (rs.next()) {
                            // Retrieve train details from the result set
                            String trainName = rs.getString("train_name");
                            int trainNo = rs.getInt("train_no");
                            String src = rs.getString("source");
                            String dest = rs.getString("destination");
                            String intermediateStations = rs.getString("intermediate_station");
                            String arrivalTime = rs.getString("arrival_time");
                            String departureTime = rs.getString("departure_time");
                            String haltStations = rs.getString("halt_stations");
                            int numCoaches = rs.getInt("num_coaches");
                            String typeOfCoaches = rs.getString("type_of_coaches");

                            // Output the train card with details
                            out.println("<div class='card'>");
                            out.println("<h3><i class='fas fa-train icon'></i> Train Name: " + trainName + " (Train No: " + trainNo + ")</h3>");
                            out.println("<p><i class='fas fa-location-arrow icon'></i> Source: " + src + "</p>");
                            out.println("<p><i class='fas fa-location-arrow icon'></i> Destination: " + dest + "</p>");
                            out.println("<p><i class='fas fa-clock icon'></i> Arrival Time: " + arrivalTime + "</p>");
                            out.println("<p><i class='fas fa-clock icon'></i> Departure Time: " + departureTime + "</p>");
                            out.println("<p><i class='fas fa-stop-circle icon'></i> Halt Stations: " + haltStations + "</p>");
                            out.println("<p><i class='fas fa-cog icon'></i> Number of Coaches: " + numCoaches + "</p>");
                            out.println("<p><i class='fas fa-cog icon'></i> Type of Coaches: " + typeOfCoaches + "</p>");
                            // Display intermediate stations if available
                            if (intermediateStations != null && !intermediateStations.isEmpty()) {
                                out.println("<p><i class='fas fa-road icon'></i> Intermediate Stations: " + intermediateStations + "</p>");
                            }
                            // Booking button linking to the booking page
                            out.println("<a href='booking.jsp?trainNo=" + trainNo + "' class='book-button'>Book Now</a>");
                            out.println("</div>");
                            trainsFound = true; // Set flag indicating trains found
                        }

                        // If no trains were found
                        if (!trainsFound) {
                            out.println("<p>No trains found for the selected route.</p>");
                        }
                    } catch (Exception e) {
                        // Handle SQL exceptions
                        e.printStackTrace();
                        out.println("<p>Error fetching train details: " + e.getMessage() + "</p>");
                    } finally {
                        // Clean up resources
                        try {
                            if (rs != null) rs.close();
                            if (pstmt != null) pstmt.close();
                            if (conn != null) conn.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                }
            %>
        </div>
    </div>
</body>
</html>
