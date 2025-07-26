<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*" %>
<%
String jdbcURL = "jdbc:mysql://localhost:3306/games_for_me?autoReconnect=true&useSSL=false";
String dbUser = "root";
String dbPassword = "dbPassword";

String gameIDStr = request.getParameter("gameID");
int gameID = Integer.parseInt(gameIDStr);
String title = "", releaseDate = "", coverArt = "", genres = "", platforms = "", description = "";

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

    String sql = "SELECT g.title, g.releaseDate, g.coverArt, g.description, " +
                 "GROUP_CONCAT(DISTINCT gg.genreName SEPARATOR ', ') AS genres, " +
                 "GROUP_CONCAT(DISTINCT gp.platformName SEPARATOR ', ') AS platforms " +
                 "FROM game g " +
                 "LEFT JOIN has_genre hg ON g.gameID = hg.gameID " +
                 "LEFT JOIN game_genre gg ON hg.genreID = gg.genreID " +
                 "LEFT JOIN on_platform hp ON g.gameID = hp.gameID " +
                 "LEFT JOIN game_platform gp ON hp.platformID = gp.platformID " +
                 "WHERE g.gameID = ? GROUP BY g.gameID";

    PreparedStatement ps = conn.prepareStatement(sql);
    ps.setInt(1, gameID);
    ResultSet rs = ps.executeQuery();
    if (rs.next()) {
        title = rs.getString("title");
        releaseDate = rs.getString("releaseDate");
        coverArt = rs.getString("coverArt");
        genres = rs.getString("genres");
        platforms = rs.getString("platforms");
        description = rs.getString("description");
    }
    rs.close();
    ps.close();
    conn.close();
} catch (Exception e) {
    out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
}
%>

<html>
<head>
  <title><%= title %></title>
  <style>
    body {
      background-color: #121212;
      color: #eee;
      font-family: Arial;
      padding: 40px;
      text-align: center;
    }

    .cover {
      width: 100%;
      max-width: 600px;
      height: auto;
      border-radius: 10px;
      margin-bottom: 20px;
    }

    .meta {
      margin: 20px auto;
      font-size: 1.1em;
      text-align: left;
      max-width: 800px;
    }
  </style>
</head>

<body>
  <h1><%= title %></h1>
  <img class="cover" src="<%= coverArt %>" alt="Cover Art">
  <div class="meta">Release Date: <%= releaseDate %></div>
  <div class="meta">Genres: <%= genres %></div>
  <div class="meta">Platforms: <%= platforms %></div>
  <div class="meta"><strong>Description:</strong> <br><%= description %></div>
</body>
</html>
