<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    request.setAttribute("currentPage", "MainPage");
%>
<jsp:include page="navbar.jsp" />


<%
Integer userID = (Integer) session.getAttribute("userID");
%>

<html>
<head>
 <title>GamesForMe - Game List</title>
 <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
 
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
    .carousel-container {
      position: relative;
      width: 90%;
      height: 450px;
      margin: 40px auto 60px;
      overflow: hidden;
      display: flex;
      justify-content: center;
      align-items: center;
    }
    .carousel-item {
      position: absolute;
      opacity: 0;
      transition: opacity 1s ease-in-out;
      width: 100%;
      display: flex;
      justify-content: center;
      align-items: center;
    }
    .carousel-item.active {
      opacity: 1;
      z-index: 1;
    }
    .carousel-item img {
      max-height: 400px;
      border-radius: 10px;
      box-shadow: -5px 5px 20px rgba(102, 0, 204, 0.5);
    }
    .carousel-info h3 {
      color: white;
      text-align: center;
      margin-top: 10px;
    }
    .genre-container {
      display: flex;
      flex-wrap: wrap;
      justify-content: center;
      gap: 20px;
      margin-bottom: 100px;
    }
    .genre-card {
      position: relative;
      width: 250px;
      height: 150px;
      border-radius: 15px;
      background-size: cover;
      background-position: center;
      overflow: hidden;
      box-shadow: 0 4px 12px rgba(0,0,0,0.5);
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
    .wishlist-btn {
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
    .wishlist-btn .hover-text {
      opacity: 0;
      transition: opacity 0.2s ease-in-out;
      white-space: nowrap;
    }
    .wishlist-btn:hover .hover-text {
      opacity: 1;
    }        
  </style>
<h2><a href="FeaturedGames.jsp" style="color: white; text-decoration: none;">Featured Games</a></h2>
<div class="carousel-container">
  <div class="carousel-item active">
    <div style="text-align: center;">
      <a href="GamePage.jsp?gameID=28">
        <img src="https://media.rawg.io/media/games/b7d/b7d3f1715fa8381a4e780173a197a615.jpg" alt="Horizon Zero Dawn">
      </a>
      <div class="carousel-info"><h3>Horizon Zero Dawn</h3></div>
    </div>
  </div>
  <div class="carousel-item">
    <div style="text-align: center;">
      <a href="GamePage.jsp?gameID=6">
        <img src="https://media.rawg.io/media/games/5f1/5f1399f755ed3a40b04a9195f4c06be5.jpg" alt="Spider-Man">
      </a>
      <div class="carousel-info"><h3>Marvel's Spider-Man Remastered</h3></div>
    </div>
  </div>
  <div class="carousel-item">
    <div style="text-align: center;">
      <a href="GamePage.jsp?gameID=65">
        <img src="https://media.rawg.io/media/games/f90/f90ee1a4239247a822771c40488e68c5.jpg" alt="Dead Cells">
      </a>
      <div class="carousel-info"><h3>Dead Cells</h3></div>
    </div>
  </div>
  <div class="carousel-item">
    <div style="text-align: center;">
      <a href="GamePage.jsp?gameID=32">
        <img src="https://media.rawg.io/media/games/490/49016e06ae2103881ff6373248843069.jpg" alt="Metal Gear Solid V">
      </a>
      <div class="carousel-info"><h3>Metal Gear Solid V: The Phantom Pain</h3></div>
    </div>
  </div>
  <div class="carousel-item">
    <div style="text-align: center;">
      <a href="GamePage.jsp?gameID=48">
        <img src="https://media.rawg.io/media/games/e42/e428e70c97064037326d7863a43a0454.jpg" alt="Injustice 2">
      </a>
      <div class="carousel-info"><h3>Injustice 2</h3></div>
    </div>
  </div>
</div>

<%
String jdbcURL = "jdbc:mysql://localhost:3306/games_for_me?autoReconnect=true&useSSL=false";
String user = "root";
String password = "Dbpassword";
Connection conn = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection(jdbcURL, user, password);
%>
<h2><a href="Genres.jsp" style="color: white; text-decoration: none;">Browse by Genre</a></h2>
<div class="genre-container">
<%
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

String genreSQL = "SELECT genreID, genreName FROM game_genre ORDER BY genreName";
Statement genreStmt = conn.createStatement();
ResultSet grs = genreStmt.executeQuery(genreSQL);
while (grs.next()) {
  int gid = grs.getInt("genreID");
  String gname = grs.getString("genreName");
  String cover = genreCovers.getOrDefault(gid, "https://via.placeholder.com/200x120.png?text=" + gname);
%>
  <a class="genre-link" href="GenreGames.jsp?genreID=<%= gid %>">
    <div class="genre-card" style="background-image: url('<%= cover %>');">
      <div class="overlay"></div>
      <div class="genre-overlay"><%= gname %></div>
    </div>
  </a>
<%
}
grs.close();
genreStmt.close();
%>
</div>

<h2><a href="AllGames.jsp" style="color: white; text-decoration: none;">All Games</a></h2>
<div class="game-container">
<%
   String sql = "SELECT g.gameID, g.title, g.releaseDate, g.coverArt, " +
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
  <form class="wishlist-form" action="Favorite.jsp" method="post">
      <input type="hidden" name="userID" value="<%= userID %>">
      <input type="hidden" name="gameID" value="<%= gameID %>">
      <button type="submit" class="favorite-btn">
         <i class="fas fa-bookmark"></i>
         <span class="hover-text">Favorite</span>
      </button>
    </form>

  <form class="wishlist-form" action="Wishlist.jsp" method="post">
      <input type="hidden" name="userID" value="<%= userID %>">
      <input type="hidden" name="gameID" value="<%= gameID %>">
      <button type="submit" class="wishlist-btn">
         <i class="fas fa-gift"></i>
         <span class="hover-text">Wishlist</span>
      </button>
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

<script>
let index = 0;
const items = document.querySelectorAll('.carousel-item');
if (items.length > 0) {
    items[index].classList.add('active');
    setInterval(() => {
        items[index].classList.remove('active');
        index = (index + 1) % items.length;
        items[index].classList.add('active');
    }, 4000);
}
</script>

</body>
</html>