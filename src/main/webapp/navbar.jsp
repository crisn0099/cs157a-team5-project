<%@ page import="java.sql.*, java.util.*, com.gamesforfun.model.UserProfile" %>
<%
Integer userID = (Integer) session.getAttribute("userID");
String avatarURL = "https://via.placeholder.com/40";

if (userID != null) {
    try {
        String jdbcURL = "jdbc:mysql://localhost:3306/games_for_me";
        String dbUser = "root";
        String dbPassword = "Hardinser20@";
        Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
        UserProfile profile = new UserProfile(conn);
        Map<String, String> userInfo = profile.getUserInfo(userID);
        if (userInfo.get("avatar") != null && !userInfo.get("avatar").isEmpty()) {
            avatarURL = userInfo.get("avatar");
        }
        conn.close();
    } catch (Exception e) {
        e.printStackTrace(new java.io.PrintWriter(out));
    }
}
String currentPage = (String) request.getAttribute("currentPage");
%>

<!DOCTYPE html>
<html>
<head>
  <title>GamesForMe</title> 
  <style>
    html {
      overflow-y: scroll;
    }
    body {
      background-color: #121212;
      color: #fff;
      font-family: Arial, sans-serif;
      margin: 0;
      padding: 0;
     
    }
    .top-nav {
      position: sticky;
      top: 0;
      z-index: 1000;
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 30px;
      background: linear-gradient(to bottom, #3c3c3c 0%, #1f1f1f 50%, #121212 100%);
      padding: 3px 40px;
      border-top: 1px solid #444;
      border-bottom: 1px solid #000;
      font-size: 1.1em;
      margin-bottom: 20px;
      width: 100%;
      box-sizing: border-box;    
    }
    .top-nav a {
      color: white;
      text-decoration: none;
      font-weight: bold;
      transition: color 0.3s ease;
    }
    .top-nav a:hover {
      color: #7F00FF;
      text-decoration: none;
    }
    .top-nav a.active {
      color: #7F00FF;
    }
    .user-profile-btn {
      display: inline-block;
      width: 40px;
      height: 40px;
      background-color: #3a3a3a;
      border-radius: 50%;
      overflow: hidden;
    }
    .user-profile-btn img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }

    .logo {
      font-size: 1.4em;
      font-weight: bold;
      color: white;
      text-decoration: none;
    }    
    .search-form {
	  display: flex;
	  align-items: center;
	  gap: 6px;
	  background-color: #1f1f1f;
	  padding: 5px 10px;
	  border-radius: 8px;
	  border: 1px solid #444;
	  margin-left: auto;
	  margin-right: 40px;
	}
	.search-form input[type="text"] {
	  background-color: transparent;
	  border: none;
	  color: white;
	  outline: none;
	  font-size: 1em;
	  width: 160px;
	}
	.search-form button {
	  background: none;
	  border: none;
	  color: white;
	  cursor: pointer;
	  font-size: 1em;
	}
	
	.search-form button:hover {
	  color: #7F00FF;
	}	    
  </style>
</head>
<body>
<nav class="top-nav">
  <a href="MainPage.jsp" class="logo <%= "MainPage".equals(currentPage) ? "active" : "" %>" style="margin-left: 20px; margin-right: 40px;">GamesForMe</a>
  <a href="Genres.jsp" class="<%= "Genres".equals(currentPage) ? "active" : "" %>">Genres</a>
  <a href="AllGames.jsp" class="<%= "AllGames".equals(currentPage) ? "active" : "" %>">All Games</a>
  <a href="FeaturedGames.jsp" class="<%= "FeaturedGames".equals(currentPage) ? "active" : "" %>">Featured Games</a>

<form action="SearchResults.jsp" method="get" class="search-form">
  <input type="text" name="query" placeholder="Search games..." autocomplete="off" />
  <button type="submit"><i class="fa fa-search"></i></button>
</form>


  <div style="margin-left: 20px; margin-right: 20px;">
    <% if (userID != null) { %>
      <a href="UserProfile.jsp" class="user-profile-btn" title="User Profile">
        <img src="<%= avatarURL %>" style="width: 100%; height: 100%; border-radius: 50%;" />
      </a>
    <% } else { %>
      <a href="Login.jsp" style="margin-right: 15px; color: white; text-decoration: none; font-weight: bold;">Login</a>
      <a href="Signup.jsp" style="color: white; text-decoration: none; font-weight: bold;">Signup</a>
    <% } %>
  </div>
</nav>