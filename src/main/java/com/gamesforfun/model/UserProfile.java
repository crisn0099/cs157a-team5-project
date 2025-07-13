package com.gamesforfun.model;
import java.sql.*;
import java.util.*;
public class UserProfile {
   private Connection conn;
   public UserProfile(Connection conn) {
       this.conn = conn;
   }
   public Map<String, String> getUserInfo(int userID) throws SQLException {
       String query = "SELECT username, avatar, bio, gamingPreferences, playStyle FROM user WHERE userID = ?";
       Map<String, String> userInfo = new HashMap<>();
       try (PreparedStatement ps = conn.prepareStatement(query)) {
           ps.setInt(1, userID);
           ResultSet rs = ps.executeQuery();
           if (rs.next()) {
               userInfo.put("username", rs.getString("username"));
               userInfo.put("avatar", rs.getString("avatar"));
               userInfo.put("bio", rs.getString("bio"));
               userInfo.put("gamingPreferences", rs.getString("gamingPreferences"));
               userInfo.put("playStyle", rs.getString("playStyle"));
           }
       }
       return userInfo;
   }
   public List<Map<String, String>> getWishlist(int userID) throws SQLException {
       String query = "SELECT g.name, g.releaseDate, g.coverImage FROM wishlist w " +
                      "JOIN game g ON w.gameID = g.gameID WHERE w.userID = ?";
       List<Map<String, String>> wishlist = new ArrayList<>();
       try (PreparedStatement ps = conn.prepareStatement(query)) {
           ps.setInt(1, userID);
           ResultSet rs = ps.executeQuery();
           while (rs.next()) {
               Map<String, String> game = new HashMap<>();
               game.put("name", rs.getString("name"));
               game.put("releaseDate", rs.getString("releaseDate"));
               game.put("coverImage", rs.getString("coverImage"));
               wishlist.add(game);
           }
       }
       return wishlist;
   }
   public List<String> getFavoriteGames(int userID) throws SQLException {
       String query = "SELECT g.name FROM favorite_games fg " +
                      "JOIN game g ON fg.gameID = g.gameID WHERE fg.userID = ?";
       List<String> favorites = new ArrayList<>();
       try (PreparedStatement ps = conn.prepareStatement(query)) {
           ps.setInt(1, userID);
           ResultSet rs = ps.executeQuery();
           while (rs.next()) {
               favorites.add(rs.getString("name"));
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
}
