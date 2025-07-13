<%@ page import="java.sql.*, java.util.*, java.util.Map, java.util.List" %> 
<%@ page import="com.gamesforfun.model.UserProfile" %>
<%
   int userID = 11; // Simulated logged-in user
   String jdbcURL = "jdbc:mysql://localhost:3306/games_for_me"; // Use your actual DB name
   String dbUser = "root";
   String dbPassword = "your_password"; // Replace with real password
   Connection conn = null;
   UserProfile profile = null;
   Map<String, String> userInfo = new HashMap<>();
   List<Map<String, String>> wishlist = new ArrayList<>();
   List<String> favGames = new ArrayList<>();
   List<String> playing = new ArrayList<>();
   List<Map<String, String>> reviews = new ArrayList<>();
   double avgRating = 0.0;
   int helpfulCount = 0;
   try {
       Class.forName("com.mysql.cj.jdbc.Driver");
       conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
       profile = new UserProfile(conn);
       userInfo = profile.getUserInfo(userID);
       wishlist = profile.getWishlist(userID);
       favGames = profile.getFavoriteGames(userID);
       playing = profile.getPlayingGames(userID);
       reviews = profile.getReviewHistory(userID);
       avgRating = profile.getAverageRating(userID);
       helpfulCount = profile.getHelpfulReviewCount(userID);
   } catch (Exception e) {
       out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
   }
%>
<html>
<head>
   <title>User Profile</title>
   <style>
       body { background-color: #121212; color: white; font-family: sans-serif; padding: 20px; }
       .avatar { width: 100px; border-radius: 50%; }
       .game { margin: 10px 0; padding: 10px; background: #1e1e1e; border-radius: 8px; }
       h2 { margin-top: 30px; }
   </style>
</head>
<body>
<h1><%= userInfo.getOrDefault("username", "Unknown User") %>'s Profile</h1>
<img src="<%= userInfo.get("avatar") != null ? userInfo.get("avatar") : "https://via.placeholder.com/100" %>" class="avatar" />
<p><%= userInfo.getOrDefault("bio", "No bio available.") %></p>
<h2>Gaming Preferences</h2>
<p><%= userInfo.getOrDefault("gamingPreferences", "Not specified.") %></p>
<h2>Play Style</h2>
<p><%= userInfo.getOrDefault("playStyle", "Not specified.") %></p>
<h2>Favorite Games</h2>
<ul>
<% for (String game : favGames) { %>
   <li><%= game %></li>
<% } %>
</ul>
<h2>Currently Playing</h2>
<ul>
<% for (String game : playing) { %>
   <li><%= game %></li>
<% } %>
</ul>
<h2>Wishlist</h2>
<ul>
<% for (Map<String, String> game : wishlist) { %>
   <li class="game">
       <img src="<%= game.get("coverImage") != null ? game.get("coverImage") : "https://via.placeholder.com/50" %>" width="50" style="vertical-align: middle;" />
       <strong><%= game.get("name") %></strong> — <%= game.get("releaseDate") %>
   </li>
<% } %>
</ul>
<h2>Review History</h2>
<ul>
<% for (Map<String, String> review : reviews) { %>
   <li>
       <strong><%= review.get("name") %></strong>:
       "<%= review.get("review") %>" — Rated <%= review.get("rating") %>/5
   </li>
<% } %>
</ul>
<h2>Average Rating</h2>
<p><%= String.format("%.1f", avgRating) %>/5</p>
<h2>Social Sharing Stats</h2>
<p><%= helpfulCount %> people found this user's reviews helpful.</p>
</body>
</html>
