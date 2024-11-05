<%@ page import="java.sql.*" %> 
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <!-- Meta tags for charset and viewport settings -->
    <meta charset="UTF-8">
    <title>Book Ticket - CPR Railways</title>
    
    <!-- Linking Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <!-- Inline CSS for styling -->
    <style>
        /* Basic styling for the body */
        body {
            font-family: Arial, sans-serif; /* Sets the font style */
            display: flex; /* Enables flex layout */
            background-image: url('./book1.jpg'); /* Background image */
            background-size: cover; /* Ensures background covers entire area */
            background-position: center; /* Centers the background image */
            background-repeat: no-repeat; /* Prevents background image repetition */
            flex-direction: column; /* Arranges children in a column */
            align-items: center; /* Centers children horizontally */
            padding: 20px; /* Adds padding around the body */
            position: relative; /* Enables the overlay to be positioned on top */
        }

        /* Styling for the container div */
        .container {
            background: white; /* White background for readability */
            border-radius: 10px; /* Rounded corners */
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1); /* Adds shadow for depth */
            padding: 20px; /* Padding inside the container */
            width: 90%; /* Responsive width */
            max-width: 600px; /* Maximum width for larger screens */
            text-align: center; /* Center-aligns text */
            position: relative; /* Positions container above the overlay */
            z-index: 2; /* Ensures container is above the overlay */
        }

        /* Styling for the header */
        h2 {
            margin-bottom: 20px; /* Adds space below the heading */
            color: #333; /* Dark color for heading */
        }

        /* Styling for each form group */
        .form-group {
            display: flex; /* Enables flex layout */
            flex-direction: column; /* Arranges children vertically */
            align-items: center; /* Centers content */
            margin-bottom: 15px; /* Spacing below each form group */
            width: 100%; /* Full-width form group */
        }

        /* Styling for input group inside form group */
        .input-group {
            display: flex; /* Enables inline-flex layout */
            align-items: center; /* Aligns items vertically in center */
            width: 90%; /* Slightly reduced width for spacing */
            margin-bottom: 15px; /* Adds space below each input */
        }

        /* Styling for icons in the input group */
        .input-group i {
            margin-right: 10px; /* Adds space between icon and input */
            color: #4a90e2; /* Icon color */
        }

        /* Styling for labels */
        label {
            display: flex; /* Enables flex layout */
            align-items: center; /* Vertically centers label text */
            margin-right: 10px; /* Space between label and input */
            flex: 1; /* Allows label to adjust with input */
        }

        /* Input field styles */
        input[type="text"], input[type="email"], input[type="number"], select {
            flex: 2; /* Allows input field to grow */
            padding: 10px; /* Padding inside input fields */
            border: 1px solid #ddd; /* Light border around input */
            border-radius: 5px; /* Rounded corners */
        }

        /* Styling for submit button */
        input[type="submit"] {
            background: #4a90e2; /* Button color */
            color: white; /* Button text color */
            border: none; /* No border */
            padding: 10px; /* Adds padding for the button */
            border-radius: 5px; /* Rounded corners */
            cursor: pointer; /* Pointer cursor on hover */
            transition: background 0.3s; /* Smooth transition on hover */
            width: 100%; /* Full width for responsive layout */
        }

        /* Hover effect for submit button */
        input[type="submit"]:hover {
            background: #357ab8; /* Darker shade on hover */
        }
    </style>
</head>
<body>
    <div class="overlay"></div> <!-- Overlay for background dimming effect -->
    
    <!-- Container holding the booking form -->
    <div class="container">
        <h2>Book Your Ticket</h2> <!-- Form header -->

        <!-- Form to submit booking details to confirmBooking.jsp -->
        <form action="confirmBooking.jsp" method="post">
            <% 
                // Retrieves parameters from request object (from previous form or link)
                String trainNo = request.getParameter("train_no");
                String trainName = request.getParameter("train_name");
                String arrivalTime = request.getParameter("arrival_time");
                String departureTime = request.getParameter("departure_time");
                String haltStations = request.getParameter("halt_stations");
                String numCoaches = request.getParameter("num_coaches");
                String typeOfCoaches = request.getParameter("type_of_coaches");
            %>

            <!-- Hidden fields to pass train details to confirmBooking.jsp -->
            <input type="hidden" name="train_no" value="<%= trainNo %>">
            <input type="hidden" name="train_name" value="<%= trainName %>">

            <!-- Passenger information form group -->
            <div class="form-group">
                <!-- Name input field with icon -->
                <div class="input-group">
                    <i class="fas fa-user"></i>
                    <label for="name">Passenger Name</label>
                    <input type="text" name="name" id="name" required>
                </div>
                
                <!-- Gender selection dropdown with icon -->
                <div class="input-group">
                    <i class="fas fa-venus-mars"></i>
                    <label for="sex">Sex</label>
                    <select name="sex" id="sex" required>
                        <option value="">Select...</option> <!-- Placeholder option -->
                        <option value="male">Male</option>
                        <option value="female">Female</option>
                        <option value="other">Other</option>
                    </select>
                </div>

                <!-- Phone number input with pattern for validation -->
                <div class="input-group">
                    <i class="fas fa-phone"></i>
                    <label for="phone">Phone Number</label>
                    <input type="text" name="phone" id="phone" required pattern="\d{10}">
                </div>

                <!-- Email input field with icon -->
                <div class="input-group">
                    <i class="fas fa-envelope"></i>
                    <label for="email">Email</label>
                    <input type="email" name="email" id="email" required>
                </div>

                <!-- Age input field with validation for minimum value -->
                <div class="input-group">
                    <i class="fas fa-birthday-cake"></i>
                    <label for="age">Age</label>
                    <input type="number" name="age" id="age" required min="1">
                </div>

                <!-- Number of tickets input with minimum value restriction -->
                <div class="input-group">
                    <i class="fas fa-map"></i>
                    <label for="num_tickets">Number of Tickets</label>
                    <input type="number" name="num_tickets" id="num_tickets" required min="1">
                </div>
            </div>

            <!-- Submit button for form submission -->
            <input type="submit" value="Confirm Booking">
        </form>
    </div>
</body>
</html>