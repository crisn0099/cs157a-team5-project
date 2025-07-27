<!DOCTYPE html>
<html>
<head>
    <title>Sign Up</title>
    <style>
        body {
            background-color: #121212;
            color: white;
            font-family: sans-serif;
            padding: 40px;
        }
        form {
            background-color: #1e1e1e;
            padding: 20px;
            border-radius: 10px;
            width: 300px;
        }
        input {
            width: 100%;
            padding: 8px;
            margin: 10px 0;
            border-radius: 5px;
            border: none;
        }
        button {
            width: 100%;
            padding: 10px;
            border-radius: 5px;
            border: none;
            background-color: #4caf50;
            color: white;
            font-weight: bold;
        }
        .error {
            color: #ff4d4d;
        }
    </style>
</head>
<body>

<h2>Create an Account</h2>

<% String error = (String) request.getAttribute("error"); %>
<% if (error != null) { %>
    <p class="error"><%= error %></p>
<% } %>

<form action="SignupServlet" method="post">
    <label>Username:</label>
    <input type="text" name="username" required />

    <label>Password:</label>
    <input type="password" name="password" required />

    <label>Email:</label>
    <input type="email" name="email" required />

    <button type="submit">Sign Up</button>
</form>

<p>Already have an account? <a href="Login.jsp" style="color: #4caf50;">Log in here</a></p>

</body>
</html>
