<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home - CPR Railways</title>
    <style>
        /* Body and Background */
        body {
            font-family: Arial, sans-serif;
            background-image: url('./home.png'); /* Replace with your image URL */
            background-size: cover; /* Cover the entire background */
            background-position: center; /* Center the background image */
            background-repeat: no-repeat; /* Do not repeat the background image */
            height: 100vh; /* Full viewport height */
            margin: 0; /* Remove default margin */
            display: flex; /* Use flexbox layout */
            flex-direction: column; /* Stack elements vertically */
            align-items: center; /* Center items horizontally */
            justify-content: center; /* Center items vertically */
            position: relative; /* Position relative for overlay */
            color: #ffffff; /* Text color */
            animation: fadeIn 1.5s ease-in; /* Fade-in animation */
        }

        /* Backdrop Overlay */
        body::before {
            content: ""; /* Empty content for pseudo-element */
            position: absolute; /* Position overlay absolutely */
            top: 0; /* Start from the top */
            left: 0; /* Start from the left */
            width: 100%; /* Full width */
            height: 100%; /* Full height */
            background: rgba(0, 0, 0, 0.7); /* Black overlay with opacity */
            z-index: 1; /* Place behind content */
        }

        /* Navbar */
        .navbar {
            position: fixed; /* Fixed position at the top */
            top: 0; /* Align to top */
            width: 100%; /* Full width */
            display: flex; /* Use flexbox layout */
            justify-content: space-between; /* Space between navbar items */
            align-items: center; /* Center align navbar items */
            padding: 15px 30px; /* Padding for navbar */
            background: rgba(0, 0, 0, 0.8); /* Background with opacity */
            z-index: 2; /* Place above overlay */
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3); /* Shadow effect */
        }
        .mt-4 {
            margin-top: 40px; /* Margin-top for spacing */
        }

        /* Circular logo with border */
        .navbar img {
            height: 50px; /* Logo height */
            width: 50px; /* Logo width */
            border-radius: 50%; /* Circular shape */
            border: 2px solid #ffffff; /* White border around logo */
            margin-right: 20px; /* Right margin for spacing */
        }

        .navbar a {
            color: #ffffff; /* Link color */
            text-decoration: none; /* Remove underline from links */
            margin: 0 15px; /* Margin for spacing */
            font-size: 18px; /* Font size for links */
            font-weight: bold; /* Bold font for links */
            transition: color 0.3s ease; /* Transition effect on hover */
        }

        .navbar a:hover {
            color: #4a90e2; /* Change color on hover */
        }

        /* Main Content with Glassmorphism */
        .content {
            z-index: 2; /* Place above overlay */
            text-align: center; /* Center align text */
            padding: 30px; /* Padding for content */
            max-width: 600px; /* Maximum width for content */
            background: rgba(255, 255, 255, 0.2); /* Glass effect */
            border-radius: 15px; /* Rounded corners */
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.37); /* Shadow effect */
            backdrop-filter: blur(10px); /* Blur background */
            -webkit-backdrop-filter: blur(10px); /* For Safari compatibility */
            border: 1px solid rgba(255, 255, 255, 0.18); /* Border for content */
        }

        h1 {
            font-size: 2.5em; /* Large font size for heading */
            color: #ffffff; /* White color for heading */
            margin-bottom: 20px; /* Margin below heading */
        }

        /* Button Styles */
        .btn {
            padding: 12px 25px; /* Padding for buttons */
            margin: 10px 10px; /* Margin for spacing */
            border: none; /* No border for buttons */
            background: linear-gradient(135deg,#4a90e2, #0870e7); /* Gradient background */
            color: #ffffff; /* White text color */
            font-weight: bold; /* Bold text */
            border-radius: 8px; /* Rounded corners for buttons */
            cursor: pointer; /* Pointer cursor on hover */
            transition: background-color 0.3s ease; /* Transition effect */
            text-decoration: none; /* Remove underline from buttons */
        }

        .btn:hover {
            background: linear-gradient(135deg,#4a90e2, #0870e7); /* Change background on hover */
        }

        /* Keyframes for Animation */
        @keyframes fadeIn {
            from { opacity: 0; } /* Start fully transparent */
            to { opacity: 1; } /* End fully opaque */
        }
    </style>
    <script>
        // JavaScript function to log out by submitting a hidden form
        function logout() {
            document.getElementById('logoutForm').submit(); // Submit logout form
        }
    </script>
</head>
<body>
    <% 
        // Check if user is logged in by checking session attribute
        String username = (String) session.getAttribute("username");
        if (username == null) { 
            // If user is not logged in, redirect to login page
            response.sendRedirect("login.jsp");
            return; // Exit the script
        }
    %>

    <!-- Navbar -->
    <nav class="navbar">
        <div style="display: flex; align-items: center;">
            <img src="logo.jpg" alt="CPR Logo"> <!-- Logo for the railway -->
            <a href="home.jsp">Home</a> <!-- Link to home page -->
            <a href="searchTrains.jsp">Search Train</a> <!-- Link to search trains page -->
            <a href="stationDetails.jsp">Station Details</a> <!-- Link to station details page -->
            <a href="trackDetails.jsp">Track Details</a> <!-- Link to track details page -->
            <a href="seatAvailability.jsp">Check Seat Availability</a> <!-- Link to check seat availability -->
            <a href="userdetails.jsp">Passenger Details</a> <!-- Link to passenger details page -->
            <a href="haltStation.jsp">Halt Station Details</a> <!-- Link to halt station details page -->
        </div>
        <div>
            <!-- Logout link triggers the logout function -->
            <a href="#" onclick="logout()" style="color:#4a90e2;">Logout</a> <!-- Logout link -->
        </div>
    </nav>

    <!-- Main Content -->
    <div class="content">
        <h1>Welcome to CPR Railways, <%= username %>!</h1> <!-- Greeting message with username -->
        
        <!-- Action Buttons -->
        <div class="mt-4">
            <a href="userdetails.jsp" class="btn">Get User Details</a> <!-- Button to get user details -->
            <a href="searchTrains.jsp" class="btn">Search Trains</a> <!-- Button to search trains -->
        </div>
    </div>

    <!-- Hidden form to terminate session on logout -->
    <form id="logoutForm" method="post" action="home.jsp" style="display: none;">
        <input type="hidden" name="logout" value="true"> <!-- Hidden input to indicate logout -->
    </form>

    <% 
        // Handle session termination if logout is requested
        if ("true".equals(request.getParameter("logout"))) {
            session.invalidate(); // Invalidate the session
            response.sendRedirect("login.jsp"); // Redirect to login page
        }
    %>
</body>
</html>
