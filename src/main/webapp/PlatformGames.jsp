<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    request.setAttribute("currentPage", "Platforms");
%>
<jsp:include page="navbar.jsp" />
<%
Integer userID = (Integer) session.getAttribute("userID");
%>

<html>
<head>
  <title>Games by Platform</title>
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
  </style>
</head>
<body>
<%
String jdbcURL = "jdbc:mysql://localhost:3306/games_for_me?useUnicode=true&characterEncoding=UTF-8";
String dbUser = "root";
String dbPassword = "DBpassword";
int platformID = Integer.parseInt(request.getParameter("platformID"));
String platformName = "";

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

    String platformQuery = "SELECT platformName FROM game_platform WHERE platformID = ?";
    PreparedStatement platformStmt = conn.prepareStatement(platformQuery);
    platformStmt.setInt(1, platformID);
    ResultSet platformRs = platformStmt.executeQuery();
    if (platformRs.next()) {
        platformName = platformRs.getString("platformName");
    }

    platformRs.close();
    platformStmt.close();
%>

<h2><%= platformName %> Games</h2>
<div class="game-container">
<%
    String sql = "SELECT g.gameID, g.title, g.releaseDate, g.coverArt " +
                 "FROM game g " +
                 "JOIN on_platform op ON g.gameID = op.gameID " +
                 "WHERE op.platformID = ?";

    PreparedStatement ps = conn.prepareStatement(sql);
    ps.setInt(1, platformID);
    ResultSet rs = ps.executeQuery();

    while (rs.next()) {
        int gameID = rs.getInt("gameID");
        String title = rs.getString("title");
        String releaseDate = rs.getString("releaseDate");
        String coverArt = rs.getString("coverArt");

        if (coverArt == null || coverArt.trim().isEmpty()) {
            coverArt = "https://via.placeholder.com/200x120.png?text=No+Image";
        }

        String formattedDate = "";
        if (releaseDate != null && !releaseDate.isEmpty()) {
            try {
                java.text.SimpleDateFormat original = new java.text.SimpleDateFormat("yyyy-MM-dd");
                java.text.SimpleDateFormat display = new java.text.SimpleDateFormat("MMM dd, yyyy");
                formattedDate = display.format(original.parse(releaseDate));
            } catch (Exception e) {
                formattedDate = releaseDate;
            }
        }

        String platformSql = "SELECT gp.platformName FROM game_platform gp " +
                             "JOIN on_platform op ON gp.platformID = op.platformID " +
                             "WHERE op.gameID = ?";
        PreparedStatement pStmt = conn.prepareStatement(platformSql);
        pStmt.setInt(1, gameID);
        ResultSet pRs = pStmt.executeQuery();
        List<String> platformList = new ArrayList<>();
        while (pRs.next()) {
            platformList.add(pRs.getString("platformName"));
        }
        pRs.close();
        pStmt.close();
%>
  <div class="game-card">
    <a href="GamePage.jsp?gameID=<%= gameID %>" style="text-decoration: none; color: inherit; display: flex; flex-grow: 1;">
      <img class="game-cover" src="<%= coverArt %>" alt="Cover Art">
      <div class="game-info">
        <div class="game-title"><%= title %></div>
        <div class="game-meta">Release Date: <%= formattedDate %></div>
        <div class="game-meta">Platforms: <%= String.join(", ", platformList) %></div>
      </div>
    </a>

    <% if (userID != null) { %>
    <form class="wishlist-form" action="Wishlist.jsp" method="post">
      <input type="hidden" name="userID" value="<%= userID %>">
      <input type="hidden" name="gameID" value="<%= gameID %>">
      <button type="submit">Wishlist</button>
    </form>

    <form class="wishlist-form" action="Favorite.jsp" method="post">
      <input type="hidden" name="userID" value="<%= userID %>">
      <input type="hidden" name="gameID" value="<%= gameID %>">
      <button type="submit">Favorite</button>
    </form>

    <form class="wishlist-form" action="Library.jsp" method="post">
      <input type="hidden" name="userID" value="<%= userID %>">
      <input type="hidden" name="gameID" value="<%= gameID %>">
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