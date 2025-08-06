<%@ page import="java.sql.*" %>
<%
   String jdbcURL = "jdbc:mysql://localhost:3306/games_for_me?autoReconnect=true&useSSL=false";
   String dbUser = "root";
   String dbPassword = "DBpassword";

   try {
       int userID = Integer.parseInt(request.getParameter("userID"));
       int gameID = Integer.parseInt(request.getParameter("gameID"));
       String action = request.getParameter("action");

       Class.forName("com.mysql.cj.jdbc.Driver");
       Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

       if ("remove".equals(action)) {
           String deleteQuery = "DELETE FROM favorite_games WHERE userID = ? AND gameID = ?";
           try (PreparedStatement deleteStmt = conn.prepareStatement(deleteQuery)) {
               deleteStmt.setInt(1, userID);
               deleteStmt.setInt(2, gameID);
               deleteStmt.executeUpdate();
           }
       } else {
           String checkQuery = "SELECT 1 FROM favorite_games WHERE userID = ? AND gameID = ?";
           try (PreparedStatement checkStmt = conn.prepareStatement(checkQuery)) {
               checkStmt.setInt(1, userID);
               checkStmt.setInt(2, gameID);
               ResultSet rs = checkStmt.executeQuery();
               if (!rs.next()) {
                   String insertQuery = "INSERT INTO favorite_games (userID, gameID) VALUES (?, ?)";
                   try (PreparedStatement insertStmt = conn.prepareStatement(insertQuery)) {
                       insertStmt.setInt(1, userID);
                       insertStmt.setInt(2, gameID);
                       insertStmt.executeUpdate();
                   }
               }
           }
       }

       conn.close();
       String referer = request.getHeader("referer");
       response.sendRedirect(referer != null ? referer : "MainPage.jsp");
   } catch (Exception e) {
       out.println("<p style='color:red;'>Error processing favorites: " + e.getMessage() + "</p>");
   }
%>