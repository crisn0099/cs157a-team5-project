<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    request.setAttribute("currentPage", "SearchResults");
%>
<jsp:include page="navbar.jsp" />

<%
String query = request.getParameter("query");
Integer userID = (Integer) session.getAttribute("userID");
%>

<html>
<head>
  <title>Search Results</title>
   <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    body {
      background-color: #121212;
      color: white;
      font-family: Arial, sans-serif;
      margin: 0;
      padding: 0;
    }
    h2 {
      text-align: center;
      margin-top: 30px;
    }
    .results-container {
      width: 85%;
      margin: 20px auto;
      display: flex;
      flex-direction: column;
      gap: 20px;
    }
    .game-card {
      display: flex;
      align-items: center;
      background-color: #1e1e1e;
      padding: 10px;
      border-radius: 10px;
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
      padding: 15px;
      flex-grow: 1;
    }
    .game-title {
      font-size: 1.6em;
      font-weight: bold;
      color: #fff;
      margin-bottom: 8px;
    }
    .game-meta {
      font-size: 0.95em;
      color: #ccc;
      margin-bottom: 4px;
    }
    .game-actions form {
      display: inline-block;
      margin-left: 10px;
    }
    .game-actions button {
      background-color: #7F00FF;
      border: none;
      padding: 6px 12px;
      color: white;
      font-weight: bold;
      border-radius: 5px;
      cursor: pointer;
    }
    .game-actions button:hover {
      background-color: #6D2F9C;
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

<h2>Search Results for "<%= query != null ? query : "" %>"</h2>

<div class="results-container">
<%
if (query != null && !query.trim().isEmpty()) {
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/games_for_me", "root", "DBpassword");

        String sql = "SELECT g.gameID, g.title, g.releaseDate, g.coverArt, " +
                     "GROUP_CONCAT(DISTINCT gg.genreName ORDER BY gg.genreName SEPARATOR ', ') AS genres, " +
                     "GROUP_CONCAT(DISTINCT gp.platformName ORDER BY gp.platformName SEPARATOR ', ') AS platforms " +
                     "FROM game g " +
                     "LEFT JOIN has_genre hg ON g.gameID = hg.gameID " +
                     "LEFT JOIN game_genre gg ON hg.genreID = gg.genreID " +
                     "LEFT JOIN on_platform hp ON g.gameID = hp.gameID " +
                     "LEFT JOIN game_platform gp ON hp.platformID = gp.platformID " +
                     "WHERE LOWER(g.title) LIKE ? " +
                     "GROUP BY g.gameID, g.title, g.releaseDate, g.coverArt";

        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, "%" + query.toLowerCase() + "%");
        ResultSet rs = stmt.executeQuery();

        boolean hasResults = false;
        while (rs.next()) {
            hasResults = true;
            int gameID = rs.getInt("gameID");
            String title = rs.getString("title");
            String releaseDate = rs.getString("releaseDate");
            String coverArt = rs.getString("coverArt");
            String genres = rs.getString("genres");
            String platforms = rs.getString("platforms");

            if (coverArt == null || coverArt.trim().isEmpty()) {
                coverArt = "https://via.placeholder.com/200x120.png?text=No+Image";
            }
            if (genres == null || genres.trim().isEmpty()) genres = "Unknown";
            if (platforms == null || platforms.trim().isEmpty()) platforms = "Not specified";
%>
  <div class="game-card" onclick="location.href='GamePage.jsp?gameID=<%= gameID %>'" style="cursor: pointer;">
    <a href="GamePage.jsp?gameID=<%= gameID %>">
      <div class="game-cover-container">
  		<img class="game-cover" src="<%= coverArt %>" alt="Cover Art">
	</div>
    </a>
    <div class="game-info">
      <div class="game-title"><%= title %></div>
      <div class="game-meta">Release Date: <%= releaseDate %></div>
      <div class="game-meta">Genres: <%= genres %></div>
      <div class="game-meta">Platforms: <%= platforms %></div>
    </div>

    <% if (userID != null) { %>
    <div class="game-actions">
      <form action="Wishlist.jsp" method="post">
        <input type="hidden" name="userID" value="<%= userID %>" />
        <input type="hidden" name="gameID" value="<%= gameID %>" />
        <button type="submit">Wishlist</button>
      </form>
      <form action="Favorite.jsp" method="post">
        <input type="hidden" name="userID" value="<%= userID %>" />
        <input type="hidden" name="gameID" value="<%= gameID %>" />
        <button type="submit">Favorite</button>
      </form>
      <form action="Library.jsp" method="post">
        <input type="hidden" name="userID" value="<%= userID %>" />
        <input type="hidden" name="gameID" value="<%= gameID %>" />
        <button type="submit">Add to Library</button>
      </form>
    </div>
    <% } %>
  </div>
<%
        }
        
        if (!hasResults) {
%>
  <p style="text-align: center;">No games found matching your search.</p>
<%
        }

        rs.close();
        stmt.close();
        conn.close();
    } catch (Exception e) {
        out.println("<p style='color:red; text-align:center;'>Error: " + e.getMessage() + "</p>");
    }
} else {
%>
  <p style="text-align: center;">Please enter a search term.</p>
<%
}
%>
</div>

</body>
</html>
