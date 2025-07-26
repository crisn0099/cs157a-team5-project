<%@ page import="java.sql.*" %>
<html>
<head>
 <title>GamesForMe - Game List</title>
 <style>
   body {
     background-color: #121212;
     font-family: Arial, sans-serif;
     margin: 0;
     padding: 0;
     color: #eee;
   }
   header {
     display: flex;
     justify-content: space-between;
     align-items: center;
     padding: 20px 40px;
   }
   .logo {
     font-size: 1.5em;
     color: white;
     font-weight: bold;
   }
   .user-profile-btn {
     display: inline-block;
     width: 50px;
     height: 50px;
     background-color: #3a3a3a;
     color: white;
     border-radius: 50%;
     text-align: center;
     line-height: 50px;
     font-size: 0.75em;
     text-decoration: none;
     transition: background-color 0.3s ease;
   }
   .user-profile-btn:hover {
     background-color: #555;
   }
   h2 {
     text-align: center;
     font-size: 2.5em;
     margin-top: 0;
     color: #fff;
   }
   .game-container {
     width: 85%;
     margin: 30px auto;
     display: flex;
     flex-direction: column;
     gap: 20px;
   }
   .game-card {
     display: flex;
     justify-content: space-between;
     align-items: center;
     background-color: #1e1e1e;
     border-radius: 10px;
     overflow: hidden;
     box-shadow: 0 4px 12px rgba(0, 0, 0, 0.5);
     transition: transform 0.2s;
     padding: 10px;
   }
   .game-card:hover {
     transform: scale(1.01);
   }
   .game-cover {
     width: 200px;
     height: 120px;
     object-fit: cover;
   }
   .game-info {
     padding: 15px 20px;
     flex-grow: 1;
   }
   .game-title {
     font-size: 1.6em;
     font-weight: bold;
     margin-bottom: 8px;
     color: #fff;
   }
   .game-meta {
     font-size: 0.95em;
     color: #ccc;
     margin-bottom: 4px;
   }
   .wishlist-form button {
     background-color: #ff4b5c;
     border: none;
     padding: 8px 14px;
     color: white;
     font-weight: bold;
     border-radius: 5px;
     cursor: pointer;
     margin-right: 20px;
   }
   .wishlist-form button:hover {
     background-color: #ff1e38;
   }
 </style>
</head>
<body>
<header>
 <div class="logo">GamesForMe</div>
 <a href="UserProfile.jsp?userID=11" class="user-profile-btn" title="User Profile"></a>
</header>
<h2>Featured Games</h2>
<div class="game-container">
<%
 String jdbcURL = "jdbc:mysql://localhost:3306/games_for_me?autoReconnect=true&useSSL=false";
 String user = "root";
 String password = "Hardinser20@"; // Replace with your real password
 try {
   Class.forName("com.mysql.cj.jdbc.Driver");
   Connection conn = DriverManager.getConnection(jdbcURL, user, password);
   
   String sql = "SELECT " +
           "g.gameID, g.title, g.releaseDate, g.coverArt, " +
           "GROUP_CONCAT(DISTINCT gg.genreName ORDER BY gg.genreName SEPARATOR ', ') AS genres, " +
           "GROUP_CONCAT(DISTINCT gp.platformName ORDER BY gp.platformName SEPARATOR ', ') AS platforms " +
           "FROM game g " +
           "LEFT JOIN has_genre hg ON g.gameID = hg.gameID " +
           "LEFT JOIN game_genre gg ON hg.genreID = gg.genreID " +
           "LEFT JOIN on_platform hp ON g.gameID = hp.gameID " +
           "LEFT JOIN game_platform gp ON hp.platformID = gp.platformID " +
           "GROUP BY g.gameID, g.title, g.releaseDate, g.coverArt";
   
   Statement stmt = conn.createStatement();
   ResultSet rs = stmt.executeQuery(sql);
   while (rs.next()) {
     int gameID = rs.getInt("gameID");
     String title = rs.getString("title");
     String releaseDateFormatted = "";
     String rawDate = rs.getString("releaseDate");
     if (rawDate != null && !rawDate.isEmpty()) {
       try {
         java.text.SimpleDateFormat originalFormat = new java.text.SimpleDateFormat("yyyy-MM-dd");
         java.text.SimpleDateFormat desiredFormat = new java.text.SimpleDateFormat("MMM dd, yyyy");
         java.util.Date date = originalFormat.parse(rawDate);
         releaseDateFormatted = desiredFormat.format(date);
       } catch (Exception e) {
         releaseDateFormatted = rawDate;
       }
     }
     String coverArt = rs.getString("coverArt");
     if (coverArt == null || coverArt.trim().isEmpty()) {
       coverArt = "https://via.placeholder.com/200x120.png?text=No+Image";
     }
     String genres = rs.getString("genres");
     if (genres == null || genres.trim().isEmpty()) {
       genres = "Unknown";
     }
     String platforms = rs.getString("platforms");
     if (platforms == null || platforms.trim().isEmpty()) {
       platforms = "Not specified";
     }
%>
 <div class="game-card">
   <img class="game-cover" src="<%= coverArt %>" alt="Cover Art">
   <div class="game-info">
     <div class="game-title"><%= title %></div>
     <div class="game-meta"><%= releaseDateFormatted %></div>
     <div class="game-meta">Genres: <%= genres %></div>
     <div class="game-meta">Platforms: <%= platforms %></div>
   </div>
   <form class="wishlist-form" action="Wishlist.jsp" method="post">
     <input type="hidden" name="userID" value="11" />
     <input type="hidden" name="gameID" value="<%= gameID %>" />
     <button type="submit">Add to Wishlist</button>
   </form>
   <form class="wishlist-form" action="Favorite.jsp" method="post">
  	 <input type="hidden" name="userID" value="11" />
  	 <input type="hidden" name="gameID" value="<%= gameID %>" />
  	 <button type="submit">Favorite</button>
   </form>
   <form class="wishlist-form" action="Library.jsp" method="post">
     <input type="hidden" name="userID" value="11" />
     <input type="hidden" name="gameID" value="<%= gameID %>" />
     <button type="submit">Add to Library</button>
   </form>
 </div>
<%
   }
   rs.close();
   stmt.close();
   conn.close();
 } catch (Exception e) {
   out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
 }
%>
</div>
</body>
</html>
