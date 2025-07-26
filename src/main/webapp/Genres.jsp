<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
  <title>Browse by Genre</title>
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
    .genre-container {
      display: flex;
      flex-wrap: wrap;
      justify-content: center;
      gap: 20px;
    }
    .genre-card {
      background-color: #1e1e1e;
      padding: 20px 30px;
      border-radius: 10px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.4);
      text-align: center;
      font-size: 1.2em;
      transition: transform 0.2s;
    }
    .genre-card:hover {
      transform: scale(1.05);
      cursor: pointer;
      background-color: #333;
    }
    .genre-link {
      text-decoration: none;
      color: white;
      display: block;
    }
  </style>
</head>
<body>
  <h2>Browse by Genre</h2>
  <div class="genre-container">
<%
    String jdbcURL = "jdbc:mysql://localhost:3306/games_for_me?useUnicode=true&characterEncoding=UTF-8";
    String dbUser = "root";
    String dbPassword = "Hardinser20@";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

        String sql = "SELECT genreID, genreName FROM game_genre ORDER BY genreName";
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(sql);

        while (rs.next()) {
            int genreID = rs.getInt("genreID");
            String genreName = rs.getString("genreName");
%>
    <a class="genre-link" href="GenreGames.jsp?genreID=<%= genreID %>">
      <div class="genre-card"><%= genreName %></div>
    </a>
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
