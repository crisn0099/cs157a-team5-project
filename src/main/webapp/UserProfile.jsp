<%@ page import="java.sql.*, java.util.*, com.gamesforfun.model.UserProfile" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="navbar.jsp" />

<%
   Integer userID = (Integer) session.getAttribute("userID");
   if (userID == null) {
       response.sendRedirect("Login.jsp");
       return;
   }
   
   

   String jdbcURL = "jdbc:mysql://localhost:3306/games_for_me";
   String dbUser = "root";
   String dbPassword = "Hardinser20@";
   Connection conn = null;
   UserProfile profile = null;
   Map<String, String> userInfo = new HashMap<>();
   List<Map<String, String>> wishlist = new ArrayList<>();
   List<Map<String, String>> favoriteGames = new ArrayList<>();
   List<Map<String, String>> library = new ArrayList<>();
   List<String> userPlaystyles = new ArrayList<>();
   
   boolean editMode = "true".equals(request.getParameter("edit"));

   try {
       Class.forName("com.mysql.cj.jdbc.Driver");
       conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

       if ("POST".equalsIgnoreCase(request.getMethod())) {
    if (request.getParameter("bio") != null && request.getParameter("avatar") != null) {
        String newBio = request.getParameter("bio");
        String newAvatar = request.getParameter("avatar");
        String updateQuery = "UPDATE user SET bio = ?, avatar = ? WHERE userID = ?";
        try (PreparedStatement ps = conn.prepareStatement(updateQuery)) {
            ps.setString(1, newBio);
            ps.setString(2, newAvatar);
            ps.setInt(3, userID);
            ps.executeUpdate();
        }
    } else if (request.getParameter("removePlaystyle") != null) {
        String playstyleToRemove = request.getParameter("removePlaystyle");
        profile = new UserProfile(conn);
        profile.removePlaystyle(userID, playstyleToRemove);
    }
}


       profile = new UserProfile(conn);
       userInfo = profile.getUserInfo(userID);
       wishlist = profile.getWishlist(userID);
       favoriteGames = profile.getFavoriteGames(userID);
       library = profile.getLibrary(userID);
       userPlaystyles = profile.getUserPlaystyles(userID);
   } catch (Exception e) {
       out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
       e.printStackTrace(new java.io.PrintWriter(out));
   }
%>
<html>
<head>
   <title>User Profile</title>
   <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
   <style>
       body { background-color: #121212; color: white; font-family: Arial, sans-serif; margin: 0; padding: 0; }
       .profile-center { text-align: center; padding: 0 20px; }
.avatar {
  width: 100px;
  height: 100px;             
  object-fit: cover;         
  border-radius: 50%;        
  border: 2px solid #444;     
  background-color: #1e1e1e; 
}
       h2 { margin-top: 30px; text-align: left; width: 85%; margin-left: auto; margin-right: auto; }

       .admin-btn {
           background-color: #0066cc;
           color: white;
           padding: 6px 12px;
           border-radius: 5px;
           border: none;
           font-size: 1em;
           margin-top: 10px;
           cursor: pointer;
       }
       .admin-btn:hover { background-color: #0052a3; }
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
       .game-card:hover { transform: scale(1.01); }
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

.button-base {
    padding: 6px 12px;
    border-radius: 5px;
    border: none;
    font-size: 1em;
    cursor: pointer;
    transition: background-color 0.3s ease;
    color: white;
}
.admin-log-btn {
    background-color: #7F00FF;
    margin-left: 20px;
}
.admin-log-btn:hover {
    background-color: #6D2F9C;
}


.edit-profile-btn {
    background-color: #7F00FF; 
    margin-top: 40px;
    margin-right: 5px;
}
.edit-profile-btn:hover {
    background-color: #6D2F9C;
}

.logout-btn {
    background-color: #cc0000;
    margin-right: 5px;
    margin-top: 0px;
}
.logout-btn:hover {
    background-color: #a30000;
}

.remove-btn {
  background-color: #cc0000;
}

.remove-btn:hover {
  background-color: #990000;
}
.playstyle-link {
    color: white;
    text-decoration: none;
    font-weight: bold;
    transition: color 0.3s ease;
}
.playstyle-link:hover {
    color: #7F00FF; 
    text-decoration: none;
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

   </style>
</head>
<body>
<div style="display: flex; justify-content: space-between; align-items: flex-start; padding: 20px 40px;">
  
  
    <div>
        <% if ("1".equals(userInfo.get("isAdmin"))) { %>
            <form action="AdminActionLog.jsp" method="get">
                <button class="button-base admin-log-btn" type="submit">
                    <i class="fa-solid fa-shield-halved"></i> Admin Action Log
                </button>
            </form>
        <% } %>
    </div>

  
    <div style="display: flex; flex-direction: column; align-items: flex-end; gap: 10px;">
        <form action="Logout.jsp" method="post">
            <button class="button-base logout-btn" type="submit">
                <i class="fa-solid fa-right-from-bracket"></i> Logout
            </button>
        </form>
        
        <form method="get" action="UserProfile.jsp">
            <input type="hidden" name="edit" value="<%= !editMode %>" />
            <button type="submit" class="button-base edit-profile-btn">
                <i class="fa-solid fa-pen-to-square"></i> <%= editMode ? "Exit Edit Mode" : "Edit Profile" %>
            </button>
        </form>
    </div>
</div>
    <div class="profile-center">
        <h1><%= userInfo.getOrDefault("username", "Unknown User") %>'s Profile</h1>
        <img src="<%= userInfo.get("avatar") != null ? userInfo.get("avatar") : "https://via.placeholder.com/100" %>" class="avatar" />

        <% if (editMode) { %>
            <form method="post" action="UserProfile.jsp?edit=true">
                <input type="hidden" name="userID" value="<%= userID %>">
                <label for="avatar">Avatar URL:</label><br>
<input type="text" name="avatar" value="<%= userInfo.get("avatar") %>" 
       style="width: 25%; background-color: #2c2c2c; color: white; border: 1px solid #444; padding: 8px; border-radius: 6px;"><br><br>

<label for="bio">Bio:</label><br>
<textarea name="bio" rows="4" cols="60"
          style="width: 30%; background-color: #2c2c2c; color: white; border: 1px solid #444; padding: 8px; border-radius: 6px;"><%= userInfo.get("bio") %></textarea><br><br>

                <button type="submit" class="admin-btn">Save Profile</button>
            </form>
        <% } else { %>
            <%
    String bio = userInfo.get("bio");
    if (bio == null || bio.trim().isEmpty() || "null".equalsIgnoreCase(bio.trim())) {
%>
    <p><i>No bio available.</i></p>
<%
    } else {
%>
    <p><%= bio %></p>
<%
    }
%>

        <% } %>

        <h2 style="text-align: center;">
            <a href="Playstyles.jsp" class="playstyle-link">Playstyles</a>
        </h2>

        <% Map<String, String> badgeMap = UserProfile.getPlaystyleBadgeMap(); %>
        <% if (userPlaystyles.isEmpty()) { %>
            <p><i>No playstyles selected.</i></p>
        <% } else { %>
            <div style="display: flex; flex-wrap: wrap; justify-content: center; gap: 20px; padding: 10px 0;">
                <% for (String ps : userPlaystyles) {
                    String badgePath = badgeMap.get(ps);
                %>
                <div style="display: flex; flex-direction: column; align-items: center;">
                    <% if (badgePath != null) { %>
                        <img src="<%= request.getContextPath() + badgePath %>" alt="<%= ps %>" style="width: 50px; height: 50px; object-fit: cover;" />
                    <% } %>
                    <span style="margin-top: 5px; font-size: 0.9em;"><%= ps %></span>
                        <% if (editMode) { %>
        <form method="post" action="UserProfile.jsp?edit=true" style="margin-top: 5px;">
            <input type="hidden" name="removePlaystyle" value="<%= ps %>">
            <button type="submit" class="button-base remove-btn" style="font-size: 0.8em; padding: 4px 8px;">
                <i class="fa-solid fa-trash"></i>
            </button>
        </form>
    <% } %>
                    
                </div>
                <% } %>
            </div>
        <% } %>
    </div>

    <h2>Library</h2>
    <div class="game-container">
    <% for (Map<String, String> game : library) {
        String cover = game.get("coverImage") != null ? game.get("coverImage") : "https://via.placeholder.com/200x120.png?text=No+Image";
    %>
        <div class="game-card">
            <a href="GamePage.jsp?gameID=<%= game.get("gameID") %>" style="text-decoration: none; color: inherit; display: flex; flex-grow: 1;">
                <div class="game-cover-container">
  					<img class="game-cover" src="<%= cover %>" alt="Cover Art">
				</div>

                <div class="game-info">
                    <div class="game-title"><%= game.get("name") %></div>
                </div>
            </a>
            <% if (editMode) { %>
                <form method="post" action="Library.jsp">
                    <input type="hidden" name="userID" value="<%= userID %>" />
                    <input type="hidden" name="gameID" value="<%= game.get("gameID") %>" />
                    <input type="hidden" name="action" value="remove" />
                    <button type="submit" class="admin-btn remove-btn" title="Remove">
    <i class="fa-solid fa-trash"></i>
</button>


                </form>
            <% } %>
        </div>
    <% } %>
    </div>

    <h2>Favorite Games</h2>
    <div class="game-container">
    <% for (Map<String, String> game : favoriteGames) {
        String cover = game.get("coverImage") != null ? game.get("coverImage") : "https://via.placeholder.com/200x120.png?text=No+Image";
    %>
        <div class="game-card">
            <a href="GamePage.jsp?gameID=<%= game.get("gameID") %>" style="text-decoration: none; color: inherit; display: flex; flex-grow: 1;">
                <div class="game-cover-container">
  					<img class="game-cover" src="<%= cover %>" alt="Cover Art">
				</div>
                <div class="game-info">
                    <div class="game-title"><%= game.get("name") %></div>
                </div>
            </a>
            <% if (editMode) { %>
                <form method="post" action="Favorite.jsp">
                    <input type="hidden" name="userID" value="<%= userID %>" />
                    <input type="hidden" name="gameID" value="<%= game.get("gameID") %>" />
                    <input type="hidden" name="action" value="remove" />
                    <button type="submit" class="admin-btn remove-btn" title="Remove">
   						 <i class="fa-solid fa-trash"></i>
					</button>
                    
                </form>
            <% } %>
        </div>
    <% } %>
    </div>

    <h2>Wishlist</h2>
    <div class="game-container">
    <% for (Map<String, String> game : wishlist) {
        String cover = game.get("coverImage") != null ? game.get("coverImage") : "https://via.placeholder.com/200x120.png?text=No+Image";
    %>
        <div class="game-card">
            <a href="GamePage.jsp?gameID=<%= game.get("gameID") %>" style="text-decoration: none; color: inherit; display: flex; flex-grow: 1;">
                <div class="game-cover-container">
  					<img class="game-cover" src="<%= cover %>" alt="Cover Art">
				</div>
                <div class="game-info">
                    <div class="game-title"><%= game.get("name") %></div>
                    <%
    String rawDate = game.get("dateAdded");
    String formattedDate = rawDate;
    try {
        java.text.SimpleDateFormat inputFormat = new java.text.SimpleDateFormat("yyyy-MM-dd");
        java.text.SimpleDateFormat outputFormat = new java.text.SimpleDateFormat("MMM dd, yyyy");
        java.util.Date parsedDate = inputFormat.parse(rawDate);
        formattedDate = outputFormat.format(parsedDate);
    } catch (Exception e) {
    }
%>
<div class="game-meta">Date Added: <%= formattedDate %></div>

                </div>
            </a>
            <% if (editMode) { %>
                <form method="post" action="Wishlist.jsp">
                    <input type="hidden" name="userID" value="<%= userID %>" />
                    <input type="hidden" name="gameID" value="<%= game.get("gameID") %>" />
                    <input type="hidden" name="action" value="remove" />
                    <button type="submit" class="admin-btn remove-btn" title="Remove">
    					<i class="fa-solid fa-trash"></i>
					</button>

                </form>
            <% } %>
        </div>
    <% } %>
    </div>
</div>
</body>
</html>