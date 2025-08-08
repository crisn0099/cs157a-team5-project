<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    request.setAttribute("currentPage", "Platforms");
%>
<jsp:include page="navbar.jsp" />
<%
Integer userID = (Integer) session.getAttribute("userID");
%>

<html>
<head>
  <title>Browse by Platform</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    body {
      background-color: #121212;
      color: #fff;
      font-family: Arial, sans-serif;
      margin: 0;
      padding: 0;
    }
    h2 {
      text-align: center;
      margin-top: 0;
      padding: 20px 0;
      font-size: 2.5em;
    }
    .platform-container {
      display: flex;
      flex-wrap: wrap;
      justify-content: center;
      gap: 20px;
      padding: 40px;
    }
    .platform-card {
      width: 250px;
      height: 100px;
      background-color: #2e2e2e;
      border-radius: 10px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 1.3em;
      font-weight: bold;
      text-align: center;
      color: white;
      text-decoration: none;
      box-shadow: 0 4px 10px rgba(0,0,0,0.5);
      transition: transform 0.3s, background-color 0.3s;
    }
    .platform-card:hover {
      transform: scale(1.05);
      background-color: #7F00FF;
    }
  </style>
</head>
<body>

<h2>Browse by Platform</h2>
<div class="platform-container">
<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/games_for_me?useUnicode=true&characterEncoding=UTF-8", 
            "root", 
            "DBpassword"
        );

        String sql = "SELECT platformID, platformName FROM game_platform ORDER BY platformName";
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(sql);

        while (rs.next()) {
            int platformID = rs.getInt("platformID");
            String platformName = rs.getString("platformName");
%>
    <a class="platform-card" href="PlatformGames.jsp?platformID=<%= platformID %>"><%= platformName %></a>
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