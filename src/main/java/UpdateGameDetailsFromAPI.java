import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;
import org.json.JSONArray;
import org.json.JSONObject;

public class UpdateGameDetailsFromAPI {
    private static final String apiKey = "7ba31eb2771e41cd82d7b985c8c4f489";
    private static final String jdbcUrl = "jdbc:mysql://localhost:3306/games_for_me?autoReconnect=true&useSSL=false";
    private static final String dbUser = "root";
    private static final String dbPass = "DBpassword";

    public static void main(String[] args) {
        try (Connection conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPass)) {
            Class.forName("com.mysql.cj.jdbc.Driver");

            // manual slug fixes for problematic games
            Map<String, String> manualSlugs = new HashMap<>();
            manualSlugs.put("Marvel Rivals", "marvel-rivals");
            

            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT gameID, title FROM Game WHERE description IS NULL");

            String updateSQL = "UPDATE Game SET description = ?, ESRB_rating = ?, developer = ?, officialSiteURL = ? WHERE gameID = ?";
            PreparedStatement updateStmt = conn.prepareStatement(updateSQL);

            while (rs.next()) {
                int gameID = rs.getInt("gameID");
                String title = rs.getString("title");

                // use manual slug if available, otherwise slugify the title
                String slug = manualSlugs.getOrDefault(title, title.toLowerCase()
                        .replace(" ", "-")
                        .replace(":", "")
                        .replace("'", "")
                        .replace("\"", "")
                        .replaceAll("[^a-z0-9\\-]", ""));

                String apiUrl = "https://api.rawg.io/api/games/" + slug + "?key=" + apiKey;

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

                    JSONObject game = new JSONObject(response.toString());

                    String description = game.optString("description_raw", null);
                    String ESRB = game.has("esrb_rating") && !game.isNull("esrb_rating")
                            ? game.getJSONObject("esrb_rating").optString("name", null)
                            : null;

                    JSONArray devs = game.optJSONArray("developers");
                    String developer = (devs != null && devs.length() > 0)
                            ? devs.getJSONObject(0).optString("name", null)
                            : null;

                    String website = game.optString("website", null);

                    updateStmt.setString(1, description);
                    updateStmt.setString(2, ESRB);
                    updateStmt.setString(3, developer);
                    updateStmt.setString(4, website);
                    updateStmt.setInt(5, gameID);

                    updateStmt.executeUpdate();
                    System.out.println("Updated: " + title);

                } catch (Exception e) {
                    System.out.println("Failed to update: " + title + " (slug: " + slug + ")");
                    e.printStackTrace();
                }
            }

            updateStmt.close();
            rs.close();
            stmt.close();
            System.out.println("All updates finished.");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
