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
  <title>Browse by Genre</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    html {
      overflow-y: scroll;
    }
    body {
      background-color: #121212;
      color: #fff;
      font-family: Arial, sans-serif;
      margin: 0;
      padding: 0;
    }
    header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 20px 40px;
    }
    h2 {
      text-align: center;
      margin-top: 0;
      padding: 10px 0;
      font-size: 2.5em;
    }
    .genre-container {
      display: flex;
      flex-wrap: wrap;
      justify-content: center;
      gap: 20px;
      padding: 40px;
    }
    .genre-card {
      position: relative;
      width: 250px;
      height: 150px;
      border-radius: 15px;
      background-size: cover;
      background-position: center;
      overflow: hidden;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.5);
      transition: transform 0.3s ease, filter 0.3s ease;
    }
    .genre-card:hover {
      transform: scale(1.05);
      filter: brightness(1.1);
    }
    .genre-card::after {
      content: '';
      position: absolute;
      top: 0;
      left: -75%;
      width: 50%;
      height: 100%;
      background: linear-gradient(120deg, rgba(255,255,255,0.3) 0%, rgba(255,255,255,0) 100%);
      transform: skewX(-25deg);
      pointer-events: none;
      z-index: 3;
    }
    .genre-card:hover::after {
      animation: shine 0.8s forwards;
    }
    @keyframes shine {
      100% {
        left: 125%;
      }
    }
    .overlay {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: rgba(102, 0, 204, 0.4);
      z-index: 1;
    }
    .genre-overlay {
      position: absolute;
      bottom: 0;
      left: 50%;
      transform: translateX(-50%);
      width: 100%;
      padding: 15px;
      background: rgba(0, 0, 0, 0.0);
      font-size: 1.4em;
      font-weight: bold;
      color: white;
      text-shadow: 1px 1px 2px black;
      text-align: center;
      z-index: 4;
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

        Map<Integer, String> genreCovers = new HashMap<>();
        genreCovers.put(1, "https://media.rawg.io/media/games/511/5118aff5091cb3efec399c808f8c598f.jpg");  // action
        genreCovers.put(2, "https://media.rawg.io/media/games/d0f/d0f91fe1d92332147e5db74e207cfc7a.jpg");  // rpg
        genreCovers.put(3, "https://media.rawg.io/media/games/587/587588c64afbff80e6f444eb2e46f9da.jpg");  // shooter
        genreCovers.put(4, "https://media.rawg.io/media/games/2ba/2bac0e87cf45e5b508f227d281c9252a.jpg");  // puzzle
        genreCovers.put(5, "https://media.rawg.io/media/games/909/909974d1c7863c2027241e265fe7011f.jpg");  // adventure
        genreCovers.put(6, "https://media.rawg.io/media/games/1f4/1f47a270b8f241e4676b14d39ec620f7.jpg");  // indie
        genreCovers.put(7, "https://media.rawg.io/media/games/f90/f90ee1a4239247a822771c40488e68c5.jpg");  // platformer
        genreCovers.put(8, "https://media.rawg.io/media/games/78b/78bc81e247fc7e77af700cbd632a9297.jpg");  // mmo
        genreCovers.put(9, "https://media.rawg.io/media/games/5f5/5f5803f27d278c46f524a72956f540e7.jpg");  // sports
        genreCovers.put(10, "https://media.rawg.io/media/games/8f3/8f306808c45a4dbe0cd698e0b142af08.jpg"); // racing
        genreCovers.put(11, "https://media.rawg.io/media/games/821/821a40bd0cc0ac7dfb3fe97a7878dc1f.jpg"); // strategy
        genreCovers.put(12, "https://media.rawg.io/media/games/62b/62b035add7205737540d66e082b85930.jpg"); // fighting
        genreCovers.put(14, "https://media.rawg.io/media/games/25c/25c4776ab5723d5d735d8bf617ca12d9.jpg"); // simulation

        while (rs.next()) {
            int genreID = rs.getInt("genreID");
            String genreName = rs.getString("genreName");
            String coverArt = genreCovers.getOrDefault(genreID, "https://via.placeholder.com/300x200?text=" + genreName);
%>
<a class="genre-link" href="GenreGames.jsp?genreID=<%= genreID %>">
  <div class="genre-card" style="background-image: url('<%= coverArt %>');">
    <div class="overlay"></div>
    <div class="genre-overlay"><%= genreName %></div>
  </div>
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
