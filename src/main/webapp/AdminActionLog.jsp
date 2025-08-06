<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*, java.util.*" %>
<%
    int userID = (Integer) session.getAttribute("userID");
    if (userID != 1) { response.sendRedirect("Login.jsp"); return; }

    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/games_for_me", "root", "Hardinser20@");

    String flaggedQuery =
        "SELECT r.reviewID, r.textReview, r.flagReason, r.flagComment, u.username, g.title " +
        "FROM game_review r " +
        "JOIN user u ON r.userID = u.userID " +
        "JOIN game g ON r.gameID = g.gameID " +
        "WHERE r.isFlagged = 1 AND r.isDeleted = 0";
    PreparedStatement ps1 = conn.prepareStatement(flaggedQuery);
    ResultSet flaggedRS = ps1.executeQuery();

    String logQuery =
        "SELECT a.reviewID, a.actionType, a.actionComment, a.timestamp, a.resolutionTimestamp, " +
        "r.textReview, r.flagReason, r.flagComment, u.username, g.title " +
        "FROM admin_action_log a " +
        "LEFT JOIN game_review r ON a.reviewID = r.reviewID " +
        "LEFT JOIN user u ON r.userID = u.userID " +
        "LEFT JOIN game g ON r.gameID = g.gameID " +
        "ORDER BY a.timestamp DESC";

    PreparedStatement ps2 = conn.prepareStatement(logQuery);
    ResultSet logRS = ps2.executeQuery();
%>

<html>
<head>
  <title>Admin Review Moderation</title>
  <style>
    body { background-color:#121212; color:white; font-family: Arial; }
    table { border-collapse: collapse; background:#1e1e1e; width: 100%; margin-bottom: 40px; }
    th, td { padding:10px; border:1px solid #555; vertical-align: top; }
    .modal {
      display: none; position: fixed; z-index: 10000;
      left: 0; top: 0; width: 100%; height: 100%;
      background-color: rgba(0,0,0,0.8);
    }
    .modal-content {
      background-color: #2a2a2a;
      margin: 10% auto; padding: 20px;
      width: 80%; max-width: 500px;
      border: 1px solid #888; border-radius: 10px;
      color: white;
    }
  </style>
</head>
<body>

<h1>Flagged Reviews</h1>
<table>
<tr>
  <th>User</th><th>Game</th><th>Review</th><th>Flag Reason</th><th>Flag Comment</th><th>Actions</th>
</tr>
<%
  while (flaggedRS.next()) {
%>
<tr>
  <td><%= flaggedRS.getString("username") %></td>
  <td><%= flaggedRS.getString("title") %></td>
  <td><%= flaggedRS.getString("textReview") %></td>
  <td><%= flaggedRS.getString("flagReason") %></td>
  <td><%= flaggedRS.getString("flagComment") %></td>
  <td>
    <button onclick="openAdminModal('<%= flaggedRS.getInt("reviewID") %>', 'approve', `<%= flaggedRS.getString("textReview").replaceAll("`", "'") %>`)">Approve</button>
    <button onclick="openAdminModal('<%= flaggedRS.getInt("reviewID") %>', 'delete', `<%= flaggedRS.getString("textReview").replaceAll("`", "'") %>`)">Delete</button>
  </td>
</tr>
<% } %>
</table>

<div id="adminModal" class="modal">
  <div class="modal-content">
    <form method="post" action="AdminActionServlet">
      <input type="hidden" name="reviewID" id="modalReviewID">
      <input type="hidden" name="action" id="modalActionType">
      <p><strong>Review:</strong> <span id="modalReviewText"></span></p>
      <label>Action Comment (Optional):<br>
        <textarea name="comment" rows="4" cols="50" placeholder="Explain your decision..."></textarea>
      </label><br><br>
      <button type="submit">Submit</button>
      <button type="button" onclick="closeAdminModal()">Cancel</button>
    </form>
  </div>
</div>

<h2>Admin Action Log History</h2>
<table>
<tr>
  <th>User</th><th>Game</th><th>Review</th>
  <th>Action Type</th><th>Admin Comment</th><th>Flagged At</th><th>Resolved At</th>
</tr>
<%
  while (logRS.next()) {
%>
<tr>
  <td><%= logRS.getString("username") %></td>
  <td><%= logRS.getString("title") %></td>
  <td><%= logRS.getString("textReview") %></td>
  <td><%= logRS.getString("actionType") %></td>
  <td><%= logRS.getString("actionComment") %></td>
  <td><%= logRS.getString("timestamp") %></td>
  <td><%= logRS.getString("resolutionTimestamp") %></td>
</tr>
<% } %>
</table>

<script>
  function openAdminModal(reviewID, actionType, reviewText) {
    document.getElementById("modalReviewID").value = reviewID;
    document.getElementById("modalActionType").value = actionType;
    document.getElementById("modalReviewText").innerText = reviewText;
    document.getElementById("adminModal").style.display = "block";
  }
  function closeAdminModal() {
    document.getElementById("adminModal").style.display = "none";
  }
  document.addEventListener("keydown", function(e) {
    if (e.key === "Escape" && document.getElementById("adminModal").style.display === "block") {
      closeAdminModal();
    }
  });
</script>

</body>
</html>
