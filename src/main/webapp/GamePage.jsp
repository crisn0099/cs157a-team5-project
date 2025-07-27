<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*, java.util.*" %>
<%
String jdbcURL = "jdbc:mysql://localhost:3306/games_for_me?autoReconnect=true&useSSL=false";
String dbUser = "root";
String dbPassword = "Hardinser20@";

String gameIDStr = request.getParameter("gameID");
int gameID = Integer.parseInt(gameIDStr);
String title = "", releaseDate = "", coverArt = "", genres = "", platforms = "", description = "";
List<Map<String, Object>> reviews = new ArrayList<>();

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

  <h2>Reviews</h2>
  <% if (reviews.isEmpty()) { %>
    <p>No reviews yet. Be the first to leave one!</p>
  <% } else { %>
    <ul style="list-style: none; padding: 0;">
    <% for (Map<String, Object> review : reviews) { %>
        <li style="margin-bottom: 25px; border-bottom: 1px solid #555; padding-bottom: 10px;">
            <strong><%= review.get("username") %></strong> rated: <%= review.get("starRating") %>/5<br>
            <em><%= review.get("textReview") %></em><br>
            Helpful? 
            <form style="display:inline;" method="post" action="MarkHelpfulServlet">
                <input type="hidden" name="reviewID" value="<%= review.get("reviewID") %>">
                <input type="hidden" name="userID" value="<%= session.getAttribute("userID") %>">
                <input type="hidden" name="isHelpful" value="1">
                <button type="submit">👍</button>
                (<%= review.get("yesVotes") %>)
            </form>
            <form style="display:inline;" method="post" action="MarkHelpfulServlet">
                <input type="hidden" name="reviewID" value="<%= review.get("reviewID") %>">
                <input type="hidden" name="userID" value="<%= session.getAttribute("userID") %>">
                <input type="hidden" name="isHelpful" value="0">
                <button type="submit">👎</button>
                (<%= review.get("noVotes") %>)
            </form>
        </li>
    <% } %>
    </ul>
  <% } %>

  <h3>Leave a Review</h3>
  <form action="SubmitReviewServlet" method="post">
    <input type="hidden" name="gameID" value="<%= gameID %>">
    <input type="hidden" name="userID" value="<%= session.getAttribute("userID") %>">
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
      <textarea name="textReview" rows="4" cols="60" required></textarea>
    </label><br>
    <button type="submit">Submit Review</button>
  </form>
</body>
</html>
