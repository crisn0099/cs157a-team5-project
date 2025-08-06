<%@ page import="java.sql.*, java.util.*, com.gamesforfun.model.UserProfile" %>
<jsp:include page="navbar.jsp" />
<%

    Integer userID = (Integer) session.getAttribute("userID");
    if (userID == null) {
        response.sendRedirect("Login.jsp");
        return;
    }

    Map<String, String> badgeMap = UserProfile.getPlaystyleBadgeMap();
    Map<String, String> playstyleDescriptions = Map.of(
    	    "Casual", "Plays games mainly for fun and relaxation, without focusing on competition or high skill.",
    	    "Competitive", "Focuses on winning, ranking, or mastering game mechanics.",
    	    "Explorer", "Enjoys discovering game worlds, storylines, secrets, and lore rather than rushing through objectives.",
    	    "Strategist", "Enjoys games that require tactical thinking, planning, and problem-solving.",
    	    "Immersive", "Engages deeply with story and characters for a personal, narrative-driven experience.",
    	    "Completionist", "Aims to experience every aspect of a game, including side quests, collectibles, and achievements.",
    	    "Social", "Prefers games with social interaction, co-op play, or playing with friends.",
    	    "Speedrunner", "Plays games aiming to finish them in the shortest time by mastering optimized routes and execution.",
    	    "Content Creator", "Plays games with the intent to entertain others online.",
    	    "Multitasker", "Enjoys juggling multiple objectives or games simultaneously."
    	);

    String jdbcURL = "jdbc:mysql://localhost:3306/games_for_me";
    String dbUser = "root";
    String dbPassword = "DBpassword";

    if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("playstyleID") != null) {
        try {
            int playstyleID = Integer.parseInt(request.getParameter("playstyleID"));
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

            String checkQuery = "SELECT 1 FROM has_playstyle WHERE userID = ? AND playstyleID = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkQuery)) {
                checkStmt.setInt(1, userID);
                checkStmt.setInt(2, playstyleID);
                ResultSet rs = checkStmt.executeQuery();

                if (!rs.next()) {
                    String insertQuery = "INSERT INTO has_playstyle (userID, playstyleID) VALUES (?, ?)";
                    try (PreparedStatement insertStmt = conn.prepareStatement(insertQuery)) {
                        insertStmt.setInt(1, userID);
                        insertStmt.setInt(2, playstyleID);
                        insertStmt.executeUpdate();
                    }
                }
            }

            conn.close();
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error adding playstyle: " + e.getMessage() + "</p>");
        }
    }

    List<Map<String, String>> allPlaystyles = new ArrayList<>();
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
        String sql = "SELECT * FROM playstyle";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> psMap = new HashMap<>();
                psMap.put("id", rs.getString("playstyleID"));
                psMap.put("name", rs.getString("playstyleName"));
                allPlaystyles.add(psMap);
            }
        }
        conn.close();
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error loading playstyles: " + e.getMessage() + "</p>");
    }
%>

<html>
<head>
    <title>Select Playstyles</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { 
        background-color: #121212;
        color: white;
        font-family: Arial, sans-serif; 
        }
        .playstyle-list { 
        width: 60%;
        margin: auto; 
        }
        .playstyle-card {
	    background-color: #1f1f1f;
	    border: 1px solid #444;
	    border-radius: 10px;
	    padding: 20px;
	    margin: 20px auto;
	    width: 80%;
	    display: flex;
	    align-items: center;
	    justify-content: space-between;
	    gap: 30px;
		}
		.playstyle-info {
		    display: flex;
		    align-items: center;
		    gap: 20px;
		    flex-grow: 1;
		}
		.playstyle-info img {
		    width: 60px;
		    height: 60px;
		    object-fit: cover;
		    border-radius: 10px;
		    background-color: #2a2a2a;
		}
		.playstyle-name {
		    font-size: 1.2em;
		    font-weight: bold;
		}
		.playstyle-description {
		    font-size: 0.95em;
		    color: #ccc;
		    margin-top: 4px;
		    max-width: 600px;
		}
        .add-btn {
            background-color: #3399ff;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 5px;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <h2 style="text-align:center;">Choose Your Playstyles</h2>
    <div class="playstyle-list">
        <% for (Map<String, String> ps : allPlaystyles) { %>
<div class="playstyle-card">
    <div class="playstyle-info">
        <% 
            String psName = ps.get("name");
            String badgePath = badgeMap.get(psName);
            String description = playstyleDescriptions.getOrDefault(psName, "No description available.");
        %>
        <% if (badgePath != null) { %>
            <img src="<%= request.getContextPath() + badgePath %>" alt="<%= psName %>" />
        <% } %>
        <div>
            <div class="playstyle-name"><%= psName %></div>
            <div class="playstyle-description"><%= description %></div>
        </div>
    </div>
    <form method="post" action="Playstyles.jsp">
        <input type="hidden" name="playstyleID" value="<%= ps.get("id") %>" />
        <button type="submit" class="add-btn">Add</button>
    </form>
</div>
            

        <% } %>
    </div>
</body>
</html>
