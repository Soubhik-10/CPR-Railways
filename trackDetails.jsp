<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Track Information - CPR Railways</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif; /* Set the font for the body */
            background-image: url('./track2.jpg'); /* Background image for the body */
            background-size: cover; /* Cover the entire background */
            background-position: center; /* Center the background image */
            background-repeat: no-repeat; /* Prevent background image repetition */
            display: flex; /* Use flexbox for layout */
            flex-direction: column; /* Stack items vertically */
            align-items: center; /* Center align items */
            padding: 20px; /* Add padding around the body */
        }
        h2 {
            color: white; /* Set heading color */
            margin-bottom: 20px; /* Space below the heading */
            text-align: center; /* Center the heading text */
        }
        .container {
            display: flex; /* Use flexbox for container */
            flex-direction: column; /* Stack items vertically */
            align-items: center; /* Center align items */
            width: 100%; /* Full width of the container */
            max-width: 1200px; /* Set a maximum width */
            gap: 20px; /* Space between cards */
        }
        .card {
            background: white; /* Card background color */
            border-radius: 15px; /* Round the corners of the card */
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15); /* Add shadow for depth */
            padding: 30px; /* Inner padding of the card */
            width: 100%; /* Full width of the card */
            max-width: 800px; /* Set a maximum width for cards */
            text-align: center; /* Center text inside the card */
            transition: transform 0.3s, box-shadow 0.3s; /* Smooth transitions on hover */
            overflow: hidden; /* Prevent content overflow */
            position: relative; /* Relative positioning for hover effect */
            border: 1px solid #ddd; /* Light border for better definition */
        }
        .card:hover {
            transform: translateY(-5px); /* Slight lift on hover */
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.2); /* Deeper shadow on hover */
        }
        .track-details {
            font-size: 1.5em; /* Size of track details text */
            font-weight: bold; /* Bold font weight */
            color: #2c3e50; /* Color for track details */
            margin: 10px 0; /* Space above and below track details */
        }
        .location {
            color: #7f8c8d; /* Color for location text */
            font-style: italic; /* Italicize the location */
            margin-bottom: 15px; /* Space below location */
        }
        .details p {
            margin: 0; /* Remove default margin for paragraphs */
            color: #555; /* Color for detail text */
        }
        @media (max-width: 768px) {
            .card {
                width: 90%; /* Full width on smaller screens */
            }
        }
    </style>
</head>
<body>
    <h2>Track Information</h2>
    <div class="container">
        <%
            Connection conn = null; // Initialize database connection
            PreparedStatement pstmt = null; // Initialize prepared statement
            ResultSet rs = null; // Initialize result set

            try {
                // Load Oracle JDBC driver
                Class.forName("oracle.jdbc.OracleDriver");
                // Establish connection to the Oracle database
                conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:oracle", "sys as sysdba", "rimi2003");

                // SQL query to retrieve track information
                String sql = "SELECT track_id, src, dest, halt_station FROM Track";
                pstmt = conn.prepareStatement(sql); // Prepare the SQL statement
                rs = pstmt.executeQuery(); // Execute the query and get the result set

                // Iterate through the result set and display track information
                while (rs.next()) {
                    int trackId = rs.getInt("track_id"); // Get track ID
                    String src = rs.getString("src"); // Get source station
                    String dest = rs.getString("dest"); // Get destination station
                    String haltStation = rs.getString("halt_station"); // Get halt station
        %>
                    <div class="card">
                        <div class="track-details">Track ID: <%= trackId %></div>
                        <div class="location">Source: <%= src %> &mdash; Destination: <%= dest %></div>
                        <div class="details">
                            <p>Halt Station: <%= haltStation != null ? haltStation : "N/A" %></p>
                        </div>
                    </div>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace(); // Print the stack trace for any exception
                out.println("<p>Error: " + e.getMessage() + "</p>"); // Display error message
            } finally {
                // Close resources in the reverse order of their opening
                if (rs != null) try { rs.close(); } catch (SQLException e) {}
                if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
                if (conn != null) try { conn.close(); } catch (SQLException e) {}
            }
        %>
    </div>
</body>
</html>
