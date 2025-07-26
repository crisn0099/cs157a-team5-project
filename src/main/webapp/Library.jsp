<%@ page import="java.sql.*, java.time.LocalDate" %>
<%
   String jdbcURL = "jdbc:mysql://localhost:3306/games_for_me?autoReconnect=true&useSSL=false";
   String dbUser = "root";
   String dbPassword = "Hardinser20@"; // Your actual password

   try {
       int userID = Integer.parseInt(request.getParameter("userID"));
       int gameID = Integer.parseInt(request.getParameter("gameID"));
       Class.forName("com.mysql.cj.jdbc.Driver");
       Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

       String checkQuery = "SELECT 1 FROM library WHERE userID = ?? AND gameID = ?";
       try (PreparedStatement checkStmt = conn.prepareStatement(checkQuery)) {
           checkStmt.setInt(1, userID);
           checkStmt.setInt(2, gameID);
           ResultSet rs = checkStmt.executeQuery();

           if (!rs.next()) {
               String insertQuery = "INSERT INTO library (userID, gameID) VALUES (?, ?)";
               try (PreparedStatement insertStmt = conn.prepareStatement(insertQuery)) {
                   insertStmt.setInt(1, userID);
                   insertStmt.setInt(2, gameID);
                   insertStmt.executeUpdate();
               }
           }
       }

       conn.close();
       response.sendRedirect("MainPage.jsp");
   } catch (Exception e) {
       out.println("<p style='color:red;'>Error adding to library: " + e.getMessage() + "</p>");
   }
%>