<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    request.setAttribute("currentPage", "AllGames");
    Integer userID = (Integer) session.getAttribute("userID");
%>

<jsp:include page="navbar.jsp" />

<html>
<head>
  <title>All Games</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    body {
      background-color: #121212;
      font-family: Arial, sans-serif;
      margin: 0;
      padding: 0;
      color: #eee;
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
      background-color: #7F00FF;
      border: none;
      padding: 8px 14px;
      color: white;
      font-weight: bold;
      border-radius: 5px;
      cursor: pointer;
      margin-right: 20px;
    }
    .wishlist-form button:hover {
      background-color: #6D2F9C;
    }
    .sort-container {
      width: 85%;
      margin: 20px auto 0 auto;
      display: flex;
      justify-content: flex-end;
      align-items: center;
    }
    .sort-label {
      color: white;
      margin-right: 10px;
      font-weight: bold;
    }
    .sort-select {
      background-color: #1e1e1e;
      color: #eee;
      border: 1px solid #444;
      border-radius: 6px;
      padding: 6px 12px;
      font-size: 1em;
      box-shadow: 0 0 5px rgba(0, 0, 0, 0.5);
      cursor: pointer;
    }
    .game-cover-container {
      position: relative;
      display: inline-block;
      overflow: hidden;
    }
    .game-card:hover .game-cover-container::after {
      content: '';
      position: absolute;
      top: 0;
      left: -75%;
      width: 50%;
      height: 100%;
      background: linear-gradient(120deg, rgba(255,255,255,0.3) 0%, rgba(255,255,255,0) 100%);
      transform: skewX(-25deg);
      pointer-events: none;
      z-index: 2;
      animation: shine-img 0.8s forwards;
    }
    @keyframes shine-img {
      100% {
        left: 125%;
      }
    }
  </style>
</head>
<body>

<h2>All Games</h2>

<form method="get" action="AllGames.jsp" class="sort-container">
  <label for="sort" class="sort-label">Sort by:</label>
  <select name="sort" id="sort" class="sort-select" onchange="this.form.submit()">
    <option value="id" <%= "id".equals(request.getParameter("sort")) ? "selected" : "" %>>ID (Default)</option>
    <option value="name" <%= "name".equals(request.getParameter("sort")) ? "selected" : "" %>>Name</option>
    <option value="release" <%= "release".equals(request.getParameter("sort")) ? "selected" : "" %>>Release Date</option>
  </select>
</form>

<div class="game-container">
<%
try {
  Class.forName("com.mysql.cj.jdbc.Driver");
  Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/games_for_me", "root", "DBpassword");

  String sortParam = request.getParameter("sort");
  String orderBy;

  if ("name".equals(sortParam)) {
      orderBy = "ORDER BY g.title ASC";
  } else if ("release".equals(sortParam)) {
      orderBy = "ORDER BY g.releaseDate DESC";
  } else {
      orderBy = "ORDER BY g.gameID ASC";
  }

  String sql = "SELECT g.gameID, g.title, g.releaseDate, g.coverArt, " +
      "GROUP_CONCAT(DISTINCT gg.genreName ORDER BY gg.genreName SEPARATOR ', ') AS genres, " +
      "GROUP_CONCAT(DISTINCT gp.platformName ORDER BY gp.platformName SEPARATOR ', ') AS platforms " +
      "FROM game g " +
      "LEFT JOIN has_genre hg ON g.gameID = hg.gameID " +
      "LEFT JOIN game_genre gg ON hg.genreID = gg.genreID " +
      "LEFT JOIN on_platform hp ON g.gameID = hp.gameID " +
      "LEFT JOIN game_platform gp ON hp.platformID = gp.platformID " +
      "GROUP BY g.gameID, g.title, g.releaseDate, g.coverArt " +
      orderBy;

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
    if (genres == null || genres.trim().isEmpty()) genres = "Unknown";

    String platforms = rs.getString("platforms");
    if (platforms == null || platforms.trim().isEmpty()) platforms = "Not specified";
%>
  <div class="game-card">
    <a href="GamePage.jsp?gameID=<%= gameID %>" style="text-decoration: none; color: inherit; display: flex; flex-grow: 1;">
      <div class="game-cover-container">
        <img class="game-cover" src="<%= coverArt %>" alt="Cover Art">
      </div>
      <div class="game-info">
        <div class="game-title"><%= title %></div>
        <div class="game-meta"><%= releaseDateFormatted %></div>
        <div class="game-meta">Genres: <%= genres %></div>
        <div class="game-meta">Platforms: <%= platforms %></div>
      </div>
    </a>

    <% if (userID != null) { %>
    <form class="wishlist-form" action="Wishlist.jsp" method="post">
      <input type="hidden" name="userID" value="<%= userID %>" />
      <input type="hidden" name="gameID" value="<%= gameID %>" />
      <button type="submit">Wishlist</button>
    </form>

    <form class="wishlist-form" action="Favorite.jsp" method="post">
      <input type="hidden" name="userID" value="<%= userID %>" />
      <input type="hidden" name="gameID" value="<%= gameID %>" />
      <button type="submit">Favorite</button>
    </form>

    <form class="wishlist-form" action="Library.jsp" method="post">
      <input type="hidden" name="userID" value="<%= userID %>" />
      <input type="hidden" name="gameID" value="<%= gameID %>" />
      <button type="submit">Add to Library</button>
    </form>
    <% } %>
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
