<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*, java.util.*" %>
<jsp:include page="navbar.jsp" />

<%
String jdbcURL = "jdbc:mysql://localhost:3306/games_for_me?autoReconnect=true&useSSL=false";
String dbUser = "root";
String dbPassword = "Hardinser20@";

String gameIDStr = request.getParameter("gameID");
int gameID = Integer.parseInt(gameIDStr);

String title = "", releaseDate = "", coverArt = "", genres = "", platforms = "", description = "";
String esrbRating = "", developer = "", releaseDateFormatted = "";

List<Map<String, Object>> reviews = new ArrayList<>();
List<String> imageURLs = new ArrayList<>();

Integer currentUserID = (Integer) session.getAttribute("userID");

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

    String sql = "SELECT g.title, g.releaseDate, g.coverArt, g.description, g.ESRB_rating, g.developer, " +
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
        esrbRating = rs.getString("ESRB_rating");
        developer = rs.getString("developer");

        if (releaseDate != null && !releaseDate.isEmpty()) {
            try {
                java.text.SimpleDateFormat originalFormat = new java.text.SimpleDateFormat("yyyy-MM-dd");
                java.text.SimpleDateFormat desiredFormat = new java.text.SimpleDateFormat("MMMM dd, yyyy");
                java.util.Date date = originalFormat.parse(releaseDate);
                releaseDateFormatted = desiredFormat.format(date);
            } catch (Exception e) {
                releaseDateFormatted = releaseDate;
            }
        }
    }

    rs.close();
    ps.close();

    String ssSQL = "SELECT imageURL FROM game_screenshot WHERE gameID = ?";
    PreparedStatement ssPS = conn.prepareStatement(ssSQL);
    ssPS.setInt(1, gameID);
    ResultSet ssRS = ssPS.executeQuery();
    while (ssRS.next()) {
        imageURLs.add(ssRS.getString("imageURL"));
    }
    ssRS.close();
    ssPS.close();

    String reviewSQL = "SELECT r.reviewID, r.textReview, r.starRating, u.username, " +
                       "(SELECT COUNT(*) FROM review_helpfulness rh WHERE rh.reviewID = r.reviewID AND rh.isHelpful = 1) AS yesVotes, " +
                       "(SELECT COUNT(*) FROM review_helpfulness rh WHERE rh.reviewID = r.reviewID AND rh.isHelpful = 0) AS noVotes " +
                       "FROM game_review r JOIN user u ON r.userID = u.userID WHERE r.gameID = ?";

    PreparedStatement reviewPS = conn.prepareStatement(reviewSQL);
    reviewPS.setInt(1, gameID);
    ResultSet reviewRS = reviewPS.executeQuery();

    while (reviewRS.next()) {
        Map<String, Object> review = new HashMap<>();
        review.put("reviewID", reviewRS.getInt("reviewID"));
        review.put("textReview", reviewRS.getString("textReview"));
        review.put("starRating", reviewRS.getInt("starRating"));
        review.put("username", reviewRS.getString("username"));
        review.put("yesVotes", reviewRS.getInt("yesVotes"));
        review.put("noVotes", reviewRS.getInt("noVotes"));
        reviews.add(review);
    }

    reviewRS.close();
    reviewPS.close();
    conn.close();
} catch (Exception e) {
    out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
}
%>

<html>
<head>
  <title><%= title %></title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    body {
      background-color: #121212;
      color: #eee;
      font-family: Arial;
      margin: 0;
      padding: 0;
      text-align: center;
    }
    .cover {
      width: 100%;
      max-width: 600px;
      border-radius: 10px;
      margin-bottom: 20px;
    }
    .meta {
      margin: 20px auto;
      font-size: 1.1em;
      text-align: left;
      max-width: 800px;
    }
    .screenshot-gallery {
      display: flex;
      flex-wrap: wrap;
      gap: 10px;
      justify-content: center;
      margin-bottom: 30px;
    }
    .screenshot-gallery img {
      width: 300px;
      max-height: 180px;
      object-fit: cover;
      border-radius: 10px;
      transition: transform 0.2s;
      cursor: pointer;
    }
    .screenshot-gallery img:hover {
      transform: scale(1.05);
    }
    #lightbox {
      display: none;
      position: fixed;
      z-index: 9999;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background-color: rgba(0, 0, 0, 0.9);
      justify-content: center;
      align-items: center;
      flex-direction: column;
    }
    #lightbox img {
      max-width: 90%;
      max-height: 90%;
      border-radius: 10px;
    }
    .lightbox-arrow {
      position: absolute;
      top: 50%;
      font-size: 3rem;
      color: white;
      cursor: pointer;
      user-select: none;
    }
    .lightbox-arrow.left { left: 5%; }
    .lightbox-arrow.right { right: 5%; }

    .modal {
      display: none;
      position: fixed;
      z-index: 10000;
      left: 0;
      top: 0;
      width: 100%;
      height: 100%;
      overflow: auto;
      background-color: rgba(0,0,0,0.8);
    }

    .modal-content {
      background-color: #2a2a2a;
      margin: 10% auto;
      padding: 20px;
      border: 1px solid #888;
      width: 80%;
      max-width: 500px;
      color: white;
      border-radius: 10px;
    }

    .review-actions button {
      background-color: #2a2a2a;
      border: 1px solid #444;
      color: white;
      padding: 4px 8px;
      border-radius: 4px;
      margin: 0 2px;
      cursor: pointer;
      transition: background-color 0.2s;
    }

    .review-actions button:hover {
      background-color: #1f1f1f;
    }

    .review-actions i {
      color: white;
    }
  </style>
</head>

<body>
  <h1><%= title %></h1>
  <img class="cover" src="<%= coverArt %>" alt="Cover Art">

  <div class="meta"><strong style="color: #7F00FF;">Release Date:</strong> <%= releaseDateFormatted %></div>
  <div class="meta"><strong style="color: #7F00FF;">Developer:</strong> <%= developer %></div>
  <div class="meta"><strong style="color: #7F00FF;">ESRB Rating:</strong> <%= esrbRating %></div>
  <div class="meta"><strong style="color: #7F00FF;">Genres:</strong> <%= genres %></div>
  <div class="meta"><strong style="color: #7F00FF;">Platforms:</strong> <%= platforms %></div>
  <div class="meta"><strong style="color: #7F00FF;">Description:</strong><br><%= description %></div>

  <h2>Screenshots</h2>
  <div class="screenshot-gallery">
    <% for (int i = 0; i < imageURLs.size(); i++) { %>
      <img src="<%= imageURLs.get(i) %>" onclick="openLightbox(<%= i %>)">
    <% } %>
  </div>

  <h2>Reviews</h2>
  <% if (reviews.isEmpty()) { %>
    <p>No reviews yet. Be the first to leave one!</p>
  <% } else { %>
    <ul style="list-style: none; padding: 0;">
      <% for (Map<String, Object> review : reviews) { %>
        <li style="margin-bottom: 25px; border-bottom: 1px solid #555; padding-bottom: 10px;">
          <strong><%= review.get("username") %></strong> rated: <%= review.get("starRating") %>/5<br>
          <em><%= review.get("textReview") %></em><br>
          <% if (currentUserID != null) { %>
            <div class="review-actions">
              Helpful?
              <form style="display:inline;" method="post" action="MarkHelpfulServlet">
                <input type="hidden" name="reviewID" value="<%= review.get("reviewID") %>">
                <input type="hidden" name="userID" value="<%= currentUserID %>">
                <input type="hidden" name="isHelpful" value="1">
                <input type="hidden" name="gameID" value="<%= gameID %>">
                <button type="submit"><i class="fa-solid fa-thumbs-up"></i></button> (<%= review.get("yesVotes") %>)
              </form>
              <form style="display:inline;" method="post" action="MarkHelpfulServlet">
                <input type="hidden" name="reviewID" value="<%= review.get("reviewID") %>">
                <input type="hidden" name="userID" value="<%= currentUserID %>">
                <input type="hidden" name="isHelpful" value="0">
                <input type="hidden" name="gameID" value="<%= gameID %>">
                <button type="submit"><i class="fa-solid fa-thumbs-down"></i></button> (<%= review.get("noVotes") %>)
              </form>
              <button type="button" onclick="openFlagModal(<%= review.get("reviewID") %>)"><i class="fa-solid fa-flag"></i></button>
            </div>
          <% } %>
        </li>
      <% } %>
    </ul>
  <% } %>

  <h3>Leave a Review</h3>
  <% if (currentUserID != null) { %>
    <form action="SubmitReviewServlet" method="post">
      <input type="hidden" name="gameID" value="<%= gameID %>">
      <input type="hidden" name="userID" value="<%= currentUserID %>">
      <label>Rating:
        <select name="starRating">
          <option value="5">5 - Excellent</option>
          <option value="4">4 - Good</option>
          <option value="3">3 - Average</option>
          <option value="2">2 - Poor</option>
          <option value="1">1 - Terrible</option>
        </select>
      </label><br>
      <label>Review:<br>
        <textarea name="textReview" rows="4" required style="width: 400px; background-color: #2c2c2c; color: white; border: 1px solid #444; border-radius: 6px; padding: 8px;"></textarea>
      </label><br>
      <button type="submit">Submit Review</button>
    </form>
  <% } else { %>
    <p><em><a href="Login.jsp">Log in</a> or <a href="Signup.jsp">sign up</a> to leave a review!</em></p>
  <% } %>

  <div id="lightbox" onclick="closeLightbox(event)">
    <span class="lightbox-arrow left" onclick="prevImage(event)">&#10094;</span>
    <img id="lightbox-img" src="">
    <span class="lightbox-arrow right" onclick="nextImage(event)">&#10095;</span>
  </div>

  <div id="flagModal" class="modal">
    <div class="modal-content">
      <form action="FlagReviewServlet" method="post">
        <input type="hidden" name="userID" value="<%= currentUserID %>">
        <input type="hidden" name="gameID" value="<%= gameID %>">
        <input type="hidden" id="modalReviewID" name="reviewID">
        <h3>Select a Reason:</h3>
        <label><input type="radio" name="flagReason" value="Offensive Language" required> Offensive Language</label><br>
        <label><input type="radio" name="flagReason" value="Spam/Trolling" required> Spam/Trolling</label><br>
        <label><input type="radio" name="flagReason" value="Botted Review" required> Botted Review</label><br>
        <label>Additional Comment (Optional):<br>
          <textarea name="flagComment" rows="3" style="width: 100%; background-color: #2c2c2c; color: white; border: 1px solid #444; border-radius: 6px; padding: 8px;"></textarea>
        </label><br><br>
        <button type="submit">Submit Flag</button>
        <button type="button" onclick="closeFlagModal()">Cancel</button>
      </form>
    </div>
  </div>

  <script>
    let screenshots = <%= imageURLs.toString().replace("[", "['").replace("]", "']").replaceAll(", ", "','") %>;
    let currentIndex = 0;

    function openLightbox(index) {
      currentIndex = index;
      document.getElementById("lightbox-img").src = screenshots[currentIndex];
      document.getElementById("lightbox").style.display = "flex";
    }

    function closeLightbox(event) {
      if (event.target.id === "lightbox" || event.target === document.getElementById("lightbox-img")) {
        document.getElementById("lightbox").style.display = "none";
      }
    }

    function prevImage(event) {
      event.stopPropagation();
      currentIndex = (currentIndex - 1 + screenshots.length) % screenshots.length;
      document.getElementById("lightbox-img").src = screenshots[currentIndex];
    }

    function nextImage(event) {
      event.stopPropagation();
      currentIndex = (currentIndex + 1) % screenshots.length;
      document.getElementById("lightbox-img").src = screenshots[currentIndex];
    }

    function openFlagModal(reviewID) {
      document.getElementById("modalReviewID").value = reviewID;
      document.getElementById("flagModal").style.display = "block";
    }

    function closeFlagModal() {
      document.getElementById("flagModal").style.display = "none";
    }

    document.addEventListener("keydown", function(e) {
      if (document.getElementById("lightbox").style.display === "flex") {
        if (e.key === "ArrowLeft") prevImage(e);
        else if (e.key === "ArrowRight") nextImage(e);
        else if (e.key === "Escape") document.getElementById("lightbox").style.display = "none";
      }
      if (e.key === "Escape" && document.getElementById("flagModal").style.display === "block") {
        closeFlagModal();
      }
    });
  </script>

  <div style="height: 50px;"></div>
</body>
</html>
