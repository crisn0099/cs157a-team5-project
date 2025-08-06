package com.gamesforfun.model;
import java.sql.*;
import java.util.*;
public class UserProfile {
   private Connection conn;
   public UserProfile(Connection conn) {
       this.conn = conn;
   }
   public Map<String, String> getUserInfo(int userID) throws SQLException {
	    String query = "SELECT username, avatar, bio, isAdmin FROM user WHERE userID = ?";
	    Map<String, String> userInfo = new HashMap<>();
	    try (PreparedStatement ps = conn.prepareStatement(query)) {
	        ps.setInt(1, userID);
	        ResultSet rs = ps.executeQuery();
	        if (rs.next()) {
	            userInfo.put("username", rs.getString("username"));
	            userInfo.put("avatar", rs.getString("avatar"));
	            userInfo.put("bio", rs.getString("bio"));
	            userInfo.put("isAdmin", rs.getString("isAdmin"));
	        }
	    }
	    return userInfo;
	}

   public List<Map<String, String>> getWishlist(int userID) throws SQLException {
	   
	   String query = "SELECT g.gameID, g.title, g.releaseDate, g.coverArt, w.dateAdded " +
               "FROM wishlist w " +
               "JOIN game g ON w.gameID = g.gameID " +
               "WHERE w.userID = ? " +
               "ORDER BY w.dateAdded DESC";

       List<Map<String, String>> wishlist = new ArrayList<>();
       try (PreparedStatement ps = conn.prepareStatement(query)) {
           ps.setInt(1, userID);
           ResultSet rs = ps.executeQuery();
           while (rs.next()) {
               Map<String, String> game = new HashMap<>();
               game.put("gameID", String.valueOf(rs.getInt("gameID")));
               game.put("name", rs.getString("title"));             
               game.put("releaseDate", rs.getString("releaseDate"));
               game.put("coverImage", rs.getString("coverArt"));
               game.put("dateAdded", rs.getString("dateAdded"));
               wishlist.add(game);
           }
       }
       return wishlist;
   }

   
   public List<Map<String, String>> getFavoriteGames(int userID) throws SQLException {
	    String query = "SELECT g.gameID, g.title, g.releaseDate, g.coverArt " +
	                   "FROM favorite_games f " +
	                   "JOIN game g ON f.gameID = g.gameID " +
	                   "WHERE f.userID = ?";
	    
	    List<Map<String, String>> favorites = new ArrayList<>();
	    try (PreparedStatement ps = conn.prepareStatement(query)) {
	        ps.setInt(1, userID);
	        ResultSet rs = ps.executeQuery();
	        while (rs.next()) {
	            Map<String, String> game = new HashMap<>();
	            game.put("gameID", String.valueOf(rs.getInt("gameID")));
	            game.put("name", rs.getString("title"));
	            game.put("releaseDate", rs.getString("releaseDate"));
	            game.put("coverImage", rs.getString("coverArt"));
	            favorites.add(game);
	        }
	    }
	    return favorites;
	}

   
   public List<String> getPlayingGames(int userID) throws SQLException {
       String query = "SELECT g.name FROM playing_library pl " +
                      "JOIN game g ON pl.gameID = g.gameID WHERE pl.userID = ?";
       List<String> playing = new ArrayList<>();
       try (PreparedStatement ps = conn.prepareStatement(query)) {
           ps.setInt(1, userID);
           ResultSet rs = ps.executeQuery();
           while (rs.next()) {
               playing.add(rs.getString("name"));
           }
       }
       return playing;
   }
   public List<Map<String, String>> getReviewHistory(int userID) throws SQLException {
       String query = "SELECT g.name AS name, r.content AS review, r.rating FROM reviews r " +
                      "JOIN game g ON r.gameID = g.gameID WHERE r.userID = ?";
       List<Map<String, String>> reviews = new ArrayList<>();
       try (PreparedStatement ps = conn.prepareStatement(query)) {
           ps.setInt(1, userID);
           ResultSet rs = ps.executeQuery();
           while (rs.next()) {
               Map<String, String> review = new HashMap<>();
               review.put("name", rs.getString("name"));
               review.put("review", rs.getString("review"));
               review.put("rating", rs.getString("rating"));
               reviews.add(review);
           }
       }
       return reviews;
   }
   public double getAverageRating(int userID) throws SQLException {
       String query = "SELECT AVG(rating) AS avgRating FROM reviews WHERE userID = ?";
       try (PreparedStatement ps = conn.prepareStatement(query)) {
           ps.setInt(1, userID);
           ResultSet rs = ps.executeQuery();
           if (rs.next()) {
               return rs.getDouble("avgRating");
           }
       }
       return 0.0;
   }
   public int getHelpfulReviewCount(int userID) throws SQLException {
       String query = "SELECT SUM(helpfulCount) AS totalHelpful FROM reviews WHERE userID = ?";
       try (PreparedStatement ps = conn.prepareStatement(query)) {
           ps.setInt(1, userID);
           ResultSet rs = ps.executeQuery();
           if (rs.next()) {
               return rs.getInt("totalHelpful");
           }
       }
       return 0;
   }
   
   public List<String> getUserPlaystyles(int userID) throws SQLException {
	    String query = "SELECT p.playstyleName FROM has_playstyle hp " +
	                   "JOIN playstyle p ON hp.playstyleID = p.playstyleID " +
	                   "WHERE hp.userID = ?";
	    List<String> playstyles = new ArrayList<>();
	    try (PreparedStatement ps = conn.prepareStatement(query)) {
	        ps.setInt(1, userID);
	        ResultSet rs = ps.executeQuery();
	        while (rs.next()) {
	            playstyles.add(rs.getString("playstyleName"));
	        }
	    }
	    return playstyles;
	}
   
   public void removePlaystyle(int userID, String playstyleName) throws SQLException {
	    String sql = "DELETE FROM has_playstyle " +
	                 "WHERE userID = ? AND playstyleID = (" +
	                 "SELECT playstyleID FROM playstyle WHERE playstyleName = ?)";
	    try (PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setInt(1, userID);
	        ps.setString(2, playstyleName);
	        ps.executeUpdate();
	    }
	}

   
   public List<Map<String, String>> getLibrary(int userID) throws SQLException {
	   String query = "SELECT g.gameID, g.title, g.coverArt FROM library l JOIN game g ON l.gameID = g.gameID WHERE l.userID = ?";

	    
	    List<Map<String, String>> library = new ArrayList<>();
	    try (PreparedStatement ps = conn.prepareStatement(query)) {
	        ps.setInt(1, userID);
	        ResultSet rs = ps.executeQuery();
	        while (rs.next()) {
	            Map<String, String> game = new HashMap<>();
	            game.put("gameID", String.valueOf(rs.getInt("gameID")));
	            game.put("name", rs.getString("title"));
	            game.put("coverImage", rs.getString("coverArt"));
	            library.add(game);
	        }
	    }
	    return library;
	}


   private static final Map<String, String> playstyleBadgeMap = Map.of(
		    "Casual", "/images/badges/casual.png",
		    "Competitive", "/images/badges/competitive.png",
		    "Explorer", "/images/badges/explorer.png",
		    "Completionist", "/images/badges/completionist.png",
		    "Social", "/images/badges/social.png",
		    "Speedrunner", "/images/badges/speedrunner3.png",
		    "Immersive", "/images/badges/immersive.png",
		    "Strategist", "/images/badges/strategist.png",
		    "Content Creator", "/images/badges/contentcreator.png",
		    "Multitasker", "/images/badges/multitasker.png"
		);
   
   public static Map<String, String> getPlaystyleBadgeMap() {
	    return playstyleBadgeMap;
	} 
}
