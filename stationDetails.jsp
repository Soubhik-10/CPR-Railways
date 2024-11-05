<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Stations - CPR Railways</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        /* Basic styling for the body */
        body {
            font-family: Arial, sans-serif;
            background-image: url('./stat.jpg');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 20px;
        }
        /* Styling for the main heading */
        h2 {
            color: white; /* Darker color for the heading */
            margin-bottom: 20px;
            text-align: center;
        }
        /* Container for the station cards */
        .container {
            display: flex;
            flex-direction: column; /* Change to column layout */
            align-items: center; /* Center align cards */
            width: 100%;
            max-width: 1200px; /* Maintain a maximum width */
            gap: 20px; /* Space between cards */
        }
        /* Styling for individual station cards */
        .card {
            background: white;
            border-radius: 15px; /* More rounded corners */
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15); /* Softer shadow */
            padding: 30px; /* Increased padding for a more spacious look */
            width: 100%; /* Full width of the container */
            max-width: 800px; /* Set a maximum width for cards */
            text-align: center;
            transition: transform 0.3s, box-shadow 0.3s; /* Smooth transitions */
            overflow: hidden; /* Prevents content overflow */
            position: relative; /* Relative position for hover effect */
            border: 1px solid #ddd; /* Light border for better definition */
        }
        /* Hover effect for the cards */
        .card:hover {
            transform: translateY(-5px); /* Slight lift on hover */
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.2); /* Deeper shadow on hover */
        }
        /* Styling for station names */
        .station-name {
            font-size: 1.8em; /* Slightly larger font for station names */
            font-weight: bold;
            color: #2c3e50; /* Darker color for station names */
            margin: 10px 0;
        }
        /* Styling for the location text */
        .location {
            color: #7f8c8d; /* Softer color for location */
            font-style: italic; /* Italicize the location */
            margin-bottom: 15px; /* Space below location */
        }
        /* Styling for the details section of the card */
        .details {
            display: flex; /* Use flex to align details in a row */
            justify-content: space-between; /* Space items evenly */
            margin-top: 15px; /* Space above details */
        }
        .details p {
            margin: 0; /* Reset margin for paragraphs */
            color: #555; /* Darker text for paragraphs */
            width: 45%; /* Width for each detail */
        }
        /* Optional: Add a gradient border around the card */
        .card:before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            border-radius: 15px;
            background: linear-gradient(135deg, rgba(52, 152, 219, 0.1), rgba(231, 76, 60, 0.1)); /* Gradient */
            z-index: 0; /* Behind card content */
        }
        /* Ensure content is above the gradient */
        .card > * {
            position: relative; /* Ensure content is above the gradient */
            z-index: 1; /* Raise content above gradient */
        }
        /* Responsive styles for smaller screens */
        @media (max-width: 768px) {
            .card {
                width: 90%; /* Full width on smaller screens */
            }
            .details {
                flex-direction: column; /* Stack details on smaller screens */
                align-items: center; /* Center items */
            }
            .details p {
                width: auto; /* Reset width for smaller screens */
                margin-bottom: 10px; /* Add space between stacked items */
            }
        }
    </style>
</head>
<body>
    <h2>Stations</h2> <!-- Heading for the stations page -->
    <div class="container">
        <%
            Connection conn = null; // Database connection object
            PreparedStatement pstmt = null; // Prepared statement for SQL query
            ResultSet rs = null; // Result set to hold query results

            try {
                // Load the Oracle JDBC driver
                Class.forName("oracle.jdbc.OracleDriver");
                // Establish connection to the Oracle database
                conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:oracle", "sys as sysdba", "rimi2003");

                // SQL query to select station details from the database
                String sql = "SELECT station_name, track_no, location, num_platforms, num_trains FROM Station";
                pstmt = conn.prepareStatement(sql); // Prepare the SQL statement
                rs = pstmt.executeQuery(); // Execute the query

                // Loop through the result set to display each station
                while (rs.next()) {
                    String stationName = rs.getString("station_name"); // Get station name
                    int trackNo = rs.getInt("track_no"); // Get track number
                    String location = rs.getString("location"); // Get location
                    int numPlatforms = rs.getInt("num_platforms"); // Get number of platforms
                    int numTrains = rs.getInt("num_trains"); // Get number of trains
        %>
                    <div class="card">
                        <div class="station-name"><%= stationName %></div> <!-- Display station name -->
                        <div class="location"><%= location %></div> <!-- Display station location -->
                        <div class="details">
                            <p>Track No: <%= trackNo %></p> <!-- Display track number -->
                            <p>Number of Platforms: <%= numPlatforms %></p> <!-- Display number of platforms -->
                        </div>
                        <p>Number of Trains: <%= numTrains %></p> <!-- Display number of trains -->
                    </div>
        <%
                }
            } catch (Exception e) { // Handle any exceptions that occur
                e.printStackTrace(); // Print stack trace for debugging
                out.println("<p>Error: " + e.getMessage() + "</p>"); // Display error message
            } finally { // Cleanup code to close resources
                if (rs != null) try { rs.close(); } catch (SQLException e) {} // Close ResultSet
                if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {} // Close PreparedStatement
                if (conn != null) try { conn.close(); } catch (SQLException e) {} // Close Connection
            }
        %>
    </div>
</body>
</html>
