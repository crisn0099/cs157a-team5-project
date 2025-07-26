import java.io.BufferedReader; 
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.*;
import org.json.JSONArray;
import org.json.JSONObject;

public class InsertGamesToDB {
    public static void main(String[] args) {
        String apiKey = "7ba31eb2771e41cd82d7b985c8c4f489";
        String apiUrl = "https://api.rawg.io/api/games?key=" + apiKey + "&page=1";

        String jdbcUrl = "jdbc:mysql://localhost:3306/games_for_me?autoReconnect=true&useSSL=false";
        String dbUser = "root";
        String dbPass = "dbPassword";

        try (
            Connection conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPass)
        ) {
            Class.forName("com.mysql.cj.jdbc.Driver");

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

            JSONObject json = new JSONObject(response.toString());
            JSONArray games = json.getJSONArray("results");

            String sql = "INSERT INTO Game (title, releaseDate, genre, platform, coverArt, officialURL) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);

            for (int i = 0; i < games.length(); i++) {
                JSONObject game = games.getJSONObject(i);

                String title = game.optString("name");
                String releaseDate = game.optString("released"); // format: yyyy-MM-dd
                String coverArt = game.optString("background_image");
                String officialURL = game.optString("website");

                JSONArray genres = game.getJSONArray("genres");
                StringBuilder genreText = new StringBuilder();
                for (int j = 0; j < genres.length(); j++) {
                    genreText.append(genres.getJSONObject(j).getString("name"));
                    if (j < genres.length() - 1) genreText.append(", ");
                }

                JSONArray platforms = game.getJSONArray("platforms");
                StringBuilder platformText = new StringBuilder();
                for (int j = 0; j < platforms.length(); j++) {
                    platformText.append(platforms.getJSONObject(j).getJSONObject("platform").getString("name"));
                    if (j < platforms.length() - 1) platformText.append(", ");
                }

                pstmt.setString(1, title);
                pstmt.setString(2, releaseDate.equals("") ? null : releaseDate);
                pstmt.setString(3, genreText.toString());
                pstmt.setString(4, platformText.toString());
                pstmt.setString(5, coverArt);
                pstmt.setString(6, officialURL);

                pstmt.executeUpdate();
                System.out.println("Inserted: " + title);
            }

            pstmt.close();
            System.out.println("All games inserted successfully!");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
