<%@ page import="java.sql.*"%>
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

    h1 {
      text-align: center;
      font-size: 1.5em;
      margin-top: 30px;
      color: #fff;
    }
    
    h2 {
   	  text-align: center;
   	  font-size: 2.5em;
      margin-top: 30px;
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
      background-color: #1e1e1e;
      border-radius: 10px;
      overflow: hidden;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.5);
      transition: transform 0.2s;
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
      display: flex;
      flex-direction: column;
      justify-content: center;
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
  </style>
</head>
<body>

<h1>GamesForMe</h1>
<h2>Featured Games</h2>

<div class="game-container">
<%
  String jdbcURL = "jdbc:mysql://localhost:3306/games_for_me?autoReconnect=true&useSSL=false";
  String user = "root";
  String password = "db_password";

  try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection(jdbcURL, user, password);

    String sql = "SELECT title, releaseDate, genre, platform, coverArt FROM Game";
    Statement stmt = conn.createStatement();
    ResultSet rs = stmt.executeQuery(sql);

    while (rs.next()) {
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

      String genre = rs.getString("genre");
      String platform = rs.getString("platform");
      String coverArt = rs.getString("coverArt");

      if (coverArt == null || coverArt.trim().isEmpty()) {
        coverArt = "https://via.placeholder.com/200x120.png?text=No+Image";
      }
%>
  <div class="game-card">
    <img class="game-cover" src="<%= coverArt %>" alt="Cover Art">
    <div class="game-info">
      <div class="game-title"><%= title %></div>
      <div class="game-meta"><%= genre %></div>
      <div class="game-meta"><%= releaseDateFormatted %></div>     
      <div class="game-meta"><%= platform %></div>
    </div>
  </div>
<%
    }

    rs.close();
    stmt.close();
    conn.close();
  } catch (Exception e) {
    out.println("Error: " + e.getMessage());
  }
%>
</div>

</body>
</html>
