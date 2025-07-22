<%@ page import="java.sql.*, java.util.*, com.gamesforfun.model.UserProfile" %>
<%
   int userID = 11;
   String jdbcURL = "jdbc:mysql://localhost:3306/games_for_me";
   String dbUser = "root";
   String dbPassword = "DBpassword"; // <-- Replace with your actual password
   Connection conn = null;
   UserProfile profile = null;
   Map<String, String> userInfo = new HashMap<>();
   List<Map<String, String>> wishlist = new ArrayList<>();
   List<String> favGames = new ArrayList<>();
   List<String> playing = new ArrayList<>();
   List<Map<String, String>> reviews = new ArrayList<>();
   List<String> userPlaystyles = new ArrayList<>();
   double avgRating = 0.0;
   int helpfulCount = 0;
   
   try {
       Class.forName("com.mysql.cj.jdbc.Driver");
       conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
       profile = new UserProfile(conn);
       userInfo = profile.getUserInfo(userID);
       wishlist = profile.getWishlist(userID);
       userPlaystyles = profile.getUserPlaystyles(userID);
       // favGames = profile.getFavoriteGames(userID);
       // playing = profile.getPlayingGames(userID);
       // reviews = profile.getReviewHistory(userID);
       // avgRating = profile.getAverageRating(userID);
       // helpfulCount = profile.getHelpfulReviewCount(userID);       
      
   } catch (Exception e) {
       out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
       e.printStackTrace(new java.io.PrintWriter(out));
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
<h2>Playstyles</h2>
<% 
   Map<String, String> badgeMap = UserProfile.getPlaystyleBadgeMap(); 
   if (userPlaystyles.isEmpty()) { 
%>
    <p>No playstyles selected.</p>
<% 
   } else { 
%>
    <ul style="list-style: none; padding: 0;">
    <% for (String ps : userPlaystyles) { 
           String badgePath = badgeMap.get(ps);
    %>
        <li style="margin: 10px 0;">
            <% if (badgePath != null) { %>
                <img src="<%= request.getContextPath() + badgePath %>" alt="<%= ps %>" style="width:40px; vertical-align: middle;" />

            <% } %>
            <span style="margin-left: 10px;"><%= ps %></span>
        </li>
    <% } %>
    </ul>
<% } %>
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
<% if (wishlist.isEmpty()) { %>
   <p>No games in wishlist.</p>
<% } else { %>
   <ul>
   <% for (Map<String, String> game : wishlist) { %>
       <li class="game">
           <img src="<%= game.get("coverImage") != null ? game.get("coverImage") : "https://via.placeholder.com/50" %>" width="50" style="vertical-align: middle;" />
           <strong><%= game.get("name") %></strong>
           <br>
           Date Added: <%= game.get("dateAdded") != null ? game.get("dateAdded") : "Not specified" %>
       </li>
   <% } %>
   </ul>
<% } %>
<h2>Average Rating</h2>
<p><%= String.format("%.1f", avgRating) %>/5</p>
<h2>Social Sharing Stats</h2>
<p><%= helpfulCount %> people found this user's reviews helpful.</p>
</body>
</html>
