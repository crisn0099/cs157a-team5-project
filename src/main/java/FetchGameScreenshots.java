import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;
import org.json.JSONArray;
import org.json.JSONObject;

public class FetchGameScreenshots {
    private static final String apiKey = "7ba31eb2771e41cd82d7b985c8c4f489";
    private static final String jdbcUrl = "jdbc:mysql://localhost:3306/games_for_me?autoReconnect=true&useSSL=false";
    private static final String dbUser = "root";
    private static final String dbPass = "DBpassword";

    public static void main(String[] args) {
        try (Connection conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPass)) {
            Class.forName("com.mysql.cj.jdbc.Driver");

            // manual slug fixes for problematic games
            Map<String, String> manualSlugs = new HashMap<>();
            manualSlugs.put("Tomb Raider (2013)", "tomb-raider");
            manualSlugs.put("Life is Strange", "life-is-strange-episode-1-2");
            manualSlugs.put("God of War (2018)", "god-of-war-2");
            manualSlugs.put("DOOM (2016)", "doom");
            manualSlugs.put("Middle-earth: Shadow of Mordor", "shadow-of-mordor");
            manualSlugs.put("The Walking Dead: Season 1", "the-walking-dead");
            manualSlugs.put("FIFA 22", "fifa-22-xbox-one");
            manualSlugs.put("The Last of Us Part II", "the-last-of-us-part-2");
            manualSlugs.put("Guilty Gear -Strive", "guilty-gear-2020");

            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT gameID, title FROM Game");

            String insertScreenshotSQL = "INSERT INTO game_screenshot (gameID, imageURL) VALUES (?, ?)";
            PreparedStatement insertScreenshotStmt = conn.prepareStatement(insertScreenshotSQL);

            while (rs.next()) {
                int gameID = rs.getInt("gameID");
                String title = rs.getString("title");

                String slug = manualSlugs.getOrDefault(title, title.toLowerCase()
                        .replace(" ", "-")
                        .replace(":", "")
                        .replace("'", "")
                        .replace("\"", "")
                        .replaceAll("[^a-z0-9\\-]", ""));

                String apiUrl = "https://api.rawg.io/api/games/" + slug + "/screenshots?key=" + apiKey;

                try {
                    URL url = new URL(apiUrl);
                    HttpURLConnection http = (HttpURLConnection) url.openConnection();
                    http.setRequestMethod("GET");

                    BufferedReader in = new BufferedReader(new InputStreamReader(http.getInputStream()));
                    StringBuilder response = new StringBuilder();
                    String line;
                    while ((line = in.readLine()) != null) {
                        response.append(line);
                    }
                    in.close();

                    JSONObject responseJson = new JSONObject(response.toString());
                    JSONArray screenshots = responseJson.getJSONArray("results");

                    for (int i = 0; i < screenshots.length(); i++) {
                        String imageURL = screenshots.getJSONObject(i).getString("image");
                        insertScreenshotStmt.setInt(1, gameID);
                        insertScreenshotStmt.setString(2, imageURL);
                        insertScreenshotStmt.executeUpdate();
                    }

                    System.out.println("Screenshots added for: " + title);

                } catch (Exception e) {
                    System.out.println("Failed for: " + title + " (slug: " + slug + ")");
                    e.printStackTrace();
                }
            }

            insertScreenshotStmt.close();
            rs.close();
            stmt.close();
            System.out.println("All screenshots fetched.");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
