<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    request.setAttribute("currentPage", "Genres");
%>
<jsp:include page="navbar.jsp" />
<%
Integer userID = (Integer) session.getAttribute("userID");
%>

<html>
<head>
  <title>Games by Genre</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    body {
      background-color: #121212;
      color: #fff;
      font-family: Arial, sans-serif;
      padding: 0;
      margin: 0;
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
    .favorite-btn {
      background-color: #7F00FF;
      border: none;
      padding: 8px 14px;
      color: white;
      font-weight: bold;
      border-radius: 5px;
      cursor: pointer;
      margin-right: 20px;
      display: flex;
      align-items: center;
      gap: 6px;
      position: relative;
    }
    .favorite-btn .hover-text {
      opacity: 0;
      transition: opacity 0.2s ease-in-out;
      white-space: nowrap;
    }
    .favorite-btn:hover .hover-text {
      opacity: 1;
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

<h2><%= genreName %> Games</h2>
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

        String platformSql = "SELECT gp.platformName FROM game_platform gp " +
                             "JOIN on_platform op ON gp.platformID = op.platformID " +
                             "WHERE op.gameID = ?";
        PreparedStatement platformStmt = conn.prepareStatement(platformSql);
        platformStmt.setInt(1, gameID);
        ResultSet platformRs = platformStmt.executeQuery();

        List<String> platforms = new ArrayList<>();
        while (platformRs.next()) {
            platforms.add(platformRs.getString("platformName"));
        }
        String platformList = String.join(", ", platforms);

        platformRs.close();
        platformStmt.close();
%>
  <div class="game-card">
    <a href="GamePage.jsp?gameID=<%= gameID %>" style="text-decoration: none; color: inherit; display: flex; flex-grow: 1;">
      <div class="game-cover-container">
        <img class="game-cover" src="<%= coverArt %>" alt="Cover Art">
      </div>
      <div class="game-info">
        <div class="game-title"><%= title %></div>
        <div class="game-meta">Release Date: <%= releaseDateFormatted %></div>
        <div class="game-meta">Platforms: <%= platformList %></div>
      </div>
    </a>

    <% if (userID != null) { %>
    <form class="wishlist-form" action="Favorite.jsp" method="post">
      <input type="hidden" name="userID" value="<%= userID %>">
      <input type="hidden" name="gameID" value="<%= gameID %>">
      <button type="submit" class="favorite-btn">
         <i class="fas fa-bookmark"></i>
         <span class="hover-text">Favorite</span>
      </button>
    </form>

     <form class="wishlist-form" action="Wishlist.jsp" method="post">
      <input type="hidden" name="userID" value="<%= userID %>" />
      <input type="hidden" name="gameID" value="<%= gameID %>" />
      <button type="submit">Wishlist</button>
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
    ps.close();
    conn.close();
} catch (Exception e) {
    out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
}
%>
</div>
</body>
</html>