import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import org.json.JSONArray;
import org.json.JSONObject;

public class FetchRawgGames {
    public static void main(String[] args) {
        try {
            String apiKey = "7ba31eb2771e41cd82d7b985c8c4f489";
            String apiUrl = "https://api.rawg.io/api/games?key=" + apiKey + "&page=1";

            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            BufferedReader in = new BufferedReader(
                    new InputStreamReader(conn.getInputStream())
            );

            StringBuilder response = new StringBuilder();
            String line;
            while ((line = in.readLine()) != null) {
                response.append(line);
            }
            in.close();

            JSONObject json = new JSONObject(response.toString());
            JSONArray games = json.getJSONArray("results");

            for (int i = 0; i < games.length(); i++) {
                JSONObject game = games.getJSONObject(i);

                String title = game.optString("name");
                String releaseDate = game.optString("released");
                String coverArt = game.optString("background_image");

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

                System.out.println("Title: " + title);
                System.out.println("Release Date: " + releaseDate);
                System.out.println("Genres: " + genreText);
                System.out.println("Platforms: " + platformText);
                System.out.println("Cover Art: " + coverArt);
                System.out.println("----------------------");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
