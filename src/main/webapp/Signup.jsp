<!DOCTYPE html>
<html>
<head>
    <title>Sign Up</title>
    <style>
        body {
            background-color: #121212;
            color: white;
            font-family: sans-serif;
            display: flex;
            justify-content: center;
            align-items: flex-start;
			padding-top: 120px;
            height: 100vh;
            margin: 0;
	        }
	        .container {
	            text-align: center;
	        }	
	        form {
	            background-color: #1e1e1e;
	            padding: 20px;
	            border-radius: 10px;
	            width: 300px;
	            margin: 0 auto;
	            display: flex;
	    		flex-direction: column;
	    		align-items: center;
	        	}
	
	        input {
	            width: 100%;
	            padding: 8px;
	            margin: 10px 0;
	            border-radius: 5px;
	            border: none;
	            background-color: #2c2c2c;
	            color: white;
	            box-sizing: border-box;
	        }
	        button {
	            width: 100%;
	            padding: 10px;
	            border-radius: 5px;
	            border: none;
	            background-color: #7F00FF;
	            color: white;
	            font-weight: bold;
	            box-sizing: border-box;
	        }	
	        .error {
	            color: #ff4d4d;
	        }
	
	        a {
	            color: #7F00FF;
	            text-decoration: none;
	        }
	
	        a:hover {
	            text-decoration: underline;
	        }	
    </style>
</head>
<body>

<div class="container">
    <h1 style="margin-bottom: 10px;">
        <a href="MainPage.jsp" style="color: #7F00FF; text-decoration: none; font-size: 2.2em;">GamesForMe</a>
    </h1>
    <h2>Create an Account</h2>


    <% String error = (String) request.getAttribute("error"); %>
    <% if (error != null) { %>
        <p class="error"><%= error %></p>
    <% } %>

    <form action="SignupServlet" method="post" autocomplete="off">
    <label>Username:</label>
    <input type="text" name="username" required autocomplete="off" />

    <label>Password:</label>
    <input type="password" name="password" required autocomplete="new-password" />

    <label>Email:</label>
    <input type="email" name="email" required autocomplete="off" />

    <button type="submit">Sign Up</button>
</form>


    <p>Already have an account? <a href="Login.jsp">Log in here</a></p>
</div>

</body>
</html>
