<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
  <title>Games by Genre</title>
  <style>
    body {
      background-color: #121212;
      color: #fff;
      font-family: Arial, sans-serif;
      padding: 40px;
    }
    h2 {
      text-align: center;
    }
    .game-container {
      display: flex;
      flex-direction: column;
      gap: 20px;
      width: 85%;
      margin: auto;
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
  </style>
</head>
<body>
<%
String jdbcURL = "jdbc:mysql://localhost:3306/games_for_me?useUnicode=true&characterEncoding=UTF-8";
String dbUser = "root";
String dbPassword = "DBpassword";
int genreID = Integer.parseInt(request.getParameter("genreID"));
String genreName = "";

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

    String genreQuery = "SELECT genreName FROM game_genre WHERE genreID = ?";
    PreparedStatement genreStmt = conn.prepareStatement(genreQuery);
    genreStmt.setInt(1, genreID);
    ResultSet genreRs = genreStmt.executeQuery();
    if (genreRs.next()) {
        genreName = genreRs.getString("genreName");
    }

    genreRs.close();
    genreStmt.close();
%>

<h2>Games in "<%= genreName %>"</h2>
<div class="game-container">
<%
    String sql = "SELECT g.gameID, g.title, g.releaseDate, g.coverArt " +
                 "FROM game g " +
                 "JOIN has_genre hg ON g.gameID = hg.gameID " +
                 "WHERE hg.genreID = ?";

    PreparedStatement ps = conn.prepareStatement(sql);
    ps.setInt(1, genreID);
    ResultSet rs = ps.executeQuery();

    while (rs.next()) {
        int gameID = rs.getInt("gameID");
        String title = rs.getString("title");
        String releaseDate = rs.getString("releaseDate");
        String coverArt = rs.getString("coverArt");

        if (coverArt == null || coverArt.trim().isEmpty()) {
            coverArt = "https://via.placeholder.com/200x120.png?text=No+Image";
        }

        String releaseDateFormatted = "";
        if (releaseDate != null && !releaseDate.isEmpty()) {
            try {
                java.text.SimpleDateFormat originalFormat = new java.text.SimpleDateFormat("yyyy-MM-dd");
                java.text.SimpleDateFormat desiredFormat = new java.text.SimpleDateFormat("MMM dd, yyyy");
                java.util.Date date = originalFormat.parse(releaseDate);
                releaseDateFormatted = desiredFormat.format(date);
            } catch (Exception e) {
                releaseDateFormatted = releaseDate;
            }
        }
%>
  <div class="game-card" onclick="window.location.href='GamePage.jsp?gameID=<%= gameID %>'" style="cursor: pointer;">
    <img class="game-cover" src="<%= coverArt %>" alt="Cover Art">
    <div class="game-info">
      <div class="game-title"><%= title %></div>
      <div class="game-meta">Release Date: <%= releaseDateFormatted %></div>
    </div>
  </div>
<%
    }

    rs.close();
    ps.close();
    conn.close();
} catch (Exception e) {
    out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
}
%>
</div>
</body>
</html>
